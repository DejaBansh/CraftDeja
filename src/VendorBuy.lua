-- SPDX-License-Identifier: MIT
local _,app=...
local state={open=false};app.vendorPurchase=state
local function now()return app.try(GetTime)or app.try(time)or 0 end
local function bags(id)return app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false,false,false,false)end
function app.vendorPurchasePlan()
    if not state.open or not app.active or app.active.invalidated then return nil end
    local rod,_,rodActive=app.rodPreparationPlan()
    if rodActive and not rod then return nil end
    local production=rod or app.productionEnabled()and app.productionPlan() or app.trainerSupplyPlan()
    local current=app.decision and app.decision.current
    if not production and (not current or current.needsLearning or not current.recipe.learned)then return nil end
    local plan=production or (app.isPoison and app.isPoison()and app.poisonPlan()or app.materialPlan(current.recipe,app.planningTarget()))
    if plan and not plan.trainerTrip and app.craftRequirementTask(plan.recipe,true)then return nil end
    if not plan or not plan.stockKnown then return nil end
    if app.completeShoppingPlan then plan=app.completeShoppingPlan(plan)end
    local offers={}
    for slot=1,(app.try(GetMerchantNumItems)or 0)do
        local offer=app.readMerchantOffer(slot)
        if offer and offer.available==-1 then offers[offer.id]=offer end
    end
    local rows={}
    for _,row in ipairs(plan.rows)do
        local offer=offers[row.id]
        local missing=math.max(0,row.buy-app.confirmedMail(row.id)-app.purchaseReserved(row.id))
        if offer and missing>0 and offer.unit<=row.unit+.000001 then
            local max=app.try(GetMerchantItemMaxStack,offer.slot)or offer.bundle
            max=math.floor(max/offer.bundle)*offer.bundle
            if max>=offer.bundle then
                local buy=math.min(max,math.ceil(missing/offer.bundle)*offer.bundle)
                rows[#rows+1]={id=row.id,name=offer.name,slot=offer.slot,missing=missing,quantity=buy,bundle=offer.bundle,
                    price=offer.price,unit=offer.unit,cost=offer.price*buy/offer.bundle,locations=row.locations}
            end
        end
    end
    return{rows=rows,from=plan.from,target=plan.target,crafts=plan.crafts}
end
function app.offerVendorPurchase()
    if not state.open or state.dismissed then return end
    app.refresh(false)
    local plan=app.vendorPurchasePlan();state.plan=plan
    if plan and #plan.rows>0 then app.showVendorBuy()
    elseif app.vendorBuyWindow then app.vendorBuyWindow:Hide()end
end
function app.retryVendorPurchase()
    app.vendorBuyTick()
    -- A timeout is not proof that the server rejected the purchase.
    -- Keep the request locked until the bag update confirms it; otherwise
    -- a late reply can turn an explicit retry into a duplicate purchase.
    if state.pending then
        if now()-state.pending.when>5 then
            state.status='vendor_buy_wait';app.renderVendorBuy()
        end
        return false
    end
    state.status='vendor_buy_changed';app.offerVendorPurchase();return true
end
function app.buyVendorMaterial(id)
    if not state.open or state.pending then return false end
    local shown
    for _,row in ipairs(state.plan and state.plan.rows or {})do if row.id==id then shown=row end end
    app.observeMerchant();app.refresh(false)
    local plan=app.vendorPurchasePlan();local current
    for _,row in ipairs(plan and plan.rows or {})do if row.id==id then current=row end end
    if not shown or not current then app.offerVendorPurchase();return false end
    if current.slot~=shown.slot or current.cost~=shown.cost or current.quantity~=shown.quantity or current.price~=shown.price or current.stockVisit~=shown.stockVisit then
        state.status='vendor_buy_changed';state.plan=plan;app.renderVendorBuy();return false
    end
    local money=app.try(GetMoney);local before=bags(id)
    if not money or money<current.cost then state.status='vendor_buy_gold';app.actionNotice=app.caption(state.status);app.renderVendorBuy();return false end
    if type(before)~='number'then state.status='shop_unknown_stock';app.renderVendorBuy();return false end
    if current.stockVisit and not app.canReceiveStock(current.id,current.quantity)then
        state.status='stock_bags_full';app.actionNotice=app.caption(state.status);app.renderVendorBuy();return false
    end
    if type(BuyMerchantItem)~='function'then state.status='vendor_buy_unsupported';app.renderVendorBuy();return false end
    state.pending={id=id,before=before,quantity=current.quantity,when=now(),stockVisit=current.stockVisit};state.status='vendor_buy_pending'
    app.renderVendorBuy()
    -- Units (not number of packages), rounded to the merchant's stackCount step.
    local ok=pcall(BuyMerchantItem,current.slot,current.quantity)
    if not ok then state.pending=nil;state.status='vendor_buy_failed';app.renderVendorBuy();return false end
    return true
end
function app.vendorBuyTick()
    if state.pending then
        local p=state.pending;local count=bags(p.id)
        if count and count>=p.before+p.quantity then
            state.pending=nil;state.status='vendor_buy_done'
            if app.captureInventory and not app.craftRefreshBusy()then app.captureInventory()end
            if state.open then app.offerVendorPurchase()elseif app.refreshNextStep then app.refreshNextStep(true)end
        elseif now()-p.when>5 then state.status='vendor_buy_wait' end
    end
    if state.open and app.vendorBuyWindow and app.vendorBuyWindow:IsShown()then app.renderVendorBuy()end
end
function app.vendorBuyEvent(event)
    if event=='MERCHANT_SHOW'then state.open=true;state.dismissed=false;state.status=nil;app.offerVendorPurchase()
    elseif event=='MERCHANT_UPDATE'and state.open then app.vendorBuyTick();if not state.pending then app.offerVendorPurchase()end
    elseif event=='MERCHANT_CLOSED'then state.open=false;if app.vendorBuyWindow then app.vendorBuyWindow:Hide()end end
end
