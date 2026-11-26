-- SPDX-License-Identifier: MIT
local _,app=...
local state={bankOpen=false,dirty=false,elapsed=0,tracked={},ready=false}
app.inventoryState=state
local function stamp()return app.try(time)or 0 end
local function count(id,bank,account)
    local n=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,bank,false,bank,account)
    return type(n)=='number'and n>=0 and math.floor(n)or nil
end
function app.initializeInventory()
    local name,realm=app.try(UnitFullName,'player')
    name=name or app.try(UnitName,'player')or app.characterKey or 'Player'
    realm=realm and realm~=''and realm or app.try(GetRealmName)or '?'
    app.character.identity={name=name,realm=realm,faction=app.playerFaction(),seen=stamp()}
    app.character.inventory=app.character.inventory or {items={}}
    app.character.inventory.items=app.character.inventory.items or {}
    app.saved.sharedInventory=app.saved.sharedInventory or {}
    app.saved.sharedInventory[realm]=app.saved.sharedInventory[realm]or {items={}}
    for _,recipes in pairs(app.catalog)do
        for _,recipe in pairs(recipes)do for id in pairs(recipe.ingredients or {})do state.tracked[id]=true end end
    end
    state.dirty=true
end
function app.trackRecipeInventory()
    if app.active then
        for _,r in pairs(app.active.recipes)do
            for _,g in ipairs(r.groups or {})do for _,id in ipairs(g.choices)do state.tracked[id]=true end end
        end
    end
end
local function readCurrent(id)
    local inventory=app.character.inventory
    if not inventory then return nil end
    local old=inventory.items[id]or {}
    local bags=count(id,false,false);local personal=count(id,true,false)
    if bags==nil then return nil end
    local now=stamp();old.bags=bags;old.bagWhen=now
    local bank=personal and personal>=bags and personal-bags or nil
    -- includeBank's valid numeric total is authoritative, including zero after
    -- a withdrawal. An unavailable API (nil) preserves the last saved bank.
    if bank then
        if bank>0 or state.bankOpen or old.bank~=nil then
            old.bank=bank;old.bankObserved=now
            if state.bankOpen then old.bankWhen=now end
        end
    end
    inventory.items[id]=old
    local shared=app.saved.sharedInventory[app.character.identity.realm]
    local all=count(id,true,true)
    local sharedCount=all and personal and all>=personal and all-personal or nil
    local canView=app.try(C_Bank and C_Bank.CanViewBank,Enum and Enum.BankType and Enum.BankType.Account)
    if sharedCount and (sharedCount>0 or (state.bankOpen and canView==true)or shared.items[id]~=nil)then
        shared.items[id]={count=sharedCount,when=now,bankWhen=state.bankOpen and now or nil}
    end
    local account=shared.items[id]
    return{name=app.character.identity.name,bags=bags,bank=old.bank,bankWhen=old.bankWhen,bankObserved=old.bankObserved,
        bankLive=state.bankOpen,shared=account and account.count or 0,
        sharedWhen=account and (account.bankWhen or account.when),
        total=bags+(old.bank or 0)+(account and account.count or 0)}
end
local function unbound(id)
    local fn=C_Item and C_Item.GetItemInfo or GetItemInfo
    if type(fn)~='function'then return false end
    local result={pcall(fn,id)}
    return result[1]and result[15]==0 -- GetItemInfo's 14th return is bindType.
end
function app.inventoryFor(id)
    if not app.character or not app.character.inventory then
        local total=count(id,true,false)
        return{total=total,alts={},altTotal=0,deductibleAlts=0}
    end
    local row=readCurrent(id)or {total=nil}
    row.alts={};row.altTotal=0;row.deductibleAlts=0
    local me=app.character.identity
    local transferable=unbound(id)
    for key,character in pairs(app.saved.characters)do
        local who=character.identity
        local item=character.inventory and character.inventory.items and character.inventory.items[id]
        if key~=app.characterKey and who and who.realm==me.realm and item then
            local total=(item.bags or 0)+(item.bank or 0)
            if total>0 then
                local eligible=transferable and me.realm~='?'and who.faction~=nil and who.faction==me.faction
                row.alts[#row.alts+1]={key=key,name=who.name,realm=who.realm,bags=item.bags or 0,bank=item.bank,
                    bagWhen=item.bagWhen,bankWhen=item.bankWhen or item.bankObserved,eligible=eligible,total=total}
                row.altTotal=row.altTotal+total
                if eligible and app.options.inventoryAlts then row.deductibleAlts=row.deductibleAlts+total end
            end
        end
    end
    table.sort(row.alts,function(a,b)return a.name==b.name and a.key<b.key or a.name<b.name end)
    if row.total~=nil then row.total=row.total+row.deductibleAlts end
    return row
