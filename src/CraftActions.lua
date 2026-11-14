-- SPDX-License-Identifier: MIT
local _,app=...
local function fail(key,...)
    app.flowLog('action.blocked',{reason=key})
    app.actionNotice=app.caption(key,...)
    if app.nextStepWindow then app.nextStepWindow.notice:SetText(app.actionNotice)end
    return false
end
local stationWords={en={station_cooking='Go to a cooking fire.',station_required='Missing requirement: %s',station_check='Check crafting requirement',station_help='Move to the required station or supply the missing tool. CraftDeja checks the recipe requirement again; crafting still needs your click.'},de={station_cooking='Gehe zur Kochstelle.',station_required='Fehlende Voraussetzung: %s',station_check='Voraussetzung pruefen',station_help='Gehe zur benoetigten Kochstelle/Arbeitsstation oder besorge das fehlende Werkzeug. Die Anzeige aktualisiert sich, sobald die Voraussetzung erfuellt ist.'}}
for lang,entries in pairs(stationWords)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.requirement_tool='Obtain required tool.';app.words.de.requirement_tool='Besorge das benoetigte Werkzeug.'
app.words.en.requirement_area='Go to the required crafting location.';app.words.de.requirement_area='Gehe zum benoetigten Herstellungsort.'
app.words.en.requirement_checked='Required: %s';app.words.de.requirement_checked='Benoetigt: %s'
app.words.en.requirement_cooldown='Wait until the recipe cooldown or a charge is ready.';app.words.de.requirement_cooldown='Warte, bis die Abklingzeit oder eine Rezeptaufladung bereit ist.'
-- Label only requirements actually reported by the client. Never infer an
-- anvil/forge from the profession alone: individual recipes can differ.
local stationLabels={
    fire={de='Zur Kochstelle',en='Visit cooking fire',names={'Kochstelle','Lagerfeuer','Feuerstelle','Cooking Fire','Campfire'}},
    anvil={de='Zum Amboss',en='Visit anvil',names={'Amboss','Anvil'}},
    forge={de='Zur Schmiede',en='Visit forge',names={'Schmiede','Forge'}},
    furnace={de='Zum Schmelzofen',en='Visit furnace',names={'Schmelzofen','Furnace','Smelting Furnace'}},
    blackAnvil={de='Zum Schwarzen Amboss',en='Visit Black Anvil',names={'Schwarzer Amboss','Black Anvil'}},
    blackForge={de='Zur Schwarzen Schmiede',en='Visit Black Forge',names={'Schwarze Schmiede','Black Forge'}},
    lab={de='Zum Alchemielabor',en='Visit alchemy lab',names={'Alchemielabor','Alchemy Lab','Alchemy Laboratory'}},
    moonwell={de='Zum Mondbrunnen',en='Visit moonwell',names={'Mondbrunnen','Moonwell'}},
    loom={de='Zum Webstuhl',en='Visit loom',names={'Webstuhl','Loom'}},
    bench={de='Zur Werkbank',en='Visit workbench',names={'Werkbank','Workbench'}},
    runeforge={de='Zur Runenschmiede',en='Visit runeforge',names={'Runenschmiede','Runeforge'}},
    enchanting={de='Zum Verzauberungstisch',en='Visit enchanting table',names={'Verzauberungstisch','Enchanting Table'}}
}
local stationAliases={}
for _,entry in pairs(stationLabels)do
    for _,name in ipairs(entry.names)do stationAliases[name:lower()]=entry end
end
function app.craftStationCTA(task)
    local requirement=task and task.requirement
    local name=requirement and requirement.name
    local entry=type(name)=='string'and stationAliases[name:match('^%s*(.-)%s*$'):lower()]
    if entry then return app.uiText and app.uiText(entry[app.lang()]or entry.en)or entry[app.lang()]or entry.en end
    if not name or name==''then
        if task and task.body==app.caption('station_cooking')then return app.caption('cta_fire')end
    end
    local area=requirement and Enum and Enum.RecipeRequirementType and requirement.type==Enum.RecipeRequirementType.Area
    -- Unknown/custom requirements retain the exact client name in the named
    -- requirement row, paired with a travel CTA rather than a check label.
    return app.caption(area and 'cta_area'or 'cta_workshop')
