-- SPDX-License-Identifier: MIT
local _,app=...
local words={en={route_title='Level route',route_open='Plan level route',route_target='Target skill',route_start='Plan route',route_apply='Accept new route',route_cancel='End route',route_prices='Refresh AH prices',route_details='Show/hide details',route_share='Share guild recipes: %s',route_teach='Learn next planned recipe',route_teacher='Trainer visit: %d recipes, fee %s',route_none_teacher='No planned recipe currently available at this trainer.',route_calculating='Comparing complete routes...',route_no_complete='No complete route with the available data. Check prices, recipes and skill access.',route_goal_done='Route target %d reached.',route_price_change='New prices suggest a different route. Review the comparison.',route_supply_action='Obtain %d x %s from %s.',route_wait_delivery='Waiting for %d x %s from %s. Check bags after delivery.',route_alt_action='Prepare or transfer %d x %s on this character.',route_return_owner='Return to the character who owns this route.',route_whisper='Could you craft %d x %s? Please confirm price/tip and delivery costs before I order.',route_skip='Skip guild craft\nand buy at the AH',route_supply='Supplier: %s · %s · %s',route_conditions='Confirm terms and acceptance',route_mode='Payment: %s',route_materials='own materials + total tip',route_fixed='fixed price per output batch',route_money='Price / total tip (copper)',route_transfer='Delivery cost (copper)',route_received='Confirm material handover',route_prepare_handover='Prepare material handover',route_reset='Reset AH preference for item',route_owner_profession='Open the route owner profession.',route_summary='Skill %d → %d · %d segments · %d compared routes',route_costs='Remaining estimated purchases %s · learning %s · delivery/tip %s\nConsumed stock value %s · vendor credit %s\nExpected net cost %s',route_estimated='PROVISIONAL: missing proof. No confirmed savings.',route_saving='Expected saving versus the next compared complete alternative: %s.',route_segment='%d → %d: %s · about %d crafts',route_bound='Bounded candidate search. Lowest among the compared routes; not an unrestricted global optimum.',route_reason='Check: %s',route_provider='Manufacturer / item',route_help='Same goal, inventory and price snapshot. Values are remaining estimates. Clicks prepare actions; you confirm purchases, learning, whispers and native crafting. Open offers for decisive item quantities. No bank or gold data is shared.',route_error='Action unavailable: %s'},de={route_title='Levelroute',route_open='Levelroute planen',route_target='Zielskill',route_start='Route planen',route_apply='Neue Route übernehmen',route_cancel='Route beenden',route_prices='AH-Preise aktualisieren',route_details='Details ein-/ausklappen',route_share='Gildenrezepte teilen: %s',route_teach='Nächstes geplantes Rezept lernen',route_teacher='Lehrerbesuch: %d Rezepte, Gebühr %s',route_none_teacher='Bei diesem Lehrer ist derzeit kein geplantes Rezept verfügbar.',route_calculating='Vollständige Routen werden verglichen...',route_no_complete='Keine vollständige Route mit vorhandenen Daten. Preise, Rezepte und Skillzugang prüfen.',route_goal_done='Routenziel %d erreicht.',route_price_change='Neue Preise sprechen für eine andere Route. Vergleich prüfen.',route_supply_action='%d x %s bei %s beschaffen.',route_wait_delivery='Warte auf %d x %s von %s. Nach Erhalt Taschen prüfen.',route_alt_action='Auf diesem Charakter %d x %s vorbereiten oder übertragen.',route_return_owner='Zum Charakter mit dem Levelauftrag zurückkehren.',route_whisper='Kannst du %d x %s herstellen? Bitte Preis/Trinkgeld und Übergabekosten vor dem Auftrag bestätigen.',route_skip='Gilden-Craft überspringen\nund im AH kaufen',route_supply='Hersteller: %s · %s · %s',route_conditions='Konditionen und Zusage bestätigen',route_mode='Bezahlung: %s',route_materials='eigene Materialien + Gesamttrinkgeld',route_fixed='Festpreis pro Ausgabepaket',route_money='Preis / Gesamttrinkgeld (Kupfer)',route_transfer='Übergabekosten (Kupfer)',route_received='Materialübergabe bestätigen',route_prepare_handover='Materialübergabe vorbereiten',route_reset='AH-Vorgabe für Gegenstand zurücksetzen',route_summary='Skill %d → %d · %d Abschnitte · %d verglichene Routen',route_costs='Offen geschätzt: Zukauf %s · Lernen %s · Übergabe/Trinkgeld %s\nVerbrauchter Bestand %s · Händlererlös %s\nErwartete Nettokosten %s',route_estimated='VORLÄUFIG: Nachweise fehlen. Keine bestätigte Ersparnis.',route_saving='Erwartete Ersparnis gegenüber der nächsten verglichenen vollständigen Alternative: %s.',route_segment='%d → %d: %s · ca. %d Herstellungen',route_bound='Begrenzte Kandidatensuche. Günstigste der verglichenen Routen, kein uneingeschränktes globales Optimum.',route_reason='Prüfen: %s',route_provider='Hersteller / Gegenstand',route_help='Gleiches Ziel, gleicher Bestand und Preisstand. Werte sind Schätzungen für den offenen Bedarf. Klicks bereiten vor; Käufe, Lernen, Whisper und native Herstellung bestätigst du. Angebote für entscheidende Mengen öffnen. Bank- und Goldbestände werden nicht geteilt.',route_error='Aktion nicht verfügbar: %s'}}
for lang,rows in pairs(words)do for k,v in pairs(rows)do app.words[lang][k]=v end end
-- Keep placeholder order aligned between both languages and every call site.
app.words.en.route_supply_action='Obtain %s x%d from %s.';app.words.de.route_supply_action='%s x%d bei %s beschaffen.'
app.words.en.route_wait_delivery='Waiting for %s x%d from %s. Check bags after delivery.';app.words.de.route_wait_delivery='Warte auf %s x%d von %s. Nach Erhalt Taschen prüfen.'
app.words.en.route_alt_action='Prepare or transfer %s x%d on this character.';app.words.de.route_alt_action='Auf diesem Charakter %s x%d vorbereiten oder übertragen.'
app.words.en.route_whisper='Could you craft %s x%d? Please confirm price/tip and delivery costs before I order.';app.words.de.route_whisper='Kannst du %s x%d herstellen? Bitte Preis/Trinkgeld und Übergabekosten vor dem Auftrag bestätigen.'
app.words.en.route_offers='Check route offers';app.words.de.route_offers='Routenangebote prüfen'
local function edit(parent,x,y,width)
    local f=CreateFrame('EditBox',nil,parent,'InputBoxTemplate');f:SetSize(width,24);f:SetPoint('TOPLEFT',x,y);f:SetAutoFocus(false);f:SetNumeric(true);return f