end
function app.inventoryTimestamp(value)
    if not value then return app.caption('inventory_unknown')end
    return app.try(date,'%d.%m. %H:%M',value)or tostring(value)
end
function app.inventoryLines(row,required)
    local lines={}
    lines[#lines+1]=app.caption('inventory_owner',row.name or app.caption('inventory_me'),row.bags~=nil and tostring(row.bags)or '?',row.bank~=nil and tostring(row.bank)or '?')
    if row.bank and row.bank>0 then
        lines[#lines+1]=app.caption(row.bankLive and 'inventory_bank_live'or 'inventory_bank_saved',app.inventoryTimestamp(row.bankWhen or row.bankObserved))
    elseif row.bank==nil then lines[#lines+1]=app.caption('inventory_visit_bank')end
    if row.shared and row.shared>0 then lines[#lines+1]=app.caption('inventory_shared',row.shared,app.inventoryTimestamp(row.sharedWhen))end
    local take=required and math.min(math.max(0,required-(row.bags or 0)),row.bank or 0)or 0
    if take>0 then lines[#lines+1]='|cff79e696'..app.caption('inventory_take_bank',take)..'|r'end
    for _,alt in ipairs(row.alts or {})do
        lines[#lines+1]=app.caption('inventory_alt',alt.name,alt.bags,alt.bank~=nil and tostring(alt.bank)or '?')
        lines[#lines+1]=app.caption('inventory_alt_date',app.inventoryTimestamp(alt.bagWhen),app.inventoryTimestamp(alt.bankWhen))
        if app.options.inventoryAlts and not alt.eligible then lines[#lines+1]=app.caption('inventory_alt_not_deducted')end
    end
    return lines
end
function app.captureInventory()
    if not app.saved or not app.character.inventory then return end
    -- Consume the pending request up front. A re-dirtying event that fires
    -- during the scan must survive the capture instead of being wiped by an
    -- unconditional reset at the end.
    state.dirty=false;state.elapsed=0
    app.trackRecipeInventory()
    -- Include live-only reagents carried by an alt, even before that alt opens
    -- the profession. Previously seen IDs remain tracked so withdrawals clear.
    local api=C_Container or {}
    for bag=0,(NUM_TOTAL_EQUIPPED_BAG_SLOTS or NUM_BAG_SLOTS or 4)do
        local slots=app.try(api.GetContainerNumSlots or GetContainerNumSlots,bag)or 0
        for slot=1,slots do
            local id=app.try(api.GetContainerItemID or GetContainerItemID,bag,slot)
            if id then state.tracked[id]=true end
        end
    end
    for id in pairs(app.character.inventory.items)do state.tracked[id]=true end
    for id in pairs(state.tracked)do readCurrent(id)end
    app.character.identity.seen=stamp()
end
function app.inventoryEvent(event)
    if not app.saved then return end
    if event=='PLAYER_ENTERING_WORLD'then state.ready=true end
    if event=='BANKFRAME_OPENED'then state.bankOpen=true;state.dirty=true
    elseif event=='BANKFRAME_CLOSED'then state.bankOpen=false;app.captureInventory()
    elseif event=='BAG_UPDATE_DELAYED'or event=='PLAYERBANKSLOTS_CHANGED'or event=='PLAYERREAGENTBANKSLOTS_CHANGED'or event=='BANK_TABS_CHANGED'or event=='PLAYER_ENTERING_WORLD'then
        -- One pending window for the whole burst: no event may reset the
        -- debounce timer, otherwise mixed notification types would defer the
        -- capture indefinitely. Only the tick performs the capture.
        state.dirty=true
    elseif event=='PLAYER_LOGOUT'then app.captureInventory()end
end
function app.inventoryTick(delta)
    if state.dirty and state.ready then
        if app.craftRefreshBusy and app.craftRefreshBusy()then return end
        state.elapsed=state.elapsed+delta
        if state.elapsed>=.3 then
            app.captureInventory()
            if app.shoppingWindow and app.shoppingWindow:IsShown()then app.renderShopping()end
        end
    end
end
