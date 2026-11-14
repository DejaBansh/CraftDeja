-- SPDX-License-Identifier: MIT
-- Observations are local evidence, never automatic edits of the shared catalogue.
local _,app=...
app.referenceData={version='2026.11.12.1',packaged='2026-11-12',reviewDays=7}
local limit=200
local words={en={audit_button='Recipe check',audit_title='Recipe data check',audit_status='Data package %s | %d unverified reports',audit_tip='Checks recipes visible in your profession window. Click to copy the report.',audit_review='Reference review recommended every %d days. No automatic internet update.',audit_empty='No differences recorded. This does not verify recipes that have not been inspected.',audit_help='Unverified client observations. Copy with Ctrl+C and post in the CurseForge comments with a short description.',audit_clear='Clear report',audit_package='Data package: %s'},de={audit_button='Rezeptcheck',audit_title='Rezeptdaten prüfen',audit_status='Datenpaket %s | %d ungeprüfte Meldungen',audit_tip='Prüft Rezepte im geöffneten Berufsfenster. Klicken, um den Bericht zu kopieren.',audit_review='Referenzprüfung alle %d Tage empfohlen. Kein automatisches Internet-Update.',audit_empty='Keine Abweichungen gespeichert. Das bestätigt keine noch nicht eingelesenen Rezepte.',audit_help='Ungeprüfte Clientbeobachtungen. Mit Strg+C kopieren und mit kurzer Beschreibung in die CurseForge-Kommentare einfügen.',audit_clear='Bericht leeren',audit_package='Datenpaket: %s'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.audit_reports_button='Check (%d)';app.words.de.audit_reports_button='Prüfen (%d)'
app.words.en.audit_status_one='Data package %s | 1 unverified report';app.words.de.audit_status_one='Datenpaket %s | 1 ungeprüfte Meldung'
app.words.en.audit_notice='CraftDeja: unverified recipe differences detected. Open /cdj data to review and copy the report.'
app.words.de.audit_notice='CraftDeja: ungeprüfte Rezeptabweichungen erkannt. Mit /cdj data den Bericht prüfen und kopieren.'
for _,lang in ipairs({'en','de'})do app.words[lang].help=(app.words[lang].help or '')..' · /cdj data'end
local function state()
    if not app.character then return nil end
    local s=app.character.recipeAudit
    if type(s)~='table'then s={entries={},order={},checks={}};app.character.recipeAudit=s end
    return s
end
function app.auditCount()
    local s=state();return s and #s.order or 0
end
function app.auditStatusText()
    local n=app.auditCount()
    return n==1 and app.caption('audit_status_one',app.referenceData.packaged)or app.caption('audit_status',app.referenceData.packaged,n)
end
-- Compare required reagent groups, independent of client enumeration order.
-- An absent/incomplete schematic is not evidence of changed ingredients.
function app.auditMaterials(groups)
    if type(groups)~='table'or #groups==0 then return nil end
    local rows,totals={},{}
    for _,g in ipairs(groups)do
        if type(g.amount)~='number'or g.amount<=0 or type(g.choices)~='table'or #g.choices==0 then return nil end
        local choices,seen={},{}
        for _,id in ipairs(g.choices)do
            if type(id)~='number'or id<=0 or id~=math.floor(id)then return nil end
            if not seen[id]then choices[#choices+1]=id;seen[id]=true end
        end
        table.sort(choices);local key=table.concat(choices,'/');totals[key]=(totals[key]or 0)+g.amount
    end
    for key,amount in pairs(totals)do rows[#rows+1]=amount..'*'..key end
    table.sort(rows);return table.concat(rows,',')
end
local function referenceMaterials(ref)
    local groups={}
    for id,amount in pairs(ref and ref.ingredients or {})do groups[#groups+1]={amount=amount,choices={id}}end
    return app.auditMaterials(groups)
end
local function remove(s,key)
    if not s.entries[key]then return end
    s.entries[key]=nil
    for i,k in ipairs(s.order)do if k==key then table.remove(s.order,i);break end end
end
function app.forgetForeignRecipeAudit(profession,recipe)
    local s=state();if not s then return end
    local prefix=profession..':'..recipe..':'
    for i=#s.order,1,-1 do local key=s.order[i]
        if key:sub(1,#prefix)==prefix then remove(s,key)end
    end
end
local function resolvedInNewPackage(s,key)
    -- A later skill/colour or a transient client refresh must not erase useful
    -- evidence before the player can report it. Only a new reference revision
    -- can automatically resolve an earlier observation.
    local old=s.entries[key]
    if old and old.package~=app.referenceData.version then remove(s,key)end
end
local function note(s,profile,r,kind,actual,expected)
    local key=profile.id..':'..r.id..':'..kind
    local old=s.entries[key]
    local signature=tostring(actual)..'|'..tostring(expected)
    local version,build,_,interface=app.try(GetBuildInfo)
    if old and old.signature==signature and old.package==app.referenceData.version and old.build==(build or '?')then return end
    local n={profession=profile.id,recipe=r.id,name=tostring(r.liveName or r.id):gsub('[\r\n]',' '):sub(1,120),kind=kind,
        actual=actual,expected=expected,signature=signature,package=app.referenceData.version,
        skill=profile.skill,cap=profile.cap,characterLevel=app.playerLevel(),learned=r.learned==true,faction=app.playerFaction()or 'Unknown',
        locale=app.try(GetLocale)or '?',client=version or '?',build=build or '?',interface=interface or '?',
        first=old and old.first or app.try(time)or 0,last=app.try(time)or 0}
    if not old then
        if #s.order>=limit then local first=table.remove(s.order,1);s.entries[first]=nil;s.dropped=(s.dropped or 0)+1 end
        s.order[#s.order+1]=key
    else
        for i,k in ipairs(s.order)do if k==key then table.remove(s.order,i);break end end
        s.order[#s.order+1]=key
    end
    s.entries[key]=n
    app.auditNew=app.auditNew or {};app.auditNew[profile.id]=true
    app.auditLogSeen=app.auditLogSeen or {}
    if app.auditLogSeen[key]~=signature then
        app.auditLogSeen[key]=signature
        app.flowLog('recipe.audit',{profession=profile.id,recipe=r.id,kind=kind,package=n.package})
    end
end
function app.auditRecipe(profile,r,ref)
    local s=state();if not s or not r.confirmed then return end
    local base=profile.id..':'..r.id..':'
    local actual=r.materialsFromClient and app.auditMaterials(r.groups)or nil
    if not ref then
        local old=s.entries[base..'unknown_recipe']
        if actual or not old or old.actual=='ingredients unavailable'then note(s,profile,r,'unknown_recipe',actual or 'ingredients unavailable','not in data package')end
    else resolvedInNewPackage(s,base..'unknown_recipe')end
    if actual and ref then
        local expected=referenceMaterials(ref)
        if expected and actual~=expected then note(s,profile,r,'ingredients',actual,expected)
        elseif expected then resolvedInNewPackage(s,base..'ingredients')end
    end
    if ref and r.learned and r.colour then
        local expected=app.band(ref,profile.skill)
        if expected and expected~=r.colour then note(s,profile,r,'difficulty',r.colour,expected)
        elseif expected then resolvedInNewPackage(s,base..'difficulty')end
    end
end
function app.auditRead(profile,confirmed)
    local s=state();if not s or confirmed<1 then return end
    s.checks[profile.id]={at=app.try(time)or 0,skill=profile.skill,cap=profile.cap,visible=confirmed,package=app.referenceData.version}
    app.auditNotified=app.auditNotified or {}
    if app.auditNew and app.auditNew[profile.id]and not app.auditNotified[profile.id]then
        app.auditNotified[profile.id]=true
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage(app.caption('audit_notice'))end
    end
    if app.auditNew then app.auditNew[profile.id]=nil end
end
function app.recipeAuditExport(maxEntries)
    local s=state()or {order={},entries={},checks={}}
    local lines={'CraftDeja recipe observations (UNVERIFIED)','Addon: '..app.release,
        'Data package: '..app.referenceData.version..' / packaged '..app.referenceData.packaged,
        'Reference sources are not all revalidated on the package date.',
        'Scope: recipes exposed by opened profession windows; this is not a complete recipe census.',
        'Review recommendation: every '..app.referenceData.reviewDays..' days and after major patches. No automatic external check.',
        'Reports: '..#s.order..' / '..limit..'; evicted: '..(s.dropped or 0),
        'Materials format: quantity*itemID; slash-separated item IDs are alternatives.',
        'No character name, account, realm or chat data included.','---'}
    local professions={};for id in pairs(s.checks)do professions[#professions+1]=id end;table.sort(professions)
    for _,id in ipairs(professions)do local c=s.checks[id]
        lines[#lines+1]=string.format('CHECK profession=%d skill=%d cap=%d visible=%d at=%s package=%s',id,c.skill,c.cap,c.visible,tostring(c.at),c.package)
    end
    local start=math.max(1,#s.order-(maxEntries or limit)+1)
    if start>1 then lines[#lines+1]='Showing latest '..maxEntries..' reports. Full report: /cdj data'end
    for i=start,#s.order do local e=s.entries[s.order[i]]
        lines[#lines+1]=string.format('\n[%s] profession=%d recipe=%d name=%s',e.kind,e.profession,e.recipe,e.name)
        lines[#lines+1]='expected='..tostring(e.expected)..' | client='..tostring(e.actual)
        lines[#lines+1]=string.format('skill=%d cap=%d characterLevel=%d learned=%s faction=%s locale=%s client=%s build=%s interface=%s',e.skill,e.cap,e.characterLevel or 0,tostring(e.learned),e.faction,e.locale,tostring(e.client),tostring(e.build),tostring(e.interface))
        lines[#lines+1]='package='..e.package..' first='..e.first..' last='..e.last
    end
    if #s.order==0 then lines[#lines+1]=app.caption('audit_empty')end
    lines[#lines+1]='\n'..app.caption('audit_help')
    return table.concat(lines,'\n')
end
function app.showRecipeAudit()
    if not app.recipeAuditWindow then
        local f=app.createWindow('CraftDejaRecipeAudit',640,450);app.recipeAuditWindow=f
        f.status=app.createLabel(f,11,18,-50,600);f.status:SetHeight(28)
        local scroll=CreateFrame('ScrollFrame',nil,f,'UIPanelScrollFrameTemplate');scroll:SetSize(580,282);scroll:SetPoint('TOPLEFT',18,-84)
        local box=CreateFrame('EditBox',nil,scroll);f.box=box;box:SetMultiLine(true);box:SetAutoFocus(false);box:SetWidth(558)
        box:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',11,'');scroll:SetScrollChild(box)
        box:SetScript('OnEscapePressed',function(self)self:ClearFocus()end)
        f.copy=app.createButton(f,18,-400,190,'',function()box:SetFocus();box:HighlightText()end)
        f.refresh=app.createButton(f,218,-400,190,'',function()app.showRecipeAudit()end)
        f.clear=app.createButton(f,418,-400,204,'',function()
            app.character.recipeAudit={entries={},order={},checks={}};app.showRecipeAudit();app.refreshUI()
        end)
    end
    local f=app.recipeAuditWindow;f.title:SetText('CraftDeja - '..app.caption('audit_title'))
    f.status:SetText(app.auditStatusText()..'\n'..app.caption('audit_review',app.referenceData.reviewDays))
    f.copy:SetText(app.caption('flow_copy'));f.refresh:SetText(app.caption('flow_refresh'));f.clear:SetText(app.caption('audit_clear'))
    f.box:SetText(app.recipeAuditExport());f.box:SetHeight(math.max(282,(app.try(f.box.GetNumLines,f.box)or 20)*14+14))
    f:Show();f.box:SetFocus();f.box:HighlightText()
end
