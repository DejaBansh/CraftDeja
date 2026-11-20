-- SPDX-License-Identifier: MIT
local _,app=...
local limit=500
local function clock()return app.try(GetTime)or 0 end
local function state()
    if not app.character then return nil end
    app.character.flowLog=app.character.flowLog or {sequence=0,entries={}}
    return app.character.flowLog
end
local function scalar(v)
    if type(v)=='string'then return v:sub(1,250):gsub('[\r\n]',' ')end
    if type(v)=='number'or type(v)=='boolean'then return tostring(v)end
    return nil
end
local function fieldsText(fields)
    local keys={};for k,v in pairs(fields or {})do if type(k)=='string'and scalar(v)then keys[#keys+1]=k end end;table.sort(keys)
    local parts={};for _,k in ipairs(keys)do parts[#parts+1]=k..'='..scalar(fields[k])end
    return table.concat(parts,' ')
end
function app.flowLog(event,fields)
    if event:sub(1,6)=='click.'then app.lastUserAction=clock()end
    if not app.options or app.options.flowLogging==false then return end
    local s=state();if not s then return end
    local text=fieldsText(fields);local signature=event..' '..text;local last=s.entries[#s.entries]
    if last and last.signature==signature and clock()-(last.clock or 0)<1 then last.repeats=(last.repeats or 1)+1;return end
    s.sequence=s.sequence+1;s.entries[#s.entries+1]={seq=s.sequence,at=app.try(time)or 0,clock=clock(),event=event,text=text,signature=signature}
    if #s.entries>limit then table.remove(s.entries,1)end
end
function app.traceProfessionRead(profile,confirmed)
    local signature=table.concat({profile.id,profile.skill,profile.cap or 0,confirmed},':')
    if signature~=app.lastProfessionRead then
        app.lastProfessionRead=signature
        app.flowLog('profession.read',{profession=profile.id,skill=profile.skill,confirmed=confirmed})
    end
end
function app.traceState()
    local p=app.active and app.active.profile;local d=app.decision
    local buyer=Auctionator and Auctionator.State and Auctionator.State.BuyCommodityFrameRef or AuctionatorBuyCommodityFrame
    local fields={buyerShown=buyer and app.try(buyer.IsShown,buyer)or false,buyerVisible=buyer and app.try(buyer.IsVisible or buyer.IsShown,buyer)or false,buyerItem=buyer and buyer.expectedItemID or 0,profession=p and p.id or 0,skill=p and p.skill or 0,recipe=d and d.current.recipe.id or 0,
        stop=d and d.stop or 0,professionOpen=app.professionOpen==true,nativeVisible=app.nativeProfessionVisible and app.nativeProfessionVisible(),
        loading=app.professionLoading==true,ahOpen=app.shopping and app.shopping.open or false,
        fresh=app.shoppingFresh and not not app.shoppingFresh()or false,problem=app.problem or '-'}
    local signature=fieldsText(fields)
    if signature~=app.lastFlowState then app.lastFlowState=signature;app.flowLog('state',fields)end
end
function app.tracePlan(plan,task)
    local fields={task=task.kind,goal=app.shopping and app.shopping.goal or '-',recipe=plan and plan.recipe.id or 0,from=plan and plan.from or 0,target=plan and plan.target or 0,crafts=plan and plan.crafts or 0,
        bagCrafts=task.available or 0,batch=task.batch or 0,offer=task.offer and task.offer.phase or '-',guideShown=app.guideRequested==true}
    if task.kind=='stock_vendor'and task.offer then
        fields.item=task.offer.id;fields.quantity=task.offer.quantity;fields.missing=task.offer.missing
    end
    local signature=fieldsText(fields);local rows={}
    for _,r in ipairs(plan and plan.rows or {})do
        local loc=r.locations or {}
        local row={item=r.id,needed=r.total or 0,owned=r.owned or -1,bags=loc.bags or -1,bank=loc.bank or -1,buy=r.buy or 0,
            mail=app.confirmedMail and app.confirmedMail(r.id)or 0,unit=r.unit or 0,ceiling=r.maxUnit or 0,vendor=not not r.vendor}
        rows[#rows+1]=row;signature=signature..'|'..fieldsText(row)
    end
    if signature~=app.lastFlowPlan then
        app.lastFlowPlan=signature;app.flowLog('task.plan',fields)
        for _,r in ipairs(rows)do app.flowLog('material',r)end
    end
end
function app.logExport()
    local s=state()or {entries={}};local version,build,_,interface=app.try(GetBuildInfo)
    local lines={'CraftDeja diagnostic log','Addon: '..app.release,'Client: '..tostring(version or '?')..' / '..tostring(build or '?')..' / '..tostring(interface or '?'),
        'Locale: '..tostring(app.try(GetLocale)or '?'),'Logging: '..tostring(app.options.flowLogging~=false),'Entries: '..#s.entries..' / '..limit,
        'No chat/account credentials are recorded.','---'}
    for _,e in ipairs(s.entries)do
        lines[#lines+1]=string.format('#%d [%s] %s %s%s',e.seq,app.try(date,'%H:%M:%S',e.at)or tostring(e.at),e.event,e.text,e.repeats and ' (x'..e.repeats..')'or '')
    end
    if app.referenceData then lines[#lines+1]='\nData package: '..app.referenceData.version..' / '..app.referenceData.packaged end
    if app.auditCount and app.auditCount()>0 then lines[#lines+1]='\n'..app.recipeAuditExport(20)end
    return table.concat(lines,'\n')
end
local function openFlowLog()
    if not app.flowLogWindow then
        local f=app.createWindow('CraftDejaFlowLog',640,440)
        f.title:SetText('CraftDeja - '..app.caption('flow_log_title'))
        f.status=app.createLabel(f,11,18,-50,600)
        local scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');scroll:SetSize(580,300);scroll:SetPoint('TOPLEFT',18,-76)
        local e=CreateFrame('EditBox',nil,scroll);f.box=e;e:SetMultiLine(true);e:SetAutoFocus(false);e:SetWidth(558)
        e:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',11,'');scroll:SetScrollChild(e)
        e:SetScript('OnEscapePressed',function(self)self:ClearFocus()end)
        f.select=app.createButton(f,18,-392,145,app.caption('flow_copy'),function()f.box:SetFocus();f.box:HighlightText()end)
        f.refresh=app.createButton(f,173,-392,145,app.caption('flow_refresh'),function()app.showFlowLog()end)
        f.toggle=app.createButton(f,328,-392,145,'',function()app.options.flowLogging=app.options.flowLogging==false;app.lastFlowState=nil;app.lastFlowPlan=nil;app.showFlowLog()end)
        f.clear=app.createButton(f,483,-392,139,app.caption('flow_clear'),function()app.character.flowLog={sequence=0,entries={}};app.lastFlowState=nil;app.lastFlowPlan=nil;app.showFlowLog()end)
        app.flowLogWindow=f
    end
    app.traceState();local f=app.flowLogWindow
    f.title:SetText('CraftDeja - '..app.caption('flow_log_title'));f.status:SetText(app.caption('flow_log_status',#(state().entries),limit))
    f.toggle:SetText(app.caption(app.options.flowLogging==false and 'flow_enable'or 'flow_disable'))
    -- EditBox has GetNumLines, not FontString:GetStringHeight. A real
    -- multiline EditBox sizes its text automatically; keep a minimum viewport.
    f.box:SetText(app.logExport());f.box:SetHeight(math.max(300,(app.try(f.box.GetNumLines,f.box)or 20)*14+14))
    f:Show();f.box:SetFocus();f.box:HighlightText()
end

-- A diagnostic window must never fail silently, even if a future client API
-- differs again. Report its actual error directly through the game's chat.
function app.showFlowLog()
    local ok,message=pcall(openFlowLog)
    if not ok then
        pcall(app.flowLog,'log.window_error',{message=tostring(message)})
        local text='CraftDeja '..app.release..' - Log error: '..tostring(message)
        if DEFAULT_CHAT_FRAME and type(DEFAULT_CHAT_FRAME.AddMessage)=='function'then
            DEFAULT_CHAT_FRAME:AddMessage((text:gsub('|','||')))
        end
    end
    return ok,message
end

function app.installFlowErrorHook()
    if app.flowErrorHook or type(geterrorhandler)~='function'or type(seterrorhandler)~='function'then return end
    local previous=geterrorhandler();if type(previous)~='function'then return end
    local capturing=false
    local function handler(message,...)
        if not capturing and type(message)=='string'and message:find('CraftDeja',1,true)then
            capturing=true
            pcall(app.flowLog,'lua.error',{message=message,stack=app.try(debugstack,2,8,8)})
            capturing=false
        end
        return previous(message,...)
    end
    seterrorhandler(handler);app.flowErrorHook=handler
end
