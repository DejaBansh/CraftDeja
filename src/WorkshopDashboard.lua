-- SPDX-License-Identifier: MIT
local _,app=...
local function move(w,x,y)w:ClearAllPoints();w:SetPoint('TOPLEFT',x,-y)end
local function label(parent,size,x,y,w,text)
    local t=app.createLabel(parent,size,x,-y,w);t:SetText(text or '');t:SetTextColor(.86,.92,.98);return t
end
local function card(parent,x,y,w,h)
    local f=CreateFrame('Frame',nil,parent);f:SetSize(w,h);f:SetPoint('TOPLEFT',x,-y);app.workshopCard(f);return f
end
local function scroll(parent,w,h)
    local s=CreateFrame('ScrollFrame',nil,parent,'UIPanelScrollFrameTemplate');s:SetPoint('TOPLEFT',18,-56);s:SetSize(w-50,h-76)
    local child=CreateFrame('Frame',nil,s);child:SetSize(w-54,h-76);s:SetScrollChild(child);return s,child
end
local advancedNames={'targetLabel','target','plan','cancel','prices','share','discover','details','offers','teacher','scroll','provider','mode','amountLabel','amount','transferLabel','transfer','conditions','whisper','skip','reset','handover','sent'}
local function guide()return app.nextStepWindow end
local function dispatch()
    -- Snapshot identity after a refresh; never click the action captured when
    -- this dashboard card was first created. Existing confirmations still apply.
    local dashboard=app.routeWindow and app.routeWindow.workshop
    local expected=dashboard and dashboard.boundActionKey
    app.refreshNextStep(true)
    local g=guide();local b=g and g.primaryCTA
    if not expected or expected~=app.workshopActionIdentity(g)then
        dashboard.changedAction={before=expected,after=app.workshopActionIdentity(g)}
        app.flowLog('ui.dashboard_action_changed',dashboard.changedAction)
        app.actionNotice=app.caption('ws_action_updated');app.refreshNextStep(true);return
    end
    if b and b:IsEnabled()then local click=b:GetScript('OnClick');if click then click(b,'LeftButton')end end
