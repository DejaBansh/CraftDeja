-- SPDX-License-Identifier: MIT
local _,app=...
local words={de={source_choose='Materialquelle wählen',source_ah='Im AH kaufen',source_stock='Eigenbestand verwenden',source_probe='Eigenbestand prüfen',source_compare='%s: AH-Zukauf %s. Eigenbestand: %d Stück, geschätzter Materialwert %s. Kein garantierter Verkaufserlös.',source_same='%s: %d vorhanden (Taschen/Bank). Bestand verwenden oder diese Menge zusätzlich im AH kaufen und den alten Bestand behalten?',source_alternative='%s statt %s verwenden? Vorhanden: %d. Stückpreis: %s statt %s. Preise sind Schätzungen.',source_advantage='%s: AH %s statt Händler %s/Stück.',source_probe_note='Eigene Rohstoffe vorhanden. Öffne den herstellenden Beruf, damit gelerntes Rezept, Ausbeute und Zutaten geprüft werden.',source_return='Zum ursprünglichen Auftrag',source_open='Herstellenden Beruf öffnen',source_missing='Dieser Herstellungsweg ist aktuell nicht nativ bestätigt oder es fehlen eigene Rohstoffe. Zurück zum Auftrag und erneut auswählen.',source_reserved='Alter Bestand bleibt reserviert; nur zusätzlich erhaltene Materialien zählen für diesen Abschnitt.',source_review='Materialwahl ändern',source_resume='Zwischenprodukt vorhanden. Kehre zum ursprünglichen Beruf zurück.'},en={source_choose='Choose material source',source_ah='Buy from AH',source_stock='Use owned supplies',source_probe='Check owned supplies',source_compare='%s: AH purchase %s. Owned supplies: %d units, estimated material value %s. Not guaranteed sale proceeds.',source_same='%s: %d owned (bags/bank). Use these supplies or buy this quantity from the AH and keep the old stock?',source_alternative='Use %s instead of %s? Owned: %d. Unit price: %s versus %s. Prices are estimates.',source_advantage='%s: AH %s versus vendor %s/unit.',source_probe_note='You own raw materials. Open the producing profession to verify the learned recipe, yield and ingredients.',source_return='Return to original order',source_open='Open producing profession',source_missing='This production path is not currently confirmed by the client, or owned ingredients are missing. Return to the order and choose again.',source_reserved='Old stock stays reserved; only additionally received materials count for this stage.',source_review='Change material choice',source_resume='Intermediate material available. Return to the original profession.'}}
for lang,t in pairs(words)do for k,v in pairs(t)do app.words[lang][k]=v end end
app.words.de.source_check_prices='Kein aktueller AH-Preisstand. Vor einem Kauf Preise neu prüfen.'
app.words.en.source_check_prices='No current AH price snapshot. Refresh prices before a purchase.'
app.words.de.source_same='%s: %d vorhanden (Taschen/Bank). Für diesen Abschnitt: %d Stück. Eigenbestand verwenden oder im AH kaufen und den alten Bestand behalten?'
app.words.en.source_same='%s: %d owned (bags/bank). This stage needs %d units. Use owned supplies or buy from the AH and keep the old stock?'
local function busy()return app.craftRefreshBusy()or app.nativeCraftHandoff or app.purchasePending()end
local function own(id)local r=app.inventoryFor(id);return math.max(0,(r.bags or 0)+(r.bank or 0)),r end
local function stage(plan)
    if not plan or not plan.recipe or plan.sourceConversion or plan.toolPreparation or plan.routeSupply then return end
    local key=table.concat({plan.recipe.profession,plan.recipe.id,plan.target or 0},':')
    return plan.production and key..':job:'..tostring(plan.jobSerial)or key
