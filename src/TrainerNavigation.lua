-- SPDX-License-Identifier: MIT
local _,app=...
-- Reuse independently recorded coordinates, never infer teaching from a rank.
local locations={}
local function add(row)
    if not app.validLocation(row)then return end
    local id=row.id or row.npc;if not id then return end
    locations[id]=locations[id]or {}
    for _,old in ipairs(locations[id])do if old.map==row.map and old.x==row.x and old.y==row.y then return end end
    local v=app.copy(row);v.id=id;v.kind='trainer';locations[id][#locations[id]+1]=v
end
for _,data in pairs(app.accessData)do for _,v in ipairs(data.routes or {})do if v.kind=='trainer'then add(v)end end end
for _,v in ipairs(app.trainerLocations)do add(v)end
-- Forever Copper Tube taught-by list + NPC location; reference, not live proof.
add({id=11031,name='Franklin Lloyd',side='Horde',map=1458,x=76,y=74,reference=true})
function app.extraTrainerSources(recipe)
    local rows={}
    for _,id in ipairs(app.trainerRecipeMembers[recipe.id]or {})do
        for _,v in ipairs(locations[id]or {})do local row=app.copy(v);row.reference=true;row.observed=nil;row.membership='ProfessionDB-1.9.1';rows[#rows+1]=row end
    end
    local records=app.character and app.character.trainerSources
    for _,v in pairs(records or {})do
        if v.recipes and v.recipes[recipe.id]then local row=app.copy(v);row.recipes=nil;rows[#rows+1]=row end
    end
    return rows
end
function app.recordTrainerSources(rows)
    if not app.character or app.craftRefreshBusy()then return end
    local context=app.locationContext();if not context.x or not context.y then return end
    local guid=app.try(UnitGUID,'npc')or ''
    local id=tonumber(guid:match('^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-'))
    local side=app.playerFaction();if not id or not side then return end
    local recipes={};local counts={}
    for _,r in ipairs(rows)do if r.id then counts[r.id]=(counts[r.id]or 0)+1 end end
    for _,r in ipairs(rows)do
        if r.id and counts[r.id]==1 and (r.kind=='used'or r.kind=='available'or r.kind=='unavailable')then recipes[r.id]=true end
    end
    if not next(recipes)then return end
    local v={id=id,npc=id,kind='trainer',name=app.try(UnitName,'npc')or app.caption('npc_number',id),side=side,map=context.map,x=context.x*100,y=context.y*100,recipes=recipes,observed=true,at=app.try(time)}
    if not app.validLocation(v)then return end
    app.character.trainerSources=app.character.trainerSources or {}
    -- Replace the actual visit's offer snapshot. Never union removed services.
    app.character.trainerSources[id..':'..context.map]=v
end
function app.observedRankTrainers(profession,cap)
    local rows={}
    -- Rank observations are supplied separately only after an exact identity
    -- has been established; a recipe teacher is never promoted to rank teacher.
    for _,v in pairs(app.character and app.character.trainerSources or {})do
        local id=app.routeRankSpells[profession]and app.routeRankSpells[profession][cap]
        if id and v.recipes[id]then
            for _,rank in ipairs(app.trainerLocations)do if rank.profession==profession and rank.fromCap==cap and not rank.book then
                local row=app.copy(rank);row.npc=v.id;row.name=v.name;row.nameDE=nil;row.map=v.map;row.x=v.x;row.y=v.y;row.side=v.side;row.observed=true;row.reference=nil;rows[#rows+1]=row;break
            end end
        end
    end
    return rows
end
