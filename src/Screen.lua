-- SPDX-License-Identifier: MIT
local _,app=...
local gold={0.87,0.73,0.39};local violet={0.46,0.28,0.61}
local colours={orange='|cffffa449',yellow='|cffffe05e',green='|cff69da85',grey='|cffaaaaaa'}
local function text(parent,size,x,y,width,colour)
    local f=parent:CreateFontString(nil,'OVERLAY')
    f:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',size,'')
    f:SetPoint('TOPLEFT',x,y);f:SetWidth(width);f:SetJustifyH('LEFT');f:SetJustifyV('TOP');f:SetWordWrap(true)
    f:SetTextColor(unpack(colour or {0.9,0.87,0.94}));return f
end
local function button(parent,x,y,w,label,click)
    return app.createButton(parent,x,y,w,label,click)
end
local function panel(parent,x,y,w,h)
    local p=CreateFrame('Frame',nil,parent,'BackdropTemplate');p:SetSize(w,h);p:SetPoint('TOPLEFT',x,y)
    p:SetBackdrop({bgFile=app.uiPath('Card')});p:SetBackdropColor(1,1,1,.87);return p
end
local function window(name,width,height)
    local f=CreateFrame('Frame',name,UIParent,'BackdropTemplate');f:SetSize(width,height);f:SetPoint('CENTER');f:SetClampedToScreen(true)
    f:SetMovable(true);f:EnableMouse(true);f:RegisterForDrag('LeftButton');f:SetFrameStrata('DIALOG')
    f:SetScript('OnDragStart',f.StartMoving);f:SetScript('OnDragStop',function(self)
        self:StopMovingOrSizing();if name=='CraftDejaWindow'then local p,_,r,x,y=self:GetPoint();app.options.position={p,r,x,y}end
    end)
    f:SetBackdrop({bgFile=app.uiPath('Window')});f:SetBackdropColor(1,1,1,1)
    local logo=f:CreateTexture(nil,'ARTWORK');f.logo=logo;logo:SetSize(34,34);logo:SetPoint('TOPLEFT',14,-10);logo:SetTexture(app.uiPath('Logo'))
    f.title=text(f,20,57,-16,width-103,gold)
    f.close=button(f,width-35,-9,26,'×',function()f:Hide();if f==app.main then app.options.visible=false end;if f.onDismiss then f.onDismiss()end end)
    f.scaleKey=name;f:SetScale(app.options.windowScales and app.options.windowScales[name]or app.options.scale);app.addScaleGrip(f,name);app.registerThemedWindow(f);f:Hide();return f
end
app.createWindow=window;app.createLabel=text
function app.keepNextStepOnly()
    app.options.visible=false;app.guideOnly=true
    -- Every CraftDeja window is registered here, including future popups.
    -- The guide is a separate top-level frame and survives hidden advisers.
    for _,f in ipairs(app.themedWindows)do if f~=app.nextStepWindow then f:Hide()end end
    if app.vendorPurchase and app.vendorPurchase.open then app.vendorPurchase.dismissed=true end
    app.poisonMerchantRetries=0;app.poisonMerchantShownEpoch=app.poisonMerchantEpoch
    app.flowLog('ui.guide_only',{profession=app.active and app.active.profile.id or 0})
    app.refreshNextStep(true)
end
local function priceLine(candidate)
    return app.caption('per_point',app.money(candidate.quote.cost),candidate.estimated and app.caption('approx')or '',app.money(candidate.unitSkill),candidate.quote.provider)
end
function app.applyScale(value,resetWindows)
    if resetWindows then app.options.windowScales={}end
    app.options.scale=math.max(0.5,math.min(1.4,tonumber(value)or 0.8))
    for _,f in pairs({app.main,app.catalogWindow,app.detailsWindow,app.optionsWindow,app.shoppingWindow,app.merchantWindow,app.vendorBuyWindow,app.nextStepWindow,app.purchaseDiagnostic,app.flowLogWindow,app.recipeAuditWindow,app.poisonWindow,app.poisonMaterialsWindow,app.poisonMerchantWindow})do if f then f:SetScale(app.options.windowScales and app.options.windowScales[f.scaleKey]or app.options.scale)end end
    if app.main then app.main.scale:SetText(math.floor((app.options.windowScales and app.options.windowScales.CraftDejaWindow or app.options.scale)*100+0.5)..'%')end