end
app.words.de.craft_safe_forecast='Serie: %d · bis %d ca. %d Versuche'
app.words.en.craft_safe_forecast='Batch: %d · to %d about %d attempts'
app.words.de.craft_forecast_help='Die geschaetzte Versuchszahl ist keine garantierte Skillpunktzahl. Die native Serie wird begrenzt, damit ein frueher Skillpunkt den guenstigeren Rezeptwechsel nicht ueberschreitet.'
app.words.en.craft_forecast_help='Estimated attempts are not guaranteed skill gains. The native batch is bounded so early successes do not pass the cheaper recipe switch.'
app.words.de.cta_attempt='Versuch vorbereiten';app.words.en.cta_attempt='Prepare attempt'
function app.recipeRequirements(recipe)
    if not recipe then return {},false end
    local live=app.professionOpen and app.nativeProfessionVisible()~=false and app.active and app.active.profile.id==recipe.profession
    if live then
        local requirements=app.try(C_TradeSkillUI and C_TradeSkillUI.GetRecipeRequirements,recipe.id)
        if type(requirements)=='table'then recipe.requirements=app.copy(requirements);return requirements,true end
    end
    return recipe.requirements or {},false
end
function app.missingCraftRequirement(recipe,toolsOnly)
    local requirements,live=app.recipeRequirements(recipe)
    local kinds=Enum and Enum.RecipeRequirementType or {}
    -- Portable tools come before travel or ingredient purchases. Cached
    -- station readiness is never used as evidence of the player's location.
    for _,requirement in ipairs(requirements)do
        if kinds.Totem~=nil and requirement.type==kinds.Totem and requirement.met~=true and (live or toolsOnly)then return requirement,live end
    end
    if live and not toolsOnly then
        for _,requirement in ipairs(requirements)do if requirement.met~=true then return requirement,true end end
    end
end
function app.craftRequirementTask(recipe,toolsOnly)
    local requirement,live=app.missingCraftRequirement(recipe,toolsOnly)
    if not requirement then return nil end
    local kinds=Enum and Enum.RecipeRequirementType or {}
    local tool=kinds.Totem~=nil and requirement.type==kinds.Totem
    local area=kinds.Area~=nil and requirement.type==kinds.Area
    local kind=tool and 'tool'or 'station'
    local key=kind..':'..recipe.id..':'..tostring(requirement.name)..':'..tostring(live)
    if app.lastRequirementTrace~=key then
        app.lastRequirementTrace=key
        app.flowLog('requirement.missing',{recipe=recipe.id,kind=kind,name=requirement.name,type=requirement.type,live=live,met=requirement.met==true})
    end
    return {kind=kind,key=key,recipe=recipe,requirement=requirement,requirementLive=live,
        body=tool and app.caption('requirement_tool')or area and app.caption('requirement_area')or recipe.profession==185 and requirement.type==kinds.SpellFocus and app.caption('station_cooking')or app.caption('station_required',requirement.name or '?')}
end
function app.craftDisplay(recipe)
    local cached=recipe.craftDisplayCache
    if cached and app.craftRefreshBusy and app.craftRefreshBusy()then return cached.icon,cached.id,cached.minimum,cached.maximum end
    local api=C_TradeSkillUI or {}
    local output=app.try(api.GetRecipeOutputItemData,recipe.id)
    local schematic=app.try(api.GetRecipeSchematic,recipe.id,false)
    local id=type(output)=='table'and output.itemID or type(schematic)=='table'and schematic.outputItemID
    local icon=id and app.itemIcon(id)or app.try(C_Spell and C_Spell.GetSpellTexture or GetSpellTexture,recipe.id)
    if not icon or icon==0 or icon==''then icon=recipe.icon or 'Interface\\Icons\\INV_Misc_QuestionMark'end
    local n=type(schematic)=='table'and schematic.quantityMin
    local minimum,maximum=tonumber(n),type(schematic)=='table'and (tonumber(schematic.quantityMax)or tonumber(n))
    recipe.craftDisplayCache={icon=icon,id=id,minimum=minimum,maximum=maximum}
    return icon,id,minimum,maximum
