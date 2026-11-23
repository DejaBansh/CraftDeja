-- SPDX-License-Identifier: MIT
local _,app=...
local words={
    recipe_in_bag={'Lerne %s per Rechtsklick in deinen Taschen.','Right-click %s in your bags to learn it.'},
    recipe_in_storage={'Hole %s aus dem Lager und lerne es.','Collect %s from storage and learn it.'},
    recipe_in_mail={'Hole %s aus der Post und lerne es.','Collect %s from your mail and learn it.'},
    recipe_owned_check={'Lernfortschritt prüfen','Check learning progress'},
    reserve_more={'Reserve für %d Versuche · ca. +%s','Stock for %d attempts · about +%s'},
    reserve_less={'Nur Bedarf für ca. %d Versuche','Stock for about %d attempts'},
    estimate_batch={'%d Versuche vorbereiten · am Ziel selbst stoppen','Prepare %d attempts · stop manually at the goal'},
    stop_recipes={'Rezepte bis Skill 300 prüfen','Review recipes through skill 300'},
    stop_optional={'Optional','Optional'},stop_current={'Aktueller Schritt','Current step'},
    stop_common={'Mehrere Routen','Multiple routes'},stop_none={'Kein offenes Händlerrezept auf den verglichenen Routen.','No outstanding vendor recipes on the compared routes.'},
    stop_partial={'Keine durchgehende Route bis 300 belegt. Aktueller Schritt wird geprüft.','No complete route to 300 found. Checking the current step.'},
    stop_vendor={'Hier kaufen · %s','Buy here · %s'},stop_limit={'AH prüfen · bis %s','Check AH · up to %s'},
    stop_vendor_trip={'Mit den Zutaten beim selben Händler kaufen','Buy with reagents at the same vendor'},
    stop_ah={'Im AH kaufen · %s','Buy at AH · %s'},stop_price={'Händlerpreis vor Ort prüfen','Check the price at the vendor'},
    stop_wait={'Angebot, Taschen und Post prüfen','Check offer, bags and mail'},
    stop_empty={'Kein passender Sofortkauf innerhalb des Limits. Händler einplanen.','No eligible buyout within the limit. Plan a vendor visit.'},
    stop_forecast_prefix={'Durchgängige Vorschau bis Skill %d. Spätere Abschnitte sind offen.','Continuous forecast through skill %d. Later stages are unresolved.'},
    stop_search={'Angebote werden geladen','Loading offers'},
    stop_ready={'Rezepte einzeln auswählen. Optionale Rezepte können später entfallen.','Select recipes individually. Optional recipes may drop out of later routes.'},
    stop_total={'Für diesen Stopp empfohlen: %d Rezepte · %s','Recommended at this stop: %d recipes · %s'},
    stop_pending={'Kauf ausstehend · Post und Taschen prüfen','Purchase pending · check mailbox and bags'},
    stop_old={'Angebot oder Auftrag geändert. Erneut prüfen.','Offer or order changed. Check again.'},
    stop_manual={'AH-Kauf prüfen und freigeben','Review and unlock AH purchase'},
    stop_unlock={'Post und Taschen geprüft · erneut freigeben','Mail and bags checked · unlock again'}
}
for key,v in pairs(words)do app.words.de[key]=v[1];app.words.en[key]=v[2] end