end
function app.ensureMain()
    if app.main then return app.main end
    local f=window('CraftDejaWindow',550,493);app.main=f
    f.title:SetText('CraftDeja')
    f.profile=text(f,12,18,-44,500,gold)
    f.help=button(f,404,-15,95,'',function()app.showGuide(not f.guideVisible)end)
    f.dataButton=button(f,285,-15,109,'',function()app.showRecipeAudit()end)
    app.styleButton(f.dataButton,'info',false)
    f.dataButton.tipLines=function()return {app.caption('audit_package',app.referenceData.packaged),app.caption('audit_tip'),app.caption('audit_review',app.referenceData.reviewDays)}end
    f.profile:SetHeight(14)
    f.dataStatus=text(f,9,18,-59,500);f.dataStatus:SetHeight(10)
    f.adviser=CreateFrame('Frame',nil,f);f.adviser:SetAllPoints()
    local current=panel(f.adviser,32,-80,486,114);f.currentPanel=current
    f.currentDetails=button(current,356,-6,116,'',function()if app.decision then app.showDetails(app.decision.current.recipe,false,true)end end)
    f.now=text(current,11,12,-10,330,gold);f.recipe=text(current,16,12,-31,462,{1,0.9,0.35});f.recipe:SetHeight(36)
    f.info=text(current,11,12,-72,462);f.info:SetHeight(15);f.price=text(current,11,12,-94,462,gold);f.price:SetHeight(16)
    local nextPanel=panel(f.adviser,32,-206,486,94)
    f.nextDetails=button(nextPanel,356,-6,116,'',function()app.showDetails(app.nextRecipe(),false,true)end)
    f.nextTitle=text(nextPanel,11,12,-10,330,gold);f.nextRecipe=text(nextPanel,14,12,-30,462);f.nextRecipe:SetHeight(32)
    f.nextInfo=text(nextPanel,11,12,-70,462);f.nextInfo:SetHeight(15)
    local ranges=panel(f.adviser,32,-312,486,104)
    f.ranges=text(ranges,11,12,-10,462);f.stage=text(ranges,11,12,-42,462,gold);f.note=text(ranges,10,12,-62,462);f.note:SetHeight(36)
    f.recipes=button(f,16,-444,87,'',function()app.showCatalogue()end)
    f.materials=button(f,109,-444,87,'',function()if app.isPoison()then app.showPoisonMaterials()else app.showDetails(app.decision and app.decision.current.recipe,true)end end)
    f.settings=button(f,202,-444,87,'',function()app.showOptions()end)
    f.shopping=button(f,295,-444,99,'',function()app.requestShopping()end)
    button(f,404,-444,25,'−',function()app.applyScale(app.options.scale-0.05,true)end)
    f.scale=text(f,11,434,-451,45,gold)
    button(f,500,-444,25,'+',function()app.applyScale(app.options.scale+0.05,true)end)
    f.guide=panel(f,16,-69,518,364)
    f.guide.requirements=text(f.guide,11,12,-10,490,gold);f.guide.requirements:SetHeight(40)
    f.guide.steps={}
    for i=1,5 do
        local y=-60-(i-1)*53
        local step={}
        step.number=text(f.guide,18,12,y,28,gold);step.number:SetText(tostring(i))
        step.title=text(f.guide,12,43,y,447,gold)
        step.body=text(f.guide,11,43,y-18,447);step.body:SetHeight(32)
        f.guide.steps[i]=step
    end
    f.guide.note=text(f.guide,10,12,-331,490);f.guide.note:SetHeight(25)
    f.guide.start=button(f,16,-444,378,'',function()app.showGuide(false)end)
    f.guideVisible=not app.options.guideSeenV1
    if app.options.position then local p=app.options.position;f:ClearAllPoints();f:SetPoint(p[1],UIParent,p[2],p[3],p[4])end
    app.applyScale(app.options.scale);return f
end
function app.renderMain()
    app.refreshProfessionThemes()
    local f=app.ensureMain();local plan=app.decision;local profile=app.active and app.active.profile
    local reports=app.auditCount()
    f.dataButton:SetText(reports>0 and app.caption('audit_reports_button',reports)or app.caption('audit_button'))
    f.dataStatus:SetText(app.auditStatusText())
    f.help:SetText(app.caption(f.guideVisible and 'guide_back'or 'guide_button'))
    for _,child in ipairs({f.adviser,f.recipes,f.materials,f.settings,f.shopping})do
        if f.guideVisible then child:Hide()else child:Show()end
    end
    if f.guideVisible then
        f.guide:Show();f.guide.start:Show();app.renderGuide()
    else f.guide:Hide();f.guide.start:Hide()end
    f.recipes:SetText(app.caption('recipes'));f.materials:SetText(app.caption('materials'));f.settings:SetText(app.caption('settings'));f.shopping:SetText(app.caption('shop_button'))
    f.profile:SetText(profile and (app.professionName(profile.id)..' · '..app.caption('skill',profile.skill,profile.cap)..' · '..app.caption('faction_'..(app.playerFaction()or 'Unknown')))or app.caption('open'))
    if profile and not app.professionOpen then f.profile:SetText(f.profile:GetText()..' · '..app.caption('session_cached'))end
    if app.professionLoading then f.profile:SetText(app.caption('profession_loading'))end
    if f.guideVisible then f.profile:SetText(app.caption('guide_intro'))end
    f.currentDetails:SetText(app.caption('current_link'));f.nextDetails:SetText(app.caption('next_link'))
    f.currentDetails:Hide();f.nextDetails:Hide()
    f.now:SetText(app.caption(plan and plan.current.needsLearning and 'learn_first'or 'now'))
    f.recipe:SetText(plan and app.recipeName(plan.current.recipe)or app.caption(app.problem or 'open'))
    f.info:SetText('');f.price:SetText('');f.nextTitle:SetText(app.caption('next'));f.nextRecipe:SetText('');f.nextInfo:SetText('');f.ranges:SetText('');f.stage:SetText('')
    local shoppingStatus=app.shoppingStatusText and app.shoppingStatusText()
    f.note:SetText(shoppingStatus or (app.caption('refresh_note')..'\n'..app.caption('chance_note')))
    f.shopping:Enable()
    if app.shopping.open and not app.shoppingFresh()then
        f.shopping:Disable();f.recipe:SetText(app.caption('scan_locked_title'));f.info:SetText(app.scanWaitText());return
    end
    if not plan then
        if app.problem=='rank_full'and app.rankTrainerTask then
            local task=app.rankTrainerTask()
            if task.levelBlocked then
                local t=task.trainer
                f.recipe:SetText(app.caption('trainer_level_title',task.requiredLevel))
                f.info:SetText(app.caption('trainer_level_after',app.professionName(profile.id),t.fromCap,t.toCap,task.requiredLevel))
                f.price:SetText(app.caption('trainer_level_current',app.playerLevel()));f.note:SetText(app.caption('trainer_level_wait'))
            end
        end
        return
    end
    f.currentDetails:Show()
    local now=plan.current;local recipe=now.recipe
    f.info:SetText(app.caption('source_chance',app.origin(recipe),(colours[now.colour]or '')..app.caption(now.colour)..'|r',now.estimated and app.caption('approx')or '',math.floor(now.chance*100+0.5)))
    f.price:SetText(priceLine(now));f.ranges:SetText(app.rangeText(recipe))
    local material=app.materialPlan(recipe,plan.stop)
    f.stage:SetText(material and app.caption('stage',material.target,material.estimated and app.caption('approx')or '',material.crafts)or '')
    local extra=recipe.rangeConflict and app.caption('conflict')or (now.greenExtra and app.caption('green_saving',math.min(recipe.green+5,recipe.grey))or nil)
    local status=(plan.unchecked or 0)>0 and app.caption('source_unverified_n',plan.unchecked)or plan.missing>0 and app.caption('price_missing_n',plan.missing)or extra or app.caption('refresh_note')
    f.note:SetText(shoppingStatus or (status..'\n'..app.caption('chance_note')))
    if plan.followup and plan.followup.candidate and plan.followup.candidate.recipe.id~=recipe.id then
        f.nextDetails:Show()
        local after=plan.followup.candidate
        f.nextTitle:SetText(app.caption(after.needsLearning and 'next_learn'or 'next'))
        f.nextRecipe:SetText(app.recipeName(after.recipe))
        f.nextInfo:SetText(app.caption('next_at',plan.followup.level,app.origin(after.recipe),after.estimated and app.caption('approx')or '',app.money(after.unitSkill)))
    else f.nextRecipe:SetText(app.caption('next_check',plan.stop))end
