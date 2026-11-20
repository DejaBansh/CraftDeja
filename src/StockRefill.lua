-- SPDX-License-Identifier: MIT
local _,app=...
local words={
    de={stock_title='Zielbestände',stock_enable='Zielbestand auffüllen',stock_hint='Ziel und Gegenstands-ID ausfüllen und Händlerware speichern. Für Herstellung das Rezept im Berufsfenster auswählen. Ziel 0 entfernt den Eintrag.',stock_save_vendor='Händlerware speichern',stock_save_recipe='Gewähltes Rezept speichern',stock_use='Herstellungsauftrag starten',stock_bad='Benötigt einen Verbrauchsgegenstand oder ein gelerntes Rezept mit fester Ausbeute.',stock_counts='%s: %d in Taschen · Ziel %d · %d fehlen',stock_round='%d Stück kaufen (Händlerstapel: %d Stück).',stock_crafts='%d Herstellungen × %d Stück.',stock_wait='Warte auf den bestätigten Bestand in deinen Taschen.',stock_bags_full='Zu wenig Platz für diese Kaufmenge. Schaffe Platz in deinen Taschen.',stock_open='Herstellenden Beruf öffnen',stock_locked='Laufenden Berufsauftrag, Kauf oder Herstellung zuerst abschließen.',stock_vendor_status='Händlerangebot bestätigen',stock_target='Zielmenge',stock_item='Gegenstands-ID'},
    en={stock_title='Stock targets',stock_enable='Refill stock targets',stock_hint='Enter the target and item ID for vendor stock. For crafting, select the recipe in the profession window. A target of 0 removes the entry.',stock_save_vendor='Save vendor item',stock_save_recipe='Save selected recipe',stock_use='Start crafting order',stock_bad='Requires a consumable or a learned recipe with fixed output.',stock_counts='%s: %d in bags · target %d · %d missing',stock_round='Buy %d units (vendor bundle: %d).',stock_crafts='%d crafts × %d units.',stock_wait='Waiting for confirmed bag inventory.',stock_bags_full='Not enough bag space for this quantity. Free some bag space.',stock_open='Open the crafting profession',stock_locked='Finish the active profession order, purchase or craft first.',stock_vendor_status='Confirm vendor offer',stock_target='Target quantity',stock_item='Item ID'}
}
for lang,entries in pairs(words)do for key,value in pairs(entries)do app.words[lang][key]=value end end

local function bagCount(id)
    return app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)
end
function app.stockPosition(id,goal,step)
    local count=bagCount(id)
    if type(count)~='number'or count<0 or count~=math.floor(count)or type(step)~='number'or step<1 or step~=math.floor(step)then return end
    local missing=math.max(0,goal-count)
    return {id=id,bags=count,goal=goal,missing=missing,crafts=math.ceil(missing/step),yield=step}
end
local function targets()
    app.character.stockTargets=app.character.stockTargets or {}
    return app.character.stockTargets
end
local function consumable(id)
    if type(id)~='number'then return false end
    local _,_,_,_,_,class=app.try(C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant,id)
    return class==0 or class==6 -- Consumable / Projectile in the client item taxonomy.
end
local function recipeOutput(recipe)
    if not recipe or not recipe.learned or not recipe.confirmed or not recipe.complete or not recipe.materialsFromClient then return end
    if recipe.profession==40 and not app.poisonUnlocked()then return end
    if recipe.profession==40 and not recipe.outputFromClient then
        local _,id,lo,hi=app.craftDisplay(recipe)
        if consumable(id)and type(lo)=='number'and lo>0 and lo==hi and lo==math.floor(lo)then return id,lo end
        return
    end
    if not recipe.outputFromClient or not consumable(recipe.outputItemID)then return end
    local n=recipe.outputMin
    if n and n>0 and n==math.floor(n)and n==recipe.outputMax then return recipe.outputItemID,n end
end
app.stockRecipeOutput=recipeOutput
local function learnedOutput(r)
    if not r.confirmed or not r.learned then return end
    if r.profession==40 and not app.poisonUnlocked()then return end
    if r.outputFromClient then return r.outputItemID,r.outputMin,r.outputMax end
    if r.profession==40 then
        local _,id,min,max=app.craftDisplay(r)
        return id,min,max
    end
