-- SPDX-License-Identifier: MIT
local _,app=...
local frame=CreateFrame('Frame');frame:Hide();app.bankTransferFrame=frame
local function now()return app.try(GetTime)or 0 end
local words={de={bank_deposit='Bankmaterialien einlagern',bank_withdraw='Bankmaterialien entnehmen',bank_closed='Persönliche Bank öffnen; danach die Materialverschiebung starten.',bank_full='Bank voll. Platz schaffen; offen: %s',bank_bags_full='Taschen voll. Platz schaffen; offen: %s',bank_wait='Verschiebung wird anhand beider Bestände geprüft. Noch offen: %s',bank_unconfirmed='Verschiebung unbestätigt. Keine Wiederholung ohne Bestandsbeleg. Bank erneut öffnen und prüfen: %s',bank_rejected='Verschiebung abgelehnt oder weiterer Nutzerklick erforderlich. Erneut klicken oder manuell verschieben: %s',bank_cursor='Cursor belegt. Gegenstand zuerst selbst ablegen. Offen: %s',bank_locked='Gegenstände gesperrt oder Daten noch nicht bereit. Offen: %s',bank_access='Passende persönliche Bank nicht verfügbar. Persönliche Bank öffnen.',bank_continue='Platz prüfen / fortsetzen'},en={bank_deposit='Deposit planned supplies',bank_withdraw='Withdraw required supplies',bank_closed='Open your personal bank, then start the transfer.',bank_full='Bank full. Make room; remaining: %s',bank_bags_full='Bags full. Make room; remaining: %s',bank_wait='Checking both inventories for confirmation. Remaining: %s',bank_unconfirmed='Transfer unconfirmed. No duplicate retry without evidence. Reopen the bank and check: %s',bank_rejected='Transfer rejected or another player click required. Click again or move manually: %s',bank_cursor='Cursor occupied. Put the item down first. Remaining: %s',bank_locked='Items locked or data not ready. Remaining: %s',bank_access='Suitable personal bank unavailable. Open the personal bank.',bank_continue='Check space / continue'}}
for lang,t in pairs(words)do for k,v in pairs(t)do app.words[lang][k]=v end end
local function state()
    if not app.character then return end
    app.character.bankTransfer=app.character.bankTransfer or {}
    return app.character.bankTransfer
end
local function api(name)return C_Container and C_Container[name]or _G[name]end
local function carriedLast()
    return (NUM_BAG_SLOTS or 4)+(Constants and Constants.InventoryConstants and Constants.InventoryConstants.NumReagentBagSlots or 0)