end

function app.renderGuide()
    local f=app.main;if not f then return end
    f.guide.requirements:SetText(app.caption('guide_requirements'))
    for i,step in ipairs(f.guide.steps)do
        step.title:SetText(app.caption('guide_step'..i..'_title'))
        step.body:SetText(app.caption('guide_step'..i..'_body'))
    end
    f.guide.note:SetText(app.caption('guide_note'));f.guide.start:SetText(app.caption('guide_start'))
end
function app.showGuide(visible)
    app.guideOnly=nil
    local f=app.ensureMain()
    f.guideVisible=visible~=false
    if not f.guideVisible then app.options.guideSeenV1=true end
    app.options.visible=true;app.renderMain();f:Show()
end

function app.showCatalogue()
    if not app.catalogWindow then
        local f=window('CraftDejaCatalogue',710,589);app.catalogWindow=f;f.page=1;f.profession=app.active and app.active.profile.id or 333;f.factionOnly=true
        f.profButton=button(f,18,-48,315,'',function()
            local nextIndex=1;for i,id in ipairs(app.professionOrder)do if id==f.profession then nextIndex=i%#app.professionOrder+1 end end
            f.profession=app.professionOrder[nextIndex];f.page=1;app.renderCatalogue()
        end)
        f.faction=button(f,345,-48,168,'',function()f.factionOnly=not f.factionOnly;f.page=1;app.renderCatalogue()end)
        f.useful=button(f,523,-48,168,'',function()f.onlyUseful=not f.onlyUseful;f.page=1;app.renderCatalogue()end)
        f.search=CreateFrame('EditBox',nil,f,'InputBoxTemplate');f.search:SetSize(660,25);f.search:SetPoint('TOPLEFT',23,-83);f.search:SetAutoFocus(false)
        f.search:SetScript('OnTextChanged',function()f.page=1;app.renderCatalogue()end)
        f.search:SetScript('OnEscapePressed',function(self)self:ClearFocus()end)
        f.rows={}
        for i=1,8 do
            local row=CreateFrame('Button',nil,f);row:SetSize(674,47);row:SetPoint('TOPLEFT',18,-123-(i-1)*49)
            local highlight=row:CreateTexture(nil,'HIGHLIGHT');highlight:SetAllPoints();highlight:SetColorTexture(0.45,0.26,0.65,0.3)
            row.name=text(row,12,6,-4,660,gold);row.info=text(row,10,6,-24,660)
            row:SetScript('OnClick',function(self)app.showDetails(self.recipe,false)end);f.rows[i]=row
        end
        f.pageText=text(f,11,250,-529,240)
        f.previous=button(f,18,-521,130,'',function()f.page=math.max(1,f.page-1);app.renderCatalogue()end)
        f.forward=button(f,560,-521,130,'',function()f.page=f.page+1;app.renderCatalogue()end)
        f.hint=text(f,10,18,-559,674)
    end
    app.renderCatalogue();app.catalogWindow:Show()
