-- SPDX-License-Identifier: MIT
local _,app=...
app.supported[40]=true;app.professionOrder[#app.professionOrder+1]=40
app.catalog[40]=app.catalog[40]or {}
app.professionLabels.en[40]='Poisons';app.professionLabels.de[40]='Gifte'
local words={en={poison_title='Poisons - production plan',poison_choose='Choose quantities in the poison planner.',poison_open='Open your Poisons profession first.',poison_apply='Apply quantities',poison_cancel='Cancel plan',poison_craft='Prepare all selected',poison_shop='Find ingredients',poison_vendor='Buy vendor ingredients',poison_done='All selected poison crafts are complete.',poison_route='%d poison types | %d crafts remaining',poison_help='Choose output units per learned recipe (0-200). Shared ingredients are combined. Confirm AH purchases and each native craft batch yourself.',poison_output='Output per craft unavailable or variable. This recipe cannot be planned safely.',poison_changed='Recipe ingredients or output changed. Review and rebuild the plan.',poison_locked='Finish the current purchase/craft or cancel the plan before changing quantities.',poison_confirm='Next batch is prepared. Click the highlighted native Create button.',poison_buy_running='Buying the selected vendor ingredients. Keep this vendor open.',poison_buy_stopped='Vendor purchasing stopped. Check the remaining quantities and prices.'},de={poison_title='Gifte - Herstellungsplan',poison_choose='Wähle die Mengen im Gifte-Planer.',poison_open='Öffne zuerst deinen Beruf Gifte.',poison_apply='Mengen übernehmen',poison_cancel='Plan abbrechen',poison_craft='Alle gewählten vorbereiten',poison_shop='Zutaten suchen',poison_vendor='Händlerzutaten kaufen',poison_done='Alle gewählten Gifte wurden hergestellt.',poison_route='%d Giftrezepte | %d Herstellungen übrig',poison_help='Stückzahl pro gelerntem Rezept wählen (0-200). Gleiche Zutaten werden zusammengezählt. AH-Käufe und jeden originalen Craft-Stapel selbst bestätigen.',poison_output='Ausgabemenge fehlt oder schwankt. Dieses Rezept ist nicht sicher planbar.',poison_changed='Rezeptzutaten oder Ausgabemenge geändert. Plan prüfen und neu erstellen.',poison_locked='Kauf/Craft abschließen oder Plan abbrechen, bevor Mengen geändert werden.',poison_confirm='Nächster Stapel vorbereitet. Klicke auf den markierten originalen Herstellknopf.',poison_buy_running='Gewählte Händlerzutaten werden gekauft. Händler geöffnet lassen.',poison_buy_stopped='Händlerkauf angehalten. Restmengen und Preise prüfen.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.poison_draft='%d poison recipes | %d output units selected';app.words.de.poison_draft='%d Giftrezepte | %d Stück gewählt'
app.words.en.poison_ready='Materials ready. Prepare a batch, then click the highlighted native Create button.'
app.words.de.poison_ready='Materialien bereit. Stapel vorbereiten und danach den markierten originalen Herstellknopf drücken.'
app.words.en.poison_ingredients='Ingredients for all selected poisons';app.words.de.poison_ingredients='Zutaten für alle gewählten Gifte'
app.words.en.poison_material_line='%d needed | %s owned | %d to buy';app.words.de.poison_material_line='%d benötigt | %s vorhanden | %d nachkaufen'
app.words.en.poison_material_source='%s | Mail: %d | Pending: %d';app.words.de.poison_material_source='%s | Post: %d | Im Kauf: %d'
app.words.en.poison_multiple='Choose a quantity divisible by this recipe output per craft.';app.words.de.poison_multiple='Wähle ein Vielfaches der Ausgabemenge pro Herstellung.'
local stockWords={en={poison_mode_stock='Mode: refill bag stock',poison_mode_extra='Mode: craft extra units',poison_stock_scope='Target: this character’s bags',poison_stock_apply='Plan refill',poison_stock_summary='%d stock targets | %d units missing',poison_stock_line='Bags %d | Target %d | Missing %d | Produce %d',poison_extra_line='Additional production: %d units',poison_stock_elsewhere='Bank %s | Alts %d (not deducted)',poison_stock_unknown='Output item or current bag stock unavailable. Refill is paused.',poison_stock_duplicate='Two selected recipes make the same item. Choose one recipe for this stock target.',poison_stock_help='Choose your desired bag stock. Only missing units are planned; full recipe batches may produce extra units. Bank/alt finished stock is shown separately. Click Plan refill to start.'},de={poison_mode_stock='Modus: Zielbestand auffüllen',poison_mode_extra='Modus: Zusätzlich herstellen',poison_stock_scope='Ziel: Taschen dieses Charakters',poison_stock_apply='Auffüllen planen',poison_stock_summary='%d Vorratsziele | %d Stück fehlen',poison_stock_line='Taschen %d | Ziel %d | Fehlen %d | Herstellen %d',poison_extra_line='Zusätzlich herstellen: %d Stück',poison_stock_elsewhere='Bank %s | Alts %d (nicht abgezogen)',poison_stock_unknown='Ausgabe-Item oder aktueller Taschenbestand fehlt. Auffüllen pausiert.',poison_stock_duplicate='Zwei gewählte Rezepte erzeugen dasselbe Item. Wähle dafür ein Rezept.',poison_stock_help='Gewünschten Taschenvorrat wählen. Nur Fehlmengen werden geplant; volle Rezeptmengen können Mehrstücke ergeben. Fertige Gifte auf Bank/Alts werden separat angezeigt. Mit Auffüllen planen starten.'}}
for lang,entries in pairs(stockWords)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.poison_stock_done='Refill order complete. Check your stock before planning another refill.';app.words.de.poison_stock_done='Auffüllauftrag abgeschlossen. Bestand vor dem nächsten Auffüllen prüfen.'
app.words.en.poison_open_planner='Open planner';app.words.de.poison_open_planner='Planer öffnen'
app.words.en.poison_plan_hint='Choose stock targets or additional quantities in the poison planner.';app.words.de.poison_plan_hint='Zielbestand oder zusätzliche Mengen im Gifte-Planer wählen.'
app.words.en.poison_empty='No learned poison recipe is available yet. Open your native Poisons window and check the recipe list.';app.words.de.poison_empty='Noch kein gelerntes Giftrezept verfügbar. Öffne das originale Giftefenster und prüfe die Rezeptliste.'
app.words.en.poison_completed_short='Order complete';app.words.de.poison_completed_short='Auftrag abgeschlossen'
app.words.en.poison_shared_hint='Individual quantities • Shared ingredient list';app.words.de.poison_shared_hint='Einzelne Mengen • Gemeinsame Zutatenliste'
app.words.en.poison_follow_step='Follow Next step for ingredients and native crafting.';app.words.de.poison_follow_step='Folge Nächster Schritt für Zutaten und die originale Herstellung.'
app.words.en.poison_merchant_title='Poison vendor';app.words.de.poison_merchant_title='Giftverkäufer'
app.words.en.poison_merchant_read='Poison supplies detected. Open your Poisons profession once to read the learned recipes. Then choose your quantities and return to the vendor.';app.words.de.poison_merchant_read='Giftzutaten erkannt. Öffne Gifte einmal, damit CraftDeja deine gelernten Rezepte einliest. Wähle danach die Mengen und sprich den Händler erneut an.'
app.words.en.poison_merchant_open='Open Poisons';app.words.de.poison_merchant_open='Gifte öffnen'
function app.isPoison()return app.active and app.active.profile.id==40 end
function app.poisonUnlocked()
    local _,class=app.try(UnitClass,'player')
    if class~='ROGUE'then return false end
    -- The learned profession ability is the result of unlocking Poisons. Do
    -- not infer completion from level, vendor stock, cached jobs or quest IDs.
    if app.try(IsPlayerSpell,2842)==true or app.try(IsSpellKnown,2842)==true then return true end
    for _,index in pairs({app.try(GetProfessions)})do
        local _,_,rank,_,_,_,id=app.try(GetProfessionInfo,index)
        if id==40 and type(rank)=='number'and rank>0 then return true end
    end
    -- A live native profession also proves access when the legacy ability
    -- APIs are absent. A saved CraftDeja session alone is not such evidence.
    if app.nativeProfessionVisible()==true then
        local profile=app.readProfession()
        if profile and profile.id==40 and profile.skill>0 then return true end
    end
    return false
end
local function state()
    app.character.poisons=app.character.poisons or {targets={},serial=0,restock=true}
    app.character.poisons.stockTargets=app.character.poisons.stockTargets or {}
    return app.character.poisons
end
local function targets()local s=state();return s.restock and s.stockTargets or s.targets end
local function notice(key)
    app.actionNotice=app.caption(key);app.flowLog('poison.notice',{reason=key});return false
end
local function nativePurchaseBusy()
    local b=Auctionator and Auctionator.State and Auctionator.State.BuyCommodityFrameRef
    if not b then return false end
    if b.waitingForPurchase then return true end
    for _,k in ipairs({'QuantityCheckConfirmationDialog','FinalConfirmationDialog','WidePriceRangeWarningDialog'})do
        if b[k]and app.try(b[k].IsShown,b[k])then return true end
    end
    return false
end
local function yieldFor(r)
    local _,_,lo,hi=app.craftDisplay(r)
    if lo and lo>0 and lo==math.floor(lo)and lo==hi then return lo end
end
local function learned()
    local rows={}
    if app.isPoison()then for _,r in pairs(app.active.recipes)do if r.learned and r.confirmed then rows[#rows+1]=r end end end
    table.sort(rows,function(a,b)return a.id<b.id end);return rows
end
local function inputs(r)
    if not r.complete or not r.materialsFromClient then return nil end
    local rows={}
    for _,g in ipairs(r.groups or {})do
        -- Never guess which alternative reagent the native form will consume.
        if #g.choices~=1 or not g.amount or g.amount<1 then return nil end
        rows[g.choices[1]]=(rows[g.choices[1]]or 0)+g.amount
    end
    return next(rows)and rows or nil
end
function app.poisonStock(r)
    local _,id=app.craftDisplay(r);local produced=yieldFor(r)
    if type(id)~='number'or id<=0 or not produced then return nil end
    app.inventoryState.tracked[id]=true
    local bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)
    if type(bags)~='number'or bags<0 or bags~=math.floor(bags)then return nil end
    local goal=state().stockTargets[r.id]or 0
    local missing=math.max(0,goal-bags)
    return {id=id,bags=bags,goal=goal,missing=missing,crafts=math.ceil(missing/produced),yield=produced,locations=app.inventoryFor(id)}
end
function app.setPoisonRestock(enabled)
    if state().job or app.craftBatch or app.nativeCraftHandoff or app.purchasePending()or nativePurchaseBusy()then return notice('poison_locked')end
    state().restock=enabled==true;app.poisonDone=false;app.actionNotice=nil
    app.renderPoisonPlanner();app.refresh(false);return true
end
function app.reconcilePoisonStock()
    local j=state().job
    if not j or not j.restock or app.craftBatch or app.nativeCraftHandoff or app.purchasePending()or app.poisonVendorQueue then return end
    if (app.try(GetTime)or 0)<(app.poisonStockSettleUntil or 0)then return end
    local any=false
    for id,n in pairs(j.remaining)do if n>0 then
        local r=app.active and app.active.recipes[id];local stock=r and app.poisonStock(r)
        -- Never enlarge a confirmed order when a poison is consumed or moved.
        -- A new refill always requires a new explicit click.
        if stock and stock.id==j.outputs[id]then
            j.remaining[id]=math.min(n,math.ceil(math.max(0,j.goals[id]-stock.bags)/j.yield[id]))
        end
        any=any or j.remaining[id]>0
    end end
    if not any then state().job=nil;app.poisonDone=true;app.poisonAutoPrepare=false end
end
function app.setPoisonTarget(id,value)
    local s=state()
    if s.job or app.craftBatch or app.nativeCraftHandoff or app.purchasePending()or nativePurchaseBusy()then return notice('poison_locked')end
    local r=app.isPoison()and app.active.recipes[id]
    if not r or not r.learned then return false end
    local n=tonumber(value);if not n or n~=n then return false end
    targets()[id]=math.max(0,math.min(200,math.floor(n)))
    app.poisonDone=false;app.actionNotice=nil
    if app.poisonWindow then app.poisonWindow.status:SetText(app.routeSummary())end
    return true
end
function app.startPoisonOrder()
    if not app.isPoison()then return notice('poison_open')end
    local s=state()
    if s.job or app.purchasePending()or nativePurchaseBusy()or app.craftBatch or app.nativeCraftHandoff then return notice('poison_locked')end
    local job={remaining={},initial={},yield={},fingerprints={},requested={},restock=s.restock,outputs={},goals={}}
    local outputs,selected={},false
    for id,n in pairs(targets())do if n>0 then
        selected=true
        local r=app.active.recipes[id];local produced=r and yieldFor(r)
        if not r or not r.learned or r.disabled or not inputs(r)or not produced then return notice('poison_output')end
        local count
        if s.restock then
            local stock=app.poisonStock(r);if not stock then return notice('poison_stock_unknown')end
            if outputs[stock.id]then return notice('poison_stock_duplicate')end;outputs[stock.id]=true
            count=stock.crafts;job.outputs[id]=stock.id;job.goals[id]=n
            app.flowLog('poison.stock',{recipe=id,item=stock.id,bags=stock.bags,goal=n,missing=stock.missing,crafts=count})
        else
            if n%produced~=0 then return notice('poison_multiple')end
            count=math.ceil(n/produced)
        end
        if count>0 then
            job.remaining[id]=count;job.initial[id]=count
            job.yield[id]=produced;job.requested[id]=n;job.fingerprints[id]=app.auditMaterials(r.groups)
        end
    end end
    if not next(job.remaining)then
        if s.restock and selected then app.poisonDone=true;app.actionNotice=nil;app.refresh(false);return true end
        return notice('poison_choose')
    end
    s.serial=s.serial+1;job.serial=s.serial;s.job=job
    app.poisonDone=false;app.poisonAutoPrepare=false;app.actionNotice=nil;app.newPurchasePlan()
    app.flowLog('poison.plan',{serial=s.serial,mode=s.restock and 'stock' or 'extra'});app.refresh(false);return true
end
function app.cancelPoisonOrder()
    if app.purchasePending()or nativePurchaseBusy()or app.craftBatch then return notice('poison_locked')end
    app.clearNativeCraft()
    state().job=nil;app.poisonVendorQueue=nil;app.poisonAutoPrepare=false;app.poisonDone=false
    app.newPurchasePlan();app.refresh(false);return true
end
local function remaining()
    local j=state().job;local rows={}
    if j then for id,n in pairs(j.remaining)do if n>0 then rows[#rows+1]=id end end end
    table.sort(rows);return rows,j
end
local function makeRows(totals)
    local rows,known,priced,purchase={},true,true,0
    for id,total in pairs(totals)do
        local unit=app.unitPrice(id);local loc=app.inventoryFor(id)
        local owned=loc and loc.total;local buy=math.max(0,total-(owned or 0))
        known=known and type(owned)=='number';priced=priced and type(unit)=='number'and unit>0
        rows[#rows+1]={id=id,name=app.itemName(id),total=total,unit=unit or 0,locations=loc,owned=owned,buy=buy,
            vendorUnit=app.vendorPrice(id),vendor=app.vendorPrice(id)and (not unit or app.vendorPrice(id)<=unit)or false}
        purchase=purchase+buy*(unit or 0)
    end
    table.sort(rows,function(a,b)return a.id<b.id end)
    return rows,known,priced,purchase
end
function app.poisonRecipePlan(r,count)
    if not app.isPoison()or app.active.invalidated then return nil,'session_stale'end
    local ids,j=remaining();if not j or not j.remaining[r.id]then return nil,'poison_choose'end
    local reagent=inputs(r)
    if not reagent or yieldFor(r)~=j.yield[r.id]or app.auditMaterials(r.groups)~=j.fingerprints[r.id]then return nil,'poison_changed'end
    if j.restock then local stock=app.poisonStock(r);if not stock or stock.id~=j.outputs[r.id]then return nil,'poison_stock_unknown'end end
    local n=math.min(count or j.remaining[r.id],j.remaining[r.id]);local totals={}
    if n<1 then return nil,'poison_done'end
    for id,amount in pairs(reagent)do totals[id]=amount*n end
    local rows,known,priced,cost=makeRows(totals)
    return {poison=true,recipe=r,rows=rows,crafts=n,from=0,target=n,stockKnown=known,priceKnown=priced,purchase=cost,estimated=false,jobSerial=j.serial}
end
function app.poisonPlan()
    if not app.isPoison()or app.active.invalidated then return nil,'session_stale'end
    app.reconcilePoisonStock()
    local ids,j=remaining();if not j or #ids==0 then return nil,'poison_choose'end
    local totals,total={},0
    for _,id in ipairs(ids)do
        local r=app.active.recipes[id]
        if not r or not r.learned then return nil,'poison_changed'end
        local p,why=app.poisonRecipePlan(r)
        if not p then return nil,why end
        total=total+p.crafts
        for _,row in ipairs(p.rows)do totals[row.id]=(totals[row.id]or 0)+row.total end
    end
    local rows,known,priced,cost=makeRows(totals)
    return {poison=true,poisonAggregate=true,recipe=app.active.recipes[ids[1]],rows=rows,crafts=total,from=0,target=total,
        stockKnown=known,priceKnown=priced,purchase=cost,estimated=false,jobSerial=j.serial}
end
function app.poisonDecision()
    app.reconcilePoisonStock()
    local ids=remaining();if #ids==0 then return nil,'poison_choose'end
    local chosen=ids[1]
    -- Keep an in-flight native recipe stable; otherwise use available bag stock.
    local active=app.craftBatch or app.nativeCraftHandoff
    if active then chosen=active.id else
        for _,id in ipairs(ids)do local p=app.poisonRecipePlan(app.active.recipes[id])
            if p and app.craftAvailability(p)>0 then chosen=id;break end
        end
    end
    local r=app.active.recipes[chosen];if not r then return nil,'poison_changed'end
    return {profile=app.active.profile,current={recipe=r,quote=app.quote(r,{}),colour=r.colour or 'grey',chance=1,unitSkill=0},stop=math.huge}
end
-- Grey consumables are valid production targets. Normal skill routes retain all
-- existing grey/green/rank guards.
local oldAvailability=app.craftAvailability
app.craftAvailability=function(plan)
    if not plan or not plan.poison then return oldAvailability(plan)end
    if plan.poisonAggregate or not plan.stockKnown or plan.recipe.disabled or plan.recipe.cooldown then return 0 end
    local n=math.huge
    for _,row in ipairs(plan.rows)do
        local bags=row.locations and row.locations.bags
        if type(bags)~='number'then bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,row.id,false,false,false,false)end
        if type(bags)~='number'then return 0 end
        n=math.min(n,math.floor(bags/(row.total/plan.crafts)))
    end
    return n==math.huge and 0 or math.max(0,n)
end
local oldBatchInfo=app.craftBatchInfo
app.craftBatchInfo=function(plan)
    if not plan or not plan.poison then return oldBatchInfo(plan)end
    local n=app.craftAvailability(plan);return {available=n,count=math.min(n,plan.crafts),stop=math.huge}
end
local oldMaterialPlan=app.materialPlan
app.materialPlan=function(r,target)
    if r and r.profession==40 and app.isPoison()then return app.poisonRecipePlan(r)end
    return oldMaterialPlan(r,target)
end
local oldBatchPlan=app.craftBatchPlan
app.craftBatchPlan=function(r,n,stop)
    if r and r.profession==40 and app.isPoison()then return app.poisonRecipePlan(r,n)end
    return oldBatchPlan(r,n,stop)
end
local oldQuote=app.quote
app.quote=function(r,memo,sellPrices)
    if r.profession~=40 then return oldQuote(r,memo,sellPrices)end
    local reagent=inputs(r);if not reagent then return nil end
    local quote={inputs={},cost=0,provider='Poisons'}
    for id,n in pairs(reagent)do local unit=app.unitPrice(id,memo)or 0
        quote.inputs[#quote.inputs+1]={item=id,amount=n,unit=unit};quote.cost=quote.cost+n*unit
    end
    return quote
end
local oldKey=app.purchaseKey
app.purchaseKey=function(plan)
    if plan.poisonAggregate then return 'poisons:'..tostring(plan.jobSerial)end
    return oldKey(plan)
end
local oldShopping=app.shoppingPlan
app.shoppingPlan=function(points)
    if not app.isPoison()then return oldShopping(points)end
    if not app.shoppingFresh()then return nil,'shop_wait_scan'end
    local p,why=app.poisonPlan();if not p then return nil,why end
    if not p.priceKnown then return nil,'no_prices'end
    p.scanSerial=app.shopping.scanSerial;p.goalMode='poisons'
    return app.completeShoppingPlan(p)
end
local oldSummary=app.routeSummary
app.routeSummary=function()
    if not app.isPoison()then return oldSummary()end
    local ids,j=remaining();local n=0;for _,id in ipairs(ids)do n=n+j.remaining[id]end
    if not j then
        local count,total=0,0;for id,qty in pairs(targets())do if qty>0 then
            count=count+1
            if state().restock then
                local r=app.active.recipes[id];local stock=r and app.poisonStock(r)
                if not stock then return app.caption('poison_stock_unknown')end
                total=total+stock.missing
            else total=total+qty end
        end end
        if state().restock then return app.caption('poison_stock_summary',count,total)end
        return app.caption('poison_draft',count,total)
    end
    return app.caption('poison_route',#ids,n)
end
local oldNext=app.refreshNextStep
app.refreshNextStep=function(force)
    if not app.isPoison()then return oldNext(force)end
    if app.craftBatch or app.nativeCraftHandoff then
        local h=app.craftBatch or app.nativeCraftHandoff
        local task={kind=app.craftBatch and 'craft_queue'or 'craft_native',key='poison_native:'..h.id,
            body=app.craftBatch and app.craftQueueBody()or app.caption('craft_native_confirm',h.count)}
        return app.renderNextStep(h.plan,true,task)
    end
    local aggregate,why=app.poisonPlan()
    if not aggregate then return app.renderNextStep(nil,true,{kind='poison',key='poison_config',body=app.caption(app.poisonDone and (state().restock and 'poison_stock_done'or 'poison_done')or why or 'poison_choose')})end
    local current=app.decision and app.decision.current.recipe
    local plan=current and app.poisonRecipePlan(current)
    local batch=plan and app.craftBatchInfo(plan)
    if batch and batch.count>0 then
        return app.renderNextStep(plan,true,{kind='craft',key='poison_craft:'..current.id,available=batch.available,batch=batch.count,stop=math.huge,
            body=app.caption('poison_ready')})
    end
    if app.shoppingFresh()then aggregate=app.completeShoppingPlan(aggregate)end
    app.renderNextStep(aggregate,true,app.nextStep(aggregate))
end
function app.poisonEvent(event,unit,guid,id)
    if event~='UNIT_SPELLCAST_SUCCEEDED'or unit~='player'then return end
    local s=state();local j=s.job
    if not j or not j.remaining[id]or j.remaining[id]<=0 then return end
    if guid and guid==app.poisonLastGUID then return end
    app.poisonLastGUID=guid;j.remaining[id]=j.remaining[id]-1
    app.poisonStockSettleUntil=(app.try(GetTime)or 0)+1.5
    app.flowLog('poison.completed',{recipe=id,remaining=j.remaining[id]})
    if #remaining()==0 then s.job=nil;app.poisonDone=true;app.poisonAutoPrepare=false end
end
function app.preparePoisonQueue()
    if not app.isPoison()or not state().job then return notice('poison_choose')end
    app.poisonAutoPrepare=true
    local r=app.decision and app.decision.current.recipe
    local p=r and app.poisonRecipePlan(r)
    local ok=p and app.craftNext(p,true)or false;app.poisonAutoPrepare=ok;return ok
end
local oldCraftNext=app.craftNext
app.craftNext=function(plan,all)
    local poison=app.isPoison()and plan and plan.poison
    local ok=oldCraftNext(plan,all)
    if poison then app.poisonAutoPrepare=all==true and ok==true end
    return ok
end
function app.poisonTick()
    if not app.isPoison()or not app.professionOpen or not app.poisonAutoPrepare or not state().job or app.craftBatch or app.nativeCraftHandoff then return end
    if app.try(UnitCastingInfo,'player')or app.try(UnitChannelInfo,'player')then return end
    app.poisonAutoPrepare=false -- only retry after the next confirmed batch
    app.refresh(false)
    local r=app.decision and app.decision.current.recipe;local p=r and app.poisonRecipePlan(r)
    if p and app.craftAvailability(p)>0 then
        local ok=app.craftNext(p,true);app.poisonAutoPrepare=ok or false
    end
end
function app.poisonVendorQuote()
    if not app.isPoison()or not state().job or not app.vendorPurchase.open then return nil end
    app.observeMerchant()
    local plan=app.vendorPurchasePlan();if not plan or #plan.rows==0 then return false end
    local q={serial=state().job.serial,epoch=app.poisonMerchantEpoch,limits={},cost=0,spent=0};local signature={}
    for _,row in ipairs(plan.rows)do
        local n=math.ceil(row.missing/row.bundle)*row.bundle
        q.limits[row.id]={units=n,unit=row.unit};q.cost=q.cost+n*row.unit
        signature[#signature+1]=row.id..':'..n..':'..row.unit
    end
    table.sort(signature);q.signature=table.concat(signature,',');return q
end
function app.startPoisonVendorQueue()
    local v=app.vendorPurchase
    if not app.isPoison()or not state().job or not v.open or v.pending or app.poisonVendorQueue then return false end
    local shown=app.poisonVendorOffer
    app.observeMerchant();app.offerVendorPurchase()
    local q=app.poisonVendorQuote();if not q then return false end
    if not shown or shown.serial~=q.serial or shown.epoch~=q.epoch or shown.signature~=q.signature then return notice('vendor_buy_changed')end
    if (app.try(GetMoney)or 0)<q.cost then return notice('vendor_buy_gold')end
    app.poisonVendorQueue=q;app.actionNotice=nil
    app.flowLog('poison.vendor_start',{serial=q.serial,cost=q.cost});app.tickPoisonVendorQueue();return true
end
function app.tickPoisonVendorQueue()
    local q=app.poisonVendorQueue;if not q then return end
    local v=app.vendorPurchase;local j=state().job
    local function stop()app.poisonVendorQueue=nil;notice('poison_buy_stopped')end
    if not app.isPoison()or not j or j.serial~=q.serial or not v.open or q.epoch~=app.poisonMerchantEpoch then stop();return end
    if q.sent then
        local n=app.try(C_Item and C_Item.GetItemCount or GetItemCount,q.sent.id,false,false,false,false)
        if type(n)=='number'and n>=q.sent.before+q.sent.quantity then q.sent=nil
        elseif (app.try(GetTime)or 0)-q.sent.at>6 then stop();return
        else return end
    end
    if v.pending then return end
    app.offerVendorPurchase();local plan=app.vendorPurchasePlan()
    for _,row in ipairs(plan and plan.rows or {})do
        local limit=q.limits[row.id]
        if limit then
            if row.quantity>limit.units or row.unit>limit.unit+.000001 or q.spent+row.cost>q.cost+.000001 then stop();return end
            local before=app.try(C_Item and C_Item.GetItemCount or GetItemCount,row.id,false,false,false,false)
            if type(before)~='number'then stop();return end
            if not app.buyVendorMaterial(row.id)then stop();return end
            limit.units=limit.units-row.quantity;q.spent=q.spent+row.cost
            q.sent={id=row.id,before=before,quantity=row.quantity,at=app.try(GetTime)or 0};return
        end
    end
    app.poisonVendorQueue=nil;app.actionNotice=nil
    app.flowLog('poison.vendor_complete',{serial=q.serial,cost=q.spent})
end
local oldVendorTick=app.vendorBuyTick
app.vendorBuyTick=function()
    oldVendorTick();app.tickPoisonVendorQueue()
    if app.vendorPurchase.open and (app.poisonMerchantRetries or 0)>0 then
        app.poisonMerchantRetries=app.poisonMerchantRetries-1;app.autoOpenPoisonMerchant()
    end
end
local poisonSupplies={[2928]=true,[2930]=true,[5173]=true,[8923]=true,[8924]=true}
function app.isPoisonMerchant()
    -- Merchant events/item APIs are shared by the native and TSM merchant UI.
    -- Vials alone are not sufficient: ordinary reagent vendors sell them too.
    for slot=1,(app.try(GetMerchantNumItems)or 0)do
        local link=app.try(GetMerchantItemLink,slot)
        local id=type(link)=='string'and tonumber(link:match('item:(%d+)'))
        if poisonSupplies[id]then return true end
    end
    return false
end
function app.showPoisonMerchantPrompt()
    if not app.poisonMerchantWindow then
        local f=app.createWindow('CraftDejaPoisonMerchant',420,228);app.poisonMerchantWindow=f;f.professionTheme=40
        f.body=app.createLabel(f,12,24,-62,372);f.body:SetHeight(100)
        f.open=app.createButton(f,24,-178,372,'',function()
            -- Only this user click may open the native profession; visiting a
            -- vendor never casts a spell or closes its shop automatically.
            if app.openCraftProfession(nil,40)then f:Hide()end
        end)
        app.styleButton(f.open,'bag',false);f.open.fixedRole=true
    end
    local f=app.poisonMerchantWindow;f.title:SetText('CraftDeja - '..app.caption('poison_merchant_title'))
    f.body:SetText(app.caption('poison_merchant_read'));f.open:SetText(app.caption('poison_merchant_open'))
    app.applyProfessionTheme(f,40);f:Show()
end
function app.autoOpenPoisonMerchant()
    if not app.poisonMerchantEligible()then return false end
    if not app.vendorPurchase.open or app.poisonMerchantShownEpoch==app.poisonMerchantEpoch or not app.isPoisonMerchant()then return false end
    app.poisonMerchantShownEpoch=app.poisonMerchantEpoch;app.poisonMerchantRetries=0
    local cached=app.sessions[40]
    if not app.isPoison()and cached and not cached.invalidated and (cached.confirmed or 0)>0 and not app.professionOpen and app.nativeProfessionVisible()~=true and not app.craftBatch and not app.nativeCraftHandoff then
        app.active=cached;app.professionLoading=false;app.expectedProfession=nil
    end
    local ready=app.isPoison()and not app.active.invalidated and (app.active.confirmed or 0)>0
    app.flowLog('poison.vendor_open',{recipesReady=ready==true,hasOrder=state().job~=nil})
    if not ready then app.showPoisonMerchantPrompt();return true end
    if app.poisonMerchantWindow then app.poisonMerchantWindow:Hide()end
    if app.unifiedUI then
        app.observeMerchant();app.refresh(false);app.offerVendorPurchase();app.refreshNextStep(true);return true
    end
    app.options.visible=true;app.showGuide(false);app.main:Show()
    app.observeMerchant();app.refresh(false);app.showPoisonPlanner();app.offerVendorPurchase();app.refreshNextStep(true)
    return true
end
function app.poisonMerchantEligible()
    if not app.poisonUnlocked()then return false end
    -- A mixed reagent merchant is not an instruction to change the user's job.
    if app.active and app.active.profile.id~=40 then return false end
    local order=app.currentRouteOrder and app.currentRouteOrder()
    if order and order.active and order.profession~=40 then return false end
    if app.isPoison()or app.character and app.character.poisons and app.character.poisons.job then return true end
    return true
end
local oldVendorEvent=app.vendorBuyEvent
app.vendorBuyEvent=function(event)
    if event=='MERCHANT_SHOW'or event=='MERCHANT_CLOSED'then
        app.poisonMerchantEpoch=(app.poisonMerchantEpoch or 0)+1
        app.poisonMerchantRetries=event=='MERCHANT_SHOW'and 10 or 0
    end
    oldVendorEvent(event)
    if event=='MERCHANT_SHOW'or event=='MERCHANT_UPDATE'then app.autoOpenPoisonMerchant()end
    if event=='MERCHANT_CLOSED'and app.poisonMerchantWindow then app.poisonMerchantWindow:Hide()end
    if event=='MERCHANT_CLOSED'and app.poisonVendorQueue then app.poisonVendorQueue=nil;notice('poison_buy_stopped')end
end
function app.renderPoisonPlanner()
    local f=app.poisonWindow;if not f or not f:IsShown()or not app.isPoison()then return end
    local s=state();f.title:SetText('CraftDeja - '..app.caption('poison_title'));f.hint:SetText(app.caption(s.restock and 'poison_stock_help'or 'poison_help'))
    f.mode:SetText(app.caption(s.restock and 'poison_mode_stock'or 'poison_mode_extra'))
    f.scope:SetText(s.restock and app.caption('poison_stock_scope')or '0-200')
    if s.job or app.craftBatch or app.nativeCraftHandoff or app.purchasePending()or nativePurchaseBusy()then f.mode:Disable()else f.mode:Enable()end
    local recipes=learned();f.syncing=true
    for i,r in ipairs(recipes)do
        local row=f.rows[i]
        if not row then
            row=CreateFrame('Frame',nil,f.content,'BackdropTemplate');row:SetSize(508,100);row:SetPoint('TOPLEFT',0,-(i-1)*104)
            row:SetBackdrop({bgFile=app.uiPath('Card')});row:SetBackdropColor(1,1,1,.85)
            row.icon=row:CreateTexture(nil,'ARTWORK');row.icon:SetSize(38,38);row.icon:SetPoint('TOPLEFT',6,-10)
            row.name=app.createLabel(row,14,52,-8,440);row.name:SetHeight(23)
            row.stock=app.createLabel(row,11,52,-34,440);row.stock:SetHeight(30)
            row.slider=CreateFrame('Slider',nil,row);row.slider:SetSize(340,24);row.slider:SetPoint('TOPLEFT',52,-70);row.slider:SetOrientation('HORIZONTAL')
            row.slider.track=row.slider:CreateTexture(nil,'BACKGROUND');row.slider.track:SetTexture(app.uiPath('SliderTrack'));row.slider.track:SetPoint('CENTER');row.slider.track:SetSize(340,8)
            row.slider.thumb=row.slider:CreateTexture(nil,'OVERLAY',nil,7);row.slider.thumb:SetTexture(app.uiPath('SliderThumb'));row.slider.thumb:SetSize(20,24)
            row.slider:SetThumbTexture(row.slider.thumb)
            row.slider:SetMinMaxValues(0,200);row.slider:SetValueStep(1);app.try(row.slider.SetObeyStepOnDrag,row.slider,true)
            row.box=CreateFrame('EditBox',nil,row,'InputBoxTemplate');row.box:SetSize(64,26);row.box:SetPoint('TOPLEFT',428,-67);row.box:SetAutoFocus(false)
            row.box:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',14,'');app.try(row.box.SetNumeric,row.box,true)
            row.slider:SetScript('OnValueChanged',function(_,value)
                if not f.syncing and app.setPoisonTarget(row.recipe.id,value)then f.syncing=true;row.box:SetText(tostring(targets()[row.recipe.id]));f.syncing=false;app.renderPoisonStockRow(row)end
            end)
            row.box:SetScript('OnEnterPressed',function(self)
                if app.setPoisonTarget(row.recipe.id,self:GetText())then app.renderPoisonPlanner()end;self:ClearFocus()
            end)
            row.box:SetScript('OnTextChanged',function(self)
                if not f.syncing and self:GetText()~=''then app.setPoisonTarget(row.recipe.id,self:GetText());app.renderPoisonStockRow(row)end
            end)
            row.box:SetScript('OnEscapePressed',function(self)self:ClearFocus();app.renderPoisonPlanner()end)
            f.rows[i]=row
        end
        row.recipe=r;row.icon:SetTexture(app.craftDisplay(r));row.name:SetText(app.recipeName(r))
        row.slider:SetValue(targets()[r.id]or 0)
        if not app.try(row.box.HasFocus,row.box)then row.box:SetText(tostring(targets()[r.id]or 0))end
        app.renderPoisonStockRow(row)
        if s.job or not yieldFor(r)or not inputs(r)then row.slider:Disable();row.box:Disable()else row.slider:Enable();row.box:Enable()end
        row:Show()
    end
    for i=#recipes+1,#f.rows do f.rows[i]:Hide()end
    local viewport=math.max(1,math.min(3,#recipes))*104
    f.scroll:SetHeight(viewport);f.content:SetHeight(math.max(viewport,#recipes*104))
    if f.visibleRows~=#recipes then app.try(f.scroll.SetVerticalScroll,f.scroll,0);f.visibleRows=#recipes end
    if #recipes==0 then f.empty:SetText(app.caption('poison_empty'));f.empty:Show()else f.empty:Hide()end
    local statusY=146+viewport+10;local buttonsY=statusY+42;local vendorY=buttonsY+36
    f.status:ClearAllPoints();f.status:SetPoint('TOPLEFT',24,-statusY)
    f.statusBackdrop:ClearAllPoints();f.statusBackdrop:SetPoint('TOPLEFT',24,-statusY+4)
    for i,b in ipairs({f.apply,f.shop,f.craft})do b:ClearAllPoints();b:SetPoint('TOPLEFT',({24,202,380})[i],-buttonsY)end
    f.vendor:ClearAllPoints();f.vendor:SetPoint('TOPLEFT',24,-vendorY)
    f:SetHeight(vendorY+48);app.applyProfessionTheme(f,40);f.syncing=false
    f.status:SetText(app.actionNotice or app.poisonVendorQueue and app.caption('poison_buy_running')or app.poisonDone and app.caption(s.restock and 'poison_stock_done'or 'poison_done')or app.routeSummary())
    f.apply:SetText(app.caption(s.job and 'poison_cancel'or s.restock and 'poison_stock_apply'or 'poison_apply'));f.craft:SetText(app.caption('poison_craft'));f.shop:SetText(app.caption('poison_shop'));f.vendor:SetText(app.caption('poison_vendor'))
    app.poisonVendorOffer=app.poisonVendorQuote()
    if app.poisonVendorOffer then f.vendor:SetText(app.caption('poison_vendor')..': '..app.money(app.poisonVendorOffer.cost))end
    if s.job and app.vendorPurchase.open and not app.poisonVendorQueue then f.vendor:Enable()else f.vendor:Disable()end
end
function app.renderPoisonStockRow(row)
    if not state().restock then row.stock:SetText(app.caption('poison_extra_line',targets()[row.recipe.id]or 0));return end
    local stock=app.poisonStock(row.recipe)
    if not stock then row.stock:SetText(app.caption('poison_stock_unknown'));return end
    local loc=stock.locations or {}
    row.stock:SetText(app.caption('poison_stock_line',stock.bags,stock.goal,stock.missing,stock.crafts*stock.yield)..'\n'..app.caption('poison_stock_elsewhere',loc.bank~=nil and tostring(loc.bank)or '?',loc.altTotal or 0))
end
function app.showPoisonPlanner()
    if not app.poisonUnlocked()then return notice('poison_open')end
    if not app.isPoison()then return notice('poison_open')end
    if not app.poisonWindow then
        local f=app.createWindow('CraftDejaPoisons',580,386);app.poisonWindow=f;f.rows={}
        f.hint=app.createLabel(f,11,24,-52,532);f.hint:SetHeight(44)
        f.mode=app.createButton(f,24,-104,270,'',function()app.setPoisonRestock(not state().restock)end)
        f.scope=app.createLabel(f,10,306,-112,250)
        local scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');f.scroll=scroll;scroll:SetSize(508,104);scroll:SetPoint('TOPLEFT',24,-146)
        f.content=CreateFrame('Frame',nil,scroll);f.content:SetSize(508,104);scroll:SetScrollChild(f.content)
        f.empty=app.createLabel(f.content,12,12,-14,480);f.empty:SetHeight(68)
        f.status=app.createLabel(f,12,24,-260,532);f.status:SetHeight(32)
        f.statusBackdrop=f:CreateTexture(nil,'BACKGROUND',nil,6);f.statusBackdrop:SetColorTexture(.07,.035,.12,.9);f.statusBackdrop:SetSize(532,36)
        f.apply=app.createButton(f,24,-302,170,'',function()if state().job then app.cancelPoisonOrder()else app.startPoisonOrder()end;app.renderPoisonPlanner()end)
        f.shop=app.createButton(f,202,-302,170,'',function()app.showPoisonMaterials()end)
        f.craft=app.createButton(f,380,-302,176,'',function()app.preparePoisonQueue();app.renderPoisonPlanner()end)
        f.vendor=app.createButton(f,24,-338,532,'',function()app.startPoisonVendorQueue();app.renderPoisonPlanner()end)
    end
    app.poisonWindow:Show();app.renderPoisonPlanner()
end
function app.showPoisonMaterials()
    if not app.isPoison()then return notice('poison_open')end
    if not app.poisonMaterialsWindow then
        local f=app.createWindow('CraftDejaPoisonMaterials',580,490);app.poisonMaterialsWindow=f;f.rows={}
        f.status=app.createLabel(f,11,18,-50,540);f.status:SetHeight(24)
        local scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');scroll:SetSize(530,325);scroll:SetPoint('TOPLEFT',20,-85)
        f.content=CreateFrame('Frame',nil,scroll);f.content:SetSize(510,325);scroll:SetScrollChild(f.content)
        f.ah=app.createButton(f,18,-430,262,'',function()app.searchShopping();app.refreshNextStep(true)end)
        f.vendor=app.createButton(f,290,-430,272,'',function()app.startPoisonVendorQueue();app.renderPoisonMaterials()end)
    end
    app.poisonMaterialsWindow:Show();app.renderPoisonMaterials()
end
function app.renderPoisonMaterials()
    local f=app.poisonMaterialsWindow;if not f or not f:IsShown()or not app.isPoison()then return end
    f.title:SetText('CraftDeja - '..app.caption('materials'));f.status:SetText(app.caption('poison_ingredients'))
    local plan,why=app.poisonPlan()
    if not plan then f.status:SetText(app.caption(why or 'poison_choose'))end
    for i,r in ipairs(plan and plan.rows or {})do
        local row=f.rows[i]
        if not row then
            row=CreateFrame('Frame',nil,f.content);row:SetSize(510,60);row:SetPoint('TOPLEFT',0,-(i-1)*64)
            row.icon=row:CreateTexture(nil,'ARTWORK');row.icon:SetSize(36,36);row.icon:SetPoint('TOPLEFT',0,-8)
            row.name=app.createLabel(row,12,45,-2,460);row.info=app.createLabel(row,11,45,-22,460);row.source=app.createLabel(row,10,45,-40,460)
            row:EnableMouse(true);row:SetScript('OnEnter',function(self)app.showTip(self,self.data.name,app.inventoryLines(self.data.locations,self.data.total))end);row:SetScript('OnLeave',app.hideTip)
            f.rows[i]=row
        end
        row.data=r;row.name:SetText(r.name);row.icon:SetTexture(app.itemIcon(r.id))
        local mail,reserved=app.confirmedMail(r.id),app.purchaseReserved(r.id)
        row.info:SetText(app.caption('poison_material_line',r.total,r.owned or '?',math.max(0,r.buy-mail-reserved)))
        row.source:SetText(app.caption('poison_material_source',app.caption(r.vendor and 'origin_vendor'or 'shop_button')..' · '..app.money(r.unit),mail,reserved));row:Show()
    end
    local n=plan and #plan.rows or 0;for i=n+1,#f.rows do f.rows[i]:Hide()end;f.content:SetHeight(math.max(325,n*64))
    f.ah:SetText(app.caption('compact_search'));app.poisonVendorOffer=app.poisonVendorQuote();f.vendor:SetText(app.caption('poison_vendor')..(app.poisonVendorOffer and ': '..app.money(app.poisonVendorOffer.cost)or ''))
    if app.shoppingFresh()and plan and plan.priceKnown then f.ah:Enable()else f.ah:Disable()end
    if app.poisonVendorOffer and not app.poisonVendorQueue then f.vendor:Enable()else f.vendor:Disable()end
end
local oldUI=app.refreshUI
app.refreshUI=function()
    oldUI()
    if not app.isPoison()then
        if app.poisonWindow then app.poisonWindow:Hide()end
        if app.poisonMaterialsWindow then app.poisonMaterialsWindow:Hide()end
    else app.renderPoisonPlanner();app.renderPoisonMaterials()end
end
local oldMain=app.renderMain
app.renderMain=function()
    local decision,problem=app.decision,app.problem
    if app.isPoison()then app.decision=nil;app.problem='poison_choose'end
    oldMain();app.decision=decision;app.problem=problem
    if app.isPoison()then
        local f=app.main;f.recipe:SetText(app.poisonDone and app.caption('poison_completed_short')or app.caption('poison_title'))
        f.info:SetText(app.routeSummary());f.price:SetText('');f.stage:SetText('');f.ranges:SetText('')
        f.nextRecipe:SetText(app.caption('poison_plan_hint'));f.nextInfo:SetText(app.caption('poison_shared_hint'))
        f.note:SetText(app.nativeCraftHandoff and app.caption('poison_confirm')or app.craftBatch and app.craftQueueBody()or state().job and app.caption('poison_follow_step')or app.caption('poison_choose'))
        if not f.poisonPlanner then
            f.poisonPlanner=app.createButton(f.currentPanel,356,-6,116,'',function()app.showPoisonPlanner()end)
            app.styleButton(f.poisonPlanner,'bag',false);f.poisonPlanner.fixedRole=true
        end
        f.poisonPlanner:SetText(app.caption('poison_open_planner'))
        if f.guideVisible then f.poisonPlanner:Hide()else f.poisonPlanner:Show()end
    elseif app.main.poisonPlanner then app.main.poisonPlanner:Hide()end
end
local oldRequestShopping=app.requestShopping
app.requestShopping=function()
    if app.isPoison()then return app.searchShopping()end
    return oldRequestShopping()
end
