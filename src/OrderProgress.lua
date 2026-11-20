-- SPDX-License-Identifier: MIT
local _,app=...
local words={en={order_title='Order overview',order_ah='Shopping',order_mail='Mail',order_vendor='Vendor',order_craft='Crafting',order_done='Done',order_none='No order',order_open='Open',order_ok='Done',order_none_needed='Not needed',order_unknown='Waiting for current plan and stock.',order_units='%d units remaining',order_casts='%d crafts remaining',order_casted='%d successful crafts recorded',order_pending='%d units awaiting purchase confirmation',order_storage='Bank / alts: collect %d units',order_help='Hover over a station for open items. Purchases require confirmation; native crafting is started by you.',order_scan='Waiting for the current AH scan.',order_more='%d more item types'},de={order_title='Auftragsübersicht',order_ah='Einkaufen',order_mail='Post',order_vendor='Händler',order_craft='Herstellen',order_done='Fertig',order_none='Kein Auftrag',order_open='Offen',order_ok='Erledigt',order_none_needed='Nicht nötig',order_unknown='Warte auf aktuellen Plan und Bestand.',order_units='%d Stück offen',order_casts='%d Herstellungen offen',order_casted='%d erfolgreiche Herstellungen erfasst',order_pending='%d Stück warten auf Kaufbestätigung',order_storage='Bank / Alts: %d Stück holen',order_help='Maus über eine Station für offene Materialien. Käufe bestätigen; Herstellung startest du im Berufsfenster.',order_scan='Warte auf den aktuellen AH-Scan.',order_more='%d weitere Materialarten'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
local definitions={{'ah','coin'},{'mail','bag'},{'vendor','merchant'},{'craft','hammer'},{'done','check'}}
local activeStage={ah='ah',ah_buy='ah',ah_confirm='ah',ah_load='ah',ah_wait='ah',ah_done='ah',scan='ah',mail='mail',vendor='vendor',vendor_wait='vendor',tool='craft',station='craft',craft='craft',craft_native='craft',craft_queue='craft'}
local function freshOverview()
    local v={storage=0,crafted=0}
    for _,def in ipairs(definitions)do v[def[1]]={n=0,lines={},state='pending'}end
    return v
end
local function line(stage,n,name)
    if n<=0 then return end
    stage.n=stage.n+n;stage.lines[#stage.lines+1]=n..' x '..name
end
local function job()return app.isPoison()and app.character.poisons and app.character.poisons.job end
function app.orderProgressEvent(event,unit,guid,id)
    if event~='UNIT_SPELLCAST_SUCCEEDED'or unit~='player'then return end
    app.productionCraftEvent(unit,guid,id)
    local o=app.character.orderProgress
    if not o or not app.active or o.profession~=app.active.profile.id or not o.recipes[id]or o.finished or guid and guid==o.lastGUID then return end
    o.lastGUID=guid;o.crafted=o.crafted+1
end
-- Read-only projection of the existing shopping/mail/inventory/craft state.
-- The small saved record stores identity and observed craft successes only;
-- it does not create a second purchase budget or operate any native buttons.
function app.orderOverview(plan,task)
    local v=freshOverview();local prof=app.active and app.active.profile
    if not prof then v.unknown=true;return v end
    local j=job();local poison=app.isPoison()
    if j then plan=app.poisonPlan()end -- aggregate all selected poisons, including during a single native batch
    local o=app.character.orderProgress
    if o and o.profession~=prof.id then o=nil end
    if poison and not j and not app.poisonDone then o=nil end -- cancelled, not completed
    if plan and plan.recipe then
        local key=j and 'poisons:'..j.serial or plan.toolPreparation and 'rod:'..plan.jobSerial..':'..plan.recipe.id or plan.production and 'production:'..plan.jobSerial or (prof.id..':'..plan.recipe.id..':'..tostring(app.shopping.goal)..':'..tostring(app.shopping.points))
        -- Keep the initial route boundary while the same recipe is being crafted.
        if not o or o.key~=key or not poison and app.shopping.goal=='next'and o.target~=plan.target or o.finished and app.shopping.goal~='manual'and (plan.from or prof.skill)<(plan.target or prof.skill)then
            o={key=key,profession=prof.id,recipe=plan.recipe.id,target=plan.target,recipes={},crafted=0,items={}}
            app.character.orderProgress=o
        end
        if j then for id in pairs(j.initial)do o.recipes[id]=true end else o.recipes[plan.recipe.id]=true end
        if not poison and not plan.production and not app.craftBatch and not app.nativeCraftHandoff and type(o.target)=='number'and o.target>prof.skill then
            -- A native batch may use only today's bag stock; show the whole
            -- remaining route rather than shrinking the order to that batch.
            local full=app.materialPlan(plan.recipe,o.target)
            if full then plan=full end
        end
        for _,r in ipairs(plan.rows)do o.items[r.id]=r.name end
    end
    v.crafted=o and o.crafted or 0
    local production=app.productionEnabled()and app.productionJob()
    local goalDone=not(plan and plan.toolPreparation)and (production and production.remaining<=0
        or not production and (poison and app.poisonDone and not j or task and task.kind=='done'))
    if goalDone and o then o.finished=true end
    local scanning=task and task.kind=='scan'
    local known=plan and plan.stockKnown
    if scanning or app.active.invalidated or not goalDone and (not plan or not known)then v.unknown=true end
    local rows=plan and plan.rows or {}
    if not goalDone and known then
        for _,r in ipairs(rows)do
            local mail=app.confirmedMail(r.id);local pending=app.purchaseReserved(r.id)
            local missing=math.max(0,r.buy or 0)
            if r.vendor then line(v.vendor,math.max(0,missing-mail-pending),r.name)
            else line(v.ah,math.max(0,missing-mail),r.name)end
            if pending>0 then v.ah.lines[#v.ah.lines+1]=app.caption('order_pending',pending)end
            local loc=r.locations
            if loc and type(loc.bags)=='number'then
                local n=math.max(0,math.min(r.total,loc.total or loc.bags)-loc.bags)
                v.storage=v.storage+n
            end
        end
        v.craft.n=plan.crafts or 0
        v.craft.estimated=plan.estimated and not app.nativeCraftHandoff and not app.craftBatch
        if j then
            for id,n in pairs(j.remaining)do if n>0 then
                local r=app.active.recipes[id];v.craft.lines[#v.craft.lines+1]=n..' x '..(r and app.recipeName(r)or tostring(id))
            end end
        elseif plan.recipe then v.craft.lines[1]=(plan.crafts or 0)..' x '..app.recipeName(plan.recipe)end
    end
    -- Confirmed mail remains an open task even after a craft boundary is reached.
    local items=o and o.items or {}
    for id,name in pairs(items)do line(v.mail,app.confirmedMail(id),name)end
    local transaction=app.purchasePending()
    if transaction and items[transaction.id]and v.ah.n==0 then
        v.ah.n=app.purchaseReserved(transaction.id)
        v.ah.lines[#v.ah.lines+1]=app.caption('order_pending',v.ah.n)
    end
    v.finished=goalDone and not v.unknown and v.ah.n==0 and v.mail.n==0 and v.vendor.n==0 and v.storage==0
    for _,def in ipairs(definitions)do
        local key=def[1];local s=v[key]
        s.state=v.unknown and 'unknown'or s.n==0 and 'done'or 'pending'
    end
    v.done.state=v.finished and 'done'or 'pending'
    if not v.finished and task and activeStage[task.kind]then v[activeStage[task.kind]].state='active'end
    if scanning then
        v.ah.state='active';v.ah.lines={app.caption('order_scan')};v.ah.waiting=true
        -- A scan cannot certify that any previous shopping requirement is met.
        if not plan then v.ah.n=nil end
    end
    if not goalDone then v.done.state='pending'end
    return v
end
function app.renderOrderProgress(parent,plan,task,y)
    if not parent.orderBar then
        local f=CreateFrame('Frame',nil,parent);parent.orderBar=f;f:SetSize(324,85);f.columns={}
        f.heading=app.createLabel(f,10,0,0,324)
        f.storage=app.createLabel(f,9,0,-76,324);f.storage:SetHeight(22)
        for i,def in ipairs(definitions)do
            local c=CreateFrame('Frame',nil,f);c:SetSize(62,58);c:SetPoint('TOPLEFT',(i-1)*65,-17)
            c.icon=c:CreateTexture(nil,'OVERLAY');c.icon:SetSize(19,19);c.icon:SetPoint('TOPLEFT',21,0);c.icon:SetTexture(app.uiPath('Icon_'..def[2]))
            c.label=app.createLabel(c,9,0,-23,62);c.label:SetJustifyH('CENTER');c.label:SetHeight(13)
            c.count=app.createLabel(c,9,0,-38,62);c.count:SetJustifyH('CENTER');c.count:SetHeight(17)
            c:EnableMouse(true);c:SetScript('OnEnter',function(self)
                local data=self.data;local lines={}
                if data then
                    for n=1,math.min(8,#data.lines)do lines[#lines+1]=data.lines[n]end
                    if #data.lines>8 then lines[#lines+1]=app.caption('order_more',#data.lines-8)end
                    if #lines==0 then lines[1]=app.caption(data.state=='unknown'and 'order_unknown'or self.stage=='done'and (f.view.finished and 'order_ok'or 'order_open')or 'order_none_needed')end
                    if self.stage=='craft'then lines[#lines+1]=app.caption('order_casted',f.view.crafted)end
                end
                lines[#lines+1]=app.caption('order_help');app.showTip(self,app.caption('order_'..self.stage),lines)
            end);c:SetScript('OnLeave',app.hideTip);c.stage=def[1];f.columns[i]=c
        end
    end
    local f=parent.orderBar;local v=app.orderOverview(plan,task);f.view=v
    f:ClearAllPoints();f:SetPoint('TOPLEFT',18,-y);f.heading:SetText(app.caption('order_title'))
    for i,def in ipairs(definitions)do
        local key=def[1];local s=v[key];local c=f.columns[i];c.data=s
        local colour=s.state=='done'and {0.42,.88,.57}or s.state=='active'and {1,.81,.3}or {.65,.61,.72}
        c.label:SetText(app.caption('order_'..key));c.label:SetTextColor(unpack(colour));c.count:SetTextColor(unpack(colour))
        c.icon:SetAlpha((s.state=='pending'or s.state=='unknown')and .4 or 1)
        app.try(c.icon.SetDesaturated,c.icon,s.state=='pending'or s.state=='unknown')
        c.count:SetText(key=='done'and app.caption(v.finished and 'order_ok'or 'order_open')or (s.state=='unknown'or s.waiting)and '?'or (s.estimated and '~'or '')..tostring(s.n or 0))
    end
    f.storage:SetText(v.storage>0 and app.caption('order_storage',v.storage)or '')
    f:SetHeight(v.storage>0 and 100 or 78);f:Show();return f:GetHeight()+6
end
