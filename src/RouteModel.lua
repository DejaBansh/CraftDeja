-- SPDX-License-Identifier: MIT
local _,app=...
local function clock()return app.try(time)or 0 end
local fields={'id','profession','skill','yellow','green','grey','colour','points','confirmed','learned','disabled','cooldown',
    'noSkill','craftLimit','rangeConflict','referenceHidden','outputItemID','outputMin','outputMax','outputFromClient','isEnchantingRecipe','liveName','materialsFromClient'}
function app.routeTransferable(item,existingStock)
    local fn=C_Item and C_Item.GetItemInfo or GetItemInfo
    if type(fn)~='function'then return false end
    local result={pcall(fn,item)}
    return result[1]and (result[15]==0 or not existingStock and result[15]==2)
end
function app.recordRouteProfession(session)
    if not app.character or not session or not session.profile or app.craftRefreshBusy()then return end
    local p=session.profile
    local record={skill=p.skill,cap=p.cap,at=clock(),recipes={}}
    for id,r in pairs(session.recipes or {})do
        if r.confirmed and r.learned and r.materialsFromClient then
            local n={}
            for _,key in ipairs(fields)do n[key]=r[key]end
            n.groups={}
            for _,g in ipairs(r.groups or {})do
                local choices={};for i,item in ipairs(g.choices or {})do choices[i]=item end
                n.groups[#n.groups+1]={amount=g.amount,choices=choices}
            end
            record.recipes[id]=n
        end
    end
    app.character.routeProfessions=app.character.routeProfessions or {};app.character.routeProfessions[p.id]=record
end
function app.currentRouteOrder()
    if not app.saved or not app.character then return end
    local identity=app.character.identity or {}
    local scope=(identity.realm or '?')..':'..(identity.faction or '?')
    local id=app.saved.routeActive and app.saved.routeActive[scope]
    return id and app.saved.routeOrders and app.saved.routeOrders[id]
end
function app.startRouteOrder(target)
    if not app.active or app.isPoison()or app.productionEnabled()or app.craftRefreshBusy()or app.purchasePending()then return false end
    local p=app.active.profile;target=math.floor(tonumber(target)or p.cap)
    if target<=p.skill or target>450 then return false end
    app.saved.routeSequence=(app.saved.routeSequence or 0)+1
    local identity=app.character.identity or {};local scope=(identity.realm or '?')..':'..(identity.faction or '?')
    local id=app.characterKey..':'..app.saved.routeSequence
    local order={id=id,owner=app.characterKey,profession=p.id,start=p.skill,target=target,scope=scope,
        forceAH={},terms={},learned={},created=clock(),active=true}
    app.saved.routeOrders=app.saved.routeOrders or {};app.saved.routeOrders[id]=order
    app.saved.routeActive=app.saved.routeActive or {};app.saved.routeActive[scope]=id
    if app.invalidateRoute then app.invalidateRoute('new_order')end
    return true
end
function app.skipGuildRouteItem(item)
    local order=app.currentRouteOrder();if not order or not app.guildCraftAllowed(item)then return false end
    order.forceAH[item]=true
    if app.invalidateRoute then app.invalidateRoute('force_ah')end
    return true
end
function app.resetGuildRouteItem(item)
    local order=app.currentRouteOrder();if not order then return false end
    order.forceAH[item]=nil
    if app.invalidateRoute then app.invalidateRoute('reset_ah')end
    return true
end
function app.setRouteProviderTerms(key,item,terms)
    local order=app.currentRouteOrder()
    if not order or type(terms)~='table'or type(item)~='number'or type(key)~='string'or #key>160 or not app.routeFinite(terms.transferCost)then return false end
    if terms.mode=='fixed'and not app.routeFinite(terms.fixedPrice)or terms.mode=='materials'and not app.routeFinite(terms.tip)then return false end
    if terms.mode~='fixed'and terms.mode~='materials'then return false end
    order.terms[key]={mode=terms.mode,tip=terms.tip,fixedPrice=terms.fixedPrice,transferCost=terms.transferCost,
        accepted=terms.accepted==true,at=clock(),guild=app.routeGuildIdentity(),item=item}
    if app.invalidateRoute then app.invalidateRoute('provider_terms')end
    return true
end

local function addItem(items,id)if type(id)=='number'and id>0 then items[id]=true end end
function app.buildRouteModel(order)
    if not app.active or not order or order.owner~=app.characterKey or app.active.profile.id~=order.profession then return nil,'owner_profession_required'end
    if app.craftRefreshBusy()then return nil,'crafting_busy'end
    local session=app.active;local profile=session.profile
    local model={profession=profile.id,start=profile.skill,target=order.target,cap=profile.cap,now=clock(),maxAge=app.shopping.maxAge or 900,
        green=app.options.green,stock={},unknownStock={},prices={},recipes={},providers={},ranks={},excludedGuild=order.forceAH,
        guild=app.routeGuildIdentity(),characterLevel=app.playerLevel(),width=6,maxExpansions=4000,rawRecipes=session.recipes}
    local items={};local raw={};local providerRows={}
    for id,r in pairs(session.recipes)do
        if r.skill and r.skill<=model.target and (r.grey or 0)>model.start and not r.referenceHidden then
            raw[id]=r
            for _,g in ipairs(r.groups or {})do for _,item in ipairs(g.choices or {})do addItem(items,item)end end
            addItem(items,r.outputItemID)
            local data=app.accessInfo(r);addItem(items,data.item or r.scroll)
        end
    end
    local prerequisites,chains=app.routePrerequisiteRecipes(session,raw)
    model.prerequisites=chains
    for id,r in pairs(prerequisites)do
        raw[id]=r
        for _,g in ipairs(r.groups or {})do for _,item in ipairs(g.choices or {})do addItem(items,item)end end
        addItem(items,r.outputItemID)
    end
    local me=app.character.identity or {}
    for key,char in pairs(app.saved.characters or {})do
        local who=char.identity or {}
        if key~=app.characterKey and who.realm==me.realm and who.faction==me.faction then
            for profession,p in pairs(char.routeProfessions or {})do
                for id,r in pairs(p.recipes or {})do
                    if r.learned and r.confirmed and r.outputFromClient and r.outputMin and items[r.outputItemID]and not r.disabled and not r.cooldown then
                        providerRows[#providerRows+1]={kind='alt',name=who.name,key='alt:'..key..':'..id,character=key,recipe=id,
                            profession=profession,skill=p.skill,item=r.outputItemID,output=r.outputMin,groups=r.groups,at=p.at,
                            confirmed=r.materialsFromClient==true and (r.skill or math.huge)<=p.skill,transferable=app.routeTransferable(r.outputItemID)}
                        for _,g in ipairs(r.groups or {})do for _,item in ipairs(g.choices or {})do addItem(items,item)end end
                    end
                end
            end
        end
    end
    for _,p in ipairs(app.guildProviderSnapshot())do
        if items[p.item]then providerRows[#providerRows+1]=p;for item in pairs(p.inputs or {})do addItem(items,item)end end
    end
    local memo={}
    for item in pairs(items)do
        local vendor=app.vendorPrice(item);local depth=app.routeDepth and app.routeDepth[item]
        local scan=app.shopping.prices and app.shopping.prices[item]
        local at=app.shopping.readyWall
        local price={unit=scan,at=at,vendor=vendor}
        local live=app.routePriceObservations and app.routePriceObservations[item]
        if live and live.serial==app.shopping.scanSerial then price.unit=live.unit;price.at=live.at end
        if depth and depth.serial==app.shopping.scanSerial then price.levels=depth.levels;price.at=depth.at end
        if not price.unit and not price.levels and not vendor then price.unit=app.unitPrice(item,memo)end
        if vendor and not at then price.at=model.now end
        model.prices[item]=price
        local inventory=app.inventoryFor(item)
        if inventory and inventory.total~=nil then
            model.stock[item]=math.max(0,inventory.total-(inventory.deductibleAlts or 0))+(app.confirmedMail(item)or 0)
        else model.stock[item]=app.confirmedMail(item)or 0;model.unknownStock[item]=true end
    end
    model.currentStock=app.copy(model.stock);model.stockOrigins={}
    for key,char in pairs(app.saved.characters or {})do
        local who=char.identity or {}
        if key~=app.characterKey and who.realm==me.realm and who.faction==me.faction then
            for item in pairs(items)do
                local stock=char.inventory and char.inventory.items and char.inventory.items[item]
                local n=stock and (stock.bags or 0)+(stock.bank or 0)or 0
                if n>0 and not order.forceAH[item]and app.routeTransferable(item,true)then
                    model.stock[item]=(model.stock[item]or 0)+n
                    model.stockOrigins[item]=model.stockOrigins[item]or {}
                    local token='stock:'..key..':'..item;local terms=order.terms[token]
                    local observed=stock.bagWhen
                    if (stock.bank or 0)>0 then observed=math.min(observed or 0,stock.bankObserved or stock.bankWhen or 0)end
                    model.stockOrigins[item][#model.stockOrigins[item]+1]={key=token,name=who.name,character=key,quantity=n,at=observed,
                        transferCost=terms and terms.transferCost}
                end
            end
        end
    end
    local function inputs(r)
        if r.inputs then return app.copy(r.inputs)end
        local list={}
        for _,g in ipairs(r.groups or {})do
            local selected,best
            for _,item in ipairs(g.choices or {})do
                local cost=app.routeCurveCost(model.prices[item],g.amount)
                if cost and (not best or cost<best)then selected,best=item,cost end
            end
            selected=selected or (g.choices or {})[1]
            if selected then list[selected]=(list[selected]or 0)+g.amount end
        end
        return list
    end
    for id,r in pairs(raw)do
        local n={};for _,key in ipairs(fields)do n[key]=r[key]end
        n.inputs=inputs(r);n.allowed=app.canRecommend(r);n.outputItem=r.outputItemID;n.outputMin=r.outputFromClient and r.outputMin or nil
        if not r.outputFromClient and r.isEnchantingRecipe~=true then n.confirmed=false end
        if prerequisites[id]then n.noSkill=true end
        n.fee=app.acquisitionQuote(r,{})
        if not n.fee.known then n.fee=nil end
        local q=app.quote(r,memo);n.sell=q and q.vendorRevenueKnown and r.outputMin and q.vendorRevenue/r.outputMin or nil
        model.recipes[id]=n
    end
    for _,p in ipairs(providerRows)do
        p.inputs=inputs(p)
        local terms=order.terms[p.key]
        if terms and terms.item==p.item and (p.kind~='guild'or terms.guild==model.guild)then
            p.mode=terms.mode;p.tip=terms.tip;p.fixedPrice=terms.fixedPrice;p.transferCost=terms.transferCost;p.accepted=terms.accepted
        elseif p.kind=='alt'then p.mode=p.ownedStock and 'fixed'or 'materials';p.tip=0 end
        local sent=order.supplyProgress and order.supplyProgress[p.key]
        if sent and sent.status=='materials_sent'then p.inputs={}end
        if p.ownedStock then
            local value=app.routeCurveCost(model.prices[p.item],1)
            p.fixedPrice=value -- value of consumed alt stock, not a zero-cost material
        end
        model.providers[p.item]=model.providers[p.item]or {};model.providers[p.item][#model.providers[p.item]+1]=p
    end
    local cap=profile.cap
    while cap<order.target do
        local row=app.nearestRankTrainer(profile.id,cap);if not row or not row.toCap then break end
        local rank=app.copy(row);rank.cost=app.character.routeRankCosts and app.character.routeRankCosts[cap]
        if rank.questID then rank.cost=nil end -- Quest materials have variable auction prices.
        rank.spellID=(app.routeRankSpells[profile.id]or {})[cap]
        model.ranks[#model.ranks+1]=rank;cap=row.toCap
    end
    return model
end
