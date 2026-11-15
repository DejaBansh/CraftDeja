-- SPDX-License-Identifier: MIT
local _,app=...
-- No wrappers, events or timers until explicitly started. A capture is bounded
-- to 30 seconds, counts only fixed public functions/event names, never arguments.
local names={'refresh','readRecipes','marketView','decide','selectionAt','learningAssessment','probability','quote','materialPlan','inventoryFor','captureInventory','trackRecipeInventory','refreshNextStep','renderNextStep','renderCatalogue','renderDetails','ahBuyStatus','observeCommodityResults','updateLiveCommodity','bindAuctionBuying','bindShopping'}
local function say(en,de)
    if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage('CraftDeja: '..(app.lang()=='de'and de or en))end
end
local function clock()
    if type(debugprofilestop)=='function'then return debugprofilestop()end
    return (app.try(GetTimePreciseSec)or app.try(GetTime)or 0)*1000
end
local function pack(...)return {n=select('#',...),...}end
local function setScript(frame,key,fn)
    -- A direct :SetScript call is instrumented AGAIN by wowlua dev builds.
    -- Keep the original callback identity so stopping a capture fully restores
    -- the pre-existing handler, rather than accumulating monitor wrappers.
    local setter=frame.SetScript;setter(frame,key,fn)
end
local function measure(state,label,fn,...)
    if not state.active then return fn(...)end
    local parent=state.current;local node={child=0};state.current=node
    local start=clock();local result=pack(pcall(fn,...));local elapsed=math.max(0,clock()-start)
    state.current=parent;if parent then parent.child=parent.child+elapsed end
    local row=state.rows[label]or {calls=0,total=0,self=0,max=0,errors=0};state.rows[label]=row
    row.calls=row.calls+1;row.total=row.total+elapsed;row.self=row.self+math.max(0,elapsed-node.child);row.max=math.max(row.max,elapsed)
    if not result[1]then row.errors=row.errors+1;error(result[2],0)end
    return unpack(result,2,result.n)
end
function app.stopPerformanceCapture()
    local s=app.performanceCapture;if not s or not s.active then return false end
    s.active=false
    for _,entry in ipairs(s.hooks)do
        if entry.frame then
            if entry.frame:GetScript(entry.key)==entry.wrapper then setScript(entry.frame,entry.key,entry.original)end
        elseif app[entry.key]==entry.wrapper then app[entry.key]=entry.original end
    end
    say('CPU capture finished. /cdj perf show exports it.','CPU-Aufnahme beendet. /cdj perf show zeigt den Bericht.')
    return true
end
function app.startPerformanceCapture()
    app.stopPerformanceCapture()
    local s={active=true,rows={},events={},hooks={},elapsed=0,frames=0};app.performanceCapture=s
    for _,key in ipairs(names)do
        local fn=app[key]
        if type(fn)=='function'then
            local label=key
            local wrapper=function(...)return measure(s,label,fn,...)end
            s.hooks[#s.hooks+1]={key=key,original=fn,wrapper=wrapper};app[key]=wrapper
        end
    end
    local frame=app.events
    if frame then
        local event=frame:GetScript('OnEvent')
        if event then
            local wrapper=function(self,name,...)
                if s.active then s.events[name]=(s.events[name]or 0)+1 end
                return measure(s,'OnEvent',event,self,name,...)
            end
            s.hooks[#s.hooks+1]={frame=frame,key='OnEvent',original=event,wrapper=wrapper};setScript(frame,'OnEvent',wrapper)
        end
        local update=frame:GetScript('OnUpdate')
        if update then
            local wrapper=function(self,delta)
                if s.active then
                    s.frames=s.frames+1;s.elapsed=s.elapsed+delta
                    if s.elapsed>=30 then app.stopPerformanceCapture()end
                end
                return measure(s,'OnUpdate',update,self,delta)
            end
            s.hooks[#s.hooks+1]={frame=frame,key='OnUpdate',original=update,wrapper=wrapper};setScript(frame,'OnUpdate',wrapper)
        end
    end
    say('CPU capture started (30s). Reproduce the AH interaction; no purchase needed.','CPU-Aufnahme gestartet (30s). AH-Ablauf wiederholen; kein Kauf nötig.')
    return true
end
function app.performanceExport()
    local s=app.performanceCapture
    if not s then return 'CraftDeja CPU capture: OFF / AUS (no capture)'end
    local info=app.__wowlua and app.__wowlua.devInfo
    local lines={'CraftDeja CPU capture: '..(s.active and 'ACTIVE'or 'STOPPED'),'Addon: '..app.release,
        'Build profile: '..tostring(info and info.profile or 'unknown'),
        string.format('Elapsed %.3fs; OnUpdate callbacks %d',s.elapsed,s.frames),
        'Opt-in instrumentation overhead included. Not a game FPS benchmark.',
        'total/self: inclusive / excluding other wrapped children; do not add inclusive totals.',
        'No character, account, chat or function arguments recorded.'}
    local labels={};for label in pairs(s.rows)do labels[#labels+1]=label end
    table.sort(labels,function(a,b)return s.rows[a].self>s.rows[b].self end)
    for _,label in ipairs(labels)do local row=s.rows[label]
        lines[#lines+1]=string.format('%s calls=%d total_ms=%.3f self_ms=%.3f max_ms=%.3f errors=%d',label,row.calls,row.total,row.self,row.max,row.errors)
    end
    labels={};for label in pairs(s.events)do labels[#labels+1]=label end;table.sort(labels)
    for _,label in ipairs(labels)do lines[#lines+1]='event '..label..'='..s.events[label]end
    return table.concat(lines,'\n')
end
function app.performanceCommand(command)
    if command=='start'then app.startPerformanceCapture()
    elseif command=='stop'then app.stopPerformanceCapture()
    elseif command=='show'then app.stopPerformanceCapture();app.showFlowLog()
    else say('/cdj perf start | stop | show (off by default)','/cdj perf start | stop | show (standardmäßig aus)')end
end
local export=app.logExport
app.logExport=function()
    local text=export()
    if app.performanceCapture then text=text..'\n\n'..app.performanceExport()end
    return text
end