end
local function providers(search)
    local rows,seen={},{}
    for item,list in pairs(search and search.model.providers or {})do
        for _,p in ipairs(list)do if not seen[p.key]and search.best and (search.best.demand[item]or 0)>0 then seen[p.key]=true;rows[#rows+1]={provider=p,item=item,quantity=search.best.demand[item]}end end
    end
    for _,s in ipairs(search and search.best and search.best.transfers or {})do
        if s.provider.key and not seen[s.provider.key]then seen[s.provider.key]=true;rows[#rows+1]={provider=s.provider,item=s.item,quantity=s.quantity}end
    end
    table.sort(rows,function(a,b)return a.provider.key<b.provider.key end);return rows
end
function app.renderRouteWindow()
    local f=app.routeWindow;if not f or not f:IsShown()then return end
    local order=app.currentRouteOrder();local search=app.routeSuggestion or app.routeResult
    local lines={app.caption('route_help')}
    if app.actionNotice then lines[#lines+1]=app.actionNotice end
    f.title:SetText(app.caption('route_title'));f.plan:SetText(app.caption(app.routeSuggestion and 'route_apply'or 'route_start'))
    f.share:SetText(app.caption('route_share',app.caption(app.options.guildRecipeSharing and 'enabled'or 'disabled')))
    f.cancel:SetText(app.caption('route_cancel'));f.prices:SetText(app.caption('route_prices'));f.details:SetText(app.caption('route_details'))
    f.targetLabel:SetText(app.caption('route_target'));f.amountLabel:SetText(app.caption('route_money'));f.transferLabel:SetText(app.caption('route_transfer'))
    f.offers:SetText(app.caption('route_offers'));f.skip:SetText(app.caption('route_skip'));f.reset:SetText(app.caption('route_reset'))
    f.handover:SetText(app.caption('route_prepare_handover'));f.sent:SetText(app.caption('route_received'))
    if app.routeSearch or app.routeDirty then lines[#lines+1]=app.caption('route_calculating')end
    if search and search.best then
        local best=search.best
        lines[#lines+1]=app.caption('route_summary',search.model.start,search.model.target,#best.segments,search.compared)
        if best.provisional then lines[#lines+1]=app.caption('route_estimated')end
        local materials,learning,transfer=best.cashMaterials,best.cashLearning,best.cashTransfer
        if best.provisional then materials=nil;learning=nil;transfer=nil end
        lines[#lines+1]=app.caption('route_costs',app.money(materials),app.money(learning),app.money(transfer),app.money(best.owned),app.money(best.vendor),app.money(best.knownNet))
        if search.saving then lines[#lines+1]=app.caption('route_saving',app.money(search.saving))end
        lines[#lines+1]=app.caption('route_bound')
        if f.expanded then
            for _,s in ipairs(best.segments)do local r=search.model.rawRecipes[s.recipe]or search.model.recipes[s.recipe];lines[#lines+1]=app.caption('route_segment',s.from,s.to,app.recipeName(r),s.crafts)end
            local reasons={};for key in pairs(best.reasons)do reasons[#reasons+1]=key end;table.sort(reasons)
            for _,reason in ipairs(reasons)do lines[#lines+1]=app.caption('route_reason',reason)end
            local ids={};for id in pairs(best.bought)do ids[#ids+1]=id end;table.sort(ids)
            for _,id in ipairs(ids)do local price=search.model.prices[id];lines[#lines+1]=app.itemName(id)..' x'..best.bought[id]..' · '..app.inventoryTimestamp(type(price)=='table'and price.at)end
        end
        f.visit=app.routeTeacherVisit(best)
        lines[#lines+1]=#f.visit.available>0 and app.caption('route_teacher',#f.visit.available,app.money(f.visit.total))or app.caption('route_none_teacher')
        if f.expanded then
            for _,r in ipairs(f.visit.available)do lines[#lines+1]='[+] '..r.name..' · '..app.money(r.cost)end
            for _,r in ipairs(f.visit.locked)do lines[#lines+1]='[?] '..(r.name or tostring(r.id))..' · '..tostring(r.skill or r.kind)end
        end
    elseif order then lines[#lines+1]=app.caption(app.routeBuildProblem or 'route_no_complete')end
    f.providerRows=providers(search);f.providerIndex=math.max(1,math.min(f.providerIndex or 1,#f.providerRows));f.selection=f.providerRows[f.providerIndex]
    local s=f.selection
    if s then
        local p=s.provider;f.provider:SetText((p.name or '?')..' · '..app.itemName(s.item)..' x'..s.quantity)
        lines[#lines+1]=app.caption('route_supply',p.name or '?',p.kind=='guild'and (p.online and 'Online'or 'Offline')or 'Alt',app.inventoryTimestamp(p.at))
        if search then
            local c=app.compareRouteSupply(search.model,s.item,s.quantity,order and order.forceAH[s.item])
            for _,r in ipairs(c.alternatives)do lines[#lines+1]=r.kind..' · '..app.money(r.cash)..' / '..app.money(r.net)..' · '..tostring(r.confirmed)end
            for _,r in ipairs(c.options)do lines[#lines+1]=(r.provider.name or r.kind)..' · '..tostring(r.reason or 'confirmation_required')end
        end
    else f.provider:SetText(app.caption('route_provider'))end
    f.mode:SetText(app.caption('route_mode',app.caption(f.fixed and 'route_fixed'or 'route_materials')))
    f.conditions:SetText(app.caption('route_conditions'));f.teacher:SetText(app.caption('route_teach'))
    f.body:SetText(table.concat(lines,'\n\n'));local h=f.body:GetStringHeight()+10;f.body:SetHeight(h);f.child:SetHeight(math.max(280,h))
end
function app.showRouteWindow(target)
    if not app.routeWindow then
        local f=app.createWindow('CraftDejaRoute',760,735);app.routeWindow=f
        f:SetFrameLevel(2000)
        f.targetLabel=app.createLabel(f,11,18,-55,100);f.targetLabel:SetText(app.caption('route_target'));f.target=edit(f,125,-50,70)
        f.plan=app.createButton(f,212,-48,245,'',function()
            if app.routeSuggestion then app.acceptRouteSuggestion()else app.startRouteOrder(tonumber(f.target:GetText()))end
            app.renderRouteWindow();app.refreshNextStep(true)
        end)
        f.cancel=app.createButton(f,473,-48,265,'',function()app.cancelRouteOrder();app.renderRouteWindow()end)
        f.prices=app.createButton(f,18,-87,232,'',function()app.requestShopping();app.renderRouteWindow()end)
        f.share=app.createButton(f,261,-87,315,'',function()app.setGuildRecipeSharing(not app.options.guildRecipeSharing);app.renderRouteWindow()end)
        f.discover=app.createButton(f,589,-87,149,'Gilde / Guild',function()app.requestGuildRouteRecipes();app.renderRouteWindow()end)
        f.details=app.createButton(f,18,-126,173,'',function()f.expanded=not f.expanded;app.renderRouteWindow()end)
        f.offers=app.createButton(f,202,-126,176,app.caption('route_offers'),function()
            if not app.checkRouteOffers()then app.actionNotice=app.caption('shop_wait_scan')end;app.renderRouteWindow()
        end)
        f.teacher=app.createButton(f,389,-126,349,'',function()local ok,why=app.learnPlannedRecipe(f.visit);if not ok then app.actionNotice=app.caption('route_error',why)end;app.renderRouteWindow()end)
        f.scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');f.scroll:SetPoint('TOPLEFT',18,-170);f.scroll:SetSize(703,280)
        f.child=CreateFrame('Frame',nil,f.scroll);f.child:SetSize(690,280);f.scroll:SetScrollChild(f.child)
        f.body=app.createLabel(f.child,11,0,0,685)
        f.provider=app.createButton(f,18,-467,720,'',function()f.providerIndex=(f.providerIndex or 1)%math.max(1,#(f.providerRows or {}))+1;f.amount:SetText('');f.transfer:SetText('');app.renderRouteWindow()end)
        f.mode=app.createButton(f,18,-506,720,'',function()f.fixed=not f.fixed;app.renderRouteWindow()end)
        f.amountLabel=app.createLabel(f,10,18,-549,290);f.amountLabel:SetText(app.caption('route_money'));f.amount=edit(f,310,-541,90)
        f.transferLabel=app.createLabel(f,10,420,-549,190);f.transferLabel:SetText(app.caption('route_transfer'));f.transfer=edit(f,640,-541,90)
        f.conditions=app.createButton(f,18,-579,720,'',function()
            local s=f.selection;if not s then return end
            local ok=app.setRouteProviderTerms(s.provider.key,s.item,{mode=f.fixed and 'fixed'or 'materials',tip=tonumber(f.amount:GetText()),
                fixedPrice=tonumber(f.amount:GetText()),transferCost=tonumber(f.transfer:GetText()),accepted=true})
            if not ok then app.actionNotice=app.caption('route_error',app.caption('route_transfer'))end
            app.renderRouteWindow()
        end)
        f.whisper=app.createButton(f,18,-620,230,'Whisper',function()local s=f.selection;if s and s.provider.kind=='guild'then app.openGuildCraftWhisper(s.provider,s.item,s.quantity)end end)
        f.skip=app.createButton(f,261,-620,232,app.caption('route_skip'),function()if f.selection then app.skipGuildRouteItem(f.selection.item);app.renderRouteWindow();app.refreshNextStep(true)end end)
        f.reset=app.createButton(f,506,-620,232,'',function()if f.selection then app.resetGuildRouteItem(f.selection.item);app.renderRouteWindow()end end);f.reset:SetText(app.caption('route_reset'))
        f.handover=app.createButton(f,18,-659,350,app.caption('route_prepare_handover'),function()
            local s=app.currentRouteSupply();local ok=app.prepareRouteHandover(s)
            if not ok then app.actionNotice=app.caption('route_error',app.caption('step_unknown'))end;app.renderRouteWindow()
        end)
        f.sent=app.createButton(f,389,-659,349,app.caption('route_received'),function()
            local s=app.currentRouteSupply();local ok=app.confirmRouteHandover(s)
            if not ok then app.actionNotice=app.caption('route_error',app.caption('step_unknown'))end;app.renderRouteWindow()
        end)
        f.expanded=true
    end
    local f=app.routeWindow;local order=app.currentRouteOrder()
    f.target:SetText(tostring(target or order and order.target or app.active and app.active.profile.cap or 75));f:Show();app.try(f.Raise,f);app.renderRouteWindow()
end
local cta=app.applyGuideCTA
app.applyGuideCTA=function(f,plan)
    cta(f,plan)
    local task=f.task;local kind=task and task.kind or ''
    if kind:find('route_',1,true)==1 then
        f.body:SetText(task.body);f.body:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',13,'');f.body:SetHeight(44)
        f.primaryCTA:SetText(app.caption(kind=='route_pending'and 'cta_wait'or 'route_open'))
        if kind=='route_pending'then f.primaryCTA:Disable()else f.primaryCTA:Enable()end
    end
    if task and task.supply and task.supply.source=='guild'then
        if not f.routeSkip then f.routeSkip=app.createButton(f,18,0,324,'',function()if f.task and f.task.supply then app.skipGuildRouteItem(f.task.supply.item);app.refreshNextStep(true)end end);f.routeSkip:SetHeight(36)end
        f.routeSkip:ClearAllPoints();f.routeSkip:SetPoint('TOPLEFT',18,-f:GetHeight()+5);f.routeSkip:SetText(app.caption('route_skip'));app.styleCTAButton(f.routeSkip,false);f.routeSkip:Show();f:SetHeight(f:GetHeight()+40)
    elseif f.routeSkip then f.routeSkip:Hide()end
end
local action=app.unifiedAction
app.unifiedAction=function(f)
    local t=f.task
    if t and t.kind=='route_profession'then
        local order=app.currentRouteOrder();if order then app.openCraftProfession(nil,order.profession)end;return true
    end
    if t and t.kind=='route_supply_alt'and t.supply and t.supply.provider.recipe and
        (not app.active or app.active.profile.id~=t.supply.provider.profession or not app.professionOpen)then
        app.openCraftProfession(t.supply.provider.recipe,t.supply.provider.profession);return true
    end
    if t and t.kind=='route_supply_alt'and t.craftPlan then
        if t.materialTask.kind=='craft'then app.craftNext(t.craftPlan,true)
        elseif t.materialTask.kind=='ah'then app.searchShopping()
        else app.showRouteWindow()end
        return true
    end
    if t and t.kind and t.kind:find('route_',1,true)==1 then app.showRouteWindow();return true end
    return action(f)
end
