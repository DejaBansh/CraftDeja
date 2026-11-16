-- SPDX-License-Identifier: MIT
local _,app=...
local shop={open=false,epoch=0,points=5,goal="next",tolerance=10,maxAge=1800}
app.shopping=shop
function app.initializeShopping()
    if app.options.autoSkillPlanVersion~=2 then
        app.options.shoppingGoal='next';app.options.autoSkillPlanVersion=2
        if app.character then app.character.orderProgress=nil end
    end
    shop.goal=app.options.shoppingGoal=="manual"and "manual"or "next"
    shop.points=math.max(1,math.min(50,math.floor(tonumber(app.options.shoppingPoints)or 5)))
    app.initializePurchasing()
    local tolerance=tonumber(app.options.shoppingTolerance)
    shop.tolerance=(tolerance==0 or tolerance==5 or tolerance==10 or tolerance==20)and tolerance or 10
end
local function clock()return app.try(GetTime)or app.try(time)or 0 end
local function api()return Auctionator and Auctionator.API and Auctionator.API.v1 end
local function hide()if app.shoppingWindow then app.shoppingWindow:Hide()end end
local function clear()
    local carry=shop.autoCarry
    if app.pauseManagedPurchaseUI then app.pauseManagedPurchaseUI()end
    shop.ready=nil;shop.readyWall=nil;shop.pendingScan=nil;shop.prices=nil;shop.livePrices=nil;shop.plan=nil;shop.searched=nil;shop.started=nil;shop.scanKind=nil;shop.notice=nil;shop.sentSummary=nil;hide()
    if carry then shop.searched=carry.searched;shop.sentSummary=carry.sentSummary end
end
local function message(key)
    shop.notice=key
    if app.main then app.renderMain()end
    if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage('|cffd8b966CraftDeja:|r '..app.caption(key))end
end
local function recalculate()
    -- Never reopen/read Blizzard's crafting panel at the AH: on Forever the
    -- panels exclude each other and its recipe API can be empty or stale.
    app.refresh(not shop.open)
end
function app.nativeScanBusy()
    local state=Auctionator and Auctionator.State or {}
    return (state.FullScanFrameRef and state.FullScanFrameRef.inProgress==true)or
        (state.IncrementalScanFrameRef and state.IncrementalScanFrameRef.doingFullScan==true)or false
end
function app.shoppingAge()
    if not shop.ready then return nil end
    local age=clock()-shop.ready
    local wall=app.try(time)
    if age<0 then return nil end
    if shop.readyWall and wall then
        local wallAge=wall-shop.readyWall;if wallAge<0 then return nil end
        age=math.max(age,wallAge)
    end
    return age
end
local function reusableScan()
    local age=app.shoppingAge()
    return shop.ready and shop.prices and age and age<=shop.maxAge
end
function app.shoppingFresh()
    return shop.open and shop.ready and not shop.started and not shop.pendingScan and not app.nativeScanBusy()and reusableScan()
end
function app.scanWaitText()
    if shop.pendingScan then return app.caption('scan_processing')end
    if shop.started or app.nativeScanBusy()then return app.caption('step_auto_scanning')end
    return app.caption(shop.autoReason or 'step_auto_scan')
end
function app.blockShoppingAction()
    app.flowLog('scan.purchase_blocked',{epoch=shop.epoch,busy=app.nativeScanBusy(),started=not not shop.started,processing=not not shop.pendingScan,age=app.shoppingAge()or -1})
    if app.saved then app.refreshNextStep(true);if app.main then app.renderMain()end end
    return false
