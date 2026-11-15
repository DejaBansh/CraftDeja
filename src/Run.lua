-- SPDX-License-Identifier: MIT
local _,app=...
local open,pending,elapsed,poll,shopPoll=false,false,0,0,0
app.professionOpen=false
function app.craftRefreshBusy()
    return app.craftBatch~=nil or app.active and app.professionOpen and
        ((app.try(GetTime)or 0)<(app.craftQuietUntil or 0)or app.try(UnitCastingInfo,'player')~=nil or app.try(UnitChannelInfo,'player')~=nil)
end
local function deferCraftRefresh()
    if not app.craftRefreshDeferred then app.flowLog('craft.background_paused',{recipe=app.craftBatch and app.craftBatch.id or 0})end
    app.craftRefreshDeferred=true
end
function app.refreshCraftProgress()
    if not app.active or app.active.invalidated then return false end
    if app.professionOpen and app.nativeProfessionVisible()~=false then
        local profile=app.readProfession()
        if profile and profile.id~=app.active.profile.id then return false end
        if profile then
            local old=app.active.profile.skill
            local recipe=app.craftBatch and app.active.recipes[app.craftBatch.id]or app.decision and app.decision.current.recipe
            app.readCraftProgress(recipe,profile,old)
            app.active.profile.skill=profile.skill;app.active.profile.cap=profile.cap
        end
    end
    app.checkCraftBatch();app.traceState();app.refreshNextStep()
    return true
end
function app.refresh(rescan)
    if not app.saved then return end
    if app.craftRefreshBusy()and app.refreshCraftProgress()then deferCraftRefresh();return end
    app.marketRefreshPending=nil
    if rescan and (not app.shopping.open or app.professionOpen and app.nativeProfessionVisible()~=false)then
        local profile=app.readProfession()
        if profile and (not app.expectedProfession or profile.id==app.expectedProfession)then
            local session=app.readRecipes(profile)
            app.traceProfessionRead(profile,session.confirmed)
            if session.confirmed>0 then
                if profile.id==40 and (not app.active or app.active.profile.id~=40)and app.professionOpen then app.poisonShowOnRead=true end
                app.active=session;app.sessions[profile.id]=session;app.professionLoading=false;app.expectedProfession=nil
                if app.actionNotice==app.caption('action_opening')or app.actionNotice==app.caption('profession_loading')then app.actionNotice=nil end
                if app.catalogWindow and app.catalogWindow:IsShown()then app.catalogWindow.profession=profile.id end
            else app.professionLoading=app.professionOpen end
        elseif app.professionOpen then app.professionLoading=true end
    end
    app.trackRecipeInventory()
    app.decision=nil;app.problem=not app.active and 'open'or nil
    if app.professionLoading then app.problem='profession_loading'
    elseif app.active then
        if app.active.invalidated then app.problem='session_stale'
        elseif app.isPoison()then app.decision,app.problem=app.poisonDecision()
        else app.decision,app.problem=app.decide(app.marketView(app.active))end
    end
    app.checkCraftBatch();app.traceState();app.refreshUI()
    if app.poisonShowOnRead and app.active and not app.professionLoading then
        app.poisonShowOnRead=nil;if app.isPoison()then if app.unifiedUI then app.refreshNextStep(true)else app.showPoisonPlanner()end end
    end
end
function app.requestMarketRefresh()
    -- Prices are already stored synchronously. Merge notifications in the same
    -- frame; explicit buy/search/quote actions still call refresh synchronously.
    app.marketRefreshPending=true
end
local function schedule()
    if app.craftRefreshBusy()then deferCraftRefresh();return end
    if not pending then elapsed=0 end
    pending=true
end
function app.onProfessionOpened(expected)
    app.guideOnly=nil
    open=true;app.professionOpen=true;app.professionLoading=true;app.options.visible=true
    app.poisonShowOnRead=true
    if expected then app.expectedProfession=expected end
    app.refresh(true);schedule();app.refreshNextStep(true)
    if app.pendingRecipeSelection then app.selectNativeRecipe(app.pendingRecipeSelection)end
end
local function professionClosed(force)
    local wasOpen=open or app.professionOpen
    app.clearNativeCraft()
    open=false;app.professionOpen=false;app.professionLoading=false;app.expectedProfession=nil;pending=false
    app.poisonShowOnRead=nil
    if force or wasOpen then app.keepNextStepOnly()end
