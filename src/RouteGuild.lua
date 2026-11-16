-- SPDX-License-Identifier: MIT
local _,app=...
local prefix='CDJRoute1'
local queue={};local lastSent=-100;local lastPublish=-100;local replies={};local peers={};local roster,shorts={},{};local rosterKey;app.guildRoutePeers=peers
local function now()return app.try(time)or 0 end
function app.routeGuildIdentity()
    local name,_,_,realm=app.try(GetGuildInfo,'player')
    if type(name)~='string'or name==''then return nil end
    return name..'@'..tostring(realm or app.try(GetRealmName)or '?')
end
function app.refreshRouteGuildRoster()
    roster={};shorts={}
    local signature={}
    local count=app.try(GetNumGuildMembers)or 0
    if count>1000 then return end
    for i=1,count do
        local name,_,_,_,_,_,_,_,online=app.try(GetGuildRosterInfo,i)
        if type(name)=='string'then
            roster[name]=online==true
            signature[#signature+1]=name..':'..tostring(online==true)
            local short=name:match('^[^-]+')
            if shorts[short]~=nil then shorts[short]=false else shorts[short]=name end
        end
    end
    table.sort(signature);local key=table.concat(signature,'|');local changed=key~=rosterKey;rosterKey=key;return changed
end
local function member(sender)
    if type(sender)~='string'or #sender>100 then return false end
    local key=roster[sender]~=nil and sender or shorts[sender]
    if type(key)=='string'then return true,roster[key]==true end
    return false
end
function app.setGuildRecipeSharing(enabled)
    if not enabled and app.options.guildRecipeSharing and app.guildShareScope==app.routeGuildIdentity()then
        local api=C_ChatInfo or {};app.try(api.SendAddonMessage or SendAddonMessage,prefix,'OFF','GUILD')
    end
    app.options.guildRecipeSharing=enabled==true
    app.guildShareScope=app.routeGuildIdentity();queue={};replies={};lastPublish=-100
    local saved=app.saved and app.saved.guildRecipeCache
    peers=enabled and saved and saved.scope==app.guildShareScope and saved.peers or {};app.guildRoutePeers=peers
    if app.saved then app.saved.guildRecipeCache={scope=app.guildShareScope,peers=peers}end
    local f=app.routeRuntimeFrame
    if f then
        if enabled then f:RegisterEvent('CHAT_MSG_ADDON');f:RegisterEvent('PLAYER_GUILD_UPDATE');f:RegisterEvent('GUILD_ROSTER_UPDATE')
        else f:UnregisterEvent('CHAT_MSG_ADDON');f:UnregisterEvent('PLAYER_GUILD_UPDATE');f:UnregisterEvent('GUILD_ROSTER_UPDATE')end
    end
    if enabled and app.guildShareScope then
        local api=C_ChatInfo or {}
        app.try(api.RegisterAddonMessagePrefix or RegisterAddonMessagePrefix,prefix)
        app.refreshRouteGuildRoster()
        app.publishGuildRecipes()
        queue[#queue+1]='Q'
        if f then f:Show()end
    end
end
function app.requestGuildRouteRecipes()
    if not app.options.guildRecipeSharing or not app.routeGuildIdentity()then return false end
    app.try(C_GuildInfo and C_GuildInfo.GuildRoster or GuildRoster)
    app.refreshRouteGuildRoster()
    if #queue<30 then queue[#queue+1]='Q'end
    if app.routeRuntimeFrame then app.routeRuntimeFrame:Show()end
    return true
end
function app.publishGuildRecipes()
    if not app.options.guildRecipeSharing or not app.guildShareScope or app.guildShareScope~=app.routeGuildIdentity()then return end
    if now()-lastPublish<30 then return end
    lastPublish=now()
    -- Only this logged-in character's confirmed whitelisted recipe IDs and
    -- profession skill. Inventory, gold, bank and terms are NEVER serialized.
    for profession,p in pairs(app.character.routeProfessions or {})do
        for id,r in pairs(p.recipes or {})do
            if r.learned and r.confirmed and r.outputFromClient and app.guildCraftAllowed(r.outputItemID)and app.routeTransferable(r.outputItemID)then
                local text=table.concat({'R',profession,p.skill,id,r.outputItemID,r.outputMin or 0,p.at or 0},'|')
                if #text<=220 and #queue<30 then queue[#queue+1]=text end
            end
        end
    end
    if app.routeRuntimeFrame and #queue>0 then app.routeRuntimeFrame:Show()end
end
function app.guildRouteTick()
    if #queue==0 then return false end
    if not app.options.guildRecipeSharing or not app.guildShareScope or app.guildShareScope~=app.routeGuildIdentity()then queue={};return false end
    local t=app.try(GetTime)or 0
    if t-lastSent<.25 then return true end
    lastSent=t
    local api=C_ChatInfo or {};local fn=api.SendAddonMessage or SendAddonMessage
    if type(fn)=='function'then app.try(fn,prefix,table.remove(queue,1),'GUILD')else queue={}end
    return #queue>0
end
function app.receiveGuildRouteMessage(p,text,channel,sender)
    if not app.options.guildRecipeSharing or p~=prefix or channel~='GUILD'or type(text)~='string'or #text>220 then return false end
    local scope=app.routeGuildIdentity()
    if scope~=app.guildShareScope then app.setGuildRecipeSharing(app.options.guildRecipeSharing);return false end
    local valid,online=member(sender);if not valid then return false end
    if text=='OFF'then peers[sender]=nil;if app.invalidateRoute then app.invalidateRoute('guild_opt_out')end;return true end
    if text=='Q'then
        if not replies[sender]or now()-replies[sender]>=30 then replies[sender]=now();app.publishGuildRecipes()end
        return true
    end
    local prof,skill,spell,item,quantity,observed=text:match('^R|(%d+)|(%d+)|(%d+)|(%d+)|(%d+)|(%d+)$')
    prof,skill,spell,item,quantity,observed=tonumber(prof),tonumber(skill),tonumber(spell),tonumber(item),tonumber(quantity),tonumber(observed)
    if not prof or not app.supported[prof]or skill<1 or skill>450 or not app.guildCraftAllowed(item)or quantity~=1 then return false end
    if not observed or observed>now()+60 then return false end
    local ref=(app.catalog[prof]or {})[spell];local identity=app.guildCraftRecipes[spell]
    if not identity or identity.item~=item or identity.profession~=prof or not ref or not ref.ingredients or not ref.skill or ref.skill>skill then return false end
    local who=peers[sender]or {recipes={},window=now(),messages=0,guild=scope}
    if now()-who.window>=60 then who.window=now();who.messages=0 end
    who.messages=who.messages+1;if who.messages>30 then return false end
    local old=who.recipes[item]
    if old and old.id==spell and old.skill==skill and old.at==observed and who.online==online then return true end
    who.online=online;who.at=now()
    local old=who.recipes[item]
    if old and old.id==spell and old.skill==skill and old.at==observed then return true end
    who.recipes[item]={id=spell,profession=prof,skill=skill,item=item,output=quantity,inputs=app.copy(ref.ingredients),at=observed}
    peers[sender]=who
    if app.invalidateRoute then app.invalidateRoute('guild_recipe')end
    return true
end
function app.guildProviderSnapshot()
    local rows={};local scope=app.routeGuildIdentity()
    if not app.options.guildRecipeSharing or scope~=app.guildShareScope then return rows end
    for name,who in pairs(peers)do
        local valid,online=member(name)
        if valid and who.guild==scope then
            for item,r in pairs(who.recipes)do
                rows[#rows+1]={kind='guild',name=name,key='guild:'..name..':'..r.id,recipe=r.id,profession=r.profession,
                    skill=r.skill,item=item,output=r.output,inputs=r.inputs,at=r.at,guild=scope,online=online,confirmed=true,
                    transferable=app.routeTransferable(item)}
            end
        end
    end
    return rows
end
function app.openGuildCraftWhisper(provider,item,n)
    local valid=provider and member(provider.name)
    if not valid or provider.guild~=app.routeGuildIdentity()or not app.guildCraftAllowed(item)then return false end
    local text=app.caption('route_whisper',app.itemName(item),n)
    if type(ChatFrame_OpenChat)~='function'then return false end
    ChatFrame_OpenChat('/w '..provider.name..' '..text)
    return true -- draft only; the player sends it
end