end
-- ScanComplete has to belong to this AH visit and its native scanner must have
-- left its busy state. Its wall/monotonic completion time is never reset on reuse.
function app.finishShoppingScan()
    local p=shop.pendingScan
    if not p then return false end
    if not shop.open or p.epoch~=shop.epoch then shop.pendingScan=nil;return false end
    if app.nativeScanBusy()then return false end
    local wall=app.try(time);local age=clock()-p.at
    if age<0 or p.wall and wall and wall<p.wall then clear();shop.reason='shop_stale';return false end
    if p.wall and wall then age=math.max(age,wall-p.wall)end
    if age<0 or age>shop.maxAge then clear();shop.reason='shop_stale';return false end
    shop.pendingScan=nil;shop.prices=p.prices;shop.ready=p.at;shop.readyWall=p.wall
    shop.scanSerial=(shop.scanSerial or 0)+1;shop.reason=nil;shop.autoCarry=nil;shop.autoAfter=nil;shop.autoReason=nil
    app.flowLog('scan.ready',{epoch=shop.epoch,kind=p.kind,serial=shop.scanSerial,items=p.items,age=age})
    if app.active then recalculate();if not app.guideOnly then app.showShopping()end else message('open')end
    return true
end
-- Full scans can be replicate/get-all scans OR complete summary/browse scans.
-- A single-item search / generic DB update never grants freshness.
local function scanPrices(data,kind)
    if type(data)~='table'then return nil end
    local prices={}
    for _,entry in ipairs(data)do
        if type(entry)~='table'then return nil end
        local id,quantity,unit
        if kind=='summary'then
            local key=entry.itemKey
            if type(key)~='table'or type(key.itemID)~='number'or type(entry.totalQuantity)~='number'or type(entry.minPrice)~='number'then return nil end
            id=key.itemID;quantity=entry.totalQuantity;unit=entry.minPrice
            -- Battle pets are not crafting reagents; keep their valid scan rows
            -- from invalidating the complete summary scan.
            if key.battlePetSpeciesID and key.battlePetSpeciesID~=0 then id=0 end
        else
            local info=entry.replicateInfo or entry.auctionInfo
            if type(info)~='table'or type(entry.itemLink)~='string'then return nil end
            id=tonumber(entry.itemLink:match('item:(%d+)'))
            quantity=info[3];local buyout=info[10]
            if not id or type(quantity)~='number'or type(buyout)~='number'then return nil end
            if quantity>0 then unit=buyout/quantity end
        end
        if id>0 and quantity>0 and unit and unit>0 then
            if not prices[id]or unit<prices[id]then prices[id]=unit end
        end
    end
    return prices