end
local function relevantItem(id)
    if type(id)~='number'or not app.active then return false end
    local snapshot=app.decision and app.decision.snapshot
    if snapshot and (snapshot.prices[id]~=nil or snapshot.sellPrices and snapshot.sellPrices[id]~=nil)then return true end
    for _,r in pairs(app.active.recipes)do
        if r.outputItemID==id then return true end
        for _,g in ipairs(r.groups or {})do for _,item in ipairs(g.choices)do if item==id then return true end end end
    end
    return false
end
local events=CreateFrame('Frame');app.events=events
for _,event in ipairs({'ADDON_LOADED','AUCTION_HOUSE_SHOW','AUCTION_HOUSE_CLOSED','TRADE_SKILL_SHOW','TRADE_SKILL_CLOSE','TRADE_SKILL_LIST_UPDATE','TRADE_SKILL_DATA_SOURCE_CHANGED','TRADE_SKILL_DETAILS_UPDATE','SKILL_LINES_CHANGED','UNIT_SPELLCAST_SUCCEEDED','BAG_UPDATE_DELAYED','GET_ITEM_INFO_RECEIVED','MERCHANT_SHOW','MERCHANT_UPDATE','MERCHANT_CLOSED','NEUTRAL_FACTION_SELECT_RESULT','PLAYER_ENTERING_WORLD','PLAYER_LEVEL_UP','BANKFRAME_OPENED','BANKFRAME_CLOSED','PLAYERBANKSLOTS_CHANGED','PLAYERREAGENTBANKSLOTS_CHANGED','BANK_TABS_CHANGED','PLAYER_LOGOUT','COMMODITY_PURCHASE_SUCCEEDED','COMMODITY_PURCHASE_FAILED','COMMODITY_PURCHASED','MAIL_SHOW','MAIL_CLOSED','UNIT_SPELLCAST_FAILED','UNIT_SPELLCAST_INTERRUPTED','UI_ERROR_MESSAGE','UNIT_SPELLCAST_START','UNIT_SPELLCAST_CHANNEL_START','ADDON_ACTION_BLOCKED','ADDON_ACTION_FORBIDDEN','COMMODITY_SEARCH_RESULTS_UPDATED'})do app.try(events.RegisterEvent,events,event)end
events:SetScript('OnEvent',function(_,event,arg,castGUID,spellID)
    app.shoppingEvent(event)
    if event=='COMMODITY_SEARCH_RESULTS_UPDATED'and app.saved then app.observeCommodityResults(arg)end
    if event=='UI_ERROR_MESSAGE'and app.saved and (app.craftBatch or app.nativeCraftHandoff or (app.lastUserAction and (app.try(GetTime)or 0)-app.lastUserAction<5))then app.flowLog('game.error',{code=arg,message=castGUID})end
    local relevantCast=not event:find('UNIT_SPELLCAST_',1,true)or arg=='player'and app.active and app.active.recipes[spellID]and app.active.recipes[spellID].learned
    if relevantCast and arg=='player'and (event=='UNIT_SPELLCAST_START'or event=='UNIT_SPELLCAST_CHANNEL_START'or event=='UNIT_SPELLCAST_SUCCEEDED')then
        app.craftQuietUntil=(app.try(GetTime)or 0)+.4
    end
    if app.saved and relevantCast and event~='UI_ERROR_MESSAGE'and event~='GET_ITEM_INFO_RECEIVED'and event~='MERCHANT_UPDATE'and event~='ADDON_LOADED'then app.flowLog('event.'..event,{unit=type(arg)=='string'and arg or nil,item=type(arg)=='number'and arg or nil,spell=spellID})end
    if (event=='ADDON_ACTION_BLOCKED'or event=='ADDON_ACTION_FORBIDDEN')and arg==app.identifier then
        app.flowLog('craft.client_blocked',{addon=arg,action=castGUID})
        app.craftBlocked={action=tostring(castGUID or '?')};app.clearNativeCraft();app.craftBatch=nil
        if app.saved then
            app.refreshNextStep();app.actionNotice=app.caption('craft_client_blocked',app.craftBlocked.action);app.refreshNextStep()
        end
        return
    end
    if app.saved and app.rodCraftEvent then app.rodCraftEvent(event,arg,castGUID,spellID)end
    if app.saved and app.orderProgressEvent then app.orderProgressEvent(event,arg,castGUID,spellID)end
    if app.craftBatchEvent then app.craftBatchEvent(event,arg,castGUID,spellID)end
    if app.poisonEvent and app.saved then app.poisonEvent(event,arg,castGUID,spellID)end
    if app.ahBuyingEvent then app.ahBuyingEvent(event,arg,castGUID)end
    app.inventoryEvent(event)
    if event=='ADDON_LOADED'then
        if arg~=app.identifier then return end
        app.initialize();app.initializeInventory();app.initializeShopping();app.installFlowErrorHook();app.flowLog('session.start',{version=app.release,locale=app.try(GetLocale)});app.ensureMain();app.refreshUI()
        SLASH_CRAFTDEJA1='/cdj';SLASH_CRAFTDEJA2='/craftdeja';SLASH_CRAFTDEJA3='/edj';SlashCmdList.CRAFTDEJA=app.command
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage('|cffd8b966'..app.caption('boot',app.release)..'|r')end
    elseif not app.saved then return
    elseif event=='PLAYER_ENTERING_WORLD'and not app.options.guideSeenV1 and not app.guideAutoShown then
        app.guideAutoShown=true;app.showGuide(true)
    elseif event=='PLAYER_LEVEL_UP'then
        app.levelUpValue=tonumber(arg)or app.levelUpValue;app.refresh(false);app.refreshNextStep(true)
    elseif event=='TRADE_SKILL_SHOW'then
        app.onProfessionOpened()
    elseif event=='TRADE_SKILL_CLOSE'then
        professionClosed(true)
        -- Blizzard's crafting panel may close when the AH opens. CraftDeja is
        -- independent and keeps the last fully read profession for shopping.
        app.refresh(false)
    elseif event=='MERCHANT_SHOW'or event=='MERCHANT_UPDATE'then
        if event=='MERCHANT_SHOW'then app.guideOnly=nil end
        app.observeMerchant();app.vendorBuyEvent(event);if open then schedule()end
    elseif event=='MERCHANT_CLOSED'then app.vendorBuyEvent(event)
    elseif event=='AUCTION_HOUSE_SHOW'then
        if app.nativeProfessionVisible()==true then open=true;app.professionOpen=true;schedule()else professionClosed()end
        poll=0;app.refresh(open)
        if app.active and app.options.visible then if app.unifiedUI then app.refreshNextStep(true)else app.main:Show()end end
        app.guideOnly=nil -- a new AH visit may open its shopping panel after a successful scan
        app.refreshNextStep(true)
    elseif event=='AUCTION_HOUSE_CLOSED'then if open then schedule()end
    elseif (event=='TRADE_SKILL_LIST_UPDATE'or event=='TRADE_SKILL_DATA_SOURCE_CHANGED'or event=='TRADE_SKILL_DETAILS_UPDATE')and app.nativeProfessionVisible()==true then
        open=true;app.professionOpen=true;schedule()
    elseif event=='UNIT_SPELLCAST_SUCCEEDED'then
        if arg=='player'then app.noteCompletedCraft(spellID,castGUID)end
        if arg=='player'and open then schedule()
        elseif arg=='player'and app.active and app.active.recipes[spellID]then
            -- A craft queue can finish after closing the profession. Its skill
            -- may have changed; do not shop from that old snapshot.
            app.active.invalidated=true;app.refresh(false)
        end
    elseif event=='BAG_UPDATE_DELAYED'and app.shopping.open and not open then app.refresh(false)
    elseif event=='SKILL_LINES_CHANGED'and not open then app.refresh(false)
    elseif relevantCast and arg=='player'and (event=='UNIT_SPELLCAST_START'or event=='UNIT_SPELLCAST_CHANNEL_START'
        or event=='UNIT_SPELLCAST_FAILED'or event=='UNIT_SPELLCAST_INTERRUPTED')then
        if open then schedule()end
    elseif event=='GET_ITEM_INFO_RECEIVED'then
        if castGUID==true and relevantItem(arg)then schedule()end
    elseif event=='BAG_UPDATE_DELAYED'or event=='SKILL_LINES_CHANGED'or event=='PLAYERBANKSLOTS_CHANGED'
        or event=='PLAYERREAGENTBANKSLOTS_CHANGED'or event=='BANK_TABS_CHANGED'or event=='BANKFRAME_OPENED'or event=='BANKFRAME_CLOSED'then
        if open then schedule()elseif app.active then app.refresh(false)end
    end
end)
events:SetScript('OnUpdate',function(_,delta)
    if not app.saved then return end
    app.inventoryTick(delta)
    app.updateMerchantMarker(delta)
    if app.craftRefreshDeferred and not app.craftRefreshBusy()then
        app.craftRefreshDeferred=nil;app.flowLog('craft.background_resumed',{});schedule()
    end
    shopPoll=shopPoll+delta
    if shopPoll>=1 then shopPoll=0;
        local visible=app.nativeProfessionVisible()
        if visible==true and not app.professionOpen then app.onProfessionOpened()
        elseif visible==false and app.professionOpen then professionClosed();app.refresh(false)end
        local busy=app.craftRefreshBusy()
        if busy then
            deferCraftRefresh()
            if not app.refreshCraftProgress()then app.refresh(true)end
        else app.checkCraftBatch();app.traceState();app.refreshNextStep()end
        app.purchasePoll();app.ahMailPoll();app.shoppingPoll();app.bindAuctionBuying();app.vendorBuyTick();if not busy then app.poisonTick()end
        if not busy and app.shoppingWindow and app.shoppingWindow:IsShown()then app.renderShopping()end end
    if pending then
        elapsed=elapsed+delta
        if elapsed>=0.2 then
            pending=false
            if app.craftRefreshBusy()then deferCraftRefresh()
            else
                app.refresh(true);if app.pendingRecipeSelection then app.selectNativeRecipe(app.pendingRecipeSelection)end
                if open and app.options.visible then if app.unifiedUI then app.refreshNextStep(true)else app.main:Show()end end
            end
        end
    end
    if app.marketRefreshPending and not app.craftRefreshBusy()then app.refresh(false)end
    if open and not app.craftRefreshBusy()then
        poll=poll+delta
        if poll>=3 then
            poll=0
            -- Events invalidate recipes. The fallback poll only checks the
            -- inexpensive profession header, never re-enumerates unchanged data.
            local p=app.readProfession();local old=app.active and app.active.profile
            if app.professionLoading or p and (not old or p.id~=old.id or p.skill~=old.skill or p.cap~=old.cap)then schedule()end
        end
    else poll=0 end
end)
function app.command(message)
    local action,argument=string.match(message or '','^%s*(%S*)%s*(.-)%s*$')
    action=string.lower(action or '')
    if action=='scale'then local value=tonumber(argument);if value then app.applyScale(value>2 and value/100 or value,true)end
    elseif action=='lang'and (argument=='en'or argument=='de'or argument=='auto')then app.options.language=argument;app.refreshUI()
    elseif action=='source'and (argument=='auto'or argument=='auctionator'or argument=='tsm')then app.options.prices=argument;app.refresh()
    elseif action=='help'or action=='guide'then app.showGuide(true)
    elseif action=='recipes'then app.showCatalogue()
    elseif action=='materials'then app.showDetails(app.decision and app.decision.current.recipe,true)
    elseif action=='options'then app.showOptions()
    elseif action=='log'then app.showFlowLog()
    elseif action=='perf'then app.performanceCommand(argument)
    elseif action=='poisons'or action=='gifte'then app.showPoisonPlanner()
    elseif action=='order'or action=='auftrag'then app.refreshNextStep(true)
    elseif action=='data'or action=='audit'then app.showRecipeAudit()
    elseif action=='version'then if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage('CraftDeja '..app.release)end
    elseif action=='diagnose'then app.showPurchaseDiagnostic()
    elseif action=='shopping'then app.requestShopping()
    elseif action=='refresh'then app.refresh(true)
    elseif action==''then
        local f=app.ensureMain();app.options.visible=not f:IsShown();app.refresh(open)
        if app.options.visible then f:Show()else f:Hide()end
    elseif DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(app.caption('help'))end
end
