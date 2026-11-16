-- SPDX-License-Identifier: MIT
local _,app=...
local function copy(t)local n={};for k,v in pairs(t or {})do n[k]=v end;return n end
local function finite(n)return type(n)=='number'and n==n and n>=0 and n<math.huge end
local function positive(n)return finite(n)and n>0 end
app.routeFinite=finite

-- A curve is a frozen market observation, never an instruction to buy.
function app.routeCurveCost(curve,quantity)
    if quantity<=0 then return 0,true end
    if type(curve)=='number'then curve={unit=curve}end
    if type(curve)~='table'then return nil,false,'missing_price'end
    if curve.offset and curve.offset>0 then
        local plain=copy(curve);plain.offset=nil
        local total,known,reason=app.routeCurveCost(plain,quantity+curve.offset)
        local before=app.routeCurveCost(plain,curve.offset)
        if total==nil or before==nil then return nil,false,reason end
        return total-before,known,reason
    end
    local levels={}
    for _,r in ipairs(curve.levels or {})do
        if positive(r.unit or r.unitPrice or r.price)and positive(r.quantity)then
            levels[#levels+1]={unit=r.unit or r.unitPrice or r.price,quantity=r.quantity}
        end
    end
    table.sort(levels,function(a,b)return a.unit<b.unit end)
    local remaining,total=quantity,0
    for _,r in ipairs(levels)do
        if curve.vendor and r.unit>=curve.vendor then break end
        local n=math.min(remaining,r.quantity);total=total+n*r.unit;remaining=remaining-n
        if remaining<=.000001 then return total,true end
    end
    if positive(curve.vendor)then return total+remaining*curve.vendor,true end
    if curve.levels~=nil then return nil,false,'insufficient_depth'end
    if positive(curve.unit)then return quantity*curve.unit,false,'depth_unknown'end
    return nil,false,'missing_price'
end

local function marginal(model,id,n,previous)
    local price=model.prices[id]
    local a,known,reason=app.routeCurveCost(price,previous+n)
    local b=previous>0 and app.routeCurveCost(price,previous)or 0
    if a==nil or b==nil then return nil,false,reason end
    return a-b,known,reason
end
local function stockValue(model,id,n)
    if n<=0 then return 0 end
    local cost=app.routeCurveCost(model.prices[id],n)
    return cost
end
local function fresh(model,price)
    return type(price)=='table'and price.at and model.now>=price.at and model.now-price.at<=(model.maxAge or 900)
end
local function mark(ledger,reason,id)
    ledger.provisional=true;ledger.reasons[reason..':'..tostring(id or '')]=true
end
local own
local function fee(ledger,model,r)
    if r.learned or ledger.learned[r.id]then return true end
    ledger.learned[r.id]=true
    local f=r.fee
    if not f or not finite(f.cost)then mark(ledger,'learning_fee_unknown',r.id);return false end
    if f.item then
        local missing=own(ledger,model,f.item,1)
        if missing>0 then
            local cost,known,reason=marginal(model,f.item,missing,ledger.bought[f.item]or 0)
            if not fresh(model,model.prices[f.item])and not(type(model.prices[f.item])=='table'and model.prices[f.item].vendor)then mark(ledger,'recipe_price_stale',f.item)end
            if cost==nil then mark(ledger,reason or 'recipe_price_unknown',f.item);ledger.unknownValue=true
            else ledger.cashLearning=ledger.cashLearning+cost;ledger.net=ledger.net+cost;ledger.bought[f.item]=(ledger.bought[f.item]or 0)+missing
                if not known then mark(ledger,'recipe_depth_unknown',f.item)end
            end
        end
    else ledger.cashLearning=ledger.cashLearning+f.cost;ledger.net=ledger.net+f.cost end
    ledger.learning[#ledger.learning+1]={id=r.id,skill=r.skill or 0,cost=f.cost,source=f.source or 'trainer',item=f.item}
    return true
end
own=function(ledger,model,id,n)
    if model.unknownStock and model.unknownStock[id]then mark(ledger,'stock_unknown',id)end
    local have=ledger.stock[id]or 0;local take=math.min(n,have)
    ledger.stock[id]=have-take
    if take>0 then
        local localTake=math.min(take,ledger.currentStock and (ledger.currentStock[id]or 0)or take)
        if ledger.currentStock then ledger.currentStock[id]=(ledger.currentStock[id]or 0)-localTake end
        local transfer=take-localTake
        for i,origin in ipairs((model.stockOrigins or {})[id]or {})do
            local key=id..':'..i;local available=ledger.altUsed[key]or 0
            local use=math.min(transfer,math.max(0,origin.quantity-available))
            if use>0 then
                ledger.altUsed[key]=available+use;transfer=transfer-use
                local alreadyAtMaker=ledger.consumingAt and ledger.consumingAt==origin.character
                if not alreadyAtMaker then ledger.transfers[#ledger.transfers+1]={item=id,quantity=use,source='alt_stock',provider=origin,recipient=ledger.consumingAt,stage=#ledger.segments+1}end
                if not alreadyAtMaker and not ledger.altPaid[key]then
                    ledger.altPaid[key]=true
                    if finite(origin.transferCost)then ledger.cashTransfer=ledger.cashTransfer+origin.transferCost;ledger.net=ledger.net+origin.transferCost
                    else mark(ledger,'transfer_cost_unknown',id)end
                end
                if not origin.at or model.now-origin.at>604800 or model.now<origin.at then mark(ledger,'alt_stock_old',id)end
            end
        end
        local value=stockValue(model,id,take)
        if value then ledger.owned=ledger.owned+value;ledger.net=ledger.net+value
        else mark(ledger,'stock_value_unknown',id);ledger.unknownValue=true end
    end
    return n-take
end
local function buy(ledger,model,id,n)
    if n<=.000001 then return true end
    local previous=ledger.bought[id]or 0
    local cost,known,reason=marginal(model,id,n,previous)
    if cost==nil then mark(ledger,reason or 'missing_price',id);ledger.unknownValue=true;return false end
    if not known then mark(ledger,reason or 'depth_unknown',id)end
    if not fresh(model,model.prices[id])and not(type(model.prices[id])=='table'and model.prices[id].vendor)then mark(ledger,'price_stale',id)end
    ledger.bought[id]=previous+n;ledger.cashMaterials=ledger.cashMaterials+cost;ledger.net=ledger.net+cost
    return true
end

-- Shared whitelist, applied at EVERY recursion level. Guilds never produce
-- raw materials or intermediate bulk goods for this feature.
app.guildCraftItems={[6217]=true,[6338]=true,[11128]=true,[11144]=true,[16206]=true,[15846]=true}
-- Output identity is checked independently of an incoming guild assertion.
-- See docs/MULTI_STAGE_ROUTES.md for the Forever recipe references.
app.guildCraftRecipes={[7818]={item=6338,profession=164},[14379]={item=11128,profession=164},
    [14380]={item=11144,profession=164},[20201]={item=16206,profession=164},[19567]={item=15846,profession=202}}
function app.guildCraftAllowed(item)return app.guildCraftItems[item]==true end

local function providerCosts(model,p,item,n,visiting)
    if not p.confirmed or not p.transferable or not positive(p.output)then return nil,'unconfirmed_provider'end
    if not p.at or p.at>model.now or model.now-p.at>(p.kind=='alt'and 604800 or model.providerMaxAge or 900)then return nil,'provider_old'end
    if not p.at or model.now<p.at or model.now-p.at>(model.providerMaxAge or 900)then return nil,'provider_stale'end
    if p.kind=='guild'and not app.guildCraftAllowed(item)then return nil,'guild_bulk_blocked'end
    local crafts=math.ceil(n/p.output)
    local material,cash,owned=0,0,0
    if p.mode=='fixed'then
        if not finite(p.fixedPrice)then return nil,'terms_unknown'end
        material=p.fixedPrice*crafts;cash=material
    elseif p.mode=='materials'then
        if not finite(p.tip)then return nil,'terms_unknown'end
        for id,amount in pairs(p.inputs or {})do
            -- No guild subcontract recursion, including underneath a whitelisted tool.
            local qty=amount*crafts
            local stock=math.min(qty,(model.stock or {})[id]or 0)
            if stock>0 and model.unknownStock and model.unknownStock[id]then return nil,'stock_unknown'end
            local remote=stock-math.min(stock,model.currentStock and (model.currentStock[id]or 0)or stock)
            for _,origin in ipairs((model.stockOrigins or {})[id]or {})do
                local use=math.min(remote,origin.quantity)
                if use>0 then
                    remote=remote-use
                    if not origin.at or origin.at>model.now or model.now-origin.at>604800 then return nil,'alt_stock_old'end
                    if origin.character~=p.character then
                        if not finite(origin.transferCost)then return nil,'transfer_cost_unknown'end
                        material=material+origin.transferCost;cash=cash+origin.transferCost
                    end
                end
            end
            if remote>0 then return nil,'stock_unknown'end
            local missing=qty-stock;local cost,known=app.routeCurveCost(model.prices[id],missing)
            local value=stockValue(model,id,stock)
            local price=model.prices[id]
            if cost==nil or value==nil or not known or not fresh(model,price)and not(type(price)=='table'and price.vendor)then return nil,'material_price_unconfirmed'end
            material=material+cost+value;cash=cash+cost;owned=owned+value
        end
        material=material+p.tip;cash=cash+p.tip
    else return nil,'terms_unknown'end
    if not finite(p.transferCost)then return nil,'transfer_cost_unknown'end
    return {net=material+p.transferCost,cash=cash+p.transferCost,owned=owned,crafts=crafts}
end
function app.compareRouteSupply(model,item,n,excluded)
    local alternatives,options={},{}
    local ah,known,reason=app.routeCurveCost(model.prices[item],n)
    local price=model.prices[item]
    if ah then alternatives[#alternatives+1]={kind='ah',net=ah,cash=ah,confirmed=known and (fresh(model,price)or type(price)=='table'and price.vendor~=nil),reason=reason}end
    for _,p in ipairs((model.providers or {})[item]or {})do
        if not excluded then
            local cost,why=providerCosts(model,p,item,n,{})
            local row={kind=p.kind,provider=p,net=cost and cost.net,cash=cost and cost.cash,owned=cost and cost.owned,
                confirmed=cost~=nil and (p.kind~='guild'or p.accepted==true and p.online==true and p.guild==model.guild and
                    p.at and model.now>=p.at and model.now-p.at<=(model.providerMaxAge or 900)),reason=why}
            if row.confirmed then alternatives[#alternatives+1]=row else options[#options+1]=row end
        end
    end
    table.sort(alternatives,function(a,b)
        if math.abs(a.net-b.net)>.000001 then return a.net<b.net end
        -- Do not ask a guild member or change characters to save zero copper.
        local rank={ah=1,alt=2,guild=3};return (rank[a.kind]or 9)<(rank[b.kind]or 9)
    end)
    local best
    for _,r in ipairs(alternatives)do if r.confirmed then best=r;break end end
    if best and best.kind~='ah'then
        local baseline=false
        for _,other in ipairs(alternatives)do if other~=best and other.confirmed then baseline=true;break end end
        if not baseline then best=nil end -- no demonstrated saving against an available alternative
    end
    for _,r in ipairs(alternatives)do
        local competitor
        for _,other in ipairs(alternatives)do if other~=r and other.confirmed then competitor=other;break end end
        r.saving=competitor and competitor.net-r.net or nil
    end
    return {best=best,alternatives=alternatives,options=options,item=item,quantity=n,provisional=not best}
end

function app.evaluateRoute(model,segments,reuse)
    local l={stock=copy(model.stock),currentStock=model.currentStock and copy(model.currentStock),altUsed={},altPaid={},providerPaid={},produced={},bought={},learned={},learning={},transfers={},
        cashMaterials=0,cashLearning=0,cashTransfer=0,owned=0,net=0,vendor=0,reasons={},segments={},extraCrafts=0,visits=0,reused={},demand={}}
    local outputValues={};local lastVisit=-1
    for stage,s in ipairs(segments)do
        local r=model.recipes[s.recipe]
        if not r or not positive(s.crafts)then return nil,'invalid_segment'end
        if not r.learned and not l.learned[r.id]then
            fee(l,model,r)
            if lastVisit<s.from then l.visits=l.visits+1;lastVisit=s.from end
        end
        if not r.confirmed then mark(l,'recipe_reference',r.id)end
        if r.outputItem then
            for later=stage+1,#segments do
                local next=model.recipes[segments[later].recipe]
                if next and next.inputs[r.outputItem]then l.extraCrafts=l.extraCrafts+s.crafts;break end
            end
        end
        for id,amount in pairs(r.inputs or {})do
            local n=amount*s.crafts
            l.demand[id]=(l.demand[id]or 0)+n
            n=own(l,model,id,n)
            if reuse and n>0 then local used=math.min(n,l.produced[id]or 0);l.produced[id]=(l.produced[id]or 0)-used;n=n-used;l.reused[id]=(l.reused[id]or 0)+used end
            if n>0 then
                local selected={}
                if model.providers and model.providers[id]and #model.providers[id]>0 then
                    local supplyModel=copy(model);supplyModel.stock=l.stock;supplyModel.currentStock=l.currentStock;supplyModel.prices={}
                    for item,price in pairs(model.prices)do
                        local p=type(price)=='table'and copy(price)or {unit=price};p.offset=l.bought[item]or 0;supplyModel.prices[item]=p
                    end
                    supplyModel.providers={}
                    for item,rows in pairs(model.providers)do
                        supplyModel.providers[item]={}
                        for _,provider in ipairs(rows)do
                            local p=copy(provider)
                            if l.providerPaid[p.key or provider]then p.tip=0;p.transferCost=0 end
                            supplyModel.providers[item][#supplyModel.providers[item]+1]=p
                        end
                    end
                    selected=app.compareRouteSupply(supplyModel,id,n,model.excludedGuild and model.excludedGuild[id])
                end
                local supply=selected.best
                if supply and supply.kind~='ah'then
                    -- Reserve material ownership once in the same ledger; the
                    -- independent comparison must not credit it a second time.
                    local p=supply.provider;local count=math.ceil(n/p.output)
                    l.providerPaid[p.key or p]=true
                    if p.mode=='materials'then
                        l.consumingAt=p.kind=='alt'and p.character or nil
                        for material,qty in pairs(p.inputs or {})do
                            local missing=own(l,model,material,qty*count);buy(l,model,material,missing)
                        end
                        l.consumingAt=nil
                        local paid=p.tip+p.transferCost
                        l.cashTransfer=l.cashTransfer+paid;l.net=l.net+paid
                    else l.cashTransfer=l.cashTransfer+supply.cash;l.net=l.net+supply.net end
                    l.transfers[#l.transfers+1]={item=id,quantity=n,source=supply.kind,provider=p,comparison=selected,stage=#l.segments+1}
                    l.produced[id]=(l.produced[id]or 0)+count*p.output-n
                else buy(l,model,id,n)end
            end
        end
        if r.outputItem and positive(r.outputMin)then
            l.produced[r.outputItem]=(l.produced[r.outputItem]or 0)+r.outputMin*s.crafts
            if finite(r.sell)then outputValues[r.outputItem]=r.sell end
        elseif r.outputItem then mark(l,'output_unknown',r.id)end
        l.segments[#l.segments+1]=copy(s)
    end
    for item,n in pairs(l.produced)do
        local sell=outputValues[item]
        if finite(sell)then l.vendor=l.vendor+n*sell;l.net=l.net-n*sell end
    end
    l.cash=l.cashMaterials+l.cashLearning+l.cashTransfer
    l.remaining=l.produced;l.mode=reuse and 'reuse'or 'buy'
    if l.provisional or l.unknownValue then l.knownNet=nil;l.knownCash=nil else l.knownNet=l.net;l.knownCash=l.cash end
    return l
end

function app.routeBetter(a,b)
    if not b then return true end
    if a.provisional~=b.provisional then return not a.provisional end
    if math.abs(a.net-b.net)>.000001 then return a.net<b.net end
    if (a.extraCrafts or 0)~=(b.extraCrafts or 0)then return (a.extraCrafts or 0)<(b.extraCrafts or 0)end
    if a.visits~=b.visits then return a.visits<b.visits end
    return #a.segments<#b.segments
end
