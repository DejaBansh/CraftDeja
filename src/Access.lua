-- SPDX-License-Identifier: MIT
local _,app=...

-- Merge reference categories once, before recipe views are constructed.
for spell,rows in pairs(app.ofaRecipeSources)do
    local data=app.accessData[spell]
    if data then
        local kinds,sides={},{}
        local categories={}
        for _,kind in ipairs(data.categories or {})do kinds[kind]=true;categories[#categories+1]=kind end
        for _,row in ipairs(rows)do
            if not kinds[row.kind]then
                kinds[row.kind]=true;categories[#categories+1]=row.kind
            end
            if row.kind=='vendor'then sides[row.side]=true end
        end
        data.categories=categories
        data.referenceSources=true
        if data.access=='Unknown' then
            if sides.Both or (sides.Alliance and sides.Horde) then data.access='Both'
            elseif sides.Alliance then data.access='Alliance'
            elseif sides.Horde then data.access='Horde' end
        end
    end
end

function app.playerFaction()
    local faction=app.try(UnitFactionGroup,'player')
    return (faction=='Alliance'or faction=='Horde')and faction or nil
end

function app.accessInfo(recipe)
    local data=(app.accessData or {})[recipe.id]or {access='Unknown',audit='missing'}
    local item=app.ofaRecipeItems[recipe.id]
    if item and not data.item and not recipe.scroll then
        local enriched=app.copy(data)
        enriched.item=item
        return enriched
    end
    return data
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
    local disputed=app.disputedTrainerHints[recipe.id]
    local function add(row)
        if row.kind=='trainer' and disputed and disputed[row.id] and not row.observed then return end
        local teachers=app.foreverTeacherLists[recipe.id]
        if row.kind=='trainer' and teachers and not teachers[row.id] and not row.observed then return end
        local key=table.concat({tostring(row.kind),tostring(row.id),tostring(row.map),tostring(row.x),tostring(row.y)},':')
        if seen[key]then return end
        seen[key]=true;list[#list+1]=row
        if row.giver then add({kind='questgiver',id=row.giver,name=row.giverName,side=row.side,map=row.map,x=row.x,y=row.y,reference=row.reference})end
    end
    local extra=app.extraTrainerSources and app.extraTrainerSources(recipe)or {}
    for _,row in ipairs(extra)do if row.observed then add(row)end end
    local realm=app.character and app.character.identity and app.character.identity.realm
    local item=data.item or recipe.scroll
    if item and realm then
        for _,v in pairs(app.saved and app.saved.merchants and app.saved.merchants[realm]or {})do
            if v.npc and v.npc>0 and ((v.offers and v.offers[item]) or (v.recipeOffers and v.recipeOffers[item]))then
                add({kind='vendor',id=v.npc,name=v.name,side=v.side,map=v.map,x=v.x,y=v.y,observed=true})
            end
        end
    end
    for _,row in ipairs((app.recipeSourceCorrections or {})[recipe.id]or {})do add(row)end
    for _,row in ipairs(data.routes or {})do add(row)end
    for _,row in ipairs(app.ofaRecipeSources[recipe.id]or {})do add(row)end
    for _,row in ipairs(extra)do if not row.observed then add(row)end end
    -- The detail list should agree with routing: own/neutral faction, current
    -- map, then comparable local distance. No cross-map distance is invented.
    local context=app.locationContext()
    local function rank(row)
        if row.side=='Both'or row.side==player then return 1 end
        if row.side==nil or row.side=='Unknown'then return 2 end
        return 3
    end
    table.sort(list,function(a,b)
        if rank(a)~=rank(b)then return rank(a)<rank(b)end
        if app.locationBefore(a,b,context)then return true end
        if app.locationBefore(b,a,context)then return false end
        return(a.kind or '')<(b.kind or '')
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
