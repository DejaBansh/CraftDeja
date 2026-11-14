-- SPDX-License-Identifier: MIT
local _,app=...
app.words.en.skill_goal_done='Skill target %d reached. Apply a new order to continue.'
app.words.de.skill_goal_done='Skillziel %d erreicht. Zum Fortsetzen einen neuen Auftrag uebernehmen.'
app.words.en.skill_goal_done_button='Target reached'
app.words.de.skill_goal_done_button='Ziel erreicht'
local function manualGoal(profile,points)
    if not app.character then return nil end
    app.character.skillGoals=app.character.skillGoals or {}
    local goals=app.character.skillGoals
    local goal=goals[profile.id]
    if type(goal)~='table'or goal.points~=points or type(goal.target)~='number'then
        local old=app.character.orderProgress
        local suffix=':manual:'..tostring(points)
        local target=old and old.profession==profile.id and type(old.key)=='string'
            and old.key:sub(-#suffix)==suffix and type(old.target)=='number'and old.target
        goal={points=points,target=target or math.min(profile.cap,profile.skill+points)}
        goals[profile.id]=goal
    end
    return goal
end
function app.nextActionBoundary()
    local p=app.active and app.active.profile;local d=app.decision
    if not p then return nil end
    if p.skill>=p.cap then return {target=p.cap,kind='rank',cap=p.cap}end
    if not d then return nil end
    if d.current.needsLearning then return {target=p.skill,kind='learn',recipe=d.current.recipe}end
    local follow=d.followup
    if follow and follow.candidate and follow.candidate.needsLearning and follow.level<=p.skill then
        return {target=p.skill,kind='learn',recipe=follow.candidate.recipe}
    end
    local stop=math.min(d.stop,p.cap)
    if stop>=p.cap then return {target=stop,kind='rank',cap=p.cap}end
    if follow and follow.candidate and follow.level<=stop and follow.candidate.recipe.id~=d.current.recipe.id then
        return {target=follow.level,kind=follow.candidate.needsLearning and 'learn'or 'switch',recipe=follow.candidate.recipe}
    end
    return {target=stop,kind='review'}
end
function app.nextActionLabel(boundary)
    if not boundary then return app.caption('goal_review')end
    if boundary.kind=='learn'then return app.caption('goal_learn',app.recipeName(boundary.recipe))end
    if boundary.kind=='switch'then return app.caption('goal_switch',app.recipeName(boundary.recipe))end
    if boundary.kind=='rank'then
        local nextCap=({[75]=150,[150]=225,[225]=300})[boundary.cap]
        return nextCap and app.caption('goal_rank',boundary.cap,nextCap)or app.caption('rank_full')
    end
    return app.caption('goal_review')
end
function app.planningTarget(points)
    local p=app.active and app.active.profile;if not p then return nil end
    local mode=points~=nil and 'manual'or app.shopping.goal or 'next'
    if mode=='next'then local b=app.nextActionBoundary();return b and b.target,mode,b end
    local n=math.max(1,math.min(50,math.floor(tonumber(points)or app.shopping.points or 5)))
    local goal=points==nil and manualGoal(p,n)
    return goal and goal.target or math.min(p.cap,p.skill+n),mode,app.nextActionBoundary()
end
function app.nextActionPlan()
    local d=app.decision;local boundary=app.nextActionBoundary()
    if app.shopping.goal=='manual'and app.active then boundary={target=app.planningTarget(),kind='review'}end
    if not d or not boundary or boundary.target<=app.active.profile.skill then return nil,boundary end
    if app.routeCache and app.routeCache.decision==d then return app.routeCache.plan,boundary end
    local plan=app.materialPlan(d.current.recipe,boundary.target)
    app.routeCache={decision=d,plan=plan};return plan,boundary
end
function app.routeSummary()
    if app.productionEnabled()then
        local j=app.productionJob()
        return j and app.caption('production_quantity',j.remaining)or app.caption('production_choose')
    end
    local plan,b=app.nextActionPlan()
    if not b then return ''end
    local headline=plan and app.caption('goal_route_count',plan.target,plan.estimated and app.caption('approx')or '',plan.crafts)or app.caption('goal_route_at',b.target)
    if app.shopping.goal=='manual'then headline=app.caption('goal_manual_summary',app.shopping.points,headline)end
    return headline..'\n'..app.nextActionLabel(b)
end
function app.planningTitle(plan)
    if app.shopping.goal=='next'then return app.caption('goal_auto_title',plan and plan.target or (app.nextActionBoundary()or {}).target or 0)end
    return app.caption('shop_goal',app.shopping.points)
end
function app.setPlanningGoal(mode,points)
    if app.purchasePending and app.purchasePending()then return false end
    local wantedMode=mode=='manual'and 'manual'or 'next'
    local wantedPoints=points and math.max(1,math.min(50,math.floor(points+.5)))or app.shopping.points
    local profile=app.active and app.active.profile
    local same=app.shopping.goal==wantedMode and app.shopping.points==wantedPoints
    local goal=same and wantedMode=='manual'and profile and manualGoal(profile,wantedPoints)
    local restart=goal and profile.skill>=goal.target
    if same and not restart then return true end
    if profile and wantedMode=='manual'and app.character then
        app.character.skillGoals=app.character.skillGoals or {}
        app.character.skillGoals[profile.id]={points=wantedPoints,target=math.min(profile.cap,profile.skill+wantedPoints)}
    end
    if app.character then app.character.orderProgress=nil end
    app.routeCache=nil
    app.shopping.goal=wantedMode;app.options.shoppingGoal=app.shopping.goal
    if points then app.shopping.points=math.max(1,math.min(50,math.floor(points+.5)));app.options.shoppingPoints=app.shopping.points end
    if app.newPurchasePlan then app.newPurchasePlan()end
    app.refreshNextStep(true);if app.shoppingWindow then app.renderShopping()end
    return true
end

local productionWords={en={auto_skill_title='Automatic: lowest expected cost per skill point',auto_skill_help='Materials are planned until a cheaper recipe, learning step or skill cap. Yellow/green skill chances and quantities are estimates.',production_title='Production from skill 300',production_choose='Select a learned recipe in the profession window, then set the number of crafts.',production_quantity='Crafts: %d',production_apply='Apply production order',production_done='The requested production quantity is complete.',production_locked='Finish the current craft or resolve the pending purchase first.',production_missing='Open the profession to read the selected recipe and its materials.',production_help='Number of crafting actions. Output items per action follow the selected recipe.'},de={auto_skill_title='Automatisch: guenstigste Kosten pro Skillpunkt',auto_skill_help='Materialien bis zum guenstigeren Rezept, Lernschritt oder Skillmaximum planen. Skillchancen und Mengen bei Gelb/Gruen sind Schaetzungen.',production_title='Herstellung ab Skill 300',production_choose='Waehle im Berufsfenster ein gelerntes Rezept und lege die Anzahl der Herstellungen fest.',production_quantity='Herstellungen: %d',production_apply='Herstellungsauftrag uebernehmen',production_done='Die gewaehlte Herstellungsmenge ist fertig.',production_locked='Zuerst den laufenden Craft oder ungeklaerten Kauf abschliessen.',production_missing='Oeffne den Beruf, damit das gewaehlte Rezept und seine Materialien eingelesen werden.',production_help='Anzahl der Herstellvorgaenge. Die Ausgabemenge je Vorgang richtet sich nach dem Rezept.'}}
for lang,entries in pairs(productionWords)do for k,v in pairs(entries)do app.words[lang][k]=v end end
function app.productionEnabled()
    return app.active and app.active.profile.skill>=300 and not app.isPoison()
end
function app.productionJob()
    local p=app.active and app.active.profile
    return p and app.character.productionJobs and app.character.productionJobs[p.id]
end
function app.startProduction(recipe,count)
    if not app.productionEnabled()or app.purchasePending()or app.craftBatch or app.nativeCraftHandoff then return false end
    count=tonumber(count)
    if not count or count~=math.floor(count)or count<1 or count>10000 then return false end
    local current=recipe and app.active.recipes[recipe.id]
    if not current or current.profession~=app.active.profile.id or not current.learned or not current.complete or current.disabled or current.cooldown then return false end
    if not app.quote(current,{})then return false end
    app.character.productionSerial=(app.character.productionSerial or 0)+1
    app.character.productionJobs=app.character.productionJobs or {}
    app.character.productionJobs[current.profession]={recipe=current.id,remaining=count,initial=count,serial=app.character.productionSerial}
    app.character.orderProgress=nil;app.newPurchasePlan();app.refreshNextStep(true)
    return true
end
function app.productionCraftEvent(unit,guid,id)
    local j=app.productionEnabled()and app.productionJob()
    if j and unit=='player'and id==j.recipe and j.remaining>0 and (not guid or guid~=j.lastGUID)then
        j.remaining=j.remaining-1;j.lastGUID=guid
        local recipe=app.active.recipes[id]
        if recipe and type(recipe.craftLimit)=='number'and not app.purchasePending()then app.shopping.searched=nil end
    end
end
function app.productionPlan()
    local j=app.productionJob()
    if not j then return nil,'production_choose'end
    if j.remaining<=0 then return nil,'production_done'end
    local p=app.active.profile;local r=app.active.recipes[j.recipe]
    if not r or not r.learned or not r.complete or r.disabled then return nil,'production_missing'end
    if r.cooldown or r.craftLimit==0 then return nil,'requirement_cooldown'end
    local q=app.quote(r,{})
    if not q then return nil,'no_prices'end
    local count=math.min(j.remaining,r.craftLimit or j.remaining)
    local totals={}
    for _,input in ipairs(q.inputs)do
        local row=totals[input.item]or {id=input.item,total=0,unit=input.unit};totals[input.item]=row
        row.total=row.total+input.amount*count
    end
    local rows,purchase,known={},0,true
    for id,row in pairs(totals)do
        row.locations=app.inventoryFor(id);row.owned=row.locations and row.locations.total or app.owned(id)
        row.buy=math.max(0,row.total-(row.owned or 0));row.name=app.itemName(id)
        row.vendorUnit=app.vendorPrice(id);row.vendor=row.vendorUnit and row.vendorUnit<=row.unit or false
        if row.owned==nil then known=false end
        purchase=purchase+row.buy*row.unit;rows[#rows+1]=row
    end
    table.sort(rows,function(a,b)return a.id<b.id end)
    return {production=true,jobSerial=j.serial,purchaseSlice=type(r.craftLimit)=='number'and j.initial-j.remaining or nil,recipe=r,from=p.skill,target=p.skill,crafts=count,rows=rows,purchase=purchase,stockKnown=known,estimated=false}
end
