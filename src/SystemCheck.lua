-- SPDX-License-Identifier: MIT
-- Observes real client actions; never opens professions, purchases or crafts.
local _,app=...
local function de()return app.options.language=='de'or app.options.language=='auto'and app.try(GetLocale)=='deDE'end
local function tr(a,b)return de()and b or a end
local steps={
 {'open','Open a profession and wait for its recipes.','Öffne einen Beruf und warte auf seine Rezepte.'},
 {'close','Close the profession. Only the guide should remain.','Schließe den Beruf. Nur der Guide soll bleiben.'},
 {'reopen','Open the same profession again.','Öffne denselben Beruf erneut.'},
 {'switch','Switch to a different profession and wait for its recipes.','Wechsle zu einem anderen Beruf und warte auf seine Rezepte.'},
 {'pages','Visit Settings, Recipe catalogue and Recipe details. Return here.','Öffne Einstellungen, Rezeptkatalog und Rezeptdetails. Kehre hierher zurück.'},
 {'stock','Open Poisons in refill mode with a positive stock target.','Öffne Gifte im Auffüllmodus mit einem positiven Vorratsziel.'},
 {'vendor','Visit a poison vendor. The guide must appear.','Sprich einen Giftverkäufer an. Der Guide muss erscheinen.'},
 {'return','Close the vendor and guide, then visit the vendor again.','Schließe Händler und Guide, dann sprich den Händler erneut an.'},
 {'scan','Open the AH and let a current scan finish.','Öffne das AH und lasse einen aktuellen Scan abschließen.'},
 {'quantity','Prepare an AH purchase through the guide; verify its quantity. No test purchase is required.','Bereite einen AH-Kauf über den Guide vor. Ein Testkauf ist nicht nötig.'},
 {'mail','With confirmed purchases outstanding, collect them from the mailbox.','Hole bestätigte ausstehende Käufe aus dem Briefkasten.'},
 {'buy','Buy needed vendor supplies through the guide, only if you need them.','Kaufe benötigte Händlerzutaten über den Guide, nur wenn du sie brauchst.'},
 {'craft','Prepare a native batch and start it yourself. Wait for a successful craft.','Bereite einen Stapel vor, starte ihn selbst und warte auf eine erfolgreiche Herstellung.'},
 {'done','Complete your real order; the order overview must show Done.','Schließe deinen echten Auftrag ab. Die Übersicht muss Fertig anzeigen.'}}
local function clock()return app.try(GetTime)or 0 end
local function saved()
 if not app.character then return end
 app.character.systemCheck=app.character.systemCheck or {rows={},evidence={},warnings={}}
 return app.character.systemCheck
end
app.words.en.system_check='System check';app.words.de.system_check='Systemcheck'
local run,seen={},{}
local function shown(f)return f and app.try(f.IsShown,f)==true end
local function snapshot()
 local g=app.nextStepWindow;return string.format('profession=%s loading=%s guide=%s page=%s task=%s',app.active and app.active.profile.id or '-',tostring(app.professionLoading==true),tostring(shown(g)),app.unifiedViewKey or 'guide',g and g.task and g.task.kind or '-')
