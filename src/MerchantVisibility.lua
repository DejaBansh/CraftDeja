-- SPDX-License-Identifier: MIT
local _,app=...
app.words.de.merchant_auto='Beim Händler automatisch öffnen'
app.words.en.merchant_auto='Automatically open at merchants'
local render=app.renderNextStep
app.renderNextStep=function(...)
    local merchant=app.merchantUIEvent or app.vendorPurchase and app.vendorPurchase.open
    local f=app.nextStepWindow
    if app.options.autoOpenMerchant~=false then app.merchantClosedHold=nil end
    if app.options.autoOpenMerchant==false and not app.explicitUIOpen then
        if merchant and (not f or not f:IsShown())then app.merchantClosedHold=true end
        if app.merchantClosedHold then return end
    end
    return render(...)
end
-- Manual entry and the actual profession-open event preserve their existing
-- behavior. No new order is created here; these functions resume the current one.
for _,name in ipairs({'command','showCentralGuide','showOptions','showUnifiedGeneral','onProfessionOpened'})do
    local original=app[name]
    app[name]=function(...)
        local old=app.explicitUIOpen;app.explicitUIOpen=true
        app.merchantClosedHold=nil
        local ok,a,b,c=pcall(original,...);app.explicitUIOpen=old
        if not ok then error(a)end;return a,b,c
    end
end
