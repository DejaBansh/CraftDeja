-- SPDX-License-Identifier: MIT
local _,app=...
local words={
    de={ws_stock='Zielbestände',stock_overview='%d Ziele · %d unter Ziel',stock_add='Gegenstand hinzufügen',
        stock_search='Nach Gegenstandsname suchen',stock_back='Zurück zur Liste',stock_recipe_add='Gewähltes Rezept übernehmen',
        stock_merchant_add='Händlerware auswählen',stock_source_craft='Herstellen · %s',stock_source_track='Bestand verfolgen / Händler',
        stock_all='Alle Ziele',stock_low='Nur Fehlbestand',stock_bags='Taschen',stock_goal='Ziel',stock_missing='Fehlen',
        stock_name='Gegenstand',stock_pick='Auswählen',stock_empty='Keine passenden Gegenstände.',
        stock_edit_tip='Zielmenge eingeben und mit Enter speichern. 0 entfernt das Ziel.',
        stock_search_tip='Suche bekannte Gegenstände oder füge einen Gegenstandslink ein.',
        stock_next='Auffüllschritt im Guide',stock_show_step='Guide-Schritt öffnen',stock_choose_row='Wähle links einen Gegenstand.',
        stock_need_vendor='Händler für diesen Gegenstand öffnen.',stock_refill_off='„Zielbestand auffüllen“ ist ausgeschaltet.',
        stock_extra='Zusätzlich herstellen …',stock_extra_hint='Einmaliger Giftauftrag',stock_select_recipe='Wähle ein gelerntes Verbrauchsrezept im Berufsfenster.',
        stock_craft_start='Auffüllauftrag vorbereiten',stock_goal_invalid='Zielmenge zwischen 0 und 10.000 eingeben.',
        stock_save='Ziel speichern',stock_sources='Bezugsweg wählen',stock_vendor_path='Beim Händler kaufen',
        stock_read='Berufsfenster zum Einlesen öffnen: %s.',stock_read_first='Öffne einen Beruf, um seine gelernten Verbrauchsrezepte einzulesen.',
        stock_recipe_incomplete='Für dieses Rezept fehlen bestätigte Zutaten oder eine feste Ausbeute.'},
    en={ws_stock='Stock targets',stock_overview='%d targets · %d below target',stock_add='Add an item',
        stock_search='Search item names',stock_back='Back to targets',stock_recipe_add='Use selected recipe',
        stock_merchant_add='Choose vendor item',stock_source_craft='Craft · %s',stock_source_track='Track stock / vendor',
        stock_all='All targets',stock_low='Shortfalls only',stock_bags='Bags',stock_goal='Target',stock_missing='Missing',
        stock_name='Item',stock_pick='Select',stock_empty='No matching items.',
        stock_edit_tip='Enter a target and press Enter to save. Set it to 0 to remove.',
        stock_search_tip='Search known items or paste an item link.',
        stock_next='Refill step in the guide',stock_show_step='Open guide step',stock_choose_row='Select an item on the left.',
        stock_need_vendor='Open a vendor that sells this item.',stock_refill_off='“Refill stock targets” is off.',
        stock_extra='Craft extra units …',stock_extra_hint='One-time poison order',stock_select_recipe='Select a learned consumable recipe in the profession window.',
        stock_craft_start='Prepare refill order',stock_goal_invalid='Enter a stock target from 0 to 10,000.',
        stock_save='Save target',stock_sources='Choose a source',stock_vendor_path='Buy at a vendor',
        stock_read='Open the profession to read its recipes: %s.',stock_read_first='Open a profession to read its learned consumable recipes.',
        stock_recipe_incomplete='This recipe needs confirmed ingredients and a fixed yield.'}
}
for lang,entries in pairs(words)do for key,value in pairs(entries)do app.words[lang][key]=value end end

local function query(text)
    return (text:gsub('Ä','ä'):gsub('Ö','ö'):gsub('Ü','ü'):lower():gsub('ß','ss'):match('^%s*(.-)%s*$'))
end
local function label(parent,size,x,y,width,height)
    local t=app.createLabel(parent,size,x,-y,width)
    t:SetHeight(height);t:SetWordWrap(true);t:SetJustifyV('TOP')
    return t
end
local function panel(parent,x,y,w,h)
    local frame=CreateFrame('Frame',nil,parent)
    frame:SetPoint('TOPLEFT',x,-y);frame:SetSize(w,h);app.workshopCard(frame)
    return frame
