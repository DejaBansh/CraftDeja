-- SPDX-License-Identifier: MIT
local _,app=...
app.words.de.trip_ready='Bei %s lernen: %s · %s'
app.words.en.trip_ready='Learn at %s: %s · %s'
app.words.de.trip_pack='%s · bis Skill %d vor Ort einplanen (mit Reserve):'
app.words.en.trip_pack='%s · pack for skill %d on site (reserve included):'
app.words.de.trip_item='%s ×%d · noch %s einpacken'
app.words.en.trip_item='%s ×%d · still to pack: %s'
app.words.de.trip_gap='Materialbedarf bis zur nächsten Lernschwelle noch ungeklärt.'
app.words.en.trip_gap='Material requirements for the next learning threshold are unresolved.'

function app.trainerTravelRoute()
    local order=app.currentRouteOrder()
    if order and order.active then
        if order.owner==app.characterKey and app.active and app.active.profile.id==order.profession and not app.routeDirty and not app.routeSearch then
            return app.routeResult and app.routeResult.best
        end
        return
    end
    local d=app.decision
    if not d or not app.active or not d.current or not d.current.recipe or not d.stop then return end
    local stages={{recipe=d.current.recipe.id,from=app.active.profile.skill,to=d.stop}}
    local follow=d.followup
    if follow and follow.candidate and follow.candidate.recipe and follow.level then
        stages[#stages+1]={recipe=follow.candidate.recipe.id,from=follow.level,to=follow.level}
    end
    return {segments=stages}
end

-- A sum of geometric waiting times. The one-sided variance bound allocates
-- a total 10% failure budget across the stages, under the skill chance model.
function app.trainerTravelAttempts(r,first,last,stages)
    local mean,variance=0,0
    for skill=first,last-1,math.max(1,r.points or 1)do
        local p=app.probability(r,skill,false)
        if p<=0 or r.rangeConflict then return end
        mean=mean+1/p
        variance=variance+(1-p)/(p*p)
    end
    return math.ceil(mean+math.sqrt((10*stages-1)*variance))
end

function app.trainerPackingList(route,source)
    if not route or not source or source.kind~='trainer' or not app.active then return end
    local profile,recipes=app.active.profile,app.active.recipes
    local goal=profile.skill
    for _,s in ipairs(route.segments or {})do
        local r=recipes[s.recipe]
        if not r or s.from>profile.cap then break end
        if not r.learned then
            local same=false
            for _,v in ipairs(app.sourceList(r))do
                if v.kind=='trainer' and v.id==source.id then same=true;break end
            end
            if not same then break end
            if r.skill and r.skill<=profile.cap then goal=math.max(goal,r.skill) end
        end
    end
    if goal<=profile.skill then return end
    local legs={}
    local at=profile.skill
    for _,s in ipairs(route.segments)do
        if at>=goal then break end
        if s.from>at then break end
        if s.to>at then
            legs[#legs+1]={r=recipes[s.recipe],first=at,last=math.min(s.to,goal)}
            at=math.min(s.to,goal)
        end
    end
    if at<goal then return app.caption('trip_gap')end
    local totals={}
    for _,leg in ipairs(legs)do
        local r=leg.r
        local count=app.trainerTravelAttempts(r,leg.first,leg.last,#legs)
        if not count or r.cooldown or r.craftLimit and r.craftLimit<count or not r.complete then return app.caption('trip_gap')end
        local quote=app.quote(r,{})
        for i,g in ipairs(r.groups or {})do
            local id=quote and quote.inputs[i].item or #g.choices==1 and g.choices[1]
            if not id then return app.caption('trip_gap')end
            totals[id]=(totals[id] or 0)+count*g.amount
        end
    end
    local ids={}
    for id in pairs(totals)do ids[#ids+1]=id end
    table.sort(ids)
    local lines={app.caption('trip_pack',source.name,goal)}
    for _,id in ipairs(ids)do
        local inv=app.inventoryFor(id)
        local missing=inv and inv.bags and math.max(0,totals[id]-inv.bags)
        lines[#lines+1]=app.caption('trip_item',app.itemName(id),totals[id],tostring(missing or '?'))
    end
    return table.concat(lines,'\n'),totals,goal
end

function app.trainerSupplyPlan(recipe,source,totals,goal)
    local current=app.decision and app.decision.current
    if app.trainerVisitOpen or app.isPoison() or app.productionEnabled() or not current or not app.active or app.active.invalidated then return end
    recipe=recipe or current.recipe
    if not recipe or recipe.learned then return end
    source=source or app.recipeSourceTarget(recipe)
    if not totals then
        local _
        _,totals,goal=app.trainerPackingList(app.trainerTravelRoute(),source)
    end
    if not totals then return end
    local plan={recipe=recipe,from=app.active.profile.skill,target=goal,crafts=1,rows={},purchase=0,
        stockKnown=true,supplyOnly=true,trainerTrip=source.id}
    local missing=false
    for id,n in pairs(totals)do
        local loc=app.inventoryFor(id)
        local unit=app.unitPrice(id,{}) or app.vendorPrice(id)
        if not loc or loc.bags==nil or not loc.total or not unit or unit<=0 then return end
        local buy=math.max(0,n-loc.total)
        missing=missing or loc.bags<n
        plan.rows[#plan.rows+1]={id=id,name=app.itemName(id),total=n,locations=loc,owned=loc.total,buy=buy,unit=unit}
        plan.purchase=plan.purchase+buy*unit
    end
    if missing then
        table.sort(plan.rows,function(a,b)return a.id<b.id end)
        return app.completeShoppingPlan(plan)
    end
end

function app.openTrainerRecipeTask(route)
    if not app.trainerVisitOpen or app.routeLearnPending or not route then return end
    local visit=app.routeTeacherVisit(route)
    local r=visit.available[1]
    if r and visit.npc then
        return {kind='trainer_learn',key='trainer_learn:'..r.id,visit=visit,recipe=app.active.recipes[r.id],
            body=app.caption('trip_ready',app.try(UnitName,'npc') or '?',r.name or tostring(r.id),app.money(r.cost))}
    end
end
-- Verified Forever rank identities. Other ranks remain explicit manual checks;
-- a localized name never establishes the identity of a rank service.
app.routeRankSpells={[202]={[75]=4037},[333]={[75]=7412}}
function app.observeRouteRankCosts()
    local p=app.active and app.active.profile
    local id=p and (app.routeRankSpells[p.id]or {})[p.cap]
    if not id then return false end
    local found
    for _,row in ipairs(app.currentTrainerOffers())do
        if row.id==id then if found then return false end;found=row end
    end
    if not found or not app.routeFinite(found.cost)or found.kind~='available'and found.kind~='unavailable'then return false end
    app.character.routeRankCosts=app.character.routeRankCosts or {}
    local old=app.character.routeRankCosts[p.cap]
    app.character.routeRankCosts[p.cap]=found.cost
    return old~=found.cost
end
function app.routeTeacherVisit(route)
    local wanted={}
    for _,row in ipairs(route and route.learning or {})do wanted[row.id]=row end
    -- An unknown training fee omits the cost ledger entry. The selected
    -- route still needs the recipe; use the actual offer to establish cost.
    for _,s in ipairs(route and route.segments or {})do
        local r=app.active and app.active.recipes and app.active.recipes[s.recipe]
        if r and not r.learned then wanted[r.id]=r end
    end
    for _,row in ipairs(route and route.ranks or {})do if row.spellID then wanted[row.spellID]=row end end
    local offers=app.currentTrainerOffers();local counts={};local visit={available={},locked={},total=0,npc=app.try(UnitGUID,'npc')}
    for _,row in ipairs(offers)do if row.id then counts[row.id]=(counts[row.id]or 0)+1 end end
    for _,row in ipairs(offers)do
        if wanted[row.id]and counts[row.id]==1 then
            if row.kind=='available'and app.routeFinite(row.cost)then
                visit.available[#visit.available+1]=row;visit.total=visit.total+row.cost
            elseif row.kind~='used'then
                local skillName,rank=app.try(GetTrainerServiceSkillReq,row.index)
                local missing=tonumber(rank) or tonumber(skillName) or wanted[row.id].skill
                visit.locked[#visit.locked+1]={id=row.id,name=row.name,skill=missing,kind=row.kind}
            end
        end
    end
    table.sort(visit.available,function(a,b)return a.id<b.id end)
    return visit
end
function app.learnPlannedRecipe(visit,route)
    if app.routeLearnPending or app.craftRefreshBusy()or not visit or not visit.npc or app.try(UnitGUID,'npc')~=visit.npc then return false,'trainer_changed'end
    local current=app.routeTeacherVisit(route or app.routeResult and app.routeResult.best)
    local old=visit.available[1];local row=current.available[1]
    if not old or not row or old.id~=row.id or old.cost~=row.cost or current.total~=visit.total then return false,'trainer_changed'end
    local money=app.try(GetMoney)
    if type(money)~='number'or money<row.cost then return false,'not_enough_gold'end
    if type(BuyTrainerService)~='function'then return false,'trainer_api_unavailable'end
    local ok=pcall(BuyTrainerService,row.index)
    if not ok then return false,'trainer_request_failed'end
    -- One request per click. No guessed batch API and no timer clicking through
    -- services. Only a new client proof completes the row.
    app.routeLearnPending={id=row.id,npc=visit.npc,at=app.try(time)or 0}
    return true,'awaiting_learning_confirmation'
end
function app.verifyPlannedLearning()
    local p=app.routeLearnPending;if not p then return false end
    if app.try(UnitGUID,'npc')~=p.npc then app.routeLearnPending=nil;return false end
    local info=app.try(C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo,p.id)
    local known=type(info)=='table'and info.learned==true
    if not known then for _,row in ipairs(app.currentTrainerOffers())do if row.id==p.id and row.kind=='used'then known=true end end end
    if not known then
        if (app.try(time)or 0)-p.at>10 then app.routeLearnPending=nil end
        return false
    end
    if app.active and app.active.recipes[p.id]then app.active.recipes[p.id].learned=true end
    local order=app.currentRouteOrder and app.currentRouteOrder()
    if order then order.learned=order.learned or {};order.learned[p.id]=true end
    app.routeLearnPending=nil
    if app.invalidateRoute then app.invalidateRoute('learned')end
    return true
end