end
function app.selectNativeRecipe(id)
    local page=ProfessionsFrame and ProfessionsFrame.CraftingPage
    local info=app.try(C_TradeSkillUI and C_TradeSkillUI.GetRecipeInfo,id)
    if page and type(page.SelectRecipe)=='function'and type(info)=='table'then
        local ok=pcall(page.SelectRecipe,page,info)
        if ok then app.pendingRecipeSelection=nil;return true end
    end
    return false
end
function app.openCraftProfession(recipeID,professionID)
    if app.try(InCombatLockdown)then return fail('action_combat')end
    if professionID and not app.supported[professionID]then return fail('action_choose_profession')end
    local profile=professionID and {id=professionID}or app.active and app.active.profile
    if not profile then
        local ids={app.try(GetProfessions)}
        for _,index in pairs(ids)do
            local _,_,_,_,_,_,id=app.try(GetProfessionInfo,index)
            if app.supported[id]then profile={id=id};break end
        end
    end
    if not profile then return fail('action_choose_profession')end
    app.options.visible=true;app.showGuide(false);if not app.unifiedUI then app.main:Show()end
    local api=C_TradeSkillUI
    if not api or type(api.OpenTradeSkill)~='function'then return fail('action_open_unsupported')end
    -- This call comes only from a user click. Opening the native profession may
    -- close the AH; no attempt is made to override Blizzard's panel manager.
    app.pendingRecipeSelection=recipeID or app.active and app.active.profile.id==profile.id and app.decision and app.decision.current.recipe.id or nil
    app.expectedProfession=profile.id
    app.flowLog('api.OpenTradeSkill.request',{profession=profile.id})
    local ok,opened=pcall(api.OpenTradeSkill,profile.id)
    app.flowLog('api.OpenTradeSkill.result',{ok=ok,result=tostring(opened)})
    if not ok or opened==false then app.expectedProfession=nil;return fail('action_open_failed')end
    app.onProfessionOpened(profile.id)
    if app.professionLoading then app.actionNotice=app.caption('profession_loading')else app.actionNotice=nil end
    app.refreshNextStep(true);return true
end
function app.craftAvailability(plan)
    if not plan or not plan.recipe or not plan.recipe.learned or not plan.crafts or plan.crafts<1 or #plan.rows==0 then return 0 end
    if plan.recipe.disabled or plan.recipe.cooldown or not plan.production and (plan.recipe.noSkill or plan.recipe.colour=='grey')then return 0 end
    local available=math.huge
    for _,r in ipairs(plan.rows)do
        local each=r.total and r.total/plan.crafts
        if not each or each<=0 then return 0 end
        local bags=r.locations and r.locations.bags
        if type(bags)~='number'then bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,r.id,false,false,false,false)end
        if type(bags)~='number'then return 0 end
        available=math.min(available,math.floor(bags/each+.000001))
    end
    if type(plan.recipe.craftLimit)=='number'then available=math.min(available,plan.recipe.craftLimit)end
    return available==math.huge and 0 or math.max(0,available)
end
function app.craftBatchInfo(plan)
    local available=app.craftAvailability(plan)
    if available<1 then return {available=0,count=0}end
    if plan.production then return {available=available,count=math.min(available,plan.crafts),stop=math.huge}end
    local d=app.decision;local skill=app.active and app.active.profile.skill or plan.from or 0
    local requested=d and d.current.recipe.id==plan.recipe.id and d.stop or plan.target
    if type(plan.target)=='number'then requested=math.min(requested or plan.target,plan.target)end
    local bounded=app.materialPlan(plan.recipe,requested)
    local stop=bounded and bounded.target or math.min(requested or skill+1,skill+1)
    -- Even if every yellow/green cast succeeds, a native batch must not pass
    -- the next route/green/rank boundary. Failed skill-ups can need another batch.
    local safe=math.max(1,math.floor((stop-skill)/(plan.recipe.points or 1)))
    return {available=available,count=math.min(available,safe,plan.crafts),stop=stop,expected=bounded and bounded.crafts or plan.crafts}