end
local function evidence(event,fields)
 local s=saved();if not s then return end
 local parts={};for k,v in pairs(fields or {})do if type(v)=='string'or type(v)=='number'or type(v)=='boolean'then parts[#parts+1]=k..'='..tostring(v):sub(1,120):gsub('[\r\n]',' ')end end;table.sort(parts)
 s.evidence[#s.evidence+1]=string.format('%.2f %s %s | %s',clock(),event,table.concat(parts,' '),snapshot())
 if #s.evidence>180 then table.remove(s.evidence,1)end
end
local function finish(status,detail)
 local s=saved();if not s or not run.active then return end
 local row=s.rows[run.index];if row.status~='wait'then return end
 row.status=status;row.actual=detail;row.snapshot=snapshot();evidence('check.result',{step=steps[run.index][1],status=status,detail=detail})
end
function app.startSystemCheck()
 local s=saved();if not s then return end
 s.rows={};s.evidence={};s.warnings={};s.version=app.release;s.started=app.try(time)or 0
 for i,v in ipairs(steps)do s.rows[i]={id=v[1],status='untested',expected=v[2]}end
 run={active=true,index=1};app.systemCheckSelect(1)
end
function app.systemCheckSelect(index)
 local s=saved();if not s then return end
 run.active=true;run.index=math.max(1,math.min(#steps,index));seen={}
 run.at=clock();run.base=app.active and app.active.profile.id
 run.mail={};for id,v in pairs(app.character.ahMail or {})do local n=app.confirmedMail(id);if n>0 then run.mail[id]={quantity=n,bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false)or 0}end end
 local row=s.rows[run.index];row.status='wait';row.actual=nil
 evidence('check.begin',{step=row.id})
end
function app.systemCheckReport()
 local s=saved()or {rows={},warnings={},evidence={}};local lines={'CraftDeja IN-GAME SYSTEM CHECK','Addon: '..app.release,'Run version: '..tostring(s.version or '-'),'Run active: '..tostring(run.active==true),'Started: '..tostring(s.started or '-'),'No purchases or crafts are triggered by this check.','Untested/skipped steps are NOT passes.'}
 for _,row in ipairs(s.rows)do lines[#lines+1]=string.format('%s [%s]\nExpected: %s\nActual: %s\n%s',row.id,row.status,row.expected,row.actual or 'No result',row.snapshot or '')end
 lines[#lines+1]='--- Passive warnings ---';for _,w in ipairs(s.warnings)do lines[#lines+1]=w end
 lines[#lines+1]='--- Bounded test evidence ---';for _,e in ipairs(s.evidence)do lines[#lines+1]=e end
 lines[#lines+1]='--- Diagnostic log ---';lines[#lines+1]=app.logExport()
 return table.concat(lines,'\n')
end
local merchantWatch,manualClose
local oldLog=app.flowLog
app.flowLog=function(event,fields)
 oldLog(event,fields)
 if event=='click.ui'and fields and fields.role=='close'then manualClose=clock()end
 if run.active then
  if event=='ah.quantity.check'or event=='craft.native_quantity'then seen[event]=app.copy(fields)
  elseif event=='craft.native_user_start'or event=='craft.completed'or event=='poison.vendor_complete'then seen[event]=app.copy(fields)end
  if event:sub(1,6)=='click.'or event:sub(1,6)=='craft.'or event:sub(1,9)=='purchase.'or event:sub(1,3)=='ah.'or event:sub(1,7)=='poison.'then evidence(event,fields)end
  if event=='craft.client_blocked'then finish('fail','Client blocked the native action: '..tostring(fields and fields.action))end
 end
end
local originalEvent=app.events:GetScript('OnEvent')
app.events:SetScript('OnEvent',function(self,event,...)
 if event=='MERCHANT_SHOW'then merchantWatch={at=clock()}end
 if run.active then
  seen[event]=true
  if event=='TRADE_SKILL_SHOW'then seen.open=true end
  if event=='MERCHANT_SHOW'then seen.merchantAt=clock()end
  evidence('event.'..event,{})
 end
 originalEvent(self,event,...)
end)
local oldBuy=app.buyVendorMaterial
app.buyVendorMaterial=function(id,...)
 if run.active then seen.vendorBuy={id=id,bags=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false)or 0}end
 return oldBuy(id,...)
end
function app.systemCheckTick()
 local s=saved();if not s then return end
 if merchantWatch and clock()-merchantWatch.at>=.5 then
  local w=merchantWatch;merchantWatch=nil
  if app.vendorPurchase.open and app.isPoisonMerchant()and not shown(app.nextStepWindow)and not(manualClose and manualClose>=w.at)then
   local text=snapshot()..' | Poison vendor detected but guide hidden'
   s.warnings[#s.warnings+1]=text;if #s.warnings>20 then table.remove(s.warnings,1)end
   oldLog('check.warning',{reason='vendor_guide_hidden'});if run.active then finish('fail',text)end
  end
 end
 if not run.active then return end
 local row=s.rows[run.index];if not row or row.status~='wait'then return end
 local key=row.id;local g=app.nextStepWindow;local ready=app.professionOpen and not app.professionLoading and app.active and app.active.confirmed>0
 if key=='open'or key=='reopen'or key=='switch'then
  if seen.open and ready and (key~='switch'or app.active.profile.id~=run.base)and (key~='reopen'or app.active.profile.id==run.base)then
   local p=app.readProfession()
   if p and p.id==app.active.profile.id then finish(shown(g)and 'pass'or 'fail','Matching profession recipes loaded; guide visible='..tostring(shown(g)))end
  end
 elseif key=='close'and seen.TRADE_SKILL_CLOSE and not app.professionOpen then
  local extra=0;for _,f in ipairs(app.themedWindows)do if f~=g and not f.unifiedHosted and shown(f)then extra=extra+1 end end
  finish(shown(g)and extra==0 and 'pass'or 'fail','Guide visible='..tostring(shown(g))..'; extra windows='..extra)
 elseif key=='pages'then
  if app.unifiedViewKey then seen[app.unifiedViewKey]=true end
  if seen.settings and seen.catalog and seen.details then finish('pass','Settings, catalogue and details observed in shared frame')end
 elseif key=='stock'and app.isPoison()and app.character.poisons and app.character.poisons.restock then
  local any=false;for id,n in pairs(app.character.poisons.stockTargets)do if n>0 then
   any=true;local st=app.poisonStock(app.active.recipes[id]);if not st then return end
   if st.missing~=math.max(0,n-st.bags)then finish('fail','Wrong deficit for recipe '..id);return end
   evidence('stock.checked',{recipe=id,item=st.id,bags=st.bags,target=n,missing=st.missing})
  end end
  if any then finish('pass','Live output IDs and bag deficits available. Bank/alts excluded.')end
 elseif (key=='vendor'or key=='return')and (key~='return'or seen.MERCHANT_CLOSED)and seen.merchantAt and clock()-seen.merchantAt>=.5 and app.vendorPurchase.open and app.isPoisonMerchant()then
  finish(shown(g)and 'pass'or 'fail','Poison vendor detected; guide visible='..tostring(shown(g)))
 elseif key=='scan'and seen.AUCTION_HOUSE_SHOW and app.shopping.open and app.shoppingFresh()and not app.shopping.started then finish('pass','Current session prices are fresh and scan is idle')
 elseif key=='quantity'and seen['ah.quantity.check']then local v=seen['ah.quantity.check'];finish(v.ok==true and 'pass'or 'fail','Requested='..tostring(v.requested)..'; displayed='..tostring(v.displayed)..'; selected='..tostring(v.selected))
 elseif key=='mail'and seen.MAIL_SHOW and seen.BAG_UPDATE_DELAYED then
  for id,b in pairs(run.mail)do
   local n=app.try(C_Item and C_Item.GetItemCount or GetItemCount,id,false)
   if n and n>b.bags and app.confirmedMail(id)<b.quantity then finish('pass','Confirmed mail receipt and bag increase observed for item '..id);break end
  end
 elseif key=='buy'then
  local b=seen.vendorBuy;local n=b and app.try(C_Item and C_Item.GetItemCount or GetItemCount,b.id,false)
  if seen['poison.vendor_complete']then finish('pass','Approved poison vendor queue acknowledged by inventory')
  elseif b and n and n>b.bags and not app.vendorPurchase.pending then finish('pass','Vendor purchase acknowledged; bag stock increased')end
 elseif key=='craft'then
  local q=seen['craft.native_quantity'];local start=seen['craft.native_user_start'];local done=seen['craft.completed']
  if q and q.requested~=q.accepted then finish('fail','Native batch quantity mismatch')
  elseif q and start and done and q.recipe==start.recipe and start.recipe==done.recipe then finish('pass','Native quantity accepted, user start and successful craft observed')end
 elseif key=='done'and g and g.orderBar and g.orderBar.view and g.orderBar.view.finished then finish('pass','Existing order overview reports completion')end
 if app.systemCheckWindow and app.unifiedView==app.systemCheckWindow then app.renderSystemCheck()end
end
local originalUpdate=app.events:GetScript('OnUpdate');local elapsed=0
app.events:SetScript('OnUpdate',function(self,delta)
 originalUpdate(self,delta);elapsed=elapsed+delta
 if elapsed>=.25 then elapsed=0;app.systemCheckTick()end
end)
function app.renderSystemCheck()
 local f=app.systemCheckWindow;if not f or f.exporting then return end
 local s=saved();local row=s and s.rows[run.index or 1]
 f.title:SetText(tr('System check','Systemcheck'))
 local colours={pass={.4,1,.55},fail={1,.35,.3},wait={1,.85,.35},skip={.65,.65,.7},untested={.65,.65,.7}}
 f.instruction:SetTextColor(unpack(colours[row and row.status or 'untested']or colours.untested))
 local labels={pass=tr('PASSED','BESTANDEN'),fail=tr('ERROR','FEHLER'),wait=tr('WAITING FOR YOUR ACTION','WARTET AUF DEINE AKTION'),untested=tr('NOT TESTED','NICHT GEPRÜFT'),skip=tr('SKIPPED — NOT TESTED','ÜBERSPRUNGEN — NICHT GEPRÜFT')}
 f.instruction:SetText(row and ((run.index or 1)..' / '..#steps..' — '..(labels[row.status]or row.status)..'\n\n'..steps[run.index or 1][de()and 3 or 2]..'\n\n'..(row.actual or '')..(not run.active and '\n[Stopped / Beendet]'or ''))or tr('Start a guided check. All purchases and crafts remain your decision.','Starte einen geführten Test. Käufe und Crafts bleiben deine Entscheidung.'))
 local lines={};for _,v in ipairs(s and s.rows or {})do lines[#lines+1]=v.id..': '..(labels[v.status]or v.status)end
 f.results:SetText(table.concat(lines,'\n'));f.results:SetHeight(math.max(200,#lines*16))
 f.start:SetText(tr('Start new test','Neuen Test starten'));f.next:SetText(tr('Next step','Nächster Schritt'));f.skip:SetText(tr('Skip / unavailable','Überspringen / fehlt'));f.retry:SetText(tr('Retry step','Schritt wiederholen'));f.stop:SetText(tr('Stop','Beenden'));f.copy:SetText(tr('Copy report','Bericht kopieren'))
 if row and (row.status=='pass'or row.status=='fail'or row.status=='skip')and run.index<#steps then f.next:Enable()else f.next:Disable()end
end
function app.showSystemCheck()
 if not app.systemCheckWindow then
  local f=app.createWindow('CraftDejaSystemCheck',600,610);app.systemCheckWindow=f
  f.instruction=app.createLabel(f,12,24,-58,552);f.instruction:SetHeight(145)
  local scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');scroll:SetPoint('TOPLEFT',24,-210);scroll:SetSize(528,255)
  f.results=CreateFrame('EditBox',nil,scroll);f.results:SetMultiLine(true);f.results:SetAutoFocus(false);f.results:SetWidth(510);f.results:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',11,'');scroll:SetScrollChild(f.results)
  f.start=app.createButton(f,24,-480,176,'',function()f.exporting=false;app.startSystemCheck();app.renderSystemCheck()end)
  f.retry=app.createButton(f,210,-480,176,'',function()f.exporting=false;if run.index then app.systemCheckSelect(run.index)end;app.renderSystemCheck()end)
  f.skip=app.createButton(f,396,-480,180,'',function()f.exporting=false;if run.active then finish('skip','User skipped / prerequisite unavailable')end;app.renderSystemCheck()end)
  f.stop=app.createButton(f,24,-524,176,'',function()f.exporting=false;run.active=false;app.renderSystemCheck()end)
  f.copy=app.createButton(f,210,-524,176,'',function()f.exporting=true;f.results:SetText(app.systemCheckReport());f.results:SetHeight(math.max(255,app.try(f.results.GetStringHeight,f.results)or 12000));f.results:SetFocus();f.results:HighlightText()end)
  f.next=app.createButton(f,396,-524,180,'',function()f.exporting=false;if run.index and run.index<#steps then app.systemCheckSelect(run.index+1)end;app.renderSystemCheck()end)
 end
 app.systemCheckWindow.exporting=false;app.renderSystemCheck();app.mountGuidePage(app.systemCheckWindow,'systemcheck')
end
local oldCommand=app.command
app.command=function(message)
 if (message or ''):match('^%s*check%s*$')then app.showSystemCheck()else oldCommand(message)end
end