-- Count distinct recipe sequences. Reuse modes and subdivisions of the same
-- route are not independent votes for pre-buying a future recipe.
function app.forecastRecipeNeeds(result,current)
    local needs,sequences={},{}
    local function note(id,skill)
        local row=needs[id] or {recipe=id,skill=skill,votes=0}
        row.skill=math.min(row.skill,skill);needs[id]=row
        return row
    end
    if current and current.needsLearning then note(current.recipe.id,current.recipe.skill or 0).current=true end
    for _,route in ipairs(result.candidates or {})do
        local ids,seen={},{}
        for _,segment in ipairs(route.segments)do
            if ids[#ids]~=segment.recipe then ids[#ids+1]=segment.recipe end
            seen[segment.recipe]=math.min(seen[segment.recipe] or segment.from,segment.from)
        end
        local signature=table.concat(ids,',')
        local best=result.best
        local competitive=best and not route.unknownValue and route.provisional==best.provisional and
            route.net<=best.net+math.abs(best.net)*.15
        for id,skill in pairs(seen)do
            local row=note(id,skill)
            if competitive and not sequences[signature] then row.votes=row.votes+1 end
            if route==best then row.best=true end
        end
        if competitive then sequences[signature]=true end
    end
    return needs
end

function app.paintProcurementControls(f,y)
    local plan=f.plan
    local k=f.task.kind
    local idle=not app.nativeCraftHandoff and not app.craftBatch and not app.craftRefreshBusy()
    local controls={
        {'estimateButton',idle and k=='craft' and f.craftAll:IsShown() and plan and not plan.production and
            math.min(f.task.available or 0,plan.expectedCrafts or 0,plan.crafts)>(f.task.batch or 0),
            function()app.craftNext(f.plan,'estimate')end},
        {'reserveButton',idle and plan and plan.reserveEligible and (k=='ah' or k=='vendor' or k=='ah_load' or k=='craft') and not app.purchasePending(),
            function()
                local p=f.plan
                if not p or not p.reserveEligible or app.craftRefreshBusy() or app.vendorPurchase.pending or not app.newPurchasePlan() then return end
                app.character.greenReserve=p.crafts==p.expectedCrafts and {recipe=p.recipe.id,target=p.target} or nil
                app.routeCache=nil;app.refresh(false);app.refreshNextStep(true)
            end},
        {'procurementButton',idle and app.active and app.active.profile.skill<300 and not app.isPoison() and (app.vendorPurchase.open or app.shopping.open),
            function()app.showProcurement()end}
    }
    for _,entry in ipairs(controls)do
        local name,show,callback=unpack(entry)
        local button=f[name]
        if show then
            if not button then button=app.createButton(f,20,0,380,'',callback);f[name]=button end
            local label
            if name=='estimateButton' then label=app.caption('estimate_batch',math.min(f.task.available,plan.expectedCrafts,plan.crafts))
            elseif name=='reserveButton' then
                label=plan.crafts>plan.expectedCrafts and app.caption('reserve_less',plan.expectedCrafts) or app.caption('reserve_more',2*plan.expectedCrafts,app.money(plan.reserveExtra))
                button.tipLines=function()
                    local lines={}
                    for _,row in ipairs(f.plan.rows)do
                        local base=row.total*f.plan.expectedCrafts/f.plan.crafts
                        lines[#lines+1]=row.name..' · '..base..' / '..2*base
                    end
                    return lines
                end
            else label=app.caption('stop_recipes') end
            button:ClearAllPoints();button:SetPoint('TOPLEFT',20,-y);button:SetText(label);button:Show();y=y+32
        elseif button then button:Hide() end
    end
    return y
end

local function npcID()
    local guid=app.try(UnitGUID,'npc')
    return type(guid)=='string' and tonumber(guid:match('^Creature%-%d+%-%d+%-%d+%-%d+%-(%d+)%-'))
end
local function ready()return app.active and not app.active.invalidated and not app.isPoison() and app.active.profile.skill<300 end
local function busy()return app.craftRefreshBusy() or app.nativeCraftHandoff or app.purchasePending() or app.vendorPurchase.pending end
local function itemStock(item)
    local stock=app.inventoryFor(item)
    return stock and stock.total,app.confirmedMail(item)
end
local function openOffers()
    local offers={}
    if app.vendorPurchase.open then
        for i=1,app.try(GetMerchantNumItems) or 0 do
            local offer=app.readMerchantOffer(i)
            if offer and offer.purchasable~=false and offer.bundle==1 and (offer.available==-1 or (offer.available or 0)>0) then offers[offer.id]=offer end
        end
    end
    return offers
end
function app.recipeBuyLimit(vendor,sameStop)
    if type(vendor)~='number' or vendor<=0 then return end
    -- If a reagent already requires this trip, only an actual saving beats it.
    return sameStop and math.ceil(vendor)-1 or math.floor(vendor*115/100)
end
local function plannedVendors()
    local plans={}
    local d=app.decision
    if d and not d.current.needsLearning then
        local plan=app.materialPlan(d.current.recipe,app.planningTarget())
        if plan then
            plan=app.completeShoppingPlan(plan)
            for _,r in ipairs(plan.rows)do
                if r.vendor and r.buy>app.confirmedMail(r.id) then
                    local v=app.nearestMerchant(r.id)
                    if v and v.npc and v.npc>0 then plans[v.npc]=true end
                end
            end
        end
    end
    return plans
end
local function rowsFor(needs)
    local rows,offers,stops={},openOffers(),plannedVendors()
    local faction=app.playerFaction()
    for id,need in pairs(needs)do
        local recipe=app.active.recipes[id]
        if recipe and not recipe.learned and app.canRecommend(recipe) then
            local item=app.accessInfo(recipe).item or recipe.scroll
            local offer=item and offers[item]
            local scheduledPrice
            local vendor,sameStop,source=offer and offer.price,offer~=nil,offer~=nil
            if item then
                for _,v in ipairs(app.sourceList(recipe))do
                    if v.kind=='vendor' and (v.side=='Both' or v.side==faction) then
                        source=true
                        local price=app.character.recipeShopPrices and app.character.recipeShopPrices[v.id]
                        price=price and price[item]
                        local age=price and price.at and time()-price.at
                        if age and age>=0 and age<=604800 and stops[v.id] then scheduledPrice=math.min(scheduledPrice or price.unit,price.unit) end
                        if age and age>=0 and age<=604800 and (not vendor or price.unit<vendor or price.unit==vendor and stops[v.id]) then
                            vendor=price.unit;sameStop=stops[v.id] or offer and offer.price==vendor
                        end
                    end
                end
            end
            if scheduledPrice and not offer then vendor=scheduledPrice;sameStop=true end
            if source and (not app.vendorPurchase.open or offer) then
                local stock,mail=itemStock(item)
                if (stock==nil or stock==0) and mail==0 then
                    rows[#rows+1]={id=item,recipe=id,skill=need.skill,unknownStock=stock==nil,offer=offer,npc=offer and npcID(),common=need.best and need.votes>=2,current=need.current,
                        vendor=vendor,sameStop=sameStop,limit=app.routeTransferable(item) and app.recipeBuyLimit(vendor,sameStop)}
                end
            end
        end
    end
    table.sort(rows,function(a,b)
        if (a.current==true)~=(b.current==true) then return a.current==true end
        if (a.common==true)~=(b.common==true) then return a.common==true end
        return a.skill<b.skill or a.skill==b.skill and a.id<b.id
    end)
    return rows
end

-- Use a real, current single-item buyout. Historical auction prices and
-- bids are never purchase authority.
local function buyout(item,limit)
    local api=C_AuctionHouse
    if not api or not limit then return end
    local key=app.try(api.MakeItemKey,item)
    if not key then return end
    local best
    for i=1,app.try(api.GetNumItemSearchResults,key) or 0 do
        local r=app.try(api.GetItemSearchResultInfo,key,i)
        if r and r.itemKey and r.itemKey.itemID==item and r.auctionID and r.quantity==1 and not r.containsOwnerItem and not r.containsAccountItem
            and r.buyoutAmount and r.buyoutAmount>0 and r.buyoutAmount<=limit and (not best or r.buyoutAmount<best.buyoutAmount) then best=r end
    end
    return best
end
local panel
local function currentPanel()
    return panel and panel:IsShown() and ready() and panel.owner==app.characterKey and panel.profession==app.active.profile.id and panel.skill==app.active.profile.skill
end
local function commodityPlan(r)
    return {recipePurchase=r.id,scanSerial=app.shopping.scanSerial,
        rows={{id=r.id,name=app.itemName(r.id),buy=1,maxUnit=r.limit}}}
end
function app.currentRecipeAHPlan(item)
    if not currentPanel() or not panel.needs or not app.shoppingFresh() then return end
    for _,r in ipairs(rowsFor(panel.needs))do
        if r.id==item and r.limit and not r.offer and not (app.character.recipeAHRequests or {})[item] then return commodityPlan(r) end
    end
end
local function render()
    if not panel or not panel:IsShown() then return end
    if not currentPanel() then panel:Hide();return end
    local f=panel
    f.shownRow=nil;f.buy:Disable()
    if not f.needs then f.body:SetText(app.caption('route_calculating'));return end
    local rows=rowsFor(f.needs)
    f.index=math.max(1,math.min(#rows,f.index or 1))
    f.prev:SetEnabled(f.index>1);f.next:SetEnabled(f.index<#rows)
    local r=rows[f.index]
    local message=f.search and app.caption('route_calculating') or f.prefix and app.caption('stop_forecast_prefix',f.prefix) or f.partial and app.caption('stop_partial') or app.caption('stop_ready')
    if not r and f.search then f.body:SetText(message);f.buy:SetText('—');return end
    if not r then f.body:SetText(message..'\n\n'..app.caption('stop_none'));f.buy:SetText('—');return end
    local pending=(app.character.recipeAHRequests or {})[r.id]
    local label=app.caption('stop_price')
    if r.offer then label=app.caption('stop_vendor',app.money(r.offer.price));r.mode='vendor'
    elseif app.shopping.open and r.limit then
        label=app.caption('stop_limit',app.money(r.limit));r.mode='search'
        local api=C_AuctionHouse
        local key=api and app.try(api.MakeItemKey,r.id)
        local info=key and app.try(api.GetItemKeyInfo,key)
        if info and info.isCommodity then
            if app.shoppingFresh() then
                r.plan=commodityPlan(r);r.commodity=app.ahBuyStatus(r.plan)
                r.mode=not r.commodity.disabled and 'commodity' or nil
                label=r.commodity.button;message=r.commodity.body..' · '..app.caption('stop_limit',app.money(r.limit))
            else r.mode=nil;message=app.scanWaitText() end
        elseif f.queried==r.id then
            local live=f.loaded and buyout(r.id,r.limit)
            if live then r.auction=live.auctionID;r.cost=live.buyoutAmount;r.mode='buy';label=app.caption('stop_ah',app.money(r.cost))
            else message=app.caption(f.loaded and 'stop_empty' or 'stop_search') end
        end
    end
    if r.unknownStock then r.mode=nil;label=app.caption('step_unknown') end
    if pending then
        r.mode=f.unlock and 'unlock' or 'review';label=app.caption(f.unlock and 'stop_unlock' or 'stop_manual');message=app.caption('stop_pending')

    end
    if r.offer then
        local count,sum=0,0
        for _,row in ipairs(rows)do
            if row.offer and not row.unknownStock and (row.current or row.common) then count=count+1;sum=sum+row.offer.price end
        end
        if count>0 then message=message..'\n'..app.caption('stop_total',count,app.money(sum)) end
    end
    if r.sameStop and not r.offer then message=message..'\n'..app.caption('stop_vendor_trip') end
    f.body:SetText(('%d / %d   ·   Skill %d\n%s\n%s\n\n%s'):format(f.index,#rows,r.skill,app.itemName(r.id),
        app.caption(r.current and 'stop_current' or r.common and 'stop_common' or 'stop_optional'),message))
    f.buy:SetText(label);f.buy:SetEnabled(r.mode~=nil and not busy());f.shownRow=r
end
local function click()
    local shown=panel.shownRow
    if not currentPanel() or not shown or busy() then return end
    render()
    local r=panel.shownRow
    if not r or r.id~=shown.id or r.mode~=shown.mode or r.recipe~=shown.recipe then return end
    if r.mode=='review' then panel.unlock=true
    elseif r.mode=='unlock' then
        app.character.recipeAHRequests[r.id]=nil;panel.unlock=nil;panel.queried=nil
    elseif r.mode=='vendor' then
        local offer=r.offer
        if offer.price~=shown.offer.price or offer.slot~=shown.offer.slot or r.npc~=shown.npc or not app.canReceiveStock(r.id,1)
            or (app.try(GetMoney) or 0)<offer.price or type(BuyMerchantItem)~='function' then return end
        app.vendorPurchase.pending={id=r.id,before=0,quantity=1,when=GetTime()}
        if not pcall(BuyMerchantItem,offer.slot,1) then app.vendorPurchase.pending=nil end
    elseif r.mode=='commodity' then
        app.performAHBuy(shown.plan,shown.commodity)
    elseif r.mode=='search' then
        local api=C_AuctionHouse
        local key=api and app.try(api.MakeItemKey,r.id)
        panel.queried=r.id;panel.loaded=false
        if not key or not pcall(api.SendSearchQuery,key,{},false) then panel.queried=nil end
    elseif r.mode=='buy' then
        if r.auction~=shown.auction or r.cost~=shown.cost or (app.try(GetMoney) or 0)<r.cost then return end
        app.character.recipeAHRequests=app.character.recipeAHRequests or {}
        app.character.recipeAHRequests[r.id]={id=r.id,auction=r.auction,bags=0}
        if not pcall(C_AuctionHouse.PlaceBid,r.auction,r.cost) then app.character.recipeAHRequests[r.id]=nil end
    end
    render()
end
function app.showProcurement()
    if not ready() or busy() then return end
    if not panel then
        panel=app.createWindow('CraftDejaProcurement',450,285)
        panel.title:SetText(app.caption('stop_recipes'))
        panel.body=app.createLabel(panel,13,20,-56,410);panel.body:SetHeight(143)
        panel.buy=app.createButton(panel,20,-205,410,'',click)
        local function move(n)panel.index=panel.index+n;panel.unlock=nil;render()end
        panel.prev=app.createButton(panel,20,-245,198,'<',function()move(-1)end)
        panel.next=app.createButton(panel,232,-245,198,'>',function()move(1)end)
        panel:HookScript('OnHide',function(f)f.search=nil;f:SetScript('OnUpdate',nil)end)
    end
    panel:SetScript('OnUpdate',nil);panel.search=nil
    local p=app.active.profile
    panel.owner=app.characterKey;panel.profession=p.id;panel.skill=p.skill;panel.index=1
    panel.queried=nil;panel.unlock=nil;panel.prefix=nil;panel.needs=app.forecastRecipeNeeds({},app.decision and app.decision.current);panel:Show()
    local o=app.currentRouteOrder()
    if o and o.active and o.owner==app.characterKey and o.profession==p.id and o.target==300 and app.routeResult and app.routeResult.best and not app.routeResult.costsStale and not app.routeDirty and not app.routeSearch and app.routeResult.model.start==p.skill then
        panel.partial=false;panel.needs=app.forecastRecipeNeeds(app.routeResult,app.decision and app.decision.current);render();return
    end
    if not o or not o.active or o.owner~=app.characterKey or o.profession~=p.id then o={} end
    local model=app.buildRouteModel({owner=app.characterKey,profession=p.id,target=300,forceAH=o.forceAH or {},terms=o.terms or {},supplyProgress=o.supplyProgress})
    if not model then panel:Hide();return end
    model.collectPrefix=true
    panel.search=app.newRouteSearch(model)
    panel:SetScript('OnUpdate',function(f)
        if not currentPanel() then f:Hide();return end
        if busy() then return end
        local started=app.try(debugprofilestop)
        for i=1,32 do
            if app.advanceRouteSearch(f.search) then
                local result=f.search
                f.partial=not result.best
                if f.partial and result.prefix then
                    f.prefix=result.prefix.target
                    result={candidates={result.prefix}}
                end
                f.needs=app.forecastRecipeNeeds(result,app.decision and app.decision.current)
                f.search=nil;f:SetScript('OnUpdate',nil);render();return
            end
            if not started or debugprofilestop()-started>=1.5 then return end
        end
    end)
    render()
end

local events=CreateFrame('Frame')
for _,event in ipairs({'ITEM_SEARCH_RESULTS_UPDATED','AUCTION_HOUSE_PURCHASE_COMPLETED','AUCTION_HOUSE_CLOSED','MERCHANT_CLOSED','BAG_UPDATE_DELAYED','NEW_RECIPE_LEARNED','MERCHANT_UPDATE','COMMODITY_SEARCH_RESULTS_UPDATED','COMMODITY_PRICE_UPDATED','COMMODITY_PURCHASED','COMMODITY_QUANTITY_UPDATE'})do app.try(events.RegisterEvent,events,event)end
events:SetScript('OnEvent',function(_,event,arg)
    if not app.character then return end
    if event=='AUCTION_HOUSE_PURCHASE_COMPLETED' then
        for id,p in pairs(app.character.recipeAHRequests or {})do
            if p.auction==arg then app.addConfirmedMaterial(id,1,p);app.character.recipeAHRequests[id]=nil;break end
        end
    end
    if not panel or not panel:IsShown() then return end
    if event=='ITEM_SEARCH_RESULTS_UPDATED' then
        if not arg or arg.itemID~=panel.queried then return end
        panel.loaded=true
    elseif event=='AUCTION_HOUSE_CLOSED' or event=='MERCHANT_CLOSED' then panel:Hide();return end
    render()
end)

