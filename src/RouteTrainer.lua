-- SPDX-License-Identifier: MIT
local _,app=...
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
    for _,row in ipairs(route and route.ranks or {})do if row.spellID then wanted[row.spellID]=row end end
    local offers=app.currentTrainerOffers();local counts={};local visit={available={},locked={},total=0,npc=app.try(UnitGUID,'npc')}
    for _,row in ipairs(offers)do if row.id then counts[row.id]=(counts[row.id]or 0)+1 end end
    for _,row in ipairs(offers)do
        if wanted[row.id]and counts[row.id]==1 then
            if row.kind=='available'and app.routeFinite(row.cost)then
                visit.available[#visit.available+1]=row;visit.total=visit.total+row.cost
            elseif row.kind~='used'then
                local missing=app.try(GetTrainerServiceSkillReq,row.index)
                visit.locked[#visit.locked+1]={id=row.id,name=row.name,skill=missing,kind=row.kind}
            end
        end
    end
    table.sort(visit.available,function(a,b)return a.id<b.id end)
    return visit
end
function app.learnPlannedRecipe(visit)
    if app.routeLearnPending or app.craftRefreshBusy()or not visit or not visit.npc or app.try(UnitGUID,'npc')~=visit.npc then return false,'trainer_changed'end
    local current=app.routeTeacherVisit(app.routeResult and app.routeResult.best)
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