end
local function edit(parent,x,y,w,numeric)
    local box=CreateFrame('EditBox',nil,parent,'InputBoxTemplate')
    box:SetPoint('TOPLEFT',x,-y);box:SetSize(w,28);box:SetAutoFocus(false)
    box:SetNumeric(numeric);box:SetMaxLetters(numeric and 5 or 255)
    return box
end
local function on(button,enabled)
    if enabled then button:Enable()else button:Disable()end
end
local function render()app.renderWorkshopDashboard()end
local rowHeight,viewport=58,390

local function selectItem(page,id,source)
    page.selected=id;page.choice=source;page.notice=nil;page.goal:ClearFocus()
    page.sourceScroll:SetVerticalScroll(0)
    render()
end
local function save(page)
    local id=page.selected
    if not id then return end
    local n=tonumber(page.goal:GetText())
    local recipe=page.sourceRecipe
    local valid=n and n>=0 and n<=10000 and n==math.floor(n)
    if valid and app.setStockTarget(id,n,n>0 and recipe or nil,page.sourceKey=='vendor')then
        page.notice=nil;page.goal:ClearFocus();page.candidates=nil
        app.refreshNextStep(true)
    else
        page.notice=app.caption(not valid and 'stock_goal_invalid'or app.stockTargetEditingLocked()and 'stock_locked'or 'stock_bad')
    end
    render()
end
local function createRow(page)
    local row=CreateFrame('Frame',nil,page.child);row:SetSize(684,rowHeight)
    row.name=app.createButton(row,0,-3,684,'',function()
        if not row.entry then return end
        selectItem(page,row.entry.id,page.mode=='merchant'and 'vendor'or nil)
    end)
    row.name.icon:Hide()
    row.icon=row.name:CreateTexture(nil,'OVERLAY');row.icon:SetSize(29,29);row.icon:SetPoint('LEFT',8,0)
    row.name.label:ClearAllPoints();row.name.label:SetPoint('LEFT',48,0)
    row.name:SetHeight(51);row.name.label:SetWidth(365);row.name.label:SetHeight(47)
    row.name.label:SetWordWrap(true);row.name.label:SetJustifyH('LEFT')
    row.bags=label(row.name,14,436,16,65,27)
    row.goal=label(row.name,14,508,16,69,27)
    row.missing=label(row.name,14,606,16,64,27)
    return row
end

local function drawRows(page)
    local first=math.floor(page.scroll:GetVerticalScroll()/rowHeight)+1
    for i,row in ipairs(page.pool)do
        local index=first+i-1
        local entry=page.filtered[index]
        row.entry=entry
        row:SetShown(entry~=nil)
        if entry then
            row:ClearAllPoints();row:SetPoint('TOPLEFT',0,-(index-1)*rowHeight)
            local recipe=entry.recipes[1]or entry.target
            local source=recipe and recipe.profession and app.caption('stock_source_craft',app.professionName(recipe.profession))or app.caption('stock_source_track')
            row.name:SetText(entry.name..'\n'..source)
            row.name.icon:Hide();row.icon:SetTexture(entry.icon)
            if page.selected==entry.id then row.name:GetNormalTexture():SetColorTexture(.06,.23,.27,1)end
            local stock=page.stocks[entry.id]
            row.bags:SetText(stock and tostring(stock.bags or '?')or '–')
            row.goal:SetText(stock and tostring(stock.goal)or '–')
            row.missing:SetText(stock and tostring(stock.missing or '?')or '–')
            row.missing:SetTextColor(stock and stock.missing and stock.missing>0 and 1 or .61,.85,.58)
        end
    end
end

local function mode(page,value)
    page.mode=value;page.notice=nil;page.candidates=nil
    page.search:SetText('');page.scroll:SetVerticalScroll(0);render()
    if value=='search'then page.search:SetFocus()end