end
local function augment(f)
    if f.workshop then return end
    local d={};f.workshop=d;f:SetSize(1280,760)
    f.title:SetText('CraftDeja');f.title:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',22,'')
    move(f.title,80,22);f.title:SetWidth(700)
    f.close:ClearAllPoints();f.close:SetPoint('TOPRIGHT',-18,-18)
    if f.logo then f.logo:SetSize(40,40);move(f.logo,24,18)end
    d.badge=f:CreateTexture(nil,'ARTWORK');d.badge:SetTexture(app.uiPath('WorkshopLogoFrame'));d.badge:SetSize(59,59);d.badge:SetPoint('TOPLEFT',14,-8)
    d.goblin=f:CreateTexture(nil,'ARTWORK');d.goblin:SetTexture(app.uiPath('WorkshopGoblin'));d.goblin:SetSize(102,102);d.goblin:SetPoint('TOPRIGHT',-57,-4)
    d.subtitle=label(f,13,80,53,870)
    d.sidebar=card(f,18,104,178,638);d.navigation={}
    for i,key in ipairs({'route','materials','stock','settings','advanced'})do
        local page=key;local b=app.createButton(d.sidebar,16,-28-(i-1)*62,146,'',function()
            if page=='stock'and d.page~=page then app.resetWorkshopStock(d)end
            d.page=page;d.selectedItem=nil
            if page=='materials'and not app.craftRefreshBusy()then
                local decision=app.decision
                if decision and decision.current then d.materialPlan,d.materialReason=app.materialPlan(decision.current.recipe,decision.stop)end
            end
            app.renderRouteWindow()
        end)
        b:SetHeight(46);b.fixedRole=true;app.styleButton(b,({route='book',materials='bag',stock='bag',settings='gear',advanced='alts'})[key],false);d.navigation[key]=b
        b.label:SetWidth(110);b.label:SetWordWrap(true)
    end
    d.guide=app.createButton(d.sidebar,16,-552,146,'',function()app.showCentralGuide();f:Hide()end);d.guide:SetHeight(54);d.guide.label:SetWidth(110);d.guide.label:SetWordWrap(true)
    d.center=card(f,210,104,650,504);d.right=card(f,876,104,386,504);d.bottom=card(f,210,624,1052,118)
    d.centerTitle=label(d.center,18,24,20,594)
    d.configure=app.createButton(d.center,435,-18,188,'',function()d.page='advanced';app.renderRouteWindow()end)
    d.rightTitle=label(d.right,12,22,23,342);d.rightTitle:SetText(app.caption('ws_next'))
    d.summary=label(d.bottom,12,24,18,690)
    d.profession=label(d.center,27,24,70,595);d.profession:SetHeight(38)
    d.skill=label(d.center,14,24,115,595)
    d.progress=CreateFrame('StatusBar',nil,d.center);d.progress:SetSize(596,8);d.progress:SetPoint('TOPLEFT',24,-143);d.progress:SetStatusBarTexture('Interface\\Buttons\\WHITE8X8');d.progress:SetStatusBarColor(.27,.85,.66);d.progress:SetMinMaxValues(0,1);d.progress:SetValue(0)
    d.list=CreateFrame('ScrollFrame',nil,d.center,'UIPanelScrollFrameTemplate');d.list:SetPoint('TOPLEFT',24,-172);d.list:SetSize(590,315)
    d.listChild=CreateFrame('Frame',nil,d.list);d.listChild:SetSize(571,315);d.list:SetScrollChild(d.listChild);d.rows={}
    d.action=app.createButton(d.right,22,-60,342,'',dispatch);d.action.fixedRole=true
    d.actionTitle=label(d.right,16,22,137,342);d.actionTitle:SetHeight(66)
    d.statusScroll,d.statusChild=scroll(d.right,386,276);d.statusScroll:ClearAllPoints();d.statusScroll:SetPoint('TOPLEFT',22,-210);d.statusScroll:SetSize(324,263)
    d.status=label(d.statusChild,13,0,0,318);d.status:SetHeight(250)
    d.source=app.createButton(d.bottom,734,-76,292,'',function()
        local r=d.selectedRecipe;if r then app.showDetails(r,false,true)end
    end)
    d.stockOverview=app.createButton(d.bottom,734,-23,292,'',function()app.showStockTargets()end)
    d.stockOverview:SetHeight(40);d.stockOverview.label:SetWidth(256);d.stockOverview.label:SetWordWrap(true)
    -- Keep every original control and script in an explicitly chosen advanced
    -- page. This includes guild/twink terms, handover and planned trainer clicks.
    d.advanced=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');d.advanced:SetPoint('TOPLEFT',222,-91);d.advanced:SetSize(1000,633)
    d.advancedChild=CreateFrame('Frame',nil,d.advanced);d.advancedChild:SetSize(970,735);d.advanced:SetScrollChild(d.advancedChild)
    d.editOrder=app.createButton(d.advancedChild,770,-48,200,'',function()app.editUnifiedOrder()end)
    for _,name in ipairs(advancedNames)do local w=f[name];if w then
        local p,_,r,x,y=w:GetPoint();w:SetParent(d.advancedChild);w:ClearAllPoints();w:SetPoint(p,d.advancedChild,r,x,y)
    end end
    -- General settings are real saved addon options; deeper settings retain the
    -- existing configuration UI (prices, alt stock, guild sharing and diagnostics).
    d.settings=CreateFrame('Frame',nil,d.center);d.settings:SetPoint('TOPLEFT',24,-78);d.settings:SetSize(595,390)
    d.settingsRows={}
    local actions={function()app.showUnifiedGeneral()end,function()app.options.autoOpenMerchant=not(app.options.autoOpenMerchant~=false);app.renderWorkshopDashboard()end,function()app.options.minimapHidden=not app.options.minimapHidden;app.renderLauncher();app.renderWorkshopDashboard()end,function()app.showOptions('lookup')end,function()app.showOptions('help')end}
    for i,run in ipairs(actions)do d.settingsRows[i]=app.createButton(d.settings,0,-(i-1)*58,575,'',run);d.settingsRows[i]:SetHeight(44)end
    d.page='route'
end
local function rowAt(d,i)
    if not d.rows[i]then
        local b=app.createButton(d.listChild,0,-(i-1)*78,567,'',function(self)
            d.selectedRecipe=self.recipe;d.selectedSegment=self.segment;d.selectedItem=self.item;app.renderWorkshopDashboard()
        end)
        b:SetHeight(66);b.label:SetJustifyH('LEFT');b.label:SetWidth(510);b.label:SetHeight(52);b.label:SetWordWrap(true);b.fixedRole=true;app.styleButton(b,'hammer',false);d.rows[i]=b
    end
    return d.rows[i]
