-- SPDX-License-Identifier: MIT
local _,app=...
local announced={}
local function currentPosition()
    local map=app.try(C_Map and C_Map.GetBestMapForUnit,'player')
    local pos=map and app.try(C_Map and C_Map.GetPlayerMapPosition,map,'player')
    local x,y
    if pos then x,y=app.try(pos.GetXY,pos)end
    if not x and pos then x,y=pos.x,pos.y end
    return map,x and x*100,y and y*100
end
function app.recordMerchant(offers)
    local map,x,y=currentPosition()
    if not map or not x or not y or not next(offers)then return end
    local guid=app.try(UnitGUID,'npc')or ''
    local npc=tonumber(guid:match('^[^-]+%-[^-]+%-[^-]+%-[^-]+%-[^-]+%-(%d+)%-'))or 0
    local name=app.try(UnitName,'npc')or app.caption('origin_vendor')
    local identity=app.character.identity
    if not identity then return end
    app.saved.merchants=app.saved.merchants or {}
    app.saved.merchants[identity.realm]=app.saved.merchants[identity.realm]or {}
    local key=(npc>0 and tostring(npc)or name)..':'..map
    app.saved.merchants[identity.realm][key]={npc=npc,name=name,map=map,x=x,y=y,
        side=app.playerFaction()or 'Unknown',offers=offers,when=app.try(time),observed=true}
end
function app.nearestMerchant(item)
    local map,x,y=currentPosition();local faction=app.playerFaction()
    local candidates={}
    for _,v in ipairs((app.vendorLocations or {})[item]or {})do candidates[#candidates+1]=v end
    local realm=app.character and app.character.identity and app.character.identity.realm
    for _,v in pairs(app.saved and app.saved.merchants and app.saved.merchants[realm]or {})do
        if v.offers and v.offers[item]then candidates[#candidates+1]=v end
    end
    local best,bestScore
    for _,source in ipairs(candidates)do
        if source.side=='Both'or source.side==faction then
            local v=app.copy(source)
            v.sameMap=map~=nil and v.map==map
            v.distance=v.sameMap and x and y and ((v.x-x)^2+(v.y-y)^2)or nil
            v.nearby=v.distance~=nil and v.distance<=225 -- map-relative proximity, not path distance
            local score=(v.sameMap and 0 or 100000)+(v.distance or 10000)+(v.observed and -0.001 or 0)
            if not bestScore or score<bestScore then best,bestScore=v,score end
        end
    end
    return best
end
function app.merchantLocation(v)
    local info=app.try(C_Map and C_Map.GetMapInfo,v.map)
    return app.caption('merchant_place',info and info.name or ('Map '..v.map),v.x,v.y)
end
function app.announceMerchants(plan)
    if not plan then return end
    local now=app.try(time)or 0
    for _,row in ipairs(plan.rows)do
        local v=row.buy>0 and row.vendorUnit and app.nearestMerchant(row.id)
        if v and v.nearby then
            local key=(v.npc or v.name)..':'..v.map
            if not announced[key]or now-announced[key]>=300 then
                announced[key]=now
                if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage('|cffd8b966CraftDeja:|r '..app.caption('merchant_announce',v.name,app.merchantLocation(v))..(v.reference and ' '..app.caption('merchant_reference')or ''))end
            end
        end
    end
end
function app.markMerchant(v)
    local custom=app.setMerchantMarker and app.setMerchantMarker(v)
    local can=app.try(C_Map and C_Map.CanSetUserWaypointOnMap,v.map)
    local create=UiMapPoint and UiMapPoint.CreateFromCoordinates
    if can~=false and type(create)=='function'and C_Map and type(C_Map.SetUserWaypoint)=='function'then
        local point=app.try(create,v.map,v.x/100,v.y/100)
        if point then
            local ok=pcall(C_Map.SetUserWaypoint,point)
            if ok then
                app.try(C_SuperTrack and C_SuperTrack.SetSuperTrackedUserWaypoint,true)
                if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(app.caption('merchant_marked',v.name,app.merchantLocation(v)))end
                return true
            end
        end
    end
    if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(app.caption(custom and 'merchant_custom_pin'or 'merchant_no_pin',app.merchantLocation(v)))end
    return custom or false
end