end
local function create(f,d)
    local page=CreateFrame('Frame',nil,f);page:SetAllPoints(f);d.stockPage=page
    local left=panel(page,210,104,742,638)
    local right=panel(page,966,104,296,638)
    page.title=label(left,21,22,19,375,32)
    page.toggle=app.createButton(left,430,-17,290,'',function()
        page.notice=not app.toggleStockRefill()and app.caption('stock_locked')or nil;render()
    end)
    page.overview=label(left,14,23,62,690,26)
    page.add=app.createButton(left,22,-97,208,'',function()
        if page.mode then mode(page,nil)else mode(page,'search')end
    end)
    page.searchLabel=label(left,11,249,88,459,17)
    page.search=edit(left,254,106,459,false)
    page.search:SetScript('OnTextChanged',function()
        local link=tonumber(page.search:GetText():match('item:(%d+)'))
        if link then page.mode='search'end
        if page.link~=link then page.link=link;page.candidates=nil end
        page.scroll:SetVerticalScroll(0);render()
    end)
    page.search:SetScript('OnEscapePressed',function(box)box:ClearFocus()end)
    page.recipe=app.createButton(left,22,-141,239,'',function()
        local recipe,id=app.selectedStockRecipe()
        if id then mode(page,nil);selectItem(page,id,recipe.id);page.goal:SetFocus();page.goal:HighlightText()
        else page.notice=app.caption('stock_select_recipe');render()end
    end)
    page.merchant=app.createButton(left,274,-141,234,'',function()mode(page,'merchant')end)
    page.filter=app.createButton(left,520,-141,200,'',function()
        page.lowOnly=not page.lowOnly;page.scroll:SetVerticalScroll(0);render()
    end)
    page.headings={label(left,12,24,185,380,20),label(left,12,458,185,69,20),
        label(left,12,530,185,67,20),label(left,12,627,185,65,20)}
    page.scroll=CreateFrame('ScrollFrame',nil,left,'UIPanelScrollFrameTemplate')
    page.scroll:SetPoint('TOPLEFT',22,-206);page.scroll:SetSize(684,viewport)
    page.child=CreateFrame('Frame',nil,page.scroll);page.child:SetSize(684,viewport);page.scroll:SetScrollChild(page.child)
    page.filtered={};page.pool={}
    for i=1,math.ceil(viewport/rowHeight)+1 do page.pool[i]=createRow(page)end
    page.scroll:HookScript('OnVerticalScroll',function()drawRows(page)end)
    page.empty=label(left,13,25,219,675,65)
    page.help=label(left,12,23,603,698,31)
    page.read=label(left,12,23,61,460,35)
    page.overview:ClearAllPoints();page.overview:SetPoint('TOPLEFT',525,-62)
    page.overview:SetWidth(196)
    page.detail=label(right,16,21,22,255,75)
    page.amount=label(right,14,21,91,255,30)
    page.goalLabel=label(right,12,21,123,77,25)
    page.goal=edit(right,95,115,75,true)
    page.save=app.createButton(right,181,-115,94,'',function()save(page)end)
    page.save.label:SetWidth(75);page.save.label:SetWordWrap(true);page.save.icon:SetSize(12,12)
    page.save.label:ClearAllPoints();page.save.label:SetPoint('LEFT',17,0)
    page.goal:SetScript('OnEnterPressed',function()save(page)end)
    page.goal:SetScript('OnEscapePressed',function(box)box:ClearFocus();render()end)
    page.sourceTitle=label(right,13,21,156,255,24)
    page.sourceScroll=CreateFrame('ScrollFrame',nil,right,'UIPanelScrollFrameTemplate')
    page.sourceScroll:SetPoint('TOPLEFT',20,-183);page.sourceScroll:SetSize(234,95)
    page.sourceChild=CreateFrame('Frame',nil,page.sourceScroll);page.sourceChild:SetSize(234,95)
    page.sourceScroll:SetScrollChild(page.sourceChild);page.sourceButtons={}
    page.next=label(right,14,21,294,255,22)
    page.preview=label(right,13,21,321,255,102)
    page.action=app.createButton(right,21,-438,254,'',function()
        app.refreshNextStep(true);render()
        if page.guideReady then app.showCentralGuide();f:Hide()
        elseif page.selected and app.startStockTarget(page.selected)then f:Hide()
        else page.notice=app.caption('stock_locked');render()end
    end)
    page.action:SetHeight(54);page.action.label:SetWidth(212);page.action.label:SetWordWrap(true)
    page.extraTitle=label(right,13,21,494,254,30)
    page.extra=app.createButton(right,21,-528,254,'',function()
        if app.poisonUnlocked()and app.isPoison()and app.setPoisonRestock(false)then app.showPoisonPlanner();f:Hide()
        else page.notice=app.caption('stock_locked');render()end
    end)
    page.extra:SetHeight(49)
    return page
end

