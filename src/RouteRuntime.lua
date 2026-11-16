-- SPDX-License-Identifier: MIT
local _,app=...
local frame=CreateFrame('Frame');app.routeRuntimeFrame=frame;frame:Hide()
local revision=0
local fullReasons={new_order=true,force_ah=true,reset_ah=true,provider_terms=true,handover=true,manual=true,guild_opt_out=true,guild_roster=true,guild_recipe=true}
function app.invalidateRoute(reason)
    if type(app.currentRouteOrder)~='function'then return end -- early world event during addon bootstrap
    local order=app.currentRouteOrder()
    if not order or not order.active then return end
    if not fullReasons[reason]then
        -- New observations update the current action; they must not restart
        -- an in-flight comparison or re-optimize the same recipe section.
        if app.routeSearch then app.routeStaleAfterSearch=true;return end
        if app.pinnedRouteDecision and app.pinnedRouteDecision()then
            app.routeResult.costsStale=true
            app.routeDisplayDirty=true;frame:Show()
            return
        end
    end
    revision=revision+1;app.routeDirty=true
    if reason=='price'or not app.routeDirtyReason then app.routeDirtyReason=reason end
    app.routeSearch=nil;frame:Show()
end
function app.pinnedRouteDecision()
    local order=app.currentRouteOrder();local search=app.routeResult
    local best=search and search.best;local s=best and best.segments[1]
    local active=app.active
    if not order or not order.active or order.owner~=app.characterKey or not s or not active or
        active.profile.id~=order.profession or active.profile.cap~=search.model.cap or active.profile.skill>=s.to then return end
    local r=active.recipes[s.recipe]
    if not r or r.disabled or r.cooldown or r.craftLimit==0 then return end
    local d=app.routeDecision
    if not d or d.routeOrder~=order.id then return end
    local q=app.quote(r,{})or d.current.quote
    if not q then return end
    local p,colour,estimated=app.probability(r,active.profile.skill,true)
    if not p or p<=0 then return end
    d.profile=active.profile;d.current.recipe=r;d.current.quote=q;d.current.chance=p;d.current.colour=colour
    d.current.estimated=estimated;d.current.needsLearning=not r.learned;d.current.greenExtra=colour=='green'
    d.current.unitSkill=(q.netCost or q.cost)/math.max(.000001,p*(r.points or 1))
    return d
