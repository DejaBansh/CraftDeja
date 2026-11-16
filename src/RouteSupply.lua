-- SPDX-License-Identifier: MIT
local _,app=...
local function progress(s)
    local o=app.currentRouteOrder();if not o or not s or not s.provider then return end
    o.supplyProgress=o.supplyProgress or {};local key=s.provider.key or ('stock:'..tostring(s.provider.character)..':'..s.item)
    o.supplyProgress[key]=o.supplyProgress[key]or {item=s.item,quantity=s.quantity,provider=s.provider,source=s.source}
    return o.supplyProgress[key],key
end
function app.prepareRouteHandover(s)
    if not s or s.source~='guild'or not s.provider.accepted or s.provider.guild~=app.routeGuildIdentity()then return false end
    local p=progress(s);if not p then return false end
    p.before={}
    local count=math.ceil(s.quantity/(s.provider.output or 1))
    for item,n in pairs(s.provider.inputs or {})do
        local row=app.inventoryFor(item)
        if not row or (row.bags or 0)<n*count then p.before=nil;return false end
        p.before[item]=row.bags
    end
    p.status='handover_prepared';return true
end
function app.confirmRouteHandover(s)
    local p=progress(s);if not p or not p.before then return false end
    local count=math.ceil(s.quantity/(s.provider.output or 1))
    for item,n in pairs(s.provider.inputs or {})do
        local row=app.inventoryFor(item)
        if not row or row.bags==nil or p.before[item]-row.bags<n*count then return false end
    end
    p.status='materials_sent';p.at=app.try(time)or 0
    app.invalidateRoute('handover');return true
end
function app.routeProcurementPlan(s)
    if not s or s.source=='alt_stock'or s.provider.mode~='materials'then return end
    local p=progress(s);if p and p.status=='materials_sent'then return end
    local r=app.decision and app.decision.current.recipe
    if not r then return end
    local recipe=app.copy(r);recipe.learned=true
    local plan={recipe=recipe,rows={},crafts=1,from=app.active.profile.skill,target=app.active.profile.skill+1,
        purchase=0,stockKnown=true,supplyOnly=true,routeProcurement=s.provider.key,routeOrder=app.currentRouteOrder().id}
    local count=math.ceil(s.quantity/(s.provider.output or 1))
    for item,n in pairs(s.provider.inputs or {})do
        local row=app.inventoryFor(item);local unit=app.unitPrice(item,{})
        if not unit then return nil,'no_prices'end
        local held=row and row.total
        if held==nil then plan.stockKnown=false end
        local total=n*count;local buy=math.max(0,total-(held or 0))
        plan.rows[#plan.rows+1]={id=item,total=total,owned=held,buy=buy,locations=row,unit=unit,name=app.itemName(item)}
        plan.purchase=plan.purchase+buy*unit
    end
    table.sort(plan.rows,function(a,b)return a.id<b.id end)
    return app.completeShoppingPlan(plan)
end
function app.currentRouteSupply()
    local order=app.currentRouteOrder();if not order or not order.active then return end
    if order.owner~=app.characterKey then
        for _,s in ipairs(order.lastSupply or {})do if s.provider.character==app.characterKey and not order.forceAH[s.item]then return s end end
        return
    end
    for _,p in pairs(order.supplyProgress or {})do
        if p.status=='materials_sent'and not order.forceAH[p.item]then
            local row=app.inventoryFor(p.item)
            if row and (row.bags or 0)>=p.quantity then p.status='received'
            else return {item=p.item,quantity=p.quantity,source=p.source,provider=p.provider,stage=1}end
        end
    end
    local best=app.routeResult and app.routeResult.best
    for _,s in ipairs(best and best.transfers or {})do
        if s.stage==1 and not order.forceAH[s.item]then local row=app.inventoryFor(s.item);if not row or (row.bags or 0)<s.quantity then return s end end
    end
end
function app.routeSupplyCraftPlan()
    local order=app.currentRouteOrder();if not order or not order.active or order.owner==app.characterKey then return end
    local s=app.currentRouteSupply();if not s or not s.provider.recipe or s.source=='alt_stock'then return end
    local r=app.active and app.active.recipes[s.provider.recipe]
    if not r or not r.learned or not r.confirmed or not r.materialsFromClient or not r.outputFromClient or r.outputItemID~=s.item then return end
    local row=app.inventoryFor(s.item);local missing=math.max(0,s.quantity-(row and row.bags or 0))
    if missing<=0 then return end
    local quote=app.quote(r,{});if not quote then return end
    local count=math.ceil(missing/r.outputMin)
    local plan={recipe=r,production=true,routeSupply=true,jobSerial=order.id,rows={},crafts=count,from=app.active.profile.skill,
        target=app.active.profile.skill,purchase=0,stockKnown=true}
    for _,input in ipairs(quote.inputs)do
        local loc=app.inventoryFor(input.item);local total=input.amount*count
        local buy=math.max(0,total-(loc and loc.total or 0))
        if not loc or loc.total==nil then plan.stockKnown=false end
        plan.rows[#plan.rows+1]={id=input.item,total=total,buy=buy,owned=loc and loc.total,locations=loc,unit=input.unit,name=app.itemName(input.item)}
        plan.purchase=plan.purchase+buy*input.unit
    end
    return plan
end
local shopping=app.shoppingPlan
app.shoppingPlan=function(...)
    local order=app.currentRouteOrder()
    if order and order.active then
        local s=app.currentRouteSupply()
        local plan=order.owner==app.characterKey and app.routeProcurementPlan(s)or app.routeSupplyCraftPlan()
        if plan then return app.completeShoppingPlan(plan)end
    end
    return shopping(...)
end
local key=app.purchaseKey
app.purchaseKey=function(plan)
    if plan.routeProcurement then return 'route_supply:'..plan.routeOrder..':'..plan.routeProcurement end
    return key(plan)
end
local task=app.routeTask
app.routeTask=function(plan)
    local order=app.currentRouteOrder();if not order or not order.active then return end
    local s=app.currentRouteSupply()
    if s then
        if order.owner~=app.characterKey then
            local craft=app.routeSupplyCraftPlan()
            if craft then
                craft=app.completeShoppingPlan(craft)
                local next=app.nextStep(craft);next.routePlan=craft;next.supply=s
                return next
            end
        end
        local p=progress(s)
        local materials=order.owner==app.characterKey and app.routeProcurementPlan(s)
        if materials then
            local ready=true
            for _,r in ipairs(materials.rows)do if not r.locations or (r.locations.bags or 0)<r.total then ready=false end end
            if not ready then local next=app.nextStep(materials);next.supply=s;next.supplyPlan=materials;return next end
        end
        return {kind=s.source=='guild'and 'route_supply_guild'or 'route_supply_alt',key='route_supply:'..s.item,
            body=app.caption(p and p.status=='materials_sent'and 'route_wait_delivery'or 'route_supply_action',app.itemName(s.item),s.quantity,s.provider.name or '?'),supply=s}
    end
    return task(plan)
end