end
function app.updateCraftBatchPlan(b)
    local plan=b and b.plan
    if not plan or not plan.crafts or plan.crafts<1 then return end
    local previous=plan.crafts;plan.crafts=b.remaining;plan.purchase=0;plan.stockKnown=true
    plan.from=app.active and app.active.profile.skill or plan.from
    if not plan.production and plan.forecastSkill~=plan.from then
        local expected,estimated=app.expectedCraftAttempts(plan.recipe,plan.from,plan.forecastTarget or b.stop)
        plan.expectedCrafts=expected or 0;plan.estimated=expected and estimated or plan.estimated;plan.forecastSkill=plan.from
    end
    for _,row in ipairs(plan.rows)do
        row.total=math.floor(row.total/previous*b.remaining+.000001)
        row.locations=app.inventoryFor(row.id);row.owned=row.locations and row.locations.total
        if type(row.owned)~='number'then plan.stockKnown=false end
        row.buy=math.max(0,row.total-(row.owned or 0));plan.purchase=plan.purchase+row.buy*row.unit
    end
end
function app.clearNativeCraft()
    local h=app.nativeCraftHandoff
    if h then
        app.try(h.button.UnlockHighlight,h.button)
        if h.guideButton and h.guideButton~=h.button then app.try(h.guideButton.UnlockHighlight,h.guideButton)end
    end
    if app.hideNativeCue then app.hideNativeCue()end
    app.nativeCraftHandoff=nil
end
function app.focusNativeCraft()
    local h=app.nativeCraftHandoff
    if not h then return false end
    local current=app.active and app.active.recipes[h.id]
    if app.craftRequirementTask(h.plan and h.plan.recipe)or current and (current.cooldown or current.craftLimit==0)then
        app.clearNativeCraft();app.refreshNextStep(true);return false
    end
    app.try(ProfessionsFrame and ProfessionsFrame.Raise,ProfessionsFrame)
    app.try(h.button.LockHighlight,h.button)
    app.actionNotice=nil
    app.refreshNextStep(true);return true
end
function app.stopCraftBatch(userClick)
    local b=app.craftBatch;if not b then return false end
    -- Stopping a protected cast is also left to the player's native button/Esc.
    b.attention=true;app.actionNotice=app.caption('craft_stop_native')
    app.flowLog('craft.native_stop_required',{recipe=b.id,userClick=not not userClick})
    app.refreshNextStep();return false
end
function app.craftBatchEvent(event,unit,guid,id)
    local b=app.craftBatch
    local h=app.nativeCraftHandoff
    local started=event=='UNIT_SPELLCAST_START'or event=='UNIT_SPELLCAST_CHANNEL_START'or event=='UNIT_SPELLCAST_SUCCEEDED'
    if not b and h and started and unit=='player'and id==h.id then
        local now=app.try(GetTime)or 0
        b={id=h.id,total=h.count,remaining=h.count,stop=h.stop,started=now,last=now,phase='running',plan=h.plan}
        app.clearNativeCraft();app.craftBatch=b
        app.flowLog('craft.native_user_start',{recipe=id,count=b.total})
    end
    if not b then return end
    if (event=='UNIT_SPELLCAST_START'or event=='UNIT_SPELLCAST_CHANNEL_START')and unit=='player'and id==b.id then
        b.phase='running';b.last=app.try(GetTime)or 0;app.flowLog('craft.started',{recipe=id,remaining=b.remaining})
    elseif event=='UNIT_SPELLCAST_SUCCEEDED'and unit=='player'and id==b.id and (not guid or guid~=b.lastGUID)then
        b.phase='running';b.lastGUID=guid;b.remaining=math.max(0,b.remaining-1);b.last=app.try(GetTime)or 0
        app.flowLog('craft.completed',{recipe=id,remaining=b.remaining})
        if b.remaining==0 then app.craftBatch=nil end
    elseif (event=='UNIT_SPELLCAST_FAILED'or event=='UNIT_SPELLCAST_INTERRUPTED')and unit=='player'and id==b.id then
        app.flowLog('craft.interrupted',{recipe=id});app.craftBatch=nil
    end