end
local stockProfessions={[171]=true,[185]=true,[129]=true,[202]=true,[40]=true,[164]=true,[165]=true,[197]=true}
local function stockProfessionIDs()
    local ids={}
    for _,index in pairs({app.try(GetProfessions)})do
        local _,_,rank,_,_,_,id=app.try(GetProfessionInfo,index)
        if stockProfessions[id]and type(rank)=='number'and rank>0 and (id~=40 or app.poisonUnlocked())then ids[id]=true end
    end
    if app.poisonUnlocked()then ids[40]=true end
    return ids
end
function app.recordStockProfession(session)
    local profession=session.profile.id
    if not app.supported[profession] or session.invalidated or (session.confirmed or 0)==0 then return end
    local all=app.character.stockRecipes or {};app.character.stockRecipes=all
    local previous=all[profession]
    local recipes=session.fullRecipeList and {}or app.copy(previous and previous.recipes)
    for id,r in pairs(session.recipes)do
        if r.confirmed then
            local output,min,max=learnedOutput(r)
            if output then
                recipes[id]={id=id,profession=profession,liveName=r.liveName,learned=true,confirmed=true,
                    outputItemID=output,outputMin=min,outputMax=max,outputFromClient=true,
                    groups=r.materialsFromClient and r.groups or nil,complete=r.complete,materialsFromClient=r.materialsFromClient}
            elseif not r.learned then recipes[id]=nil
            elseif not recipes[id]and previous then recipes[id]=previous.recipes[id]end
        end
    end
    local pending=previous and previous.pending
    local seen=pending and session.recipes[pending]
    all[profession]={recipes=recipes,pending=not session.fullRecipeList and not (seen and seen.confirmed)and pending or nil,
        read=session.fullRecipeList or session.legacyRecipeList or previous and previous.read}
    app.invalidateWorkshopStock(nil,true)
end
function app.discoverStockRecipes()
    local api=C_TradeSkillUI or {}
    if type(api.GetProfessionSpells)~='function'then return end
    local saved=app.character.stockRecipes or {}
    for profession in pairs(stockProfessionIDs())do
        if not (saved[profession]and saved[profession].read)then
            local spells=app.try(api.GetProfessionSpells,profession)
            if type(spells)=='table'then
                local recipes,confirmed={},0
                for _,id in ipairs(spells)do if type(id)=='number'then
                    local recipe=app.lookupLearnedStockRecipe(profession,id)
                    if recipe and consumable(recipe.outputItemID)and not recipes[id]then recipes[id]=recipe;confirmed=confirmed+1 end
                end end
                app.recordStockProfession({profile={id=profession},recipes=recipes,confirmed=confirmed})
            end
        end
    end
end
function app.noteStockRecipeLearned(id)
    if type(id)~='number'then return end
    local info=app.try(C_TradeSkillUI and C_TradeSkillUI.GetProfessionInfoByRecipeID,id)
    local profession=type(info)=='table'and info.parentProfessionID
    if not app.supported[profession]then profession=type(info)=='table'and info.professionID end
    if not app.supported[profession]then return end
    app.character.stockRecipes=app.character.stockRecipes or {}
    local all=app.character.stockRecipes
    all[profession]=all[profession]or {recipes={}};all[profession].pending=id
    app.invalidateWorkshopStock(nil,true)
