-- SPDX-License-Identifier: MIT
local _,app=...
local words={de={launcher_open='CraftDeja öffnen',launcher_settings='CraftDeja einstellen',launcher_tip='Linksklick: öffnen · Rechtsklick: Einstellungen · Ziehen: verschieben',launcher_minimap='Minimap-Button anzeigen'},en={launcher_open='Open CraftDeja',launcher_settings='CraftDeja settings',launcher_tip='Left-click: open · Right-click: settings · Drag: move',launcher_minimap='Show minimap button'}}
for lang,t in pairs(words)do for k,v in pairs(t)do app.words[lang][k]=v end end
function app.openFromLauncher()
    app.options.visible=true;app.showCentralGuide()
end
local function positionButton()
    local f=app.minimapButton;if not f then return end
    local angle=tonumber(app.options.minimapAngle)or 225
    if angle~=angle or math.abs(angle)==math.huge then angle=225 end
    angle=angle%360;app.options.minimapAngle=angle
    local radius=math.max(Minimap:GetWidth(),Minimap:GetHeight())/2+8
    local x,y=math.cos(math.rad(angle))*radius,math.sin(math.rad(angle))*radius
    if app.try(GetMinimapShape)and app.try(GetMinimapShape)~='ROUND'then
        local scale=math.max(math.abs(math.cos(math.rad(angle))),math.abs(math.sin(math.rad(angle))))
        x=x/scale;y=y/scale
    end
    f:ClearAllPoints();f:SetPoint('CENTER',Minimap,'CENTER',x,y)
end
function app.renderLauncher()
    local f=app.minimapButton
    if f then positionButton();f:SetShown(app.options.minimapHidden~=true)end
    local panel=app.addonSettingsPanel
    if panel then
        panel.open:SetText(app.caption('launcher_open'));panel.settings:SetText(app.caption('launcher_settings'))
        panel.merchant:SetText(app.caption('merchant_auto')..': '..app.caption(app.options.autoOpenMerchant~=false and 'enabled'or 'disabled'))
        panel.minimap:SetText(app.caption('launcher_minimap')..': '..app.caption(app.options.minimapHidden~=true and 'enabled'or 'disabled'))
    end
end
local function closeSettings()
    if SettingsPanel then app.try(SettingsPanel.Hide,SettingsPanel)end
    if InterfaceOptionsFrame then app.try(InterfaceOptionsFrame.Hide,InterfaceOptionsFrame)end
end
function app.registerAddonSettings()
    if app.addonSettingsRegistered then return end
    local panel=app.addonSettingsPanel
    if not panel then
        panel=CreateFrame('Frame','CraftDejaAddonSettings',UIParent);panel.name='CraftDeja';panel:Hide();app.addonSettingsPanel=panel
        local title=app.createLabel(panel,22,20,-20,500);title:SetText('CraftDeja')
        panel.open=app.createButton(panel,20,-75,410,'',function()closeSettings();app.openFromLauncher()end)
        panel.settings=app.createButton(panel,20,-120,410,'',function()closeSettings();app.showOptions()end)
        panel.merchant=app.createButton(panel,20,-180,550,'',function()app.options.autoOpenMerchant=not(app.options.autoOpenMerchant~=false);app.renderLauncher();app.renderOptions()end)
        panel.minimap=app.createButton(panel,20,-225,550,'',function()app.options.minimapHidden=not app.options.minimapHidden;app.renderLauncher()end)
        panel:SetScript('OnShow',app.renderLauncher)
    end
    if Settings and type(Settings.RegisterCanvasLayoutCategory)=='function'and type(Settings.RegisterAddOnCategory)=='function'then
        local category=Settings.RegisterCanvasLayoutCategory(panel,'CraftDeja')
        if category then Settings.RegisterAddOnCategory(category);app.addonSettingsCategory=category;app.addonSettingsRegistered=true end
    elseif type(InterfaceOptions_AddCategory)=='function'then
        InterfaceOptions_AddCategory(panel);app.addonSettingsRegistered=true
    end
    app.renderLauncher()
end
local function nativeShown()
    if not app.saved then return end
    -- OnShow can occur without TRADE_SKILL_SHOW (panel replacements/reopening
    -- an already selected profession). Restore only UI here, not a full scan.
    app.openFromLauncher()
end
function app.bindProfessionVisibility()
    for _,name in ipairs({'ProfessionsFrame','TradeSkillFrame','CraftFrame'})do
        local f=_G[name]
        if f and type(f.HookScript)=='function'and not f.craftDejaVisibilityHook then
            f.craftDejaVisibilityHook=true;f:HookScript('OnShow',nativeShown)
        end
    end
    if C_TradeSkillUI and type(C_TradeSkillUI.OpenTradeSkill)=='function'and not app.professionOpenHook and type(hooksecurefunc)=='function'then
        app.professionOpenHook=true
        hooksecurefunc(C_TradeSkillUI,'OpenTradeSkill',function()
            -- An explicit second profession click may leave the native panel
            -- shown, generating neither OnShow nor TRADE_SKILL_SHOW.
            if app.nativeProfessionVisible()==true then nativeShown()end
        end)
    end
end
function app.setupLauncher()
    if Minimap and not app.minimapButton then
        local f=CreateFrame('Button','CraftDejaMinimapButton',Minimap);app.minimapButton=f
        f:SetSize(32,32);f:SetFrameStrata('MEDIUM');f:SetFrameLevel(Minimap:GetFrameLevel()+8)
        f:SetNormalTexture(app.uiPath('Logo'));f:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
        f:RegisterForClicks('LeftButtonUp','RightButtonUp');f:RegisterForDrag('LeftButton')
        f:SetScript('OnClick',function(_,button)if f.dragEndedAt and (app.try(GetTime)or 0)-f.dragEndedAt<.1 then return end;if button=='RightButton'then app.showOptions()else app.openFromLauncher()end end)
        f:SetScript('OnEnter',function(self)app.showTip(self,'CraftDeja',{app.caption('launcher_tip')})end);f:SetScript('OnLeave',app.hideTip)
        local function move()
            local x,y=app.try(GetCursorPosition);local cx,cy=Minimap:GetCenter()
            if not x or not y or not cx or not cy then return end
            local scale=Minimap:GetEffectiveScale();local atan=math.atan2 or atan2
            if not atan then return end
            app.options.minimapAngle=math.deg(atan(y/scale-cy,x/scale-cx));positionButton()
        end
        f:SetScript('OnDragStart',function()app.hideTip();f:SetScript('OnUpdate',move)end)
        f:SetScript('OnDragStop',function()move();f.dragEndedAt=app.try(GetTime)or 0;f:SetScript('OnUpdate',nil)end)
        f:SetScript('OnHide',function()f:SetScript('OnUpdate',nil)end)
    end
    app.bindProfessionVisibility();app.registerAddonSettings();app.renderLauncher()
end
local initialize=app.initialize
app.initialize=function(...)initialize(...);app.setupLauncher()end
local frame=CreateFrame('Frame');frame:RegisterEvent('ADDON_LOADED')
frame:SetScript('OnEvent',function()if app.saved then app.bindProfessionVisibility();app.registerAddonSettings()end end)
