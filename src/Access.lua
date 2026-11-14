-- SPDX-License-Identifier: MIT
local _,app=...

function app.playerFaction()
    local faction=app.try(UnitFactionGroup,'player')
    return (faction=='Alliance'or faction=='Horde')and faction or nil
end

function app.accessInfo(recipe)
    return(app.accessData or {})[recipe.id]or {access='Unknown',audit='missing'}
end

function app.canRecommend(recipe)
    local data=app.accessInfo(recipe);local player=app.playerFaction()
    if data.use and data.use~='Both'and data.use~=player then return false,'faction_blocked'end
    -- A faction-exclusive source does not invalidate a tradeable recipe already learned.
    if recipe.learned then return true,'known'end
    if data.access=='Both'or (player and data.access==player)then return true,'available'end
    if data.access=='Alliance'or data.access=='Horde'then return false,'faction_source_blocked'end
    if app.options.unverifiedSources then return true,'access_unknown'end
    return false,'access_unknown'
end

function app.accessLabel(recipe)
    local data=app.accessInfo(recipe)
    if data.use and data.use~='Both'then return app.caption('faction_use',app.caption('faction_'..data.use))end
    return app.caption('faction_access',app.caption('faction_'..(data.access or 'Unknown')))
end

function app.recipeURL(recipe)
    local data=app.accessInfo(recipe)
    local item=data.item or recipe.scroll
    return item and app.entityURL('item',item)or app.url(recipe.id)
end

function app.entityURL(kind,id)
    return 'https://www.wowhead.com/forever/'..(app.lang()=='de'and 'de/'or '')..kind..'='..tostring(id)
end

function app.sourceList(recipe)
    local data=app.accessInfo(recipe);local player=app.playerFaction();local list={}
    local seen={}
    local function add(row)
        local key=table.concat({tostring(row.kind),tostring(row.id),tostring(row.map),tostring(row.x),tostring(row.y)},':')
        if seen[key]then return end
        seen[key]=true;list[#list+1]=row
        if row.giver then add({kind='questgiver',id=row.giver,name=row.giverName,side=row.side,map=row.map,x=row.x,y=row.y,reference=row.reference})end
    end
    for _,row in ipairs(data.routes or {})do add(row)end
    for _,row in ipairs((app.recipeSourceCorrections or {})[recipe.id]or {})do add(row)end
    -- The detail list should agree with routing: own/neutral faction, current
    -- map, then comparable local distance. No cross-map distance is invented.
    local map=app.try(C_Map and C_Map.GetBestMapForUnit,'player')
    local pos=map and app.try(C_Map and C_Map.GetPlayerMapPosition,map,'player')
    local x,y
    if pos then x,y=app.try(pos.GetXY,pos);if not x then x,y=pos.x,pos.y end end
    local function localScore(row)
        if not map or row.map~=map then return 100000 end
        if type(x)=='number'and x==x and x>=0 and x<=1 and type(y)=='number'and y==y and y>=0 and y<=1
            and type(row.x)=='number'and row.x>=0 and row.x<=100 and type(row.y)=='number'and row.y>=0 and row.y<=100 then
            return (row.x-x*100)^2+(row.y-y*100)^2
        end
        return 30000
    end
    local function rank(row)
        if row.side=='Both'or row.side==player then return 1 end
        if row.side==nil or row.side=='Unknown'then return 2 end
        return 3
    end
    table.sort(list,function(a,b)
        if rank(a)~=rank(b)then return rank(a)<rank(b)end
        local left,right=localScore(a),localScore(b)
        if left~=right then return left<right end
        if a.kind~=b.kind then return a.kind<b.kind end
        if (a.id or 0)~=(b.id or 0)then return(a.id or 0)<(b.id or 0)end
        if (a.map or 0)~=(b.map or 0)then return(a.map or 0)<(b.map or 0)end
        if (a.x or 0)~=(b.x or 0)then return(a.x or 0)<(b.x or 0)end
        return(a.y or 0)<(b.y or 0)
    end)
    return list
end

function app.sourceURL(source)
    local kind=source.kind=='quest'and 'quest'or(source.kind=='object'and 'object'or 'npc')
    return app.entityURL(kind,source.id)
end

function app.nextRecipe()
    local plan=app.decision
    local candidate=plan and plan.followup and plan.followup.candidate
    if candidate and candidate.recipe.id~=plan.current.recipe.id then return candidate.recipe end
end

function app.sourceTitle(source)
    local name=source.name
    if source.kind=='quest'then name=app.try(C_QuestLog and C_QuestLog.GetTitleForQuestID,source.id)or name end
    return name or app.caption(source.kind=='quest'and 'quest_number'or 'npc_number',source.id)
end

function app.sourcePlace(source)
    if not source.map then return ''end
    local info=app.try(C_Map and C_Map.GetMapInfo,source.map)
    local name=type(info)=='table'and info.name or app.caption('map_number',source.map)
    if source.x and source.y then return string.format('%s (%.1f, %.1f)',name,source.x,source.y)end
    return name
end
