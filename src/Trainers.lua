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
function app.nearestRankTrainer(profession,cap)
    local faction=app.playerFaction()
    local map=app.try(C_Map and C_Map.GetBestMapForUnit,'player')
    local position=map and app.try(C_Map and C_Map.GetPlayerMapPosition,map,'player')
    local x,y
    if position then x,y=app.try(position.GetXY,position)end
    if not x and position then x,y=position.x,position.y end
    local best,score
    for _,source in ipairs(app.trainerLocations or {})do
        if source.profession==profession and source.fromCap==cap and (source.side=='Both'or source.side==faction)then
            local same=source.map==map
            local distance=same and x and y and ((source.x-x*100)^2+(source.y-y*100)^2)or 10000
            local value=(same and 0 or 100000)+distance
            if not score or value<score then best=app.copy(source);score=value end
        end
    end
    if best and app.lang()=='de'and best.nameDE then best.name=best.nameDE end
    return best
end
function app.rankTrainerTask()
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
