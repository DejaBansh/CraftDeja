-- SPDX-License-Identifier: MIT
local _,app=...
local function valid(n)return type(n)=='number'and n==n and n>=0 and n<math.huge and n==math.floor(n)end
local function clock()return app.try(time)or 0 end
local words={en={acquisition_fee='One-time learning/recipe cost: %s (%s).',acquisition_unknown='Learning/recipe cost unknown: check the source before treating this as a cheaper route.',acquisition_owned='Recipe already learned or recipe item already owned: no additional acquisition payment.',acquisition_check='Check learning cost',acquisition_route='Comparison to skill %d: %s with learning, %s using known recipes. Model estimate; other unknown recipes/travel/tools excluded.'},de={acquisition_fee='Einmalige Lern-/Rezeptkosten: %s (%s).',acquisition_unknown='Lern-/Rezeptkosten unbekannt: Quelle prüfen, bevor dies als günstigere Route gilt.',acquisition_owned='Rezept bereits gelernt oder Rezeptgegenstand vorhanden: kein zusätzlicher Erwerbsbetrag.',acquisition_check='Lernkosten prüfen',acquisition_route='Vergleich bis Skill %d: %s mit Lernen, %s mit bekannten Rezepten. Modellschätzung; andere unbekannte Rezepte/Reise/Werkzeuge ausgeschlossen.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
function app.observeLearningCost(id,cost,source)
    if not app.character or not valid(id)or id<1 or not valid(cost)then return false end
    app.character.learningCosts=app.character.learningCosts or {}
    local old=app.character.learningCosts[id]
    app.character.learningCosts[id]={cost=cost,source=source or 'trainer',at=clock()}
    return not old or old.cost~=cost or type(old.at)~='number'or clock()<old.at or clock()-old.at>604800
end
-- Explicit user-observed trainer/recipe/item relationship, not a name guess.
-- Extend only with a concrete trainer-offer observation. Fees stay live data.
local linklessOffers={[11071]={[7771]=6345}} -- Mot Dawnstrider
local function serviceKey(name,rank)
    if type(name)~='string'or name==''or rank~=nil and type(rank)~='string'then return end
    return name..'\001'..(rank or '')
end
local serviceKinds={available=true,unavailable=true,used=true,header=true}
local function trainerIdentity(index)
    local name,second,third=app.try(GetTrainerServiceInfo,index)
    -- Legacy: name, rank, status. Forever 1.60.1: name, status, iconID.
    if serviceKinds[third]and (second==nil or type(second)=='string')then return name,second,third,true end
    if serviceKinds[second]and (third==nil or type(third)=='number')then return name,nil,second,false end
    return name,nil,nil,false
end
local function modernSpellIdentity(info,id)
    if type(info)=='table'and type(info.name)=='string'and info.name~=''and (info.spellID==nil or info.spellID==id)then return info.name end
end
local function spellIdentity(id,ranked)
    if not ranked then
        local info=app.try(C_Spell and C_Spell.GetSpellInfo,id)
        if info~=nil then return modernSpellIdentity(info,id)end
    end
    local name,rank=app.try(GetSpellInfo,id)
    if type(name)=='string'and name~=''and (not ranked or rank==nil or type(rank)=='string')then return name,ranked and rank or nil end
    if ranked then return modernSpellIdentity(app.try(C_Spell and C_Spell.GetSpellInfo,id),id)end
end
local function linklessRecipe(row,rows)
    if row.link~=nil or row.kind~='available'and row.kind~='unavailable'then return end
    local guid=app.try(UnitGUID,'npc')
    local npc=type(guid)=='string'and tonumber(guid:match('^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-'))
    local offers=npc and linklessOffers[npc]
    local key=serviceKey(row.name,row.rank)
    if not offers or not key then return end
    -- Even identical duplicate rows are ambiguous. Never select the first one.
    for _,other in ipairs(rows)do
        if other~=row and other.name==row.name and (not row.ranked or not other.ranked or serviceKey(other.name,other.rank)==key)then return end
    end
    local matched
    for id,item in pairs(offers)do
        local recipe=(app.catalog[333]or {})[id]
        local name,rank=spellIdentity(id,row.ranked)
        if recipe and recipe.scroll==item and serviceKey(name,rank)==key then
            if matched then return end
            matched=id
        end
    end
    if not matched then return end
    local seen={}
    local language=app.try(GetLocale)=='deDE'and 'de'or 'en'
    local names=app.names[language]or {}
    for _,recipes in pairs(app.catalog)do for id,recipe in pairs(recipes)do
        if id~=matched and not seen[id]then
            seen[id]=true
            local name,rank=spellIdentity(id,row.ranked)
            if serviceKey(name,rank)==key or not name and names[id]==row.name then return end
        end
    end end
    return matched
end
function app.observeTrainerCosts()
    if not app.character or app.craftRefreshBusy and app.craftRefreshBusy()then return false end
    local count=app.try(GetNumTrainerServices)
    if not valid(count)or count>1000 then return false end
    local changed=false
    local rows={}
    for i=1,count do
        local link=app.try(GetTrainerServiceItemLink,i)
        local name,rank,kind,ranked=trainerIdentity(i)
        local cost=app.try(GetTrainerServiceCost,i)
        rows[#rows+1]={link=link,name=name,rank=rank,kind=kind,ranked=ranked,cost=cost}
    end
    for _,row in ipairs(rows)do
        local id=type(row.link)=='string'and tonumber(row.link:match('spell:(%d+)')or row.link:match('enchant:(%d+)'))
        if not id and valid(row.cost)then id=linklessRecipe(row,rows)end
        if id and valid(row.cost)and app.observeLearningCost(id,row.cost,'trainer')then changed=true end
    end
    if changed then app.flowLog('acquisition.trainer_observed',{});app.refresh(false)end
    return changed
end
function app.acquisitionQuote(recipe,memo)
    if recipe.learned then return {cost=0,known=true,source='learned'}end
    if memo and memo[recipe.id]then return memo[recipe.id]end
    local q={known=false,source='unknown'}
    local row=app.character and app.character.learningCosts and app.character.learningCosts[recipe.id]
    if row and valid(row.cost)and type(row.at)=='number'and clock()>=row.at and clock()-row.at<=604800 then
        q={cost=row.cost,known=true,source=row.source or 'trainer',observedAt=row.at}
    end
    local data=app.accessInfo and app.accessInfo(recipe)or {}
    local item=data.item or recipe.scroll
    if item then
        local inventory=app.inventoryFor(item)
        if inventory and type(inventory.total)=='number'and inventory.total>=1 then q={cost=0,known=true,source='owned_recipe',item=item}
        else
            local price,provider=app.unitPrice(item,{})
            if valid(price)and (not q.known or price<q.cost)then q={cost=price,known=true,source=provider or 'recipe_item',item=item,estimated=true}end
        end
    end
    if memo then memo[recipe.id]=q end
    return q
end
-- Expected net cost to the candidate's grey limit / skill cap. One additional
-- recipe, all already-known alternatives; learning is paid once, never per cast.
function app.learningAssessment(snapshot,recipe,level)
    snapshot.learningRoutes=snapshot.learningRoutes or {}
    local routes=snapshot.learningRoutes[recipe.id]
    if not routes then
        local fee=app.acquisitionQuote(recipe,snapshot.acquisition)
        if not fee.known then return {known=false}end
        if recipe.rangeConflict or recipe.craftLimit~=nil then return {known=false,fee=fee,unsupported=true}end
        local target=math.min(snapshot.profile.cap,(not app.options.green and recipe.green)or recipe.grey or level+1)
        local known,unlocked,first={},{},{}
        known[target]=0;unlocked[target]=0
        local function edge(r,at)
            local q=snapshot.quotes[r.id];local access=snapshot.eligibility and snapshot.eligibility[r.id]
            local allowed=access and access.allowed
            if not access then allowed=app.canRecommend(r)end
            if not allowed or not r.confirmed or not q or r.disabled or r.cooldown or r.noSkill or r.craftLimit~=nil or r.rangeConflict then return end
            if not r.learned and (r.referenceHidden or r.skill and at<r.skill)then return end
            local p,colour=app.probability(r,at,at==snapshot.profile.skill)
            if p<=0 or colour=='green'and not app.options.green then return end
            return (q.netCost or q.cost)/p,math.min(target,at+(r.points or 1))
        end
        for at=target-1,snapshot.profile.skill,-1 do
            local best,with,choice=math.huge,math.huge,nil
            for _,r in pairs(snapshot.recipes)do if r.learned then
                local cost,next= edge(r,at)
                if cost then
                    best=math.min(best,cost+(known[next]or math.huge))
                    local total=cost+(unlocked[next]or math.huge)
                    if total<with then with=total;choice=r.id end
                end
            end end
            local cost,next=edge(recipe,at)
            if cost then
                local total=cost+(unlocked[next]or math.huge)
                if total<with then with=total;choice=recipe.id end
            end
            known[at]=best;unlocked[at]=with;first[at]=choice
        end
        routes={fee=fee,target=target,known=known,unlocked=unlocked,first=first}
        snapshot.learningRoutes[recipe.id]=routes
    end
    local baseline=routes.known[level]or math.huge
    local total=(routes.unlocked[level]or math.huge)+routes.fee.cost
    return {known=true,fee=routes.fee,target=routes.target,total=total,baseline=baseline,
        worth=total<baseline-.000001 and routes.first[level]==recipe.id}
end
local f=CreateFrame('Frame')
for _,event in ipairs({'TRAINER_SHOW','TRAINER_UPDATE','TRAINER_SERVICE_INFO_NAME_UPDATE'})do app.try(f.RegisterEvent,f,event)end
f:SetScript('OnEvent',function()app.observeTrainerCosts()end)
