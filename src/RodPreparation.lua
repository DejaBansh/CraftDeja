-- SPDX-License-Identifier: MIT
local _,app=...
-- Classic rod recipes already present in the reference catalogue. Reference
-- ingredients and guessed tier substitutions never establish readiness: the
-- open client's requirements, physical output and reagent schematic do.
local rods={[7421]=true,[7795]=true,[13628]=true,[13702]=true,[20051]=true}
app.words.de.cta_rod='Rute herstellen';app.words.en.cta_rod='Craft rod'
app.words.de.cta_rod_wait='Rute prüfen';app.words.en.cta_rod_wait='Check rod'
app.words.de.rod_wait='Warte auf bestaetigten Rutenbestand und die Rezeptvoraussetzung.'
app.words.en.rod_wait='Waiting for confirmed rod stock and recipe requirements.'
app.words.de.cta_rod_collect='Rute abholen';app.words.en.cta_rod_collect='Collect rod'
app.words.de.rod_collect='Hole die vorhandene Rute aus Bank, Lager oder vom anderen Charakter in deine Taschen.'
app.words.en.rod_collect='Move the existing rod from storage or the other character into your bags.'
local function bags(id)
    return id and app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)
end
local function physical(r)
    return r and rods[r.id]and r.profession==333 and r.confirmed and r.materialsFromClient
        and r.outputItemID and r.outputMin==1 and r.outputMax==1 and r.isEnchantingRecipe~=true
end
local function waitTask(r)
    return {kind='rod_wait',key='rod_wait:'..r.id,recipe=r,body=app.caption('rod_wait')}
end
local function namedRod(name)
    local found
    for id in pairs(rods)do
        local r=app.active.recipes[id]
        if r and r.confirmed and (r.liveName==name or r.outputName==name)then
            if found then return nil end -- ambiguous localized names
            found=r
        end
    end
    return found
end
local function outputRod(id)
    local found
    for spell in pairs(rods)do
        local r=app.active.recipes[spell]
        if physical(r)and r.outputItemID==id then
            if found then return nil end
            found=r
        end
    end
    return found
end
local function rootRecipe()
    if not app.active or app.active.invalidated or app.active.profile.id~=333 then return nil end
    if app.productionEnabled()then
        local j=app.productionJob()
        return j and j.remaining>0 and app.active.recipes[j.recipe]or nil
    end
    local d=app.decision
    if app.shopping.goal=='manual'and app.planningTarget()and app.planningTarget()<=app.active.profile.skill then return nil end
    return d and not d.current.needsLearning and d.current.recipe.learned and d.current.recipe or nil