end
function app.renderWorkshopDashboard()
    local f=app.routeWindow;if not f or not f.workshop or not f:IsShown()then return end
    local d=f.workshop
    local stock=d.page=='stock'
    local route=d.page=='route'
    local advanced=d.page=='advanced';d.advanced:SetShown(advanced)
    for _,name in ipairs({'center','right','bottom'})do d[name]:SetShown(not advanced and not stock)end
    if d.stockPage then d.stockPage:SetShown(stock)end
    local stocks=(route or stock)and app.stockTargetRows()
    local low=0
    for _,row in ipairs(stocks or {})do if row.missing and row.missing>0 then low=low+1 end end
    d.stockOverview:SetShown(route)
    if route then d.stockOverview:SetText(app.caption('stock_overview',#stocks,low))end
    f.title:SetText('CraftDeja');d.subtitle:SetText(app.caption('workshop')..'  /  '..app.caption('ws_'..d.page))
    for key,b in pairs(d.navigation)do
        b:SetText(app.caption('ws_'..key)..(key=='stock'and low>0 and ' · '..low or ''));local active=key==d.page
        local t=b:GetNormalTexture();if t then t:SetColorTexture(unpack(active and {.10,.29,.36,1}or {.035,.055,.09,1}))end
        b.label:SetTextColor(unpack(active and {.62,1,.88}or {.75,.83,.94}))
    end
    d.guide:SetText(app.caption('ws_guide'))
    d.editOrder:SetText(app.caption('ui_change'))
    app.workshopFit(f,1280,760,app.options.windowScales and app.options.windowScales.CraftDejaRoute or app.options.scale)
    if stock then app.renderWorkshopStock(f,d,stocks,low);return end
    if advanced then return end
    local g=guide();local task=g and g.task;local plan=g and g.plan
    if plan then d.materialPlan=plan elseif d.materialPlan and app.decision and app.decision.current and d.materialPlan.recipe.id~=app.decision.current.recipe.id then d.materialPlan=nil end
    plan=plan or d.materialPlan
    local search=app.routeSuggestion or app.routeResult;local order=app.currentRouteOrder();local profile=app.active and app.active.profile
    if d.model~=(search and search.model)then d.model=search and search.model;d.selectedRecipe=nil;d.selectedSegment=nil;d.selectedItem=nil end
    d.rightTitle:SetText(app.caption('ws_next'))
    local settings=d.page=='settings';d.settings:SetShown(settings)
    for _,name in ipairs({'profession','skill','progress','list'})do d[name]:SetShown(not settings)end
    d.centerTitle:SetText(app.caption(settings and 'ws_settings'or d.page=='materials'and 'ws_materials'or 'ws_route'))
    d.configure:SetText(app.caption('route_start'));d.configure:SetShown(d.page=='route')
    local target=order and order.target or search and search.model.target or profile and profile.cap or 0
    d.profession:SetText(profile and app.professionName(profile.id)or 'CraftDeja')
    local start=order and order.start or search and search.model.start or 0
    d.skill:SetText(profile and app.caption('ws_progress',profile.skill,target)..'  ·  Start '..start or app.caption('ws_no_route'))
    d.progress:SetValue(profile and target>start and math.max(0,math.min(1,(profile.skill-start)/(target-start)))or 0)
    local n=0
    if not settings then
        if d.page=='materials'then
            local rows=plan and plan.rows or {}
            if #rows==0 and search and search.best then rows={};for id,total in pairs(search.best.demand or {})do rows[#rows+1]={id=id,total=total,name=app.itemName(id)}end;table.sort(rows,function(a,b)return a.id<b.id end)end
            local selectedID=d.selectedItem and d.selectedItem.id;d.selectedItem=nil
            local memo={}
            for _,cached in ipairs(rows)do
                local r=app.copy(cached);r.locations=app.inventoryFor(r.id);r.unit=app.unitPrice(r.id,memo)
                if plan and app.craftBatch and app.craftBatch.id==plan.recipe.id and plan.crafts and plan.crafts>0 then r.total=math.ceil(r.total*app.craftBatch.remaining/plan.crafts)end
                r.buy=r.locations and type(r.locations.total)=='number'and math.max(0,r.total-r.locations.total)or nil
                n=n+1;local b=rowAt(d,n);b.recipe=nil;b.segment=nil;b.item=r
                local bags=r.locations and r.locations.bags
                b:SetText((r.name or app.itemName(r.id))..'\n'..app.caption('ws_qty',bags~=nil and tostring(bags)or '?',tostring(r.total or '?'),tostring(r.buy or '?')));b:Show()
                if selectedID==r.id then d.selectedItem=r end
            end
        else
            for i,s in ipairs(search and search.best and search.best.segments or {})do
                n=n+1;local r=(search.model.rawRecipes or {})[s.recipe]or (search.model.recipes or {})[s.recipe]or {id=s.recipe}
                local b=rowAt(d,n);b.recipe=r;b.segment=s;b.item=nil
                b:SetText(string.format('%02d  ',i)..app.recipeName(r)..'\n'..app.caption('ws_segment',s.from,s.to,s.crafts));b:Show()
                if not d.selectedRecipe then d.selectedRecipe=r;d.selectedSegment=s end
                if d.selectedRecipe and d.selectedRecipe.id==r.id then b:GetNormalTexture():SetColorTexture(.07,.24,.27,1)end
            end
            if n==0 and plan and plan.recipe then n=1;local b=rowAt(d,1);b.recipe=plan.recipe;b.item=nil;b.segment=nil;b:SetText(app.recipeName(plan.recipe)..'\n'..app.caption('ws_segment',plan.from or 0,plan.target or 0,plan.crafts or 0));b:Show()end
        end
        if n==0 then local b=rowAt(d,1);b:SetText(app.caption(d.page=='materials'and 'ws_no_materials'or 'ws_no_route'));b.recipe=nil;b.item=nil;b.segment=nil;b:Show();n=1 end
    end
    for i,b in ipairs(d.rows)do if i>n or settings then b:Hide()end end
    d.listChild:SetHeight(math.max(315,n*78))
    if settings then
        local texts={app.caption('ui_general'),app.caption('merchant_auto')..': '..app.caption(app.options.autoOpenMerchant~=false and 'enabled'or 'disabled'),app.caption('launcher_minimap')..': '..app.caption(app.options.minimapHidden~=true and 'enabled'or 'disabled'),app.caption('ui_lookup'),app.caption('ui_help')}
        for i,b in ipairs(d.settingsRows)do b:SetText(texts[i])end
    end
    local primary=g and g.primaryCTA
    d.boundActionKey=app.workshopActionIdentity(g)
    d.action:SetText(primary and primary:GetText()or app.caption('ws_guide'))
    if primary and primary:IsEnabled()then d.action:Enable()else d.action:Disable()end
    app.styleCTAButton(d.action,true);app.workshopReady(d.action,app.workshopActionReady(g),d.boundActionKey)
    d.actionTitle:SetText(g and g.body:GetText()or app.caption('ws_no_route'))
    local lines={task and task.body or app.caption('ws_no_route')}
    if app.actionNotice then lines[#lines+1]=app.actionNotice end
    if d.selectedItem then local r=d.selectedItem;lines[#lines+1]=(r.name or app.itemName(r.id))..'\n'..app.caption('ws_qty',tostring(r.locations and r.locations.bags or '?'),tostring(r.total or '?'),tostring(r.buy or '?'));lines[#lines+1]=type(r.unit)=='number'and app.money(r.unit)or app.caption('ws_no_price')
    elseif d.selectedRecipe then lines[#lines+1]=app.caption('ws_selected')..': '..app.recipeName(d.selectedRecipe)
        if d.selectedSegment then local s=d.selectedSegment;lines[#lines+1]=app.caption('ws_segment',s.from,s.to,s.crafts)end
    end
    d.status:SetText(table.concat(lines,'\n\n'));d.status:SetHeight(math.max(250,d.status:GetStringHeight()+8));d.statusChild:SetHeight(d.status:GetHeight())
    local best=search and search.best
    local known=best and not best.provisional and not search.costsStale
    d.summary:SetText(app.caption('ws_cost')..'  ·  '..app.caption('ws_estimate')..'\n'..(best and app.caption('route_costs',app.money(known and best.cashMaterials or nil),app.money(known and best.cashLearning or nil),app.money(known and best.cashTransfer or nil),app.money(best.owned),app.money(best.vendor),app.money(known and best.knownNet or nil))or app.caption('ws_no_price')))
    d.summary:SetWidth(690);d.source:SetText(app.caption('ws_source'));d.source:SetShown(d.selectedRecipe~=nil and d.page~='materials')
end
local show=app.showRouteWindow
app.showRouteWindow=function(target,page)
    -- Creation and route configuration stay in the existing implementation.
    show(target);local f=app.routeWindow;augment(f)
    if page=='stock'then app.resetWorkshopStock(f.workshop)end
    if page then f.workshop.page=page end
    app.renderWorkshopDashboard()
    app.refreshNextStep(true)
end
local render=app.renderRouteWindow
app.renderRouteWindow=function(...)
    render(...);app.renderWorkshopDashboard()
end
local command=app.command
app.command=function(message)
    local key=(message or ''):match('^%s*(%S*)'):lower()
    if key=='dashboard'or key=='werkstatt'then app.showRouteWindow();return end
    return command(message)
end
local action=app.unifiedAction
app.unifiedAction=function(f)
    local kind=f.task and f.task.kind
    local result=action(f)
    if result and (kind=='route_supply_guild'or kind=='route_supply_alt'or kind=='route_review')then
        local window=app.routeWindow
        if window and window.workshop and window:IsShown()then window.workshop.page='advanced';app.renderRouteWindow()end
    end
    return result
end
