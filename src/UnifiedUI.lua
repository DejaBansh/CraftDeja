-- SPDX-License-Identifier: MIT
local _,app=...
app.words.en.vendor_named_action='Buy %s · %d';app.words.de.vendor_named_action='%s kaufen · %d'
app.unifiedUI=true
local words={en={ui_change='Change order',ui_options='Options',ui_back='Back to guide',ui_apply='Apply order',ui_draft='%d poison types / %d units selected.\nApply the order to plan the ingredients.',ui_draft_button='Apply order: %d units',ui_open_poison='Open Poisons once to read your learned recipes.',ui_settings='Settings',ui_lookup='Reference',ui_help='Help',ui_general='General settings',ui_limit='Price limit: scan +%d%%',ui_alts='Deduct alt materials: %s',ui_unlock='Allow a new AH search',ui_center='Reset guide position',ui_catalog='Recipe catalogue',ui_materials='Materials & storage',ui_source='Recipe details & sources',ui_merchants='Vendor locations',ui_tutorial='Getting started',ui_audit='Recipe observations (%d)',ui_log='Diagnostic log',ui_diagnostic='Purchase diagnostics',ui_vendor_all='Buy ingredients: %s',ui_vendor_one='Buy %d: %s',ui_vendor_running='Buying ingredients...',ui_skill='Skill target',ui_goal_next='Until next action',ui_goal_manual='Manual: +%d skill points',ui_no_recipe='No current recipe. Open your profession first.',ui_price_info='Prices and skill-up quantities are estimates.'},de={ui_change='Auftrag ändern',ui_options='Optionen',ui_back='Zurück zum Guide',ui_apply='Auftrag übernehmen',ui_draft='%d Giftarten / %d Stück gewählt.\nAuftrag übernehmen, um die Zutaten zu planen.',ui_draft_button='Auftrag übernehmen: %d Stück',ui_open_poison='Öffne Gifte einmal, damit deine gelernten Rezepte eingelesen werden.',ui_settings='Einstellungen',ui_lookup='Nachschlagen',ui_help='Hilfe',ui_general='Allgemeine Einstellungen',ui_limit='Preislimit: Scan +%d%%',ui_alts='Alt-Materialien abziehen: %s',ui_unlock='Neue AH-Suche freigeben',ui_center='Guide-Position zurücksetzen',ui_catalog='Rezeptkatalog',ui_materials='Materialien & Lagerorte',ui_source='Rezeptdetails & Herkunft',ui_merchants='Händlerstandorte',ui_tutorial='Einstiegsleitfaden',ui_audit='Rezeptbeobachtungen (%d)',ui_log='Diagnoseprotokoll',ui_diagnostic='Kaufdiagnose',ui_vendor_all='Zutaten kaufen: %s',ui_vendor_one='%d kaufen: %s',ui_vendor_running='Zutaten werden gekauft...',ui_skill='Skillziel',ui_goal_next='Bis zur nächsten Aktion',ui_goal_manual='Manuell: +%d Skillpunkte',ui_no_recipe='Kein aktuelles Rezept. Öffne zuerst deinen Beruf.',ui_price_info='Preise und Skillmengen sind Schätzungen.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.ui_resize='Drag the bottom-right corner to scale the guide.';app.words.de.ui_resize='Unten rechts ziehen, um den Guide zu skalieren.'
app.words.en.ui_units='%d units planned';app.words.de.ui_units='%d Stück geplant'
app.words.en.ui_poison_types='%d poison types';app.words.de.ui_poison_types='%d Giftarten'
app.words.en.ui_stock_unavailable='Bag stock unavailable';app.words.de.ui_stock_unavailable='Taschenbestand unbekannt'
app.words.en.ui_stock_counts='Bags %d | Target %d | Missing %d'
app.words.de.ui_stock_counts='Taschen %d | Ziel %d | Fehlen %d'
app.words.en.ui_extra_counts='Bags %d | Additional %d'
app.words.de.ui_extra_counts='Taschen %d | Zusätzlich %d'
app.words.en.ui_stock_full='Target stock reached'
app.words.de.ui_stock_full='Zielbestand erreicht'
function app.poisonModeSummary()
    local s=app.character.poisons or {};local j=s.job
    local restock=j and j.restock or not j and s.restock
    local selected=j and j.requested or restock and s.stockTargets or s.targets
    local bags,goal,missing,known=0,0,0,true
    local lines={}
    for id,n in pairs(selected or {})do if n>0 then
        local r=app.active and app.active.recipes[id];local st=r and app.poisonStock(r)
        if st then
            local target=j and j.goals[id]or n
            bags=bags+st.bags;goal=goal+target;missing=missing+math.max(0,target-st.bags)
            lines[#lines+1]=app.recipeName(r)..' [item '..st.id..']\n'..app.caption(restock and 'ui_stock_counts'or 'ui_extra_counts',st.bags,target,math.max(0,target-st.bags))
        else known=false end
    end end
    table.sort(lines)
    local mode=app.caption(restock and 'poison_mode_stock'or 'poison_mode_extra')
    local counts=known and app.caption(restock and 'ui_stock_counts'or 'ui_extra_counts',bags,goal,missing)or app.caption('ui_stock_unavailable')
    return mode..'\n'..counts,lines,known
end
local original={}
local coreNames={'output','outputName','outputCount','route','body','place','notice','action','craftAll','orderBar','attention','alertTitle','changeOrder','ctaInfo','requirementName'}
local function root()return app.nextStepWindow end
local function clearView()
    if app.unifiedView then app.unifiedView:Hide()end
    app.unifiedView=nil;app.unifiedViewKey=nil
end
local function move(f,x,y)f:ClearAllPoints();f:SetPoint('TOPLEFT',x,-y)end
local function shiftDown(w,n)
    if not w then return end
    local p,a,b,x,y=w:GetPoint();w:ClearAllPoints()
    if type(a)=='number'then w:SetPoint(p,a,b-n)else w:SetPoint(p,a,b,x,y-n)end
end
local function chrome(f)
    if not f.headerChrome then
        f.headerChrome=CreateFrame('Frame',nil,f);f.headerChrome:SetAllPoints(f)
        f.headerChrome:EnableMouse(false);f.headerChrome:SetFrameLevel(999)
        f.headerChrome.title=app.createLabel(f.headerChrome,20,57,-16,220,{.87,.73,.39})
        f.headerChrome.logo=f.headerChrome:CreateTexture(nil,'ARTWORK');f.headerChrome.logo:SetSize(34,34)
        f.headerChrome.logo:SetPoint('TOPLEFT',14,-10);f.headerChrome.logo:SetTexture(app.uiPath('Logo'))
    end
    f.headerChrome.title:SetWordWrap(false);f.headerChrome.title:SetHeight(26)
    f.headerChrome.title:SetText(f.title:GetText());f.headerChrome.title:SetWidth(f:GetWidth()-140)
    f.title:Hide();if f.logo then f.logo:Hide()end
    f.title:SetWidth(f:GetWidth()-140)
    f.close:ClearAllPoints();f.close:SetPoint('TOPRIGHT',-9,-9)
    f.logButton:ClearAllPoints();f.logButton:SetPoint('TOPRIGHT',-46,-9)
    f.logButton:SetText(app.caption('ui_options'));app.styleButton(f.logButton,'gear',true)
    f.logButton:SetScript('OnClick',function()app.showOptions()end)
    f.logButton.tipLines=function()return {app.caption('ui_options')}end
    local level=1000
    app.try(f.logButton.SetFrameLevel,f.logButton,level);app.try(f.close.SetFrameLevel,f.close,level)
    if not f.unifiedChrome then
        f.unifiedChrome=true
        f:ClearAllPoints()
        local p=app.options.guidePosition
        if p then f:SetPoint(p[1],UIParent,p[2],p[3],p[4])else f:SetPoint('CENTER')end
        f:SetScript('OnDragStop',function(self)
            self:StopMovingOrSizing();local a,_,b,x,y=self:GetPoint();app.options.guidePosition={a,b,x,y}
        end)
        local dismiss=f.onDismiss
        f.onDismiss=function()
            if app.unifiedView and app.unifiedView.onDismiss then app.unifiedView.onDismiss()end
            clearView();if dismiss then dismiss()end
        end
        f.back=app.createButton(f,18,0,324,'',function()app.showCentralGuide()end)
        f.back.fixedRole=true;app.styleButton(f.back,'prev',false)
        f.changeOrder=app.createButton(f,18,0,324,'',function()app.editUnifiedOrder()end)
        f.changeOrder.fixedRole=true;app.styleButton(f.changeOrder,'bag',false)
        f.surface=f:CreateTexture(nil,'BACKGROUND',nil,1);f.surface:SetColorTexture(.07,.035,.12,.92)
    end
    f.surface:ClearAllPoints();f.surface:SetPoint('TOPLEFT',12,-48)
    f.surface:SetSize(f:GetWidth()-24,math.max(1,f:GetHeight()-63))
    app.applyProfessionTheme(f,app.unifiedView and (app.unifiedView.professionTheme or app.unifiedView==app.catalogWindow and app.unifiedView.profession)or app.active and app.active.profile.id)
end
local function hideMain()if app.main then app.main:Hide()end end
function app.poisonDraft()
    local s=app.character.poisons or {};local targets=s.restock and s.stockTargets or s.targets
    local count,total,known=0,0,true;local first;local signature={}
    if app.isPoison()then for id,n in pairs(targets or {})do
        local r=app.active.recipes[id]
        if n>0 and r and r.learned then
            count=count+1;first=first or r;signature[#signature+1]=id..':'..n
            local stock=s.restock and app.poisonStock(r)
            if s.restock and not stock then known=false
            else total=total+(s.restock and stock.missing or n)end
        end
    end end
    table.sort(signature);return count,total,first,table.concat(signature,','),known
end
local function paintView()
    local f=root();local v=app.unifiedView;if not f or not v then return end
    for _,name in ipairs(coreNames)do if f[name]then f[name]:Hide()end end
    f.attentionActive=false
    v:SetBackdrop(nil);if v.themeHeader then v.themeHeader:Hide()end;v.title:Hide();if v.logo then v.logo:Hide()end;if v.close then v.close:Hide()end
    f:SetWidth(v:GetWidth());f:SetHeight(v:GetHeight()+42)
    f.title:SetText(v.title:GetText())
    f.back:SetText(app.caption('ui_back'));f.back:SetWidth(f:GetWidth()-36);f.back.label:SetWidth(f:GetWidth()-75)
    move(f.back,18,v:GetHeight()+4);f.back:Show()
    chrome(f)
end
local function mount(v,key)
    if not v then return end
    if not root()then app.refreshNextStep(true)end
    local f=root();if not f then return end
    if app.unifiedView~=v then clearView()end
    app.unifiedView=v;app.unifiedViewKey=key
    if not v.unifiedHosted then
        v.unifiedHosted=true;v:SetParent(f);v:SetBackdrop(nil)
        v.title:Hide();if v.logo then v.logo:Hide()end;if v.close then v.close:Hide()end;if v.scaleGrip then v.scaleGrip:Hide()end
        v:SetMovable(false)
        v:SetScript('OnDragStart',function()f:StartMoving()end)
        v:SetScript('OnDragStop',function()
            f:StopMovingOrSizing();local a,_,b,x,y=f:GetPoint();app.options.guidePosition={a,b,x,y}
        end)
    end
    v:SetScale(1);v:ClearAllPoints();v:SetPoint('TOPLEFT',f,'TOPLEFT',0,0)
    -- Never leave another CraftDeja window beside the guide.
    for _,other in ipairs(app.themedWindows)do if other~=f and other~=v then other:Hide()end end
    f.dismissed=nil;f:Show();v:Show();paintView();hideMain()
end
app.mountGuidePage=mount
function app.showCentralGuide()
    clearView();app.refreshNextStep(true);hideMain()
end
local oldNext=app.renderNextStep
app.renderNextStep=function(plan,keep,task)
    local s=app.character and app.character.poisons
    if app.poisonMerchantNeedsRead and (not app.poisonUnlocked()or app.poisonMerchantNeedsRead~='explicit'and not app.poisonMerchantEligible())then app.poisonMerchantNeedsRead=nil end
    if not app.professionLoading and app.poisonMerchantNeedsRead and (app.vendorPurchase.open or app.poisonMerchantNeedsRead=='explicit')and not app.isPoison()then
        task={kind='poison_open',key='poison_open',body=app.caption('ui_open_poison')}
    elseif not app.professionLoading and app.isPoison()then
        app.poisonMerchantNeedsRead=nil
        if not(s and s.job)and not app.poisonDone then
            local count,total,_,signature=app.poisonDraft()
            if count>0 then task={kind='poison_apply',key='poison_apply:'..tostring(s.restock)..':'..signature,body=app.caption('ui_draft',count,total),draft=total}end
        end
    end
    if root()then
        for _,name in ipairs({'body','place','notice','action'})do root()[name]:Show()end
    end
    oldNext(plan,keep,task)
    local f=root();if not f then return end
    chrome(f);hideMain()
    local t=f.task
    f.draftRecipe=nil
    if t and t.kind=='poison_apply'then
        local count,total,r=app.poisonDraft()
        if r then
            f.plan=nil;f.draftRecipe=r
            f.output:Show();f.outputName:Show();f.outputCount:Show()
            f.output.icon:SetTexture(app.craftDisplay(r));f.outputName:SetText(count==1 and app.recipeName(r)or app.caption('ui_poison_types',count))
            f.outputCount:SetText(app.caption('ui_units',total))
            for _,name in ipairs({'orderBar','body','place','notice','action'})do shiftDown(f[name],54)end
            f:SetHeight(f:GetHeight()+54)
        end
        f.action:SetText(app.caption('ui_draft_button',t.draft));app.styleButton(f.action,'check',false)
        local _,_,_,_,known=app.poisonDraft()
        if s.restock and not known then f.action:SetText(app.caption('poison_stock_unknown'));f.action:Disable()
        elseif s.restock and total==0 then f.action:SetText(app.caption('ui_stock_full'));f.action:Disable()end
    elseif t and t.kind=='poison_open'then
        f.action:SetText(app.caption('poison_merchant_open'));app.styleButton(f.action,'bag',false)
    elseif t and t.kind=='vendor'and t.atVendor then
        if app.isPoison()then
            f.vendorQuote=app.poisonVendorQuote()
            if app.poisonVendorQueue then f.action:SetText(app.caption('ui_vendor_running'));f.action:Disable()
            elseif f.vendorQuote then f.action:SetText(app.caption('ui_vendor_all',app.money(f.vendorQuote.cost)))end
        else
            local vp=app.vendorPurchasePlan();f.vendorOffer=nil
            for _,row in ipairs(vp and vp.rows or {})do if row.id==t.id then f.vendorOffer=app.copy(row)end end
            if f.vendorOffer then f.action:SetText(app.caption('ui_vendor_one',f.vendorOffer.quantity,app.money(f.vendorOffer.cost)))end
        end
    end
    f.route:SetScript('OnEnter',nil);f.route:SetScript('OnLeave',nil)
    if app.isPoison()and (plan or t and t.kind=='poison_apply')then
        local summary=app.poisonModeSummary()
        f.route:SetText(summary);f.route:SetHeight(32);f.route:Show()
        if not plan then
            for _,name in ipairs({'orderBar','body','place','notice','action'})do shiftDown(f[name],32)end
            f:SetHeight(f:GetHeight()+32)
        end
        f.route:EnableMouse(true)
        f.route:SetScript('OnEnter',function()local text,lines=app.poisonModeSummary();app.showTip(f.route,text,lines)end)
        f.route:SetScript('OnLeave',app.hideTip)
    end
    local h=f:GetHeight();f:SetHeight(h+38)
    f.changeOrder:SetText(app.caption('ui_change'));move(f.changeOrder,18,h-2);f.changeOrder:Show();if app.professionLoading then f.changeOrder:Disable()else f.changeOrder:Enable()end;f.back:Hide()
    if plan and not app.isPoison()and app.active then
        f.outputCount:SetText(f.outputCount:GetText()..' · '..app.caption('skill',app.active.profile.skill,app.active.profile.cap))
    end
    if app.unifiedViewKey=='vendor'and not app.vendorPurchase.open then clearView()end
    if app.unifiedView then paintView()else
        f:SetWidth(360);f.title:SetText('CraftDeja');app.applyGuideCTA(f,plan);chrome(f)
    end
end
local ctaWords={en={cta_ah_visit='Visit auction house',cta_ah_check='Check auction house',cta_ah_search='Search auctions',cta_scan='Scanning prices',cta_wait='Please wait',cta_buy='Buy',cta_confirm='Confirm purchase',cta_purchase_check='Check purchase',cta_purchase_done='Shopping complete',cta_details='Open details',cta_mail='Collect mail',cta_mail_check='Check mail',cta_vendor='Visit vendor',cta_material='Buy materials',cta_map='Open map',cta_learn='Learn recipe',cta_source='Show source',cta_rank='Learn rank',cta_trainer='Show trainer',cta_level='Gain levels',cta_station='Visit crafting station',cta_fire='Visit cooking fire',cta_station_check='Check station',cta_craft='Craft',cta_prepare='Prepare crafting',cta_single='Prepare one',cta_native='Show Create button',cta_running='Crafting underway',cta_stop='Show stop hint',cta_done='Goal reached',cta_finished='Done',cta_open='Open profession',cta_loading='Reading profession',cta_review='Choose recipe',cta_catalog='Open recipes',cta_stock='Check inventory',cta_poison='Choose poisons',cta_poison_open='Open poisons',cta_order='Start order',cta_apply='Apply',cta_production='Choose quantity',cta_back='Back',cta_issue='Check action'},de={cta_ah_visit='Zum Auktionshaus',cta_ah_check='AH prüfen',cta_ah_search='AH durchsuchen',cta_scan='Preise einlesen',cta_wait='Bitte warten',cta_buy='Kaufen',cta_confirm='Kauf bestätigen',cta_purchase_check='Kauf prüfen',cta_purchase_done='Einkauf erledigt',cta_details='Details öffnen',cta_mail='Post abholen',cta_mail_check='Post prüfen',cta_vendor='Händler besuchen',cta_material='Material kaufen',cta_map='Karte öffnen',cta_learn='Rezept lernen',cta_source='Quelle zeigen',cta_rank='Rang lernen',cta_trainer='Lehrer zeigen',cta_level='Level erreichen',cta_station='Voraussetzung fehlt',cta_fire='Zur Kochstelle',cta_station_check='Kochstelle prüfen',cta_craft='Herstellen',cta_prepare='Herstellung vorbereiten',cta_single='Einzeln vorbereiten',cta_native='Herstellknopf zeigen',cta_running='Herstellung läuft',cta_stop='Stopp-Hinweis',cta_done='Ziel erreicht',cta_finished='Fertig',cta_open='Beruf öffnen',cta_loading='Beruf einlesen',cta_review='Rezept wählen',cta_catalog='Rezepte öffnen',cta_stock='Bestand prüfen',cta_poison='Gifte wählen',cta_poison_open='Gifte öffnen',cta_order='Auftrag starten',cta_apply='Übernehmen',cta_production='Menge festlegen',cta_back='Zurück',cta_issue='Aktion prüfen'}}
for lang,entries in pairs(ctaWords)do for key,value in pairs(entries)do app.words[lang][key]=value end end
local requirementWords={en={cta_tool='Obtain tool',cta_tool_check='Check tool',cta_workshop='Visit workstation',cta_area='Visit required location',cta_requirement_check='Check requirement',cta_cooldown='Recipe cooldown',cta_enchant='Enchant',cta_enchant_target='Choose target'},de={cta_tool='Werkzeug besorgen',cta_tool_check='Werkzeug prüfen',cta_workshop='Zur Arbeitsstätte',cta_area='Zum Herstellungsort',cta_requirement_check='Voraussetzung prüfen',cta_cooldown='Abklingzeit abwarten',cta_enchant='Verzaubern',cta_enchant_target='Ziel auswählen'}}
for lang,entries in pairs(requirementWords)do for key,value in pairs(entries)do app.words[lang][key]=value end end
function app.applyGuideCTA(f,plan)
    local task=f.task;if not task then return end
    local kind=task.kind
    local details={task.body,f.place:GetText(),f.notice:GetText(),f.route:GetText()}
    local recipe=plan and plan.recipe or task.recipe or f.draftRecipe
    if recipe then
        local requirements=kind=='craft_queue'and (recipe.requirements or {})or app.recipeRequirements(recipe)
        for _,r in ipairs(requirements)do details[#details+1]=(r.met==true and '[+] 'or '[?] ')..app.caption('requirement_checked',r.name or '?')end
    end
    if app.actionNotice then details[#details+1]=app.actionNotice end
    if plan and plan.estimated and not plan.production then
        details[#details+1]=app.caption('craft_forecast_help')
    end
    f.ctaDetails=details
    local title,label='cta_stock','cta_details'
    local primary,secondary=f.action,nil
    if kind=='ah'then title=app.shopping.open and 'cta_ah_search'or 'cta_ah_visit';label=app.shopping.open and 'cta_ah_search'or 'cta_ah_check'
    elseif kind=='scan'or kind=='ah_scan'then title,label='cta_scan','cta_wait'
    elseif kind=='ah_list'then title,label='shopping_list_update','shopping_list_update'
    elseif kind=='ah_buy'then title,label='cta_material','cta_buy'
    elseif kind=='ah_confirm'then title,label='cta_confirm','cta_confirm'
    elseif kind=='ah_load'then title,label='cta_ah_search','cta_ah_search'
    elseif kind=='ah_wait'then title,label='cta_purchase_check','cta_purchase_check'
    elseif kind=='ah_done'then title,label='cta_purchase_done','cta_details'
    elseif kind=='mail'then title,label='cta_mail','cta_mail_check'
    elseif kind=='vendor'then title,label=task.atVendor and 'cta_material'or 'cta_vendor',task.atVendor and 'cta_buy'or 'cta_map'
    elseif kind=='learn'then title,label=task.needsCostCheck and 'acquisition_check'or 'cta_learn',task.sourceTarget and 'cta_source'or 'cta_details'
    elseif kind=='rank'then title,label=task.levelBlocked and 'cta_level'or 'cta_rank','cta_trainer'
    elseif kind=='station'then
        title,label='cta_workshop','cta_workshop'
    elseif kind=='tool'then title,label='cta_tool',app.professionOpen and 'cta_tool_check'or 'cta_open'
    elseif kind=='rod_collect'then title,label='cta_rod_collect','cta_stock'
    elseif kind=='rod_wait'then title,label='cta_rod_wait','cta_wait'
    elseif kind=='cooldown'then title,label='cta_cooldown','cta_wait'
    elseif kind=='craft'then
        title,label='cta_craft','cta_prepare'
        if f.craftAll:IsShown()then primary,secondary=f.craftAll,f.action;secondary:SetText(app.caption('cta_single'))end
        if plan and plan.recipe.profession==333 and not plan.toolPreparation then title,label='cta_enchant','cta_enchant_target'end
        if plan and plan.toolPreparation then title='cta_rod'end
        if plan and plan.estimated and task.batch==1 then label='cta_attempt'end
    elseif kind=='craft_native'then
        title,label='cta_craft','cta_native'
        if f.craftAll:IsShown()then secondary=f.craftAll;secondary:SetText(app.caption('cta_back'))end
    elseif kind=='craft_queue'then
        title,label='cta_running','cta_wait'
        if f.craftAll:IsShown()then secondary=f.craftAll;secondary:SetText(app.caption('cta_stop'))end
    elseif kind=='done'then title,label='cta_done','cta_finished'
    elseif kind=='open'then title,label='cta_open','cta_open'
    elseif kind=='loading'then title,label='cta_loading','cta_wait'
    elseif kind=='review'then title,label='cta_review','cta_catalog'
    elseif kind=='poison_open'then title,label='cta_poison_open','cta_poison_open'
    elseif kind=='poison_apply'then title,label='cta_order','cta_apply'
    elseif kind=='poison'then title,label='cta_poison','cta_poison'
    elseif kind=='production_choose'then title,label='cta_production','cta_production'end
    local stationCTA=kind=='station'and app.craftStationCTA(task)
    primary:SetText(stationCTA or kind=='vendor'and task.atVendor and f.vendorOffer and app.caption('vendor_named_action',f.vendorOffer.name,f.vendorOffer.quantity)or app.caption(label))
    if kind=='cooldown'or kind=='rod_wait'then primary:Disable()end
    local cost=task.offer and task.offer.cost
    if kind=='vendor'and task.atVendor then local offer=app.isPoison()and f.vendorQuote or f.vendorOffer;cost=offer and offer.cost end
    if cost and (kind=='ah_buy'or kind=='ah_confirm'or kind=='vendor'and task.atVendor)then primary:SetText(primary:GetText()..' · '..app.money(cost))end
    f.primaryCTA=primary;f.secondaryCTA=secondary
    local extra=task.requirement and 22 or 0
    if not f.requirementName then f.requirementName=app.createLabel(f,12,18,-92,324);f.requirementName:SetHeight(20);f.requirementName:SetJustifyH('CENTER')end
    if task.requirement then f.requirementName:SetText(task.requirement.name or '?');f.requirementName:Show()else f.requirementName:Hide()end
    primary:SetWidth(324);primary.label:SetWidth(285);move(primary,18,103+extra)
    app.styleCTAButton(primary,true);primary.tipLines=function()return f.ctaDetails end
    f.route:Hide();f.place:Hide();f.notice:Hide();f.attention:Hide();f.alertTitle:Hide();f.attentionActive=false
    if plan and plan.estimated and not plan.production and (kind=='craft'or kind=='craft_native'or kind=='craft_queue')then
        local batch=kind=='craft'and task.batch or plan.crafts
        if batch then f.outputCount:SetText(app.caption('craft_safe_forecast',batch,plan.forecastTarget or plan.target,plan.expectedCrafts or plan.crafts))end
    end
    f.body:SetText(stationCTA or app.caption(title));f.body:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',22,'OUTLINE')
    f.body:SetTextColor(.98,1,.98);f.body:SetJustifyH('CENTER');f.body:SetWidth(324);f.body:SetHeight(36);move(f.body,18,58);f.body:Show()
    if not f.ctaInfo then
        f.ctaInfo=CreateFrame('Frame',nil,f);f.ctaInfo:SetAllPoints(f.body);f.ctaInfo:EnableMouse(true)
        f.ctaInfo:SetScript('OnEnter',function(self)app.showTip(self,f.body:GetText(),f.ctaDetails)end)
        f.ctaInfo:SetScript('OnLeave',app.hideTip)
    end
    f.ctaInfo:Show()
    local y=159+extra
    if app.actionNotice and app.actionNotice~=''then
        f.notice:SetText(app.caption('cta_issue'));f.notice:SetTextColor(1,.55,.45);f.notice:SetHeight(18);move(f.notice,18,y);f.notice:Show();y=y+24
    end
    if recipe then
        f.output:Show();f.outputName:Show();f.output:SetSize(30,30);move(f.output,18,y)
        move(f.outputName,58,y);f.outputName:SetWidth(284);f.outputName:SetHeight(32)
        if plan or task.recipe then
            f.outputName:SetText(app.recipeName(recipe));local icon=app.craftDisplay(recipe);f.output.icon:SetTexture(icon)
        end
        f.outputName:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',11,'')
        if kind=='craft'or kind=='craft_native'or kind=='craft_queue'or kind=='poison_apply'then
            f.outputCount:Show();move(f.outputCount,58,y+29);f.outputCount:SetWidth(284);y=y+49
        else f.outputCount:Hide();y=y+40 end
    else f.output:Hide();f.outputName:Hide();f.outputCount:Hide()end
    if plan and f.orderBar then move(f.orderBar,18,y);f.orderBar:Show();y=y+f.orderBar:GetHeight()+12
    elseif f.orderBar then f.orderBar:Hide()end
    if secondary then
        secondary:SetWidth(156);secondary.label:SetWidth(117);move(secondary,18,y);app.styleCTAButton(secondary,false)
        secondary.tipLines=function()return f.ctaDetails end
    end
    f.changeOrder:SetWidth(132);f.changeOrder.label:SetWidth(93);move(f.changeOrder,210,y)
    app.styleCTAButton(f.changeOrder,false)
    f:SetHeight(y+42)
end
function app.unifiedAction(f)
    local t=f.task
    if t.kind=='poison_apply'then
        if app.startPoisonOrder()then app.showCentralGuide()else app.refreshNextStep(true)end;return true
    elseif t.kind=='poison_open'then app.openCraftProfession(nil,40);return true
    elseif t.kind=='vendor'and t.atVendor then
        if app.isPoison()and f.vendorQuote then
            app.poisonVendorOffer=f.vendorQuote;app.startPoisonVendorQueue();app.refreshNextStep(true);return true
        elseif f.vendorOffer then
            local old=f.vendorOffer;local found
            for _,r in ipairs((app.vendorPurchasePlan()or {}).rows or {})do if r.id==old.id then found=r end end
            if not found or found.quantity~=old.quantity or found.price~=old.price or found.cost~=old.cost or found.slot~=old.slot then
                app.actionNotice=app.caption('vendor_buy_changed');app.refreshNextStep(true);return true
            end
            app.buyVendorMaterial(old.id);app.refreshNextStep(true);return true
        end
    end
    return false
end
-- Automatic merchant/scan updates update the guide, not another window.
app.offerVendorPurchase=function()
    local s=app.vendorPurchase;if not s.open or s.dismissed then return end
    app.refresh(false);s.plan=app.vendorPurchasePlan()
    if app.unifiedViewKey=='vendor'then app.renderVendorBuy()end
end
app.showShopping=function()app.refreshNextStep(true)end
app.showPoisonMerchantPrompt=function()if app.poisonMerchantEligible()then app.poisonMerchantNeedsRead=true;app.refreshNextStep(true)end end
local oldNextRefresh=app.refreshNextStep
app.refreshNextStep=function(force)
    if force and root()then root().dismissed=nil end
    if app.professionLoading then return app.renderNextStep(nil,true,{kind='loading',key='loading',body=app.caption('profession_loading')})end
    return oldNextRefresh(force)
end
local oldVendorEvent=app.vendorBuyEvent
app.vendorBuyEvent=function(event)
    if event=='MERCHANT_SHOW'then clearView()end
    oldVendorEvent(event)
    if event=='MERCHANT_SHOW'then app.refreshNextStep(true)end
    if event=='MERCHANT_CLOSED'then app.poisonMerchantNeedsRead=nil end
end
local oldPlanner=app.showPoisonPlanner
local oldRenderPlanner=app.renderPoisonPlanner
app.renderPoisonPlanner=function()
    oldRenderPlanner()
    local f=app.poisonWindow;if not f or not f.unifiedHosted or not f:IsShown()or not app.isPoison()then return end
    f.shop:Hide();f.craft:Hide();f.vendor:Hide()
    local _,_,y=f.apply:GetPoint();y=type(y)=='number'and -y or f:GetHeight()-84
    f.apply:SetWidth(532);f.apply.label:SetWidth(493)
    f:SetHeight(y+48)
    if app.unifiedView==f then paintView()end
end
app.showPoisonPlanner=function()
    if not app.poisonUnlocked()then app.poisonMerchantNeedsRead=nil;return false end
    if not app.isPoison()then app.poisonMerchantNeedsRead='explicit';app.refreshNextStep(true);return end
    oldPlanner();local f=app.poisonWindow
    if not f.unifiedApply then
        f.unifiedApply=true
        f.apply:SetScript('OnClick',function()
            local s=app.character.poisons
            if s.job then app.cancelPoisonOrder();app.renderPoisonPlanner()
            elseif app.startPoisonOrder()then app.showCentralGuide()else app.renderPoisonPlanner()end
        end)
    end
    mount(f,'poisons');app.renderPoisonPlanner()
end
local pages={showCatalogue={'catalogWindow','catalog'},showDetails={'detailsWindow','details'},showRecipeAudit={'recipeAuditWindow','audit'},showFlowLog={'flowLogWindow','log'},showPurchaseDiagnostic={'purchaseDiagnostic','diagnostic'},showMerchants={'merchantWindow','merchants'},showPoisonMaterials={'poisonMaterialsWindow','materials'},showVendorBuy={'vendorBuyWindow','vendor'}}
for name,entry in pairs(pages)do
    local fn=app[name];local method=name;local attribute=entry[1];local pageKey=entry[2];original[name]=fn
    app[name]=function(...)
        if method=='showDetails'and not select(1,...)then app.actionNotice=app.caption('ui_no_recipe');app.showCentralGuide();return end
        fn(...);local v=app[attribute];if v and v:IsShown()then mount(v,pageKey)end
    end
end
function app.selectedProductionRecipe()
    local form=ProfessionsFrame and ProfessionsFrame.CraftingPage and ProfessionsFrame.CraftingPage.SchematicForm
    local info=app.professionOpen and form and app.try(form.GetRecipeInfo,form)
    local job=app.productionJob()
    local id=info and info.recipeID or job and job.recipe
    return id and app.active and app.active.recipes[id]
end
function app.editUnifiedOrder()
    if app.professionLoading then app.showCentralGuide();return end
    if app.isPoison()then return app.showPoisonPlanner()end
    if not app.active then app.refreshNextStep(true);return end
    if not app.skillOrderView then
        local f=app.createWindow('CraftDejaSkillOrder',480,290);app.skillOrderView=f
        f.mode=app.createLabel(f,12,24,-58,432);f.mode:SetHeight(40)
        f.recipeName=app.createLabel(f,11,24,-103,432);f.recipeName:SetHeight(45)
        f.quantity=CreateFrame('EditBox',nil,f,'InputBoxTemplate');f.quantity:SetSize(110,25);f.quantity:SetPoint('TOPLEFT',24,-154)
        f.quantity:SetAutoFocus(false);f.quantity:SetNumeric(true)
        f.quantity:SetScript('OnTextChanged',function()app.renderSkillOrder()end)
        f.info=app.createLabel(f,11,24,-190,432);f.info:SetHeight(48)
        f.apply=app.createButton(f,24,-245,432,'',function()
            if app.productionEnabled()then
                if app.startProduction(app.selectedProductionRecipe(),tonumber(f.quantity:GetText()))then app.showCentralGuide()
                else f.info:SetText(app.caption('production_locked'))end
            elseif app.setPlanningGoal('next')then app.showCentralGuide()end
        end);app.styleButton(f.apply,'check',false);f.apply.fixedRole=true
    end
    local f=app.skillOrderView;local j=app.productionJob()
    f.quantity:SetText(tostring(j and math.max(1,j.remaining)or 1))
    app.renderSkillOrder();mount(f,'skill')
end
function app.renderSkillOrder()
    local f=app.skillOrderView;if not f then return end
    local production=app.productionEnabled()
    f.title:SetText(app.caption(production and 'production_title'or 'auto_skill_title'))
    f.mode:SetText(app.caption(production and 'production_choose'or 'auto_skill_title'))
    if production then
        f.quantity:Show()
        local r=app.selectedProductionRecipe();local n=tonumber(f.quantity:GetText())
        f.recipeName:SetText(r and app.recipeName(r)or app.caption('production_missing'))
        f.info:SetText(app.caption('production_help'));f.apply:SetText(app.caption('production_apply'))
        if r and r.learned and n and n>=1 and n<=10000 and n==math.floor(n)then f.apply:Enable()else f.apply:Disable()end
    else
        f.quantity:Hide();f.recipeName:SetText(app.routeSummary())
        f.info:SetText(app.caption('auto_skill_help'));f.apply:SetText(app.caption('ui_apply'));f.apply:Enable()
    end
end
local oldOptions=app.showOptions
function app.showUnifiedGeneral()
    oldOptions();local f=app.optionsWindow
    f.center:SetScript('OnClick',function()local g=root();g:ClearAllPoints();g:SetPoint('CENTER');app.options.guidePosition=nil end)
    mount(f,'settings')
end
function app.showOptions(tab)
    if not app.unifiedOptions then
        local f=app.createWindow('CraftDejaGuideOptions',480,370);app.unifiedOptions=f;f.tabs={};f.rows={};f.tab='settings'
        for i,key in ipairs({'settings','lookup','help'})do
            local tabKey=key;f.tabs[i]=app.createButton(f,24+(i-1)*146,-54,140,'',function()app.showOptions(tabKey)end)
            app.styleButton(f.tabs[i],({'gear','book','help'})[i],false);f.tabs[i].fixedRole=true
        end
        for i=1,5 do f.rows[i]=app.createButton(f,24,-99-(i-1)*40,432,'',function(self)if self.run then self.run()end end)end
        f.note=app.createLabel(f,10,24,-310,432);f.note:SetHeight(40)
    end
    local f=app.unifiedOptions;if type(tab)=='string'then f.tab=tab end
    app.renderUnifiedOptions();mount(f,'menu')
end
function app.renderUnifiedOptions()
    local f=app.unifiedOptions;if not f then return end
    f.title:SetText('CraftDeja - '..app.caption('ui_options'))
    for i,key in ipairs({'settings','lookup','help'})do f.tabs[i]:SetText(app.caption('ui_'..key))end
    local entries
    if f.tab=='lookup'then entries={
        {app.caption('ui_catalog'),'book',app.showCatalogue},
        {app.caption('ui_materials'),'bag',function()if app.isPoison()then if app.character.poisons.job then app.showPoisonMaterials()else app.showPoisonPlanner()end else app.showDetails(app.decision and app.decision.current.recipe,true)end end},
        {app.caption('ui_source'),'link',function()app.showDetails(app.decision and app.decision.current.recipe,false,true)end},
        {app.caption('ui_merchants'),'map',app.showMerchants},
        {app.caption('route_open'),'book',function()app.showRouteWindow()end}}
    elseif f.tab=='help'then entries={
        {app.caption('ui_tutorial'),'help',function()app.showGuide(true)end},
        {app.caption('ui_audit',app.auditCount()),'info',app.showRecipeAudit},
        {app.caption('ui_log'),'info',app.showFlowLog},
        {app.caption('ui_diagnostic'),'coin',app.showPurchaseDiagnostic},
        {app.caption('system_check'),'check',function()app.showSystemCheck()end}}
    else entries={
        {app.caption('ui_general'),'gear',app.showUnifiedGeneral},
        {app.caption('ui_limit',app.shopping.tolerance),'coin',function()app.shopping.tolerance=({[0]=5,[5]=10,[10]=20,[20]=0})[app.shopping.tolerance]or 0;app.options.shoppingTolerance=app.shopping.tolerance;app.renderUnifiedOptions()end},
        {app.caption('ui_alts',app.caption(app.options.inventoryAlts and 'enabled'or 'disabled')),'alts',function()app.options.inventoryAlts=not app.options.inventoryAlts;app.refresh(false);app.renderUnifiedOptions()end},
        {app.caption('ui_unlock'),'unlock',function()app.newPurchasePlan();app.renderUnifiedOptions()end},
        {app.caption('ui_center'),'center',function()local g=root();g:ClearAllPoints();g:SetPoint('CENTER');app.options.guidePosition=nil end}}
    end
    for i,b in ipairs(f.rows)do local e=entries[i];if e then b:SetText(e[1]);app.styleButton(b,e[2],false);b.fixedRole=true;b.run=e[3];b:Show()else b:Hide()end end
    f.note:SetText('CraftDeja '..app.release..'\n'..(app.actionNotice or app.caption('ui_resize')))
end
app.showGuide=function(visible)
    if visible==false then app.options.guideSeenV1=true;app.showCentralGuide();return end
    if not app.unifiedHelp then
        local f=app.createWindow('CraftDejaGuideHelp',550,450);app.unifiedHelp=f
        f.body=app.createLabel(f,12,24,-58,502);f.body:SetHeight(370)
    end
    local f=app.unifiedHelp;local lines={app.caption('guide_requirements')}
    for i=1,5 do lines[#lines+1]=i..'. '..app.caption('guide_step'..i..'_title')..'\n'..app.caption('guide_step'..i..'_body')end
    f.title:SetText(app.caption('ui_tutorial'));f.body:SetText(table.concat(lines,'\n\n'));app.options.guideSeenV1=true
    mount(f,'help')
end
local oldKeep=app.keepNextStepOnly
app.keepNextStepOnly=function()clearView();oldKeep()end
local oldRefresh=app.refreshUI
app.refreshUI=function()
    oldRefresh();hideMain()
    if app.unifiedViewKey=='menu'then app.renderUnifiedOptions()elseif app.unifiedViewKey=='skill'then app.renderSkillOrder()end
    if app.unifiedView then paintView()end
end
local oldScale=app.applyScale
app.applyScale=function(...)
    oldScale(...)
    for _,f in ipairs(app.themedWindows)do if f.unifiedHosted then f:SetScale(1)end end
    if root()then root():SetScale(app.options.windowScales and app.options.windowScales.CraftDejaNextStep or app.options.scale)end
end
local oldCommand=app.command
app.command=function(message)
    local action=(message or ''):match('^%s*(%S*)'):lower()
    if action==''then
        local f=root()
        if f and f:IsShown()then if f.onDismiss then f.onDismiss()end;f:Hide()else app.showCentralGuide()end
    elseif action=='help'or action=='guide'then app.showGuide(true)
    elseif action=='order'or action=='auftrag'then app.showCentralGuide()
    elseif action=='options'then app.showOptions()
    else oldCommand(message)end
end

local oldOpened=app.onProfessionOpened
app.onProfessionOpened=function(...)clearView();return oldOpened(...)end
local oldShoppingEvent=app.shoppingEvent
app.shoppingEvent=function(event,...)
    if event=='AUCTION_HOUSE_SHOW'then clearView()end
    return oldShoppingEvent(event,...)
end
for _,f in ipairs(app.themedWindows)do if f~=root()then f:Hide()end end
