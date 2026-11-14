-- SPDX-License-Identifier: MIT
local _,app=...
local function clock()return app.try(GetTime)or app.try(time)or 0 end
function app.purchaseState()
    app.character.ahPurchase=app.character.ahPurchase or {sequence=0,log={}}
    return app.character.ahPurchase
end
function app.purchaseLog(event,id,n)
    app.flowLog('purchase.'..event,{item=id,quantity=n})
    local s=app.purchaseState();s.log=s.log or {}
    s.log[#s.log+1]={at=app.try(time)or 0,event=event,id=id,quantity=n}
    while #s.log>40 do table.remove(s.log,1)end
end
function app.purchaseKey(plan)
    if plan.toolPreparation then return 'rod:'..plan.recipe.profession..':'..plan.jobSerial..':'..plan.recipe.id end
    if plan.production then return 'production:'..plan.recipe.profession..':'..plan.jobSerial..':'..tostring(plan.purchaseSlice or 'whole')end
    if plan.recipe then
        local ids={};for _,r in ipairs(plan.rows)do ids[#ids+1]=r.id end;table.sort(ids)
        return table.concat({plan.recipe.profession or 0,plan.recipe.id,plan.from or 0,plan.target or 0,app.character.craftRevision or 0,table.concat(ids,',')},':')
    end
    local parts={'adhoc'};for _,r in ipairs(plan.rows)do parts[#parts+1]=r.id..':'..r.buy end
    return table.concat(parts,':')
end
function app.purchasePending()
    local t=app.purchaseState().transaction
    return t and (t.status=='pending'or t.status=='uncertain')and t or nil
end
function app.purchaseReserved(id)
    local t=app.purchasePending();return t and t.id==id and math.max(0,t.quantity-(t.applied or 0))or 0
end
function app.initializePurchasing()
    local t=app.purchaseState().transaction
    if t and (t.status=='pending'or t.status=='uncertain')then t.status='uncertain';t.lostContext=true
    elseif t and t.status=='quoted'then t.status='failed'end
end
function app.ensurePurchaseBatch(plan)
    local s=app.purchaseState();local key=app.purchaseKey(plan)
    if app.purchasePending()then return app.ahOrder end
    local b=s.batch
    if not b or b.key~=key then
        b={key=key,rows={},created=clock()};s.batch=b
        for _,r in ipairs(plan.rows)do
            if not r.vendor and r.buy>0 then
                local needed=math.max(0,r.buy-app.confirmedMail(r.id))
                b.rows[r.id]={remaining=needed,initial=needed,purchased=0,ceiling=r.maxUnit,
                    bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,r.id,false,false,false,false)}
            end
        end
        app.purchaseLog('new_plan')
    else
        -- Live prices/inventory may REDUCE this batch; a poll or scan can never
        -- grant again units already purchased for the same skill/craft goal.
        for _,r in ipairs(plan.rows)do
            local old=b.rows[r.id]
            if old then old.remaining=math.min(old.remaining,math.max(0,r.buy-app.confirmedMail(r.id)));old.ceiling=r.maxUnit end
        end
    end
    b.created=clock();app.ahOrder=b;return b
end
function app.purchaseBudget(plan,id,missing)
    local b=app.purchaseState().batch
    if b and b.key==app.purchaseKey(plan)then
        return math.min(missing,b.rows[id]and b.rows[id].remaining or 0)
    end
    return missing
end
function app.newPurchasePlan()
    if app.purchasePending()then app.actionNotice=app.caption('ah_uncertain_body');return false end
    app.purchaseState().batch=nil;app.ahOrder=nil;app.shopping.searched=nil
    local buyer=Auctionator and Auctionator.State and Auctionator.State.BuyCommodityFrameRef or AuctionatorBuyCommodityFrame
    if buyer then buyer.craftDejaManagedID=nil;buyer.craftDejaQuantityItem=nil end
    app.purchaseLog('explicit_unlock');return true
end
function app.observeAHQuote(dialog,details)
    if not app.shoppingFresh()then return nil end
    local b=app.ahOrder;local r=b and b.rows[details.itemID]
    local n,cost=details.quantity,details.total
    if not r or type(n)~='number'or n<1 or n~=math.floor(n)or n>r.remaining or type(cost)~='number'or cost<0 or app.purchasePending()then return nil end
    local s=app.purchaseState();local t=s.transaction
    if not t or t.status~='quoted'or t.scanSerial~=app.shopping.scanSerial or t.id~=details.itemID or t.quantity~=n or t.cost~=cost then
        s.sequence=s.sequence+1;t={nonce=s.sequence,id=details.itemID,quantity=n,cost=cost,status='quoted',applied=0,batch=b.key,scanSerial=app.shopping.scanSerial};s.transaction=t
    end
    app.purchaseDialog=dialog;t.quotedAt=clock();dialog.craftDejaQuote={id=t.id,quantity=n,cost=cost,nonce=t.nonce,scanSerial=t.scanSerial}
    app.purchaseLog('quote',t.id,n);return t
end
local function receipt(t,n,source)
    local s=app.purchaseState();local b=s.batch
    n=math.min(n,t.quantity-(t.applied or 0));if n<=0 then return end
    local r=b and b.rows[t.id]
    if r then r.remaining=math.max(0,r.remaining-n);r.purchased=(r.purchased or 0)+n end
    app.addConfirmedMaterial(t.id,n,r)
    t.applied=(t.applied or 0)+n
    if t.applied>=t.quantity then t.status='succeeded';t.finished=clock()end
    app.purchaseLog(source,t.id,n)
    if app.syncNativePurchaseQuantity then app.syncNativePurchaseQuantity(t.id)end
end
function app.markAHConfirm(dialog)
    if not app.shoppingFresh()then app.flowLog('scan.confirm_blocked',{});return false end
    local q=dialog and dialog.craftDejaQuote;local t=app.purchaseState().transaction
    if not q or not t or q.scanSerial~=app.shopping.scanSerial or q.nonce~=t.nonce or t.status=='succeeded'or t.status=='failed'then return false end
    if dialog.QuantityInput and tonumber(app.try(dialog.QuantityInput.GetText,dialog.QuantityInput))~=t.quantity then return false end
    if t.status=='quoted'then t.status='pending';t.started=clock();app.purchaseLog('confirm_intent',t.id,t.quantity)end
    -- A synchronous generic success may precede the native method's post-hook.
    if t.earlySuccess and clock()-t.earlySuccess<.25 then receipt(t,t.quantity-(t.applied or 0),'success_correlated');t.earlySuccess=nil end
    return true
end
function app.purchaseSignal(event,id,quantity)
    local s=app.purchaseState();local t=s.transaction
    app.purchaseLog(event,id,quantity)
    if event=='COMMODITY_PURCHASE_SUCCEEDED'then
        if t and not t.lostContext and (t.status=='pending'or t.status=='uncertain')then receipt(t,t.quantity-(t.applied or 0),'success_correlated')
        elseif t and t.status=='quoted'then t.earlySuccess=clock()end
    elseif event=='COMMODITY_PURCHASED'and type(quantity)=='number'and quantity>0 and quantity==math.floor(quantity)then
        if t and t.id==id and t.status~='failed'then
            if t.status~='succeeded'then receipt(t,quantity,'success_item')end
        else
            local b=s.batch;local row=b and b.rows[id]
            if row and row.remaining>0 then
                s.sequence=s.sequence+1;t={nonce=s.sequence,id=id,quantity=quantity,status='pending',applied=0,batch=b.key};s.transaction=t
                receipt(t,quantity,'success_item')
            end
        end
    elseif event=='COMMODITY_PURCHASE_FAILED'then
        if t and not t.lostContext and t.status~='succeeded'then t.status='failed';t.earlySuccess=nil end
    end
end
function app.purchasePoll()
    local t=app.purchasePending()
    if t and t.status=='pending'and clock()-(t.started or clock())>8 then t.status='uncertain';app.purchaseLog('missing_receipt',t.id,t.quantity)end
end
function app.noteCompletedCraft(id,guid)
    if not app.active or not app.active.recipes[id]or not app.active.recipes[id].learned then return end
    if guid and guid==app.lastCraftGUID then return end
    app.lastCraftGUID=guid;app.character.craftRevision=(app.character.craftRevision or 0)+1
end
function app.updateLiveAHPrice(id,unit,source)
    if not app.shoppingFresh()or type(unit)~='number'or unit<=0 then return false end
    local s=app.shopping;s.livePrices=s.livePrices or {}
    local previous=s.livePrices[id];local old=previous and previous.unit or s.prices[id]
    s.livePrices[id]={unit=unit,at=clock(),source=source}
    if old~=unit then app.purchaseLog('live_price',id,unit);app.actionNotice=app.caption('ah_live_repriced',app.money(unit));return true end
    return false
end
function app.updateLiveCommodity(id,results)
    local minimum
    for _,r in ipairs(results or {})do if type(r.price)=='number'and r.price>0 and (not minimum or r.price<minimum)then minimum=r.price end end
    if minimum and app.updateLiveAHPrice(id,minimum,'offers')then app.refresh(false)end
end
function app.showPurchaseDiagnostic()
    if not app.purchaseDiagnostic then
        local f=app.createWindow('CraftDejaPurchaseDiagnostic',520,330);app.purchaseDiagnostic=f
        local e=CreateFrame('EditBox',nil,f,'InputBoxTemplate');f.box=e
        e:SetPoint('TOPLEFT',18,-58);e:SetSize(484,250);e:SetMultiLine(true);e:SetAutoFocus(false)
        e:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',10,'')
    end
    local f=app.purchaseDiagnostic;f.title:SetText('CraftDeja - '..app.caption('ah_diagnose_button'))
    local s=app.purchaseState();local t=s.transaction
    local lines={'Version: '..app.release,'Transaction: '..(t and t.status or 'none')}
    if t then lines[#lines+1]='Item '..t.id..' / quantity '..t.quantity..' / receipt '..(t.applied or 0)end
    for id,r in pairs(s.batch and s.batch.rows or {})do lines[#lines+1]='Item '..id..': planned '..r.initial..', bought '..(r.purchased or 0)..', remaining '..r.remaining end
    lines[#lines+1]='Recent events:'
    for i=math.max(1,#(s.log or {})-9),#(s.log or {})do local e=s.log[i];lines[#lines+1]=e.event..' '..tostring(e.id or '')..' '..tostring(e.quantity or '')end
    f.box:SetText(table.concat(lines,'\n'));f:Show();f.box:SetFocus();f.box:HighlightText()
end
