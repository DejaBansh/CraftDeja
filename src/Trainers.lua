-- SPDX-License-Identifier: MIT
local _,app=...
local words={en={trainer_show='Show trainer on map',trainer_missing='No matching rank trainer location is recorded. Ask a city guard for profession trainers.',trainer_reference='Reference location; check the trainer offer in game.',trainer_marked='Trainer marked on the map.',trainer_no_marker='Use the trainer coordinates above.',trainer_level='Requires character level %d and profession skill %d.'},de={trainer_show='Lehrer auf Karte zeigen',trainer_missing='Kein passender Rang-Lehrer gespeichert. Frage eine Stadtwache nach Berufslehrern.',trainer_reference='Referenzstandort; Lehrangebot im Spiel prüfen.',trainer_marked='Berufslehrer auf der Karte markiert.',trainer_no_marker='Nutze die Lehrerkoordinaten oben.',trainer_level='Benötigt Charakterstufe %d und Berufsskill %d.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.trainer_book='Buy and use the profession-rank book from %s.'
app.words.de.trainer_book='Kaufe und benutze das Berufsrang-Lehrbuch bei %s.'
app.words.en.trainer_level_first='Reach character level %d first (currently %d).\nThen learn %s %d-%d.'
app.words.de.trainer_level_first='Erreiche zuerst Charakterstufe %d (aktuell %d).\nDanach %s %d-%d lernen.'
app.words.en.trainer_level_title='Reach character level %d first.'
app.words.de.trainer_level_title='Zuerst Charakterstufe %d erreichen.'
app.words.en.trainer_level_after='%s %d-%d unlocks at character level %d.'
app.words.de.trainer_level_after='%s %d-%d ist erst ab Charakterstufe %d möglich.'
app.words.en.trainer_level_current='Your character level: %d'
app.words.de.trainer_level_current='Deine Charakterstufe: %d'
app.words.en.trainer_later='Show trainer for later'
app.words.de.trainer_later='Lehrer für später zeigen'
app.words.en.trainer_level_wait='Training is only possible once the character level requirement is met.'
app.words.de.trainer_level_wait='Weiterlernen ist erst möglich, wenn die benötigte Charakterstufe erreicht ist.'
function app.playerLevel()
    local level=app.try(UnitLevel,'player')
    return math.max(type(level)=='number'and level or 0,app.levelUpValue or 0)
end
-- Forever quest 6610. Dirge's coordinates match the project's vendor record.
local dirge={npc=8125,name="Dirge Quikcleave",profession=185,fromCap=225,toCap=300,
    level=35,skill=225,map=1446,x=52.6,y=28,side="Both",questID=6610}
local supplies={{12207,12},{7974,10},{8932,20}}
app.words.de.cooking_quest="Muschelette Surprise"
app.words.en.cooking_quest="Clamlette Surprise"
app.words.de.cooking_visit="Reise nach Tanaris ins Gasthaus im Osten von Gadgetzan. Sprich mit Dirge Quikcleave (52,6 / 28,0)."
app.words.en.cooking_visit="Travel to Tanaris and enter the inn in eastern Gadgetzan. Speak to Dirge Quikcleave (52.6 / 28.0)."
app.words.de.cooking_start="Quest annehmen und Zutaten übergeben"
app.words.en.cooking_start="Accept the quest and deliver the ingredients"
app.words.de.cooking_finish="Quest bei Dirge abgeben"
app.words.en.cooking_finish="Turn in the quest to Dirge"
app.words.de.cooking_refresh="Quest abgeschlossen. Öffne Kochkunst, um den neuen Rang einzulesen."
app.words.en.cooking_refresh="Quest completed. Open Cooking to read the new rank."
app.words.de.cooking_no_offer="Für %s fehlt ein aktuelles AH-Angebot. Besorge den Gegenstand oder prüfe das AH später erneut."
app.words.en.cooking_no_offer="No current auction quote for %s. Collect the item or check the auction house again later."
function app.atCookingQuestCap()
    local p=app.active and not app.active.invalidated and app.active.profile
    return p and p.id==185 and p.cap==225 and p.skill>=225
end
local function questCompleted()
    return app.try(C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted or IsQuestFlaggedCompleted,6610)
end
function app.cookingQuestPlan()
    if not app.atCookingQuestCap() or app.productionEnabled() or app.playerLevel()<35 or questCompleted() then return end
    local plan={questID=6610,supplyOnly=true,from=225,target=225,crafts=0,purchase=0,stockKnown=true,rows={},
        recipe={id=18260,profession=185,liveName=app.caption('cooking_quest')}}
    local missing=false
    for _,item in ipairs(supplies) do
        local id,total=item[1],item[2]
        local loc=app.inventoryFor(id) or {}
        local bags=loc.bags or app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)
        if bags==nil then plan.stockKnown=false end
        local bank=(loc.bank or 0)+(loc.shared or 0)
        local owned=(bags or 0)+bank
        local buy=math.max(0,total-owned)
        local unit=0 -- completeShoppingPlan applies the current AH quote, including to vendor goods.
        plan.rows[#plan.rows+1]={id=id,name=app.itemName(id),total=total,owned=owned,buy=buy,unit=unit,
            locations={bags=bags,bank=bank,total=owned}}
        plan.purchase=plan.purchase+buy*unit
        missing=missing or (bags or 0)<total
    end
    if missing then return app.completeShoppingPlan(plan) end
end
local function cookingQuestTask(level)
    if level<35 then
        return {kind='rank',key='cooking_level',trainer=dirge,levelBlocked=true,requiredLevel=35,
            body=app.caption('trainer_level_first',35,level,app.professionName(185),225,300)}
    end
    if questCompleted() then
        return {kind='open',key='cooking_refresh',body=app.caption('cooking_refresh')}
    end
    local plan=app.cookingQuestPlan()
    if plan then
        local task=app.nextStep(plan)
        task.routePlan=plan
        if task.kind=='mail' then task.after=app.caption('cooking_visit') end
        if plan.unpricedQuestItem and app.shoppingFresh() and not app.purchasePending() then
            task={kind='quest_price',key='quest_price:'..plan.unpricedQuestItem,
                body=app.caption('cooking_no_offer',app.itemName(plan.unpricedQuestItem)),routePlan=plan}
        end
        return task
    end
    local accepted=app.try(C_QuestLog and C_QuestLog.IsOnQuest,6610)
    return {kind='quest_visit',key='quest6610:'..tostring(accepted),trainer=dirge,
        body=app.caption('cooking_quest')..' · '..app.caption(accepted and 'cooking_finish' or 'cooking_start')..'\n'..app.caption('cooking_visit')}
end
function app.nearestRankTrainer(profession,cap)
    if profession==185 and cap==225 then return app.copy(dirge) end
    local faction=app.playerFaction()
    local context=app.locationContext()
    local best
    local candidates={}
    for _,v in ipairs(app.trainerLocations or {})do candidates[#candidates+1]=v end
    for _,v in ipairs(app.observedRankTrainers and app.observedRankTrainers(profession,cap)or {})do candidates[#candidates+1]=v end
    for _,source in ipairs(candidates)do
        if source.profession==profession and source.fromCap==cap and app.validLocation(source)and (source.side=='Both'or source.side==faction)then
            if not best or app.locationBefore(source,best,context)then best=app.copy(source)end
        end
    end
    if best and app.lang()=='de'and best.nameDE then best.name=best.nameDE end
    return best
end
function app.rankTrainerTask()
    if app.atCookingQuestCap() then return cookingQuestTask(app.playerLevel()) end
    local p=app.active and app.active.profile
    local trainer=p and app.nearestRankTrainer(p.id,p.cap)
    local level=app.playerLevel()
    local blocked=trainer and trainer.level and trainer.level>0 and level>0 and level<trainer.level or false
    return {kind='rank',key='rank:'..tostring(p and p.id)..':'..tostring(p and p.cap)..':'..tostring(trainer and trainer.npc)..':'..tostring(blocked),trainer=trainer,levelBlocked=blocked,requiredLevel=trainer and trainer.level,
        body=blocked and app.caption('trainer_level_first',trainer.level,level,app.professionName(p.id),trainer.fromCap,trainer.toCap)or trainer and trainer.book and app.caption('trainer_book',trainer.name)or app.caption('goal_rank_task',app.nextActionLabel(app.nextActionBoundary()))}
end
function app.showRankTrainer(trainer)
    if not trainer then return false end
    local marked=app.markMerchant(trainer)
    if WorldMapFrame then
        app.try(WorldMapFrame.Show,WorldMapFrame)
        app.try(WorldMapFrame.SetMapID,WorldMapFrame,trainer.map)
        app.updateMerchantMarker(1)
    end
    app.flowLog('trainer.mark',{npc=trainer.npc,profession=trainer.profession,fromCap=trainer.fromCap,toCap=trainer.toCap,map=trainer.map,x=trainer.x,y=trainer.y,marked=marked})
    return marked
end