end
function app.observeRouteDepth(item,rows)
    if not app.currentRouteOrder()or type(item)~='number'then return end
    local levels,signature={},{}
    for i,r in ipairs(rows or {})do
        if i>5000 then break end
        local unit=r.unit or r.unitPrice or r.price
        if app.routeFinite(unit)and unit>0 and app.routeFinite(r.quantity)and r.quantity>0 then
            levels[#levels+1]={unit=unit,quantity=r.quantity};signature[#signature+1]=unit..':'..r.quantity
        end
    end
    table.sort(signature);local key=table.concat(signature,',')
    app.routeDepth=app.routeDepth or {};local old=app.routeDepth[item]
    app.routeDepth[item]={levels=levels,at=app.try(time)or 0,serial=app.shopping.scanSerial,key=key}
    if not old or old.key~=key or old.serial~=app.shopping.scanSerial or (app.try(time)or 0)-old.at>(app.shopping.maxAge or 900)then app.invalidateRoute('price')end
end
function app.checkRouteOffers()
    if app.purchasePending()or app.craftRefreshBusy()or not app.shoppingFresh()then return false end
    local search=app.routeSuggestion or app.routeResult
    if not search or not search.best then return false end
    local terms={}
    for item,n in pairs(search.best.bought)do
        local price=search.model.prices[item]
        if n>0 and not(type(price)=='table'and price.vendor)then
            local name=app.itemName(item)
            if name and name:sub(1,1)~='#'then terms[#terms+1]={searchString=name,isExact=true,categoryKey='',quantity=n}end
        end
    end
    local api=Auctionator and Auctionator.API and Auctionator.API.v1
    if #terms==0 or not api or type(api.MultiSearchAdvanced)~='function'then return false end
    -- Search only. Do not replace the existing buy batch or prefill quantities.
    return pcall(api.MultiSearchAdvanced,app.identifier..' Route',terms)
end
local function apply(search)
    local order=app.currentRouteOrder();local best=search and search.best
    if not order or not best or order.owner~=app.characterKey or not app.active or app.active.profile.id~=order.profession then return false end
    local first=best.segments[1];local recipe=first and app.active.recipes[first.recipe]
    if not recipe then return false end
    local quote=app.quote(recipe,{})
    if not quote then app.routeApplyBlocked=true;return false end
    app.routeApplyBlocked=nil
    local p,colour,estimated=app.probability(recipe,app.active.profile.skill,true)
    local current={recipe=recipe,quote=quote,chance=p,colour=colour,estimated=estimated,
        unitSkill=(quote.netCost or quote.cost)/math.max(.000001,p*(recipe.points or 1)),needsLearning=not recipe.learned,greenExtra=colour=='green'}
    local nextStage=best.segments[2]
    local follow=nextStage and {level=first.to,candidate={recipe=app.active.recipes[nextStage.recipe]or search.model.rawRecipes[nextStage.recipe],needsLearning=not search.model.recipes[nextStage.recipe].learned}}
    app.routeDecision={profile=app.active.profile,current=current,stop=first.to,followup=follow,snapshot=app.decision and app.decision.snapshot,
        missing=0,unchecked=0,routeOrder=order.id}
    app.decision=app.routeDecision;app.problem=nil;app.routeResult=search;app.routeSuggestion=nil;app.routeDirtyReason=nil
    search.costsStale=app.routeStaleAfterSearch or nil;app.routeStaleAfterSearch=nil
    app.flowLog('route.completed',{compared=search.compared or 0,from=app.active.profile.skill,stop=first.to})
    order.lastRoute={};for i,s in ipairs(best.segments)do order.lastRoute[i]=app.copy(s)end
    order.lastSupply={};for _,t in ipairs(best.transfers)do order.lastSupply[#order.lastSupply+1]={item=t.item,quantity=t.quantity,source=t.source,provider=app.copy(t.provider),stage=t.stage}end
    return true
end
function app.acceptRouteSuggestion()
    if app.purchasePending()or app.craftRefreshBusy()then return false end
    local s=app.routeSuggestion or app.routeResult
    if not s or s.revision~=revision then return false end
    local ok=apply(s);if ok then app.refreshNextStep(true)end;return ok
end
function app.cancelRouteOrder()
    if app.purchasePending()or app.craftRefreshBusy()then return false end
    local order=app.currentRouteOrder();if order then order.active=false end
    app.routeResult=nil;app.routeSearch=nil;app.routeSuggestion=nil;app.routeDecision=nil;app.routeDirty=nil
    app.refresh(false);return true
end
function app.routeRuntimeTick()
    local network=app.guildRouteTick()
    local order=app.currentRouteOrder()
    if not order or not order.active then if not network then frame:Hide()end;return end
    if app.craftRefreshBusy()or app.purchasePending()or app.nativeCraftHandoff then return end
    if order.owner~=app.characterKey then if not network then frame:Hide()end;return end
    if not app.active or app.active.profile.id~=order.profession then if not network then frame:Hide()end;return end
    if app.active.profile.skill>=order.target then order.finished=true;app.routeDirty=nil;app.routeSearch=nil;if not network then frame:Hide()end;return end
    if app.routeDirty and not app.routeSearch then
        local model,why=app.buildRouteModel(order)
        if not model then app.routeBuildProblem=why;return end
        app.routeBuildProblem=nil;app.routeSearch=app.newRouteSearch(model);app.routeSearch.revision=revision;app.routeDirty=nil
        app.flowLog('route.started',{reason=app.routeDirtyReason or 'checkpoint',from=model.start,target=model.target})
    end
    local search=app.routeSearch
    local completed=false
    if search then
        local started=type(debugprofilestop)=='function'and debugprofilestop()or 0
        for _=1,8 do
            if app.advanceRouteSearch(search)then completed=true;break end
            if type(debugprofilestop)=='function'and debugprofilestop()-started>=2 then break end
        end
    end
    if search and completed then
        app.routeSearch=nil
        if search.revision~=revision then app.routeDirty=true;return end
        local previous=app.routeResult and app.routeResult.best
        if previous and search.best and previous.segments[1].recipe~=search.best.segments[1].recipe and app.routeDirtyReason=='price'then
            app.routeSuggestion=search
        else app.routeResult=search;apply(search)end
        if app.renderRouteWindow then app.renderRouteWindow()end
        app.refreshNextStep(true)
    end
    if app.routeDisplayDirty then app.routeDisplayDirty=nil;if app.renderRouteWindow then app.renderRouteWindow()end end
    if not app.routeSearch and not app.routeDirty and not network then frame:Hide()end
end

local function oldOwnerTask(order)
    for _,task in ipairs(order.lastSupply or {})do
        if task.provider.character==app.characterKey and not order.forceAH[task.item]then
            return {kind='route_supply_alt',key='route_alt:'..task.item,body=app.caption('route_alt_action',app.itemName(task.item),task.quantity),supply=task}
        end
    end
    return {kind='route_owner',key='route_owner',body=app.caption('route_return_owner')}
end
function app.routeTask(plan)
    local order=app.currentRouteOrder();if not order or not order.active then return end
    if order.owner~=app.characterKey then return oldOwnerTask(order)end
    if not app.active or app.active.profile.id~=order.profession then return {kind='route_profession',key='route_profession',body=app.caption('step_open_profession')}end
    if app.active and app.active.profile.skill>=order.target then return {kind='done',key='route_done',body=app.caption('route_goal_done',order.target)}end
    if app.nativeCraftHandoff or app.craftBatch then return end
    if app.routeDirty or app.routeSearch then return {kind='route_pending',key='route_pending',body=app.caption('route_calculating')}end
    if app.routeSuggestion then return {kind='route_review',key='route_review',body=app.caption('route_price_change')}end
    if app.routeApplyBlocked then return {kind='route_review',key='route_no_prices',body=app.caption('no_prices')}end
    local search=app.routeResult
    if not search or not search.best then return {kind='route_review',key='route_missing',body=app.caption(app.routeBuildProblem or 'route_no_complete')}end
    for _,rank in ipairs(search.best.ranks or {})do
        if app.active.profile.cap==rank.fromCap and app.active.profile.skill>=rank.skill then return app.rankTrainerTask()end
    end
    local first=search.best.segments[1];local r=app.active.recipes[first.recipe]
    if r and not r.learned then
        local task=app.recipeLearningTask(r);task.routeTeacher=true;return task
    end
    for _,s in ipairs(search.best.transfers)do
        if s.stage==1 and not order.forceAH[s.item]then
            local loc=app.inventoryFor(s.item)
            if not loc or (loc.bags or 0)<s.quantity then
                return {kind=s.source=='guild'and 'route_supply_guild'or 'route_supply_alt',key='route_supply:'..s.item,body=app.caption('route_supply_action',app.itemName(s.item),s.quantity,s.provider.name or '?'),supply=s}
            end
        end
    end
end

-- Refreshing the recipe snapshot is the existing heavy operation. This hook
-- records alt skills only there; ordinary idle ticks never enumerate recipes.
local refresh=app.refresh
app.refresh=function(rescan,...)
    refresh(rescan,...)
    if rescan and app.active and not app.craftRefreshBusy()then app.recordRouteProfession(app.active);app.publishGuildRecipes()end
    local pinned=app.pinnedRouteDecision();if pinned then app.decision=pinned end
    app.invalidateRoute(rescan and 'progress'or 'state')
end
local next=app.refreshNextStep
app.refreshNextStep=function(force)
    if app.saved and app.currentRouteOrder()and app.currentRouteOrder().active and not app.craftRefreshBusy()and not app.purchasePending()then
        local task=app.routeTask()
        if task then app.renderNextStep(task.routePlan or task.supplyPlan,true,task);return end
    end
    return next(force)
end
local initialize=app.initialize
app.initialize=function(...)
    initialize(...)
    app.setGuildRecipeSharing(app.options.guildRecipeSharing==true)
    local order=app.currentRouteOrder()
    if order and order.active then app.invalidateRoute('resume')end
end
local capture=app.captureInventory
app.captureInventory=function(...)
    capture(...)
    if app.saved then app.invalidateRoute('inventory')end
end
local live=app.updateLiveAHPrice
app.updateLiveAHPrice=function(id,unit,source,...)
    local changed=live(id,unit,source,...)
    if changed then
        app.routePriceObservations=app.routePriceObservations or {}
        app.routePriceObservations[id]={unit=unit,at=app.try(time)or 0,serial=app.shopping.scanSerial}
        if source=='quote'and app.routeDepth then app.routeDepth[id]=nil end
        app.invalidateRoute('price')
    end
    return changed
end
frame:RegisterEvent('PLAYER_ENTERING_WORLD')
for _,event in ipairs({'TRAINER_SHOW','TRAINER_UPDATE','TRAINER_SERVICE_INFO_NAME_UPDATE','TRAINER_CLOSED'})do app.try(frame.RegisterEvent,frame,event)end
frame:SetScript('OnEvent',function(_,event,...)
    if event=='CHAT_MSG_ADDON'then app.receiveGuildRouteMessage(...)
    elseif event=='PLAYER_GUILD_UPDATE'then
        if app.guildShareScope~=app.routeGuildIdentity()then app.setGuildRecipeSharing(app.options.guildRecipeSharing)end
        app.invalidateRoute('guild_roster')
    elseif event=='GUILD_ROSTER_UPDATE'then if app.refreshRouteGuildRoster()then app.invalidateRoute('guild_roster')end
    elseif event=='TRAINER_CLOSED'then app.routeLearnPending=nil
    elseif event=='PLAYER_ENTERING_WORLD'then app.invalidateRoute('resume')
    elseif event:find('TRAINER',1,true)then
        app.verifyPlannedLearning()
        if app.observeRouteRankCosts()then app.invalidateRoute('rank_fee')end
        if app.renderRouteWindow then app.renderRouteWindow()end
    end
end)
frame:SetScript('OnUpdate',function()app.routeRuntimeTick()end)

local command=app.command
app.command=function(message)
    local action,rest=(message or ''):match('^%s*(%S*)%s*(.-)%s*$')
    if action=='route'or action=='routen'then app.showRouteWindow(tonumber(rest));return end
    return command(message)
end