end
function app.checkCraftBatch()
    local h=app.nativeCraftHandoff
    if h then
        local d=app.decision
        local info=app.try(h.form.GetRecipeInfo,h.form)
        local count=app.try(h.input.GetValue,h.input)
        local production=h.plan and h.plan.production
        local current=app.active and app.active.recipes[h.id]
        if not app.professionOpen or not production and (not d or d.current.recipe.id~=h.id)or not info or info.recipeID~=h.id or count~=h.count or app.missingCraftRequirement(h.plan and h.plan.recipe)or current and (current.cooldown or current.craftLimit==0)then
            app.flowLog('craft.native_preparation_changed',{recipe=h.id,quantity=count or 0})
            app.clearNativeCraft()
        end
    end
    local b=app.craftBatch;if not b then return end
    local d=app.decision
    local current=app.active and app.active.recipes[b.id]
    if not(b.plan and b.plan.production)and (d and d.current.recipe.id~=b.id or app.active and app.active.profile.skill>=b.stop or current and (current.noSkill or current.colour=='grey'or current.disabled))and not b.attention then
        app.stopCraftBatch(false);return
    end
    if current and app.professionOpen then app.updateCraftBatchPlan(b)end
    local now=app.try(GetTime)or 0
    if now-(b.last or b.started)>(b.phase=='requested'and 5 or 3)and not app.try(UnitCastingInfo,'player')and not app.try(UnitChannelInfo,'player')then
        app.flowLog(b.phase=='requested'and 'craft.not_started'or 'craft.queue_ended',{recipe=b.id,remaining=b.remaining,completed=b.total-b.remaining});app.craftBatch=nil
        app.actionNotice=app.caption(b.phase=='requested'and 'craft_no_start'or 'craft_batch_incomplete',b.remaining)
    end
end
-- Select and prepare only. The player must click the real native Create
-- button. Never invoke its script/Click or the protected CraftRecipe API here.
local function prepareNativeCraft(recipe,count,stop)
    local page=ProfessionsFrame and ProfessionsFrame.CraftingPage
    local form=page and page.SchematicForm
    local input=page and page.CreateMultipleInputBox
    local button=page and page.CreateButton
    if not form or not input or not button or type(input.SetValue)~='function'or type(input.GetValue)~='function'then
        return false,'native recipe quantity/button unavailable'
    end
    if not app.selectNativeRecipe(recipe.id)then return false,'native recipe selection not ready'end
    local info=app.try(form.GetRecipeInfo,form)
    if not info or info.recipeID~=recipe.id then return false,'native selected recipe does not match'end
    input:SetValue(count)
    local accepted=input:GetValue()
    app.flowLog('craft.native_quantity',{recipe=recipe.id,requested=count,accepted=accepted})
    if accepted~=count then return false,'native quantity does not match requested batch'end
    app.clearNativeCraft()
    app.nativeCraftHandoff={id=recipe.id,count=count,stop=stop,input=input,button=button,form=form,plan=app.craftBatchPlan(recipe,count,stop)}
    app.try(button.LockHighlight,button)
    app.flowLog('craft.native_prepared',{recipe=recipe.id,count=count,button=app.try(button.GetText,button)or 'Create',requiresUserClick=true})
    return true