end
function app.renderCatalogue()
    local f=app.catalogWindow;if not f then return end
    app.applyProfessionTheme(f,f.profession)
    f.title:SetText(app.caption('catalog_title'));f.profButton:SetText(app.professionName(f.profession)..'  ›')
    f.useful:SetText((f.onlyUseful and '✓ 'or '')..app.caption('only_useful'))
    f.faction:SetText(app.caption(f.factionOnly and 'own_faction'or 'all_factions'))
    f.previous:SetText(app.caption('previous'));f.forward:SetText(app.caption('forward'));f.hint:SetText(app.caption('scroll_hint'))
    local session=app.sessions[f.profession];local records=session and session.recipes or {};local list={}
    local query=string.lower(f.search:GetText()or '')
    for id in pairs(app.catalog[f.profession]or {})do
        local r=records[id]or app.referenceRecipe(f.profession,id)
        local name=app.recipeName(r);local origin=app.origin(r)
        local matches=query==''or string.find(string.lower(name..' '..origin..' '..app.accessLabel(r)..' '..id),query,1,true)
        local useful=not f.onlyUseful or (session and r.skill and r.skill<=session.profile.skill and (not r.grey or r.grey>session.profile.skill))
        local data=app.accessInfo(r);local faction=app.playerFaction()
        local factionOK=not f.factionOnly or r.learned or ((not data.use or data.use=='Both'or data.use==faction)and (data.access=='Both'or data.access=='Unknown'or data.access==faction))
        if matches and useful and factionOK then list[#list+1]=r end
    end
    -- Include live-only recipes as well as the shipped catalogue.
    for id,r in pairs(records)do
        if not app.catalog[f.profession][id]then
            local name=app.recipeName(r)
            local data=app.accessInfo(r);local faction=app.playerFaction()
            local matches=query==''or string.find(string.lower(name..' '..app.origin(r)..' '..app.accessLabel(r)..' '..id),query,1,true)
            local useful=not f.onlyUseful or (session and (r.skill==nil or r.skill<=session.profile.skill)and r.colour~='grey')
            local own=not f.factionOnly or r.learned or ((not data.use or data.use=='Both'or data.use==faction)and (data.access=='Both'or data.access=='Unknown'or data.access==faction))
            if matches and useful and own then list[#list+1]=r end
        end
    end
    table.sort(list,function(a,b)if(a.skill or 9999)~=(b.skill or 9999)then return(a.skill or 9999)<(b.skill or 9999)end;return a.id<b.id end)
    f.page=math.max(1,math.min(f.page,math.max(1,math.ceil(#list/8))))
    local first=(f.page-1)*8+1
    for i,row in ipairs(f.rows)do
        local r=list[first+i-1];row.recipe=r
        if r then
            row:Show();row.name:SetText(app.recipeName(r)..'  |cffaaaaaa#'..r.id..'|r')
            local state=not r.confirmed and 'unchecked'or (r.learned and 'known'or 'learn')
            row.info:SetText(app.caption(state)..' · '..app.origin(r)..' · '..(r.skill or '?')..' → '..(r.grey or '?')..' · '..app.accessLabel(r))
        else row:Hide()end
    end
    f.pageText:SetText(app.caption('count',#list>0 and first or 0,math.min(first+7,#list),#list))
end

function app.showDetails(recipe,materials,linkOnly)
    if not recipe then return end
    if not app.detailsWindow then
        local f=window('CraftDejaDetails',680,650);app.detailsWindow=f
        f.name=text(f,15,18,-49,640,gold);f.name:SetHeight(42)
        f.url=CreateFrame('EditBox',nil,f,'InputBoxTemplate');f.url:SetSize(624,24);f.url:SetPoint('TOPLEFT',23,-98);f.url:SetAutoFocus(false);f.url:SetScript('OnEscapePressed',function(self)self:ClearFocus()end)
        local function selectURL(value)f.url:SetText(value);f.url:SetFocus();f.url:HighlightText()end
        f.recipePage=button(f,18,-132,199,'',function()selectURL(app.recipeURL(f.recipe))end)
        f.craftPage=button(f,229,-132,199,'',function()selectURL(app.url(f.recipe.id))end)
        f.sourcePage=button(f,440,-132,219,'',function()
            local list=app.sourceList(f.recipe)
            if #list==0 then return end
            f.sourceIndex=(f.sourceIndex or 0)%#list+1
            local source=list[f.sourceIndex]
            selectURL(app.sourceURL(source));f.sourcePage:SetText(app.caption('source_page',f.sourceIndex,#list))
            f.sourceName:SetText(app.sourceTitle(source)..' · '..app.caption('faction_'..(source.side or 'Unknown'))..' · '..app.sourcePlace(source))
        end)
        f.sourceName=text(f,10,18,-164,640);f.sourceName:SetHeight(17)
        f.targetLabel=text(f,11,18,-200,145)
        f.target=CreateFrame('EditBox',nil,f,'InputBoxTemplate');f.target:SetSize(63,25);f.target:SetPoint('TOPLEFT',151,-193);f.target:SetAutoFocus(false);f.target:SetNumeric(true)
        f.calculate=button(f,231,-193,132,'',function()app.renderDetails(true)end)
        f.scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');f.scroll:SetPoint('TOPLEFT',18,-233);f.scroll:SetSize(617,390)
        f.child=CreateFrame('Frame',nil,f.scroll);f.child:SetSize(607,375);f.scroll:SetScrollChild(f.child)
        f.body=text(f.child,12,0,0,603)
    end
    local f=app.detailsWindow;f.recipe=recipe;f.materials=materials;f.sourceIndex=0;f.shownRecipeID=nil
    local target=app.decision and app.decision.current.recipe.id==recipe.id and app.decision.stop or recipe.green
    f.target:SetText(tostring(target or ((app.active and app.active.profile.skill or 0)+1)))
    app.renderDetails(materials);f:Show()
    if linkOnly then f.url:SetFocus();f.url:HighlightText()end
end
function app.renderDetails(materials)
    local f=app.detailsWindow;if not f or not f.recipe then return end
    local r=f.recipe
    if app.active and app.active.profile.id==r.profession then r=app.active.recipes[r.id]or r;f.recipe=r end
    f.title:SetText(app.caption(materials and 'materials'or 'detail'));f.name:SetText(app.recipeName(r));f.recipePage:SetText(app.caption('recipe_page'));f.craftPage:SetText(app.caption('craft_page'))
    if f.shownRecipeID~=r.id or f.shownLanguage~=app.lang()then
        f.url:SetText(app.recipeURL(r));f.shownRecipeID=r.id;f.shownLanguage=app.lang();f.sourceIndex=0
        local routes=app.sourceList(r)
        f.sourcePage:SetText(#routes>0 and app.caption('source_page',1,#routes)or app.caption('source_none'))
        f.sourceName:SetText(app.caption('source_links_hint'))
    end
    f.targetLabel:SetText(app.caption('target'));f.calculate:SetText(app.caption('calculate'))
    local lines={app.caption('source')..': '..app.origin(r),app.rangeText(r),app.caption('basis',app.caption(r.observed and 'observed'or (r.rangeVerified and 'verified'or 'reference')))}
    lines[#lines+1]=app.accessLabel(r)
    local allowed,reason=app.canRecommend(r)
    if not allowed then lines[#lines+1]=app.caption(reason)end
    local routes=app.sourceList(r)
    for _,source in ipairs(routes)do
        local kind=source.kind=='object'and 'container'or source.kind
        lines[#lines+1]=app.caption('source_route',app.caption('origin_'..kind),app.sourceTitle(source),app.caption('faction_'..(source.side or 'Unknown')))
        local place=app.sourcePlace(source);if place~=''then lines[#lines+1]=place end
    end
    if #routes>0 then lines[#lines+1]=app.caption('source_count',#routes)end
    if r.referenceHidden and not r.learned then lines[#lines+1]=app.caption('hidden_reference')end
    if r.example then lines[#lines+1]=app.caption('example_source')..': '..r.example end
    if not r.confirmed then lines[#lines+1]=app.caption('unchecked')end
    if r.cooldown then lines[#lines+1]=app.caption('cooldown')end
    local plan,reason=app.materialPlan(r,tonumber(f.target:GetText()))
    lines[#lines+1]=''
    if plan then
        lines[#lines+1]=app.caption('plan_summary',plan.from,plan.target,plan.estimated and app.caption('approx')or '',plan.crafts)
        if plan.capped then lines[#lines+1]=app.caption('plan_capped')end
        for _,row in ipairs(plan.rows)do
            lines[#lines+1]=app.caption('ingredient',row.name,row.total,row.owned and tostring(row.owned)or '?',row.buy)
        end
        lines[#lines+1]='';lines[#lines+1]=app.caption('plan_note',app.money(plan.purchase))
    else
        lines[#lines+1]=app.caption(reason or 'no_prices')
        for _,g in ipairs(r.groups or {})do
            local names={};for _,id in ipairs(g.choices)do names[#names+1]=app.itemName(id)end
            lines[#lines+1]=g.amount..' × '..table.concat(names,' / ')
        end
    end
    lines[#lines+1]='';lines[#lines+1]=app.caption('model_note');lines[#lines+1]=app.caption('chance_note');lines[#lines+1]=app.caption('source_note');lines[#lines+1]=app.caption('vendor_note');lines[#lines+1]=app.caption('needs_tools');lines[#lines+1]=app.caption('cross_faction_note')
    f.body:SetText(table.concat(lines,'\n\n'));f.body:SetHeight(f.body:GetStringHeight()+10);f.child:SetHeight(math.max(375,f.body:GetStringHeight()+15))
end
function app.showOptions()
    if not app.optionsWindow then
        local f=window('CraftDejaOptions',550,390);app.optionsWindow=f
        f.language=button(f,18,-60,514,'',function()
            local nextLanguage={auto='de',de='en',en='auto'};app.options.language=nextLanguage[app.options.language]or 'auto';app.refreshUI()
        end)
        f.prices=button(f,18,-101,514,'',function()
            local nextProvider={auto='auctionator',auctionator='tsm',tsm='auto'};app.options.prices=nextProvider[app.options.prices]or 'auto';app.refresh()
        end)
        f.green=button(f,18,-142,514,'',function()app.options.green=not app.options.green;app.refresh()end)
        f.unverified=button(f,18,-183,514,'',function()app.options.unverifiedSources=not app.options.unverifiedSources;app.refresh()end)
        f.scan=button(f,18,-224,250,'',function()app.refresh(true)end)
        f.center=button(f,281,-224,250,'',function()app.main:ClearAllPoints();app.main:SetPoint('CENTER');app.options.position=nil end)
        f.help=text(f,11,18,-271,512)
    end
    app.renderOptions();app.optionsWindow:Show()
end
function app.renderOptions()
    local f=app.optionsWindow;if not f then return end
    f.title:SetText(app.caption('options_title'))
    f.language:SetText(app.caption('language')..': '..(app.options.language=='auto'and app.caption('language_auto')or app.options.language=='de'and 'Deutsch'or 'English'))
    f.prices:SetText(app.caption('prices')..': '..(app.options.prices=='auto'and app.caption('auto')or app.options.prices))
    f.green:SetText(app.caption('green_toggle')..': '..app.caption(app.options.green and 'enabled'or 'disabled'))
    f.unverified:SetText(app.caption('unknown_toggle')..': '..app.caption(app.options.unverifiedSources and 'enabled'or 'disabled'))
    f.scan:SetText(app.caption('reload'));f.center:SetText(app.caption('reset_position'));f.help:SetText(app.caption('help'))
end
function app.refreshUI()
    app.renderMain();app.renderCatalogue();app.renderOptions();if app.refreshNextStep then app.refreshNextStep()end
    if app.detailsWindow and app.detailsWindow:IsShown()then app.renderDetails(app.detailsWindow.materials)end
    if app.shoppingWindow and app.shoppingWindow:IsShown()then app.renderShopping()end
end

function app.showShopping()
    if not app.shoppingFresh()then return end
    app.guideOnly=nil
    if not app.shoppingWindow then
        local f=window('CraftDejaShopping',500,395);app.shoppingWindow=f;f.page=1
        f.subtitle=text(f,10,18,-48,464,gold)
        local target=panel(f,14,-70,472,63)
        f.goal=text(target,12,12,-8,275,gold)
        f.goalMode=button(target,294,-4,166,'',function()app.setPlanningGoal(app.shopping.goal=='next'and 'manual'or 'next')end)
        f.slider=CreateFrame('Slider',nil,target)
        f.slider:SetSize(342,24);f.slider:SetPoint('TOPLEFT',65,-26)
        f.slider.track=f.slider:CreateTexture(nil,'BACKGROUND');f.slider.track:SetSize(342,8);f.slider.track:SetPoint('CENTER');f.slider.track:SetTexture(app.uiPath('SliderTrack'))
        f.slider.thumb=f.slider:CreateTexture(nil,'OVERLAY',nil,7);f.slider.thumb:SetSize(20,24);f.slider.thumb:SetTexture(app.uiPath('SliderThumb'));f.slider:SetThumbTexture(f.slider.thumb)
        f.slider.Low=text(target,12,10,-31,32,gold);f.slider.Low:SetJustifyH('CENTER')
        f.slider.High=text(target,12,430,-31,32,gold);f.slider.High:SetJustifyH('CENTER')
        for _,x in ipairs({8,428})do local border=target:CreateTexture(nil,'BACKGROUND');border:SetSize(36,26);border:SetPoint('TOPLEFT',x,-25);border:SetTexture(app.uiPath('SliderNumber'))end
        f.slider:SetOrientation('HORIZONTAL');f.slider:SetMinMaxValues(1,50);f.slider:SetValueStep(1);f.slider:SetObeyStepOnDrag(true)
        if f.slider.Low then f.slider.Low:SetText('1')end;if f.slider.High then f.slider.High:SetText('50')end
        f.slider:SetScript('OnValueChanged',function(_,value)
            if f.syncSlider then return end
            if not app.setPlanningGoal('manual',value)then app.renderShopping()end
        end)
        
        
        f.bound=text(f,10,0,0,464);f.bound:Hide()
        f.recipe=text(f,14,18,-143,464,gold);f.recipe:SetHeight(29)
        f.summary=text(f,10,18,-175,464);f.summary:SetHeight(28)
        f.cards={}
        for i=1,7 do
            local card=button(f,18+(i-1)*66,-211,62,'',function()end);card:SetSize(62,72)
            card.itemIcon=true;card.iconOnly=true;card.label:Hide()
            card.icon:ClearAllPoints();card.icon:SetSize(42,42);card.icon:SetPoint('TOP',0,-6)
            card.count=text(card,10,2,-52,58);card.count:SetJustifyH('CENTER')
            card.dot=card:CreateTexture(nil,'OVERLAY');card.dot:SetSize(10,10);card.dot:SetPoint('TOPRIGHT',-5,-39)
            card:SetScript('OnEnter',function(self)
                if self.row then app.showTip(self,self.row.name,app.shoppingItemLines(self.row))end
            end);f.cards[i]=card
        end
        f.previous=button(f,18,-285,28,'<',function()f.page=math.max(1,f.page-1);app.renderShopping()end)
        f.pageText=text(f,10,53,-294,130)
        f.forward=button(f,184,-285,28,'>',function()f.page=f.page+1;app.renderShopping()end)
        f.alts=button(f,18,-321,42,'',function()app.options.inventoryAlts=not app.options.inventoryAlts;app.renderShopping()end)
        f.vendors=button(f,68,-321,42,'',function()app.showMerchants()end)
        f.priceLimit=button(f,118,-321,42,'',function()
            local nextValue={[0]=5,[5]=10,[10]=20,[20]=0};app.shopping.tolerance=nextValue[app.shopping.tolerance]or 0;app.options.shoppingTolerance=app.shopping.tolerance;app.renderShopping()
        end)
        f.unlock=button(f,168,-321,42,'',function()app.newPurchasePlan();app.renderShopping()end)
        f.info=button(f,218,-321,42,'',function()if app.shopping.plan then app.showDetails(app.shopping.plan.recipe,true)end end)
        f.info:SetText(app.caption('compact_info'));f.info.tipLines=function()return {f.bound:GetText(),f.hint:GetText(),app.caption('compact_hover')}end
        for b,role in pairs({[f.alts]='alts',[f.vendors]='merchant',[f.priceLimit]='coin',[f.unlock]='unlock',[f.info]='info'})do
            app.styleButton(b,role,true);b.fixedRole=true
        end
        f.total=text(f,11,18,-365,464,gold)
        f.hint=text(f,10,0,0,464);f.hint:Hide()
        f.rows=text(f,10,0,0,464);f.rows:Hide()
        f.child=CreateFrame('Frame',nil,f);f.child:Hide()
        f.buy=button(f,282,-321,200,'',function()app.searchShopping()end);f.buy:SetSize(200,34)
        app.styleButton(f.buy,'coin',false);f.buy.fixedRole=true
        f.syncSlider=true;f.slider:SetValue(app.shopping.points);f.syncSlider=nil
    end
    app.renderShopping();app.shoppingWindow:Show();app.announceMerchants(app.shopping.plan);if app.renderNextStep then app.renderNextStep(app.shopping.plan)end
end
function app.shoppingItemLines(row)
    local lines={app.caption('inventory_material',row.name,row.total,row.buy)}
    if row.locations then
        for _,line in ipairs(app.inventoryLines(row.locations,row.total))do lines[#lines+1]=line end
        local fromAlts=math.min(row.locations.deductibleAlts,math.max(0,row.total-(row.locations.bags or 0)-(row.locations.bank or 0)-(row.locations.shared or 0)))
        if fromAlts>0 then lines[#lines+1]=app.caption('inventory_transfer_alt',fromAlts)end
    end
    if row.buy>0 then
        lines[#lines+1]=row.vendor and app.caption(row.vendorKind=='reference'and 'shop_vendor_reference'or 'shop_vendor',app.money(row.unit))or app.caption('shop_unit_limit',app.money(row.unit),app.money(row.maxUnit))
        if row.vendorUnit and not row.vendor then lines[#lines+1]=app.caption('shop_ah_below_vendor',app.money(row.vendorUnit))end
        if row.vendorUnit then local v=app.nearestMerchant(row.id);if v then lines[#lines+1]=app.caption('merchant_row',v.name,app.merchantLocation(v))end end
    else lines[#lines+1]=app.caption('shop_owned')end
    return lines
end
function app.renderShopping()
    local f=app.shoppingWindow;if not f then return end
    if not app.shoppingFresh()then f:Hide();return end
    local s=app.shopping;local plan,reason=app.shoppingPlan()
    f.title:SetText('CraftDeja · '..app.caption('shop_title'))
    local age=math.max(0,math.floor((app.try(GetTime)or app.try(time)or 0)-s.ready))
    f.subtitle:SetText(app.caption('shop_scan_age',math.floor(age/60),age%60))
    f.goal:SetText(app.planningTitle(plan))
    f.goalMode:SetText(app.caption(s.goal=='next'and 'goal_mode_next'or 'goal_mode_manual'))
    local delta=plan and plan.target-plan.from or s.points
    f.syncSlider=true;local high=s.goal=='next'and math.max(50,delta)or 50
    f.slider:SetMinMaxValues(1,high);f.slider.High:SetText(tostring(high));f.slider:SetValue(s.goal=='next'and math.max(1,delta)or s.points);f.syncSlider=nil
    f.alts:SetText(app.caption(app.options.inventoryAlts and 'inventory_alts_count'or 'inventory_alts_show'))
    f.vendors:SetText(app.caption('merchant_button'))
    f.bound:SetText(app.caption('shop_bounds'))
    f.priceLimit:SetText(app.caption('shop_limit',s.tolerance))
    f.unlock:SetText(app.caption('shop_unlock'));f.buy:SetText(app.caption(s.searched and 'compact_sent'or 'compact_search'))
    f.hint:SetText(app.caption(s.searched and 'shop_in_mail'or 'shop_buy_hint'))
    f.recipe:SetText(plan and app.recipeName(plan.recipe)or app.caption(reason or 'none'))
    f.summary:SetText('');f.total:SetText('');f.rows:SetText('')
    f.buy:Disable()
    for _,card in ipairs(f.cards)do card:Hide()end
    if not plan then f.pageText:SetText(app.caption(reason or 'none'));if app.refreshNextStep then app.refreshNextStep()end;return end
    s.plan=plan
    f.summary:SetText(app.caption('plan_summary',plan.from,plan.target,plan.estimated and app.caption('approx')or '',plan.crafts)..'\n'..app.caption('shop_counts',plan.ahRows,plan.vendorRows,plan.ownedRows))
    f.summary:SetHeight(28)
    if plan.capped then f.bound:SetText(app.caption('shop_capped',plan.target-plan.from))end
    local lines={}
    for _,row in ipairs(plan.rows)do
        for _,line in ipairs(app.shoppingItemLines(row))do lines[#lines+1]=line end
        lines[#lines+1]=''
    end
    f.rows:SetText(table.concat(lines,'\n'))
    f.page=math.max(1,math.min(f.page,math.max(1,math.ceil(#plan.rows/7))))
    for i,card in ipairs(f.cards)do
        local row=plan.rows[(f.page-1)*7+i];card.row=row
        if row then
            card:Show()
            local icon=app.itemIcon(row.id)
            card.icon:SetTexture(icon);card.count:SetText((row.owned or '?')..'/'..row.total)
            local colour=row.buy>0 and (row.vendor and {1,.75,.25}or {1,.4,.36})or (row.locations and (row.locations.bank or 0)>0 and {.4,.8,1}or {.5,.9,.6})
            card.dot:SetColorTexture(unpack(colour));card.count:SetTextColor(unpack(colour))
        else card:Hide()end
    end
    local multiple=#plan.rows>7
    if multiple then f.previous:Show();f.forward:Show();f.pageText:SetText(f.page..' / '..math.ceil(#plan.rows/7))
    else f.previous:Hide();f.forward:Hide();f.pageText:SetText(app.caption('compact_hover'))end
    f.total:SetText(app.caption('shop_total',app.money(plan.ahTotal),app.money(plan.vendorTotal)))
    if not plan.stockKnown then f.hint:SetText(app.caption('shop_unknown_stock'))
    elseif plan.ahRows==0 then f.hint:SetText(app.caption(plan.vendorRows>0 and 'shop_vendor_only'or 'shop_nothing'))
    elseif not s.searched then f.buy:Enable()end
    if app.merchantWindow and app.merchantWindow:IsShown()then app.renderMerchants()end
    if app.renderNextStep then app.renderNextStep(plan)end
end

function app.showMerchants()
    if not app.merchantWindow then
        local f=window('CraftDejaMerchants',650,450);app.merchantWindow=f
        f.page=1
        button(f,478,-33,34,'‹',function()f.page=math.max(1,f.page-1);app.renderMerchants()end)
        f.pageText=text(f,11,521,-40,62)
        button(f,592,-33,34,'›',function()f.page=f.page+1;app.renderMerchants()end)
        f.rows={}
        for i=1,5 do
            local row=panel(f,16,-61-(i-1)*65,618,59)
            row.name=text(row,12,10,-6,490,gold);row.name:SetHeight(28)
            row.location=text(row,10,10,-35,490);row.location:SetHeight(20)
            row.pin=button(row,520,-16,87,'',function()if row.merchant then app.markMerchant(row.merchant)end end)
            f.rows[i]=row
        end
        f.note=text(f,10,18,-399,612);f.note:SetHeight(35)
    end
    app.renderMerchants();app.merchantWindow:Show()
end
function app.renderMerchants()
    local f=app.merchantWindow;if not f then return end
    f.title:SetText(app.caption('merchant_title'))
    local entries={};local plan=app.shopping.plan
    for _,row in ipairs(plan and plan.rows or {})do
        if row.buy>0 and row.vendorUnit then
            local v=app.nearestMerchant(row.id)
            entries[#entries+1]={item=row.name,merchant=v}
        end
    end
    for i,row in ipairs(f.rows)do
        f.page=math.max(1,math.min(f.page,math.max(1,math.ceil(#entries/5))))
        local entry=entries[(f.page-1)*5+i]
        if entry then
            row:Show();row.merchant=entry.merchant;row.pin:SetText(app.caption('merchant_pin'))
            if entry.merchant then
                local v=entry.merchant
                row.name:SetText(v.name..' · '..entry.item)
                row.location:SetText(app.merchantLocation(v)..' · '..app.caption(v.observed and 'merchant_observed'or 'merchant_reference'))
                row.pin:Enable()
            else row.name:SetText(entry.item);row.location:SetText(app.caption('merchant_unknown'));row.pin:Disable()end
        else row:Hide()end
    end
    f.pageText:SetText(f.page..' / '..math.max(1,math.ceil(#entries/5)))
    f.note:SetText(app.caption(#entries==0 and 'merchant_no_need'or 'merchant_note'))
end

function app.showVendorBuy()
    if not app.vendorBuyWindow then
        local f=window('CraftDejaVendorBuy',500,306);app.vendorBuyWindow=f;f.page=1
        f.onDismiss=function()app.vendorPurchase.dismissed=true end
        f.goal=text(f,11,18,-53,285,gold)
        button(f,338,-45,28,'-',function()app.setPlanningGoal('manual',app.shopping.points-1);app.offerVendorPurchase()end)
        button(f,375,-45,28,'+',function()app.setPlanningGoal('manual',app.shopping.points+1);app.offerVendorPurchase()end)
        f.retry=button(f,442,-45,40,'',function()app.retryVendorPurchase()end);f.retry:SetText(app.caption('vendor_buy_retry'))
        app.styleButton(f.retry,'refresh',true);f.retry.fixedRole=true
        f.summary=text(f,12,18,-81,464,gold);f.summary:SetHeight(25)
        f.cards={}
        for i=1,7 do
            local card=button(f,18+(i-1)*66,-111,62,'',function(self)if self.row then f.selected=self.row.id;app.renderVendorBuy()end end)
            card:SetSize(62,64);card.itemIcon=true;card.iconOnly=true;card.label:Hide()
            card.icon:ClearAllPoints();card.icon:SetSize(36,36);card.icon:SetPoint('TOP',0,-5)
            card.count=text(card,10,2,-45,58);card.count:SetJustifyH('CENTER')
            card:SetScript('OnEnter',function(self)
                local r=self.row;if r then app.showTip(self,r.name,{app.caption('vendor_buy_amount',r.missing,r.quantity,r.bundle),app.caption('vendor_buy_cost',app.money(r.cost)),app.caption('vendor_buy_help')})end
            end);f.cards[i]=card
        end
        f.previous=button(f,18,-184,28,'<',function()f.page=math.max(1,f.page-1);app.renderVendorBuy()end)
        f.pageText=text(f,10,53,-192,120)
        f.forward=button(f,184,-184,28,'>',function()f.page=f.page+1;app.renderVendorBuy()end)
        f.status=text(f,11,18,-217,464);f.status:SetHeight(29)
        f.buy=button(f,18,-257,464,'',function()if f.selected then app.buyVendorMaterial(f.selected)end end);f.buy:SetSize(464,34)
        app.styleButton(f.buy,'bag',false);f.buy.fixedRole=true
    end
    app.renderVendorBuy();app.vendorBuyWindow:Show()
end
function app.renderVendorBuy()
    local f=app.vendorBuyWindow;local s=app.vendorPurchase;if not f then return end
    if not s.open then f:Hide();return end
    local rows=s.plan and s.plan.rows or {}
    f.title:SetText('CraftDeja · '..app.caption('vendor_buy_title'))
    f.goal:SetText(app.planningTitle(s.plan))
    local selected
    for _,row in ipairs(rows)do if row.id==f.selected then selected=row end end
    selected=selected or rows[1];f.selected=selected and selected.id
    f.page=math.max(1,math.min(f.page,math.max(1,math.ceil(#rows/7))))
    for i,card in ipairs(f.cards)do
        local row=rows[(f.page-1)*7+i];card.row=row
        if row then
            card:Show();card.icon:SetTexture(app.itemIcon(row.id))
            card.count:SetText(tostring(row.quantity));card.count:SetTextColor(unpack(row.id==f.selected and {1,.92,.5}or {.8,.8,.85}))
        else card:Hide()end
    end
    if #rows>7 then f.previous:Show();f.forward:Show();f.pageText:SetText(f.page..' / '..math.ceil(#rows/7))
    else f.previous:Hide();f.forward:Hide();f.pageText:SetText(app.caption('compact_hover'))end
    f.summary:SetText(selected and selected.name..' · '..app.caption('vendor_buy_amount',selected.missing,selected.quantity,selected.bundle)or app.caption('shop_nothing'))
    f.status:SetText(app.caption(s.status or 'vendor_buy_one_stack'))
    f.buy:SetText(selected and app.caption('vendor_buy_button',selected.quantity,app.money(selected.cost))or app.caption('shop_nothing'))
    if selected and not s.pending then f.buy:Enable()else f.buy:Disable()end
end