end
local function state(plan)
    local key=stage(plan);if not key then return end
    app.materialStages=app.materialStages or app.character.materialSourceStages or {}
    local s=app.materialStages[key]
    if not s then s={choices={},recipe=plan.recipe.id,profession=plan.recipe.profession,target=plan.target,production=plan.production==true};app.materialStages[key]=s end
    return s,key
end
function app.preferredOwnedReagent(recipe,index)
    local s=app.materialStage
    if not s or s.recipe~=recipe.id or s.profession~=recipe.profession or not s.production and app.active and app.active.profile.id==s.profession and app.active.profile.skill>=(s.target or 0)then return end
    local c=s.choices['group:'..index]
    if c and c.source=='stock'and own(c.item)>0 then return c.item end
end
function app.validateMaterialReagents(recipe,form,prepare)
    if not recipe then return false end
    local q
    for index,g in ipairs(recipe.groups or {})do if #g.choices>1 then
        q=q or app.quote(recipe,{})
        local id=q and q.inputs[index]and q.inputs[index].item
        local transaction=app.try(form.GetTransaction,form)or form.transaction
        local slot=g.slotIndex
        if not id or not slot or not transaction then return false end
        local reagent={itemID=id}
        if prepare and not pcall(transaction.OverwriteAllocation,transaction,slot,reagent,g.amount)then return false end
        if prepare then
            for _,widgets in pairs(form.reagentSlots or {})do for _,widget in ipairs(widgets)do
                local schematic=app.try(widget.GetReagentSlotSchematic,widget)
                if schematic and schematic.slotIndex==slot then app.try(widget.SetReagent,widget,reagent)end
            end end
        end
        local allocation=app.try(transaction.GetAllocations,transaction,slot)
        if not allocation or app.try(allocation.GetQuantityAllocated,allocation,reagent)~=g.amount or app.try(allocation.Accumulate,allocation)~=g.amount then return false end
    end end
    local event=prepare and q and ProfessionsRecipeSchematicFormMixin and ProfessionsRecipeSchematicFormMixin.Event and ProfessionsRecipeSchematicFormMixin.Event.AllocationsModified
    if event then app.try(form.TriggerEvent,form,event)end
    return true
end
function app.applyMaterialSources(plan)
    local s=state(plan);if not s then return plan end
    app.materialStage=s
    if next(s.choices)==nil then return plan end
    local limit=plan.crafts
    for index,g in ipairs(plan.recipe.groups or {})do
        local c=s.choices['group:'..index]
        if c and c.source=='stock'and app.preferredOwnedReagent(plan.recipe,index)then
            local each=g.amount
            for _,r in ipairs(plan.rows)do if r.id==c.item then each=r.total/math.max(1,plan.crafts)end end
            limit=math.min(limit,math.floor(own(c.item)/each))
        end
    end
    local ratio=limit/math.max(1,plan.crafts);plan.crafts=limit;plan.purchase=0
    for _,r in ipairs(plan.rows)do
        r.total=math.ceil(r.total*ratio-.000001)
        local c=s.choices['item:'..r.id]
        if c and c.source=='ah'then
            local actual=app.inventoryFor(r.id);local available=math.max(0,(actual.bags or 0)+(actual.bank or 0)-c.reserve)
            r.locations=app.copy(actual);r.locations.bags=math.min(actual.bags or 0,available)
            r.locations.bank=math.min(actual.bank or 0,math.max(0,available-r.locations.bags));r.locations.shared=0;r.locations.deductibleAlts=0
            r.locations.total=available;r.owned=available;r.reservedStock=c.reserve
        end
        r.buy=math.max(0,r.total-(r.owned or 0));plan.purchase=plan.purchase+r.buy*r.unit
    end
    return plan
end
local materialPlan=app.materialPlan
app.materialPlan=function(recipe,target,...)
    local stages=app.materialStages or app.character and app.character.materialSourceStages or {}
    local saved=recipe and stages[table.concat({recipe.profession,recipe.id,target or 0},':')]
    if saved then app.materialStage=saved
    elseif app.materialStage and recipe and app.materialStage.recipe==recipe.id and app.materialStage.target~=target then app.materialStage=nil end
    local p,why=materialPlan(recipe,target,...);return p and app.applyMaterialSources(p)or nil,why