end
function app.craftBatchPlan(recipe,count,stop)
    local rod=app.rodPreparationPlan()
    local plan=rod and rod.recipe.id==recipe.id and rod or app.productionEnabled()and app.productionPlan()or app.materialPlan(recipe,stop)
    if not plan or plan.crafts<1 then return nil end
    local planned=plan.crafts;plan.crafts=count;plan.purchase=0
    plan.expectedCrafts=planned;plan.forecastTarget=plan.target;plan.forecastSkill=plan.from
    for _,row in ipairs(plan.rows)do
        row.total=math.floor(row.total/planned*count+.000001)
        row.buy=math.max(0,row.total-(row.owned or 0))
        row.vendorUnit=app.vendorPrice(row.id);row.vendor=row.vendorUnit and row.vendorUnit<=row.unit or false
        plan.purchase=plan.purchase+row.buy*row.unit
    end
    return plan
end
function app.craftQueueBody()
    local b=app.craftBatch
    return app.caption(b.attention and 'craft_queue_attention'or b.phase=='requested'and 'craft_queue_waiting'or 'craft_queue_running',b.remaining)
end
function app.craftNext(plan,all)
    if app.craftBatch or app.craftRefreshBusy and app.craftRefreshBusy()then return fail('action_busy')end
    if app.try(InCombatLockdown)then return fail('action_combat')end
    if not app.professionOpen or app.nativeProfessionVisible()==false then return app.openCraftProfession(plan and plan.recipe.id)end
    if app.try(UnitCastingInfo,'player')or app.try(UnitChannelInfo,'player')then return fail('action_busy')end
    local old=plan and plan.recipe.id
    app.refresh(true)
    local d=app.decision
    local rod,_,rodActive=app.rodPreparationPlan()
    if rodActive and not rod then return fail('action_changed')end
    local production=rod or app.productionEnabled()and app.productionPlan()
    if app.productionEnabled()and not production then return fail('production_done')end
    if not production and (not d or d.current.needsLearning or not d.current.recipe.learned)then return fail('action_recipe_missing')end
    local recipe=production and production.recipe or d.current.recipe
    if old~=recipe.id then return fail('action_changed')end
    local requirement=app.craftRequirementTask(recipe)
    if requirement then app.actionNotice=requirement.body;app.refreshNextStep(true);return false end
    if recipe.profession==333 and not(production and production.toolPreparation)then
        app.selectNativeRecipe(recipe.id);return fail('action_enchant_target')
    end
    local quote=app.quote(recipe,{})
    if production and production.toolPreparation then
        quote={inputs={}}
        for _,row in ipairs(production.rows)do quote.inputs[#quote.inputs+1]={item=row.id,amount=row.total}end
    end
    if not quote then return fail('no_prices')end
    local quantities={}
    for _,r in ipairs(quote.inputs)do quantities[r.item]=(quantities[r.item]or 0)+r.amount end
    for id,n in pairs(quantities)do
        local bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)
        if type(bags)~='number'or bags<n then return fail('action_materials')end
    end
    local target=production and math.huge or app.decision.stop
    if not(production and production.toolPreparation)and app.shopping.goal=='manual'then
        local requested=app.planningTarget()
        if type(requested)=='number'then
            if requested<=app.active.profile.skill then return fail('skill_goal_done_button')end
            target=math.min(target,requested)
        end
    end
    local fresh=production or app.materialPlan(recipe,target)
    local batch=fresh and app.craftBatchInfo(fresh)
    local count=all and batch and batch.count or 1
    if not count or count<1 then return fail('action_materials')end
    app.clearNativeCraft();app.craftBlocked=nil
    local called,ok,message=pcall(prepareNativeCraft,recipe,count,batch.stop)
    if not called then message=ok;ok=false end
    if not ok then
        app.clearNativeCraft();app.refreshNextStep();app.flowLog('craft.native_prepare_failed',{recipe=recipe.id,message=tostring(message)})
        return fail('craft_native_missing')
    end
    app.actionNotice=nil;app.refreshNextStep(true);return true
end
