-- Run from addon directory: lua Tests/spec.lua (Lua 5.1+, no WoW installation needed).
local passed=0
local function eq(actual,expected,label)
    assert(actual==expected,(label or 'equality')..': expected '..tostring(expected)..', received '..tostring(actual));passed=passed+1
end
local function near(actual,expected,label)assert(math.abs(actual-expected)<0.00001,(label or 'near')..': '..tostring(actual)..' ~= '..expected);passed=passed+1 end
unpack=unpack or table.unpack
-- UI surface mock: captures layout/text/scripts; not an in-game renderer.
local allFrames={}
local methods={}
local function object(kind,name,parent)
    local o={kind=kind,name=name,parent=parent,scripts={},shown=true,width=0,height=0,value=''}
    setmetatable(o,{__index=function(_,key)
        if kind=='EditBox'and key=='GetStringHeight'then return nil end
        return methods[key]
    end});allFrames[#allFrames+1]=o;return o
end
function methods:SetSize(w,h)self.width=w;self.height=h end
function methods:SetWidth(w)self.width=w end
function methods:GetWidth()return self.width end
function methods:GetSize()return self.width,self.height end
function methods:SetFontString(f)self.buttonFont=f end
function methods:SetNormalTexture(path)self.normalTexture=path end
function methods:SetPushedTexture(path)self.pushedTexture=path end
function methods:SetHighlightTexture(path)self.highlightTexture=path end
function methods:SetDisabledTexture(path)self.disabledTexture=path end
function methods:SetParent(parent)self.parent=parent end
function methods:SetFrameLevel(v)self.level=v end
function methods:GetFrameLevel()return self.level or 1 end

function methods:SetThumbTexture(t)self.thumbTexture=t end
function methods:SetOrientation(v)self.orientation=v end
function methods:GetScale()return self.appliedScale or 1 end
function methods:GetEffectiveScale()return self:GetScale()end
function methods:GetHeight()return self.height end
function methods:SetHeight(h)self.height=h end
function methods:SetText(value)self.value=tostring(value or '');if self.buttonFont then self.buttonFont.value=self.value end end
function methods:GetText()return self.value end
function methods:SetPoint(...)self.point={...}end
function methods:GetPoint()return unpack(self.point or {'CENTER',UIParent,'CENTER',0,0})end
function methods:GetScript(key)return self.scripts[key]end
function methods:SetScript(key,fn)self.scripts[key]=fn end
function methods:Show()self.shown=true end
function methods:Hide()self.shown=false end
function methods:IsShown()return self.shown end
function methods:SetScale(s)self.appliedScale=s end
function methods:CreateTexture(_,layer,_,sublevel)local t=object('Texture',nil,self);t.layer=layer;t.sublevel=sublevel;return t end
function methods:CreateFontString()return object('FontString',nil,self)end
function methods:GetStringHeight()local _,lines=self.value:gsub('\n','');return(lines+1+math.floor(#self.value/80))*14 end
function methods:GetNumLines()local _,n=self.value:gsub('\n','');return n+1+math.floor(#self.value/80)end
function methods:SetScrollChild(child)self.child=child end
function methods:RegisterEvent(name)self.registered=self.registered or {};self.registered[name]=true end
function methods:Enable()self.enabled=true end
function methods:Disable()self.enabled=false end
function methods:SetMinMaxValues(a,b)self.minimum=a;self.maximum=b end
function methods:SetValueStep(v)self.step=v end
function methods:SetObeyStepOnDrag()end
function methods:SetValue(v)self.sliderValue=v;if self.scripts.OnValueChanged then self.scripts.OnValueChanged(self,v)end end
for _,m in ipairs({'SetMultiLine','SetFont','SetJustifyH','SetJustifyV','SetWordWrap','SetTextColor','SetBackdrop','SetBackdropColor','SetBackdropBorderColor','SetClampedToScreen','SetMovable','EnableMouse','RegisterForDrag','SetFrameStrata','SetAllPoints','SetTexture','SetAlpha','SetColorTexture','SetAutoFocus','SetNumeric','ClearAllPoints','StartMoving','StopMovingOrSizing','SetFocus','ClearFocus','HighlightText'})do methods[m]=function()end end
function methods:SetAlpha(value)self.alpha=value end
function methods:SetTexture(path)self.texture=path end
function methods:SetAllPoints()self.full=true end
function methods:SetFont(file,size,flags)
    assert(type(file)=='string'and type(size)=='number'and type(flags)=='string','FontInstance:SetFont(fontFile, height, flags): explicit flags required')
    self.fontSize=size;self.fontFlags=flags
end
function methods:SetTextColor(r,g,b)self.textColour={r,g,b}end
function methods:SetBackdropColor(r,g,b,a)self.background={r,g,b,a}end
function methods:SetBackdropBorderColor(r,g,b)self.border={r,g,b}end
UIParent=object('Frame','UIParent');STANDARD_TEXT_FONT='Fonts\\FRIZQT__.TTF';SlashCmdList={}
function CreateFrame(kind,name,parent)return object(kind,name,parent)end
local faction='Horde';function UnitFactionGroup()return faction end
local locale='enUS';function GetLocale()return locale end
function UnitGUID()return 'test-character'end
function time()return 1 end
DEFAULT_CHAT_FRAME={AddMessage=function()end}
local prices,stock={},{}
Auctionator={API={v1={GetAuctionPriceByItemID=function(_,id)return prices[id]end}}}
C_Item={GetItemCount=function(id)return stock[id]end,GetItemNameByID=function(id)return 'Item '..id end}
local app={}
for _,file in ipairs({'Start.lua','Words.lua','FlowLog.lua','Data/Catalog.lua','Data/Names_en.lua','Data/Names_de.lua','Data/FactionAccess.lua','Data/VendorReagents.lua','Data/VendorLocations.lua','Data/TrainerLocations.lua','Access.lua','Client.lua','Inventory.lua','Merchants.lua','Trainers.lua','Economy.lua','RecipeAudit.lua','PlanningGoals.lua','Skin.lua','Themes.lua','Attention.lua','Screen.lua','Shopping.lua','VendorBuy.lua','MapPins.lua','CraftActions.lua','NextStep.lua','PurchaseState.lua','AuctionBridge.lua','Poisons.lua','OrderProgress.lua','Run.lua'})do
    local chunk,err=loadfile(file);assert(chunk,err);chunk('CraftDeja',app)
end
local function count(t)local n=0;for _ in pairs(t)do n=n+1 end;return n end
local function test(name,fn)local ok,err=pcall(fn);if not ok then error(name..' FAILED: '..err)end;print('PASS '..name)end
local profile={professionID=333,professionName='Enchanting',skillLevel=100,maxSkillLevel=150}
local live={}
C_TradeSkillUI={GetBaseProfessionInfo=function()return profile end,
GetAllRecipeIDs=function()local t={};for id in pairs(live)do t[#t+1]=id end;return t end,
GetRecipeInfo=function(id)return live[id]end,
GetRecipeSchematic=function(id)return live[id]and live[id].schematic end,
GetRecipeCooldown=function(id)local r=live[id];return r.cooldown or 0,false,r.charges end}
local function info(name,band,learned,ingredients)
    local slots={};for id,n in pairs(ingredients or {})do slots[#slots+1]={required=true,reagentType=1,quantityRequired=n,reagents={{itemID=id}}}end
    return{name=name,relativeDifficulty=band,learned=learned~=false,canSkillUp=band~=3,schematic={reagentSlotSchematics=slots}}
end
local function scan()
    app.active=app.readRecipes(app.readProfession());app.sessions[app.active.profile.id]=app.active
    app.decision,app.problem=app.decide(app.marketView(app.active));return app.decision
end
local original7748=app.copy(app.accessData[7748])
local function fixtures(skill)
    app.accessData[7748]=app.copy(original7748);app.accessData[7748].access='Both'
    app.options.unverifiedSources=false;faction='Horde'
    profile={professionID=333,professionName='Enchanting',skillLevel=skill or 100,maxSkillLevel=150}
    prices={[10940]=88,[10938]=96};stock={[10940]=1,[10938]=3}
    live={[7426]=info('Enchant Chest - Minor Absorption',(skill or 100)>=110 and 2 or 1,true,{[10938]=1}),[7748]=info('Enchant Chest - Lesser Health',(skill or 100)>=105 and 1 or 0,true,{[10938]=1,[10940]=1})}
    app.sessions={};app.options.green=true;app.options.prices='auto'
end
app.events.scripts.OnEvent(app.events,'ADDON_LOADED','CraftDeja')
test('first login guide, dismiss and reopen without repeated popups',function()
    eq(app.options.guideSeenV1,false);eq(app.main.guideVisible,true)
    app.events.scripts.OnEvent(app.events,'PLAYER_ENTERING_WORLD')
    eq(app.main:IsShown(),true);eq(app.main.guide:IsShown(),true);eq(app.main.adviser:IsShown(),false)
    eq(app.main.recipes:IsShown(),false);eq(app.main.guide.start:IsShown(),true)
    assert(app.main.guide.requirements:GetText():find('Auctionator OR TSM',1,true))
    app.main.guide.start.scripts.OnClick()
    eq(app.options.guideSeenV1,true);eq(app.main.guideVisible,false);eq(app.main.adviser:IsShown(),true)
    eq(app.main.guide.start:IsShown(),false);eq(app.main.recipes:IsShown(),true)
    app.main:Hide();app.guideAutoShown=nil
    app.events.scripts.OnEvent(app.events,'PLAYER_ENTERING_WORLD');eq(app.main:IsShown(),false)
    app.command('help');eq(app.main:IsShown(),true);eq(app.main.guideVisible,true)
    app.command('lang de');eq(app.main.help:GetText(),'Berater')
    assert(app.main.guide.steps[2].body:GetText():find('automatisch',1,true))
    assert(app.main.guide.steps[5].body:GetText():find('Post abholen',1,true))
    app.main.help.scripts.OnClick();eq(app.main.guideVisible,false)
    eq(app.main.help:GetText(),'Leitfaden')
    app.main.help.scripts.OnClick();eq(app.main.guideVisible,true)
    app.command('lang en');eq(app.main.help:GetText(),'Adviser')
    eq(app.main.guide.steps[1].title:GetText(),'Open your profession')
    app.showGuide(false);app.initialize();eq(app.options.guideSeenV1,true);app.command('lang auto')
end)
test('catalogue and translations',function()
    eq(SLASH_CRAFTDEJA1,'/cdj');eq(SLASH_CRAFTDEJA2,'/craftdeja');eq(SLASH_CRAFTDEJA3,'/edj')
    eq(_G.CraftDeja,app);eq(app.main.title:GetText(),'CraftDeja')
    eq(count(app.catalog[333]),262);eq(count(app.catalog[171]),195)
    local n=0;for _,p in ipairs(app.professionOrder)do n=n+count(app.catalog[p])end;eq(n,2508)
    eq(app.catalog[333][7426].yellow,90);eq(app.catalog[333][7426].green,110);eq(app.catalog[333][7748].yellow,105)
    eq(app.catalog[171][2329].yellow,55);eq(app.catalog[171][2329].green,75);eq(app.catalog[171][2329].grey,95)
    for key in pairs(app.words.en)do assert(app.words.de[key],key)end
    for key in pairs(app.words.de)do assert(app.words.en[key],key)end
    locale='deDE';eq(app.lang(),'de');eq(app.professionName(171),'Alchemie')
    app.command('lang en');eq(app.lang(),'en');eq(app.professionName(171),'Alchemy');eq(app.caption('now'),'CRAFT NOW')
    app.command('lang auto');locale='enUS'
    eq(app.recipeName({id=2329}),app.names.en[2329])
end)
test('German profession fallback and isolation',function()
    profile={professionName='Alchemie',skillLevel=40,maxSkillLevel=75};eq(app.readProfession().id,171)
    profile={professionName='Verzauberkunst',skillLevel=40,maxSkillLevel=75};eq(app.readProfession().id,333)
    profile={professionID=356,professionName='Fishing'};eq(app.readProfession(),nil)
end)
test('yellow beats twice-priced orange',function()
    fixtures(100);local d=scan();eq(d.current.recipe.id,7426);eq(d.current.colour,'yellow');near(d.current.chance,0.75);near(d.current.unitSkill,128)
    near(d.snapshot.quotes[7748].cost,184)
    eq(d.stop,110);local p=app.materialPlan(d.current.recipe,150);eq(p.target,110);eq(p.capped,true);eq(p.estimated,true)
    eq(p.rows[1].id,10938);eq(p.rows[1].buy,p.crafts-3)
end)
test('green exception and fixed limit',function()
    fixtures(110);prices[10938]=94;prices[10940]=88;local d=scan()
    eq(d.current.recipe.id,7426);eq(d.current.colour,'green');near(d.current.chance,0.5);near(d.current.unitSkill,188);eq(d.current.greenExtra,true)
    -- The yellow alternative costs 182/0.875=208; green is cheaper now, but not at 114.
    eq(d.stop,114);eq(d.followup.candidate.recipe.id,7748)
    local p=app.materialPlan(d.current.recipe,150);eq(p.target,114)
    app.options.green=false;d=scan();eq(d.current.recipe.id,7748)
    fixtures(115);prices[10938]=1;prices[10940]=100000;d=scan();eq(d.current.recipe.id,7748)
end)
test('ties prefer higher chance',function()
    fixtures(110);prices[10938]=70;prices[10940]=52.5
    local d=scan();eq(d.current.recipe.id,7748)
end)
test('unlearned and unconfirmed stay separate',function()
    fixtures(100);live[7748].learned=false;prices[10940]=1;prices[10938]=100
    local d=scan();eq(d.current.recipe.id,7426);eq(d.followup.candidate.recipe.id,7748);eq(d.followup.candidate.needsLearning,true);eq(d.stop,101)
    live={};d=scan();eq(d,nil);eq(app.problem,'none')
end)
test('reference-hidden unlearned recipe is never a learning hint',function()
    fixtures(100);live[7748].learned=false;prices[10940]=1;prices[10938]=100
    app.active=app.readRecipes(app.readProfession());app.active.recipes[7748].referenceHidden=true
    local known,learn=app.selectionAt(app.marketView(app.active),100,true);eq(known.recipe.id,7426);eq(learn,nil)
    app.active.recipes[7748].learned=true;known=app.selectionAt(app.marketView(app.active),100,true);eq(known.recipe.id,7748)
end)
test('missing prices and vendor buy unit',function()
    fixtures(100);prices={};local d=scan();eq(d,nil);eq(app.problem,'no_prices')
    function GetMerchantNumItems()return 2 end
    function GetMerchantItemLink(slot)return 'item:'..(slot==1 and 3371 or 3372)end
    function GetMerchantItemInfo(slot)return 'Vial',nil,100,5,-1,true,slot==2 end
    app.observeMerchant();near(app.unitPrice(3371,{}),20);near(app.unitPrice(3372,{}),app.vendorReagents[3372].Horde)
    prices[3371]=30;near(app.unitPrice(3371,{}),20)
    Auctionator.API.v1.GetAuctionPriceByItemID=function(_,id)return prices[id]end
    app.options.prices='tsm';eq(app.unitPrice(10938,{}),nil)
    TSM_API={GetCustomPriceValue=function(source,item)eq(source,'DBMinBuyout');if item=='i:10938'then return 55 end end}
    near(app.unitPrice(10938,{}),55);TSM_API=nil;app.options.prices='auto'
end)
test('alchemy live materials, cooldowns and charges',function()
    profile={professionID=171,professionName='Alchemy',skillLevel=35,maxSkillLevel=75}
    prices={[765]=5,[2447]=8,[3371]=20,[2449]=40};stock={[765]=2,[2447]=0,[3371]=0,[2449]=0}
    live={[2329]=info('Elixir of Minor Strength',0,true,{[765]=1,[2449]=1,[3371]=1}),[2331]=info('Minor Mana Potion',0,true,{[765]=1,[2447]=1,[3371]=1})}
    live[2331].cooldown=120;app.sessions={};local d=scan();eq(d.profile.id,171);eq(d.current.recipe.id,2329)
    live[2331].charges=1;d=scan();eq(d.current.recipe.id,2331)
    eq(d.snapshot.quotes[2331].cost,33);eq(d.current.recipe.materialsFromClient,true)
    for _,r in pairs(app.active.recipes)do eq(r.profession,171)end
    local old=app.referenceRecipe(333,7426);local p,why=app.materialPlan(old,40);eq(p,nil);eq(why,'other_prof')
end)
test('client colour conflicts limit bulk',function()
    fixtures(100);live[7426].relativeDifficulty=2
    local d=scan();eq(app.active.recipes[7426].rangeConflict,true);eq(d.current.recipe.id,7748)
    live[7748]=nil;d=scan();eq(d,nil)
end)
test('observed transition corrects threshold',function()
    fixtures(89);live[7426].relativeDifficulty=0;scan()
    profile.skillLevel=90;live[7426].relativeDifficulty=1;scan()
    eq(app.character.transitions[333][7426].yellow,90)
    eq(app.active.recipes[7426].observed,true)
end)
test('alternative reagents, inventory unknown and target validation',function()
    fixtures(100);scan();local r=app.active.recipes[7426]
    r.groups={{amount=2,choices={10940,10938}}};local q=app.quote(r,{});eq(q.cost,176);eq(q.inputs[1].item,10940)
    stock={};local p=app.materialPlan(r,'invalid');eq(p.stockKnown,false)
    local none,why=app.materialPlan(r,90);eq(none,nil);eq(why,'target_low')
end)
test('live-only recipe uses client and bounded material estimate',function()
    fixtures(100);live={[999999]=info('New Forever Recipe',0,true,{[10938]=2})}
    local d=scan();eq(d.current.recipe.id,999999);eq(d.stop,101)
    local p=app.materialPlan(d.current.recipe,120);eq(p.target,101);eq(p.crafts,1)
    eq(app.recipeName(d.current.recipe),'New Forever Recipe')
end)
test('all UI panels, search, scaling and language refresh',function()
    fixtures(100);app.refresh(true);app.main:Show();app.showCatalogue();eq(app.catalogWindow.profession,333)
    app.catalogWindow.search:SetText('7426');app.renderCatalogue();eq(app.catalogWindow.rows[1].recipe.id,7426)
    app.showDetails(app.decision.current.recipe,true);eq(app.detailsWindow:IsShown(),true)
    app.showOptions();app.command('scale 65');near(app.main.appliedScale,.65);near(app.detailsWindow.appliedScale,.65);near(app.catalogWindow.appliedScale,.65);near(app.optionsWindow.appliedScale,.65)
    app.command('lang de');eq(app.main.now:GetText(),'JETZT HERSTELLEN');app.command('lang en');eq(app.main.now:GetText(),'CRAFT NOW')
    assert(app.detailsWindow.body:GetText():find('Recipe acquisition costs extra',1,true))
    app.command('scale 20');near(app.main.appliedScale,.5);app.command('scale 200');near(app.main.appliedScale,1.4)
    eq(app.detailsWindow.url:GetText(),app.recipeURL(app.active.recipes[7426]))
end)
test('events reprice failed skill-up and never reopen closed window',function()
    fixtures(100);local reads=0;local original=C_TradeSkillUI.GetAllRecipeIDs
    C_TradeSkillUI.GetAllRecipeIDs=function()reads=reads+1;return original()end
    local event=app.events.scripts.OnEvent;local tick=app.events.scripts.OnUpdate
    event(app.events,'TRADE_SKILL_SHOW');tick(app.events,.21);eq(app.main:IsShown(),true);local n=reads
    prices[10938]=500;prices[10940]=1;event(app.events,'UNIT_SPELLCAST_SUCCEEDED','player');tick(app.events,.21);eq(reads,n+1)
    eq(app.active.profile.skill,100);eq(app.decision.snapshot.quotes[7426].cost,500)
    app.main:Hide();app.options.visible=false;event(app.events,'BAG_UPDATE_DELAYED');tick(app.events,.21);eq(app.main:IsShown(),false)
    n=reads;tick(app.events,3.1);eq(reads,n+1);eq(app.main:IsShown(),false)
    event(app.events,'TRADE_SKILL_CLOSE');n=reads;tick(app.events,4);eq(reads,n);eq(app.main:IsShown(),false)
end)
test('all catalogue records audited and Kaldorei acquisition corrected',function()
    local records,missing=0,0
    for _,prof in ipairs(app.professionOrder)do
        for id in pairs(app.catalog[prof])do records=records+1;if not app.accessData[id]then missing=missing+1 end end
    end
    eq(records,2508);eq(missing,0)
    local r=app.referenceRecipe(185,6412)
    eq(app.accessInfo(r).access,'Alliance');eq(app.accessInfo(r).use,'Both')
    eq(app.origin(r),'Quest');eq(app.recipeURL(r),'https://www.wowhead.com/forever/item=5482')
    local q=app.sourceList(r)[1];eq(q.kind,'quest');eq(q.id,4161);eq(q.side,'Alliance')
    eq(app.sourceURL(q),'https://www.wowhead.com/forever/quest=4161')
end)
test('Horde cooking never suggests the Alliance quest recipe',function()
    profile={professionID=185,professionName='Cooking',skillLevel=62,maxSkillLevel=75}
    faction='Horde';app.options.unverifiedSources=false;app.sessions={}
    prices={[5466]=22,[5465]=3};stock={}
    live={[6413]=info('Scorpid Surprise',1,true,{[5466]=1}),[6412]=info('Kaldorei Spider Kabob',1,false,{[5465]=1})}
    local d=scan();eq(d.current.recipe.id,6413);eq(app.nextRecipe(),nil)
    local allowed,reason=app.canRecommend(app.active.recipes[6412]);eq(allowed,false);eq(reason,'faction_source_blocked')
    app.options.unverifiedSources=true;d=scan();eq(app.nextRecipe(),nil)
    faction='Alliance';d=scan();eq(app.nextRecipe().id,6412)
    local q=app.nextRecipe();app.refreshUI();eq(app.main.nextDetails:IsShown(),true)
    app.main.nextDetails.scripts.OnClick();eq(app.detailsWindow.recipe.id,6412)
    eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/item=5482')
    app.detailsWindow.sourcePage.scripts.OnClick();eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/quest=4161')
    app.detailsWindow.sourcePage.scripts.OnClick();eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/npc=6286')
    app.detailsWindow.craftPage.scripts.OnClick();eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/spell=6412')
    app.detailsWindow.recipePage.scripts.OnClick();eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/item=5482')
end)
test('already learned tradeable recipe remains usable across source faction',function()
    faction='Horde';live[6412].learned=true;app.options.unverifiedSources=false
    local d=scan();eq(d.current.recipe.id,6412);eq(app.canRecommend(d.current.recipe),true)
    app.refreshUI();eq(app.main.nextDetails:IsShown(),false)
    app.main.currentDetails.scripts.OnClick();eq(app.detailsWindow.recipe.id,6412)
end)
test('hard use restriction and unknown source safeguards',function()
    faction='Horde';local id=999111
    local r={id=id,learned=false};app.accessData[id]={use='Both',access='Unknown'}
    local ok,why=app.canRecommend(r);eq(ok,false);eq(why,'access_unknown')
    app.options.unverifiedSources=true;eq(app.canRecommend(r),true)
    app.accessData[id]={use='Alliance',access='Alliance'};eq(app.canRecommend(r),false)
    r.learned=true;eq(app.canRecommend(r),false)
    app.accessData[id]={use='Both',access='Alliance'};eq(app.canRecommend(r),true)
    r.learned=false;eq(app.canRecommend(r),false)
    app.accessData[id]={use='Both',access='Horde'};eq(app.canRecommend(r),true)
    faction='Alliance';eq(app.canRecommend(r),false)
    app.accessData[id]=nil;app.options.unverifiedSources=false
end)
test('faction catalogue filter and untranslated source links remain selectable',function()
    faction='Horde';live[6412].learned=false;scan();app.showCatalogue()
    local f=app.catalogWindow;f.profession=185;f.factionOnly=true;f.search:SetText('6412');app.renderCatalogue()
    eq(f.rows[1]:IsShown(),false)
    f.faction.scripts.OnClick();eq(f.rows[1].recipe.id,6412)
    app.showDetails(f.rows[1].recipe,false);app.command('lang de')
    eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/de/item=5482')
    app.detailsWindow.sourcePage.scripts.OnClick();eq(app.detailsWindow.url:GetText(),'https://www.wowhead.com/forever/de/quest=4161')
    assert(app.detailsWindow.body:GetText():find('Allianz',1,true))
    app.command('lang en')
end)
test('source links prioritize friendly routes without mutating the catalogue',function()
    faction='Horde';local id=999112
    app.accessData[id]={use='Both',access='Both',routes={{kind='vendor',id=1,name='Alliance merchant',side='Alliance'},{kind='vendor',id=2,name='Horde merchant',side='Horde'},{kind='quest',id=3,name='Neutral quest',side='Both'}}}
    local routes=app.sourceList({id=id});eq(routes[1].id,3);eq(routes[2].id,2);eq(routes[3].id,1)
    eq(app.accessData[id].routes[1].id,1);eq(app.sourceURL(routes[2]),'https://www.wowhead.com/forever/npc=2')
    app.accessData[id]=nil
end)

-- Full scans are distinct from database updates / search result refreshes.
local now=100
GetTime=function()return now end
local scanEvents={ScanStart='test_start',ScanComplete='test_complete',ScanFailed='test_failed'}
local listeners={}
local submitted,searchFails
local function shoppingAPI()
    listeners={}
    Auctionator.FullScan={Events=scanEvents}
    Auctionator.EventBus={Register=function(_,listener,events)listeners[#listeners+1]=listener end}
    Auctionator.API.v1.MultiSearchAdvanced=function(caller,terms)
        assert(caller=='CraftDeja');if searchFails then error('search failure')end
        submitted=terms
    end
    app.bindShopping()
end
local function emit(event,data)for _,listener in ipairs(listeners)do listener:ReceiveEvent(event,data)end end
local function auction(id,unit,quantity,legacy)
    local info={[3]=quantity or 10,[10]=unit*(quantity or 10)}
    return{itemLink='|Hitem:'..id..':0|h[Item]|h',replicateInfo=not legacy and info or nil,auctionInfo=legacy and info or nil}
end
local function fullscan(data)
    emit(scanEvents.ScanStart);emit(scanEvents.ScanComplete,data or {auction(10938,96),auction(10940,88)})
end
-- These legacy scenarios intentionally use the retained manual skill target.
local function beginShopping()
    app.shopping.goal='manual'
    app.craftBatch=nil;app.character.ahPurchase=nil;app.ahOrder=nil;app.character.ahMail={}
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
    app.shopping.ready=nil;app.shopping.prices=nil;app.shopping.notice=nil;app.shopping.searched=nil
    fixtures(100);scan();shoppingAPI();submitted=nil;searchFails=false
    app.shopping.points=5;app.shopping.tolerance=10
    app.shoppingEvent('AUCTION_HOUSE_SHOW')
end
test('shopping remains closed until full scan, with exact event registration',function()
    beginShopping();eq(app.shoppingFresh(),nil)
    app.requestShopping();eq(app.shoppingWindow,nil)
    emit('prices_processed');eq(app.shoppingFresh(),nil)
    emit(scanEvents.ScanComplete,{auction(10938,96)});eq(app.shoppingFresh(),nil)
    emit(scanEvents.ScanStart);eq(app.shopping.started,app.shopping.epoch)
    emit(scanEvents.ScanFailed);eq(app.shoppingFresh(),nil)
    eq(app.shopping.reason,'shop_scan_failed')
    fullscan();eq(app.shoppingFresh(),true);eq(app.shoppingWindow:IsShown(),true)
    eq(app.shoppingWindow.slider.minimum,1);eq(app.shoppingWindow.slider.maximum,50)
    local p=app.shoppingPlan(5);eq(p.from,100);eq(p.target,105);eq(p.crafts,8)
    eq(p.rows[1].buy,5);eq(p.rows[1].maxUnit,105);eq(p.ahTotal,525)
    fullscan();eq(#listeners,1)
end)
test('shopping uses current full-scan prices, never old cache or TSM absent entries',function()
    beginShopping();prices[10938]=1;prices[10940]=1
    fullscan({auction(10938,1000),auction(10940,2),auction(10938,500)})
    eq(app.unitPrice(10938),500)
    app.options.prices='tsm';TSM_API={GetCustomPriceValue=function()return 1 end}
    eq(app.unitPrice(10938),500)
    fullscan({auction(10940,2)})
    eq(app.unitPrice(10938),nil);eq(app.decision,nil)
    eq(app.shoppingWindow.buy.enabled,false)
    TSM_API=nil;app.options.prices='auto'
end)
test('scan cancellation, malformed results, close and expiry invalidate shopping',function()
    beginShopping();fullscan();eq(app.shoppingWindow:IsShown(),true)
    emit(scanEvents.ScanStart);eq(app.shoppingWindow:IsShown(),false)
    emit(scanEvents.ScanComplete,{{bad=true}});eq(app.shoppingFresh(),nil)
    fullscan();app.shoppingEvent('AUCTION_HOUSE_CLOSED')
    eq(app.shoppingFresh(),false);eq(app.shoppingWindow:IsShown(),false)
    app.shoppingEvent('AUCTION_HOUSE_SHOW');emit(scanEvents.ScanComplete,{auction(10938,96)})
    eq(app.shoppingFresh(),true)
    fullscan();now=now+1801;app.shoppingPoll()
    eq(app.shoppingFresh(),nil);eq(app.shopping.reason,'shop_stale');eq(app.shoppingWindow:IsShown(),false)
    eq(app.searchShopping(),false)
    fullscan({});eq(app.shoppingFresh(),true);eq(app.decision,nil)
end)
test('search hands exact quantities and copper ceilings to Auctionator and blocks duplicates',function()
    beginShopping();fullscan();local mainShown=app.main:IsShown();eq(app.searchShopping(),true)
    eq(#submitted,1);eq(submitted[1].searchString,'Item 10938')
    eq(submitted[1].isExact,true);eq(submitted[1].quantity,5);eq(submitted[1].maxPrice,105)
    eq(app.shoppingWindow:IsShown(),false);eq(app.main:IsShown(),mainShown)
    eq(app.searchShopping(),false)
    app.requestShopping();eq(app.shoppingWindow:IsShown(),true)
    eq(app.shoppingWindow.buy.enabled,false)
    app.shoppingWindow.unlock.scripts.OnClick();eq(app.shopping.searched,nil)
    app.shopping.tolerance=0;eq(app.searchShopping(),true);eq(submitted[1].maxPrice,96)
    fullscan({auction(10938,.05,20),auction(10940,88)})
    eq(app.searchShopping(),true);near(submitted[1].maxPrice,.05);eq(app.money(.05),'<1c')
end)
test('inventory is rechecked at handoff; unknown stock, vendor inputs and failures',function()
    beginShopping();fullscan();stock[10938]=7
    eq(app.searchShopping(),true);eq(submitted[1].quantity,1)
    fullscan();stock[10938]=nil;eq(app.searchShopping(),false)
    stock[10938]=100;eq(app.searchShopping(),false)
    stock[10938]=0;searchFails=true;eq(app.searchShopping(),false);eq(app.shopping.searched,nil)
    searchFails=false;app.character.vendor[10938]={unit=10}
    app.refresh(false);local p=app.shoppingPlan(5)
    eq(p.rows[1].vendor,true);eq(p.ahRows,0);eq(p.vendorTotal,80);eq(app.searchShopping(),false)
    app.character.vendor[10938]=nil
end)
test('skill target slider caps at recipe switches and fixed green limit',function()
    beginShopping();fullscan()
    app.shoppingWindow.slider:SetValue(50);eq(app.shopping.points,50)
    local p=app.shoppingPlan(50);eq(p.target,110);eq(p.capped,true)
    fixtures(110);scan();fullscan({auction(10938,94),auction(10940,88)})
    p=app.shoppingPlan(50);eq(p.target,114)
    app.options.green=false;app.refresh(false);p=app.shoppingPlan(50)
    assert(p.recipe.id~=7426);assert(p.target<=p.recipe.green)
    app.applyScale(.7);eq(app.shoppingWindow.appliedScale,.7)
    app.command('lang de');app.renderShopping();assert(app.shoppingWindow.title:GetText():find('Einkauf',1,true))
    assert(app.shoppingWindow.goal:GetText():find('Skillpunkte',1,true))
    app.command('lang en')
end)
test('legacy full-scan payload and incompatible API fail closed',function()
    beginShopping();fullscan({auction(10938,96,10,true),auction(10940,88,10,true)})
    eq(app.unitPrice(10938),96);eq(app.shoppingFresh(),true)
    emit(scanEvents.ScanStart);emit(scanEvents.ScanComplete,nil)
    eq(app.shoppingFresh(),nil);eq(app.shopping.reason,'shop_incompatible')
    fullscan();Auctionator.API.v1.MultiSearchAdvanced=nil
    eq(app.searchShopping(),false)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');Auctionator.FullScan=nil
    eq(app.bindShopping(),false)
end)
test('shopping preserves profession at AH and invalidates a queued craft',function()
    fixtures(100);scan();shoppingAPI()
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
    local getIDs=C_TradeSkillUI.GetAllRecipeIDs
    C_TradeSkillUI.GetAllRecipeIDs=function()return {}end
    app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_SHOW');fullscan()
    eq(app.active.confirmed,2);eq(app.decision.current.recipe.id,7426)
    C_TradeSkillUI.GetAllRecipeIDs=getIDs
    local getProfile=C_TradeSkillUI.GetBaseProfessionInfo
    C_TradeSkillUI.GetBaseProfessionInfo=function()return nil end
    app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_SHOW');fullscan()
    eq(app.shoppingFresh(),true);assert(app.active)
    local p=app.shoppingPlan(5);assert(p)
    stock[10938]=30;app.events.scripts.OnEvent(app.events,'BAG_UPDATE_DELAYED')
    p=app.shoppingPlan(5);eq(p.rows[1].buy,0)
    app.events.scripts.OnEvent(app.events,'SKILL_LINES_CHANGED')
    eq(app.active.confirmed,2);assert(app.shoppingPlan(5))
    app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_SUCCEEDED','player','cast-guid',7426)
    eq(app.active.invalidated,true);eq(app.decision,nil);eq(app.shoppingWindow.buy.enabled,false)
    app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_CLOSED')
    C_TradeSkillUI.GetBaseProfessionInfo=getProfile
end)

test('profession close keeps only the guide while retaining AH planning across panel event order',function()
    local event=app.events.scripts.OnEvent;local tick=app.events.scripts.OnUpdate
    for _,closeFirst in ipairs({true,false})do
        app.shoppingEvent('AUCTION_HOUSE_CLOSED');fixtures(100)
        event(app.events,'TRADE_SKILL_SHOW');tick(app.events,.21)
        eq(app.main:IsShown(),true);local saved=app.active
        local getProfile=C_TradeSkillUI.GetBaseProfessionInfo
        local reads=0
        C_TradeSkillUI.GetBaseProfessionInfo=function()reads=reads+1;return nil end
        if closeFirst then event(app.events,'TRADE_SKILL_CLOSE');event(app.events,'AUCTION_HOUSE_SHOW')
        else event(app.events,'AUCTION_HOUSE_SHOW');tick(app.events,.25);event(app.events,'TRADE_SKILL_CLOSE')end
        tick(app.events,3.2)
        eq(app.main:IsShown(),false);eq(app.nextStepWindow:IsShown(),true);eq(app.active,saved);eq(app.professionOpen,false)
        event(app.events,'SKILL_LINES_CHANGED');eq(app.active,saved)
        fullscan();eq(app.shoppingWindow:IsShown(),closeFirst)
        app.requestShopping();eq(app.shoppingWindow:IsShown(),true)
        eq(app.shoppingPlan(5).recipe.id,7426)
        app.command('refresh');eq(app.active,saved)
        stock[10938]=0;eq(app.searchShopping(),true)
        eq(app.main:IsShown(),false);eq(reads,0)
        eq(submitted[1].quantity,8)
        C_TradeSkillUI.GetBaseProfessionInfo=getProfile
        event(app.events,'AUCTION_HOUSE_CLOSED')
    end
end)
test('manual hide is respected at AH and a new profession replaces the cached one',function()
    local event=app.events.scripts.OnEvent;local tick=app.events.scripts.OnUpdate
    fixtures(100);event(app.events,'TRADE_SKILL_SHOW');tick(app.events,.21)
    app.command('');eq(app.main:IsShown(),false)
    event(app.events,'TRADE_SKILL_CLOSE');event(app.events,'AUCTION_HOUSE_SHOW')
    eq(app.main:IsShown(),false);eq(app.active.profile.id,333)
    app.command('');eq(app.main:IsShown(),true);eq(app.active.profile.id,333)
    event(app.events,'AUCTION_HOUSE_CLOSED')
    profile={professionID=171,professionName='Alchemy',skillLevel=1,maxSkillLevel=75}
    prices={[765]=5,[2447]=8,[3371]=20};stock={}
    live={[2329]=info('Elixir of Minor Strength',0,true,{[765]=1,[2447]=1,[3371]=1})}
    event(app.events,'TRADE_SKILL_SHOW');tick(app.events,.21)
    eq(app.active.profile.id,171);eq(app.active.profile.skill,1)
    event(app.events,'TRADE_SKILL_CLOSE');event(app.events,'AUCTION_HOUSE_SHOW')
    fullscan({auction(765,5),auction(2447,8),auction(3371,20)})
    local plan=app.shoppingPlan(5);eq(plan.recipe.id,2329);eq(#plan.rows,3)
    eq(app.active.profile.id,171)
    event(app.events,'AUCTION_HOUSE_CLOSED')
end)
test('summary full scan is recognized, generic updates are excluded and status is visible',function()
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');beginShopping()
    Auctionator.IncrementalScan={Events={ScanStart='summary_start',ScanComplete='summary_complete',ScanFailed='summary_failed',PricesProcessed='summary_prices'}}
    app.bindShopping()
    app.requestShopping();assert(app.main.note:GetText():lower():find('scan',1,true))
    emit('summary_prices');eq(app.shoppingFresh(),nil)
    emit('summary_complete',{});eq(app.shoppingFresh(),nil)
    emit('summary_start');eq(app.shoppingFresh(),nil)
    assert(app.main.note:GetText():find('running',1,true))
    local data={{itemKey={itemID=10938,battlePetSpeciesID=0},minPrice=96,totalQuantity=100},
      {itemKey={itemID=10940,battlePetSpeciesID=0},minPrice=88,totalQuantity=30},
      {itemKey={itemID=10938,battlePetSpeciesID=0},minPrice=99,totalQuantity=200},
      {itemKey={itemID=0,battlePetSpeciesID=44},minPrice=10000,totalQuantity=1}}
    emit('summary_complete',data)
    eq(app.shoppingFresh(),true);eq(app.shoppingWindow:IsShown(),true)
    eq(app.unitPrice(10938),96);eq(app.shoppingPlan(5).rows[1].buy,5)
    assert(app.main.note:GetText():find('scan valid',1,true))
    eq(app.searchShopping(),true);eq(submitted[1].quantity,5);eq(submitted[1].maxPrice,105)
    emit('summary_start');emit('summary_failed')
    eq(app.shoppingFresh(),nil);assert(app.main.note:GetText():find('failed',1,true))
    emit('summary_start');emit(scanEvents.ScanComplete,{auction(10938,1)})
    eq(app.shoppingFresh(),nil)
    emit('summary_complete',{{itemKey={itemID=10938},minPrice='bad',totalQuantity=1}})
    eq(app.shoppingFresh(),nil);eq(app.shopping.reason,'shop_incompatible')
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('summary-only Auctionator binding and visible missing dependency feedback',function()
    beginShopping();Auctionator.FullScan=nil
    app.shopping.bus=nil;eq(app.bindShopping(),true)
    emit('summary_start');emit('summary_complete',{{itemKey={itemID=10938},minPrice=96,totalQuantity=2}})
    eq(app.shoppingFresh(),true);eq(app.unitPrice(10938),96)
    app.shoppingWindow:Hide();Auctionator.API.v1.MultiSearchAdvanced=nil
    app.requestShopping();eq(app.shoppingWindow:IsShown(),false)
    assert(app.main.note:GetText():find('requires Auctionator',1,true))
    app.command('lang de');app.requestShopping()
    assert(app.main.note:GetText():find('benötigt Auctionator',1,true))
    app.command('lang en');app.shoppingEvent('AUCTION_HOUSE_CLOSED');Auctionator.IncrementalScan=nil
end)
local function vialPlanSetup()
    app.shopping.goal='manual'
    app.craftBatch=nil;app.character.ahPurchase=nil;app.ahOrder=nil;app.character.ahMail={}
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');fixtures(100)
    app.character.vendor[3371]=nil;app.character.vendor[3372]=nil
    profile={professionID=171,professionName='Alchemy',skillLevel=1,maxSkillLevel=75}
    live={[2329]=info('Elixir of Minor Strength',0,true,{[765]=1,[2447]=1,[3371]=1})}
    prices={[765]=5,[2447]=8,[3371]=5};stock={[765]=11,[2447]=7,[3371]=0}
    app.sessions={};scan();shoppingAPI();submitted=nil
    app.shopping.points=5;app.shopping.tolerance=20;app.shoppingEvent('AUCTION_HOUSE_SHOW')
    fullscan({auction(765,5),auction(2447,8),auction(3371,5)})
end
test('ordinary merchant references exclude expensive vials and explain owned herbs',function()
    vialPlanSetup();eq(count(app.vendorReagents),41)
    near(app.vendorPrice(3371),3.4)
    local p=app.shoppingPlan(5);eq(p.crafts,5);eq(p.ahRows,0);eq(p.vendorRows,1);eq(p.ownedRows,2)
    eq(p.rows[1].id,765);eq(p.rows[1].buy,0);eq(p.rows[2].buy,0)
    eq(p.rows[3].id,3371);eq(p.rows[3].buy,5);eq(p.rows[3].vendor,true)
    eq(p.rows[3].vendorKind,'reference');near(p.vendorTotal,17)
    app.renderShopping();assert(app.shoppingWindow.summary:GetText():find('0 AH',1,true))
    eq(app.searchShopping(),false);eq(submitted,nil)
    assert(app.main.note:GetText():find('Only vendor materials',1,true))
    fullscan({auction(765,5),auction(2447,8)});eq(app.shoppingPlan(5).vendorRows,1)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('all missing herbs are handed off together; vendor reagent stays separate',function()
    vialPlanSetup();stock={[765]=0,[2447]=0,[3371]=0}
    eq(app.searchShopping(),true);eq(#submitted,2)
    eq(submitted[1].searchString,'Item 765');eq(submitted[1].quantity,5)
    eq(submitted[2].searchString,'Item 2447');eq(submitted[2].quantity,5)
    eq(app.shopping.sentSummary.ah,2);eq(app.shopping.sentSummary.vendor,1);eq(app.shopping.sentSummary.owned,0)
    assert(app.main.note:GetText():find('Sent to Auctionator: 2',1,true))
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('cheaper AH vials have a strict vendor ceiling even with tolerance',function()
    vialPlanSetup()
    function GetMerchantNumItems()return 1 end
    function GetMerchantItemLink()return 'item:3371'end
    function GetMerchantItemInfo()return 'Empty Vial',nil,20,5,-1,true,false end
    app.observeMerchant();near(app.vendorPrice(3371),4)
    fullscan({auction(765,5),auction(2447,8),auction(3371,3.9,100)})
    local p=app.shoppingPlan(5);eq(p.vendorRows,0);eq(p.ahRows,1)
    eq(p.rows[3].vendor,false);assert(p.rows[3].maxUnit<4);assert(p.rows[3].maxUnit>=3.9)
    eq(app.searchShopping(),true);eq(#submitted,1);eq(submitted[1].quantity,5);assert(submitted[1].maxPrice<4)
    fullscan({auction(765,5),auction(2447,8),auction(3371,4,100)})
    eq(app.shoppingPlan(5).vendorRows,1);eq(app.searchShopping(),false)
    app.character.vendor[3371]={unit=1,limited=true}
    near(app.vendorPrice(3371),3.4)
    faction='Alliance';near(app.vendorPrice(3371),4);faction='Horde'
    app.character.vendor[3371]=nil;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('successful scans stay valid across AH visits for exactly thirty minutes',function()
    beginShopping();fullscan();local completed=app.shopping.ready;local originalPrices=app.shopping.prices
    eq(app.shopping.maxAge,1800);eq(app.searchShopping(),true)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');eq(app.shoppingFresh(),false)
    now=now+300;app.shoppingEvent('AUCTION_HOUSE_SHOW')
    eq(app.shoppingFresh(),true);eq(app.shopping.ready,completed);eq(app.shopping.prices,originalPrices)
    eq(app.shopping.reason,nil);eq(app.shopping.searched,true)
    eq(app.searchShopping(),false)
    app.requestShopping();eq(app.shoppingWindow:IsShown(),true);eq(app.shoppingWindow.buy.enabled,false)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');now=completed+1800;app.shoppingEvent('AUCTION_HOUSE_SHOW')
    eq(app.shoppingFresh(),true);eq(app.shopping.ready,completed)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');now=completed+1801;app.shoppingEvent('AUCTION_HOUSE_SHOW')
    eq(app.shoppingFresh(),nil);eq(app.shopping.reason,'shop_stale');eq(app.shopping.prices,nil)
    fullscan();eq(app.shoppingFresh(),true)
    emit(scanEvents.ScanStart);app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.shoppingEvent('AUCTION_HOUSE_SHOW')
    emit(scanEvents.ScanComplete,{auction(10938,96)});eq(app.shoppingFresh(),nil)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)

local oldGUID,oldFullName,oldUnitName,oldRealm,oldCount,oldItemInfo,oldTime=UnitGUID,UnitFullName,UnitName,GetRealmName,C_Item.GetItemCount,C_Item.GetItemInfo,time
local people={A={id='inventory-A',name='Crafter',realm='Test Realm',faction='Horde',bags={[765]=0},bank={[765]=11}},
 B={id='inventory-B',name='Banker',realm='Test Realm',faction='Horde',bags={[765]=20},bank={[765]=30}},
 C={id='inventory-C',name='AllianceAlt',realm='Test Realm',faction='Alliance',bags={[765]=9},bank={[765]=6}},
 D={id='inventory-D',name='OtherRealm',realm='Other Realm',faction='Horde',bags={[765]=100},bank={[765]=100}}}
local person,shared,bindings,inventoryNow,bankUnavailable=people.A,{[765]=5},{},1000,false
local function inventoryMocks()
    UnitGUID=function(unit)return unit=='npc'and 'Creature-0-1-1-1-999321-000001'or person.id end
    UnitFullName=function()return person.name,person.realm end
    UnitName=function(unit)return unit=='npc'and 'Observed Supplier'or person.name end
    GetRealmName=function()return person.realm end
    time=function()return inventoryNow end
    C_Item.GetItemCount=function(id,bank,uses,reagents,account)
        if bank and bankUnavailable then return nil end
        return(person.bags[id]or 0)+(bank and(person.bank[id]or 0)or 0)+(account and(shared[id]or 0)or 0)
    end
    C_Item.GetItemInfo=function(id)
        if bindings[id]=='unknown'then return nil end
        return 'Material','item:'..id,1,1,1,'Trade Goods','Other',200,'',0,0,7,0,bindings[id]or 0
    end
end
local function loginInventory(key)
    person=people[key];faction=person.faction;inventoryNow=inventoryNow+100
    app.initialize();app.initializeInventory();app.inventoryState.bankOpen=true;app.captureInventory();app.inventoryState.bankOpen=false
end
test('current bags, bank and shared bank are separated and bank withdrawals clear',function()
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');inventoryMocks();loginInventory('A')
    local r=app.inventoryFor(765);eq(r.bags,0);eq(r.bank,11);eq(r.shared,5);eq(r.total,16)
    eq(r.bankLive,false);assert(r.bankWhen)
    local text=table.concat(app.inventoryLines(r),'\n');assert(text:find('Crafter',1,true));assert(text:find('bank 11',1,true))
    person.bags[765]=11;person.bank[765]=0;app.inventoryEvent('BAG_UPDATE_DELAYED');app.inventoryTick(.31)
    r=app.inventoryFor(765);eq(r.bags,11);eq(r.bank,0);eq(r.total,16)
    person.bank[765]=7;app.captureInventory();bankUnavailable=true
    r=app.inventoryFor(765);eq(r.bank,7);eq(r.total,23);bankUnavailable=false
end)
test('alt snapshots persist per character and shared bank is counted once',function()
    person.bags[765]=0;person.bank[765]=11;app.captureInventory();loginInventory('B')
    local r=app.inventoryFor(765);eq(r.total,55);eq(r.altTotal,11);eq(#r.alts,1);eq(r.alts[1].name,'Crafter')
    app.options.inventoryAlts=true;r=app.inventoryFor(765);eq(r.total,66);eq(r.deductibleAlts,11)
    loginInventory('C');loginInventory('D');loginInventory('A')
    r=app.inventoryFor(765);eq(r.total,66);eq(r.altTotal,65);eq(#r.alts,2)
    for _,alt in ipairs(r.alts)do assert(alt.name~='OtherRealm')end
    bindings[765]=1;r=app.inventoryFor(765);eq(r.total,16);eq(r.deductibleAlts,0)
    bindings[765]='unknown';eq(app.inventoryFor(765).total,16);bindings[765]=0
    loginInventory('B');person.bags[765]=0;person.bank[765]=0;app.captureInventory();loginInventory('A')
    r=app.inventoryFor(765);eq(r.total,16);eq(r.deductibleAlts,0)
    eq(app.saved.characters['inventory-B'].inventory.items[765].bags,0)
    app.options.inventoryAlts=false
end)
test('shopping shows bank collection and alt locations without silently deducting them',function()
    shared={};people.B.bags[765]=20;people.B.bank[765]=0;loginInventory('B');loginInventory('A')
    person.bags[765]=0;person.bank[765]=11;app.captureInventory()
    vialPlanSetup();app.character.vendor[3371]=nil
    local p=app.shoppingPlan(5);eq(p.rows[1].locations.bank,11);eq(p.rows[1].owned,11)
    app.renderShopping();assert(app.shoppingWindow.rows:GetText():find('Collect 5',1,true))
    assert(app.shoppingWindow.rows:GetText():find('Banker:',1,true))
    person.bank[765]=0;app.captureInventory();app.renderShopping()
    p=app.shoppingPlan(5);eq(p.rows[1].buy,5)
    app.shoppingWindow.alts.scripts.OnClick();eq(app.options.inventoryAlts,true)
    p=app.shoppingPlan(5);eq(p.rows[1].buy,0);eq(p.rows[1].locations.deductibleAlts,20)
    app.shoppingWindow.alts.scripts.OnClick();eq(app.options.inventoryAlts,false)
    app.command('lang de');assert(app.shoppingWindow.rows:GetText():find('Taschen',1,true));app.command('lang en')
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('nearby merchant selection, recorded visits and waypoint fallback',function()
    local oldMap,oldPoint,oldSuper=C_Map,UiMapPoint,C_SuperTrack
    local refs=app.vendorLocations[3371]
    app.vendorLocations[3371]={{npc=1,name='Enemy',side='Alliance',map=1458,x=50,y=50},
        {npc=2,name='Friendly',side='Horde',map=1458,x=49,y=50,reference=true},
        {npc=3,name='Far',side='Both',map=1438,x=50,y=50,reference=true}}
    C_Map={GetBestMapForUnit=function()return 1458 end,GetPlayerMapPosition=function()return{GetXY=function()return .5,.5 end}end,
        GetMapInfo=function()return{name='Undercity'}end,CanSetUserWaypointOnMap=function()return true end}
    local v=app.nearestMerchant(3371);eq(v.npc,2);eq(v.nearby,true)
    app.recordMerchant({[3371]=4});v=app.nearestMerchant(3371)
    eq(v.npc,999321);eq(v.name,'Observed Supplier');eq(v.observed,true)
    near(v.x,50);near(v.y,50)
    local pinned,tracked
    UiMapPoint={CreateFromCoordinates=function(map,x,y)return {uiMapID=map,x=x,y=y}end}
    C_Map.SetUserWaypoint=function(point)pinned=point end
    C_SuperTrack={SetSuperTrackedUserWaypoint=function(on)tracked=on end}
    eq(app.markMerchant(v),true);eq(pinned.uiMapID,1458);near(pinned.x,.5);eq(tracked,true)
    UiMapPoint=nil;eq(app.markMerchant(v),false)
    local oldChat=DEFAULT_CHAT_FRAME;local notices={}
    DEFAULT_CHAT_FRAME={AddMessage=function(_,line)notices[#notices+1]=line end}
    app.announceMerchants({rows={{id=3371,buy=2,vendorUnit=4}}})
    eq(#notices,1);assert(notices[1]:find('Observed Supplier',1,true))
    app.announceMerchants({rows={{id=3371,buy=2,vendorUnit=4}}});eq(#notices,1)
    inventoryNow=inventoryNow+300;app.announceMerchants({rows={{id=3371,buy=2,vendorUnit=4}}});eq(#notices,2)
    DEFAULT_CHAT_FRAME=oldChat

    vialPlanSetup();app.showMerchants();eq(app.merchantWindow:IsShown(),true)
    assert(app.merchantWindow.rows[1].name:GetText():find('Observed Supplier',1,true))
    app.applyScale(.7);near(app.merchantWindow.appliedScale,.7)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.merchantWindow:Hide()
    app.vendorLocations[3371]=refs;C_Map=oldMap;UiMapPoint=oldPoint;C_SuperTrack=oldSuper
end)
UnitGUID,UnitFullName,UnitName,GetRealmName,C_Item.GetItemCount,C_Item.GetItemInfo,time=oldGUID,oldFullName,oldUnitName,oldRealm,oldCount,oldItemInfo,oldTime
app.initialize();app.initializeInventory();app.options.inventoryAlts=false

test('Goblin skin, compact icon tooltips and safe font characters',function()
    beginShopping();fullscan()
    eq(app.main.recipes.role,'book');eq(app.main.materials.role,'bag');eq(app.main.settings.role,'gear')
    eq(app.main.shopping.role,'coin');assert(app.main.recipes.normalTexture:find('Button_book.tga',1,true))
    eq(app.shoppingWindow.width,500);eq(app.shoppingWindow.height,395);eq(#app.shoppingWindow.cards,7)
    eq(app.uiText('→ − — ✓'),'-> - - +')
    local oldTip=GameTooltip;local tip={lines={}}
    function tip:SetOwner(owner)self.owner=owner end
    function tip:SetText(t)self.title=t;self.lines={}end
    function tip:AddLine(line)self.lines[#self.lines+1]=line end
    function tip:Show()self.shown=true end
    function tip:Hide()self.shown=false end
    GameTooltip=tip
    local card=app.shoppingWindow.cards[1];card.scripts.OnEnter(card)
    eq(tip.owner,card);eq(tip.title,card.row.name);eq(tip.shown,true)
    assert(table.concat(tip.lines,' '):find('need',1,true))
    card.scripts.OnLeave();eq(tip.shown,false)
    GameTooltip=oldTip;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
local merchantPrice,merchantUnits,merchantStock,merchantExtended,merchantCalls,merchantGold=20,5,-1,false,{},200
local oldModernMerchant,oldMoney,oldMaxStack,oldBuy=C_MerchantFrame,GetMoney,GetMerchantItemMaxStack,BuyMerchantItem
local function setupVendorPopup()
    app.vendorBuyEvent('MERCHANT_CLOSED');app.vendorPurchase.pending=nil
    vialPlanSetup();app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.shopping.points=6
    merchantPrice=20;merchantUnits=5;merchantStock=-1;merchantExtended=false;merchantGold=200;merchantCalls={}
    C_MerchantFrame={GetItemInfo=function()return{name='Empty Vial',price=merchantPrice,stackCount=merchantUnits,numAvailable=merchantStock,hasExtendedCost=merchantExtended}end}
    GetMerchantNumItems=function()return 1 end;GetMerchantItemLink=function()return 'item:3371'end
    GetMerchantItemMaxStack=function()return 20 end;GetMoney=function()return merchantGold end
    BuyMerchantItem=function(slot,units)merchantCalls[#merchantCalls+1]={slot=slot,units=units}end
    app.observeMerchant();app.vendorBuyEvent('MERCHANT_SHOW')
end
test('vendor popup buys package-rounded units only after click and waits for inventory',function()
    setupVendorPopup();eq(app.vendorBuyWindow:IsShown(),true)
    local row=app.vendorPurchase.plan.rows[1]
    eq(row.id,3371);eq(row.missing,6);eq(row.quantity,10);eq(row.bundle,5);eq(row.cost,40)
    eq(#merchantCalls,0);eq(app.buyVendorMaterial(3371),true)
    eq(#merchantCalls,1);eq(merchantCalls[1].slot,1);eq(merchantCalls[1].units,10)
    eq(app.vendorBuyWindow.buy.enabled,false);eq(app.buyVendorMaterial(3371),false);eq(#merchantCalls,1)
    stock[3371]=10;app.vendorBuyTick();eq(app.vendorPurchase.pending,nil);eq(app.vendorBuyWindow:IsShown(),false)
    app.vendorBuyEvent('MERCHANT_CLOSED')
end)
test('vendor purchase checks new prices, gold, stock type and merchant closure',function()
    setupVendorPopup();merchantPrice=25
    eq(app.buyVendorMaterial(3371),false);eq(#merchantCalls,0);eq(app.vendorPurchase.status,'vendor_buy_changed')
    eq(app.vendorPurchase.plan.rows[1].cost,50)
    merchantGold=1;eq(app.buyVendorMaterial(3371),false);eq(app.vendorPurchase.status,'vendor_buy_gold');eq(#merchantCalls,0)
    merchantGold=200;merchantExtended=true;eq(app.buyVendorMaterial(3371),false);eq(#merchantCalls,0)
    setupVendorPopup();merchantStock=3;eq(app.buyVendorMaterial(3371),false);eq(#merchantCalls,0)
    setupVendorPopup();prices[3371]=2;app.observeMerchant();app.offerVendorPurchase()
    eq(#app.vendorPurchase.plan.rows,0);eq(app.vendorBuyWindow:IsShown(),false)
    app.vendorBuyEvent('MERCHANT_CLOSED');eq(app.buyVendorMaterial(3371),false)
end)
test('unconfirmed vendor purchase never retries automatically and explicit dismissal stays closed',function()
    setupVendorPopup();eq(app.buyVendorMaterial(3371),true)
    now=now+6;app.vendorBuyTick();eq(app.vendorPurchase.status,'vendor_buy_wait')
    eq(#merchantCalls,1);eq(app.vendorBuyWindow.buy.enabled,false)
    eq(app.retryVendorPurchase(),true);eq(#merchantCalls,1);eq(app.vendorPurchase.pending,nil)
    app.vendorBuyWindow.onDismiss();app.vendorBuyWindow:Hide();app.vendorBuyEvent('MERCHANT_UPDATE')
    eq(app.vendorBuyWindow:IsShown(),false)
    app.vendorBuyEvent('MERCHANT_CLOSED');app.vendorPurchase.pending=nil
end)
C_MerchantFrame,GetMoney,GetMerchantItemMaxStack,BuyMerchantItem=oldModernMerchant,oldMoney,oldMaxStack,oldBuy
test('large logo marker follows the correct world map and can be removed',function()
    local oldWorld,oldCtrl=WorldMapFrame,IsControlKeyDown
    local canvas=object('Frame','TestMapCanvas');canvas:SetSize(1000,600)
    local mapID=1458
    WorldMapFrame=object('Frame','TestWorldMap');WorldMapFrame.GetCanvas=function()return canvas end
    WorldMapFrame.GetMapID=function()return mapID end
    local v={name='Supplier',map=1458,x=50,y=40}
    eq(app.setMerchantMarker(v),true);app.updateMerchantMarker(.11)
    eq(app.mapPin:IsShown(),true);eq(app.mapPin.width,56);eq(app.mapPin.height,63)
    eq(app.mapPin.name:GetText(),'CraftDeja');near(app.mapPin.point[4],500);near(app.mapPin.point[5],-240)
    mapID=1438;app.updateMerchantMarker(.11);eq(app.mapPin:IsShown(),false)
    mapID=1458;app.updateMerchantMarker(.11);eq(app.mapPin:IsShown(),true)
    IsControlKeyDown=function()return true end;app.mapPin.scripts.OnClick();eq(app.mapPin:IsShown(),false)
    eq(app.character.mapTarget,nil)
    WorldMapFrame,IsControlKeyDown=oldWorld,oldCtrl
end)
test('next action shows exact vendor quantity, truthful marker status and inventory follow-up',function()
    vialPlanSetup();app.options.language='de';app.shopping.points=6
    app.renderShopping();app.showShopping()
    local f=app.nextStepWindow
    eq(f:IsShown(),true);eq(f.task.kind,'vendor')
    assert(f.body:GetText():find('6 x',1,true));assert(f.body:GetText():find('Händler',1,true))
    local oldMark=app.markMerchant;local marks=0
    app.markMerchant=function()marks=marks+1;return false end
    f.taskKey=nil;app.renderShopping();eq(marks,1)
    assert(f.notice:GetText():find('nicht verfügbar',1,true))
    app.renderShopping();eq(marks,1)
    app.markMerchant=function()marks=marks+1;return true end
    f.action.scripts.OnClick();assert(f.notice:GetText():find('auf der Karte markiert',1,true))
    f.onDismiss();f:Hide();app.renderShopping();eq(f:IsShown(),false)
    app.shopping.points=5;app.renderShopping();eq(f:IsShown(),true)
    local p=app.shopping.plan;local owned=app.copy(p)
    owned.ahRows=0;owned.vendorRows=0;owned.rows={{id=765,name='Silverleaf',total=6,buy=0,locations={bags=0,bank=11,shared=0}}}
    local t=app.nextStep(owned);eq(t.kind,'bank');assert(t.body:find('6 x Silverleaf',1,true))
    owned.rows[1].locations.bags=6;eq(app.nextStep(owned).kind,'craft')
    owned.ahRows=1;owned.rows[1].buy=1;owned.rows[1].locations.bags=0;app.shopping.searched=false;eq(app.nextStep(owned).kind,'ah')
    app.shopping.searched=true;eq(app.nextStep(owned).kind,'ah_load')
    owned.stockKnown=false;eq(app.nextStep(owned).kind,'unknown')
    app.shopping.searched=false;app.options.language='en';f.taskKey=nil;app.renderShopping()
    assert(f.body:GetText():find('vendor',1,true));app.markMerchant=oldMark
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.refreshNextStep();eq(f:IsShown(),true)
end)
test('skill range labels and numbers have matching inline colours',function()
    local r={skill=1,yellow=10,green=12,grey=15}
    app.options.language='de';local s=app.rangeText(r)
    assert(s:find('|cffffa449Orange 1-9|r',1,true))
    assert(s:find('|cffffe05eGelb 10-11|r',1,true))
    assert(s:find('|cff69da85Grün 12-14|r',1,true))
    assert(s:find('|cffaaaaaaGrau ab 15|r',1,true))
    app.options.language='en';assert(app.rangeText(r):find('Yellow 10-11',1,true))
    passed=passed+5
end)
test('each window scales from its corner, clamps, saves and preserves other windows',function()
    local x,y=400,400;local oldCursor,oldDown=GetCursorPosition,IsMouseButtonDown
    GetCursorPosition=function()return x,y end;IsMouseButtonDown=function()return true end
    app.applyScale(.8,true)
    for _,f in ipairs({app.main,app.shoppingWindow,app.nextStepWindow,app.vendorBuyWindow,app.catalogWindow,app.detailsWindow,app.optionsWindow,app.merchantWindow})do
        assert(f and f.scaleGrip);local g=f.scaleGrip
        local before=f:GetScale();g.scripts.OnMouseDown(g,'RightButton');eq(g.drag,nil)
        g.scripts.OnMouseDown(g,'LeftButton');x=x+90;y=y-70;g.scripts.OnUpdate()
        assert(f:GetScale()>before);eq(app.options.windowScales[f.scaleKey],f:GetScale())
        g.scripts.OnMouseUp();eq(g.drag,nil)
    end
    local mainScale=app.main:GetScale();app.applyScale(.65);eq(app.main:GetScale(),mainScale)
    local f=app.nextStepWindow;local g=f.scaleGrip
    g.scripts.OnMouseDown(g,'LeftButton');x=x+10000;y=y-10000;g.scripts.OnUpdate();eq(f:GetScale(),1.4)
    x=x-30000;y=y+30000;g.scripts.OnUpdate();eq(f:GetScale(),.5);g.scripts.OnMouseUp()
    app.applyScale(.75,true);eq(f:GetScale(),.75);eq(next(app.options.windowScales),nil)
    GetCursorPosition,IsMouseButtonDown=oldCursor,oldDown
end)
test('icons stay on an overlay and uncached or zero item icons have fallbacks',function()
    eq(app.main.recipes.icon.layer,'OVERLAY');eq(app.main.recipes.icon.sublevel,5)
    eq(app.shoppingWindow.cards[1].icon.layer,'OVERLAY')
    local a,b,c,d=C_Item.GetItemIconByID,GetItemIcon,C_Item.GetItemInfoInstant,C_Item.GetItemInfo
    C_Item.GetItemIconByID=function()return 0 end;GetItemIcon=function()return 12345 end
    eq(app.itemIcon(3371),12345)
    GetItemIcon=function()return ''end
    C_Item.GetItemInfoInstant=function()return nil,nil,nil,nil,6789 end
    eq(app.itemIcon(3371),6789)
    C_Item.GetItemInfoInstant=nil;C_Item.GetItemInfo=function()return nil end
    eq(app.itemIcon(3371),'Interface\\Icons\\INV_Misc_QuestionMark')
    C_Item.GetItemIconByID,GetItemIcon,C_Item.GetItemInfoInstant,C_Item.GetItemInfo=a,b,c,d
end)
test('shopping slider uses a purple track, golden thumb and boxed endpoints',function()
    local f=app.shoppingWindow
    eq(f.slider.orientation,'HORIZONTAL');eq(f.slider.thumbTexture,f.slider.thumb)
    eq(f.slider.Low:GetText(),'1');eq(f.slider.High:GetText(),'50')
    assert(f.slider.track.texture:find('SliderTrack',1,true));assert(f.slider.thumb.texture:find('SliderThumb',1,true))
    f.slider:SetValue(9);eq(app.shopping.points,9)
    f.slider:SetValue(900);eq(app.shopping.points,50)
    f.slider:SetValue(-4);eq(app.shopping.points,1)
end)
test('next-step survives craft transitions, scan start, shopping close and restores on every opening',function()
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');fixtures(100);scan()
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_SHOW')
    local f=app.nextStepWindow;eq(f:IsShown(),true)
    f.onDismiss();f:Hide();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_SHOW');eq(f:IsShown(),true)
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE');app.shopping.ready=nil;app.shopping.prices=nil;stock[10938]=0;stock[10940]=0
    app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_SHOW');eq(f:IsShown(),true);eq(f.task.kind,'scan')
    app.shopping.started=app.shopping.epoch;app.refreshNextStep();eq(f:IsShown(),true);assert(f.body:GetText():find('scan',1,true))
    app.shopping.started=nil;app.shopping.ready=nil;app.shopping.prices=nil
    app.shoppingWindow:Hide();app.refreshNextStep();eq(f:IsShown(),true)
    f.onDismiss();f:Hide();app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_CLOSED')
    app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_SHOW');eq(f:IsShown(),true)
    local active=app.active;app.active=nil;app.refreshNextStep();eq(f.task.kind,'open');eq(f:IsShown(),true)
    app.active=active;app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_CLOSED')
end)
test('automatic full scan waits for AH delay and reuses fresh prices until expiry',function()
    beginShopping();local count=0
    Auctionator.State={FullScanFrameRef={CanInitiate=function()return true end,InitiateScan=function()count=count+1;app.shopping.listener:ReceiveEvent(Auctionator.FullScan.Events.ScanStart)end}}
    local oldConfig=Auctionator.Config;Auctionator.Config=nil
    app.shopping.autoAfter=now+2;app.shoppingPoll();eq(count,0)
    now=now+2;app.shoppingPoll();eq(count,1);eq(app.shopping.started,app.shopping.epoch)
    app.shoppingPoll();eq(count,1)
    app.shopping.listener:ReceiveEvent(Auctionator.FullScan.Events.ScanComplete,{auction(10938,96),auction(10940,88)})
    eq(app.shoppingFresh(),true);app.shoppingPoll();eq(count,1)
    app.shopping.searched=true;app.shopping.sentSummary={ah=1,vendor=0,owned=1}
    now=now+1801;app.shoppingPoll();eq(count,2);eq(app.shopping.searched,true)
    app.shopping.listener:ReceiveEvent(Auctionator.FullScan.Events.ScanComplete,{auction(10938,96),auction(10940,88)})
    eq(app.shoppingFresh(),true);eq(app.shopping.searched,true)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');now=now+1801;app.shoppingPoll();eq(count,2)
    app.shoppingEvent('AUCTION_HOUSE_SHOW');app.shoppingPoll();eq(count,2)
    now=now+2;app.shoppingPoll();eq(count,3)
    Auctionator.State=nil;Auctionator.Config=oldConfig;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('autoscan obeys cooldown, busy purchase, throttling and failure backoff',function()
    beginShopping();local calls=0;local permitted=false
    local full={CanInitiate=function()return permitted end,InitiateScan=function()calls=calls+1;app.shopping.listener:ReceiveEvent(Auctionator.FullScan.Events.ScanStart)end}
    Auctionator.State={FullScanFrameRef=full};app.shopping.autoAfter=0
    app.autoScanTick();eq(calls,0);eq(app.shopping.autoReason,'step_auto_cooldown')
    permitted=true;Auctionator.State.BuyCommodityFrameRef={IsShown=function()return true end}
    app.autoScanTick(true);eq(calls,0);eq(app.shopping.autoReason,'step_auto_busy')
    Auctionator.State.BuyCommodityFrameRef=nil
    local oldAH=C_AuctionHouse;C_AuctionHouse={IsThrottledMessageSystemReady=function()return false end}
    app.autoScanTick(true);eq(calls,0)
    C_AuctionHouse=oldAH;app.autoScanTick(true);eq(calls,1)
    app.shopping.listener:ReceiveEvent(Auctionator.FullScan.Events.ScanFailed)
    app.shoppingPoll();eq(calls,1);now=now+61;app.shoppingPoll();eq(calls,2)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');Auctionator.State=nil
end)
test('automatic scan selects Auctionator summary mode without changing its setting',function()
    beginShopping();local calls=0;local oldConfig=Auctionator.Config
    Auctionator.IncrementalScan={Events={ScanStart='summary-start-auto',ScanComplete='summary-complete-auto',ScanFailed='summary-failed-auto'}}
    app.bindShopping()
    Auctionator.Config={Options={REPLICATE_SCAN='replicate'},Get=function(key)eq(key,'replicate');return false end}
    Auctionator.State={FullScanFrameRef={InitiateScan=function()error('wrong scan mode')end},IncrementalScanFrameRef={InitiateScan=function()calls=calls+1;app.shopping.listener:ReceiveEvent(Auctionator.IncrementalScan.Events.ScanStart)end}}
    eq(app.autoScanTick(true),true);eq(calls,1);eq(app.shopping.scanKind,'summary')
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');Auctionator.State=nil;Auctionator.Config=oldConfig
end)
test('AH quantity prefill is limited to planned items, quantities, prices and session',function()
    beginShopping();fullscan();app.setAHOrder({rows={{id=10938,buy=6,maxUnit=100},{id=3371,buy=5,maxUnit=3,vendor=true}}})
    local input=object('EditBox');local dialog={QuantityInput=input}
    eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=6,total=600}),true);eq(input:GetText(),'6')
    eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=7,total=600}),false)
    eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=6,total=601}),false)
    eq(app.prefillAHQuantity(dialog,{itemID=3371,quantity=5,total=15}),false)
    eq(app.prefillAHQuantity(dialog,{itemID=10940,quantity=1,total=1}),false)
    eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=0,total=0}),false)
    app.ahOrder.pending={id=10938,quantity=4};app.ahBuyingEvent('COMMODITY_PURCHASED',10938,4);eq(app.ahOrder.rows[10938].remaining,2)
    eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=6,total=500}),false)
    eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=2,total=200}),true)
    app.ahOrder.pending={id=10938,quantity=2};app.ahBuyingEvent('COMMODITY_PURCHASE_FAILED');eq(app.ahOrder.rows[10938].remaining,2)
    now=now+1801;eq(app.prefillAHQuantity(dialog,{itemID=10938,quantity=2,total=200}),false)
    app.ahBuyingEvent('AUCTION_HOUSE_CLOSED');eq(app.ahOrder,nil);app.character.ahMail={}
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
local function nativeCraftFrame(id)
    local f=object('Frame');local page={selected=id};f.CraftingPage=page
    local n=1
    page.SelectRecipe=function()page.selected=id;n=1 end
    page.SchematicForm={GetRecipeInfo=function()return {recipeID=page.selected}end}
    page.CreateMultipleInputBox={SetValue=function(_,value)n=value end,GetValue=function()return n end}
    page.CreateButton=object('Button',nil,f);page.CreateButton:SetText('Erstellen')
    page.CreateButton.LockHighlight=function(self)self.locked=true end
    page.CreateButton.UnlockHighlight=function(self)self.locked=false end
    -- This function represents a physical click made by the test's user, not
    -- an addon-issued Click or protected API invocation.
    page.CreateButton.scripts.OnClick=function()if C_TradeSkillUI.CraftRecipe then C_TradeSkillUI.CraftRecipe(page.selected,n)end end
    return f
end
test('native profession opener has a real effect and reports API or combat failures',function()
    vialPlanSetup();app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.professionOpen=false
    local oldOpen,oldCombat=C_TradeSkillUI.OpenTradeSkill,InCombatLockdown
    local calls=0;C_TradeSkillUI.OpenTradeSkill=function(id)eq(id,171);calls=calls+1;return true end
    app.showGuide(true);eq(app.openCraftProfession(),true);eq(calls,1);eq(app.main.guideVisible,false)
    InCombatLockdown=function()return true end;eq(app.openCraftProfession(),false);eq(calls,1)
    InCombatLockdown=nil;C_TradeSkillUI.OpenTradeSkill=function()return false end;eq(app.openCraftProfession(),false)
    C_TradeSkillUI.OpenTradeSkill=nil;eq(app.openCraftProfession(),false)
    C_TradeSkillUI.OpenTradeSkill,InCombatLockdown=oldOpen,oldCombat
end)
test('craft task shows icon and prepares one craft without invoking a protected API',function()
    vialPlanSetup();app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.professionOpen=true
    stock[3371]=20;scan();app.shopping.points=5
    local oldCraft,oldIcon,oldOutput=C_TradeSkillUI.CraftRecipe,C_Item.GetItemIconByID,C_TradeSkillUI.GetRecipeOutputItemData
    C_Item.GetItemIconByID=function(id)return id==2454 and 777777 or 136243 end
    C_TradeSkillUI.GetRecipeOutputItemData=function(id)eq(id,2329);return {itemID=2454}end
    local oldFrame=ProfessionsFrame;ProfessionsFrame=nativeCraftFrame(2329)
    local crafted={};C_TradeSkillUI.CraftRecipe=function(id,n)crafted[#crafted+1]={id,n}end
    app.refreshNextStep(true);local f=app.nextStepWindow
    eq(f.task.kind,'craft');eq(f.output.icon.texture,777777)
    assert(f.outputCount:GetText():find(tostring(f.task.available),1,true));eq(#crafted,0)
    f.action.scripts.OnClick();eq(#crafted,0);eq(app.nativeCraftHandoff.count,1)
    ProfessionsFrame.CraftingPage.CreateButton.scripts.OnClick();eq(#crafted,1);eq(crafted[1][1],2329);eq(crafted[1][2],1)
    stock[3371]=0;eq(app.craftNext(f.plan),false);eq(#crafted,1)
    C_TradeSkillUI.CraftRecipe,C_Item.GetItemIconByID,C_TradeSkillUI.GetRecipeOutputItemData=oldCraft,oldIcon,oldOutput
    app.clearNativeCraft();ProfessionsFrame=oldFrame;app.professionOpen=false
end)
test('AH task waits for actual purchased event, handles partial mail and collected stock',function()
    beginShopping();fullscan();app.character.ahMail={}
    local plan=app.shoppingPlan(1);local id=plan.rows[1].id;stock[id]=0
    local synthetic={stockKnown=true,ahRows=1,recipe=plan.recipe,crafts=4,rows={{id=id,name='Material',buy=4,total=4,maxUnit=100,vendor=false}}}
    app.shopping.searched=true;app.setAHOrder(synthetic)
    eq(app.nextStep(synthetic).kind,'ah_load');eq(app.confirmedMail(id),0)
    app.ahBuyingEvent('COMMODITY_PURCHASE_SUCCEEDED');eq(app.confirmedMail(id),0)
    app.ahBuyingEvent('COMMODITY_PURCHASED',id,1);eq(app.confirmedMail(id),1)
    eq(app.nextStep(synthetic).kind,'ah_load')
    app.ahBuyingEvent('COMMODITY_PURCHASE_FAILED');eq(app.confirmedMail(id),1)
    app.observeAHQuote({}, {itemID=id,quantity=3,total=300});app.ahBuyingEvent('COMMODITY_PURCHASED',id,3);eq(app.confirmedMail(id),4)
    eq(app.nextStep(synthetic).kind,'mail');assert(app.nextStep(synthetic).body:find('4',1,true))
    stock[id]=(stock[id]or 0)+4;app.ahMailPoll();eq(app.confirmedMail(id),0)
    app.ahBuyingEvent('AUCTION_HOUSE_CLOSED');app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('next-step AH buttons load offers, request a quote and explicitly confirm a bounded purchase',function()
    beginShopping();fullscan();app.character.ahMail={};app.shopping.points=1
    stock[10938]=0;app.refresh(false)
    local oldHook,oldAH,oldMoney,oldState,oldBuying=hooksecurefunc,C_AuctionHouse,GetMoney,Auctionator.State,Auctionator.Buying
    hooksecurefunc=function(t,k,post)local original=t[k];t[k]=function(self,...)original(self,...);post(self,...)end end
    local buyer=object('Frame');buyer:Hide();local requested,purchased=0,0
    local d=object('Frame');d:Hide();d.QuantityInput=object('EditBox')
    function d:SetDetails(q)self.itemID=q.itemID;self.quantity=q.quantity;self.QuantityInput:SetText('');self:Show()end
    function d:ConfirmPurchase()
        if tonumber(self.QuantityInput:GetText())==self.quantity then purchased=purchased+1;app.ahBuyingEvent('COMMODITY_PURCHASED',self.itemID,self.quantity);self:Hide()end
    end
    buyer.QuantityCheckConfirmationDialog=d
    function buyer:ReceiveEvent(_,row)self.expectedItemID=row.itemKey.itemID;self.selectedQuantity=row.purchaseQuantity;self.results={{price=80,quantity=100}};self:Show()end
    function buyer:UpdateView()end
    function buyer:BuyClicked()requested=requested+1;self.waitingForPurchase=true end
    Auctionator.State={BuyCommodityFrameRef=buyer};Auctionator.Buying={Events={ShowCommodityBuy='show-commodity-test'}}
    Auctionator.EventBus.Fire=function(_,_,event,row,info)eq(info.isCommodity,true);buyer:ReceiveEvent(event,row)end
    C_AuctionHouse={MakeItemKey=function(id)return {itemID=id}end,GetItemKeyInfo=function()return {isCommodity=true}end}
    GetMoney=function()return 100000 end
    eq(app.searchShopping(),true);local plan=app.shoppingPlan(1)
    local offer=app.ahBuyStatus(plan);eq(offer.phase,'ah_load');eq(purchased,0)
    eq(app.performAHBuy(plan,offer),true);offer=app.ahBuyStatus(plan);eq(offer.phase,'ah_buy');eq(purchased,0)
    local oldCost=offer.cost;buyer.results[1].price=81
    eq(app.performAHBuy(plan,offer),false);eq(requested,0)
    offer=app.ahBuyStatus(plan);eq(app.performAHBuy(plan,offer),true);eq(requested,1);eq(purchased,0)
    eq(app.ahBuyStatus(plan).phase,'ah_wait');buyer.waitingForPurchase=false
    d:SetDetails({itemID=offer.id,quantity=offer.quantity,total=offer.cost})
    eq(d.QuantityInput:GetText(),tostring(offer.quantity));eq(app.confirmedMail(offer.id),0)
    local confirmation=app.ahBuyStatus(plan);eq(confirmation.phase,'ah_confirm')
    eq(app.performAHBuy(plan,confirmation),true);eq(purchased,1)
    eq(app.confirmedMail(offer.id),offer.quantity);eq(app.nextStep(plan).kind,'mail')
    eq(app.performAHBuy(plan,confirmation),false);eq(purchased,1)
    stock[offer.id]=(stock[offer.id]or 0)+offer.quantity;app.ahMailPoll();eq(app.confirmedMail(offer.id),0)
    stock[offer.id]=0;local later=app.shoppingPlan(1);local again=app.ahBuyStatus(later)
    eq(again.phase,'ah_done');eq(app.performAHBuy(later,again),false);eq(requested,1)
    app.noteCompletedCraft(later.recipe.id,'new-craft-for-replenishment');again=app.ahBuyStatus(later)
    eq(again.phase,'ah_buy');eq(app.performAHBuy(later,again),true);eq(requested,2);eq(purchased,1)
    hooksecurefunc,C_AuctionHouse,GetMoney,Auctionator.State,Auctionator.Buying=oldHook,oldAH,oldMoney,oldState,oldBuying
    app.character.ahMail={};app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('profession button reads a visible profession while the auction house stays open',function()
    vialPlanSetup();app.character.ahMail={};app.active.invalidated=true
    local oldFrame,oldOpen,oldCraft=ProfessionsFrame,C_TradeSkillUI.OpenTradeSkill,C_TradeSkillUI.CraftRecipe
    ProfessionsFrame=object('Frame');ProfessionsFrame:Hide();local openCalls=0
    C_TradeSkillUI.OpenTradeSkill=function(id)eq(id,171);openCalls=openCalls+1;ProfessionsFrame:Show();return true end
    profile.skillLevel=13;live[2329].relativeDifficulty=2;stock[3371]=3
    eq(app.shopping.open,true);eq(app.openCraftProfession(),true)
    eq(app.professionOpen,true);eq(app.shopping.open,true);eq(app.active.profile.skill,13)
    eq(app.active.invalidated,nil);eq(app.professionLoading,false);assert(app.active.confirmed>0)
    app.refreshNextStep(true);assert(app.nextStepWindow.task.kind~='open')
    -- A late AH_SHOW must not discard the visible profession's state.
    app.events.scripts.OnEvent(app.events,'AUCTION_HOUSE_SHOW');eq(app.professionOpen,true);eq(app.active.profile.skill,13)
    profile.skillLevel=1;live[2329].relativeDifficulty=0;app.refresh(true)
    local casts=0;C_TradeSkillUI.CraftRecipe=function(id,n)eq(id,2329);eq(n,1);casts=casts+1 end
    ProfessionsFrame.CraftingPage=nativeCraftFrame(2329).CraftingPage
    local plan=app.shoppingPlan(1);eq(app.craftNext(plan),true);eq(casts,0);eq(openCalls,1)
    eq(app.nativeCraftHandoff.count,1);app.clearNativeCraft()
    ProfessionsFrame,C_TradeSkillUI.OpenTradeSkill,C_TradeSkillUI.CraftRecipe=oldFrame,oldOpen,oldCraft
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE');app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('profession readiness retries empty API data without hiding next step or reopening the window',function()
    vialPlanSetup();app.active.invalidated=true
    local oldFrame,oldOpen,oldProfile,oldIDs=ProfessionsFrame,C_TradeSkillUI.OpenTradeSkill,C_TradeSkillUI.GetBaseProfessionInfo,C_TradeSkillUI.GetAllRecipeIDs
    ProfessionsFrame=object('Frame');ProfessionsFrame:Hide()
    local opened=0;C_TradeSkillUI.OpenTradeSkill=function()opened=opened+1;ProfessionsFrame:Show();return true end
    C_TradeSkillUI.GetBaseProfessionInfo=function()return nil end
    eq(app.openCraftProfession(),true);eq(opened,1);eq(app.professionLoading,true)
    eq(app.nextStepWindow.task.kind,'loading');eq(app.nextStepWindow:IsShown(),true)
    eq(app.nextStepWindow.action.enabled,false)
    C_TradeSkillUI.GetBaseProfessionInfo=oldProfile;C_TradeSkillUI.GetAllRecipeIDs=function()return {}end
    app.events.scripts.OnUpdate(app.events,.25);eq(app.professionLoading,true)
    app.shoppingWindow:Show();app.renderShopping();eq(app.nextStepWindow:IsShown(),true)
    C_TradeSkillUI.GetAllRecipeIDs=oldIDs
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_LIST_UPDATE');app.events.scripts.OnUpdate(app.events,.25)
    eq(app.professionLoading,false);eq(app.active.invalidated,nil);eq(app.active.profile.id,171)
    eq(opened,1);assert(app.nextStepWindow.task.kind~='loading');assert(app.nextStepWindow.task.kind~='open')
    eq(app.actionNotice,nil)
    ProfessionsFrame,C_TradeSkillUI.OpenTradeSkill,C_TradeSkillUI.GetBaseProfessionInfo,C_TradeSkillUI.GetAllRecipeIDs=oldFrame,oldOpen,oldProfile,oldIDs
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE');app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('native visibility repairs a missing show event and hidden AH panels never trigger recipe reads',function()
    vialPlanSetup();local oldFrame,oldProfile=ProfessionsFrame,C_TradeSkillUI.GetBaseProfessionInfo
    ProfessionsFrame=object('Frame');ProfessionsFrame:Hide()
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
    local reads=0;C_TradeSkillUI.GetBaseProfessionInfo=function()reads=reads+1;return oldProfile()end
    app.events.scripts.OnUpdate(app.events,1.1);eq(reads,0)
    ProfessionsFrame:Show();app.events.scripts.OnUpdate(app.events,1.1)
    assert(reads>0);eq(app.professionOpen,true);eq(app.professionLoading,false)
    ProfessionsFrame:Hide();app.events.scripts.OnUpdate(app.events,1.1)
    eq(app.professionOpen,false);local before=reads
    app.events.scripts.OnUpdate(app.events,3.1);eq(reads,before)
    ProfessionsFrame,C_TradeSkillUI.GetBaseProfessionInfo=oldFrame,oldProfile
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE');app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('a two-unit batch cannot be regranted four times by polling, rescanning or stale inventory',function()
    beginShopping();fullscan();stock[765]=1
    local p={recipe=app.decision.current.recipe,from=100,target=101,crafts=3,rows={{id=765,buy=2,total=3,owned=1,maxUnit=14}}}
    app.setAHOrder(p);local d={QuantityInput=object('EditBox')};d.QuantityInput:SetText('2')
    app.observeAHQuote(d,{itemID=765,quantity=2,total=28});eq(app.markAHConfirm(d),true)
    eq(app.ahBuyStatus(p).phase,'ah_wait');eq(app.purchaseReserved(765),2)
    app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED');eq(app.confirmedMail(765),2)
    eq(app.ahOrder.rows[765].remaining,0)
    app.purchaseSignal('COMMODITY_PURCHASED',765,2);eq(app.confirmedMail(765),2)
    for attempt=1,4 do
        app.setAHOrder(p);eq(app.ahOrder.rows[765].remaining,0)
        eq(app.purchaseBudget(p,765,2),0);eq(app.observeAHQuote(d,{itemID=765,quantity=2,total=28}),nil)
        app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED');eq(app.confirmedMail(765),2)
    end
    app.ahBuyingEvent('AUCTION_HOUSE_CLOSED');app.setAHOrder(p);eq(app.ahOrder.rows[765].remaining,0)
    fullscan();app.setAHOrder(p);eq(app.purchaseBudget(p,765,2),0)
    stock[765]=3;app.ahMailPoll();eq(app.confirmedMail(765),0)
    stock[765]=1;app.setAHOrder(p);eq(app.purchaseBudget(p,765,2),0)
    app.noteCompletedCraft(p.recipe.id,'budget-real-craft');app.setAHOrder(p);eq(app.purchaseBudget(p,765,2),2)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('generic-only synchronous success needs native confirmation intent and both event variants count once',function()
    beginShopping();fullscan();stock[765]=0
    local p={rows={{id=765,buy=2,maxUnit=15}}};app.setAHOrder(p)
    local d={QuantityInput=object('EditBox')};d.QuantityInput:SetText('2')
    app.observeAHQuote(d,{itemID=765,quantity=2,total=30})
    app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED');eq(app.confirmedMail(765),0)
    eq(app.markAHConfirm(d),true);eq(app.confirmedMail(765),2);eq(app.ahOrder.rows[765].remaining,0)
    app.purchaseSignal('COMMODITY_PURCHASED',765,2);app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED');eq(app.confirmedMail(765),2)
    app.character.ahMail={};app.newPurchasePlan();app.setAHOrder(p)
    app.observeAHQuote(d,{itemID=765,quantity=2,total=30});app.markAHConfirm(d)
    app.purchaseSignal('COMMODITY_PURCHASED',765,2);app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED')
    eq(app.confirmedMail(765),2);eq(app.ahOrder.rows[765].remaining,0)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('missing purchase results freeze the reservation across timeout and reload until an actual result',function()
    beginShopping();fullscan();app.setAHOrder({rows={{id=765,buy=2,maxUnit=15}}})
    local d={};app.observeAHQuote(d,{itemID=765,quantity=2,total=30});app.markAHConfirm(d)
    now=now+9;app.purchasePoll();eq(app.purchasePending().status,'uncertain')
    eq(app.newPurchasePlan(),false);eq(app.confirmedMail(765),0)
    app.initializePurchasing();eq(app.purchasePending().status,'uncertain')
    eq(app.ahBuyStatus({rows={{id=765,buy=2}}}).phase,'ah_wait')
    app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED');eq(app.purchasePending().status,'uncertain');eq(app.confirmedMail(765),0)
    app.purchaseSignal('COMMODITY_PURCHASED',765,2);eq(app.purchasePending(),nil);eq(app.confirmedMail(765),2)
    app.character.ahMail={};app.newPurchasePlan();app.setAHOrder({rows={{id=765,buy=2,maxUnit=15}}})
    app.observeAHQuote(d,{itemID=765,quantity=2,total=30});app.markAHConfirm(d)
    app.purchaseSignal('COMMODITY_PURCHASE_FAILED');eq(app.purchasePending(),nil);eq(app.ahOrder.rows[765].remaining,2)
    eq(app.confirmedMail(765),0);app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('a live one-copper increase revalues prices and ceilings without resetting the purchase budget',function()
    beginShopping();fullscan({auction(10938,14),auction(10940,88)});stock[10938]=0;app.shopping.points=1;app.shopping.tolerance=0;app.refresh(false)
    local p=app.shoppingPlan(1);local id=p.rows[1].id;eq(id,10938);eq(p.rows[1].maxUnit,14)
    app.setAHOrder(p);local original=app.ahOrder.rows[id].remaining
    app.updateLiveCommodity(id,{{price=15,quantity=71},{price=16,quantity=31}})
    eq(app.unitPrice(id),15);local nextPlan=app.shoppingPlan(1);eq(nextPlan.rows[1].maxUnit,15)
    app.setAHOrder(nextPlan);eq(app.ahOrder.rows[id].remaining,original)
    local d={QuantityInput=object('EditBox')};app.observeAHQuote(d,{itemID=id,quantity=original,total=original*15})
    eq(app.prefillAHQuantity(d,{itemID=id,quantity=original,total=original*15}),true)
    app.markAHConfirm(d);app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED')
    app.updateLiveCommodity(id,{{price=16,quantity=71}});app.setAHOrder(app.shoppingPlan(1))
    eq(app.ahOrder.rows[id].remaining,0);eq(app.purchaseBudget(app.shoppingPlan(1),id,original),0)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('native quantity clears at completion and live result events refresh a one-copper move',function()
    beginShopping();fullscan({auction(10938,14),auction(10940,88)});stock[10938]=0;app.shopping.points=1;app.refresh(false)
    local oldHook,oldState=hooksecurefunc,Auctionator.State
    hooksecurefunc=function(t,k,after)local fn=t[k];t[k]=function(self,...)fn(self,...);after(self,...)end end
    local buyer=object('Frame');buyer.expectedItemID=10938;buyer.results={{price=14,quantity=71}}
    buyer.DetailsContainer={BuyButton=object('Button')};buyer.selectedQuantity=2
    function buyer:UpdateView()self.DetailsContainer.BuyButton:Enable()end
    function buyer:OnEvent(_,id)self.expectedItemID=id;self.results={{price=15,quantity=69}}end
    Auctionator.State={BuyCommodityFrameRef=buyer};app.setAHOrder(app.shoppingPlan(1));buyer.craftDejaManagedID=10938
    buyer:OnEvent('COMMODITY_SEARCH_RESULTS_UPDATED',10938);eq(app.unitPrice(10938),15)
    local p=app.shoppingPlan(1);app.setAHOrder(p);local n=app.ahOrder.rows[10938].remaining
    local d={};app.observeAHQuote(d,{itemID=10938,quantity=n,total=n*15});app.markAHConfirm(d)
    app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED')
    eq(buyer.selectedQuantity,0);eq(buyer.DetailsContainer.BuyButton.enabled,false)
    buyer:UpdateView();eq(buyer.DetailsContainer.BuyButton.enabled,false)
    hooksecurefunc,Auctionator.State=oldHook,oldState;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('unrelated bag gains do not erase confirmed mailbox stock',function()
    beginShopping();fullscan();stock[765]=0;app.mailOpen=false
    app.setAHOrder({rows={{id=765,buy=2,maxUnit=15}}})
    local d={};app.observeAHQuote(d,{itemID=765,quantity=2,total=30});app.markAHConfirm(d);app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED')
    eq(app.confirmedMail(765),2);now=now+3
    stock[765]=1;app.ahMailPoll();eq(app.confirmedMail(765),2)
    app.ahBuyingEvent('MAIL_SHOW');stock[765]=3;app.ahMailPoll();eq(app.confirmedMail(765),0)
    app.ahBuyingEvent('MAIL_CLOSED');eq(app.mailOpen,false)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
local stockNativeFrameBackup
local function stockCraftSetup()
    app.shopping.goal='manual'
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.craftBatch=nil;app.clearNativeCraft()
    stockNativeFrameBackup=ProfessionsFrame;ProfessionsFrame=nativeCraftFrame(995501)
    profile={professionID=171,professionName='Alchemy',skillLevel=15,maxSkillLevel=75}
    live={[995501]=info('Stock potion',0,true,{[765]=1,[2447]=1,[3371]=1})}
    app.catalog[171][995501]={skill=1,yellow=55,green=75,grey=95,rangeVerified=true,ingredients={[765]=1,[2447]=1,[3371]=1},sources={'trainer'}}
    prices={[765]=14,[2447]=28,[3371]=3};stock={[765]=5,[2447]=4,[3371]=6}
    app.sessions={};app.options.prices='auto';app.shopping.points=5
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_SHOW')
end
local function stockCraftCleanup()
    app.craftBatch=nil;app.clearNativeCraft();ProfessionsFrame=stockNativeFrameBackup;app.catalog[171][995501]=nil;app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
end
test('four ready crafts beat an AH trip for the fifth planned craft',function()
    stockCraftSetup();local p=app.materialPlan(app.decision.current.recipe,20)
    eq(p.crafts,5);eq(app.craftAvailability(p),4)
    local task=app.nextStep(p);eq(task.kind,'craft');eq(task.available,4);eq(task.batch,4)
    app.refreshNextStep(true);eq(app.nextStepWindow.task.kind,'craft');eq(app.nextStepWindow.craftAll:IsShown(),true)
    assert(app.nextStepWindow.craftAll:GetText():find('4',1,true))
    app.decision.stop=17;eq(app.craftBatchInfo(p).count,2)
    stock[2447]=0;eq(app.craftAvailability(p),4) -- snapshot is revalidated before clicking
    app.refresh(true);local updated=app.materialPlan(app.decision.current.recipe,20)
    eq(app.craftAvailability(updated),0);assert(app.nextStep(updated).kind~='craft')
    stockCraftCleanup()
end)
test('single and all prepare exact amounts; only a physical native click starts the batch',function()
    stockCraftSetup();local old=C_TradeSkillUI.CraftRecipe
    local calls={};C_TradeSkillUI.CraftRecipe=function(id,n)calls[#calls+1]={id=id,n=n}end
    app.refreshNextStep(true);app.nextStepWindow.action.scripts.OnClick()
    eq(#calls,0);eq(app.nativeCraftHandoff.count,1);eq(app.craftBatch,nil)
    app.nextStepWindow.craftAll.scripts.OnClick();eq(app.nativeCraftHandoff,nil)
    app.nextStepWindow.craftAll.scripts.OnClick();eq(#calls,0);eq(app.nativeCraftHandoff.count,4)
    eq(ProfessionsFrame.CraftingPage.CreateMultipleInputBox:GetValue(),4)
    ProfessionsFrame.CraftingPage.CreateButton.scripts.OnClick();eq(#calls,1);eq(calls[1].n,4)
    app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_START','player','native-start',995501)
    eq(app.craftBatch.remaining,4);eq(app.nativeCraftHandoff,nil)
    app.refreshNextStep();eq(app.nextStepWindow.task.kind,'craft_queue');eq(app.nextStepWindow.action.enabled,false)
    for k=1,4 do
        profile.skillLevel=profile.skillLevel+1;stock[765]=stock[765]-1;stock[2447]=stock[2447]-1;stock[3371]=stock[3371]-1
        app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_SUCCEEDED','player','batch-cast-'..k,995501)
        app.events.scripts.OnUpdate(app.events,.25)
        if k<4 then eq(app.craftBatch.remaining,4-k);eq(app.nextStepWindow.task.kind,'craft_queue')end
    end
    eq(app.craftBatch,nil);eq(#calls,1);assert(app.nextStepWindow.task.kind~='craft_queue')
    C_TradeSkillUI.CraftRecipe=old;stockCraftCleanup()
end)

test('native interruption clears tracking; stopping is an explicit native instruction',function()
    stockCraftSetup();local oldCraft,oldStop=C_TradeSkillUI.CraftRecipe,C_TradeSkillUI.StopRecipeRepeat
    local protectedCalls=0;C_TradeSkillUI.CraftRecipe=function()protectedCalls=protectedCalls+1 end
    C_TradeSkillUI.StopRecipeRepeat=function()protectedCalls=protectedCalls+1 end
    local p=app.materialPlan(app.decision.current.recipe,20);eq(app.craftNext(p,true),true)
    app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_START','player','start',995501)
    app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_INTERRUPTED','player','interrupt',995501);eq(app.craftBatch,nil)
    eq(app.craftNext(p,true),true);app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_START','player','start2',995501)
    eq(app.stopCraftBatch(true),false);eq(protectedCalls,0);eq(app.craftBatch.attention,true)
    app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_INTERRUPTED','player','interrupt2',995501);eq(app.craftBatch,nil)
    C_TradeSkillUI.CraftRecipe,C_TradeSkillUI.StopRecipeRepeat=oldCraft,oldStop;stockCraftCleanup()
end)

test('flow log is bounded, persistent, copyable, pausable and avoids unchanged-state spam',function()
    app.character.flowLog={sequence=0,entries={}};app.options.flowLogging=true
    for k=1,600 do app.flowLog('test.event',{item=k})end
    eq(#app.character.flowLog.entries,500);eq(app.character.flowLog.entries[1].seq,101)
    local exported=app.logExport();assert(exported:find('test.event item=600',1,true))
    assert(not exported:find('test.event item=1\n',1,true))
    app.initialize();eq(#app.character.flowLog.entries,500)
    app.options.flowLogging=false;app.flowLog('must_not_appear',{});eq(app.character.flowLog.sequence,600)
    app.options.flowLogging=true;app.lastFlowState=nil;app.traceState();local seq=app.character.flowLog.sequence
    app.traceState();app.traceState();eq(app.character.flowLog.sequence,seq)
    app.showFlowLog();eq(app.flowLogWindow:IsShown(),true);assert(app.flowLogWindow.box:GetText():find('CraftDeja diagnostic log',1,true))
    app.flowLogWindow.toggle.scripts.OnClick();eq(app.options.flowLogging,false)
    app.flowLogWindow.toggle.scripts.OnClick();eq(app.options.flowLogging,true)
    app.flowLogWindow.clear.scripts.OnClick();assert(#app.character.flowLog.entries<10)
end)
test('own Lua errors are logged and the previous error handler still receives every error',function()
    local oldGet,oldSet=geterrorhandler,seterrorhandler;local forwarded=0
    local handler=function()forwarded=forwarded+1 end
    geterrorhandler=function()return handler end;seterrorhandler=function(fn)handler=fn end
    app.flowErrorHook=nil;app.installFlowErrorHook();local seq=app.character.flowLog.sequence
    handler('OtherAddon error');eq(forwarded,1);eq(app.character.flowLog.sequence,seq)
    handler('Interface/AddOns/CraftDeja/Test.lua: simulated failure');eq(forwarded,2)
    assert(app.logExport():find('lua.error',1,true))
    geterrorhandler,seterrorhandler=oldGet,oldSet;app.flowErrorHook=nil
end)
test('hidden shopping parent is brought to the foreground before loading commodity offers',function()
    beginShopping();fullscan();stock[10938]=0;app.shopping.points=1;app.refresh(false)
    local oldState,oldAH,oldBuying,oldTab=Auctionator.State,C_AuctionHouse,Auctionator.Buying,AuctionatorTabs_Shopping
    local visible=false;local nav=0;local fired=0
    local buyer=object('Frame');buyer.expectedItemID=10938;buyer.results={{price=80,quantity=100}}
    buyer.IsVisible=function()return visible end
    Auctionator.State={BuyCommodityFrameRef=buyer};Auctionator.Buying={Events={ShowCommodityBuy='show-hidden-test'}}
    AuctionatorTabs_Shopping={Click=function()nav=nav+1;visible=true end}
    C_AuctionHouse={MakeItemKey=function(id)return {itemID=id}end,GetItemKeyInfo=function()return {isCommodity=true}end}
    Auctionator.EventBus.Fire=function()eq(visible,true);fired=fired+1 end
    local p=app.shoppingPlan(1);app.setAHOrder(p);eq(app.ahBuyStatus(p).phase,'ah_load')
    eq(app.performAHBuy(p,app.ahBuyStatus(p)),true);eq(nav,1);eq(fired,1)
    Auctionator.State,C_AuctionHouse,Auctionator.Buying,AuctionatorTabs_Shopping=oldState,oldAH,oldBuying,oldTab
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('log opens through the actual info button and slash command on a real-shaped EditBox',function()
    stockCraftSetup();app.refreshNextStep(true)
    app.flowLogWindow:Hide();app.nextStepWindow.logButton.scripts.OnClick()
    eq(app.flowLogWindow:IsShown(),true);eq(app.flowLogWindow.box.GetStringHeight,nil)
    eq(type(app.flowLogWindow.box.GetNumLines),'function')
    app.flowLogWindow:Hide();app.command('log');eq(app.flowLogWindow:IsShown(),true)
    app.flowLogWindow:Hide();app.command('log');eq(app.flowLogWindow:IsShown(),true)
    stockCraftCleanup()
end)
test('preparing four does not call or replace native handlers, Click, Create or CraftRecipe',function()
    stockCraftSetup();local oldAPI=C_TradeSkillUI.CraftRecipe
    C_TradeSkillUI.CraftRecipe=function()error('protected CraftRecipe must not be called by addon')end
    local page=ProfessionsFrame.CraftingPage;local handler=page.CreateButton.scripts.OnClick
    page.CreateButton.Click=function()error('scripted native click forbidden')end
    page.Create=function()error('scripted Create forbidden')end
    local plan=app.materialPlan(app.decision.current.recipe,20)
    eq(app.craftNext(plan,true),true);eq(page.CreateMultipleInputBox:GetValue(),4)
    eq(page.CreateButton.locked,true);eq(page.CreateButton.scripts.OnClick,handler)
    eq(app.nativeCraftHandoff.count,4);eq(app.craftBatch,nil)
    eq(app.nextStepWindow.task.kind,'craft_native');eq(app.focusNativeCraft(),true)
    app.clearNativeCraft();eq(page.CreateButton.locked,false)
    C_TradeSkillUI.CraftRecipe=oldAPI;stockCraftCleanup()
end)

test('native quantity clamping and setup errors cannot start a wrong or duplicate batch',function()
    stockCraftSetup();local oldFrame,oldCraft=ProfessionsFrame,C_TradeSkillUI.CraftRecipe
    local calls=0;local selected=nil
    local input={SetValue=function()end,GetValue=function()return 1 end}
    local page={SelectRecipe=function()selected=995501 end,SchematicForm={GetRecipeInfo=function()return {recipeID=selected}end},
        CreateMultipleInputBox=input,CreateButton=object('Button'),Create=function()calls=calls+1 end}
    ProfessionsFrame={IsShown=function()return true end,CraftingPage=page};C_TradeSkillUI.CraftRecipe=function()calls=calls+1 end
    local plan=app.materialPlan(app.decision.current.recipe,20)
    eq(app.craftNext(plan,true),false);eq(calls,0);eq(app.craftBatch,nil)
    input.SetValue=function()error('native setter error')end
    eq(app.craftNext(plan,true),false);eq(calls,0);eq(app.craftBatch,nil)
    assert(app.logExport():find('native setter error',1,true))
    ProfessionsFrame,C_TradeSkillUI.CraftRecipe=oldFrame,oldCraft;stockCraftCleanup()
end)
test('client-required font flags are explicit and log errors are visible in chat',function()
    local e=CreateFrame('EditBox')
    local ok=pcall(e.SetFont,e,'Fonts\\FRIZQT__.TTF',11);eq(ok,false)
    eq(app.showFlowLog(),true);eq(app.flowLogWindow.box.fontFlags,'')
    local oldSet=app.flowLogWindow.box.SetText;local oldChat=DEFAULT_CHAT_FRAME
    local messages={};DEFAULT_CHAT_FRAME={AddMessage=function(_,text,...)assert(select('#',...)==0);messages[#messages+1]=text end}
    app.flowLogWindow.box.SetText=function()error('simulated client text failure')end
    eq(app.showFlowLog(),false);eq(#messages,1);assert(messages[1]:find('simulated client text failure',1,true))
    app.flowLogWindow.box.SetText=oldSet
    app.command('version');eq(messages[2],'CraftDeja '..app.release)
    eq(app.showFlowLog(),true)
    DEFAULT_CHAT_FRAME=oldChat
end)
test('prepared native task persists without assuming a start or ever retrying a protected call',function()
    stockCraftSetup();local oldAPI=C_TradeSkillUI.CraftRecipe;local calls=0
    C_TradeSkillUI.CraftRecipe=function()calls=calls+1 end
    local p=app.materialPlan(app.decision.current.recipe,20)
    eq(app.craftNext(p,true),true);eq(calls,0);eq(app.craftBatch,nil)
    eq(app.nativeCraftHandoff.plan.crafts,4)
    for _,row in ipairs(app.nativeCraftHandoff.plan.rows)do eq(row.total,4);eq(row.buy,0)end
    local before=app.character.flowLog.sequence
    for k=1,3 do app.checkCraftBatch();app.refreshNextStep();app.renderNextStep(p,true)end
    eq(app.character.flowLog.sequence,before);eq(app.nextStepWindow.plan.crafts,4)
    now=now+30;app.checkCraftBatch();eq(app.nativeCraftHandoff.count,4);eq(calls,0)
    ProfessionsFrame.CraftingPage.CreateMultipleInputBox:SetValue(1);app.checkCraftBatch()
    eq(app.nativeCraftHandoff,nil);eq(calls,0)
    C_TradeSkillUI.CraftRecipe=oldAPI;stockCraftCleanup()
end)

test('real native start confirms tracking and client block events clear only the pending action',function()
    stockCraftSetup();local p=app.materialPlan(app.decision.current.recipe,20)
    eq(app.craftNext(p,true),true)
    app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_START','player','real-start',995501)
    eq(app.craftBatch.phase,'running');assert(app.logExport():find('craft.native_user_start',1,true))
    app.craftBatch=nil;eq(app.craftNext(p,true),true)
    app.events.scripts.OnEvent(app.events,'ADDON_ACTION_BLOCKED','CraftDeja','UNKNOWN()')
    eq(app.craftBatch,nil);eq(app.nativeCraftHandoff,nil)
    assert(app.logExport():find('craft.client_blocked',1,true));assert(app.actionNotice:find('UNKNOWN()',1,true))
    app.craftBlocked=nil;stockCraftCleanup()
end)

test('unchanged profession polling and unrelated spell/addon events do not fill the log',function()
    stockCraftSetup();app.traceProfessionRead(app.active.profile,1)
    local before=app.character.flowLog.sequence
    for k=1,50 do
        app.traceProfessionRead(app.active.profile,1)
        app.events.scripts.OnEvent(app.events,'ADDON_LOADED','UnrelatedAddon')
        app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_FAILED','player','battle-shout-'..k,6673)
    end
    eq(app.character.flowLog.sequence,before)
    stockCraftCleanup()
end)
local function routeGoalSetup()
    stockCraftSetup()
    app.catalog[171][995502]={skill=73,yellow=110,green=135,grey=160,rangeVerified=true,ingredients={[765]=1},sources={'trainer'}}
    app.accessData[995502]={access='Both',audit='test'}
    live[995502]=info('Next potion',0,false,{[765]=1})
    app.shopping.goal='next';app.options.shoppingGoal='next';app.shopping.points=5
    shoppingAPI();app.shoppingEvent('AUCTION_HOUSE_SHOW')
    fullscan({auction(765,14),auction(2447,28),auction(3371,3)})
    app.refresh(true)
end
local function routeGoalCleanup()
    app.catalog[171][995502]=nil;app.accessData[995502]=nil;app.shopping.goal='manual';app.options.shoppingGoal='manual'
    stockCraftCleanup()
end
test('next-action goal replaces the old five-point default and buys through the recipe-learning boundary',function()
    routeGoalSetup();eq(app.decision.stop,73)
    local p=app.shoppingPlan();eq(p.from,15);eq(p.target,73);eq(p.crafts,64);eq(p.goalMode,'next')
    for _,row in ipairs(p.rows)do eq(row.total,64)end
    eq(app.shopping.points,5) -- remembered manual slider value does not cap auto mode
    eq(app.nextActionBoundary().kind,'learn');assert(app.routeSummary():find('73',1,true))
    eq(app.searchShopping(),true)
    local quantities={};for _,row in ipairs(submitted)do quantities[row.searchString]=row.quantity end
    eq(quantities['Item 765'],59);eq(quantities['Item 2447'],60);eq(quantities['Item 3371'],58) -- this fixture's AH vial price is below the observed vendor price
    routeGoalCleanup()
end)
test('manual slider remains available and the next-action button restores the full route',function()
    routeGoalSetup();app.showShopping();eq(app.shopping.goal,'next')
    eq(app.shoppingWindow.slider.maximum,58);eq(app.shoppingWindow.slider.sliderValue,58)
    app.shoppingWindow.slider.scripts.OnValueChanged(app.shoppingWindow.slider,3)
    eq(app.shopping.goal,'manual');eq(app.shoppingPlan().target,18);eq(app.shoppingPlan(1).target,16)
    app.shoppingWindow.goalMode.scripts.OnClick();eq(app.shopping.goal,'next');eq(app.shoppingPlan().target,73)
    app.initializeShopping();eq(app.shopping.goal,'next')
    app.options.shoppingGoal=nil;app.initializeShopping();eq(app.shopping.goal,'next')
    routeGoalCleanup()
end)
test('route stops at a rank cap and shows learning required now without buying past it',function()
    stockCraftSetup();app.shopping.goal='next';profile.skillLevel=70;profile.maxSkillLevel=75;live[995501].relativeDifficulty=1
    app.refresh(true)
    app.decision=app.decide(app.marketView({profile=app.active.profile,recipes={[995501]=app.active.recipes[995501]}}))
    local b=app.nextActionBoundary();eq(b.target,75);eq(b.kind,'rank')
    assert(app.nextActionLabel(b):find('75-150',1,true));eq(app.planningTarget(),75)
    profile.skillLevel=75;app.refresh(true);eq(app.nextStepWindow.task.kind,'rank')
    eq(app.nextStepWindow.attentionActive,true);eq(app.nextStepWindow.action.enabled,true)
    stockCraftCleanup()
    routeGoalSetup();app.decision.followup.level=app.active.profile.skill
    eq(app.nextActionBoundary().target,15);app.refreshNextStep(true)
    eq(app.nextStepWindow.task.kind,'learn');eq(app.nextStepWindow.task.recipe.id,995502)
    local p,reason=app.shoppingPlan();eq(p,nil);eq(reason,'learn_first')
    routeGoalCleanup()
end)
test('changing goals is blocked while a purchase is pending and unchanged values never unlock a batch',function()
    routeGoalSetup();app.shopping.goal='next';app.shopping.points=5
    app.purchaseState().transaction={status='pending',id=765,quantity=2,applied=0}
    eq(app.setPlanningGoal('manual',3),false);eq(app.shopping.goal,'next');eq(app.shopping.points,5)
    app.purchaseState().transaction=nil
    local before=app.character.flowLog.sequence
    eq(app.setPlanningGoal('next'),true);eq(app.character.flowLog.sequence,before)
    routeGoalCleanup()
end)
test('mail is visibly highlighted and only its background pulses until the task changes',function()
    stockCraftSetup();local p=app.materialPlan(app.decision.current.recipe,20)
    app.renderNextStep(p,true,{kind='mail',key='test-mail',body='Kauf bestaetigt: Hole 5 x Friedensblume aus dem Briefkasten.'})
    local f=app.nextStepWindow;eq(f.attentionActive,true);eq(f.body.fontSize,14);eq(f.attention:IsShown(),true)
    eq(f.alertTitle:IsShown(),true);eq(f.body.textColour[1],1)
    f.scripts.OnUpdate(f,.1);local alpha=f.attention.alpha;f.scripts.OnUpdate(f,.5)
    assert(alpha~=f.attention.alpha);eq(f.body.alpha,nil)
    eq(f.body:GetText(),'Kauf bestaetigt: Hole 5 x Friedensblume aus dem Briefkasten.')
    app.renderNextStep(p,true,{kind='unknown',key='test-unknown',body='Update inventory'})
    eq(f.attentionActive,false);eq(f.attention:IsShown(),false);eq(f.body.fontSize,12)
    stockCraftCleanup()
end)
test('native arrow chooses safe Create all and otherwise the exact prepared Create button without clicking',function()
    stockCraftSetup();local page=ProfessionsFrame.CraftingPage
    page.CreateAllButton=object('Button');page.CreateAllButton.LockHighlight=function(self)self.locked=true end
    page.CreateAllButton.UnlockHighlight=function(self)self.locked=false end
    page.GetCraftableCount=function()return math.min(stock[765],stock[2447],stock[3371])end
    stock[3371]=2;app.refresh(true)
    eq(app.nativeCue:IsShown(),true);eq(app.nativeCue.target,page.CreateAllButton);eq(app.nativeCue.count,2)
    eq(app.nativeCue.point[2],page.CreateAllButton);eq(app.nativeCue.isAll,true)
    local oldAPI=C_TradeSkillUI.CraftRecipe;C_TradeSkillUI.CraftRecipe=function()error('arrow must never craft')end
    profile.maxSkillLevel=16;stock[3371]=6;app.refresh(true)
    eq(app.nativeCue:IsShown(),false) -- all four would cross the next safe boundary
    eq(app.craftNext(app.nextStepWindow.plan,true),true)
    eq(app.nativeCraftHandoff.count,1);eq(app.nativeCue.target,page.CreateButton);eq(app.nativeCue.isAll,false)
    page.CreateButton:Hide();app.nativeCue.scripts.OnUpdate(app.nativeCue,.1);eq(app.nativeCue:IsShown(),false)
    C_TradeSkillUI.CraftRecipe=oldAPI;stockCraftCleanup()
end)
test('stale callbacks and Next step stay locked until scan completion and native idle',function()
    beginShopping();fullscan();stock[10938]=0;stock[10940]=0;app.refresh(false)
    local p=app.shoppingPlan();app.searchShopping();local oldState=Auctionator.State
    local oldAH=C_AuctionHouse;local requests=0
    C_AuctionHouse={MakeItemKey=function()requests=requests+1;return {}end}
    Auctionator.State={FullScanFrameRef={inProgress=true}}
    emit(scanEvents.ScanStart);app.refreshNextStep(true)
    eq(app.nextStepWindow.task.kind,'scan');eq(app.nextStepWindow.action.enabled,false)
    eq(app.main.shopping.enabled,false);eq(app.performAHBuy(p,{phase='ah_load'}),false)
    eq(app.searchShopping(),false);eq(requests,0);eq(app.ahBuyStatus(p).phase,'ah_scan')
    eq(app.observeAHQuote({}, {itemID=10938,quantity=1,total=1}),nil)
    emit(scanEvents.ScanComplete,{auction(10938,210),auction(10940,100)})
    eq(app.shoppingFresh(),nil);eq(type(app.shopping.pendingScan),'table')
    eq(app.performAHBuy(p,{phase='ah_load'}),false);eq(requests,0)
    Auctionator.State.FullScanFrameRef.inProgress=false;app.shoppingPoll();app.refreshNextStep()
    eq(app.shoppingFresh(),true);eq(app.unitPrice(10938),210);eq(app.nextStepWindow.action.enabled,true)
    eq(app.shopping.pendingScan,nil)
    Auctionator.State,C_AuctionHouse=oldState,oldAH;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('eight-hour wall-clock pause expires prices even if the client timer did not advance',function()
    beginShopping();local oldTime=time;local wall=100000;time=function()return wall end
    fullscan();local p=app.shoppingPlan();local ready=app.shopping.ready
    wall=wall+1799;eq(app.shoppingFresh(),true);wall=wall+1;eq(app.shoppingFresh(),true)
    wall=wall+1;eq(app.shoppingFresh(),false)
    wall=wall+8*3600;eq(app.shoppingFresh(),false);eq(app.shopping.ready,ready)
    eq(app.performAHBuy(p,{phase='ah_load'}),false);eq(app.nextStepWindow.action.enabled,false)
    time=oldTime;app.shoppingEvent('AUCTION_HOUSE_CLOSED');app.shopping.ready=nil;app.shopping.prices=nil
end)
test('automatic next-action purchase keeps full quantities and rejects an earlier scan plan',function()
    routeGoalSetup();eq(app.shopping.points,5);local plan=app.shoppingPlan();eq(plan.target,73)
    eq(app.searchShopping(),true)
    local oldState,oldAH,oldBuying=Auctionator.State,C_AuctionHouse,Auctionator.Buying
    local buyer=object('Frame');buyer:Hide();local amount=0
    Auctionator.State={BuyCommodityFrameRef=buyer};Auctionator.Buying={Events={ShowCommodityBuy='full-target-load'}}
    Auctionator.EventBus.Fire=function(_,_,_,row)
        amount=row.purchaseQuantity;buyer.expectedItemID=row.itemKey.itemID;buyer.selectedQuantity=amount;buyer:Show()
    end
    C_AuctionHouse={MakeItemKey=function(id)return {itemID=id}end,GetItemKeyInfo=function()return {isCommodity=true}end}
    eq(app.performAHBuy(plan,app.ahBuyStatus(plan)),true);eq(amount,59) -- not the remembered 5 minus 3
    local originalKey=app.purchaseKey(plan);local serial=plan.scanSerial
    fullscan({auction(765,14),auction(2447,28),auction(3371,3)})
    eq(app.purchaseKey(app.shoppingPlan()),originalKey);assert(app.shopping.scanSerial>serial)
    amount=0;eq(app.performAHBuy(plan,{phase='ah_load'}),false);eq(amount,0)
    Auctionator.State,C_AuctionHouse,Auctionator.Buying=oldState,oldAH,oldBuying;routeGoalCleanup()
end)
test('raw commodity events reprice live offers without depending on Auctionator widget hooks',function()
    routeGoalSetup();local oldAH=C_AuctionHouse;local calls=0
    C_AuctionHouse={GetNumCommoditySearchResults=function(id)eq(id,765);return 2 end,
        GetCommoditySearchResultInfo=function(_,i)calls=calls+1;return {unitPrice=i==1 and 19 or 17,quantity=10}end}
    app.events.scripts.OnEvent(app.events,'COMMODITY_SEARCH_RESULTS_UPDATED',765)
    eq(calls,2);eq(app.unitPrice(765),17)
    emit(scanEvents.ScanStart);app.events.scripts.OnEvent(app.events,'COMMODITY_SEARCH_RESULTS_UPDATED',765)
    eq(calls,2);eq(app.shopping.livePrices,nil)
    C_AuctionHouse=oldAH;routeGoalCleanup()
end)
test('scan restart clears managed quotes but preserves an already-confirmed pending purchase',function()
    beginShopping();fullscan();stock[10938]=0;app.refresh(false);local oldState=Auctionator.State
    local p=app.shoppingPlan(1);app.setAHOrder(p);local id=p.rows[1].id
    local dialog={QuantityInput=object('EditBox')};local buyer={craftDejaManagedID=id,selectedQuantity=1,QuantityCheckConfirmationDialog=dialog}
    Auctionator.State={BuyCommodityFrameRef=buyer}
    local q=app.observeAHQuote(dialog,{itemID=id,quantity=1,total=1});dialog.QuantityInput:SetText('1')
    eq(app.markAHConfirm(dialog),true);local t=app.purchasePending();eq(t.status,'pending')
    emit(scanEvents.ScanStart);eq(buyer.selectedQuantity,0);eq(dialog.craftDejaQuote,nil)
    eq(app.purchasePending(),t);eq(app.markAHConfirm(dialog),false)
    app.ahBuyingEvent('COMMODITY_PURCHASED',id,1);eq(app.confirmedMail(id),1);eq(t.status,'succeeded')
    Auctionator.State=oldState;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('completion still processing at AH close cannot unlock a later visit',function()
    beginShopping();local oldState=Auctionator.State
    Auctionator.State={FullScanFrameRef={inProgress=true}}
    emit(scanEvents.ScanStart);emit(scanEvents.ScanComplete,{auction(10938,1)})
    eq(type(app.shopping.pendingScan),'table')
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');eq(app.shopping.pendingScan,nil)
    Auctionator.State.FullScanFrameRef.inProgress=false;app.shoppingEvent('AUCTION_HOUSE_SHOW')
    emit(scanEvents.ScanComplete,{auction(10938,1)});eq(app.shoppingFresh(),nil)
    Auctionator.State=oldState;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('native quantity and total match the full route before requesting a quote',function()
    routeGoalSetup();local plan=app.shoppingPlan();app.setAHOrder(plan)
    local oldState,oldMoney=Auctionator.State,GetMoney
    local buyer=object('Frame');buyer:Show();buyer.expectedItemID=765;buyer.selectedQuantity=2
    buyer.results={{price=14,quantity=39},{price=15,quantity=70}}
    buyer.DetailsContainer={Quantity=object('EditBox'),BuyButton=object('Button')}
    buyer.DetailsContainer.Quantity:SetText('2')
    function buyer:UpdateView()self.DetailsContainer.Quantity:SetText(tostring(self.selectedQuantity))end
    function buyer:GetPrices()
        local left,total=self.selectedQuantity,0
        for _,r in ipairs(self.results)do local take=math.min(left,r.quantity);left=left-take;total=total+take*r.price end
        return self.results[1].price,total
    end
    local requested=0
    function buyer:BuyClicked()requested=requested+1;eq(self.selectedQuantity,59);eq(self.DetailsContainer.Quantity:GetText(),'59')end
    Auctionator.State={BuyCommodityFrameRef=buyer};GetMoney=function()return 100000 end
    local offer=app.ahBuyStatus(plan);eq(offer.phase,'ah_buy');eq(offer.quantity,59);eq(offer.cost,846)
    eq(buyer.DetailsContainer.Quantity:GetText(),'59');eq(requested,0)
    function buyer:UpdateView()self.selectedQuantity=2;self.DetailsContainer.Quantity:SetText('2')end
    local blocked=app.ahBuyStatus(plan);eq(blocked.disabled,true);eq(blocked.phase,'ah_wait')
    eq(app.performAHBuy(plan,offer),false);eq(requested,0)
    function buyer:UpdateView()self.DetailsContainer.Quantity:SetText(tostring(self.selectedQuantity))end
    offer=app.ahBuyStatus(plan);eq(app.performAHBuy(plan,offer),true);eq(requested,1)
    function buyer:UpdateView()self.DetailsContainer.Quantity:SetText('2')end
    eq(app.applyNativeAHQuantity(buyer,765,59,846),false)
    function buyer:UpdateView()self.DetailsContainer.Quantity:SetText(tostring(self.selectedQuantity))end
    eq(app.applyNativeAHQuantity(buyer,765,59,845),false)
    Auctionator.State,GetMoney=oldState,oldMoney;routeGoalCleanup()
end)
test('both confirmed herbs lead through partial mail collection, vendor vials and ready crafts',function()
    vialPlanSetup();stock[765]=0;stock[2447]=0;stock[3371]=0;app.refresh(false)
    local plan=app.shoppingPlan();app.setAHOrder(plan)
    local names={}
    for _,r in ipairs(plan.rows)do
        names[r.id]=r.name
        if not r.vendor then
            local dialog={};app.observeAHQuote(dialog,{itemID=r.id,quantity=r.buy,total=r.buy*r.unit})
            eq(app.markAHConfirm(dialog),true);app.purchaseSignal('COMMODITY_PURCHASE_SUCCEEDED')
        end
    end
    local task=app.nextStep(plan);eq(task.kind,'mail');eq(task.mailCount,2)
    assert(task.body:find(names[765],1,true));assert(task.body:find(names[2447],1,true))
    assert(task.after:find(names[3371],1,true))
    app.renderNextStep(plan,true);eq(app.nextStepWindow.action:GetText(),app.caption('step_mail_check'))
    -- Checking is a real stock refresh; it neither opens recipe details nor
    -- falsely marks the post as collected.
    local oldDetails=app.showDetails;local details=0;app.showDetails=function()details=details+1 end
    app.nextStepWindow.action.scripts.OnClick();eq(details,0);eq(app.confirmedMail(765),5)
    app.showDetails=oldDetails
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');now=now+3
    app.ahBuyingEvent('MAIL_SHOW');stock[765]=3;stock[2447]=5
    app.ahBuyingEvent('BAG_UPDATE_DELAYED');app.refresh(false)
    app.refreshNextStep(true);plan=app.nextStepWindow.plan
    eq(app.confirmedMail(765),2);eq(app.confirmedMail(2447),0)
    task=app.nextStep(plan);eq(task.kind,'mail');eq(task.mailCount,1)
    stock[765]=5;app.ahBuyingEvent('BAG_UPDATE_DELAYED');app.ahBuyingEvent('MAIL_CLOSED');app.refresh(false)
    eq(app.confirmedMail(765),0)
    app.refreshNextStep(true);plan=app.nextStepWindow.plan
    task=app.nextStep(plan);eq(task.kind,'vendor');eq(task.id,3371)
    stock[3371]=5;app.refresh(false);app.refreshNextStep(true);plan=app.nextStepWindow.plan
    task=app.nextStep(plan);eq(task.kind,'craft');eq(task.available,5)
end)
test('rank trainer selection matches profession, exact rank and faction with local map priority',function()
    local oldMap,oldFaction=C_Map,faction
    C_Map={GetBestMapForUnit=function()return 1458 end,GetPlayerMapPosition=function()return {x=.52,y=.75}end}
    faction='Horde'
    local t=app.nearestRankTrainer(171,75);eq(t.npc,4609);eq(t.fromCap,75);eq(t.toCap,150)
    eq(app.nearestRankTrainer(171,150).npc,4611)
    eq(app.nearestRankTrainer(171,225).npc,1386);eq(app.nearestRankTrainer(171,300),nil)
    faction='Alliance';t=app.nearestRankTrainer(171,75);eq(t.side,'Alliance');assert(t.npc~=4609)
    faction='Unknown';eq(app.nearestRankTrainer(171,75),nil)
    eq(app.nearestRankTrainer(99999,75),nil)
    local professions={}
    for _,r in ipairs(app.trainerLocations)do
        assert(r.x>=0 and r.x<=100 and r.y>=0 and r.y<=100)
        assert(r.toCap==r.fromCap+75 and r.name and r.npc and r.map)
        professions[r.profession]=true
    end
    eq(count(professions),9)
    C_Map,faction=oldMap,oldFaction
end)
test('skill cap automatically marks the trainer and map button opens his map, then rank learning clears the task',function()
    stockCraftSetup();local oldMap,oldFrame,oldFaction=C_Map,WorldMapFrame,faction
    faction='Horde';app.options.language='de'
    local canvas=object('Frame');canvas:SetSize(600,500)
    WorldMapFrame=object('Frame');WorldMapFrame:Hide()
    function WorldMapFrame:GetCanvas()return canvas end
    function WorldMapFrame:GetMapID()return self.map end
    function WorldMapFrame:SetMapID(id)self.map=id end
    C_Map={GetBestMapForUnit=function()return 1458 end,GetPlayerMapPosition=function()return {x=.647,y=.386}end,
        GetMapInfo=function()return {name='Undercity'}end,CanSetUserWaypointOnMap=function()return false end}
    profile.skillLevel=75;app.refresh(true);app.refreshNextStep(true)
    local f=app.nextStepWindow;eq(f.task.kind,'rank');eq(f.task.trainer.npc,4609)
    eq(app.mapTarget.npc,4609);eq(app.mapTarget.map,1458);near(app.mapTarget.x,51.6);near(app.mapTarget.y,74.6)
    eq(f.action.enabled,true);assert(f.place:GetText():find('Doktor Marsh',1,true));eq(WorldMapFrame:IsShown(),false)
    f.action.scripts.OnClick();eq(WorldMapFrame:IsShown(),true);eq(WorldMapFrame.map,1458)
    eq(app.mapPin:IsShown(),true);eq(app.mapPin.target.npc,4609)
    profile.maxSkillLevel=150;app.refresh(true);app.refreshNextStep(true);assert(f.task.kind~='rank')
    profile.maxSkillLevel=300;profile.skillLevel=300;app.refresh(true);app.refreshNextStep(true)
    eq(f.task.kind,'rank');eq(f.task.trainer,nil);eq(f.action.enabled,false)
    C_Map,WorldMapFrame,faction=oldMap,oldFrame,oldFaction;app.options.language='auto';stockCraftCleanup()
end)
test('character-level requirement takes priority over trainer travel and clears on level up',function()
    stockCraftSetup();local oldLevel,oldFaction,oldMap=UnitLevel,faction,C_Map
    faction='Horde';UnitLevel=function()return 7 end;app.levelUpValue=nil;app.options.language='de'
    C_Map={GetBestMapForUnit=function()return 1458 end,GetPlayerMapPosition=function()return {x=.51,y=.74}end,
        GetMapInfo=function()return {name='Undercity'}end}
    profile.skillLevel=75;app.mapTarget=nil;app.character.mapTarget=nil
    app.refresh(true);app.refreshNextStep(true)
    local f=app.nextStepWindow;eq(f.task.kind,'rank');eq(f.task.levelBlocked,true);eq(f.task.requiredLevel,10)
    assert(f.body:GetText():find('Charakterstufe 10',1,true));assert(f.body:GetText():find('aktuell 7',1,true))
    eq(f.action:GetText(),app.caption('trainer_later'));eq(app.mapTarget,nil)
    assert(app.main.recipe:GetText():find('10',1,true));eq(f.attentionActive,true)
    -- The event may arrive before UnitLevel updates. Its actual new level must
    -- immediately switch back to the trainer task and restore auto-marking.
    app.events.scripts.OnEvent(app.events,'PLAYER_LEVEL_UP',10)
    eq(f.task.levelBlocked,false);eq(app.mapTarget.npc,4609);eq(f.action:GetText(),app.caption('trainer_show'))
    eq(app.playerLevel(),10)
    UnitLevel=function()return 10 end;app.levelUpValue=nil;eq(app.rankTrainerTask().levelBlocked,false)
    UnitLevel=function()return 0 end;eq(app.rankTrainerTask().levelBlocked,false)
    UnitLevel, faction,C_Map=oldLevel,oldFaction,oldMap;app.levelUpValue=nil;app.options.language='auto';stockCraftCleanup()
end)
test('audit reagent comparisons are ordered, alternative-aware and reject incomplete data',function()
    local a=app.auditMaterials({{amount=2,choices={7,5,7}},{amount=1,choices={8}}})
    eq(a,app.auditMaterials({{amount=1,choices={8}},{amount=2,choices={5,7}}}))
    eq(app.auditMaterials({{amount=1,choices={7}},{amount=1,choices={7}}}),app.auditMaterials({{amount=2,choices={7}}}))
    assert(a~=app.auditMaterials({{amount=1,choices={8}},{amount=3,choices={5,7}}}))
    eq(app.auditMaterials({}),nil);eq(app.auditMaterials({{amount=1,choices={}}}),nil)
    eq(app.auditMaterials({{amount=0,choices={7}}}),nil);eq(app.auditMaterials({{amount=1,choices={'7'}}}),nil)
end)
test('profession read audits unknown and changed recipes without replacing reference facts',function()
    stockCraftSetup();app.character.recipeAudit=nil
    live[995501]=info('Changed potion',0,true,{[765]=2,[2447]=1,[3371]=1})
    live[995599]=info('Brand new potion',0,true,{[765]=3})
    local read=app.readRecipes(app.readProfession());eq(app.auditCount(),2)
    eq(app.catalog[171][995501].ingredients[765],1);eq(app.catalog[171][995599],nil)
    local actual={};for _,g in ipairs(read.recipes[995501].groups)do actual[g.choices[1]]=g.amount end
    eq(actual[765],2);eq(read.recipes[995599].learned,true)
    local entries=app.character.recipeAudit.entries
    assert(entries['171:995501:ingredients'].actual:find('2*765',1,true))
    assert(entries['171:995599:unknown_recipe'].actual:find('3*765',1,true))
    app.readRecipes(app.readProfession());eq(app.auditCount(),2)
    eq(app.character.recipeAudit.checks[171].visible,2)
    local before=entries['171:995599:unknown_recipe'].actual
    live[995501].schematic=nil;live[995599].schematic=nil
    app.readRecipes(app.readProfession());eq(app.auditCount(),2)
    eq(entries['171:995599:unknown_recipe'].actual,before)
    app.character.recipeAudit=nil;stockCraftCleanup()
end)
test('audit keeps colour evidence across skill changes until a reviewed reference revision resolves it',function()
    app.character.recipeAudit=nil
    local p={id=171,skill=54,cap=75};local ref={yellow=55,green=75,grey=95,ingredients={[765]=1}}
    local r={id=995511,liveName='Colour test',confirmed=true,learned=true,colour='yellow',materialsFromClient=true,groups={{amount=1,choices={765}}}}
    app.auditRecipe(p,r,ref);eq(app.auditCount(),1)
    local e=app.character.recipeAudit.entries['171:995511:difficulty'];eq(e.actual,'yellow');eq(e.expected,'orange');eq(e.skill,54)
    p.skill=55;app.auditRecipe(p,r,ref);eq(app.auditCount(),1);eq(e.skill,54)
    local revision=app.referenceData.version;app.referenceData.version=revision..'-reviewed'
    app.auditRecipe(p,r,ref);eq(app.auditCount(),0);app.referenceData.version=revision
    app.character.recipeAudit=nil
end)
test('audit storage is bounded and remains independent from flow logging',function()
    app.character.recipeAudit=nil;local oldLogging=app.options.flowLogging;app.options.flowLogging=false
    local p={id=171,skill=75,cap=150}
    for id=990001,990205 do app.auditRecipe(p,{id=id,confirmed=true,learned=true,liveName='New potion '..id},nil)end
    eq(app.auditCount(),200);eq(app.character.recipeAudit.dropped,5)
    eq(app.character.recipeAudit.entries['171:990001:unknown_recipe'],nil)
    local report=app.recipeAuditExport(20)
    assert(report:find('Showing latest 20',1,true));assert(report:find('990205',1,true));assert(not report:find('recipe=990006',1,true))
    assert(not report:find('test-character',1,true))
    local oldBuild=GetBuildInfo;GetBuildInfo=function()return '1.60.1','new-build',nil,16001 end
    app.auditRecipe(p,{id=990205,confirmed=true,learned=true,liveName='New potion 990205'},nil)
    eq(app.auditCount(),200);eq(app.character.recipeAudit.entries['171:990205:unknown_recipe'].build,'new-build')
    GetBuildInfo=oldBuild
    app.options.flowLogging=oldLogging;app.character.recipeAudit=nil
end)
test('audit report command, log integration, data badge and saved observations survive reopening',function()
    stockCraftSetup();app.character.recipeAudit=nil
    app.auditRecipe(app.active.profile,{id=995599,confirmed=true,learned=true,liveName='New potion',materialsFromClient=true,groups={{amount=2,choices={765}}}},nil)
    eq(app.auditCount(),1);local saved=app.character.recipeAudit
    app.initialize();eq(app.character.recipeAudit,saved)
    for _,language in ipairs({'de','en'})do
        app.options.language=language;app.renderMain();app.command('data')
        local f=app.recipeAuditWindow;eq(f:IsShown(),true)
        assert(f.box:GetText():find('995599',1,true));assert(f.status:GetText():find(app.referenceData.packaged,1,true))
        assert(app.main.dataStatus:GetText():find(app.referenceData.packaged,1,true))
        eq(app.main.dataButton:GetText(),app.caption('audit_reports_button',1))
        f:Hide();app.main.dataButton.scripts.OnClick();eq(f:IsShown(),true)
    end
    assert(app.logExport():find('CraftDeja recipe observations',1,true))
    app.applyScale(.8);eq(app.recipeAuditWindow:GetScale(),.8)
    app.recipeAuditWindow.clear.scripts.OnClick();eq(app.auditCount(),0)
    assert(app.recipeAuditWindow.box:GetText():find(app.caption('audit_empty'),1,true))
    app.options.language='auto';app.recipeAuditWindow:Hide();stockCraftCleanup()
end)
local poisonFrameBackup
local function poisonSetup()
    app.vendorBuyEvent('MERCHANT_CLOSED');app.vendorPurchase.pending=nil;app.shoppingEvent('AUCTION_HOUSE_CLOSED')
    app.clearNativeCraft();app.craftBatch=nil;app.character.poisons={targets={},stockTargets={},serial=0,restock=false};app.character.ahPurchase=nil;app.character.ahMail={}
    app.poisonDone=false;app.poisonAutoPrepare=false;app.poisonLastGUID=nil
    poisonFrameBackup=ProfessionsFrame;ProfessionsFrame=nativeCraftFrame(990101)
    local page=ProfessionsFrame.CraftingPage
    page.SelectRecipe=function(_,r)page.selected=r.recipeID;page.CreateMultipleInputBox:SetValue(1)end
    profile={professionID=40,professionName='Poisons',skillLevel=100,maxSkillLevel=100}
    live={[990101]=info('Instant test poison',3,true,{[2928]=1,[3371]=1}),[990102]=info('Deadly test poison',3,true,{[2928]=2,[2930]=1,[3371]=1})}
    for id,r in pairs(live)do r.recipeID=id;r.schematic.quantityMin=1;r.schematic.quantityMax=1;r.schematic.outputItemID=id+10 end
    stock={[2928]=2,[2930]=0,[3371]=0,[990111]=0,[990112]=0};prices={[2928]=999,[2930]=999,[3371]=999}
    app.sessions={};app.events.scripts.OnEvent(app.events,'TRADE_SKILL_SHOW')
end
local function poisonCleanup()
    app.vendorBuyEvent('MERCHANT_CLOSED');app.vendorPurchase.pending=nil;app.poisonVendorQueue=nil
    app.clearNativeCraft();app.craftBatch=nil;app.character.poisons=nil;app.poisonAutoPrepare=false
    if app.poisonWindow then app.poisonWindow:Hide()end
    ProfessionsFrame=poisonFrameBackup;fixtures(100);app.refresh(true)
end
local function poisonOrder()
    eq(app.setPoisonTarget(990101,4),true);eq(app.setPoisonTarget(990102,3),true);eq(app.startPoisonOrder(),true)
end
test('all selected A backgrounds follow the active profession and catalogue independently',function()
    eq(count(app.professionThemes),10)
    for id in pairs(app.professionThemes)do app.applyProfessionTheme(app.main,id);eq(app.main.themeProfession,id)end
    app.applyProfessionTheme(app.main,9999);eq(app.main.themeProfession,0);eq(app.main.themeHeader:IsShown(),false)
    app.refreshProfessionThemes()
end)
test('poison window opens with one slider and numeric output target per learned recipe',function()
    poisonSetup();eq(app.active.profile.id,40);eq(app.poisonWindow:IsShown(),true);eq(#app.poisonWindow.rows,2)
    eq(app.poisonWindow.themeProfession,40)
    eq(app.setPoisonTarget(990101,999),true);eq(app.character.poisons.targets[990101],200)
    eq(app.setPoisonTarget(990101,-2),true);eq(app.character.poisons.targets[990101],0)
    app.poisonWindow.rows[1].box:SetText('4');app.poisonWindow.rows[1].box.scripts.OnTextChanged(app.poisonWindow.rows[1].box)
    eq(app.character.poisons.targets[990101],4)
    eq(app.setPoisonTarget(990102,3),true);eq(app.startPoisonOrder(),true)
    local p=app.poisonPlan();eq(p.crafts,7);local rows={};for _,r in ipairs(p.rows)do rows[r.id]=r end
    eq(rows[2928].total,10);eq(rows[2928].buy,8);eq(rows[2930].total,3);eq(rows[3371].total,7)
    eq(app.setPoisonTarget(990101,8),false)
    local saved=app.character.poisons;app.initialize();eq(app.character.poisons,saved)
    poisonCleanup()
end)
test('poison plans reject variable output and changed or incomplete live ingredients',function()
    poisonSetup();eq(app.setPoisonTarget(990101,4),true)
    live[990101].schematic.quantityMax=2;eq(app.startPoisonOrder(),false)
    live[990101].schematic.quantityMax=1;eq(app.startPoisonOrder(),true)
    app.active.recipes[990101].groups[1].amount=20
    local p,why=app.poisonPlan();eq(p,nil);eq(why,'poison_changed')
    poisonCleanup()
end)
test('poison combined AH list respects the fresh scan and uses one frozen order budget',function()
    poisonSetup();poisonOrder();shoppingAPI();app.shoppingEvent('AUCTION_HOUSE_SHOW')
    emit(scanEvents.ScanStart)
    eq(app.shoppingPlan(),nil)
    fullscan({auction(2928,1),auction(2930,2),auction(3371,1)})
    local p=app.shoppingPlan();eq(p.poisonAggregate,true);eq(p.goalMode,'poisons');eq(p.crafts,7)
    eq(app.searchShopping(),true);local quantities={}
    for _,r in ipairs(submitted)do quantities[r.searchString]=r.quantity end
    eq(quantities['Item 2928'],8);eq(quantities['Item 2930'],3);eq(quantities['Item 3371'],7)
    local key=app.purchaseKey(p);app.character.craftRevision=(app.character.craftRevision or 0)+1
    eq(app.purchaseKey(app.poisonPlan()),key)
    emit(scanEvents.ScanStart);eq(app.shoppingPlan(),nil)
    poisonCleanup()
end)
test('grey poison recipes prepare exact native batches and advance only after successful casts',function()
    poisonSetup();stock[2928]=10;stock[2930]=3;stock[3371]=7;poisonOrder()
    local oldCraft=C_TradeSkillUI.CraftRecipe;local calls=0
    C_TradeSkillUI.CraftRecipe=function(id,n)
        calls=calls+1
        for i=1,n do
            for _,g in ipairs(app.active.recipes[id].groups)do stock[g.choices[1]]=stock[g.choices[1]]-g.amount end
            app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_SUCCEEDED','player','poison-'..id..'-'..i,id)
        end
    end
    eq(app.preparePoisonQueue(),true);eq(calls,0);eq(app.nativeCraftHandoff.count,4)
    local page=ProfessionsFrame.CraftingPage
    page.CreateButton.scripts.OnClick();eq(calls,1);eq(app.character.poisons.job.remaining[990101],0)
    app.poisonTick();eq(calls,1);eq(app.nativeCraftHandoff.id,990102);eq(app.nativeCraftHandoff.count,3)
    page.CreateButton.scripts.OnClick();eq(calls,2);eq(app.character.poisons.job,nil);eq(app.poisonDone,true)
    app.poisonTick();eq(calls,2)
    C_TradeSkillUI.CraftRecipe=oldCraft;poisonCleanup()
end)
test('poison vendor queue buys shared materials once and waits for each inventory acknowledgement',function()
    poisonSetup();poisonOrder()
    local oldInfo,oldNum,oldLink,oldMoney,oldMax,oldBuy=C_MerchantFrame,GetMerchantNumItems,GetMerchantItemLink,GetMoney,GetMerchantItemMaxStack,BuyMerchantItem
    local items={2928,2930,3371};local costs={100,50,5};local units={5,1,1};local calls={}
    C_MerchantFrame={GetItemInfo=function(slot)return {name='Item '..items[slot],price=costs[slot],stackCount=units[slot],numAvailable=-1}end}
    GetMerchantNumItems=function()return 3 end;GetMerchantItemLink=function(slot)return 'item:'..items[slot]end
    GetMoney=function()return 100000 end;GetMerchantItemMaxStack=function()return 20 end
    BuyMerchantItem=function(slot,n)calls[#calls+1]={id=items[slot],n=n}end
    app.vendorBuyEvent('MERCHANT_SHOW');app.showPoisonPlanner();eq(app.startPoisonVendorQueue(),true);eq(#calls,1)
    app.vendorBuyTick();eq(#calls,1)
    for i=1,3 do local c=calls[i];assert(c);stock[c.id]=stock[c.id]+c.n;app.vendorBuyTick()end
    eq(#calls,3);eq(app.poisonVendorQueue,nil)
    eq(stock[2928],12);eq(stock[2930],3);eq(stock[3371],7)
    -- A second order must stop if a not-yet-bought ingredient becomes dearer.
    app.cancelPoisonOrder();stock[2928]=2;stock[2930]=0;stock[3371]=0;calls={};poisonOrder()
    app.showPoisonPlanner();eq(app.startPoisonVendorQueue(),true);eq(#calls,1)
    local first=calls[1];stock[first.id]=stock[first.id]+first.n;costs[2]=500
    app.vendorBuyTick();eq(#calls,1);eq(app.poisonVendorQueue,nil)
    -- Closing the vendor cancels the queue; acknowledgements never trigger hidden retries.
    costs[2]=50;app.vendorPurchase.pending=nil;app.showPoisonPlanner()
    eq(app.startPoisonVendorQueue(),true);eq(#calls,2)
    app.vendorBuyEvent('MERCHANT_CLOSED');eq(app.poisonVendorQueue,nil);app.vendorBuyTick();eq(#calls,2)
    C_MerchantFrame,GetMerchantNumItems,GetMerchantItemLink,GetMoney,GetMerchantItemMaxStack,BuyMerchantItem=oldInfo,oldNum,oldLink,oldMoney,oldMax,oldBuy
    poisonCleanup()
end)
test('poison material popup shows the aggregate, scales and refuses partial output batches',function()
    poisonSetup();poisonOrder();app.showPoisonMaterials()
    local f=app.poisonMaterialsWindow;eq(f:IsShown(),true);eq(#f.rows,3);eq(f.rows[1].data.total,10)
    app.applyScale(.9);eq(f:GetScale(),.9);eq(f.themeProfession,40)
    app.cancelPoisonOrder();live[990101].schematic.quantityMin=2;live[990101].schematic.quantityMax=2;app.refresh(true)
    app.setPoisonTarget(990101,3);app.setPoisonTarget(990102,0);eq(app.startPoisonOrder(),false);eq(app.character.poisons.job,nil)
    app.setPoisonTarget(990101,4);eq(app.startPoisonOrder(),true);eq(app.character.poisons.job.remaining[990101],2)
    poisonCleanup()
end)
local function restockSetup()
    poisonSetup();app.poisonStockSettleUntil=nil
    stock[990111]=7;stock[990112]=0
    eq(app.setPoisonRestock(true),true)
end
test('stock targets are separate, persistent and compute only the bag deficit',function()
    poisonSetup();app.setPoisonTarget(990101,4)
    stock[990111]=7;stock[990112]=0;eq(app.setPoisonRestock(true),true)
    eq(app.character.poisons.targets[990101],4);eq(app.poisonWindow.rows[1].box:GetText(),'0')
    app.poisonWindow.rows[1].box:SetText('20');app.poisonWindow.rows[1].box.scripts.OnTextChanged(app.poisonWindow.rows[1].box)
    eq(app.character.poisons.stockTargets[990101],20);eq(app.poisonStock(app.active.recipes[990101]).missing,13)
    assert(app.poisonWindow.rows[1].stock:GetText():find('13',1,true))
    local oldInventory=app.inventoryFor
    app.inventoryFor=function(id)if id==990111 then return {bags=7,bank=100,altTotal=200}end;return oldInventory(id)end
    eq(app.startPoisonOrder(),true);eq(app.character.poisons.job.remaining[990101],13)
    eq(app.character.poisons.job.goals[990101],20);eq(app.character.poisons.job.outputs[990101],990111)
    eq(app.setPoisonRestock(false),false);eq(app.setPoisonTarget(990101,10),false)
    local rows={};for _,r in ipairs(app.poisonPlan().rows)do rows[r.id]=r end
    eq(rows[2928].total,13);eq(rows[2928].buy,11);eq(rows[3371].total,13)
    local saved=app.character.poisons;app.initialize();eq(app.character.poisons,saved)
    app.inventoryFor=oldInventory
    app.cancelPoisonOrder();eq(app.setPoisonRestock(false),true);eq(app.poisonWindow.rows[1].box:GetText(),'4')
    eq(app.setPoisonRestock(true),true);eq(app.poisonWindow.rows[1].box:GetText(),'20')
    poisonCleanup()
end)
test('satisfied stock targets create no order and unknown output stock fails closed',function()
    restockSetup();app.setPoisonTarget(990101,7);eq(app.startPoisonOrder(),true)
    eq(app.character.poisons.job,nil);eq(app.poisonDone,true)
    app.setPoisonTarget(990101,20);eq(app.poisonDone,false);stock[990111]=nil
    eq(app.startPoisonOrder(),false);eq(app.character.poisons.job,nil)
    stock[990111]=7;live[990101].schematic.outputItemID=nil
    eq(app.startPoisonOrder(),false);eq(app.character.poisons.job,nil)
    poisonCleanup()
end)
test('restock rounds missing units to full recipes and rejects duplicate output targets',function()
    restockSetup();stock[990111]=1;app.setPoisonTarget(990101,6)
    live[990101].schematic.quantityMin=2;live[990101].schematic.quantityMax=2;app.refresh(true)
    eq(app.poisonStock(app.active.recipes[990101]).crafts,3)
    eq(app.startPoisonOrder(),true);eq(app.character.poisons.job.remaining[990101],3)
    app.cancelPoisonOrder();live[990102].schematic.outputItemID=990111;app.refresh(true)
    app.setPoisonTarget(990102,5);eq(app.startPoisonOrder(),false);eq(app.character.poisons.job,nil)
    poisonCleanup()
end)
test('restock reconciles incoming finished items but never expands an approved order',function()
    restockSetup();app.setPoisonTarget(990101,20);eq(app.startPoisonOrder(),true)
    local serial=app.character.poisons.job.serial
    stock[990111]=19;app.refresh(false);eq(app.character.poisons.job.remaining[990101],1)
    stock[990111]=2;app.refresh(false);eq(app.character.poisons.job.remaining[990101],1)
    eq(app.character.poisons.job.serial,serial)
    stock[990111]=20;app.refresh(false);eq(app.character.poisons.job,nil);eq(app.poisonDone,true)
    stock[990111]=0;app.refresh(false);eq(app.character.poisons.job,nil)
    eq(app.startPoisonOrder(),true);eq(app.character.poisons.job.remaining[990101],20)
    poisonCleanup()
end)
test('restock native batch reaches the target once without hidden crafts or refill loops',function()
    restockSetup();app.setPoisonTarget(990101,10)
    stock[2928]=10;stock[3371]=10;eq(app.startPoisonOrder(),true)
    local oldCraft=C_TradeSkillUI.CraftRecipe;local calls=0
    C_TradeSkillUI.CraftRecipe=function(id,n)
        calls=calls+1;eq(n,3)
        for i=1,n do
            stock[2928]=stock[2928]-1;stock[3371]=stock[3371]-1
            -- Simulate bag updates arriving before the spell success, then a normal refresh.
            stock[990111]=stock[990111]+1;app.refresh(false)
            app.events.scripts.OnEvent(app.events,'UNIT_SPELLCAST_SUCCEEDED','player','stock-cast-'..i,id)
        end
    end
    eq(app.preparePoisonQueue(),true);eq(calls,0);eq(app.nativeCraftHandoff.count,3)
    ProfessionsFrame.CraftingPage.CreateButton.scripts.OnClick();eq(calls,1);eq(stock[990111],10)
    eq(app.character.poisons.job,nil);eq(app.poisonDone,true)
    now=now+3;app.poisonTick();eq(calls,1)
    stock[990111]=8;app.refresh(false);app.poisonTick();eq(calls,1);eq(app.character.poisons.job,nil)
    eq(app.startPoisonOrder(),true);eq(app.character.poisons.job.remaining[990101],2)
    C_TradeSkillUI.CraftRecipe=oldCraft;poisonCleanup()
end)
test('order overview follows confirmed shopping, mail, vendor supplies and aggregate poison crafts',function()
    poisonSetup();app.character.orderProgress=nil;poisonOrder()
    prices[2928]=10;prices[2930]=10;app.refresh(false)
    local p=app.poisonPlan();local v=app.orderOverview(p,{kind='ah'})
    eq(v.ah.n,11);eq(v.mail.n,0);eq(v.vendor.n,7);eq(v.craft.n,7);eq(v.finished,false)
    app.character.ahPurchase.transaction={id=2928,quantity=8,applied=0,status='pending'}
    v=app.orderOverview(p,{kind='ah_wait'});eq(v.ah.n,11);eq(v.mail.n,0);eq(v.finished,false)
    app.character.ahPurchase.transaction=nil
    app.character.ahMail={[2928]={quantity=8},[2930]={quantity=3}}
    v=app.orderOverview(p,{kind='mail'});eq(v.ah.n,0);eq(v.mail.n,11);eq(v.vendor.n,7);eq(v.mail.state,'active')
    stock[2928]=10;stock[2930]=3;app.character.ahMail={};app.refresh(false)
    v=app.orderOverview(app.poisonPlan(),{kind='vendor'});eq(v.mail.n,0);eq(v.vendor.n,7)
    stock[3371]=7;app.refresh(false)
    v=app.orderOverview(app.poisonRecipePlan(app.active.recipes[990101],2),{kind='craft_native'})
    eq(v.craft.n,7);eq(v.vendor.n,0);eq(v.craft.state,'active')
    for _,id in ipairs({990101,990102})do
        local n=app.character.poisons.job.remaining[id]
        for i=1,n do
            app.orderProgressEvent('UNIT_SPELLCAST_SUCCEEDED','player','overview-'..id..'-'..i,id)
            app.orderProgressEvent('UNIT_SPELLCAST_SUCCEEDED','player','overview-'..id..'-'..i,id)
            app.poisonEvent('UNIT_SPELLCAST_SUCCEEDED','player','overview-'..id..'-'..i,id)
        end
    end
    v=app.orderOverview(nil,{kind='poison'});eq(v.finished,true);eq(v.crafted,7);eq(v.done.state,'done')
    eq(v.craft.n,0);eq(app.character.poisons.job,nil)
    poisonCleanup()
end)
test('overview distinguishes unknown scans, bank tasks and cancelled poison orders',function()
    poisonSetup();app.character.orderProgress=nil;poisonOrder()
    local p=app.poisonPlan();local oldInventory=app.inventoryFor
    app.inventoryFor=function(id)local r=oldInventory(id);if id==2928 then r.bags=0;r.total=10;r.bank=10 end;return r end
    local v=app.orderOverview(p,{kind='bank'});eq(v.storage,10);eq(v.finished,false)
    local budget=app.purchaseState().batch
    v=app.orderOverview(nil,{kind='scan'});eq(v.ah.waiting,true);eq(v.finished,false);eq(app.purchaseState().batch,budget)
    app.inventoryFor=oldInventory;app.cancelPoisonOrder()
    v=app.orderOverview(nil,{kind='poison'});eq(v.unknown,true);eq(v.finished,false)
    poisonCleanup()
end)
test('normal route overview retains its boundary through partial native batches and persists safely',function()
    stockCraftSetup();app.character.orderProgress=nil
    local p=app.materialPlan(app.decision.current.recipe,app.decision.stop)
    local v=app.orderOverview(p,{kind='craft'});local o=app.character.orderProgress;local goal=o.target
    app.orderProgressEvent('UNIT_SPELLCAST_SUCCEEDED','target','ignored',p.recipe.id);eq(o.crafted,0)
    app.orderProgressEvent('UNIT_SPELLCAST_SUCCEEDED','player','one-success',p.recipe.id);eq(o.crafted,1)
    local tiny=app.craftBatchPlan(p.recipe,1,goal)
    v=app.orderOverview(tiny,{kind='craft_native'});eq(v.craft.n,p.crafts);eq(app.character.orderProgress,o)
    app.initialize();eq(app.character.orderProgress,o)
    app.active.profile.skill=goal
    v=app.orderOverview(nil,{kind='rank'});eq(v.finished,true);eq(v.done.state,'done')
    app.active.profile.id=129;v=app.orderOverview(nil,{kind='open'});eq(v.unknown,true);eq(v.crafted,0)
    stockCraftCleanup()
end)
test('overview stations are read-only, localized, scaled with Next step and directly reopenable',function()
    poisonSetup();app.character.orderProgress=nil;poisonOrder()
    for _,lang in ipairs({'de','en'})do
        app.options.language=lang;app.refreshNextStep(true)
        local bar=app.nextStepWindow.orderBar;eq(#bar.columns,5);eq(bar:IsShown(),true)
        eq(bar.columns[1].label:GetText(),app.caption('order_ah'))
        assert(bar.columns[4].count:GetText():find('7',1,true))
        local before=app.character.poisons.job.remaining[990101]
        bar.columns[1].scripts.OnEnter(bar.columns[1]);eq(app.character.poisons.job.remaining[990101],before)
    end
    app.nextStepWindow:Hide();app.command('auftrag');eq(app.nextStepWindow:IsShown(),true)
    app.options.language='auto';poisonCleanup()
end)
local function poisonVendorFixture()
    local old={C_MerchantFrame,GetMerchantNumItems,GetMerchantItemLink,GetMerchantItemMaxStack,GetMoney,BuyMerchantItem,MerchantFrame}
    local f={count=1,id=2928,bought=0}
    C_MerchantFrame={GetItemInfo=function()return {name='Poison supply',price=20,stackCount=1,numAvailable=-1}end}
    GetMerchantNumItems=function()return f.count end;GetMerchantItemLink=function()return 'item:'..f.id end
    GetMerchantItemMaxStack=function()return 20 end;GetMoney=function()return 100000 end
    BuyMerchantItem=function()f.bought=f.bought+1 end
    MerchantFrame=object('Frame');MerchantFrame:Hide() -- TSM has replaced the native merchant UI.
    f.cleanup=function()
        app.vendorBuyEvent('MERCHANT_CLOSED')
        C_MerchantFrame,GetMerchantNumItems,GetMerchantItemLink,GetMerchantItemMaxStack,GetMoney,BuyMerchantItem,MerchantFrame=unpack(old)
    end
    return f
end
test('poison vendor opens the planner without an order, including TSM and once-only dismissal',function()
    poisonSetup();local f=poisonVendorFixture();app.poisonWindow:Hide();app.main:Hide()
    app.vendorBuyEvent('MERCHANT_SHOW');eq(app.poisonWindow:IsShown(),true);eq(app.main:IsShown(),true)
    eq(f.bought,0);eq(app.character.poisons.job,nil);eq(MerchantFrame:IsShown(),false)
    app.poisonWindow:Hide();app.vendorBuyEvent('MERCHANT_UPDATE');eq(app.poisonWindow:IsShown(),false)
    app.vendorBuyEvent('MERCHANT_CLOSED');app.vendorBuyEvent('MERCHANT_SHOW');eq(app.poisonWindow:IsShown(),true)
    f.cleanup();poisonCleanup()
end)
test('delayed poison vendor inventory is retried and ordinary vial vendors are not misidentified',function()
    poisonSetup();local f=poisonVendorFixture();app.poisonWindow:Hide();f.count=0
    app.vendorBuyEvent('MERCHANT_SHOW');eq(app.poisonWindow:IsShown(),false)
    f.count=1;app.vendorBuyTick();eq(app.poisonWindow:IsShown(),true);eq(f.bought,0)
    app.vendorBuyEvent('MERCHANT_CLOSED');app.poisonWindow:Hide();f.id=3371
    app.vendorBuyEvent('MERCHANT_SHOW');app.vendorBuyEvent('MERCHANT_UPDATE');eq(app.poisonWindow:IsShown(),false)
    f.cleanup();poisonCleanup()
end)
test('poison vendor restores a valid cached profession and offers pending ingredients without buying',function()
    poisonSetup();poisonOrder();local f=poisonVendorFixture();local cached=app.active
    ProfessionsFrame:Hide();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
    app.active={profile={id=171,skill=1,cap=75},recipes={},confirmed=1};app.sessions[40]=cached
    app.poisonWindow:Hide();app.vendorBuyEvent('MERCHANT_SHOW')
    eq(app.active,cached);eq(app.poisonWindow:IsShown(),true);eq(app.vendorBuyWindow:IsShown(),true)
    eq(app.vendorPurchase.plan.rows[1].id,2928);eq(app.vendorPurchase.plan.rows[1].missing,8);eq(f.bought,0)
    f.cleanup();poisonCleanup()
end)
test('fresh login poison vendor prompts before opening the correct profession on a real click',function()
    poisonSetup();local f=poisonVendorFixture()
    ProfessionsFrame:Hide();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
    local oldOpen=C_TradeSkillUI.OpenTradeSkill;local calls=0
    C_TradeSkillUI.OpenTradeSkill=function(id)eq(id,40);calls=calls+1;ProfessionsFrame:Show();return true end
    app.active=nil;app.sessions={};app.poisonWindow:Hide()
    app.vendorBuyEvent('MERCHANT_SHOW');eq(calls,0);eq(app.poisonMerchantWindow:IsShown(),true);eq(f.bought,0)
    app.applyScale(.9);eq(app.poisonMerchantWindow:GetScale(),.9)
    app.refreshProfessionThemes();eq(app.poisonMerchantWindow.themeProfession,40)
    app.poisonMerchantWindow.open.scripts.OnClick();eq(calls,1);eq(app.active.profile.id,40)
    eq(app.poisonWindow:IsShown(),true);eq(app.poisonMerchantWindow:IsShown(),false)
    C_TradeSkillUI.OpenTradeSkill=oldOpen;f.cleanup();poisonCleanup()
end)
test('stale poison snapshots never unlock a merchant plan automatically',function()
    poisonSetup();local f=poisonVendorFixture();app.active.invalidated=true;app.poisonWindow:Hide()
    app.vendorBuyEvent('MERCHANT_SHOW');eq(app.poisonMerchantWindow:IsShown(),true);eq(app.poisonWindow:IsShown(),false)
    eq(app.vendorPurchase.plan,nil);eq(f.bought,0)
    app.vendorBuyEvent('MERCHANT_CLOSED');eq(app.poisonMerchantWindow:IsShown(),false)
    f.cleanup();poisonCleanup()
end)
test('closing the profession hides every registered CraftDeja window except the guide without clearing orders',function()
    poisonSetup();poisonOrder();local f=poisonVendorFixture();app.vendorBuyEvent('MERCHANT_SHOW')
    local job=app.character.poisons.job;local targets=app.character.poisons.targets
    local receipt={id=2928,quantity=1,applied=0,status='pending'};app.character.ahPurchase.transaction=receipt
    for _,window in ipairs(app.themedWindows)do window:Show()end
    ProfessionsFrame:Hide();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
    for _,window in ipairs(app.themedWindows)do eq(window:IsShown(),window==app.nextStepWindow)end
    eq(app.nextStepWindow:IsShown(),true);eq(app.character.poisons.job,job);eq(app.character.poisons.targets,targets)
    eq(app.character.ahPurchase.transaction,receipt);eq(app.options.visible,false);eq(app.guideOnly,true)
    -- A purchase acknowledgement/merchant update must not reopen the popup on this visit.
    app.vendorPurchase.pending={id=2928,before=2,quantity=1,when=now};stock[2928]=3
    app.vendorBuyTick();app.vendorBuyEvent('MERCHANT_UPDATE');app.refresh(false)
    for _,window in ipairs(app.themedWindows)do eq(window:IsShown(),window==app.nextStepWindow)end
    eq(f.bought,0);eq(app.character.poisons.job,job)
    app.character.ahPurchase.transaction=nil
    app.events.scripts.OnEvent(app.events,'MERCHANT_SHOW');eq(app.poisonWindow:IsShown(),true)
    eq(f.bought,0);f.cleanup();poisonCleanup()
end)
test('visibility polling also leaves only the guide and reopening the profession restores the adviser',function()
    poisonSetup();poisonOrder();local j=app.character.poisons.job
    app.showPoisonMaterials();app.main:Show();ProfessionsFrame:Hide()
    app.events.scripts.OnUpdate(app.events,1.1)
    eq(app.main:IsShown(),false);eq(app.poisonWindow:IsShown(),false);eq(app.poisonMaterialsWindow:IsShown(),false)
    eq(app.nextStepWindow:IsShown(),true);eq(app.character.poisons.job,j)
    app.events.scripts.OnUpdate(app.events,3.2);eq(app.main:IsShown(),false);eq(app.poisonWindow:IsShown(),false)
    ProfessionsFrame:Show();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_SHOW');app.events.scripts.OnUpdate(app.events,.21)
    eq(app.main:IsShown(),true);eq(app.poisonWindow:IsShown(),true);eq(app.guideOnly,nil);eq(app.character.poisons.job,j)
    poisonCleanup()
end)
print('SUCCESS: '..passed..' assertions')

if os.getenv('EDJ_PREVIEW')then
    local function output(name,rootWindow)
        app.refresh(true);app.main:Show();app.applyScale(.85)
        local root=rootWindow or app.main
        local indexes={};for i,f in ipairs(allFrames)do indexes[f]=i end
        local file=assert(io.open('../'..name..'.tsv','w'))
        for _,f in ipairs(allFrames)do
            local ancestor=f;local visible=true
            while ancestor and ancestor~=root do if not ancestor.shown then visible=false end;ancestor=ancestor.parent end
            if ancestor==root and visible and f.shown and f.kind~='Texture'then
                local point=f.point or {};local colour=f.textColour or {0.9,0.87,0.94}
                file:write(table.concat({indexes[f],indexes[f.parent]or 0,f.kind,f.width,f.height,tostring(point[1]or ''),type(point[2])=='number'and point[2]or 0,type(point[3])=='number'and point[3]or 0,f.fontSize or 12,(f.value or ''):gsub('\n','<NL>'),colour[1],colour[2],colour[3],f.background and 'panel'or ''},'\t'),'\n')
            end
        end
        file:close()
    end
    beginShopping();fullscan();app.shoppingWindow.slider:SetValue(5);app.options.language='de';output('preview_shopping_de',app.shoppingWindow)
    app.options.language='en';output('preview_shopping_en',app.shoppingWindow)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
    fixtures(110);prices[10938]=94;app.options.language='de';output('preview_de')
    profile={professionID=171,professionName='Alchemy',skillLevel=35,maxSkillLevel=75}
    prices={[765]=5,[2447]=8,[3371]=20,[2449]=40};live={[2331]=info('Minor Mana Potion',0,true,{[765]=1,[2447]=1,[3371]=1}),[2329]=info('Elixir of Minor Strength',0,true,{[765]=1,[2449]=1,[3371]=1})}
    app.sessions={};app.options.language='en';output('preview_en')
    faction='Alliance';profile={professionID=185,professionName='Cooking',skillLevel=62,maxSkillLevel=75}
    prices={[5466]=22,[5465]=3};live={[6413]=info('Scorpid Surprise',1,true,{[5466]=1}),[6412]=info('Kaldorei Spider Kabob',1,false,{[5465]=1})}
    app.options.language='de';app.sessions={};app.refresh(true);app.showDetails(app.nextRecipe(),false,true)
    output('preview_details',app.detailsWindow)
    output('preview_next')
    app.showGuide(true);app.options.language='de';output('preview_guide_de')
    app.options.language='en';output('preview_guide_en');app.showGuide(false)

    local function skinOutput(name,root)
        local indexes={};for i,f in ipairs(allFrames)do indexes[f]=i end
        local out=assert(io.open('../../style/'..name..'.tsv','w'))
        for _,f in ipairs(allFrames)do
            local p=f;local visible=true
            while p and p~=root do if not p.shown then visible=false end;p=p.parent end
            if p==root and f.shown and visible then
                local pos=f.point or {};local col=f.textColour or {1,.9,.68}
                local x,y=type(pos[2])=='number'and pos[2]or 0,type(pos[3])=='number'and pos[3]or 0
                out:write(table.concat({indexes[f],indexes[f.parent]or 0,f.kind,f.width,f.height,pos[1]or 'TOPLEFT',x,y,f.fontSize or 11,(f.value or ''):gsub('\n','<NL>'),f.texture or f.normalTexture or '',col[1],col[2],col[3],f.full and '1'or '0',f.layer or '',f.alpha or 1},'\t'),'\n')
            end
        end;out:close()
    end
    poisonSetup();app.options.language='de';poisonOrder();app.showPoisonPlanner();app.showPoisonMaterials();skinOutput('Poisons',app.poisonWindow);skinOutput('PoisonMaterials',app.poisonMaterialsWindow);poisonCleanup();restockSetup();app.options.language='de';app.setPoisonTarget(990101,20);app.setPoisonTarget(990102,10);app.renderPoisonPlanner();skinOutput('Restock',app.poisonWindow);poisonCleanup()
    poisonSetup();app.character.orderProgress=nil;poisonOrder();prices[2928]=10;prices[2930]=10;app.character.ahMail={[2928]={quantity=8},[2930]={quantity=3}};app.options.language='de';app.refresh(false);app.refreshNextStep(true);skinOutput('OrderMail',app.nextStepWindow);poisonCleanup()
    poisonSetup();app.options.language='de';live[990102]=nil;app.refresh(true);app.showPoisonPlanner();skinOutput('PoisonSingle',app.poisonWindow);skinOutput('PoisonMain',app.main)
    for i=3,5 do local id=990100+i;live[id]=info('Beispielgift '..i,3,true,{[2928]=1,[3371]=1});live[id].recipeID=id;live[id].schematic.quantityMin=1;live[id].schematic.quantityMax=1;live[id].schematic.outputItemID=id+10 end
    app.refresh(true);app.showPoisonPlanner();skinOutput('PoisonScroll',app.poisonWindow);poisonCleanup()
    app.shoppingEvent('AUCTION_HOUSE_CLOSED');fixtures(100);app.refresh(true);app.showGuide(false)
    app.options.language='de';app.refreshUI();skinOutput('Main',app.main)
    app.character.recipeAudit=nil
    app.auditRecipe({id=171,skill=75,cap=150},{id=995599,liveName='Beispielrezept',confirmed=true,learned=true,materialsFromClient=true,groups={{amount=2,choices={765}}}},nil)
    app.showRecipeAudit();skinOutput('RecipeAudit',app.recipeAuditWindow);app.renderMain();skinOutput('AuditMain',app.main);app.recipeAuditWindow:Hide()
    beginShopping();fullscan();app.options.language='de';app.renderShopping();skinOutput('Shopping',app.shoppingWindow)
    setupVendorPopup();app.options.language='de';app.renderVendorBuy();skinOutput('Vendor',app.vendorBuyWindow);app.vendorBuyEvent('MERCHANT_CLOSED');vialPlanSetup();app.options.language='de';app.shopping.points=6;app.renderShopping();app.showShopping();skinOutput('Step',app.nextStepWindow);stockCraftSetup();app.options.language='de';app.refreshNextStep(true);skinOutput('CraftStep',app.nextStepWindow);app.craftNext(app.nextStepWindow.plan,true);skinOutput('CraftPrepared',app.nextStepWindow);stockCraftCleanup()

    routeGoalSetup();app.options.language='de';profile.skillLevel=19
    live[995501].name='Elixier der schwachen Verteidigung';live[995502].name='Schwacher Manatrank'
    stock[3371]=2;app.refresh(true);app.refreshNextStep(true);skinOutput('RouteReady',app.nextStepWindow)
    app.renderNextStep(app.shoppingPlan(),true,{kind='mail',key='mail-preview',body=app.caption('step_mail_confirmed',5,'Friedensblume')})
    skinOutput('RouteMail',app.nextStepWindow);app.showShopping();skinOutput('RouteShopping',app.shoppingWindow);routeGoalCleanup()

    inventoryMocks();loginInventory('B');loginInventory('A');person.bags[765]=0;person.bank[765]=11;shared={};app.captureInventory()
    vialPlanSetup();app.options.language='de';output('preview_inventory_de',app.shoppingWindow)
    app.options.language='en';output('preview_inventory_en',app.shoppingWindow)
    app.showMerchants();output('preview_merchants',app.merchantWindow)

end

-- Core/legacy presenter contracts above run separately from the single-window
-- presenter. These integration cases use the production presenter.
if os.getenv('EDJ_PREVIEW')then
    UnitGUID,UnitFullName,UnitName,GetRealmName,C_Item.GetItemCount,C_Item.GetItemInfo,time=oldGUID,oldFullName,oldUnitName,oldRealm,oldCount,oldItemInfo,oldTime
    app.initialize();app.initializeInventory()
end
function methods:SetParent(parent)self.parent=parent end
assert(loadfile('UnifiedUI.lua'))('CraftDeja',app)
local function onlyGuide()
    local shown={}
    for _,f in ipairs(app.themedWindows)do if f:IsShown()and f.parent==UIParent then shown[#shown+1]=f end end
    eq(#shown,1);eq(shown[1],app.nextStepWindow);eq(app.main:IsShown(),false)
    if not app.unifiedView then eq(app.nextStepWindow.action:IsShown(),true);eq(app.nextStepWindow.body:IsShown(),true)end
end
test('unified profession opening presents only the guide and accepts saved poison drafts directly',function()
    poisonSetup();onlyGuide();eq(app.unifiedView,nil)
    app.setPoisonTarget(990101,20);app.refreshNextStep(true)
    local g=app.nextStepWindow;eq(g.task.kind,'poison_apply');assert(g.action:GetText():find('20',1,true))
    g.action.scripts.OnClick();eq(app.character.poisons.job.remaining[990101],20)
    eq(app.unifiedView,nil);onlyGuide();eq(app.poisonWindow:IsShown(),false)
    poisonCleanup()
end)
test('poison quantities are edited inside the guide with one apply action and no shopping buttons',function()
    poisonSetup();app.editUnifiedOrder();onlyGuide()
    local g=app.nextStepWindow;local p=app.poisonWindow
    eq(p.parent,g);eq(app.unifiedView,p);eq(p:GetScale(),1)
    eq(p.shop:IsShown(),false);eq(p.craft:IsShown(),false);eq(p.vendor:IsShown(),false)
    eq(p.close:IsShown(),false);eq(p.scaleGrip:IsShown(),false)
    p.rows[1].box:SetText('12');p.rows[1].box.scripts.OnTextChanged(p.rows[1].box)
    p.apply.scripts.OnClick();eq(app.character.poisons.job.remaining[990101],12)
    eq(app.unifiedView,nil);onlyGuide()
    app.applyScale(.9,true);eq(g:GetScale(),.9);eq(p:GetScale(),1)
    poisonCleanup()
end)
test('vendor visit shows only a guide quote, and buying begins only after that quote is clicked',function()
    poisonSetup();poisonOrder();local f=poisonVendorFixture()
    app.events.scripts.OnEvent(app.events,'MERCHANT_SHOW');onlyGuide();eq(app.unifiedView,nil)
    local g=app.nextStepWindow;eq(g.task.kind,'vendor');eq(f.bought,0);assert(g.vendorQuote)
    assert(g.action:GetText():find(app.money(g.vendorQuote.cost),1,true))
    g.action.scripts.OnClick();eq(f.bought,1);eq(app.unifiedView,nil);onlyGuide()
    eq(app.vendorBuyWindow:IsShown(),false);f.cleanup();poisonCleanup()
end)
test('options tabs and diagnostic pages share the guide frame and return without losing an order',function()
    poisonSetup();poisonOrder();local j=app.character.poisons.job
    app.showOptions('help');onlyGuide();eq(app.unifiedViewKey,'menu')
    local menu=app.unifiedOptions;eq(menu.parent,app.nextStepWindow)
    menu.rows[3].scripts.OnClick(menu.rows[3]);eq(app.unifiedViewKey,'log');onlyGuide()
    eq(app.flowLogWindow.parent,app.nextStepWindow)
    app.nextStepWindow.back.scripts.OnClick();eq(app.unifiedView,nil);onlyGuide();eq(app.character.poisons.job,j)
    app.showOptions('settings');app.unifiedOptions.rows[1].scripts.OnClick(app.unifiedOptions.rows[1])
    eq(app.unifiedViewKey,'settings');onlyGuide()
    app.keepNextStepOnly();eq(app.unifiedView,nil);onlyGuide();eq(app.character.poisons.job,j)
    poisonCleanup()
end)
test('fresh poison vendor guidance opens no extra prompt and native profession opening stays user-driven',function()
    poisonSetup();local f=poisonVendorFixture();ProfessionsFrame:Hide()
    app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE');app.active=nil;app.sessions={}
    local old=C_TradeSkillUI.OpenTradeSkill;local calls=0
    C_TradeSkillUI.OpenTradeSkill=function(id)eq(id,40);calls=calls+1;ProfessionsFrame:Show();return true end
    app.events.scripts.OnEvent(app.events,'MERCHANT_SHOW');onlyGuide();eq(app.nextStepWindow.task.kind,'poison_open');eq(calls,0)
    app.nextStepWindow.action.scripts.OnClick();eq(calls,1);onlyGuide();eq(app.unifiedView,nil)
    C_TradeSkillUI.OpenTradeSkill=old;f.cleanup();poisonCleanup()
end)
print('UNIFIED SUCCESS: '..passed..' assertions')
test('unified vendor quote rejects a price change and supports ordinary reagent purchases in the guide',function()
    poisonSetup();poisonOrder();local f=poisonVendorFixture();app.events.scripts.OnEvent(app.events,'MERCHANT_SHOW')
    C_MerchantFrame.GetItemInfo=function()return {name='Poison supply',price=21,stackCount=1,numAvailable=-1}end
    app.nextStepWindow.action.scripts.OnClick();eq(f.bought,0);eq(app.poisonVendorQueue,nil);onlyGuide()
    app.nextStepWindow.action.scripts.OnClick();eq(f.bought,1);onlyGuide();f.cleanup();poisonCleanup()
    setupVendorPopup();app.refreshNextStep(true);onlyGuide();eq(app.nextStepWindow.task.kind,'vendor')
    local before=#merchantCalls;app.nextStepWindow.action.scripts.OnClick();eq(#merchantCalls,before+1)
    eq(app.vendorBuyWindow:IsShown(),false);app.vendorPurchase.pending=nil;app.vendorBuyEvent('MERCHANT_CLOSED')
end)
test('unified AH scan and search stay in the guide and retain fresh-price safeguards',function()
    beginShopping();fullscan();stock[10938]=0;stock[10940]=0;app.refresh(false);app.refreshNextStep(true)
    onlyGuide();eq(app.unifiedView,nil);eq(app.shoppingWindow:IsShown(),false);eq(app.nextStepWindow.task.kind,'ah')
    app.nextStepWindow.action.scripts.OnClick();assert(submitted);onlyGuide();eq(app.shopping.searched,true)
    app.shopping.ready=nil;app.refreshNextStep(true);eq(app.nextStepWindow.task.kind,'scan');eq(app.nextStepWindow.action.enabled,false)
    app.shoppingEvent('AUCTION_HOUSE_CLOSED')
end)
test('normal skill goals and reference pages are edited in the guide without extra root windows',function()
    stockCraftSetup();app.editUnifiedOrder();onlyGuide();eq(app.unifiedViewKey,'skill')
    local f=app.skillOrderView;f.slider:SetValue(3);eq(f.draftPoints,3)
    f.apply.scripts.OnClick();eq(app.shopping.points,3);eq(app.shopping.goal,'manual');eq(app.unifiedView,nil);onlyGuide()
    app.showCatalogue();onlyGuide();eq(app.unifiedViewKey,'catalog')
    app.showDetails(app.decision.current.recipe,true);onlyGuide();eq(app.unifiedViewKey,'details')
    app.nextStepWindow.close.scripts.OnClick();eq(app.nextStepWindow:IsShown(),false);eq(app.unifiedView,nil)
    app.command('');onlyGuide();stockCraftCleanup()
end)
test('native crafting still requires a physical native click in unified UI',function()
    stockCraftSetup();local calls=0;local old=C_TradeSkillUI.CraftRecipe
    C_TradeSkillUI.CraftRecipe=function()calls=calls+1 end
    app.showCentralGuide();onlyGuide();eq(app.nextStepWindow.task.kind,'craft')
    app.nextStepWindow.craftAll.scripts.OnClick();eq(calls,0);assert(app.nativeCraftHandoff);onlyGuide()
    ProfessionsFrame.CraftingPage.CreateButton.scripts.OnClick();eq(calls,1)
    C_TradeSkillUI.CraftRecipe=old;stockCraftCleanup()
end)
print('FINAL SUCCESS: '..passed..' assertions')

if os.getenv('EDJ_PREVIEW')then
    local function unifiedOutput(name)
        local root=app.nextStepWindow;local indexes={};for i,f in ipairs(allFrames)do indexes[f]=i end
        local out=assert(io.open('../../unified/'..name..'.tsv','w'))
        for _,f in ipairs(allFrames)do
            local p=f;local visible=true
            while p and p~=root do if not p.shown then visible=false end;p=p.parent end
            if p==root and f.shown and visible then
                local pos=f.point or {};local col=f.textColour or {1,.9,.68}
                local x,y=type(pos[2])=='number'and pos[2]or 0,type(pos[3])=='number'and pos[3]or 0
                out:write(table.concat({indexes[f],indexes[f.parent]or 0,f.kind,f.width,f.height,pos[1]or 'TOPLEFT',x,y,f.fontSize or 11,(f.value or ''):gsub('\n','<NL>'),f.texture or f.normalTexture or '',col[1],col[2],col[3],f.full and '1'or '0',f.layer or '',f.alpha or 1},'\t'),'\n')
            end
        end;out:close()
    end
    poisonSetup();app.options.language='de';app.setPoisonTarget(990101,20);app.showCentralGuide();unifiedOutput('GuideDraft')
    app.editUnifiedOrder();unifiedOutput('GuideEditor');app.showCentralGuide()
    app.nextStepWindow.action.scripts.OnClick();local f=poisonVendorFixture();app.events.scripts.OnEvent(app.events,'MERCHANT_SHOW');unifiedOutput('GuideVendor')
    app.showOptions('settings');unifiedOutput('GuideMenu');f.cleanup();poisonCleanup()
end

test('new poison profiles default to refill and existing explicit extra plans stay extra',function()
    poisonSetup();app.options.language='en';app.character.poisons=nil;app.refresh(false)
    eq(app.character.poisons.restock,true)
    stock[990111]=20;eq(app.setPoisonTarget(990101,20),true)
    app.refreshNextStep(true)
    eq(app.poisonDraft(),1);eq(select(2,app.poisonDraft()),0)
    local text=app.poisonModeSummary();assert(text:find('20',1,true));assert(text:find('Missing 0',1,true))
    eq(app.nextStepWindow.action.enabled,false)
    eq(app.startPoisonOrder(),true);eq(app.character.poisons.job,nil)
    app.setPoisonTarget(990101,25);eq(app.startPoisonOrder(),true)
    eq(app.character.poisons.job.remaining[990101],5)
    local rows={};for _,row in ipairs(app.poisonPlan().rows)do rows[row.id]=row end
    eq(rows[2928].total,5);eq(rows[3371].total,5)
    stock[990111]=25;app.poisonStockSettleUntil=nil;app.refresh(false)
    eq(app.character.poisons.job,nil)
    app.cancelPoisonOrder();eq(app.setPoisonRestock(false),true)
    app.setPoisonTarget(990101,20);eq(app.startPoisonOrder(),true)
    eq(app.character.poisons.job.remaining[990101],20)
    local extra=app.poisonModeSummary();assert(extra:find('Additional 20',1,true))
    poisonCleanup()
end)
test('refill matches exact output IDs and never treats unknown counts as a deficit',function()
    restockSetup();stock[990111]=20;stock[990112]=0
    app.setPoisonTarget(990101,20);app.setPoisonTarget(990102,20)
    eq(select(2,app.poisonDraft()),20)
    eq(app.startPoisonOrder(),true)
    eq(app.character.poisons.job.remaining[990101],nil)
    eq(app.character.poisons.job.remaining[990102],20)
    app.cancelPoisonOrder();stock[990112]=nil;app.refreshNextStep(true)
    eq(select(5,app.poisonDraft()),false);eq(app.nextStepWindow.action.enabled,false)
    eq(app.startPoisonOrder(),false);eq(app.character.poisons.job,nil)
    poisonCleanup()
end)
print('STOCK FIX SUCCESS: '..passed..' assertions')

test('completed poison guide reopens after dismissal on every new merchant visit',function()
    poisonSetup();app.poisonDone=true;app.refreshNextStep(true)
    local guide=app.nextStepWindow;guide.close.scripts.OnClick(guide.close)
    eq(guide:IsShown(),false)
    ProfessionsFrame:Hide();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE')
    guide.close.scripts.OnClick(guide.close);eq(guide:IsShown(),false)
    local f=poisonVendorFixture()
    for visit=1,3 do
        app.events.scripts.OnEvent(app.events,'MERCHANT_SHOW');onlyGuide()
        app.refreshNextStep();eq(guide:IsShown(),true);eq(app.poisonDone,true)
        guide.close.scripts.OnClick(guide.close);eq(guide:IsShown(),false)
        app.events.scripts.OnEvent(app.events,'MERCHANT_UPDATE');eq(guide:IsShown(),false)
        app.events.scripts.OnEvent(app.events,'MERCHANT_CLOSED')
    end
    eq(f.bought,0);f.cleanup();poisonCleanup()
end)
test('normal profession options and reference pages retain a visible shared header',function()
    fixtures(100);app.options.language='en';app.onProfessionOpened()
    local function page(check)
        app.refreshProfessionThemes();app.refreshUI();onlyGuide()
        local g=app.nextStepWindow;eq(g.headerChrome.logo:IsShown(),true)
        assert(#g.headerChrome.title:GetText()>0)
        local v=app.unifiedView;assert(v)
        if v.themeHeader then eq(v.themeHeader:IsShown(),false)end
        if check then check(v)end
        g.back.scripts.OnClick(g.back);onlyGuide();eq(app.unifiedView,nil)
    end
    app.editUnifiedOrder();page(function(v)eq(v,app.skillOrderView)end)
    app.showUnifiedGeneral();page(function(v)
        local green=app.options.green;v.green.scripts.OnClick(v.green);eq(app.options.green,not green)
        v.green.scripts.OnClick(v.green)
    end)
    for _,tab in ipairs({'settings','lookup','help'})do
        app.showOptions(tab);page(function(v)eq(v.tab,tab)end)
    end
    for _,show in ipairs({app.showCatalogue,app.showMerchants,app.showRecipeAudit,app.showFlowLog,app.showPurchaseDiagnostic})do show();page()end
    app.showDetails(app.active.recipes[7748],true);page()
    app.showGuide(true);page()
    profile={professionID=171,professionName='Alchemy',skillLevel=20,maxSkillLevel=75}
    live={[2330]=info('Minor Healing Potion',1,true,{[2447]=1,[765]=1,[3371]=1})}
    stock={[2447]=5,[765]=5,[3371]=5};prices={[2447]=10,[765]=10}
    app.onProfessionOpened();eq(app.active.profile.id,171);onlyGuide()
    app.editUnifiedOrder();page();app.showOptions('lookup');page()
    fixtures(100);app.onProfessionOpened()
end)
test('profession header changes reject stale foreign recipe lists before auditing or planning',function()
    poisonSetup();local poison=app.active
    app.character.recipeAudit={entries={},order={},checks={}}
    profile={professionID=333,professionName='Enchanting',skillLevel=116,maxSkillLevel=150}
    app.onProfessionOpened()
    eq(app.professionLoading,true);eq(app.active,poison);eq(app.nextStepWindow.task.kind,'loading')
    eq(app.nextStepWindow.action.enabled,false);eq(app.nextStepWindow.changeOrder,nil)
    eq(app.auditCount(),0)
    live={[7748]=info('Enchant Chest - Lesser Health',1,true,{[10940]=2,[10938]=2}),[990101]=live[990101],
        [990999]=info('New valid enchant',0,true,{[10940]=1})}
    app.refresh(true)
    eq(app.professionLoading,false);eq(app.active.profile.id,333);eq(app.active.confirmed,2)
    eq(app.active.recipes[990101],nil);eq(app.sessions[40],poison)
    assert(app.active.recipes[990999].confirmed)
    for _,e in pairs(app.character.recipeAudit.entries)do assert(e.recipe~=990101)end
    poisonCleanup()
end)
test('repeated large audits do not evict useful diagnostic actions with duplicate reports',function()
    fixtures(100);app.character.recipeAudit={entries={},order={},checks={}}
    app.character.flowLog={sequence=0,entries={}};app.auditLogSeen={};live={}
    for id=980001,980220 do live[id]=info('New observed recipe',0,true,{[10940]=1})end
    app.readRecipes(app.readProfession());app.flowLog('click.audit_test',{})
    local seq=app.character.flowLog.sequence
    app.readRecipes(app.readProfession());eq(app.character.flowLog.sequence,seq)
    eq(app.character.flowLog.entries[#app.character.flowLog.entries].event,'click.audit_test')
    fixtures(100);app.refresh(true)
end)
print('TRANSITIONS SUCCESS: '..passed..' assertions')

test('a mixed stale first-login list is not accepted as a new poison session',function()
    fixtures(100);app.sessions={};app.active=nil
    profile={professionID=40,professionName='Poisons',skillLevel=1,maxSkillLevel=75}
    live={[7748]=info('Old enchant',1,true,{[10940]=1}),[979999]=info('Unknown old recipe',1,true,{[10940]=1})}
    app.character.recipeAudit={entries={},order={},checks={}}
    local result=app.readRecipes(app.readProfession())
    eq(result.confirmed,0);eq(app.auditCount(),0);eq(result.recipes[979999],nil)
    fixtures(100);app.onProfessionOpened()
end)
print('FINAL UI REVIEW SUCCESS: '..passed..' assertions')

assert(loadfile("SystemCheck.lua"))("CraftDeja",app)

test('in-game system check is read-only and records actual steps rather than untested passes',function()
 fixtures(100);ProfessionsFrame=nativeCraftFrame(7748);app.onProfessionOpened();local goal=app.shopping.goal;local targets=app.character.poisons
 app.showSystemCheck();onlyGuide();eq(app.unifiedViewKey,'systemcheck')
 app.startSystemCheck();eq(app.character.systemCheck.rows[1].status,'wait')
 app.systemCheckTick();eq(app.character.systemCheck.rows[1].status,'wait')
 app.events.scripts.OnEvent(app.events,'TRADE_SKILL_SHOW');app.systemCheckTick()
 eq(app.character.systemCheck.rows[1].status,'pass');eq(app.character.systemCheck.rows[2].status,'untested')
 app.systemCheckSelect(2);ProfessionsFrame:Hide();app.events.scripts.OnEvent(app.events,'TRADE_SKILL_CLOSE');app.systemCheckTick()
 eq(app.character.systemCheck.rows[2].status,'pass')
 app.systemCheckSelect(10)
 app.flowLog('ah.quantity.check',{requested=59,selected=2,displayed=2,ok=false});app.systemCheckTick()
 eq(app.character.systemCheck.rows[10].status,'fail')
 app.systemCheckSelect(10);app.flowLog('ah.quantity.check',{requested=59,selected=59,displayed=59,ok=true});app.systemCheckTick()
 eq(app.character.systemCheck.rows[10].status,'pass')
 app.systemCheckSelect(13)
 app.flowLog('craft.native_quantity',{recipe=7748,requested=4,accepted=4});app.systemCheckTick()
 eq(app.character.systemCheck.rows[13].status,'wait')
 app.flowLog('craft.native_user_start',{recipe=7748,count=4});app.flowLog('craft.completed',{recipe=7748,remaining=3});app.systemCheckTick()
 eq(app.character.systemCheck.rows[13].status,'pass')
 app.systemCheckSelect(9);app.showSystemCheck();app.systemCheckWindow.skip.scripts.OnClick()
 eq(app.character.systemCheck.rows[9].status,'skip')
 app.systemCheckWindow.copy.scripts.OnClick();local report=app.systemCheckWindow.results:GetText()
 assert(report:find('quantity [pass]',1,true));assert(report:find('scan [skip]',1,true));assert(report:find('Untested/skipped steps are NOT passes.',1,true))
 app.systemCheckTick();eq(app.systemCheckWindow.results:GetText(),report)
 app.systemCheckWindow.stop.scripts.OnClick();eq(app.shopping.goal,goal);eq(app.character.poisons,targets)
 ProfessionsFrame:Show();fixtures(100);app.onProfessionOpened()
end)
test('system check stock uses real bag deficit and unknown data stays untested',function()
 restockSetup();app.setPoisonTarget(990101,20);stock[990111]=7
 app.startSystemCheck();app.systemCheckSelect(6);app.systemCheckTick()
 eq(app.character.systemCheck.rows[6].status,'pass')
 assert(app.systemCheckReport():find('missing=13',1,true))
 app.systemCheckSelect(6);stock[990111]=nil;app.systemCheckTick();eq(app.character.systemCheck.rows[6].status,'wait')
 app.showSystemCheck();app.systemCheckWindow.stop.scripts.OnClick();poisonCleanup()
end)
print('SYSTEM CHECK SUCCESS: '..passed..' assertions')
