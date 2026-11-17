-- SPDX-License-Identifier: MIT
local _,app=...
local numericBands={[0]="orange",[1]="yellow",[2]="green",[3]="grey"}
local namedBands={optimal="orange",medium="yellow",easy="green",trivial="grey",difficult="orange"}
local function itemID(link)return type(link)=="string"and tonumber(link:match("item:(%d+)"))or nil end

-- Refresh only the running recipe. A skill event during a native batch must
-- not enumerate/audit every recipe or rebuild the economic route.
function app.readCraftProgress(recipe,profile,oldLevel)
    if not recipe then return end
    local api=C_TradeSkillUI or {}
    local info=app.try(api.GetRecipeInfo,recipe.id)
    if type(info)~='table'then return end
    local colour=numericBands[info.relativeDifficulty]or namedBands[info.difficulty]
    if colour and recipe.colour and colour~=recipe.colour and profile.skill==oldLevel+1 then
        local field=colour=='yellow'and 'yellow'or colour=='green'and 'green'or colour=='grey'and 'grey'
        if field then
            local saved=app.character.transitions
            saved[profile.id]=saved[profile.id]or {};saved[profile.id][recipe.id]=saved[profile.id][recipe.id]or {}
            saved[profile.id][recipe.id][field]=profile.skill;recipe[field]=profile.skill;recipe.observed=true
        end
    end
    recipe.colour=colour or recipe.colour;recipe.disabled=info.disabled==true
    recipe.noSkill=info.canSkillUp==false and recipe.learned
    if colour then recipe.rangeConflict=app.band(recipe,profile.skill)~=colour end
end

-- Visibility is only a permission to read the native profession, never proof
-- that its recipe API has finished loading. No recipe API is queried here.
function app.nativeProfessionVisible()
    local known=false
    for _,name in ipairs({'ProfessionsFrame','TradeSkillFrame','CraftFrame'})do
        local f=_G[name]
        if f and type(f.IsShown)=='function'then
            known=true;if app.try(f.IsShown,f)then return true end
        end
    end
    if known then return false end
    return nil
end
function app.readProfession()
    local api=C_TradeSkillUI or {}
    local info=app.try(api.GetBaseProfessionInfo)
    if type(info)~="table"then
        local name,skill,maximum=app.try(GetTradeSkillLine)
        if not name then return nil end
        info={professionName=name,skillLevel=skill,maxSkillLevel=maximum}
    end
    local id=info.professionID or info.skillLineID
    if not app.supported[id]then
        id=nil
        for _,dictionary in pairs(app.professionLabels)do
            for candidate,label in pairs(dictionary)do
                local plain=label:match("^([^/]+)"):gsub("%s+$","")
                if info.professionName==label or info.professionName==plain then id=candidate;break end
            end
            if id then break end
        end
    end
    if not id then return nil end
    return{id=id,skill=tonumber(info.skillLevel)or 0,cap=tonumber(info.maxSkillLevel)or 300,name=info.professionName}
end