end
local function quoteRod(r)
    local q=app.quote(r,{})
    if q then return q end
    -- A soulbound rod that is already owned needs no market valuation.
    -- Missing, unpriced ingredients still block purchases and preparation.
    local inputs,cost={},0
    for _,group in ipairs(r.groups or {})do
        local selected
        for _,id in ipairs(group.choices)do
            local unit=app.unitPrice(id,{})
            local stock=app.inventoryFor(id)
            if not unit and stock and type(stock.total)=='number'and stock.total>=group.amount then unit=0 end
            if type(unit)=='number'and unit>=0 and (not selected or unit<selected.unit)then selected={item=id,amount=group.amount,unit=unit}end
        end
        if not selected then return nil end
        inputs[#inputs+1]=selected;cost=cost+selected.amount*selected.unit
    end
    return #inputs>0 and {inputs=inputs,cost=cost}or nil
end
-- Return a plan, an overriding task, and whether a prerequisite owns the flow.
-- No profession selection, purchase or protected craft is performed here.
function app.rodPreparationPlan()
    local root=rootRecipe()
    local j=app.character and app.character.rodPreparation
    if not root then return nil,nil,false end
    if j and j.pending then
        local p=j.pending;local n=bags(p.output)
        if type(n)~='number'or n<=p.before then return nil,waitTask(app.active.recipes[p.recipe]or root),true end
        j.pending=nil
    end
    local requirement=app.missingCraftRequirement(root,true)
    if not requirement then
        if j and j.root==root.id and not app.purchasePending()and not app.craftBatch then
            if app.nativeCraftHandoff and app.nativeCraftHandoff.plan and app.nativeCraftHandoff.plan.toolPreparation then app.clearNativeCraft()end
            app.character.rodPreparation=nil;app.newPurchasePlan()
        end
        return nil,nil,false
    end
    local target=namedRod(requirement.name)
    if not target then return nil,nil,false end
    if not j or j.root~=root.id or j.target~=target.id then
        if app.purchasePending()or app.craftBatch or app.nativeCraftHandoff then return nil,app.craftRequirementTask(root,true),true end
        app.character.rodSerial=(app.character.rodSerial or 0)+1
        j={root=root.id,target=target.id,serial=app.character.rodSerial};app.character.rodPreparation=j
    end
    local visited={}
    local function resolve(r)
        if visited[r.id]then return nil,app.craftRequirementTask(root,true)end
        visited[r.id]=true
        if not r.learned then return nil,app.recipeLearningTask(r)end
        if not physical(r)or not r.complete then return nil,app.craftRequirementTask(root,true)end
        local count=bags(r.outputItemID)
        if type(count)~='number'then return nil,waitTask(r)end
        if count>0 then
            local _,live=app.recipeRequirements(root)
            if not live then return nil,{kind='open',key='rod_reopen:'..root.id,recipe=root,body=app.caption('step_open_profession')}end
            return nil,waitTask(r) -- client must confirm usable tool
        end
        local stored=app.inventoryFor(r.outputItemID)
        if stored and type(stored.total)=='number'and stored.total>0 then
            return nil,{kind='rod_collect',key='rod_collect:'..r.id,recipe=r,
                requirement={name=r.liveName},body=app.caption('rod_collect')}
        end
        if r.cooldown or r.craftLimit==0 then return nil,{kind='cooldown',key='rod_cd:'..r.id,recipe=r,body=app.caption('requirement_cooldown')}end
        if r.disabled then return nil,app.craftRequirementTask(root,true)end
        local tool=app.missingCraftRequirement(r,true)
        if tool then
            local lower=namedRod(tool.name)
            if lower then return resolve(lower)end
            return nil,app.craftRequirementTask(r,true)
        end
        -- Some clients express an older rod as a consumed reagent rather
        -- than a reusable Totem. Respect only the live, unambiguous slot.
        for _,group in ipairs(r.groups or {})do
            if #group.choices==1 and group.amount==1 then
                local id=group.choices[1];local lower=outputRod(id);local stock=app.inventoryFor(id)
                if lower and stock and type(stock.total)=='number'and stock.total<1 then return resolve(lower)end
            end
        end
        return r
    end
    local recipe,task=resolve(target)
    if not recipe then return nil,task,true end
    if j.recipe~=recipe.id then
        if app.purchasePending()then return nil,waitTask(recipe),true end
        j.recipe=recipe.id;j.output=recipe.outputItemID;j.before=bags(j.output)
        app.newPurchasePlan()
    end
    local q=quoteRod(recipe)
    if not q then return nil,{kind='review',key='rod_prices:'..recipe.id,recipe=recipe,body=app.caption('no_prices')},true end
    local totals,rows,purchase,known={},{},0,true
    for _,input in ipairs(q.inputs)do
        local row=totals[input.item]or {id=input.item,total=0,unit=input.unit};totals[input.item]=row
        row.total=row.total+input.amount
    end
    for id,row in pairs(totals)do
        row.locations=app.inventoryFor(id);row.owned=row.locations and row.locations.total
        if type(row.owned)~='number'then known=false end
        row.buy=math.max(0,row.total-(row.owned or 0));row.name=app.itemName(id)
        row.vendorUnit=app.vendorPrice(id);row.vendor=row.vendorUnit and row.vendorUnit<=row.unit or false
        rows[#rows+1]=row;purchase=purchase+row.buy*row.unit
    end
    table.sort(rows,function(a,b)return a.id<b.id end)
    local skill=app.active.profile.skill
    return {toolPreparation=true,production=true,jobSerial=j.serial,purchaseSlice=recipe.id,parentRecipe=root.id,
        recipe=recipe,crafts=1,from=skill,target=skill,rows=rows,purchase=purchase,stockKnown=known,estimated=false},nil,true
end
function app.rodCraftEvent(event,unit,guid,id)
    local j=app.character and app.character.rodPreparation
    if not j or unit~='player'or id~=j.recipe then return end
    if event=='UNIT_SPELLCAST_START'or event=='UNIT_SPELLCAST_CHANNEL_START'then
        if not j.pending then j.before=bags(j.output)end
    elseif event=='UNIT_SPELLCAST_SUCCEEDED'and not j.pending and (not guid or guid~=j.lastGUID)then
        j.lastGUID=guid
        j.pending={recipe=id,output=j.output,before=j.before or 0}
        app.flowLog('rod.await_stock',{recipe=id,output=j.output})
    end
end
