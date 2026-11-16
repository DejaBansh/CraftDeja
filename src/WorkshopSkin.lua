-- SPDX-License-Identifier: MIT
local _,app=...
local words={de={workshop='Werkstattpult',ws_route='Route',ws_materials='Materialien',ws_settings='Einstellungen',ws_advanced='Auftrag & Angebote',ws_details='Details aufklappen',ws_less='Details einklappen',ws_next='JETZT ZU TUN',ws_selected='Ausgewählter Schritt',ws_missing='Offener Bedarf',ws_no_route='Öffne deinen Beruf und plane eine Levelroute.',ws_progress='Skill %d / %d',ws_cost='Kostenübersicht',ws_wait='Aktuelle Verarbeitung abwarten.',ws_guide='Kompakten Guide öffnen',ws_segment='Skill %d bis %d · %d Herstellungen',ws_source='Rezeptdetails und Quelle zeigen',ws_no_materials='Keine Materialliste verfügbar. Beruf oder Auftrag öffnen.',ws_no_price='Preis unbekannt',ws_estimate='Geschätzte Kosten · vor dem Kauf prüfen',ws_ready='Aktion bereit',ws_later='Rezeptwechsel',ws_bank='Bank',ws_qty='Taschen %s · Bedarf %s · Fehlen %s',ws_order='Bestehenden Auftrag fortsetzen',ws_price='Menge und Preis vor Kauf bestätigen.'},en={workshop='Workshop console',ws_route='Route',ws_materials='Materials',ws_settings='Settings',ws_advanced='Order & offers',ws_details='Expand details',ws_less='Collapse details',ws_next='DO THIS NEXT',ws_selected='Selected step',ws_missing='Outstanding supplies',ws_no_route='Open your profession and plan a leveling route.',ws_progress='Skill %d / %d',ws_cost='Cost overview',ws_wait='Wait for the current operation.',ws_guide='Open compact guide',ws_segment='Skill %d to %d · %d crafts',ws_source='Show recipe details and source',ws_no_materials='No material list available. Open a profession or order.',ws_no_price='Price unknown',ws_estimate='Estimated costs · check before buying',ws_ready='Action ready',ws_later='Recipe transitions',ws_bank='Bank',ws_qty='Bags %s · Required %s · Missing %s',ws_order='Continue current order',ws_price='Confirm quantity and price before buying.'}}
for lang,t in pairs(words)do for k,v in pairs(t)do app.words[lang][k]=v end end
local actions={de={ws_bank_visit='Bankbedarf anzeigen',ws_alt='Twink-Auftrag vorbereiten',ws_guild='Gildenauftrag abstimmen',ws_return='Auftragscharakter anzeigen',ws_replan='Route prüfen',ws_action_updated='Die nächste Aktion wurde aktualisiert. Bitte prüfe den neuen Button.'},en={ws_bank_visit='Show bank requirements',ws_alt='Prepare alt order',ws_guild='Review guild order',ws_return='Show order character',ws_replan='Review route',ws_action_updated='The next action changed. Please check the updated button.'}}
for lang,t in pairs(actions)do for k,v in pairs(t)do app.words[lang][k]=v end end
local function point(w,x,y)w:ClearAllPoints();w:SetPoint('TOPLEFT',x,-y)end
-- Nine slices preserve rounded corners instead of stretching rivets with a card.
function app.workshopCard(f)
    if f.workshopSlices then return end
    f.workshopSlices={}
    local cuts={0,.12,.88,1};local size=22
    for row=1,3 do for col=1,3 do
        local t=f:CreateTexture(nil,'BACKGROUND',nil,-6);t:SetTexture(app.uiPath('WorkshopCard'));t:SetTexCoord(cuts[col],cuts[col+1],cuts[row],cuts[row+1])
        local left=col==1 and 0 or size;local right=col==3 and 0 or size
        local top=row==1 and 0 or size;local bottom=row==3 and 0 or size
        if col==1 then t:SetPoint(row==3 and 'BOTTOMLEFT'or 'TOPLEFT',0,row==3 and 0 or -top);t:SetWidth(size)
        elseif col==3 then t:SetPoint(row==3 and 'BOTTOMRIGHT'or 'TOPRIGHT',0,row==3 and 0 or -top);t:SetWidth(size)
        else t:SetPoint(row==3 and 'BOTTOMLEFT'or 'TOPLEFT',left,row==3 and 0 or -top);t:SetPoint(row==3 and 'BOTTOMRIGHT'or 'TOPRIGHT',-right,row==3 and 0 or -top)end
        if row==2 then t:SetPoint(col==3 and 'BOTTOMRIGHT'or 'BOTTOMLEFT',col==3 and 0 or left,bottom)else t:SetHeight(size)end
        f.workshopSlices[#f.workshopSlices+1]=t
    end end
end
function app.workshopFit(f,w,h,desired)
    -- Keep physical text size stable across the game's UI Scale setting.
    local parentScale=app.try(UIParent.GetEffectiveScale,UIParent)or 1
    local saved=app.options.windowScales and f.scaleKey and app.options.windowScales[f.scaleKey]
    local wanted=saved or (desired or app.options.scale or .8)/.8*.9/parentScale
    local scale=math.min(wanted,(UIParent:GetWidth()-32)/w,(UIParent:GetHeight()-32)/h)
    f:SetScale(math.max(.35,scale))
end
local theme=app.applyProfessionTheme
app.applyProfessionTheme=function(f,profession)
    theme(f,profession)
    f:SetBackdrop(nil);if f.themeHeader then f.themeHeader:Hide()end
    if not f.unifiedHosted then app.workshopCard(f)end
    if f.workshopSlices then for _,t in ipairs(f.workshopSlices)do t:SetShown(not f.unifiedHosted)end end
end
local style=app.styleButton
app.styleButton=function(b,role,iconOnly)
    style(b,role,iconOnly)
    for _,kind in ipairs({'Normal','Pushed','Highlight','Disabled'})do
        app.try(b['Set'..kind..'Texture'],b,'Interface\\Buttons\\WHITE8X8')
        local t=app.try(b['Get'..kind..'Texture'],b)
        if t then
            local c=kind=='Highlight'and {.18,.45,.59,.5}or kind=='Pushed'and {.08,.28,.29,1}or kind=='Disabled'and {.06,.08,.12,.95}or {.055,.085,.14,.95}
            t:SetColorTexture(unpack(c))
        end
    end
    if b.label then b.label:SetTextColor(.88,.93,1);b.label:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',b:GetWidth()<170 and 11 or 12,'')end
    if b.icon then b.icon:SetDesaturated(true);b.icon:SetVertexColor(.65,.86,.95)end
end
local create=app.createButton
app.createButton=function(...)
    local b=create(...);local set=b.SetText
    b.SetText=function(self,text)set(self,text);app.styleButton(self,self.role,self.iconOnly)end
    app.styleButton(b,b.role,b.iconOnly);return b
end
local cta=app.styleCTAButton
app.styleCTAButton=function(b,primary)
    cta(b,primary)
    if primary then
        for _,kind in ipairs({'Normal','Pushed','Highlight','Disabled'})do
            b['Set'..kind..'Texture'](b,app.uiPath('WorkshopAction'))
            local t=b['Get'..kind..'Texture'](b)
            if t then t:SetDesaturated(not b:IsEnabled());t:SetVertexColor(unpack(kind=='Disabled'and {.34,.38,.45,1}or kind=='Pushed'and {.64,.85,.68,1}or kind=='Highlight'and {1,1,1,.5}or {.85,1,.92,1}))end
        end
        b:SetHeight(60);if b.label then b.label:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',15,'OUTLINE');b.label:SetWidth(b:GetWidth()-38);b.label:SetHeight(42);b.label:SetWordWrap(true)end
        if b.ctaBorder then b.ctaBorder:Hide()end
    end
end
function app.workshopReady(b,ready,key)
    if not b.workshopGlow then
        local t=b:CreateTexture(nil,'ARTWORK');b.workshopGlow=t;t:SetAllPoints();t:SetTexture(app.uiPath('WorkshopAction'));t:SetBlendMode('ADD');t:SetAlpha(0)
        local g=t:CreateAnimationGroup();b.readyAnimation=g
        local up=g:CreateAnimation('Alpha');up:SetFromAlpha(0);up:SetToAlpha(.38);up:SetDuration(.22);up:SetOrder(1)
        local down=g:CreateAnimation('Alpha');down:SetFromAlpha(.38);down:SetToAlpha(0);down:SetDuration(.65);down:SetOrder(2)
        g:SetScript('OnFinished',function()t:SetAlpha(0)end)
        b:HookScript('OnHide',function()g:Stop();t:SetAlpha(0)end)
    end
    local changed=ready and (not b.workshopReadyState or b.workshopActionKey~=key)
    b.workshopReadyState=ready;b.workshopActionKey=key
    if not ready then b.readyAnimation:Stop();b.workshopGlow:SetAlpha(0)
        for _,kind in ipairs({'Normal','Pushed','Highlight'})do local t=b['Get'..kind..'Texture'](b);if t then t:SetDesaturated(true);t:SetVertexColor(.42,.52,.63,1)end end
    elseif changed and b:IsVisible()then b.readyAnimation:Play();b.workshopPulses=(b.workshopPulses or 0)+1 end
end
local waiting={scan=true,loading=true,craft_queue=true,ah_scan=true,ah_wait=true,ah_load=true,cooldown=true,rod_wait=true,route_pending=true,route_wait=true}
function app.workshopActionReady(f)
    if not f or not f.task or not f.primaryCTA or not f.primaryCTA:IsEnabled()or waiting[f.task.kind]then return false end
    if f.task.kind=='tool'or f.task.kind=='station'or f.task.levelBlocked or f.task.key=='route_no_prices'or f.task.kind=='review'and app.problem=='no_prices'then return false end
    if (f.task.kind=='route_bank'or f.task.kind=='route_bank_withdraw')and app.character.bankTransfer then
        local s=app.character.bankTransfer
        if s.pending or s.status and s.status~='ready'and s.status~='done'then return false end
    end
    return true
end
function app.workshopActionIdentity(f)
    if not f or not f.task or not f.primaryCTA then return 'none'end
    local offer=f.task.offer or f.vendorOffer or f.vendorQuote or {}
    local p=f.plan or {}
    return table.concat({f.task.key,f.primaryCTA:GetText(),tostring(p.recipe and p.recipe.id),tostring(p.crafts),tostring(offer.quantity or offer.count),tostring(offer.cost),tostring(offer.price)},':')
end
function app.paintWorkshopGuide(f)
    if not f then return end
    if f.surface then f.surface:SetColorTexture(.014,.025,.045,.92)end
    if not f.workshopBadge then
        f.workshopBadge=f:CreateTexture(nil,'ARTWORK');f.workshopBadge:SetTexture(app.uiPath('WorkshopLogoFrame'));f.workshopBadge:SetSize(48,48);f.workshopBadge:SetPoint('TOPLEFT',8,-4)
        f.workshopOpen=app.createButton(f,0,0,36,'',function()app.showRouteWindow()end);f.workshopOpen.fixedRole=true;app.styleButton(f.workshopOpen,'book',true)
        f.workshopOpen.tipLines=function()return {app.caption('workshop')}end
        f.workshopStatus=app.createLabel(f,13,20,-190,380);f.workshopStatus:SetTextColor(.82,.9,.96)
        f.workshopExtra=app.createLabel(f,12,20,-260,380)
        f.workshopToggle=app.createButton(f,20,0,183,'',function()f.workshopExpanded=not f.workshopExpanded;app.paintWorkshopGuide(f)end)
        f.workshopToggle.fixedRole=true;app.styleButton(f.workshopToggle,'info',false)
    end
    f.workshopOpen:ClearAllPoints();f.workshopOpen:SetPoint('TOPRIGHT',-83,-12)
    if app.unifiedView then f.workshopStatus:Hide();f.workshopExtra:Hide();f.workshopToggle:Hide();if f.routeSkip then f.routeSkip:Hide()end;if f.bankLater then f.bankLater:Hide()end;return end
    f:SetWidth(420)
    if f.headerChrome then f.headerChrome.title:SetWidth(240);f.headerChrome.title:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',18,'');f.headerChrome.logo:SetSize(30,30);f.headerChrome.logo:ClearAllPoints();f.headerChrome.logo:SetPoint('TOPLEFT',17,-13)end
    f.body:SetWidth(380);f.body:SetHeight(46);f.body:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',20,'');point(f.body,20,65)
    local b=f.primaryCTA;if not b then return end
    local kind=f.task.kind
    if kind=='route_bank'or kind=='route_bank_withdraw'then if not app.inventoryState.bankOpen then b:SetText(app.caption('ws_bank_visit'))end
    elseif kind=='route_supply_alt'then b:SetText(app.caption('ws_alt'))
    elseif kind=='route_supply_guild'then b:SetText(app.caption('ws_guild'))
    elseif kind=='route_owner'then b:SetText(app.caption('ws_return'))
    elseif kind=='route_profession'then b:SetText(app.caption('cta_open'))
    elseif kind=='route_review'then b:SetText(app.caption('ws_replan'))end
    b:SetWidth(380);point(b,20,112);app.styleCTAButton(b,true)
    if f.task and (f.task.kind=='route_bank'or f.task.kind=='route_bank_withdraw')then f.body:SetText(b:GetText())end
    local status={}
    if f.task and f.task.body and f.task.body~=''then status[#status+1]=f.task.body end
    if app.actionNotice and app.actionNotice~=''then status[#status+1]=app.actionNotice end
    if not b:IsEnabled()and #status==0 then status[1]=app.caption('ws_wait')end
    local statusTop=182
    if f.task and f.task.requirement then
        f.requirementName:SetWidth(380);f.requirementName:SetHeight(22);f.requirementName:SetText(f.task.requirement.name or '?');point(f.requirementName,20,180);f.requirementName:Show();statusTop=206
    else f.requirementName:Hide()end
    local full=table.concat(status,'\n');local visible=full:gsub(', ','\n')
    f.workshopStatus:SetWidth(380);f.workshopStatus:SetWordWrap(true);f.workshopStatus:SetText(visible)
    local _,breaks=visible:gsub('\n','')
    local height=math.min(112,math.max(48,16*(breaks+1)+8,f.workshopStatus:GetStringHeight()+8));f.workshopStatus:SetHeight(height);point(f.workshopStatus,20,statusTop);f.workshopStatus:Show()
    f.workshopStatus:SetMaxLines(6);f.workshopStatus:EnableMouse(true);f.workshopStatus:SetScript('OnEnter',function(self)app.showTip(self,f.body:GetText(),{full})end);f.workshopStatus:SetScript('OnLeave',app.hideTip)
    f.ctaInfo:Show();f.notice:Hide()
    local y=statusTop+height+6
    if f.output:IsShown()then point(f.output,22,y);point(f.outputName,62,y);f.outputName:SetWidth(332);f.outputName:SetHeight(36);if f.outputCount:IsShown()then point(f.outputCount,62,y+35);f.outputCount:SetWidth(332);y=y+62 else y=y+44 end end
    if f.orderBar then f.orderBar:SetShown(f.workshopExpanded and f.plan~=nil);if f.orderBar:IsShown()then point(f.orderBar,48,y);y=y+f.orderBar:GetHeight()+12 end end
    if f.workshopExpanded then
        local lines={};for _,v in ipairs(f.ctaDetails or {})do if v and v~=''then lines[#lines+1]=v end end
        f.workshopExtra:SetText(table.concat(lines,'\n'));f.workshopExtra:SetWidth(380);f.workshopExtra:SetHeight(math.min(140,f.workshopExtra:GetStringHeight()+6));f.workshopExtra:SetMaxLines(9);point(f.workshopExtra,20,y);f.workshopExtra:Show();y=y+f.workshopExtra:GetHeight()+12
    else f.workshopExtra:Hide()end
    if f.routeSkip then
        local show=f.workshopExpanded and f.task.supply and f.task.supply.source=='guild'
        f.routeSkip:SetShown(show==true)
        if show then point(f.routeSkip,20,y);f.routeSkip:SetWidth(380);f.routeSkip.label:SetWidth(340);y=y+32 end
    end
    if f.bankLater then
        local show=f.workshopExpanded and f.task.kind=='route_bank'
        f.bankLater:SetShown(show)
        if show then point(f.bankLater,20,y);f.bankLater:SetWidth(380);f.bankLater.label:SetWidth(340);y=y+32 end
    end
    if f.secondaryCTA then point(f.secondaryCTA,20,y);f.secondaryCTA:SetWidth(183);f.secondaryCTA.label:SetWidth(143);app.styleCTAButton(f.secondaryCTA,false);y=y+32 end
    point(f.workshopToggle,20,y);f.workshopToggle:SetText(app.caption(f.workshopExpanded and 'ws_less'or 'ws_details'));f.workshopToggle:Show()
    point(f.changeOrder,217,y);f.changeOrder:SetWidth(183);f.changeOrder.label:SetWidth(143)
    f:SetHeight(y+48);app.workshopFit(f,420,f:GetHeight(),app.options.windowScales and app.options.windowScales.CraftDejaNextStep or app.options.scale)
    app.workshopReady(b,app.workshopActionReady(f),app.workshopActionIdentity(f))
end
local render=app.renderNextStep
app.renderNextStep=function(...)
    render(...);app.paintWorkshopGuide(app.nextStepWindow)
    if app.renderWorkshopDashboard then app.renderWorkshopDashboard()end
end