local function liveMaterials(recipeId,index)
    local api=C_TradeSkillUI or {}
    local schematic=app.try(api.GetRecipeSchematic,recipeId,false)
    if type(schematic)=="table"and type(schematic.reagentSlotSchematics)=="table"then
        local groups,valid={},true
        local basic=Enum and Enum.CraftingReagentType and Enum.CraftingReagentType.Basic or 1
        for slotIndex,slot in ipairs(schematic.reagentSlotSchematics)do
            if slot.required~=false and (slot.reagentType==nil or slot.reagentType==basic)then
                local n=tonumber(slot.quantityRequired)
                if not n then valid=false
                elseif n>0 then
                    local ids={}
                    for _,choice in ipairs(slot.reagents or {})do if choice.itemID then ids[#ids+1]=choice.itemID end end
                    groups[#groups+1]={amount=n,choices=ids,slotIndex=slotIndex}
                    if #ids==0 then valid=false end
                end
            end
        end
        return groups,valid and #groups>0,schematic
    end
    local count,info,link,argument
    if index then count,info,link,argument=GetTradeSkillNumReagents,GetTradeSkillReagentInfo,GetTradeSkillReagentItemLink,index
    else count,info,link,argument=api.GetRecipeNumReagents,api.GetRecipeReagentInfo,api.GetRecipeReagentItemLink,recipeId end
    local total=app.try(count,argument)
    if not total or total<1 then return nil,false end
    local groups={}
    for n=1,total do
        local _,_,amount=app.try(info,argument,n)
        local id=itemID(app.try(link,argument,n))
        if not id or not amount or amount<1 then return nil,false end
        groups[#groups+1]={amount=amount,choices={id}}
    end
    return groups,true
end

function app.referenceRecipe(profession,id)
    local reference=(app.catalog[profession]or {})[id]
    local record=app.copy(reference)
    record.id=id;record.profession=profession
    record.confirmed=false;record.learned=false
    local access=app.accessInfo(record)
    if access.categories and #access.categories>0 then record.sources=access.categories;record.sourceUnconfirmed=access.referenceSources==true;record.example=nil end
    if access.item then record.scroll=access.item end
    record.groups={}
    for item,amount in pairs(record.ingredients or {})do record.groups[#record.groups+1]={amount=amount,choices={item}}end
    table.sort(record.groups,function(a,b)return a.choices[1]<b.choices[1]end)
    record.complete=#record.groups>0
    local observations=app.character and app.character.transitions[profession]and app.character.transitions[profession][id]
    if observations then
        for k,v in pairs(observations)do record[k]=v end
        record.observed=true
    end
    return record
end

-- A profession's header can change before GetAllRecipeIDs changes. Do not
-- attach known foreign recipes (or audit them) to that new header.
function app.foreignRecipeProfession(profession,id)
    if (app.catalog[profession]or {})[id]then return nil end
    for other,recipes in pairs(app.catalog)do if other~=profession and recipes[id]then return other end end
    for other,session in pairs(app.sessions or {})do
        local recipe=other~=profession and session.recipes and session.recipes[id]
        if recipe and recipe.confirmed then return other end
    end
end
function app.readRecipes(profile)
    local api=C_TradeSkillUI or {}
    local records={}
    for id in pairs(app.catalog[profile.id]or {})do records[id]=app.referenceRecipe(profile.id,id)end
    local ids=app.try(api.GetAllRecipeIDs)
    if type(ids)=='table'then
        local own,foreign=0,0
        for _,id in ipairs(ids)do
            local current=app.sessions[profile.id]and app.sessions[profile.id].recipes[id]
            if (app.catalog[profile.id]or {})[id]or current and current.confirmed then own=own+1
            elseif app.foreignRecipeProfession(profile.id,id)then foreign=foreign+1 end
        end
        if foreign>0 and own==0 then
            local key=profile.id..':'..foreign..':'..#ids
            if app.lastForeignSnapshot~=key then
                app.lastForeignSnapshot=key
                app.flowLog('profession.recipes_wait',{profession=profile.id,foreign=foreign,visible=#ids})
            end
            return {profile=profile,recipes=records,confirmed=0}
        end
    end
    local function ingest(id,info,index)
        if type(id)~="number"or type(info)~="table"then return end
        local foreign=app.foreignRecipeProfession(profile.id,id)
        if foreign then
            app.foreignReadSeen=app.foreignReadSeen or {}
            local key=profile.id..':'..id
            if not app.foreignReadSeen[key]then
                app.foreignReadSeen[key]=true;app.flowLog('recipe.foreign_ignored',{profession=profile.id,recipe=id,owner=foreign})
            end
            if app.forgetForeignRecipeAudit then app.forgetForeignRecipeAudit(profile.id,id)end
            return
        end
        local record=records[id]or app.referenceRecipe(profile.id,id)
        record.confirmed=true;record.learned=info.learned==true;record.disabled=info.disabled==true
        record.liveName=info.name;record.points=math.max(1,tonumber(info.numSkillUps)or 1)
        record.noSkill=info.canSkillUp==false and record.learned
        record.colour=numericBands[info.relativeDifficulty]or namedBands[info.difficulty]
        local cooldown,isDayCooldown,charges,maxCharges=app.try(api.GetRecipeCooldown,id)
        record.cooldown=type(cooldown)=="number"and cooldown>=0 and (tonumber(charges)or 0)<=0
        record.canCreateMultiple=info.canCreateMultiple~=false
        record.availableCharges=tonumber(charges);record.maxCharges=tonumber(maxCharges)
        record.singleAttempt=info.canCreateMultiple==false or profile.id==171 and type(info.name)=='string'and info.name:lower():find('^transmut')~=nil or isDayCooldown==true
        if record.maxCharges and record.maxCharges>0 then
            record.craftLimit=math.min(math.max(0,record.availableCharges or 0),record.singleAttempt and 1 or record.maxCharges)
        else record.craftLimit=record.singleAttempt and 1 or nil end
        local requirements=record.learned and app.try(api.GetRecipeRequirements,id)
        if type(requirements)=='table'then record.requirements=app.copy(requirements)end
        local groups,complete,schematic=liveMaterials(id,index)
        -- Read output proof for every crafting profession, not just rods.
        -- Never reuse reference/previous output metadata when the client has no schematic.
        record.isEnchantingRecipe=info.isEnchantingRecipe
        local output=app.try(api.GetRecipeOutputItemData,id)
        record.outputItemID=type(output)=='table'and output.itemID or schematic and schematic.outputItemID
        record.outputMin=schematic and tonumber(schematic.quantityMin)
        record.outputMax=schematic and (tonumber(schematic.quantityMax)or record.outputMin)
        if index then
            record.outputItemID=record.outputItemID or itemID(app.try(GetTradeSkillItemLink,index))
            if not record.outputMin then
                local minimum,maximum=app.try(GetTradeSkillNumMade,index)
                record.outputMin=tonumber(minimum);record.outputMax=tonumber(maximum)or record.outputMin
            end
        end
        record.outputFromClient=record.outputItemID~=nil and record.outputMin~=nil
            and (not schematic or not schematic.outputItemID or schematic.outputItemID==record.outputItemID)
        if profile.id==333 then
            record.outputName=record.outputItemID and app.try(C_Item and C_Item.GetItemInfo or GetItemInfo,record.outputItemID)
        end
        if complete then record.groups=groups;record.complete=true;record.materialsFromClient=true end
        if record.yellow and record.green and record.grey and record.colour then
            local predicted=app.band(record,profile.skill)
            if predicted~=record.colour and not record.rangeVerified and not record.observed and record.raw and record.raw[1]and record.raw[2]and record.raw[3]then
                local alternative=app.copy(record);alternative.yellow,alternative.green,alternative.grey=record.raw[1],record.raw[2],record.raw[3]
                if app.band(alternative,profile.skill)==record.colour then record.yellow,record.green,record.grey=alternative.yellow,alternative.green,alternative.grey end
            end
            record.rangeConflict=app.band(record,profile.skill)~=record.colour
        end
        local old=app.sessions[profile.id]and app.sessions[profile.id].recipes[id]
        if not record.requirements and old and old.requirements then record.requirements=app.copy(old.requirements)end
        local oldLevel=app.sessions[profile.id]and app.sessions[profile.id].profile.skill
        if old and old.colour and record.colour and oldLevel and profile.skill==oldLevel+1 and old.colour~=record.colour then
            local field=record.colour=="yellow"and "yellow"or (record.colour=="green"and "green"or (record.colour=="grey"and "grey"or nil))
            if field then
                local saved=app.character.transitions
                saved[profile.id]=saved[profile.id]or {};saved[profile.id][id]=saved[profile.id][id]or {}
                saved[profile.id][id][field]=profile.skill
                record[field]=profile.skill
                record.rangeConflict=app.band(record,profile.skill)~=record.colour;record.observed=true
            end
        end
        if app.auditRecipe then app.auditRecipe(profile,record,(app.catalog[profile.id]or {})[id])end
        records[id]=record
    end
    if type(ids)=="table"and type(api.GetRecipeInfo)=="function"then
        for _,id in ipairs(ids)do ingest(id,app.try(api.GetRecipeInfo,id))end
    elseif type(GetNumTradeSkills)=="function"then
        for index=1,GetNumTradeSkills()do
            local name,band=app.try(GetTradeSkillInfo,index)
            local link=app.try(GetTradeSkillRecipeLink,index)
            local id=type(link)=="string"and tonumber(link:match("enchant:(%d+)"))or nil
            if id and band~="header"then ingest(id,{name=name,learned=true,difficulty=band},index)end
        end
    end
    app.character.seen[profile.id]=app.character.seen[profile.id]or {}
    local confirmed=0
    for id,record in pairs(records)do
        if record.confirmed then confirmed=confirmed+1;app.character.seen[profile.id][id]=record.learned end
    end
    if app.auditRead then app.auditRead(profile,confirmed)end
    return{profile=profile,recipes=records,confirmed=confirmed}
end

-- This is the item's SELL value, not the vendor reagent BUY price below.
-- Cache only within one economic snapshot; unknown data can recover next refresh.
function app.vendorSellPrice(id,memo)
    if memo and memo[id]then return memo[id].value end
    -- Detail/progress callers may still request a quote between cast packets.
    -- Reuse the decision snapshot, never query item prices during a native batch.
    if app.craftRefreshBusy and app.craftRefreshBusy()then
        local snapshot=app.decision and app.decision.snapshot
        local cached=snapshot and snapshot.sellPrices and snapshot.sellPrices[id]
        return cached and cached.value
    end
    local function read(fn)
        local result={app.try(fn,id)}
        local value=result[11] -- GetItemInfo: eleventh result, copper per item.
        if type(result[1])=='string'and result[1]~=''and type(value)=='number'
            and value==value and value>=0 and value<math.huge and value==math.floor(value)then return value end
    end
    local modern=C_Item and C_Item.GetItemInfo
    local value=read(modern)
    if value==nil and GetItemInfo~=modern then value=read(GetItemInfo)end
    if memo then memo[id]={value=value}end
    return value
end

function app.vendorPrice(id)
    local observed=app.character and app.character.vendor[id]
    if observed and observed.limited~=true and type(observed.unit)=='number'and observed.unit>0 then
        return observed.unit,'observed'
    end
    local reference=app.vendorReagents and app.vendorReagents[id]
    local unit=reference and reference[app.playerFaction()or 'Unknown']
    if type(unit)=='number'and unit>0 then return unit,'reference'end
end
function app.unitPrice(id,memo)
    if memo and memo[id]~=nil then local entry=memo[id];return entry.value,entry.provider end
    local value,provider
    local policy=app.options.prices
    if app.shoppingPricesCurrent and app.shoppingPricesCurrent()then
        local live=app.shopping.livePrices and app.shopping.livePrices[id]
        value=live and live.unit or app.shopping.prices[id];provider=value and (live and 'Auctionator · Live'or 'Auctionator · Scan')or nil
    elseif policy=="auto"or policy=="auctionator"then
        local api=Auctionator and Auctionator.API and Auctionator.API.v1
        local found=api and app.try(api.GetAuctionPriceByItemID,app.identifier,id)
        if type(found)=="number"and found>0 then value,provider=found,"Auctionator"end
    end
    if not value and not(app.shoppingFresh and app.shoppingFresh())and (policy=="auto"or policy=="tsm")and TSM_API then
        local found=app.try(TSM_API.GetCustomPriceValue,"DBMinBuyout","i:"..id)
        if type(found)=="number"and found>0 then value,provider=found,"TSM"end
    end
    local vendor,kind=app.vendorPrice(id)
    if vendor and (not value or vendor<=value)then value,provider=vendor,app.caption(kind=='reference'and 'vendor_reference'or 'vendor_cached')end
    if memo then memo[id]={value=value,provider=provider}end
    return value,provider
end

function app.readMerchantOffer(slot)
    local id=itemID(app.try(GetMerchantItemLink,slot))
    local info=app.try(C_MerchantFrame and C_MerchantFrame.GetItemInfo,slot)
    local name,price,bundle,available,extended
    if type(info)=='table'then
        name,price,bundle,available,extended=info.name,info.price,info.stackCount,info.numAvailable,info.hasExtendedCost or info.currencyID~=nil
    else
        local texture,usable
        name,texture,price,bundle,available,usable,extended=app.try(GetMerchantItemInfo,slot)
    end
    if id and type(price)=='number'and price>0 and type(bundle)=='number'and bundle>0 and not extended then
        return{id=id,slot=slot,name=name or app.itemName(id),price=price,bundle=bundle,unit=price/bundle,available=available}
    end
end
function app.observeMerchant()
    local count=app.try(GetMerchantNumItems)or 0
    local offers={}
    for slot=1,count do
        local offer=app.readMerchantOffer(slot)
        if offer then
            app.character.vendor[offer.id]={unit=offer.unit,when=app.try(time),limited=type(offer.available)=='number'and offer.available~=-1}
            if offer.available==-1 then offers[offer.id]=offer.unit end
        end
    end
    if app.recordMerchant then app.recordMerchant(offers)end
end

function app.owned(id)
    if app.inventoryFor then return app.inventoryFor(id).total end
    local count=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,true)
    return type(count)=="number"and math.max(0,count)or nil
end
function app.itemName(id)
    local value=app.try(C_Item and C_Item.GetItemNameByID,id)or app.try(GetItemInfo,id)
    return value or ("#"..id)
end