function app.invalidateWorkshopStock(item,defer)
    local f=app.routeWindow
    local page=f and f.workshop and f.workshop.stockPage
    if not page then return end
    if item and not (page.pending and page.pending[item])then return end
    page.candidates=nil
    if not defer and f:IsShown()and (f.workshop.page=='stock'or f.workshop.page=='route')and not app.craftRefreshBusy()then render()end
end
function app.resetWorkshopStock(d)
    local page=d.stockPage
    if not page then return end
    page.mode=nil;page.choice=nil;page.lowOnly=false;page.candidates=nil;page.notice=nil;page.link=nil
    page.goal:ClearFocus();page.search:SetText('');page.scroll:SetVerticalScroll(0)
end

local function drawSources(page,entry,target)
    local sources={}
    if entry then
        for _,r in ipairs(entry.recipes)do
            sources[#sources+1]={key=r.id,recipe=r,name=app.professionName(r.profession)..' · '..app.recipeName(r)}
        end
        if entry.vendor then sources[#sources+1]={key='vendor',name=app.caption('stock_vendor_path')}end
        local wanted=page.choice or (target and (target.recipe or 'tracked'))
        local found
        for _,source in ipairs(sources)do if source.key==wanted then found=true end end
        if not found and target then
            local name=target.profession and app.caption('stock_source_craft',app.professionName(target.profession))or app.caption('stock_source_track')
            sources[#sources+1]={key=target.recipe or 'tracked',name=name}
            if not page.choice then wanted=target.recipe or 'tracked'end
        elseif #sources==0 then
            sources[1]={key='tracked',name=app.caption('stock_source_track')}
        end
        page.sourceKey=sources[1].key;page.sourceRecipe=sources[1].recipe
        for _,source in ipairs(sources)do if source.key==wanted then
            page.sourceKey=source.key;page.sourceRecipe=source.recipe;break
        end end
    else page.sourceKey=nil;page.sourceRecipe=nil end
    for i,source in ipairs(sources)do
        local button=page.sourceButtons[i]
        if not button then
            button=app.createButton(page.sourceChild,0,-(i-1)*46,225,'',function(self)
                page.choice=self.sourceKey;page.notice=nil;render()
            end)
            button:SetHeight(42);button.label:SetWidth(186);button.label:SetWordWrap(true)
            page.sourceButtons[i]=button
        end
        button.sourceKey=source.key;button:SetText(source.name);button:Show()
        if source.key==page.sourceKey then button:GetNormalTexture():SetColorTexture(.06,.23,.27,1)end
    end
    for i=#sources+1,#page.sourceButtons do page.sourceButtons[i]:Hide()end
    page.sourceChild:SetHeight(math.max(95,#sources*46))
end

function app.renderWorkshopStock(f,d,stocks,low)
    local page=d.stockPage or create(f,d)
    if page.character~=app.character then
        page.character=app.character
        page.mode=nil;page.choice=nil;page.selected=nil;page.notice=nil;page.candidates=nil;page.link=nil
        if not app.craftRefreshBusy()then app.discoverStockRecipes()end
        if page.search:GetText()~=''then page.search:SetText('')end
    end
    page.stocks={}
    for _,row in ipairs(stocks)do page.stocks[row.id]=row end
    local needle=query(page.search:GetText())
    if not page.candidates or page.session~=app.active then
        page.candidates,page.pending=app.stockSearchCandidates(page.link,page.mode)
        page.session=app.active;page.unread=app.unreadStockProfessions()
    end
    local entry
    page.filtered={}
    for _,candidate in ipairs(page.candidates)do
        local current=page.stocks[candidate.id]
        if (page.link and candidate.id==page.link or not page.link and query(candidate.name):find(needle,1,true))
            and (page.mode or not page.lowOnly or current and current.missing and current.missing>0)then
            page.filtered[#page.filtered+1]=candidate
            if candidate.id==page.selected then entry=candidate end
        end
    end
    page.child:SetHeight(math.max(viewport,#page.filtered*rowHeight))
    local offset=math.min(page.scroll:GetVerticalScroll(),math.max(0,page.child:GetHeight()-viewport))
    if offset~=page.scroll:GetVerticalScroll()then page.scroll:SetVerticalScroll(offset)end
    drawRows(page)
    page.title:SetText(app.caption('stock_title'))
    page.overview:SetText(app.caption('stock_overview',#stocks,low))
    page.toggle:SetText(app.caption('stock_enable')..' · '..app.caption(app.options.stockRefill and 'enabled'or 'disabled'))
    page.add:SetText(app.caption(page.mode and 'stock_back'or 'stock_add'))
    page.searchLabel:SetText(app.caption('stock_search'))
    page.recipe:SetText(app.caption('stock_recipe_add'))
    page.merchant:SetText(app.caption('stock_merchant_add'));on(page.merchant,app.vendorPurchase.open)
    page.filter:SetText(app.caption(page.lowOnly and 'stock_low'or 'stock_all'));on(page.filter,not page.mode)
    page.read:SetText(page.unread~=''and app.caption('stock_read',page.unread)
        or #page.candidates==0 and not page.mode and app.caption('stock_read_first')or '')
    local headings={'stock_name','stock_bags','stock_goal','stock_missing'}
    for i,heading in ipairs(page.headings)do heading:SetText(app.caption(headings[i]))end
    page.empty:SetText(app.caption('stock_empty'));page.empty:SetShown(#page.filtered==0)
    page.help:SetText(page.notice or app.caption(page.mode and 'stock_search_tip'or 'stock_edit_tip'))
    local id=entry and entry.id
    local selected=id and page.stocks[id]
    local target=selected and selected.target
    if page.editID~=id then page.goal:ClearFocus();page.editID=id end
    page.detail:SetText(entry and entry.name or app.caption('stock_choose_row'))
    local quantity=selected or id and app.stockPosition(id,0,1)
    page.amount:SetText(entry and (app.caption('stock_bags')..' '..(quantity and quantity.bags or '?')..'  ·  '
        ..app.caption('stock_missing')..' '..(selected and selected.missing or selected and '?'or '–'))or '')
    page.goalLabel:SetText(app.caption('stock_goal'));page.save:SetText(app.caption('stock_save'))
    page.sourceTitle:SetText(app.caption('stock_sources'))
    for _,control in ipairs({page.goalLabel,page.goal,page.save,page.sourceTitle,page.sourceScroll})do control:SetShown(id~=nil)end
    if not page.goal:HasFocus()then page.goal:SetText(selected and tostring(selected.goal)or '')end
    drawSources(page,entry,target)
    local incomplete=page.sourceRecipe and not app.stockRecipeOutput(page.sourceRecipe)
    on(page.save,entry and not incomplete)
    if incomplete then page.help:SetText(app.caption('stock_recipe_incomplete'))end
    page.next:SetText(app.caption('stock_next'))
    local g=app.nextStepWindow
    local task=g and g.task
    local plan=g and g.plan
    local matches=selected and (task and task.kind=='stock_vendor'and task.offer.id==id
        or task and task.kind=='stock_open'and task.target.id==id
        or task and task.key=='stock_vendor_wait'and app.vendorPurchase.pending and app.vendorPurchase.pending.id==id
        or plan and plan.stock and plan.stock.id==id
        or plan and plan.poison and app.character.poisons.job and app.character.poisons.job.restock
           and app.character.poisons.job.outputs[selected.target.recipe]==id)
    if id and not matches and task and (task.kind=='stock_wait'or task.kind=='station')then
        local stock=app.guideStockPosition(plan,task)
        matches=stock and stock.id==id
    end
    page.guideReady=matches==true
    local startable=selected and (selected.missing or 0)>0 and app.stockTargetStartable(selected.target)
    local preview
    if matches then preview=g.primaryCTA:GetText()..'\n\n'..(task.body or '')
    elseif selected then
        if selected.missing==0 then preview=app.caption('ui_stock_full')
        elseif not app.options.stockRefill then preview=app.caption('stock_refill_off')
        elseif selected.target.recipe then preview=app.caption(startable and 'stock_craft_start'or 'stock_locked')
        else preview=app.caption('stock_need_vendor')end
    end
    page.preview:SetText(preview or '')
    page.action:SetText(app.caption(matches and 'stock_show_step'or 'stock_craft_start'))
    on(page.action,matches or startable);app.styleCTAButton(page.action,true)
    local extra=(page.sourceRecipe and page.sourceRecipe.profession==40 or target and target.profession==40)and app.isPoison()and app.poisonUnlocked()
    page.extraTitle:SetText(app.caption('stock_extra_hint'));page.extraTitle:SetShown(not not extra)
    page.extra:SetText(app.caption('stock_extra'));page.extra:SetShown(not not extra)
end