end
function app.bindShopping()
    local a=Auctionator;local bus=a and a.EventBus
    if not bus or type(bus.Register)~='function'then return false end
    local names,map,signature={},{},{}
    for _,source in ipairs({{kind='replicate',part=a.FullScan},{kind='summary',part=a.IncrementalScan}})do
        local events=source.part and source.part.Events
        if events and events.ScanStart and events.ScanComplete and events.ScanFailed then
            for _,phase in ipairs({'ScanStart','ScanComplete','ScanFailed'})do
                local name=events[phase]
                names[#names+1]=name;map[name]={kind=source.kind,phase=phase};signature[#signature+1]=name
            end
        end
    end
    if #names==0 then return false end
    signature=table.concat(signature,'|')
    if shop.bus==bus and shop.bindingSignature==signature then return true end
    local binding={};local listener={}
    function listener:ReceiveEvent(event,data)
        if shop.binding~=binding or not shop.open then return end
        local matched=map[event];if not matched then return end
        if matched.phase=='ScanStart'then
            clear();shop.started=shop.epoch;shop.scanKind=matched.kind;shop.reason='shop_scanning'
            app.flowLog('scan.start',{epoch=shop.epoch,kind=matched.kind})
            if app.clearNativeCraft then app.clearNativeCraft()end
            if app.refreshNextStep and app.active then app.refreshNextStep(true)end
        elseif matched.phase=='ScanFailed'then
            if shop.started~=shop.epoch or shop.scanKind~=matched.kind then return end
            app.flowLog('scan.failed',{epoch=shop.epoch,kind=matched.kind})
            clear();shop.autoCarry=nil;shop.reason='shop_scan_failed';shop.autoAfter=clock()+60;message(shop.reason)
        elseif matched.phase=='ScanComplete'then
            if shop.started~=shop.epoch or shop.scanKind~=matched.kind then return end
            local prices=scanPrices(data,matched.kind)
            clear()
            if not prices then shop.autoCarry=nil;shop.autoAfter=clock()+60;shop.reason='shop_incompatible';message(shop.reason);return end
            shop.pendingScan={prices=prices,epoch=shop.epoch,kind=matched.kind,at=clock(),wall=app.try(time),items=#data}
            shop.reason='scan_processing'
            app.flowLog('scan.complete',{epoch=shop.epoch,kind=matched.kind,items=#data,busy=app.nativeScanBusy()})
            app.finishShoppingScan()
        end
        if app.main then app.renderMain()end
    end
    shop.bus=bus;shop.binding=binding;shop.bindingSignature=signature
    local ok=pcall(bus.Register,bus,listener,names)
    if not ok then shop.bus=nil;shop.binding=nil;return false end
    shop.listener=listener;return true
end
function app.shoppingStatusText()
    if shop.notice=='shop_sent'and shop.sentSummary then
        local s=shop.sentSummary
        return app.caption('shop_sent_counts',s.ah,s.vendor,s.owned)
    end
    if shop.notice then return app.caption(shop.notice)end
    if shop.open then return app.caption(app.shoppingFresh()and 'shop_ready'or shop.reason or 'shop_wait_scan')end
end
function app.shoppingEvent(event)
    if event=='AUCTION_HOUSE_SHOW'then
        if shop.open then app.bindShopping();return end
        local expired=shop.ready and not reusableScan()
        if not reusableScan()then clear()end
        shop.open=true;shop.epoch=shop.epoch+1;shop.autoAfter=clock()+2
        if reusableScan()then shop.reason=nil
        else shop.reason=expired and 'shop_stale'or 'shop_wait_scan'end
        if not shop.searched then shop.notice=nil end
        app.bindShopping()
    elseif event=='AUCTION_HOUSE_CLOSED'then
        -- Completed scans remain usable for 30 minutes across AH visits.
        -- Preserve the mail/repeat-search lock as well. Interrupted scans cannot
        -- complete into a later visit, and never resurrect the previous scan.
        if shop.started or shop.pendingScan then clear()end
        hide();shop.open=false;shop.autoCarry=nil;shop.epoch=shop.epoch+1;shop.reason='shop_open_ah'
        if app.saved then app.refresh(false)end
    elseif event=='ADDON_LOADED'then app.bindShopping()
    end
end
function app.shoppingPoll()
    if shop.open then
        app.finishShoppingScan()
        app.bindShopping()
        if shop.ready and not app.shoppingFresh()then shop.autoCarry={searched=shop.searched,sentSummary=shop.sentSummary};clear();shop.reason='shop_stale';message(shop.reason)end
        app.autoScanTick()
    end
end
function app.requestShopping()
    app.guideOnly=nil -- explicit request from the guide or a command
    local a=api()
    if not a or type(a.MultiSearchAdvanced)~='function'then message('shop_needs_auctionator');return end
    if not shop.open then message('shop_open_ah');return end
    if not app.bindShopping()then message('shop_incompatible');return end
    if not app.shoppingFresh()then message(shop.reason or 'shop_wait_scan');app.blockShoppingAction();return end
    recalculate();app.showShopping()
end
function app.shoppingPlan(points)
    if not app.shoppingFresh()then return nil,shop.reason or 'shop_wait_scan'end
    local rod,_,rodActive=app.rodPreparationPlan()
    if rodActive then return rod and app.completeShoppingPlan(rod)or nil,'requirement_tool'end
    if app.productionEnabled and app.productionEnabled()then
        local plan,reason=app.productionPlan()
        if plan and app.craftRequirementTask(plan.recipe,true)then return nil,'requirement_tool'end
        return plan and app.completeShoppingPlan(plan)or nil,reason
    end
    local d=app.decision
    if not app.active or not d then return nil,app.problem or 'open'end
    if d.current.needsLearning or not d.current.recipe.learned then return nil,'learn_first'end
    if app.craftRequirementTask(d.current.recipe,true)then return nil,'requirement_tool'end
    local target,mode,boundary=app.planningTarget(points)
    if not target or target<=app.active.profile.skill then return nil,'learn_first'end
    local plan,reason=app.materialPlan(d.current.recipe,target)
    if not plan then return nil,reason end
    plan.goalMode=mode;plan.boundary=boundary;plan.scanSerial=shop.scanSerial
    return app.completeShoppingPlan(plan)
end
function app.completeShoppingPlan(plan)
    plan.scanSerial=shop.scanSerial
    plan.ahTotal=0;plan.vendorTotal=0;plan.ahRows=0;plan.vendorRows=0;plan.ownedRows=0
    local observedPrices=shop.prices or {}
    for _,row in ipairs(plan.rows)do
        local vendor,kind=app.vendorPrice(row.id)
        local live=shop.livePrices and shop.livePrices[row.id]
        local ah=live and live.unit or observedPrices[row.id]
        row.vendor=vendor and (not ah or vendor<=ah)or false
        row.vendorUnit=vendor;row.vendorKind=kind
        local ceiling=row.unit*(1+shop.tolerance/100)
        -- A zero advanced maxPrice means "no ceiling" in Auctionator. Preserve
        -- fractional copper for cheap stacks rather than rounding it to zero.
        row.maxUnit=ceiling>=1 and math.floor(ceiling)or ceiling
        if vendor and not row.vendor then
            -- Even with tolerance, AH results must remain strictly cheaper than
            -- this normal merchant price. Never raise a vial search above it.
            row.maxUnit=math.min(row.maxUnit,vendor-math.max(.000001,vendor*1e-9))
        end
        if row.buy>0 then
            if row.vendor then plan.vendorTotal=plan.vendorTotal+row.buy*row.unit;plan.vendorRows=plan.vendorRows+1
            else plan.ahTotal=plan.ahTotal+row.buy*row.maxUnit;plan.ahRows=plan.ahRows+1 end
        else plan.ownedRows=plan.ownedRows+1 end
    end
    return plan
end
function app.searchShopping()
    if not app.shoppingFresh()then message(shop.reason or 'shop_wait_scan');hide();return app.blockShoppingAction()end
    -- Re-read quantities/prices and the decision immediately before hand-off.
    recalculate()
    local plan,reason=app.shoppingPlan()
    if not plan then message(reason or 'none');return false end
    if not plan.stockKnown then message('shop_unknown_stock');return false end
    if shop.searched then message('shop_in_mail');return false end
    local terms={}
    for _,row in ipairs(plan.rows)do
        if row.buy>0 and not row.vendor then
            local name=app.itemName(row.id)
            if not name or name:sub(1,1)=='#'then message('shop_item_loading');return false end
            local quantity=app.purchaseBudget(plan,row.id,math.max(0,row.buy-app.confirmedMail(row.id)))
            if quantity>0 then terms[#terms+1]={searchString=name,isExact=true,categoryKey='',quantity=quantity,maxPrice=row.maxUnit}end
        end
    end
    if #terms==0 then
        if plan.vendorRows>0 then message('shop_vendor_only')else message('shop_nothing')end
        return false
    end
    local a=api()
    if not a or type(a.MultiSearchAdvanced)~='function'then message('shop_needs_auctionator');return false end
    app.setAHOrder(plan)
    local ok=pcall(a.MultiSearchAdvanced,app.identifier,terms)
    if not ok then app.ahOrder=nil;message('shop_search_failed');return false end
    -- Won auctions may still be in the mailbox, so do not silently submit the
    -- same estimated shopping quantity repeatedly. Unlock explicitly or rescan.
    shop.searched=true;shop.plan=plan;shop.sentSummary={ah=#terms,vendor=plan.vendorRows,owned=plan.ownedRows}
    hide();message('shop_sent')
    return true
end
