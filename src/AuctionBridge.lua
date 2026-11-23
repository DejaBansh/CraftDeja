-- SPDX-License-Identifier: MIT
local _,app=...
local function clock()return app.try(GetTime)or app.try(time)or 0 end
local words={en={auto_scan_button='Refresh prices',step_open_profession='Open your profession once so CraftDeja can read your recipes and skill.',step_auto_scanning='Full scan in progress. Wait for the results; your shopping plan will update automatically.',step_auto_scan='Prices are being refreshed automatically. Keep the auction house open.',step_auto_busy='Finish or close the Auctionator purchase dialog. The automatic scan will start afterwards.',step_auto_cooldown='Waiting for the auction-house scan cooldown. CraftDeja will retry automatically.',step_auto_unsupported='Automatic scan unavailable with this Auctionator version. Use its Scan button.',step_learn='Learn %s first. Open the recipe details to find its source.',ah_quantity_mismatch='Auctionator has not accepted the planned quantity or total. Purchase locked. Reload the offers.',ah_quantity_help='CraftDeja fills the planned quantity. Check the price and confirm the purchase yourself.'},de={auto_scan_button='Preise aktualisieren',step_open_profession='Öffne deinen Beruf einmal, damit CraftDeja Rezepte und Skill einlesen kann.',step_auto_scanning='Vollscan läuft. Warte auf das Ergebnis; dein Einkaufsplan wird danach automatisch aktualisiert.',step_auto_scan='Preise werden automatisch aktualisiert. Lass das Auktionshaus geöffnet.',step_auto_busy='Schließe zuerst den Auctionator-Kaufdialog ab. Danach startet der Scan automatisch.',step_auto_cooldown='Warte auf die AH-Scanfreigabe. CraftDeja versucht es automatisch erneut.',step_auto_unsupported='Automatischer Scan mit dieser Auctionator-Version nicht verfügbar. Nutze deren Scan-Knopf.',step_learn='Lerne zuerst %s. Die Rezeptdetails zeigen dir die Herkunft.',ah_quantity_mismatch='Auctionator hat Planmenge oder Gesamtpreis nicht übernommen. Kauf gesperrt. Angebote neu laden.',ah_quantity_help='CraftDeja trägt die Planmenge ein. Prüfe den Preis und bestätige den Kauf selbst.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
function app.autoScanTick(force)
    local s=app.shopping
    if not s.open or not app.active or s.started or s.pendingScan or app.shoppingFresh()then return false end
    if not force and clock()<(s.autoAfter or 0)then return false end
    s.autoAfter=clock()+5
    local a=Auctionator;local state=a and a.State
    if not state or not app.bindShopping()then s.autoReason='step_auto_unsupported';return false end
    local buyer=state.BuyCommodityFrameRef or AuctionatorBuyCommodityFrame
    if (buyer and app.try(buyer.IsVisible or buyer.IsShown,buyer))or app.ahOrder and app.ahOrder.pending then s.autoReason='step_auto_busy';return false end
    if app.try(InCombatLockdown)or app.try(C_AuctionHouse and C_AuctionHouse.IsThrottledMessageSystemReady)==false then s.autoReason='step_auto_cooldown';return false end
    local full=state.FullScanFrameRef;local summary=state.IncrementalScanFrameRef
    if (full and full.inProgress)or (summary and summary.doingFullScan)then s.autoReason='step_auto_scanning';return false end
    local choice=full
    if summary and a.Config and a.Config.Options and a.Config.Options.REPLICATE_SCAN then
        local replicate=app.try(a.Config.Get,a.Config.Options.REPLICATE_SCAN)
        if replicate==false then choice=summary end
    elseif not full then choice=summary end
    if not choice or type(choice.InitiateScan)~='function'then s.autoReason='step_auto_unsupported';return false end
    if type(choice.CanInitiate)=='function'and app.try(choice.CanInitiate,choice)~=true then s.autoReason='step_auto_cooldown';return false end
    -- Keep the mail lock when refreshing automatically; a new scan is not proof
    -- that previously purchased mail has been collected.
    s.autoCarry={searched=s.searched,sentSummary=s.sentSummary}
    s.autoReason='step_auto_scanning';s.autoAfter=clock()+60
    local ok=pcall(choice.InitiateScan,choice)
    if not ok then s.autoCarry=nil;s.autoReason='step_auto_unsupported';return false end
    return true
end
function app.pauseManagedPurchaseUI()
    local buyer=Auctionator and Auctionator.State and Auctionator.State.BuyCommodityFrameRef or AuctionatorBuyCommodityFrame
    if not buyer or not buyer.craftDejaManagedID then return end
    buyer.selectedQuantity=0;app.try(buyer.UpdateView,buyer)
    local buy=buyer.DetailsContainer and buyer.DetailsContainer.BuyButton
    if buy then app.try(buy.Disable,buy)end
    for _,key in ipairs({'QuantityCheckConfirmationDialog','FinalConfirmationDialog'})do
        local dialog=buyer[key]
        if dialog and dialog.craftDejaQuote then
            dialog.craftDejaQuote=nil
            if dialog.QuantityInput then app.try(dialog.QuantityInput.SetText,dialog.QuantityInput,'')end
        end
    end
    local t=app.purchaseState().transaction
    if t and t.status=='quoted'then t.status='failed';app.purchaseLog('scan_invalidated_quote',t.id,t.quantity)end
end
function app.observeCommodityResults(id)
    if not app.shoppingFresh()or type(id)~='number'then return false end
    local api=C_AuctionHouse
    local count=api and app.try(api.GetNumCommoditySearchResults,id)
    if type(count)~='number'or count<0 or type(api.GetCommoditySearchResultInfo)~='function'then return false end
    local minimum
    local routeLevels=app.currentRouteOrder and app.currentRouteOrder()and {}or nil
    for i=1,count do
        local info=app.try(api.GetCommoditySearchResultInfo,id,i)
        if type(info)=='table'and type(info.unitPrice)=='number'and info.unitPrice>0 and (info.quantity or 0)>0 then
            minimum=math.min(minimum or info.unitPrice,info.unitPrice)
            if routeLevels then routeLevels[#routeLevels+1]={unit=info.unitPrice,quantity=info.quantity}end
        end
    end
    if routeLevels then app.observeRouteDepth(id,routeLevels)end
    if minimum and app.updateLiveAHPrice(id,minimum,'commodity_event')then app.requestMarketRefresh();return true end
    return false
end
function app.setAHOrder(plan)
    app.ensurePurchaseBatch(plan);app.bindAuctionBuying()
end
local function rowFor(id)
    local order=app.ahOrder
    if not app.shoppingFresh()or not order or clock()-order.created>1800 then return end
    return order.rows[id],order
end
function app.prefillAHQuantity(dialog,details)
    if type(details)~='table'then return false end
    local row= rowFor(details.itemID)
    local n,total=details.quantity,details.total
    if not row or type(n)~='number'or n<1 or n~=math.floor(n)or n>row.remaining or type(total)~='number'or total<0 or total>row.ceiling*n+.000001 then return false end
    if not dialog.QuantityInput then return false end
    local ok=pcall(dialog.QuantityInput.SetText,dialog.QuantityInput,tostring(n))
    if ok then app.try(dialog.QuantityInput.ClearFocus,dialog.QuantityInput)end
    return ok
end
function app.bindAuctionBuying()
    if type(hooksecurefunc)~='function'then return end
    local a=Auctionator;local buyer=a and a.State and a.State.BuyCommodityFrameRef or AuctionatorBuyCommodityFrame
    if not buyer then return end
    if not buyer.craftDejaUpdateHook and type(buyer.UpdateView)=='function'then
        buyer.craftDejaUpdateHook=true
        hooksecurefunc(buyer,'UpdateView',function(self)
            if self.craftDejaManagedID and self.selectedQuantity==0 then
                local button=self.DetailsContainer and self.DetailsContainer.BuyButton
                if button then app.try(button.Disable,button)end
            end
        end)
    end
    if not buyer.craftDejaQuantityHook and type(buyer.ReceiveEvent)=='function'then
        buyer.craftDejaQuantityHook=true
        hooksecurefunc(buyer,'ReceiveEvent',function(self,event,row)
            if not a.Buying or not a.Buying.Events or event~=a.Buying.Events.ShowCommodityBuy or type(row)~='table'or not row.itemKey then return end
            local r=rowFor(row.itemKey.itemID)
            if r then
                self.craftDejaManagedID=row.itemKey.itemID
                self.craftDejaQuantityItem=nil -- a newly opened offer may receive one initial prefill
                self.selectedQuantity=math.min(r.remaining,self.maxQuantity or r.remaining)
                app.try(self.UpdateView,self)
            end
        end)
    end
    if not buyer.craftDejaLiveHook and type(buyer.OnEvent)=='function'then
        buyer.craftDejaLiveHook=true
        hooksecurefunc(buyer,'OnEvent',function(self,event,id)
            if event=='COMMODITY_SEARCH_RESULTS_UPDATED'and id==self.expectedItemID then app.updateLiveCommodity(id,self.results)end
        end)
    end
    for _,key in ipairs({'QuantityCheckConfirmationDialog','FinalConfirmationDialog'})do
        local d=buyer[key]
        if d and not d.craftDejaQuantityHook and type(d.SetDetails)=='function'and type(d.ConfirmPurchase)=='function'then
            d.craftDejaQuantityHook=true
            hooksecurefunc(d,'SetDetails',function(self,details)
                self.craftDejaQuote=nil
                if type(details)~='table'then return end
                app.flowLog('ah.quote',{item=details.itemID,quantity=details.quantity,cost=details.total})
                if details.quantity and details.quantity>0 and details.total and details.total>0 then
                    if app.updateLiveAHPrice(details.itemID,details.total/details.quantity,'quote')then app.refresh(false)end
                end
                local livePlan=app.shoppingPlan()
                if livePlan and app.ahOrder then
                    for _,r in ipairs(livePlan.rows)do local previous=app.ahOrder.rows[r.id];if previous then previous.ceiling=r.maxUnit end end
                end
                local t=app.observeAHQuote(self,details)
                if t then app.prefillAHQuantity(self,details)end
            end)
            hooksecurefunc(d,'ConfirmPurchase',function(self)app.markAHConfirm(self)end)

        end
    end
end
app.words.en.step_ah_visit='Go to the auction house. CraftDeja will scan automatically, then prepare the missing material quantities.'
app.words.en.step_ah_here='Click Search AH. Review the offers and confirm purchases; CraftDeja fills the planned commodity quantity.'
app.words.de.step_ah_visit='Gehe zum Auktionshaus. CraftDeja scannt automatisch und bereitet danach die fehlenden Materialmengen vor.'
app.words.de.step_ah_here='Klicke AH durchsuchen. Prüfe die Angebote und bestätige die Käufe; CraftDeja trägt die geplante Reagenzienmenge ein.'

-- Confirmed-mail bookkeeping is separate from a submitted search. In Forever,
-- COMMODITY_PURCHASED carries itemID/quantity; generic success carries neither.
local function bagCount(id)return app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)end
local function mailLedger()
    if not app.character then return {}end
    app.character.ahMail=app.character.ahMail or {};return app.character.ahMail
end
function app.confirmedMail(id)
    local entry=mailLedger()[id];return type(entry)=='table'and math.max(0,tonumber(entry.quantity)or 0)or 0
end
function app.ahMailPoll()
    for id,entry in pairs(mailLedger())do
        local n=bagCount(id)
        if type(n)=='number'then
            if entry.bags then
                local increase=math.max(0,n-entry.bags)
                local age=entry.receiptClock and clock()-entry.receiptClock
                local direct=age and age>=0 and age<2 and (entry.directAllowance or 0)or 0
                local received=app.mailOpen and increase or math.min(increase,direct)
                entry.quantity=math.max(0,entry.quantity-received)
                entry.directAllowance=math.max(0,(entry.directAllowance or 0)-received)
            end
            entry.bags=n
            if entry.quantity<=0 then mailLedger()[id]=nil end
        end
    end
end
function app.addConfirmedMaterial(id,quantity,row)
    local nowBags=bagCount(id)
    local delivered=type(nowBags)=='number'and row and type(row.bags)=='number'and math.min(quantity,math.max(0,nowBags-row.bags))or 0
    if row then row.bags=nowBags end
    local ledger=mailLedger();local entry=ledger[id]or {quantity=0}
    local age=entry.receiptClock and clock()-entry.receiptClock
    if not age or age<0 or age>=2 then entry.directAllowance=0 end
    entry.quantity=entry.quantity+quantity-delivered;entry.bags=nowBags
    entry.directAllowance=(entry.directAllowance or 0)+quantity-delivered;entry.receiptClock=clock();ledger[id]=entry
end
function app.ahBuyingEvent(event,id,quantity)
    if event=='COMMODITY_PURCHASED'or event=='COMMODITY_PURCHASE_SUCCEEDED'or event=='COMMODITY_PURCHASE_FAILED'then app.purchaseSignal(event,id,quantity)
    elseif event=='AUCTION_HOUSE_CLOSED'then app.ahOrder=nil
    elseif event=='MAIL_SHOW'then app.ahMailPoll();app.mailOpen=true
    elseif event=='MAIL_CLOSED'then app.ahMailPoll();app.mailOpen=false
    elseif event=='BAG_UPDATE_DELAYED'then app.ahMailPoll()end
end
local function nextMissing(plan)
    for _,r in ipairs(plan and plan.rows or {})do
        if not r.vendor then
            local n=app.purchaseBudget(plan,r.id,math.max(0,(r.buy or 0)-app.confirmedMail(r.id)))
            if n>0 then return r,n end
        end
    end
end
local function commodityBuyer()
    return Auctionator and Auctionator.State and Auctionator.State.BuyCommodityFrameRef or AuctionatorBuyCommodityFrame
end
-- Auctionator 344 uses DetailsContainer.Quantity (not the confirmation's
-- QuantityInput). Read back both the native model and its displayed input after
-- UpdateView: OnTextChanged may clamp the requested amount to available stock.
function app.applyNativeAHQuantity(buyer,id,quantity,cost)
    if not app.shoppingFresh()or not buyer or buyer.expectedItemID~=id then return false end
    local input=buyer.DetailsContainer and buyer.DetailsContainer.Quantity
    local displayed=input and tonumber(app.try(input.GetText,input))or nil
    local ok=true
    -- Status polls are read-only when the native quantity already agrees.
    if buyer.selectedQuantity~=quantity or input and displayed~=quantity then
        buyer.selectedQuantity=quantity
        ok=type(buyer.UpdateView)=='function'and pcall(buyer.UpdateView,buyer)
        displayed=input and tonumber(app.try(input.GetText,input))or nil
    end
    local accepted=ok and buyer.selectedQuantity==quantity and (not input or displayed==quantity)
    if accepted and type(buyer.GetPrices)=='function'then
        local priced,_,total=pcall(buyer.GetPrices,buyer)
        accepted=priced and total==cost
    end
    local signature=table.concat({id,quantity,tostring(buyer.selectedQuantity),tostring(displayed),tostring(cost),tostring(accepted)},':')
    if signature~=buyer.craftDejaQuantityCheck then
        buyer.craftDejaQuantityCheck=signature
        app.flowLog('ah.quantity.check',{item=id,requested=quantity,selected=buyer.selectedQuantity or 0,displayed=displayed or '-',cost=cost,ok=accepted or false})
    end
    if not accepted then
        local button=buyer.DetailsContainer and buyer.DetailsContainer.BuyButton
        if button then app.try(button.Disable,button)end
    end
    return accepted
end
function app.ahBuyStatus(plan)
    if not app.shoppingFresh()then return {phase='ah_scan',disabled=true,body=app.scanWaitText(),button=app.caption('scan_locked_button')}end
    local pending=app.purchasePending()
    if pending then return {phase='ah_wait',id=pending.id,quantity=pending.quantity,body=app.caption(pending.status=='uncertain'and 'ah_uncertain_body'or 'ah_pending_body'),button=app.caption(pending.status=='uncertain'and 'ah_diagnose_button'or 'ah_wait_button'),disabled=pending.status~='uncertain'}end
    if plan and plan.scanSerial and plan.scanSerial~=app.shopping.scanSerial then return {phase='ah_wait',disabled=true,body=app.caption('action_changed'),button=app.caption('ah_check_dialog_button')}end
    local row,n=nextMissing(plan)
    if not row then return {phase='ah_done',body=app.caption('ah_batch_done'),button=app.caption('ah_diagnose_button')}end
    local offer={id=row.id,quantity=n,phase='ah_load',body=app.caption('ah_load_body',n,row.name),button=app.caption('ah_load_button')}
    local buyer=commodityBuyer()
    if not buyer or not app.try(buyer.IsVisible or buyer.IsShown,buyer)or buyer.expectedItemID~=row.id then return offer end
    for _,key in ipairs({'QuantityCheckConfirmationDialog','FinalConfirmationDialog'})do
        local dialog=buyer[key]
        if dialog and app.try(dialog.IsShown,dialog)then
            local q=dialog.craftDejaQuote
            if q and q.scanSerial==app.shopping.scanSerial and q.id==row.id and q.quantity<=n and q.cost and q.cost<=q.quantity*row.maxUnit+.000001 then
                offer.phase='ah_confirm';offer.quantity=q.quantity;offer.cost=q.cost
                offer.body=app.caption('ah_confirm_body',q.quantity,row.name,app.money(q.cost));offer.button=app.caption('ah_confirm_button',app.money(q.cost))
            else offer.phase='ah_wait';offer.disabled=true;offer.body=app.caption('ah_check_dialog');offer.button=app.caption('ah_check_dialog_button')end
            return offer
        end
    end
    if buyer.WidePriceRangeWarningDialog and app.try(buyer.WidePriceRangeWarningDialog.IsShown,buyer.WidePriceRangeWarningDialog)then offer.phase='ah_wait';offer.disabled=true;offer.body=app.caption('ah_check_dialog');offer.button=app.caption('ah_check_dialog_button');return offer end
    if buyer.waitingForPurchase then offer.phase='ah_wait';offer.disabled=true;offer.body=app.caption('ah_wait_quote');offer.button=app.caption('ah_wait_button');return offer end
    if type(buyer.results)~='table'or #buyer.results==0 then return offer end
    local wanted=n
    if buyer.craftDejaQuantityItem==row.id then
        local input=buyer.DetailsContainer and buyer.DetailsContainer.Quantity
        local raw=input and app.try(input.GetText,input)
        local selected=buyer.selectedQuantity
        -- An empty field is a normal intermediate state while typing. Never
        -- replace it, round a fractional edit, or silently buy more than shown.
        if type(selected)~='number'or selected<1 or selected~=math.floor(selected)or selected>n
            or input and tonumber(raw)~=selected then
            offer.phase='ah_wait';offer.disabled=true;offer.body=app.caption('ah_quantity_mismatch');offer.button=app.caption('ah_check_dialog_button');return offer
        end
        wanted=selected
    end
    local left,total=wanted,0
    for _,level in ipairs(buyer.results)do
        if type(level.price)~='number'or type(level.quantity)~='number'or level.price>row.maxUnit+.000001 then break end
        local take=math.min(left,math.max(0,level.quantity));total=total+take*level.price;left=left-take
        if left<=0 then break end
    end
    offer.quantity=wanted-left
    if buyer.craftDejaQuantityItem==row.id and left>0 then
        offer.phase='ah_wait';offer.disabled=true;offer.body=app.caption('ah_no_affordable');offer.button=app.caption('ah_check_dialog_button');return offer
    end
    if offer.quantity<1 then offer.body=app.caption('ah_no_affordable');return offer end
    if not app.applyNativeAHQuantity(buyer,row.id,offer.quantity,total)then
        offer.phase='ah_wait';offer.disabled=true;offer.body=app.caption('ah_quantity_mismatch');offer.button=app.caption('ah_check_dialog_button');return offer
    end
    buyer.craftDejaQuantityItem=row.id
    offer.phase='ah_buy';offer.cost=total;offer.body=app.caption('ah_ready_body',offer.quantity,row.name,app.money(total))
    offer.button=app.caption('ah_buy_button',offer.quantity,app.money(total));return offer
end
function app.performAHBuy(shownPlan,shownOffer)
    if shownOffer and shownOffer.phase=='ah_done'then app.showPurchaseDiagnostic();return false end
    if app.purchasePending()then
        if app.purchasePending().status=='uncertain'then app.showPurchaseDiagnostic()else app.actionNotice=app.caption('ah_pending_body');app.refreshNextStep()end
        return false
    end
    if not app.shoppingFresh()then return app.blockShoppingAction()end
    app.ahMailPoll();app.refresh(false)
    local plan
    if shownPlan and shownPlan.recipePurchase then plan=app.currentRecipeAHPlan(shownPlan.recipePurchase)
    else plan=app.shoppingPlan() end
    if not plan or not shownPlan or plan.scanSerial~=shownPlan.scanSerial or app.purchaseKey(plan)~=app.purchaseKey(shownPlan) then app.actionNotice=app.caption('action_changed');app.refreshNextStep();return false end
    local row,n=nextMissing(plan);if not row then app.refreshNextStep();return false end
    local order=app.ahOrder
    app.setAHOrder(plan)
    local offer=app.ahBuyStatus(plan);local buyer=commodityBuyer()
    if buyer then buyer.craftDejaManagedID=offer.id end
    if offer.phase=='ah_confirm'then
        if not shownOffer or shownOffer.phase~=offer.phase or shownOffer.id~=offer.id or shownOffer.quantity~=offer.quantity or shownOffer.cost~=offer.cost then app.actionNotice=app.caption('action_changed');app.refreshNextStep();return false end
        for _,key in ipairs({'QuantityCheckConfirmationDialog','FinalConfirmationDialog'})do
            local d=buyer and buyer[key];local q=d and d.craftDejaQuote
            if d and app.try(d.IsShown,d)and q and q.id==offer.id and q.quantity==offer.quantity and q.cost==offer.cost then
                if d.QuantityInput and not app.prefillAHQuantity(d,{itemID=q.id,quantity=q.quantity,total=q.cost})then return false end
                -- Explicit click only. Bookkeeping waits for COMMODITY_PURCHASED.
                if not app.markAHConfirm(d)then return false end
                app.flowLog('api.ah.confirm.request',{item=q.id,quantity=q.quantity,cost=q.cost})
                local ok,err=pcall(d.ConfirmPurchase,d);app.flowLog('api.ah.confirm.result',{ok=ok,result=tostring(err)});if not ok then app.purchaseState().transaction.status='uncertain'end;app.refreshNextStep();return ok
            end
        end
        return false
    elseif offer.phase=='ah_buy'then
        if not shownOffer or shownOffer.phase~=offer.phase or shownOffer.id~=offer.id or shownOffer.quantity~=offer.quantity or shownOffer.cost~=offer.cost then app.actionNotice=app.caption('action_changed');app.refreshNextStep();return false end
        if type(app.try(GetMoney))~='number'or app.try(GetMoney)<offer.cost then app.actionNotice=app.caption('vendor_buy_gold');return false end
        if not app.applyNativeAHQuantity(buyer,offer.id,offer.quantity,offer.cost)then
            app.actionNotice=app.caption('ah_quantity_mismatch');app.refreshNextStep();return false
        end
        if type(buyer.BuyClicked)~='function'then return false end
        app.flowLog('api.ah.quote_request',{item=offer.id,quantity=offer.quantity,cost=offer.cost})
        local ok,err=pcall(buyer.BuyClicked,buyer);app.flowLog('api.ah.quote_result',{ok=ok,result=tostring(err)});app.refreshNextStep();return ok
    elseif offer.phase=='ah_wait'or offer.phase=='ah_done'then app.showPurchaseDiagnostic();return false end
    local tab=AuctionatorTabs_Shopping
    if tab and type(tab.Click)=='function'then
        local ok,err=pcall(tab.Click,tab);app.flowLog('api.ah.show_shopping',{ok=ok,result=tostring(err)})
        if not ok then app.actionNotice=app.caption('ah_select_native');app.refreshNextStep();return false end
    end
    local a=Auctionator;local bus=a and a.EventBus
    local key=app.try(C_AuctionHouse and C_AuctionHouse.MakeItemKey,row.id)
    local info=key and app.try(C_AuctionHouse and C_AuctionHouse.GetItemKeyInfo,key)
    app.flowLog('ah.load.check',{item=row.id,quantity=n,hasKey=key~=nil,hasInfo=info~=nil,isCommodity=info and info.isCommodity or false,hasBuyer=buyer~=nil,hasBus=bus~=nil,hasEvents=a and a.Buying and a.Buying.Events~=nil or false})
    if not key or not info or not info.isCommodity or not buyer or not bus or type(bus.Fire)~='function'or not a.Buying or not a.Buying.Events then
        app.actionNotice=app.caption('ah_select_native');app.refreshNextStep();return false
    end
    -- Same event as clicking Auctionator's result row; only loads offers.
    app.try(bus.RegisterSource,bus,app,'CraftDeja')
    local ok,err=pcall(bus.Fire,bus,app,a.Buying.Events.ShowCommodityBuy,{itemKey=key,purchaseQuantity=n},info)
    app.flowLog('api.ah.load.result',{item=row.id,quantity=n,ok=ok,result=tostring(err),expected=buyer.expectedItemID or 0,shown=app.try(buyer.IsShown,buyer)or false,visible=app.try(buyer.IsVisible or buyer.IsShown,buyer)or false})
    app.try(bus.UnregisterSource,bus,app)
    app.refreshNextStep();return ok
end

function app.syncNativePurchaseQuantity(id)
    local buyer=commodityBuyer();local b=app.purchaseState().batch;local row=b and b.rows[id]
    if buyer and buyer.craftDejaManagedID==id and buyer.expectedItemID==id and row then
        buyer.craftDejaQuantityItem=nil
        buyer.selectedQuantity=app.shoppingFresh()and math.min(row.remaining,buyer.maxQuantity or row.remaining)or 0
        app.try(buyer.UpdateView,buyer)
    end
end
