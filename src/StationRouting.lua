-- SPDX-License-Identifier: MIT
local _,app=...
local text={de={station_unknown='Für %s ist auf dieser Karte/Ebene noch kein verifizierter, zugänglicher Standort hinterlegt.',station_observed='Bestätigter Arbeitsbereich: %s\n%s · %s\n%.1f, %.1f (Position beim erfüllten Rezept)',station_note='Standort zuletzt vom Client bestätigt. Zugang vor Ort prüfen; kein berechneter Laufweg.',station_expired='Kein aktueller Standortnachweis. Die konkrete Rezeptvoraussetzung bleibt erforderlich.'},en={station_unknown='No verified accessible location for %s is recorded on this map/floor yet.',station_observed='Confirmed crafting area: %s\n%s · %s\n%.1f, %.1f (position when the recipe requirement was met)',station_note='Location last confirmed by the client. Check access on arrival; not a calculated walking route.',station_expired='No current location evidence. The exact recipe requirement still applies.'}}
for lang,t in pairs(text)do for k,v in pairs(t)do app.words[lang][k]=v end end
local function stamp()return app.try(time)or 0 end
function app.stationContext()
    local c=app.locationContext()
    local group=app.try(C_Map and C_Map.GetMapGroupID,c.map)
    c.floor=0
    for _,r in ipairs(group and app.try(C_Map.GetMapGroupMembersInfo,group)or {})do if r.mapID==c.map then c.floor=r.floorIndex or 0 end end
    local _,_,_,instance=app.try(UnitPosition,'player');c.instance=instance or 0
    local _,_,_,interface=app.try(GetBuildInfo);c.interface=interface
    return c
end
function app.stationRequirementKey(requirement)
    if not requirement then return end
    local t=Enum and Enum.RecipeRequirementType or {}
    if requirement.type~=t.SpellFocus and requirement.type~=t.Area then return end
    local name=requirement.name
    if type(name)~='string'or name:match('^%s*$')then return end
    local kind=app.craftStationKind and app.craftStationKind(requirement)
    -- A special named focus never borrows the coordinates of a generic lab.
    return tostring(requirement.type)..':'..tostring(requirement.spellID or requirement.id or kind or name:match('^%s*(.-)%s*$'):lower())
end
function app.observeCraftStations(recipe,requirements)
    if not app.character then return end
    local confirmed=false
    for _,r in ipairs(requirements)do if r.met==true and app.stationRequirementKey(r)then confirmed=true;break end end
    if not confirmed then return end
    local c=app.stationContext()
    if c.interface~=16001 or not c.map or not c.x or not c.y then return end
    local store=app.character.craftStations or {};app.character.craftStations=store
    local now=stamp()
    for _,r in ipairs(requirements)do
        local key=r.met==true and app.stationRequirementKey(r)
        if key then
            local id=table.concat({key,c.map,c.floor,c.instance,math.floor(c.x*1000),math.floor(c.y*1000)},':')
            local old=store[id]
            if not old or now-old.at>=60 then
                local kind=app.craftStationKind and app.craftStationKind(r)
                -- Fire/lab/unknown foci may be temporary camp objects. Never
                -- retain them as permanent world locations.
                local ttl=(kind=='anvil'or kind=='forge'or kind=='furnace')and 3600 or 120
                store[id]={key=key,name=r.name,map=c.map,x=c.x*100,y=c.y*100,floor=c.floor,instance=c.instance,
                    side=app.playerFaction(),interface=c.interface,verified=true,at=now,expires=now+ttl,
                    district=app.try(GetSubZoneText)or '',recipe=recipe.id,proof='native_recipe_requirement_met'}
            end
        end
    end
    local count=0;local oldest,at
    for k,v in pairs(store)do
        if not v.expires or v.expires<=now then store[k]=nil
        else count=count+1;if not at or v.at<at then oldest,at=k,v.at end end
    end
    if count>100 and oldest then store[oldest]=nil end
end
function app.stationRouteDistance(row,c)
    if row.blocked or row.reachable==false or not app.validLocation(row)then return end
    if row.map~=c.map or (row.floor or 0)~=c.floor or (row.instance or 0)~=c.instance then return end
    -- There is no native pathfinding API here. Only compare confirmed points
    -- in the current map/floor/instance; do not guess a route through portals,
    -- closed areas or another dungeon layer from map percentages.
    local rank,distance=app.locationScore(row,c)
    return rank,distance
end
function app.nearestCraftStation(requirement)
    local key=app.stationRequirementKey(requirement);if not key then return end
    local c=app.stationContext();local best,rank,distance
    local faction=app.playerFaction();local now=stamp()
    for _,r in pairs(app.character and app.character.craftStations or {})do
        if r.verified==true and r.proof=='native_recipe_requirement_met'and r.key==key and r.interface==c.interface and
            r.expires and r.expires>now and (r.side=='Both'or faction and r.side==faction)then
            local ar,ad=app.stationRouteDistance(r,c)
            if ar and (not rank or ar<rank or ar==rank and ad<distance)then best,rank,distance=r,ar,ad end
        end
    end
    return best and app.copy(best)
end
function app.decorateStationTask(task)
    local station=app.nearestCraftStation(task.requirement);task.station=station
    if station then
        local info=app.try(C_Map and C_Map.GetMapInfo,station.map)
        task.body=task.body..'\n'..app.caption('station_observed',station.name,info and info.name or tostring(station.map),station.district or '',station.x,station.y)..'\n'..app.caption('station_note')
        task.key=task.key..':'..station.map..':'..station.x..':'..station.y..':'..(station.floor or 0)
    else task.body=task.body..'\n'..app.caption('station_unknown',task.requirement.name or '?')end
    return task
end
function app.clearGuideMarker(field)
    local own=app.mapTarget or app.character and app.character.mapTarget
    if not own or not own[field] then return end
    local point=app.try(C_Map and C_Map.GetUserWaypoint)
    local x,y
    if point and point.position then x,y=app.try(point.position.GetXY,point.position);x=x or point.position.x;y=y or point.position.y end
    if point and point.uiMapID==own.map and x and y and math.abs(x-own.x/100)<.00001 and math.abs(y-own.y/100)<.00001 then
        app.try(C_Map and C_Map.ClearUserWaypoint)
    end
    app.mapTarget=nil;if app.character then app.character.mapTarget=nil end
    if app.mapPin then app.mapPin:Hide()end
end
function app.clearStationMarker() app.clearGuideMarker('stationKey') end
function app.showCraftStation(task,openMap)
    if not task or not task.station then return false end
    local v=app.copy(task.station);v.stationKey=task.key
    local marked=app.markMerchant(v)
    if openMap and WorldMapFrame then app.try(WorldMapFrame.Show,WorldMapFrame);app.try(WorldMapFrame.SetMapID,WorldMapFrame,v.map)end
    app.updateMerchantMarker(1)
    app.flowLog('station.mark',{recipe=task.recipe and task.recipe.id,map=v.map,x=v.x,y=v.y,floor=v.floor,proof=v.proof})
    return marked
end