end
local productionPlan=app.productionPlan
app.productionPlan=function(...)
    local p=app.active and app.active.profile;local j=app.productionJob()
    local stages=app.materialStages or app.character and app.character.materialSourceStages or {}
    local saved=p and j and stages[p.id..':'..j.recipe..':'..p.skill..':job:'..j.serial]
    if saved then app.materialStage=saved end
    local plan,why=productionPlan(...);return plan and app.applyMaterialSources(plan)or nil,why
end
local complete=app.completeShoppingPlan
app.completeShoppingPlan=function(p)return complete(app.applyMaterialSources(p))end
-- Selecting a different owned reagent is applied by Economy.quote itself;
-- the normal price comparison remains unchanged until the explicit click.
local function hasProfession(id)
    for _,i in pairs({app.try(GetProfessions)})do local _,_,skill,_,_,_,p=app.try(GetProfessionInfo,i);if p==id and type(skill)=='number'and skill>0 then return true,skill end end
    return false
end
local function conversion(recipe,item,needed,parent)
    if not recipe or not recipe.learned or not recipe.confirmed or not recipe.materialsFromClient or not recipe.outputFromClient or
        recipe.outputItemID~=item or not recipe.outputMin or recipe.outputMin<1 or recipe.outputMin~=recipe.outputMax or recipe.disabled or recipe.cooldown or recipe.craftLimit==0 then return end
    local owns,skill=hasProfession(recipe.profession)
    if not owns or recipe.skill and recipe.skill>skill then return end
    local count=math.ceil(needed/recipe.outputMin);local value=0;local priced=true;local rows={}
    for _,g in ipairs(recipe.groups or {})do
        if #g.choices~=1 or not g.amount or g.amount<1 then return end
        local id=g.choices[1];if id==item then return end
        local have,loc=own(id);local reserved=0
        for _,r in ipairs(parent.rows or {})do if r.id==id then reserved=reserved+r.total end end
        count=math.min(count,math.floor(math.max(0,have-reserved)/g.amount))
        local unit=app.unitPrice(id,{})
        if not unit then priced=false end
        value=value+g.amount*(unit or 0);rows[#rows+1]={id=id,amount=g.amount,unit=unit or 0,locations=loc}
    end
    if count<1 or #rows==0 then return end
    if type(recipe.craftLimit)=='number'then count=math.min(count,recipe.craftLimit)end
    return {recipe=recipe,profession=recipe.profession,item=item,crafts=count,quantity=count*recipe.outputMin,value=priced and value*count or nil,inputs=rows}
end
local function conversions(item)
    local index=app.ownedConversionIndex or {profiles={},items={}}
    local changed=false
    for id,p in pairs(app.character.routeProfessions or {})do if index.profiles[id]~=p then changed=true end end
    for id in pairs(index.profiles)do if not(app.character.routeProfessions or {})[id]then changed=true end end
    if changed then
        index={profiles={},items={}}
        for id,p in pairs(app.character.routeProfessions or {})do
            index.profiles[id]=p
            for _,r in pairs(p.recipes or {})do if r.outputItemID then
                local rows=index.items[r.outputItemID]or {};index.items[r.outputItemID]=rows;rows[#rows+1]={recipe=r,at=p.at,profession=id}
            end end
        end
        app.ownedConversionIndex=index
    end
    return index.items[item]or {}
end
function app.ownedSourceCandidate(plan)
    if busy()or not plan or not plan.stockKnown or plan.sourceConversion or app.isPoison()then return end
    local s=state(plan);if not s then return end
    for index,g in ipairs(plan.recipe.groups or {})do
        local selected=s.choices['group:'..index]
        if #g.choices>1 and (not selected or selected.source=='stock'and own(selected.item)==0)then
            local cheapest,price
            for _,id in ipairs(g.choices)do local p=app.unitPrice(id,{});if p and (not price or p<price)then cheapest,price=id,p end end
            for _,id in ipairs(g.choices)do local have=own(id);local p=app.unitPrice(id,{})
                if id~=cheapest and have>0 and p and price then return {key='group:'..index,kind='alternative',item=id,cheapest=cheapest,owned=have,value=p,ah=price,quantity=g.amount*plan.crafts,group=index}end
            end
        end
    end
    for _,r in ipairs(plan.rows)do
        local key='item:'..r.id;local have=own(r.id)
        if have>0 and not s.choices[key]and not r.vendor and not(app.confirmedMail(r.id)>0)then
            return {key=key,kind='stock',item=r.id,owned=have,ah=r.unit,quantity=r.total}
        end
        if r.buy>app.confirmedMail(r.id)and not r.vendor and (not s.choices[key]or s.choices[key].source=='stock')then
            for _,entry in ipairs(conversions(r.id))do
                if entry.profession~=plan.recipe.profession and entry.at and (app.try(time)or 0)>=entry.at and (app.try(time)or 0)-entry.at<=604800 then
                        local c=conversion(entry.recipe,r.id,r.buy-app.confirmedMail(r.id),plan)
                        if c then c.key=key;c.kind='conversion';c.ah=r.unit;c.ahQuantity=math.min(r.buy-app.confirmedMail(r.id),c.quantity);c.owned=c.quantity;return c end
                end
            end
            -- Copper is a discovery hint, not proof that this player learned
            -- Smelt Copper. Native recipe data is required before preparation.
            if r.id==2840 and hasProfession(186)and own(2770)>0 then return {key=key,kind='conversion',item=2840,profession=186,recipeID=2657,probe=true,ah=r.unit,quantity=math.min(r.buy-app.confirmedMail(r.id),(own(2770)))}end
        end
    end
end
function app.chooseMaterialSource(plan,c,source)
    if busy()or not plan or not c or source~='ah'and source~='stock'then return false end
    local p=app.active and app.active.profile
    if not p or p.id~=plan.recipe.profession then return false end
    local r=app.active.recipes[plan.recipe.id]
    if not r or not r.learned then return false end
    local current=plan.production and app.productionPlan()or app.materialPlan(r,plan.target)
    current=current and app.completeShoppingPlan(current)
    if not current or current.crafts~=plan.crafts or current.from~=plan.from then app.refreshNextStep(true);return false end
    local fresh=app.ownedSourceCandidate(current)
    if not fresh or fresh.key~=c.key or fresh.item~=c.item or fresh.kind~=c.kind or fresh.quantity~=c.quantity or fresh.ahQuantity~=c.ahQuantity or fresh.ah~=c.ah or fresh.value~=c.value or fresh.owned~=c.owned then app.refreshNextStep(true);return false end
    local s,key=state(plan)
    app.character.materialSourceStages=app.materialStages
    if source=='stock'and c.kind=='conversion'then
        app.materialConversion={origin=plan.recipe.profession,parent=app.copy(plan),key=key,candidate=c,before=select(2,own(c.item)).bags or 0}
    else
        s.choices[c.key]={source=source,item=source=='ah'and c.kind=='alternative'and c.cheapest or c.item,reserve=source=='ah'and c.kind=='stock'and (own(c.item))or 0}
        if c.kind=='alternative'then
            local id=source=='ah'and c.cheapest or c.item
            s.choices['item:'..id]={source=source,item=id,reserve=source=='ah'and (own(id))or 0}
        end
    end
    app.newPurchasePlan();app.refresh(false);app.refreshNextStep(true);return true
end
function app.ownedConversionPlan()
    local j=app.materialConversion;local a=app.active
    if not j or not a or a.profile.id~=j.candidate.profession then return end
    local r=a.recipes[j.candidate.recipeID or j.candidate.recipe.id]
    local held=select(2,own(j.candidate.item)).bags or 0
    local required=math.max(0,(j.candidate.quantity or 0)-(held-j.before))
    if required<=0 then j.complete=true;return end
    local c=conversion(r,j.candidate.item,required,j.parent);if not c then return end
    local p={recipe=r,sourceConversion=true,production=true,routeSupply=true,jobSerial='owned:'..j.key,crafts=c.crafts,rows={},purchase=0,stockKnown=true,from=a.profile.skill,target=a.profile.skill}
    for _,input in ipairs(c.inputs)do local loc=app.inventoryFor(input.id);p.rows[#p.rows+1]={id=input.id,total=input.amount*c.crafts,buy=0,owned=loc.total,locations=loc,unit=input.unit,name=app.itemName(input.id)}end
    return p
end
local received=app.addConfirmedMaterial
app.addConfirmedMaterial=function(id,quantity,row)
    received(id,quantity,row)
    local s=app.materialStage
    if s and not s.choices['item:'..id]then s.choices['item:'..id]={source='stock',item=id}end
end
function app.returnFromMaterialConversion()
    if busy()then return false end
    local j=app.materialConversion;if not j then return false end
    app.materialConversion=nil
    local s=app.materialStages[j.key];if s then s.choices[j.candidate.key]=j.complete and {source='stock',kind='conversion',item=j.candidate.item}or nil end
    if not app.openCraftProfession(j.parent.recipe.id,j.origin)then app.materialConversion=j;return false end
    app.refreshNextStep(true);return true
end
function app.materialSourceTask(plan)
    local c=app.ownedSourceCandidate(plan);if not c then return end
    local body
    if c.kind=='stock'then body=app.caption('source_same',app.itemName(c.item),c.owned,c.quantity)
    elseif c.kind=='alternative'then body=app.caption('source_alternative',app.itemName(c.item),app.itemName(c.cheapest),c.owned,app.money(c.value),app.money(c.ah))
    elseif c.probe then body=app.caption('source_probe_note')
    else body=app.caption('source_compare',app.itemName(c.item),app.money((c.ahQuantity or c.quantity)*c.ah),c.quantity,app.money(c.value))end
    if not app.shoppingPricesCurrent()then body=body..'\n'..app.caption('source_check_prices')end
    return {kind='material_choice',key='source:'..stage(plan)..':'..c.key,body=body,candidate=c}
end
app.words.de.source_check_prices='AH-Preisstand vor einem neuen Kauf aktualisieren.'
app.words.en.source_check_prices='Update auction house prices before a new purchase.'
local step=app.nextStep
local refresh=app.refreshNextStep
app.refreshNextStep=function(force)
    local j=app.materialConversion
    if j and not app.craftBatch and not app.nativeCraftHandoff then
        local a=app.active;local p=app.ownedConversionPlan();local t
        if j.complete then t={kind='source_return',key='source_return',body=app.caption('source_resume')}
        elseif not a or a.profile.id~=j.candidate.profession then t={kind='source_open',key='source_open',body=app.caption('source_probe_note')}
        elseif p then t=step(p)
        else t={kind='source_return',key='source_missing',body=app.caption('source_missing')}end
        app.renderNextStep(p,true,t);return
    end
    return refresh(force)
end
local render=app.renderNextStep
app.renderNextStep=function(plan,keep,task)
    if plan and not busy()then
        plan=app.applyMaterialSources(plan)
        local eligible=not task or task.kind=='route_bank'or task.kind=='craft'or task.kind=='station'or task.kind=='bank'or task.kind=='ah'or task.kind=='ah_buy'or task.kind=='ah_load'
        if eligible then task=app.materialSourceTask(plan)or task end
    end
    if plan and not task then task=app.nextStep(plan)end
    if plan and task and not task.sourcePriceNote and app.shoppingPricesCurrent()then
        local lines={}
        for _,r in ipairs(plan.rows)do if r.buy>0 and not r.vendor and r.vendorUnit and r.unit<r.vendorUnit and #lines<3 then lines[#lines+1]=app.caption('source_advantage',r.name,app.money(r.unit),app.money(r.vendorUnit))end end
        if #lines>0 then task=app.copy(task);task.body=task.body..'\n'..table.concat(lines,'\n');task.sourcePriceNote=true end
    end
    if plan and task and not task.sourceReserveNote then
        for _,r in ipairs(plan.rows)do if r.reservedStock and r.reservedStock>0 then task=app.copy(task);task.body=task.body..'\n'..app.caption('source_reserved');task.sourceReserveNote=true;break end end
    end
    render(plan,keep,task)
end
local action=app.unifiedAction
app.unifiedAction=function(f)
    if f.task.kind=='material_choice'then return app.chooseMaterialSource(f.plan,f.task.candidate,'ah')
    elseif f.task.kind=='source_open'then local c=app.materialConversion.candidate;app.openCraftProfession(c.recipeID or c.recipe.id,c.profession);return true
    elseif f.task.kind=='source_return'then return app.returnFromMaterialConversion()
    elseif f.task.kind=='rank'then
        if app.materialRankPending or f.task.levelBlocked then return true end
        local offer=app.currentMaterialRankOffer()
        if offer then
            local shown=f.materialRankOffer
            if not shown or shown.id~=offer.id or shown.cost~=offer.cost or shown.index~=offer.index or shown.npc~=app.try(UnitGUID,'npc')then app.refreshNextStep(true);return true end
            local money=app.try(GetMoney)
            if not busy()and type(money)=='number'and money>=offer.cost and type(BuyTrainerService)=='function'then
                app.materialRankPending={at=app.try(GetTime)or 0,profession=app.active.profile.id,cap=app.active.profile.cap}
                local ok=pcall(BuyTrainerService,offer.index)
                if not ok then app.materialRankPending=nil end
                app.refreshNextStep(true)
            end
            return true
        end
    end
    return action(f)
end
local cta=app.applyGuideCTA
app.applyGuideCTA=function(f,plan)
    cta(f,plan)
    local k=f.task.kind
    if k=='material_choice'then local c=f.task.candidate;f.body:SetText(app.caption('source_choose'));f.primaryCTA:SetText(app.caption('source_ah')..' · '..app.money(app.shoppingPricesCurrent()and (c.ahQuantity or c.quantity or 1)*c.ah or nil));f.primaryCTA:Enable()
    elseif k=='source_open'then f.primaryCTA:SetText(app.caption('source_open'));f.primaryCTA:Enable()
    elseif k=='source_return'then f.primaryCTA:SetText(app.caption('source_return'));f.primaryCTA:Enable()end
    if k=='rank'then
        local pending=app.materialRankPending
        if pending and (app.active.profile.cap>pending.cap or (app.try(GetTime)or 0)-pending.at>10)then app.materialRankPending=nil;pending=nil end
        local offer=app.currentMaterialRankOffer()
        f.materialRankOffer=offer and {id=offer.id,cost=offer.cost,index=offer.index,npc=app.try(UnitGUID,'npc')}or nil
        if pending then f.primaryCTA:SetText(app.caption('cta_wait'));f.primaryCTA:Disable()
        elseif offer then f.primaryCTA:SetText(app.caption('cta_rank')..' · '..app.money(offer.cost));f.primaryCTA:SetEnabled((app.try(GetMoney)or 0)>=offer.cost and not f.task.levelBlocked)end
    end
end
local rankTask=app.rankTrainerTask
app.rankTrainerTask=function()
    local t=rankTask()
    if t.trainer then t.body=t.body..'\n'..t.trainer.name..' · '..app.merchantLocation(t.trainer)..(t.trainer.reference and '\n'..app.caption('trainer_reference')or '')end
    return t
end
function app.currentMaterialRankOffer()
    local p=app.active and app.active.profile
    if not p or not app.materialTrainerOpen or not app.try(UnitGUID,'npc')then return end
    local id=(app.routeRankSpells[p.id]or {})[p.cap];if not id then return end
    local offer
    for _,r in ipairs(app.currentTrainerOffers())do if r.id==id then
        if offer or r.kind~='available'or not app.routeFinite(r.cost)or r.cost~=math.floor(r.cost)then return end
        offer=r
    end end
    return offer
end
local trainerEvents=CreateFrame('Frame')
trainerEvents:RegisterEvent('TRAINER_SHOW');trainerEvents:RegisterEvent('TRAINER_CLOSED');trainerEvents:RegisterEvent('TRAINER_UPDATE')
trainerEvents:SetScript('OnEvent',function(_,event)
    if event=='TRAINER_SHOW'then app.materialTrainerOpen=true elseif event=='TRAINER_CLOSED'then app.materialTrainerOpen=nil;app.materialRankPending=nil end
    if app.saved and not app.craftRefreshBusy()then app.refreshNextStep()end
end)
local paint=app.paintWorkshopGuide
local function addMaterialAction(f,button)
    local _,_,_,_,y=f.workshopToggle:GetPoint()
    button:ClearAllPoints();button:SetPoint('TOPLEFT',20,y)
    button:SetWidth(380);button.label:SetWidth(340);app.styleCTAButton(button,false)
    f.workshopToggle:ClearAllPoints();f.workshopToggle:SetPoint('TOPLEFT',20,y-36)
    f:SetHeight(f:GetHeight()+36)
end
app.paintWorkshopGuide=function(f)
    paint(f);if not f or not f.task or app.unifiedView then return end
    if not f.materialStock then f.materialStock=app.createButton(f,20,0,380,'',function()
        if f.task.kind=='material_choice'then app.chooseMaterialSource(f.plan,f.task.candidate,'stock')else app.returnFromMaterialConversion()end
    end)end
    local show=f.task.kind=='material_choice'or app.materialConversion~=nil and not busy()
    f.materialStock:SetShown(show)
    if show then
        f.materialStock:SetText(app.caption(f.task.kind=='material_choice'and (f.task.candidate.probe and 'source_probe'or 'source_stock')or 'source_return'))
        addMaterialAction(f,f.materialStock)
    end
    if not f.materialReview then f.materialReview=app.createButton(f,20,0,380,'',function()
        if busy()or not f.plan then return end
        local s=state(f.plan);if s then s.choices={};app.newPurchasePlan();app.refresh(false);app.refreshNextStep(true)end
    end)end
    local review=not show and f.plan and stage(f.plan)and app.materialStage and next(app.materialStage.choices)~=nil and not busy()
    f.materialReview:SetShown(review==true)
    if review then f.materialReview:SetText(app.caption('source_review'));addMaterialAction(f,f.materialReview)end
    app.workshopFit(f,420,f:GetHeight(),app.options.windowScales and app.options.windowScales.CraftDejaNextStep or app.options.scale)
end
local supply=app.routeBankRows
app.routeBankRows=function(...)
    local rows=supply(...);local s=app.materialStage;local result={}
    for _,r in ipairs(rows)do local c=s and s.choices['item:'..r.item];if not c or c.source~='ah'then result[#result+1]=r end end
    return result
end
local routeTask=app.routeTask
app.routeTask=function(plan)
    local o=app.currentRouteOrder();local p=app.active and app.active.profile
    if o and p and o.profession==p.id and o.rankCheckpoint and p.cap>o.rankCheckpoint then
        if o.target<=o.rankCheckpoint then o.target=p.cap;o.finished=nil;app.invalidateRoute('new_order')end
        o.rankCheckpoint=nil
    end
    return routeTask(plan)
end
