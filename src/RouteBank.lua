-- SPDX-License-Identifier: MIT
local _,app=...
app.words.de.route_bank_title='Für spätere Routenabschnitte in die Bank legen:'
app.words.en.route_bank_title='Put these supplies in the bank for later route sections:'
app.words.de.route_bank_line='%d x %s'
app.words.en.route_bank_line='%d x %s'
app.words.de.route_bank_action='%d x %s für spätere Skillups in die Bank legen. Aktueller Materialbedarf bleibt in den Taschen.'
app.words.en.route_bank_action='Bank %d x %s for later skill-ups. Keep the current section materials in your bags.'
app.words.de.route_bank_open='Bankmaterialien anzeigen';app.words.en.route_bank_open='Show bank supplies'
app.words.de.route_bank_later='Jetzt weiterherstellen';app.words.en.route_bank_later='Keep crafting for now'
local cachedSearch,cachedDemand
function app.routeBankRows()
    local order=app.currentRouteOrder();local search=app.routeResult;local best=search and search.best
    if not order or not order.active or order.owner~=app.characterKey or not best or not app.active or
        app.active.profile.id~=order.profession or app.routeDirty or app.routeSearch or app.craftRefreshBusy()or app.nativeCraftHandoff or app.purchasePending()then return {}end
    local first=best.segments[1];if not first or app.active.profile.skill>=first.to then return {}end
    if cachedSearch~=search then
        cachedSearch=search;cachedDemand={}
        for i=2,#best.segments do
            local s=best.segments[i];local r=search.model.recipes[s.recipe]
            for item,n in pairs(r and r.inputs or {})do cachedDemand[item]=(cachedDemand[item]or 0)+n*s.crafts end
        end
    end
    local have,any={},false
    for item,n in pairs(cachedDemand)do
        local loc=app.inventoryFor(item)
        if loc and type(loc.bags)=='number'and loc.bags>0 then have[item]={location=loc,want=n};any=true end
    end
    if not any then return {}end
    local r=app.active.recipes[first.recipe]
    local plan=r and app.materialPlan(r,first.to)
    if not plan then return {}end
    local keep={};for _,row in ipairs(plan.rows)do keep[row.id]=row.total end
    local rows={}
    for item,row in pairs(have)do
        local bank=math.max(0,row.location.bank or 0)
        local quantity=math.floor(math.min(math.max(0,row.want-bank),math.max(0,row.location.bags-(keep[item]or 0))))
        if quantity>0 then rows[#rows+1]={item=item,quantity=quantity}end
    end
    table.sort(rows,function(a,b)return a.item<b.item end);return rows
end
local task=app.routeTask
app.routeTask=function(plan)
    local current=task(plan);if current then return current end
    local order=app.currentRouteOrder();local search=app.routeResult
    local first=search and search.best and search.best.segments[1]
    if not order or not first or not app.pinnedRouteDecision()then return end
    local key=first.recipe..':'..first.to
    if order.bankDeferredAt==key or app.craftRequirementTask(app.decision and app.decision.current.recipe,true)then return end
    local rows=app.routeBankRows();local row=rows[1]
    if row then return {kind='route_bank',key='route_bank:'..row.item..':'..row.quantity,bankCheckpoint=key,
        body=app.caption('route_bank_action',row.quantity,app.itemName(row.item))}end
end
local render=app.renderRouteWindow
app.renderRouteWindow=function()
    render()
    local f=app.routeWindow;if not f or not f:IsShown()then return end
    local rows=app.routeBankRows();if #rows==0 then return end
    local lines={f.body:GetText(),app.caption('route_bank_title')}
    for _,r in ipairs(rows)do lines[#lines+1]=app.caption('route_bank_line',r.quantity,app.itemName(r.item))end
    f.body:SetText(table.concat(lines,'\n'));local h=f.body:GetStringHeight()+10;f.body:SetHeight(h);f.child:SetHeight(math.max(280,h))
end
local cta=app.applyGuideCTA
app.applyGuideCTA=function(f,plan)
    cta(f,plan)
    if f.task and f.task.kind=='route_bank'then
        f.primaryCTA:SetText(app.caption('route_bank_open'))
        if not f.bankLater then f.bankLater=app.createButton(f,18,0,324,'',function()
            local order=app.currentRouteOrder()
            if order and f.task then order.bankDeferredAt=f.task.bankCheckpoint;app.refreshNextStep(true)end
        end)end
        f.bankLater:ClearAllPoints();f.bankLater:SetPoint('TOPLEFT',18,-f:GetHeight()+5)
        f.bankLater:SetText(app.caption('route_bank_later'));app.styleCTAButton(f.bankLater,false);f.bankLater:Show();f:SetHeight(f:GetHeight()+40)
    elseif f.bankLater then f.bankLater:Hide()end
end