end
function app.unreadStockProfessions()
    local all=app.character.stockRecipes or {}
    local missing={}
    local function consider(id)
        if not stockProfessions[id]or id==40 and not app.poisonUnlocked()then return end
        if not all[id]or not all[id].read or all[id].pending then missing[id]=app.professionName(id)end
    end
    for id in pairs(stockProfessionIDs())do consider(id)end
    for id,entry in pairs(all)do if entry.pending then consider(id)end end
    local names={}
    for _,name in pairs(missing)do names[#names+1]=name end
    table.sort(names)
    return table.concat(names,', ')
end
local function activeOrder()
    local route=app.currentRouteOrder()
    local a=app.active
    local p=a and a.profile
    local j=p and app.character.productionJobs and app.character.productionJobs[p.id]
    local manual=p and app.shopping.goal=='manual'and app.planningTarget()
    local poison=app.character.poisons
    return route and route.active and (not p or p.id~=route.profession or p.skill<route.target or route.rankCheckpoint)
        or j and j.remaining>0 or manual and p.skill<manual or poison and poison.job
        or app.materialConversion
end
local function busy()
    return app.craftRefreshBusy()or app.nativeCraftHandoff or app.purchasePending()or app.vendorPurchase.pending
end
function app.stockTargetEditingLocked()
    return busy()or app.character.poisons and app.character.poisons.job~=nil
end
function app.toggleStockRefill()
    if app.stockTargetEditingLocked()then return false end
    app.options.stockRefill=not app.options.stockRefill
    if not app.options.stockRefill then app.stockRefillJob=nil;app.pendingStockTarget=nil end
    app.refreshNextStep(true)
    return true
end
local serial=0
local function begin(target)
    local a=app.active
    local recipe=a and not a.invalidated and a.profile.id==target.profession and a.recipes[target.recipe]
    local id,yield=recipeOutput(recipe)
    if id~=target.id or recipe.disabled then return false end
    local stock=app.stockPosition(id,target.goal,yield)
    if not stock or stock.missing==0 then return false end
    if target.profession==40 then return app.startPoisonOrder(recipe.id)end
    serial=serial+1
    app.stockRefillJob={stock=true,recipe=recipe.id,profession=recipe.profession,id=id,goal=target.goal,yield=yield,
        remaining=stock.crafts,initial=stock.crafts,serial='stock:'..serial}
    app.newPurchasePlan()
    app.flowLog('stock.plan',{item=id,bags=stock.bags,goal=stock.goal,missing=stock.missing,crafts=stock.crafts})
    return true
end
function app.setStockTarget(id,goal,recipe,asVendor)
    goal=tonumber(goal)
    id=tonumber(id)
    if not goal or goal~=math.floor(goal)or goal<0 or goal>10000 or not id or id~=math.floor(id)or id<1 or app.stockTargetEditingLocked()then return false end
    local old=targets()[id]
    if goal>0 and not old and not consumable(id)then return false end
    local target={id=id,goal=goal}
    if recipe then
        if recipeOutput(recipe)~=id then return false end
        target.recipe=recipe.id;target.profession=recipe.profession;target.reagents={}
        for _,group in ipairs(recipe.groups or {})do for _,item in ipairs(group.choices)do target.reagents[item]=true end end
    elseif old and not asVendor then
        target=app.copy(old);target.goal=goal
    end
    local poison=app.character.poisons
    if poison and (old and old.profession==40 or target.profession==40)then
        poison.stockTargets=poison.stockTargets or {}
        if old and old.profession==40 then poison.stockTargets[old.recipe]=nil end
        if target.profession==40 and goal>0 then poison.stockTargets[target.recipe]=goal end
    end
    targets()[id]=goal>0 and target or nil
    if app.stockRefillJob and app.stockRefillJob.id==id then
        if goal==0 or target.recipe~=app.stockRefillJob.recipe then app.stockRefillJob=nil
        else app.stockRefillJob.goal=goal end
    end
    return true
end
-- Legacy poison goals are keyed by recipe spell. Only migrate once the
-- unlocked profession proves the actual output item and fixed yield.
function app.syncPoisonStockTargets()
    local a=app.active
    local poison=app.character.poisons
    if not a or a.invalidated or a.profile.id~=40 or not poison or not next(poison.stockTargets or {})then return end
    for recipe,goal in pairs(poison.stockTargets)do
        local r=a.recipes[recipe]
        local id=recipeOutput(r)
        if id and goal>0 and not targets()[id]then app.setStockTarget(id,goal,r)end
    end
end
function app.stockTargetRows()
    local rows={}
    for id,target in pairs(targets())do
        local row=app.stockPosition(id,target.goal,1)or {id=id,goal=target.goal}
        row.target=target;row.name=app.itemName(id)
        rows[#rows+1]=row
    end
    table.sort(rows,function(a,b)return a.name==b.name and a.id<b.id or a.name<b.name end)
    return rows
end
function app.selectedStockRecipe()
    if not app.professionOpen or app.professionLoading or not app.active or app.active.invalidated then return end
    local recipe=app.selectedProductionRecipe(true)
    local id=recipeOutput(recipe)
    if id then return recipe,id end
end
function app.stockSearchCandidates(linkID,mode)
    local items,recipes,rows,pending={},{},{},{}
    local function item(id)
        if not items[id]then items[id]={id=id,recipes={}}end
        return items[id]
    end
    local function addRecipe(r)
        local id=learnedOutput(r)
        if id and not recipes[r.id]then
            recipes[r.id]=true
            if consumable(id)then
                local row=item(id);row.recipes[#row.recipes+1]=r
            elseif not app.try(C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant,id)then
                pending[id]=true;app.try(C_Item and C_Item.RequestLoadItemDataByID,id)
            end
        end
    end
    if mode~='merchant'then
        local active=app.active
        if active and not active.invalidated then for _,r in pairs(active.recipes)do addRecipe(r)end end
        for _,entry in pairs(app.character.stockRecipes or {})do for _,r in pairs(entry.recipes)do addRecipe(r)end end
        for id,target in pairs(targets())do item(id).target=target end
    end
    if mode=='search'then
        for id in pairs(app.character.vendor or {})do if consumable(id)then item(id)end end
        for id in pairs(app.character.inventory and app.character.inventory.items or {})do if consumable(id)then item(id)end end
        local container=C_Container or {}
        for bag=0,NUM_BAG_SLOTS or 4 do
            for slot=1,app.try(container.GetContainerNumSlots,bag)or 0 do
                local info=app.try(container.GetContainerItemInfo,bag,slot)
                if info and consumable(info.itemID)then item(info.itemID)end
            end
        end
        if consumable(linkID)then item(linkID)
        elseif linkID and not app.try(C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant,linkID)then
            pending[linkID]=true;app.try(C_Item and C_Item.RequestLoadItemDataByID,linkID)
        end
        -- Only use names already cached from the broader reference catalogue.
        for _,catalog in pairs(app.catalog)do for _,r in pairs(catalog)do
            for id in pairs(r.ingredients or {})do
                if not items[id]and app.try(C_Item and C_Item.GetItemNameByID,id)and consumable(id)then item(id)end
            end
        end end
    end
    if app.vendorPurchase.open then
        for slot=1,app.try(GetMerchantNumItems)or 0 do
            local offer=app.readMerchantOffer(slot)
            if offer and offer.available==-1 and consumable(offer.id)and (mode or items[offer.id])then item(offer.id).vendor=true end
        end
    end
    for id,row in pairs(items)do
        table.sort(row.recipes,function(a,b)return a.profession==b.profession and a.id<b.id or a.profession<b.profession end)
        row.name=app.itemName(id);row.icon=app.itemIcon(id)
        if row.name:sub(1,1)=='#'then
            pending[id]=true
            if row.recipes[1]then row.name=app.recipeName(row.recipes[1])end
        end
        local observed=app.character.vendor and app.character.vendor[id]
        row.vendor=row.vendor or observed and not observed.limited
        rows[#rows+1]=row
    end
    table.sort(rows,function(a,b)
        if a.name~=b.name then return a.name<b.name end
        return a.id<b.id
    end)
    return rows,pending
end
function app.canReceiveStock(id,quantity)
    local api=C_Container or {}
    local _,_,_,_,_,_,_,stack=app.try(C_Item and C_Item.GetItemInfo or GetItemInfo,id)
    if type(stack)~='number'or stack<1 then return false end
    local room=0
    for bag=0,NUM_BAG_SLOTS or 4 do
        local free,family=app.try(api.GetContainerNumFreeSlots,bag)
        if family==0 and type(free)=='number'then room=room+free*stack end
        for slot=1,app.try(api.GetContainerNumSlots,bag)or 0 do
            local info=app.try(api.GetContainerItemInfo,bag,slot)
            if info and info.itemID==id and not info.isLocked then room=room+math.max(0,stack-(info.stackCount or stack))end
        end
    end
    return room>=quantity
end
function app.stockMerchantRelevant(recipe)
    local reagents={}
    for _,g in ipairs(recipe.groups or {})do for _,id in ipairs(g.choices)do reagents[id]=true end end
    for slot=1,app.try(GetMerchantNumItems)or 0 do
        local row=app.readMerchantOffer(slot)
        if row and row.available==-1 and reagents[row.id]then return true end
    end
    return false
end

local function stockJob()
    local job=app.stockRefillJob
    if app.options.stockRefill~=true or not job or not app.active or app.active.profile.id~=job.profession then return nil end
    if not app.craftBatch and not app.nativeCraftHandoff and activeOrder()then return nil end
    return job
end
function app.guideStockPosition(plan,task)
    local stock=plan and plan.stock
    if stock then return app.stockPosition(stock.id,stock.goal,stock.yield)or stock end
    if not task or task.kind=='stock_vendor'or task.key=='stock_vendor_wait'then return end
    local job=stockJob()
    if job and (task.kind=='stock_wait'or task.kind=='done'or task.kind=='station')then
        return app.stockPosition(job.id,job.goal,job.yield)
    end
    local p=app.isPoison()and app.character.poisons and app.character.poisons.job
    if p and p.restock then
        local recipe=plan and plan.recipe and plan.recipe.id or next(p.outputs)
        if recipe and p.outputs[recipe]then return app.stockPosition(p.outputs[recipe],p.goals[recipe],p.yield[recipe])end
    end
end
local productionEnabled=app.productionEnabled
app.productionEnabled=function()return stockJob()~=nil or productionEnabled()end
local productionJob=app.productionJob
app.productionJob=function()return stockJob()or productionJob()end
local productionPlan=app.productionPlan
app.productionPlan=function(...)
    local job=stockJob()
    if not job then return productionPlan(...)end
    local recipe=app.active.recipes[job.recipe]
    local id,yield=recipeOutput(recipe)
    if id~=job.id or yield~=job.yield or app.active.invalidated then return nil,'production_missing'end
    local stock=app.stockPosition(id,job.goal,yield)
    if not stock or job.expected and stock.bags<math.min(job.expected,job.goal)then return nil,'stock_wait'end
    job.expected=nil
    job.remaining=stock.crafts
    local plan,why=app.makeProductionPlan(job)
    if plan then
        plan.stock=stock
        return app.applyMaterialSources(plan)
    end
    return nil,why
end
local productionCraftEvent=app.productionCraftEvent
app.productionCraftEvent=function(unit,guid,id)
    local job=stockJob()
    if not job then return productionCraftEvent(unit,guid,id)end
    if unit~='player'or id~=job.recipe or not guid or guid==job.lastGUID then return end
    local batch=app.craftBatch or app.nativeCraftHandoff
    if not batch or not batch.plan or not batch.plan.stock or batch.plan.jobSerial~=job.serial then return end
    job.lastGUID=guid
    job.expected=math.max(job.expected or 0,batch.plan.stock.bags)+job.yield
end

local merchantVisit=0
local function merchantStock()
    local state=app.vendorPurchase
    if not state.open or not app.options.stockRefill or activeOrder()or app.craftRefreshBusy()or app.nativeCraftHandoff or app.purchasePending()then return end
    local direct,related={},{}
    local configured=targets()
    if not next(configured)then return end
    for slot=1,app.try(GetMerchantNumItems)or 0 do
        local row=app.readMerchantOffer(slot)
        if row and row.available==-1 then
            related[row.id]=true
            local target=configured[row.id]
            if target and not target.recipe and consumable(row.id)then
                local stock=app.stockPosition(row.id,target.goal,row.bundle)
                local max=app.try(GetMerchantItemMaxStack,slot)or row.bundle
                if stock and stock.missing>0 and max>=row.bundle then
                    row.missing=stock.missing;row.quantity=math.min(math.floor(max/row.bundle),stock.crafts)*row.bundle
                    row.cost=row.price*(row.quantity/row.bundle);row.stock=stock;row.stockVisit=merchantVisit
                    direct[#direct+1]=row
                end
            end
        end
    end
    return direct,related
end
local vendorPlan=app.vendorPurchasePlan
app.vendorPurchasePlan=function()
    if not stockJob()then
        local rows=merchantStock()
        if rows and #rows>0 then return {rows=rows}end
    end
    return vendorPlan()
end
local function merchantCraftTarget(related)
    local chosen
    for id,target in pairs(targets())do
        if target.recipe and (target.profession~=40 or app.poisonUnlocked())then
            local stock=app.stockPosition(id,target.goal,1)
            if stock and stock.missing>0 then
                for reagent in pairs(target.reagents or {})do
                    if related[reagent]and (not chosen or id<chosen.id)then chosen=target;break end
                end
            end
        end
    end
    return chosen
end
local function checkMerchant()
    if busy()or app.stockRefillJob and app.stockRefillJob.remaining>0 then return end
    local direct,related=merchantStock()
    if not direct then return end
    if #direct>0 then app.stockRefillJob=nil;return end
    local target=merchantCraftTarget(related)
    if target then begin(target)end
end
local vendorEvent=app.vendorBuyEvent
app.vendorBuyEvent=function(event)
    if event=='MERCHANT_SHOW'then merchantVisit=merchantVisit+1 end
    vendorEvent(event)
    if app.options.stockRefill and (event=='MERCHANT_SHOW'or event=='MERCHANT_UPDATE')then checkMerchant();app.refreshNextStep(true)end
end
local vendorTick=app.vendorBuyTick
app.vendorBuyTick=function()
    local pending=app.vendorPurchase.pending
    vendorTick()
    if pending and pending.stockVisit and not app.vendorPurchase.pending then
        app.stockVendorCompleted=merchantVisit;app.refreshNextStep(true)
    end
    if app.vendorPurchase.open and app.options.stockRefill then checkMerchant()end
end
local refresh=app.refreshNextStep
app.refreshNextStep=function(force)
    if app.saved and not app.professionLoading and not stockJob()then
        local rows,related=merchantStock()
        local pending=app.vendorPurchase.pending
        local row=rows and rows[1]
        if pending and pending.stockVisit and app.vendorPurchase.open then
            return app.renderNextStep(nil,true,{kind='vendor_wait',key='stock_vendor_wait',body=app.caption('stock_wait')})
        elseif row and not pending then
            local s=row.stock
            return app.renderNextStep(nil,true,{kind='stock_vendor',key='stock_vendor:'..row.id,offer=row,
                body=app.caption('stock_counts',row.name,s.bags,s.goal,s.missing)..'\n'..app.caption('stock_round',row.quantity,row.bundle)})
        elseif related then
            local target=merchantCraftTarget(related)
            if target then return app.renderNextStep(nil,true,{kind='stock_open',key='stock_open:'..target.id,target=target,body=app.caption('stock_open')..' · '..app.itemName(target.id)})end
            if #rows==0 and app.stockVendorCompleted==merchantVisit then
                return app.renderNextStep(nil,true,{kind='done',key='stock_vendor_done',body=app.caption('ui_stock_full')})
            end
        end
    end
    return refresh(force)
end
local action=app.unifiedAction
function app.stockTargetStartable(target)
    return target and target.recipe and app.options.stockRefill and not busy()and not activeOrder()
        and (target.profession~=40 or app.poisonUnlocked())
end
function app.startStockTarget(id)
    local target=targets()[id]
    local stock=target and app.stockPosition(id,target.goal,1)
    if not app.stockTargetStartable(target)or not stock or stock.missing==0 then return false end
    if begin(target)then app.showCentralGuide();return true end
    app.pendingStockTarget=target
    if app.openCraftProfession(target.recipe,target.profession)then return true end
    app.pendingStockTarget=nil
    return false
end
app.unifiedAction=function(f)
    local task=f.task
    if task.kind=='stock_vendor'then
        local shown=task.offer
        app.vendorPurchase.plan={rows={shown}}
        app.buyVendorMaterial(shown.id);app.refreshNextStep(true);return true
    elseif task.kind=='stock_open'then
        local target=task.target
        if targets()[target.id]==target then app.startStockTarget(target.id)end
        app.refreshNextStep(true)
        return true
    end
    return action(f)
end
local refreshUI=app.refreshUI
app.refreshUI=function(...)
    local target=app.pendingStockTarget
    if target and not app.professionLoading and app.active and app.active.profile.id==target.profession then
        app.pendingStockTarget=nil
        if not busy()and not activeOrder()and app.options.stockRefill and targets()[target.id]==target then begin(target)end
    end
    return refreshUI(...)
end

function app.showStockTargets()app.showRouteWindow(nil,'stock')end
local command=app.command
app.command=function(message)
    local key=(message or ''):match('^%s*(%S*)'):lower()
    if key=='stock'or key=='vorrat'then return app.showStockTargets()end
    return command(message)
end
