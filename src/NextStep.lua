-- SPDX-License-Identifier: MIT
local _,app=...
local words={en={step_title='Next step',step_vendor='Go to a reagent vendor and buy %d x %s.',step_vendor_here='Buy %d x %s at this vendor.',step_vendor_place='%s\n%s',step_marked='|cff69da85Vendor marked on the map.|r',step_no_marker='Map marker unavailable. Use the coordinates above.',step_no_vendor='No compatible supplier location is known. Visit a reagent vendor.',step_bank='Collect %d x %s from your bank.',step_alt='Transfer %s from the character shown in the material details.',step_ah='Search the AH for the missing materials and confirm purchases in Auctionator.',step_mail='Collect the purchased materials from your mailbox first.',step_craft='Materials are ready. Open your profession and craft %s.',step_unknown='Open your bags and bank to update the material counts.',step_map='Show vendor',step_buy='Buy at vendor',step_details='Material details',step_pack='Vendor packs may round up the purchase quantity.',step_more='Other tasks update after your inventory changes.'},
de={step_title='Nächster Schritt',step_vendor='Gehe zum Händler und kaufe %d x %s.',step_vendor_here='Kaufe bei diesem Händler %d x %s.',step_vendor_place='%s\n%s',step_marked='|cff69da85Händler auf der Karte markiert.|r',step_no_marker='Kartenmarkierung nicht verfügbar. Nutze die Koordinaten oben.',step_no_vendor='Kein passender Händlerstandort bekannt. Besuche einen Reagenzienhändler.',step_bank='Hole %d x %s von deiner Bank.',step_alt='Übertrage %s von dem Charakter aus den Materialdetails.',step_ah='Suche die fehlenden Materialien im AH und bestätige die Käufe in Auctionator.',step_mail='Hole zuerst die gekauften Materialien aus dem Briefkasten.',step_craft='Materialien bereit. Öffne deinen Beruf und stelle %s her.',step_unknown='Öffne Taschen und Bank, um den Materialbestand zu aktualisieren.',step_map='Händler zeigen',step_buy='Beim Händler kaufen',step_details='Materialdetails',step_pack='Händlerpakete können die Kaufmenge aufrunden.',step_more='Weitere Aufgaben folgen nach der Bestandsänderung.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
local mailWords={en={step_mail_list='Go to a mailbox and collect:',step_mail_check='Check collected mail',step_mail_after='Then:',step_mail_vendor='%d x %s from a reagent vendor',step_mail_finish='Craft using the collected materials.',step_mail_wait='Open the mailbox and take the attachments. This step updates when they reach your bags.'},de={step_mail_list='Gehe zum Briefkasten und hole ab:',step_mail_check='Postbestand prüfen',step_mail_after='Danach:',step_mail_vendor='%d x %s beim Händler kaufen',step_mail_finish='Mit den abgeholten Materialien herstellen.',step_mail_wait='Briefkasten öffnen und Anhänge abholen. Sobald sie in deinen Taschen sind, geht es weiter.'}}
for lang,entries in pairs(mailWords)do for k,v in pairs(entries)do app.words[lang][k]=v end end

function app.nextStep(plan)
    if plan and plan.recipe and plan.recipe.learned and not app.craftBatch then
        local tool=app.craftRequirementTask(plan.recipe,true)
        if tool then if app.nativeCraftHandoff then app.clearNativeCraft()end;return tool end
    end
    if app.active and app.shopping.open and not app.shoppingFresh()and not app.craftBatch then return {kind='scan',key='scan',body=app.scanWaitText()}end
    if app.craftBatch then return {kind='craft_queue',key='craft_queue:'..app.craftBatch.id,body=app.craftQueueBody()}end
    if app.nativeCraftHandoff then
        local requirement=app.craftRequirementTask(app.nativeCraftHandoff.plan and app.nativeCraftHandoff.plan.recipe)
        if requirement then app.clearNativeCraft();return requirement end
        return {kind='craft_native',key='craft_native:'..app.nativeCraftHandoff.id,body=app.caption('craft_native_confirm',app.nativeCraftHandoff.count)}
    end
    -- Take the planned vendor portion while this supplier is already open.
    -- Uncollected AH materials can be picked up on the same trip afterwards.
    if plan and plan.stockKnown and (plan.vendorRows or 0)>0 and app.vendorPurchase.open and not app.isPoison() then
        local vendorPlan=app.vendorPurchasePlan()
        local offer=vendorPlan and vendorPlan.rows[1]
        if offer then
            local pending=app.vendorPurchase.pending
            if pending then return {kind='vendor_wait',key='vendor_wait:'..pending.id,body=app.caption('vendor_buy_wait')} end
            for _,row in ipairs(plan.rows)do
                if row.vendor and row.id==offer.id and row.buy>0 then
                    return {kind='vendor',key='vendor_here:'..row.id..':'..offer.quantity,atVendor=true,id=row.id,
                        body=app.caption('step_vendor_here',offer.quantity,row.name)}
                end
            end
        end
    end
    local craft=app.craftBatchInfo(plan)
    if craft.available>0 then
        local requirement=app.craftRequirementTask(plan.recipe)
        if requirement then return requirement end
        return {kind='craft',key='craft:'..plan.recipe.id,available=craft.available,batch=craft.count,stop=craft.stop,body=plan.production and app.caption('production_quantity',craft.count)or app.caption('craft_use_stock',craft.available,craft.stop)}
    end
    if not plan or not plan.stockKnown then return {kind='unknown',key='unknown',body=app.caption('step_unknown')}end
    local ahRows=plan.ahRows
    if ahRows==nil then ahRows=0;for _,r in ipairs(plan.rows)do if r.buy>0 and not r.vendor then ahRows=ahRows+1 end end end
    if ahRows>0 then
        if app.shopping.open and app.shopping.listStale then return {kind='ah_list',key='ah_list',body=app.caption('shopping_list_changed')}end
        local due,items,keys=nil,{},{}
        for _,r in ipairs(plan.rows)do
            if r.buy>0 and not r.vendor then
                local mail=app.confirmedMail(r.id)
                if r.buy>mail then
                    if app.shopping.searched and app.shopping.open then
                        local offer=app.ahBuyStatus(plan)
                        return {kind=offer.phase,key='buy:'..offer.phase..':'..tostring(offer.id),offer=offer,body=offer.body}
                    end
                    return {kind='ah',key='ah',body=app.caption(app.shopping.open and 'step_ah_here'or 'step_ah_visit')..'\n'..app.caption('order_units',r.buy-mail)..' · '..r.name}
                elseif mail>0 then
                    local n=math.min(r.buy,mail)
                    items[#items+1]=n..' x '..r.name;keys[#keys+1]=r.id..':'..n
                end
            end
        end
        if #items>0 then
            local after={app.caption('step_mail_after')}
            for _,r in ipairs(plan.rows)do
                if r.vendor and r.buy>0 then after[#after+1]=app.caption('step_mail_vendor',r.buy,r.name)end
            end
            after[#after+1]=app.caption('step_mail_finish')
            due={kind='mail',key='mail:'..table.concat(keys,':'),mailCount=#items,afterCount=#after,
                body=app.caption('step_mail_list')..'\n'..table.concat(items,'\n'),after=table.concat(after,'\n')}
            return due
        end
    end
    for _,row in ipairs(plan.rows)do
        if row.buy>0 and row.vendor then
            local missing=math.max(0,row.buy-app.confirmedMail(row.id))
            if missing==0 then return {kind='mail',key='mail_vendor:'..row.id,body=app.caption('step_mail_list')..'\n'..row.buy..' x '..row.name} end
            local pending=app.vendorPurchase and app.vendorPurchase.pending
            if pending and pending.id==row.id then return {kind='vendor_wait',key='vendor_wait:'..row.id,body=app.caption('vendor_buy_wait')}end
            local v=app.nearestMerchant(row.id)
            local atVendor=false
            if app.vendorPurchase and app.vendorPurchase.open and app.vendorPurchasePlan then
                local vp=app.vendorPurchasePlan()
                for _,offer in ipairs(vp and vp.rows or {})do if offer.id==row.id then atVendor=true end end
            end
            return {kind='vendor',key='vendor:'..row.id..':'..row.buy..':'..(v and (v.map..':'..v.x..':'..v.y)or 'unknown'),vendor=v,atVendor=atVendor,id=row.id,
                body=app.caption(atVendor and 'step_vendor_here'or 'step_vendor',missing,row.name)}
        end
    end
    for _,row in ipairs(plan.rows)do
        local loc=row.locations
        if loc then
            local needed=math.max(0,row.total-(loc.bags or 0))
            local n=math.min(needed,(loc.bank or 0)+(loc.shared or 0))
            if n>0 then return {kind='bank',key='bank:'..row.id..':'..n,body=app.caption('step_bank',n,row.name)}end
            if needed>0 and (loc.deductibleAlts or 0)>0 then return {kind='alt',key='alt:'..row.id,body=app.caption('step_alt',row.name)}end
        end
    end
    return app.craftRequirementTask(plan.recipe)or {kind='craft',key='craft:'..plan.recipe.id,body=app.caption('step_craft_count',plan.estimated and app.caption('approx')or '',plan.crafts,app.recipeName(plan.recipe))}
end
function app.renderNextStep(plan,keepVisible,override)
    local shop=app.shoppingWindow
    if (not shop or not shop:IsShown())and not keepVisible then return end
    if not app.nextStepWindow then
        local f=app.createWindow('CraftDejaNextStep',360,250);app.nextStepWindow=f
        f:ClearAllPoints();f:SetPoint('TOPLEFT',shop or app.main or UIParent,'BOTTOMLEFT',0,-8)
        f.output=CreateFrame('Frame',nil,f);f.output:SetSize(42,42);f.output:SetPoint('TOPLEFT',18,-51)
        f.output.icon=f.output:CreateTexture(nil,'OVERLAY',nil,6);f.output.icon:SetAllPoints()
        f.output:EnableMouse(true);f.output:SetScript('OnEnter',function()if f.plan then app.showTip(f.output,app.recipeName(f.plan.recipe),{app.caption('step_planned_crafts',f.plan.crafts),app.caption('step_craft_help')})end end);f.output:SetScript('OnLeave',app.hideTip)
        f.outputName=app.createLabel(f,12,69,-52,273);f.outputName:SetHeight(28)
        f.outputCount=app.createLabel(f,10,69,-82,273);f.outputCount:SetHeight(15)
        f.route=app.createLabel(f,10,18,-102,324);f.route:SetHeight(32)
        f.body=app.createLabel(f,12,18,-102,324);f.body:SetHeight(43)
        f.place=app.createLabel(f,10,18,-147,324);f.place:SetHeight(28)
        f.notice=app.createLabel(f,10,18,-177,324);f.notice:SetHeight(29)
        f.logButton=app.createButton(f,286,-10,28,'?',function()app.showFlowLog()end);app.styleButton(f.logButton,'info',true);f.logButton.fixedRole=true;f.logButton.tipLines=function()return {app.caption('flow_log_tip')}end
        f.craftAll=app.createButton(f,186,-214,156,'',function()
            app.flowLog('click.craft_all',{recipe=f.plan and f.plan.recipe.id or 0,queue=app.craftBatch~=nil})
            if app.nativeCraftHandoff then app.clearNativeCraft();app.actionNotice=nil;app.refreshNextStep(true)
            elseif app.craftBatch then app.stopCraftBatch(true)else app.craftNext(f.plan,true)end
        end);f.craftAll:Hide()
        f.action=app.createButton(f,18,-214,324,'',function()
            local t=f.task;if not t then return end;app.actionNotice=nil
            if app.unifiedAction and app.unifiedAction(f)then return end
            app.flowLog('click.next',{task=t.kind,recipe=f.plan and f.plan.recipe.id or 0})
            if t.kind=='poison'then app.showPoisonPlanner()
            elseif t.kind=='vendor'then
                if t.atVendor then app.showVendorBuy()
                elseif t.vendor then f.marked=app.markMerchant(t.vendor);app.renderNextStep(f.plan,true)
                else app.showMerchants()end
            elseif t.kind=='ah'then if app.shoppingFresh()then app.searchShopping()else app.requestShopping()end
            elseif t.kind=='ah_list'then app.refreshShoppingList();app.refreshNextStep(true)
            elseif t.kind=='scan'then app.autoScanTick(true)
            elseif t.kind=='review'then app.showCatalogue()
            elseif t.kind=='recipe_owned'then app.refresh(app.professionOpen==true);app.refreshNextStep(true)
            elseif t.kind=='learn'then f.marked=app.showRecipeSource(t.recipe or app.decision.current.recipe)
            elseif t.kind=='station'then app.refresh(false);app.refreshNextStep(true);if f.task and f.task.kind=='station'then app.showCraftStation(f.task,true)end
            elseif t.kind=='rod_collect'then app.refresh(false);app.refreshNextStep(true)
            elseif t.kind=='tool'then if not app.professionOpen then app.openCraftProfession(t.recipe and t.recipe.id)else app.refresh(false);app.refreshNextStep(true)end
            elseif t.kind=='production_choose'then app.editUnifiedOrder()
            elseif t.kind=='craft_native'then app.focusNativeCraft()
            elseif t.kind=='craft'then app.craftNext(f.plan)
            elseif t.kind=='mail'then app.ahMailPoll();app.refresh(false);app.refreshNextStep(true)
            elseif t.kind=='rank'and t.trainer then f.marked=app.showRankTrainer(t.trainer);app.refreshNextStep(true)
            elseif t.kind=='open'then app.openCraftProfession()
            elseif t.kind=='ah_buy'or t.kind=='ah_confirm'or t.kind=='ah_load'or t.kind=='ah_wait'or t.kind=='ah_done'then app.performAHBuy(f.plan,t.offer)
            elseif f.plan then app.showDetails(f.plan.recipe,true)end
        end)
        f.onDismiss=function()app.guideRequested=false end
        f:HookScript('OnShow',function()if app.updateProfessionGuideButtons then app.updateProfessionGuideButtons()end end)
        f:HookScript('OnHide',function()
            app.guideRequested=false
            if app.updateProfessionGuideButtons then app.updateProfessionGuideButtons()end
        end)
    end
    if app.craftBatch then plan=app.craftBatch.plan elseif app.nativeCraftHandoff then plan=app.nativeCraftHandoff.plan end
    local f=app.nextStepWindow;local task=override or app.nextStep(plan)
    if not task.sourceTarget and app.clearGuideMarker then app.clearGuideMarker('recipeID')end
    if (task.kind~='station'or not task.station)and app.clearStationMarker then app.clearStationMarker()end
    if plan and app.syncShoppingList then app.syncShoppingList(plan);if not override and app.shopping.listStale then task=app.nextStep(plan)end end
    if app.shopping.open and not app.shoppingFresh()and app.active and not app.craftBatch and task.kind~='open'and task.kind~='loading'then
        task={kind='scan',key='scan',body=app.scanWaitText()};plan=nil
    end
    app.tracePlan(plan,task)
    if f.taskKey~=task.key then
        f.taskKey=task.key;f.marked=false;app.actionNotice=nil
        if task.vendor then f.marked=app.markMerchant(task.vendor)end
        if task.trainer and not task.levelBlocked then f.marked=app.markMerchant(task.trainer)end
        if task.sourceTarget then f.marked=app.markMerchant(task.sourceTarget)end
        if task.station then f.marked=app.showCraftStation(task,false)end
    end
    local important=app.isImportantTask(task)
    f.route:SetText(plan and app.routeSummary()or '')
    local routeHeight=plan and math.max(32,(app.try(f.route.GetStringHeight,f.route)or 30)+2)or 0
    f.route:SetHeight(routeHeight)
    local progressY=plan and 110+routeHeight or 58
    local progressH=app.renderOrderProgress(f,plan,task,progressY)
    local bodyY=progressY+progressH+(important and 16 or 0)
    local bodyH=math.max(important and 60 or 43,task.mailCount and (task.mailCount+2)*16 or 0)
    local placeH=math.max((task.trainer or task.sourceTarget)and 60 or 28,task.afterCount and task.afterCount*15 or 0)
    local placeY=bodyY+bodyH+6;local noticeY=placeY+placeH+4;local buttonY=noticeY+37
    f:SetHeight(buttonY+38)
    app.applyProfessionTheme(f,app.active and app.active.profile.id)
    f.action:ClearAllPoints();f.action:SetPoint('TOPLEFT',18,-buttonY)
    f.body:ClearAllPoints();f.body:SetPoint('TOPLEFT',18,-bodyY);f.body:SetHeight(bodyH)
    f.place:ClearAllPoints();f.place:SetPoint('TOPLEFT',18,-placeY)
    f.place:SetHeight(placeH)
    f.notice:ClearAllPoints();f.notice:SetPoint('TOPLEFT',18,-noticeY)
    if plan then f.route:Show()else f.route:Hide()end
    app.taskAttention(f,task,bodyY,bodyH)
    f.task=task;f.plan=plan or f.plan;
    if plan then
        f.output:Show();f.outputName:Show();f.outputCount:Show()
        local icon,_,minimum,maximum=app.craftDisplay(plan.recipe)
        f.output.icon:SetTexture(icon);f.outputName:SetText(app.recipeName(plan.recipe))
        local count=app.caption('step_planned_crafts',plan.crafts)
        if minimum and maximum then count=count..' ('..(minimum==maximum and tostring(plan.crafts*minimum)or (plan.crafts*minimum)..'-'..(plan.crafts*maximum))..' '..app.caption('step_units')..')'end
        if task.kind=='craft'then count=app.caption('craft_stock_count',task.available or 0,task.batch or 0)end
        f.outputCount:SetText(count)
    else f.output:Hide();f.outputName:Hide();f.outputCount:Hide()end
    f.title:SetText(app.caption('step_title'));f.body:SetText(task.body)
    f.place:SetText(task.kind=='craft_native'and app.caption('craft_native_hint')or task.kind=='craft'and app.caption('craft_stock_priority')or task.kind=='ah'and app.caption('ah_quantity_help')or task.vendor and app.caption('step_vendor_place',task.vendor.name,app.merchantLocation(task.vendor))or task.kind=='vendor'and app.caption('step_no_vendor')or app.caption('step_more'))
    f.notice:SetText(task.kind=='vendor'and app.caption(task.vendor and (f.marked and 'step_marked'or 'step_no_marker')or 'step_pack')or '')
    if task.kind=='mail'then f.place:SetText(task.after or app.caption('step_mail_wait'));f.notice:SetText(app.caption('step_mail_wait'))end
    if task.kind=='station'then f.place:SetText(app.caption('station_help'))end
    if task.kind=='learn'then
        if task.sourceTarget then
            f.place:SetText(task.sourceTarget.name..'\n'..app.merchantLocation(task.sourceTarget)..'\n'..app.caption('recipe_source_reference'))
            f.notice:SetText(app.caption(f.marked and 'recipe_source_marked'or 'recipe_source_coordinates'))
        else f.place:SetText(app.caption('recipe_source_missing'))end
    end
    if task.kind=='rank'then
        if task.trainer then
            local t=task.trainer
            f.place:SetText(t.name..'\n'..app.merchantLocation(t)..(t.level and t.level>0 and '\n'..app.caption('trainer_level',t.level,t.skill or 0)or '')..'\n'..app.caption('trainer_reference'))
            f.notice:SetText(app.caption(f.marked and 'trainer_marked'or 'trainer_no_marker'))
            if task.levelBlocked then f.notice:SetText(app.caption('trainer_level_wait'))end
        else f.place:SetText(app.caption('trainer_missing'))end
    end
    if plan and task.offer and task.offer.id then
        for _,r in ipairs(plan.rows)do if r.id==task.offer.id then
            f.place:SetText(app.caption('ah_stock_breakdown',r.total,r.owned or 0,app.confirmedMail(r.id),app.purchaseReserved(r.id),math.max(0,app.purchaseBudget(plan,r.id,math.max(0,r.buy-app.confirmedMail(r.id)))-app.purchaseReserved(r.id))))
        end end
    end
    if app.actionNotice then f.notice:SetText(app.actionNotice)end
    f.craftAll:Hide();f.action:SetWidth(324);f.action.label:SetWidth(285)
    local craftButtons=(task.kind=='craft_native'or task.kind=='craft_queue'or task.kind=='craft'and app.professionOpen and app.nativeProfessionVisible()~=false)and plan and (not app.requiresEnchantTarget(plan.recipe) or plan.toolPreparation)
    if craftButtons then
        f.action:SetWidth(156);f.action.label:SetWidth(117);f.craftAll:Show();f.craftAll:Enable()
        f.craftAll:ClearAllPoints();f.craftAll:SetPoint('TOPLEFT',186,-buttonY)
        f.craftAll:SetText(app.nativeCraftHandoff and app.caption('craft_native_back')or app.craftBatch and app.caption('craft_stop_button')or app.caption('craft_all_button',task.batch or 0));app.styleButton(f.craftAll,app.nativeCraftHandoff and 'prev'or app.craftBatch and 'close'or 'check',false)
        f.craftAll.fixedRole=true;f.craftAll.tipLines=function()return {app.caption('craft_all_tip')}end
    end
    f.action:Enable()
    local label=task.kind=='done'and 'skill_goal_done_button'or task.kind=='rank'and 'goal_rank_button'or task.kind=='craft_native'and 'craft_native_show'or task.kind=='craft_queue'and 'craft_queue_button'or task.kind=='review'and 'step_review_button'or task.kind=='loading'and 'profession_loading_button'or task.kind=='scan'and 'scan_locked_button'or task.kind=='open'and 'open'or task.kind=='learn'and 'learn_first'or task.kind=='vendor'and (task.atVendor and 'step_buy'or 'step_map')or task.kind=='ah'and 'compact_search'or task.kind=='craft'and (app.professionOpen and app.nativeProfessionVisible()~=false and (plan and app.requiresEnchantTarget(plan.recipe) and 'action_enchant_select'or 'action_craft_one')or 'open')or 'step_details'
    f.action:SetText(task.kind=='poison'and app.caption('poison_title')or task.kind=='rank'and task.trainer and app.caption(task.levelBlocked and 'trainer_later'or 'trainer_show')or task.kind=='mail'and app.caption('step_mail_check')or task.offer and task.offer.button or app.caption(label));if task.kind=='done'or task.kind=='scan'or task.kind=='rank'and not task.trainer or task.kind=='loading'or task.kind=='craft_queue'or task.offer and task.offer.disabled then f.action:Disable()end;app.styleButton(f.action,task.offer and 'coin'or task.kind=='rank'and 'merchant'or task.kind=='vendor'and 'merchant'or task.kind=='ah'and 'coin'or task.kind=='craft'and 'hammer'or 'bag',false)
    if task.kind=='learn'and task.sourceTarget then f.action:SetText(app.caption('recipe_source_map'));app.styleButton(f.action,'map',false)end
    if task.kind=='station'then f.action:SetText(app.caption('station_check'))end
    if task.kind=='production_choose'then f.action:SetText(app.caption('ui_change'))end
    if app.guideRequested then f:Show()else f:Hide()end
    app.updateNativeCue(task,plan)
end

-- The task window is independent from both the scan result and shopping UI.
-- Refreshing the task never changes the user's visibility preference.
function app.refreshNextStep(force)
    if not app.saved then return end
    local f=app.nextStepWindow
    if not force and not app.professionOpen and not app.shopping.open and not(f and f:IsShown())then return end
    local plan,task
    local d=app.decision
    local rod,rodTask,rodActive
    if not app.craftBatch then rod,rodTask,rodActive=app.rodPreparationPlan()end
    if app.professionLoading then
        task={kind='loading',key='loading',body=app.caption('profession_loading')}
    elseif app.active and not app.craftBatch and app.shopping.open and not app.shoppingFresh()then
        task={kind='scan',key='scan',body=app.scanWaitText()}
    elseif app.nativeCraftHandoff then
        plan=app.nativeCraftHandoff.plan
        task=app.craftRequirementTask(plan and plan.recipe)
        if task then app.clearNativeCraft()
        else task={kind='craft_native',key='craft_native:'..app.nativeCraftHandoff.id,body=app.caption('craft_native_confirm',app.nativeCraftHandoff.count)}end
    elseif app.craftBatch then
        plan=app.craftBatch.plan;task={kind='craft_queue',key='craft_queue:'..app.craftBatch.id,body=app.craftQueueBody()}
    elseif not app.active or app.active.invalidated then
        task={kind='open',key='open',body=app.caption('step_open_profession')}
    elseif rodActive then
        plan=rod;task=rodTask
        if plan then
            plan=app.completeShoppingPlan(plan)
            task=app.nextStep(plan)
        end
    elseif app.productionEnabled()then
        local reason
        plan,reason=app.productionPlan()
        local job=app.productionJob()
        local recipe=job and app.active.recipes[job.recipe]or app.selectedProductionRecipe()
        local tool=recipe and app.craftRequirementTask(recipe,true)
        if reason=='production_done'then task={kind='done',key='production_done',body=app.caption(reason)}
        elseif reason=='stock_wait'then task={kind='stock_wait',key='stock_wait',body=app.caption(reason)}
        elseif tool then task=tool;plan=nil
        elseif plan then
            plan=app.completeShoppingPlan(plan)
            task=app.nextStep(plan)
        elseif reason=='requirement_cooldown'then task={kind='cooldown',key='cooldown',body=app.caption(reason)}
        else task={kind='production_choose',key='production:'..tostring(reason),body=app.caption(reason or 'production_choose')}end
    elseif app.problem=='rank_full'and app.active.profile.cap<300 then task=app.rankTrainerTask()
    elseif app.shopping.goal=='manual'and not(app.isPoison and app.isPoison())and app.planningTarget()and app.planningTarget()<=app.active.profile.skill then
        local target=app.planningTarget()
        task={kind='done',key='skill_done:'..app.active.profile.id..':'..target,body=app.caption('skill_goal_done',target)}
    elseif app.problem=='rank_full'then task=app.rankTrainerTask()
    elseif not d and app.shopping.open and not app.shoppingFresh()then
        task={kind='scan',key='scan',body=app.caption(app.shopping.started and 'step_auto_scanning'or app.shopping.autoReason or 'step_auto_scan')}
    elseif not d then
        local selected=app.selectedProductionRecipe()
        task=selected and selected.learned and app.craftRequirementTask(selected,true)or {kind='review',key='no_decision',body=app.caption(app.problem or 'open')}
    elseif app.nextActionBoundary()and app.nextActionBoundary().kind=='learn'and app.nextActionBoundary().target<=app.active.profile.skill then
        local recipe=app.nextActionBoundary().recipe;task=app.recipeLearningTask(recipe)
    elseif d.current.needsLearning then task=app.recipeLearningTask(d.current.recipe)
    elseif app.craftRequirementTask(d.current.recipe,true)then task=app.craftRequirementTask(d.current.recipe,true)
    else
        local target=app.planningTarget()
        local reason
        if app.shoppingFresh()then plan,reason=app.shoppingPlan()
        else
            plan,reason=app.materialPlan(d.current.recipe,target)
            if plan then
                plan=app.completeShoppingPlan(plan)
            end
        end
        if plan and app.craftAvailability(plan)==0 and not app.craftBatch and app.shopping.open and not app.shoppingFresh()then task={kind='scan',key='scan',body=app.caption(app.shopping.started and 'step_auto_scanning'or app.shopping.autoReason or 'step_auto_scan')}end
        if not plan then task={kind='review',key='plan:'..tostring(reason),body=app.caption(reason or 'open')}end
    end
    app.renderNextStep(plan,true,task)
end