end
local function containers()
    if not app.inventoryState.bankOpen then return nil,'bank_closed'end
    local kind=Enum and Enum.BankType and Enum.BankType.Character
    if C_Bank and type(C_Bank.CanUseBank)=='function'and app.try(C_Bank.CanUseBank,kind)~=true then return nil,'bank_access'end
    local bags,bank,seen={},{},{}
    local function add(list,id)
        if type(id)~='number'or seen[id]then return end
        local slots=app.try(api('GetContainerNumSlots'),id)
        if type(slots)=='number'and slots>0 and slots<=200 then seen[id]=true;list[#list+1]={id=id,slots=slots}end
    end
    for id=0,carriedLast()do add(bags,id)end
    local tabs=app.try(C_Bank and C_Bank.FetchPurchasedBankTabData,kind)
    if type(tabs)=='table'and #tabs>0 then
        for _,tab in ipairs(tabs)do if type(tab.ID)=='number'and tab.ID>carriedLast()then add(bank,tab.ID)end end
    else
        add(bank,BANK_CONTAINER or -1)
        local n=Constants and Constants.InventoryConstants and Constants.InventoryConstants.NumCharacterBankSlots or NUM_BANKBAGSLOTS or 7
        for id=carriedLast()+1,carriedLast()+math.min(20,n)do add(bank,id)end
    end
    if #bank==0 then return nil,'bank_access'end
    return {bags=bags,bank=bank}
end
local function info(bag,slot)
    local value=app.try(api('GetContainerItemInfo'),bag,slot)
    if type(value)=='table'then return value end
    local id=app.try(api('GetContainerItemID'),bag,slot)
    if id then return {itemID=id,isLocked=true,stackCount=0}end -- unknown never means free
end
local function total(list,item)
    local n=0
    for _,bag in ipairs(list)do for slot=1,bag.slots do local v=info(bag.id,slot);if v and v.itemID==item then n=n+(v.stackCount or 0)end end end
    return n
end
function app.bankWithdrawalRows()
    local order=app.currentRouteOrder();local d=app.pinnedRouteDecision()
    if not order or order.owner~=app.characterKey or not d or app.routeDirty or app.routeSearch or app.craftRefreshBusy()or app.nativeCraftHandoff or app.purchasePending()then return {}end
    local plan=app.materialPlan(d.current.recipe,d.stop);local rows={}
    for _,r in ipairs(plan and plan.rows or {})do
        local loc=app.inventoryFor(r.id)
        local n=loc and math.floor(math.min(math.max(0,r.total-(loc.bags or 0)),math.max(0,loc.bank or 0)))or 0
        if n>0 then rows[#rows+1]={item=r.id,quantity=n}end
    end
    table.sort(rows,function(a,b)return a.item<b.item end);return rows
end
local function demand(mode)return mode=='withdraw'and app.bankWithdrawalRows()or app.routeBankRows()end
local function remaining(s)
    local lines={}
    for id,n in pairs(s.left or {})do if n>0 then lines[#lines+1]=n..' x '..app.itemName(id)end end
    table.sort(lines);return table.concat(lines,', ')
end
local function refresh()
    if app.refreshNextStep then app.refreshNextStep(true)end
end
local function confirm(s,c)
    local p=s.pending;if not p then return true end
    if not c then return false end
    local from=s.mode=='withdraw'and c.bank or c.bags
    local to=s.mode=='withdraw'and c.bags or c.bank
    if p.beforeFrom-total(from,p.item)>=p.quantity and total(to,p.item)-p.beforeTo>=p.quantity then
        s.left[p.item]=math.max(0,(s.left[p.item]or 0)-p.quantity);s.pending=nil;s.status='ready'
        app.flowLog('bank.confirmed',{item=p.item,quantity=p.quantity,mode=s.mode})
        if app.craftRefreshBusy()then app.inventoryState.dirty=true else app.captureInventory()end
        return true
    end
    if now()-p.at>5 then s.status='bank_unconfirmed';frame:Hide()else s.status='bank_wait'end
    return false
end
local function compatible(bag,item)
    local _,family=app.try(api('GetContainerNumFreeSlots'),bag)
    if family==0 or bag==(BANK_CONTAINER or -1)then return true end
    local itemFamily=app.try(C_Item and C_Item.GetItemFamily or GetItemFamily,item)
    if type(family)~='number'or type(itemFamily)~='number'then return nil end
    local band=bit and bit.band or bit32 and bit32.band
    return band and band(family,itemFamily)~=0 or false
end
local function destination(list,item,maxStack,sourceLink)
    local empty,uncertain
    for _,bag in ipairs(list)do
        for slot=1,bag.slots do
            local v=info(bag.id,slot)
            if v and v.itemID==item and (not sourceLink or not v.hyperlink or v.hyperlink==sourceLink)and (v.stackCount or 0)<maxStack then
                if v.isLocked then uncertain=true else return {bag=bag.id,slot=slot,space=maxStack-(v.stackCount or 0)}end
            elseif not v then
                local allowed=compatible(bag.id,item)
                if allowed and not empty then empty={bag=bag.id,slot=slot,space=maxStack}elseif allowed==nil then uncertain=true end
            end
        end
    end
    return empty,uncertain
end
function app.bankTransferTick()
    local s=state();if not s or s.dispatching or not s.order then return end
    local c,why=containers()
    if not c then s.status=why;s.armed=false;frame:Hide();return end
    if s.status=='bank_closed'then s.status='ready'end
    if not confirm(s,c)then return end
    local order=app.currentRouteOrder()
    if not order or order.id~=s.order or not order.active then s.armed=false;s.status='cancelled';frame:Hide();return end
    if app.craftRefreshBusy()or app.purchasePending()or app.nativeCraftHandoff then return end
    if not s.armed then frame:Hide();return end
    if app.try(InCombatLockdown)then s.status='bank_rejected';s.armed=false;frame:Hide();return end
    if app.try(GetCursorInfo)~=nil then s.status='bank_cursor';s.armed=false;frame:Hide();return end
    local wants={};for _,r in ipairs(demand(s.mode))do wants[r.item]=r.quantity end
    local ids={}
    for id,left in pairs(s.left)do if math.min(left,wants[id]or 0)>0 then ids[#ids+1]=id end end
    table.sort(ids)
    if #ids==0 then s.status='done';s.armed=false;frame:Hide();refresh();return end
    local from=s.mode=='withdraw'and c.bank or c.bags;local to=s.mode=='withdraw'and c.bags or c.bank
    local item,quantity,source,target,unknown
    for _,id in ipairs(ids)do
        local candidate
        for _,bag in ipairs(from)do for slot=1,bag.slots do local v=info(bag.id,slot)
            if v and v.itemID==id and (v.stackCount or 0)>0 and not v.isLocked and not candidate then candidate={bag=bag.id,slot=slot,count=v.stackCount,link=v.hyperlink}end
        end end
        local values={app.try(C_Item and C_Item.GetItemInfo or GetItemInfo,id)};local maxStack=values[8]
        if not candidate or type(maxStack)~='number'or maxStack<1 then unknown=true
        else
            local dest,uncertain=destination(to,id,maxStack,candidate.link)
            unknown=unknown or uncertain
            if dest then item=id;quantity=math.min(s.left[id],wants[id],candidate.count,dest.space);source=candidate;target=dest;break end
        end
    end
    if not target then s.status=unknown and 'bank_locked'or s.mode=='withdraw'and 'bank_bags_full'or 'bank_full';frame:Hide();refresh();return end
    local p={item=item,quantity=quantity,beforeFrom=total(from,item),beforeTo=total(to,item),at=now(),source=source,target=target}
    local targetBefore=info(target.bag,target.slot)
    s.pending=p;s.status='bank_wait';s.dispatching=true
    local pickup=api('PickupContainerItem');local split=api('SplitContainerItem')
    local ok=pcall(function()
        if quantity<source.count then assert(type(split)=='function','split unavailable');assert(split(source.bag,source.slot,quantity)~=false)
        else assert(type(pickup)=='function','pickup unavailable');assert(pickup(source.bag,source.slot)~=false)end
        local kind,id=app.try(GetCursorInfo);assert(kind=='item'and id==item,'pickup rejected')
        local current=info(target.bag,target.slot)
        assert(not targetBefore and not current or targetBefore and current and not current.isLocked and current.itemID==targetBefore.itemID and current.stackCount==targetBefore.stackCount,'destination changed')
        assert(pickup(target.bag,target.slot)~=false,'placement rejected')
        assert(app.try(GetCursorInfo)==nil,'placement not accepted')
    end)
    s.dispatching=false
    if not ok then
        -- Return only the item acquired by this request to its unchanged source.
        local kind,id=app.try(GetCursorInfo);local src=info(source.bag,source.slot)
        if kind=='item'and id==item and (not src or src.itemID==item and src.stackCount==source.count-quantity)then app.try(pickup,source.bag,source.slot)end
        if total(from,item)==p.beforeFrom and total(to,item)==p.beforeTo and app.try(GetCursorInfo)==nil then s.pending=nil end
        s.status='bank_rejected';s.armed=false;frame:Hide();refresh();return
    end
    app.flowLog('bank.request',{item=item,quantity=quantity,mode=s.mode})
    confirm(s,c);frame:Show();refresh()
end
function app.startBankTransfer(mode)
    if mode~='deposit'and mode~='withdraw'then return false end
    local s=state();local order=app.currentRouteOrder();if not s or not order or not order.active or order.owner~=app.characterKey then return false end
    local c,why=containers();if not c then
        if not s.pending then s.order=order.id;s.mode=mode;s.left={};for _,r in ipairs(demand(mode))do s.left[r.item]=r.quantity end end
        s.status=why;refresh();return false
    end
    if s.pending and not confirm(s,c)then refresh();return false end
    s.order=order.id;s.mode=mode;s.left={}
    for _,r in ipairs(demand(mode))do s.left[r.item]=r.quantity end
    s.armed=true;s.status='ready';frame:Show();app.bankTransferTick();return true
end
function app.bankTransferTask(pendingOnly)
    local s=state();local order=app.currentRouteOrder()
    if not order or not order.active or order.owner~=app.characterKey or app.craftRefreshBusy()or app.nativeCraftHandoff or app.purchasePending()then return end
    if s.order==order.id and s.pending then
        return {kind=s.mode=='withdraw'and 'route_bank_withdraw'or 'route_bank',key='bank_pending:'..s.pending.item,body=app.caption(s.status or 'bank_wait',remaining(s))}
    end
    if pendingOnly then return end
    local withdraw=app.bankWithdrawalRows()
    if s.order==order.id and s.mode=='withdraw'and #withdraw>0 and s.status and s.status~='ready'and s.status~='done'then
        return {kind='route_bank_withdraw',key='bank_status:'..s.status,body=app.caption(s.status,remaining(s))}
    end
    if #withdraw>0 then return {kind='route_bank_withdraw',key='bank_withdraw:'..withdraw[1].item,body=app.caption('step_bank',withdraw[1].quantity,app.itemName(withdraw[1].item))}end
    if s.order==order.id and s.status and s.status~='ready'and s.status~='done'and #app.routeBankRows()>0 then
        return {kind='route_bank',key='bank_status:'..s.status,body=app.caption(s.status,remaining(s))}
    end
end
for _,event in ipairs({'BANKFRAME_OPENED','BANKFRAME_CLOSED','BAG_UPDATE_DELAYED','PLAYERBANKSLOTS_CHANGED','BANK_TABS_CHANGED','ITEM_LOCK_CHANGED'})do frame:RegisterEvent(event)end
frame:SetScript('OnEvent',function(_,event)
    local s=state();if not s then return end
    if event=='BANKFRAME_CLOSED'then s.armed=false;if s.order then s.status='bank_closed'end;frame:Hide();refresh()
    elseif s.order then app.bankTransferTick();refresh()end
end)
frame:SetScript('OnUpdate',function()
    local s=state()
    -- Inventory scans are event-driven while a move is in flight. The only
    -- per-frame operation during network delay is this deadline comparison.
    if s and s.pending then
        if now()-s.pending.at>5 then s.status='bank_unconfirmed';frame:Hide();refresh()end
        return
    end
    app.bankTransferTick()
end)
local initialize=app.initialize
app.initialize=function(...)
    initialize(...);local s=state();if s then s.armed=false end;frame:Hide()
end
local task=app.routeTask
app.routeTask=function(plan)
    local t=app.bankTransferTask(true);if t then return t end
    t=task(plan)
    if not t or t.kind=='route_bank'then return app.bankTransferTask()or t end
    return t
end
local action=app.unifiedAction
app.unifiedAction=function(f)
    local t=f.task
    if t and (t.kind=='route_bank'or t.kind=='route_bank_withdraw')then
        if app.inventoryState.bankOpen then app.startBankTransfer(t.kind=='route_bank_withdraw'and 'withdraw'or 'deposit')else app.showRouteWindow()end
        return true
    end
    return action(f)
end
local cta=app.applyGuideCTA
app.applyGuideCTA=function(f,plan)
    cta(f,plan)
    if f.task and (f.task.kind=='route_bank'or f.task.kind=='route_bank_withdraw')and app.inventoryState.bankOpen then
        f.primaryCTA:SetText(app.caption(f.task.kind=='route_bank_withdraw'and 'bank_withdraw'or 'bank_deposit'))
        app.styleCTAButton(f.primaryCTA,true)
    end
end
