-- SPDX-License-Identifier: MIT
local _,app=...
function app.uiPath(name)return 'Interface\\AddOns\\'..app.identifier..'\\Art\\'..name..'.tga'end
function app.uiText(value)
    local s=tostring(value or '')
    for bad,good in pairs({['→']='->',['↔']='<->',['−']='-',['–']='-',['—']='-',['✓']='+',['‹']='<',['›']='>',['×']='x'})do s=s:gsub(bad,good)end
    return s
end
function app.showTip(owner,title,lines)
    if not GameTooltip then return end
    app.try(GameTooltip.SetOwner,GameTooltip,owner,'ANCHOR_RIGHT')
    app.try(GameTooltip.SetText,GameTooltip,app.uiText(title),1,.87,.56)
    for _,line in ipairs(lines or {})do app.try(GameTooltip.AddLine,GameTooltip,app.uiText(line),.93,.9,.96,true)end
    app.try(GameTooltip.Show,GameTooltip)
end
function app.hideTip()if GameTooltip then app.try(GameTooltip.Hide,GameTooltip)end end
local roles={poison_mode_stock='refresh',poison_mode_extra='hammer',poison_stock_apply='check',poison_title='bag',poison_apply='check',poison_cancel='close',poison_shop='bag',poison_craft='hammer',poison_vendor='merchant',compact_search='coin',recipes='book',recipe_page='book',materials='bag',settings='gear',shop_button='coin',shop_search='coin',shop_sent='check',
 guide_button='help',guide_back='hammer',guide_start='check',current_link='link',next_link='link',link='link',craft_page='hammer',
 source_page='merchant',merchant_button='merchant',merchant_pin='map',inventory_alts_count='alts',inventory_alts_show='alts',
 shop_limit='coin',shop_unlock='unlock',previous='prev',forward='next',calculate='check',language='language',prices='coin',
 green_toggle='green',unknown_toggle='filter',reload='refresh',reset_position='center',only_useful='filter',own_faction='alts',all_factions='alts'}
local function roleFor(value)
    if value=='-'then return 'minus'elseif value=='+'then return 'plus'elseif value=='x'then return 'close'
    elseif value=='<'then return 'prev'elseif value=='>'then return 'next'end
    for key,role in pairs(roles)do
        if not key:find('%%')and not(key=='source_page'or key=='shop_limit')then
            local label=app.caption(key)
            if #label>0 and value:sub(1,#label)==label then return role end
        end
    end
    return 'info'
end
function app.styleButton(b,role,iconOnly)
    b.role=role or b.role or 'info';b.iconOnly=iconOnly or b:GetWidth()<45
    if b.icon then b.icon:SetTexture(app.uiPath('Icon_'..b.role))end
    app.try(b.SetNormalTexture,b,app.uiPath('Button_'..b.role))
    if b.label then if b.iconOnly then b.label:Hide()else b.label:Show()end end
end
-- Guide CTA colours describe priority, independently of the action's icon.
function app.styleCTAButton(b,primary)
    b.ctaPriority=primary and 'primary'or 'secondary'
    local enabled=b:IsEnabled()
    local fill=primary and enabled and {.055,.32,.16,1}or {.105,.10,.14,1}
    local border=primary and enabled and {.35,1,.60,1}or {.42,.40,.48,1}
    for _,kind in ipairs({'Normal','Pushed','Highlight','Disabled'})do
        local setter=b['Set'..kind..'Texture'];local getter=b['Get'..kind..'Texture']
        app.try(setter,b,'Interface\\Buttons\\WHITE8X8')
        local texture=app.try(getter,b)
        if texture then
            local c=kind=='Disabled'and {.10,.10,.12,.8}or kind=='Highlight'and {.16,.30,.22,.35}or fill
            app.try(texture.SetColorTexture,texture,unpack(c))
        end
    end
    if not b.ctaBorder then
        b.ctaBorder=CreateFrame('Frame',nil,b);b.ctaBorder:SetAllPoints(b)
        b.ctaBorder:EnableMouse(false)
        b.ctaBorder.edges={}
        for _,side in ipairs({'TOP','BOTTOM','LEFT','RIGHT'})do
            local edge=b.ctaBorder:CreateTexture(nil,'OVERLAY');b.ctaBorder.edges[#b.ctaBorder.edges+1]=edge
            if side=='TOP'or side=='BOTTOM'then
                edge:SetPoint(side..'LEFT');edge:SetPoint(side..'RIGHT');edge:SetHeight(2)
            else edge:SetPoint('TOP'..side);edge:SetPoint('BOTTOM'..side);edge:SetWidth(2)end
        end
    end
    b.ctaBorderColor=border
    for _,edge in ipairs(b.ctaBorder.edges)do edge:SetColorTexture(unpack(border))end
    b:SetHeight(primary and 42 or 22)
    if b.label then
        b.label:ClearAllPoints()
        if primary then b.label:SetPoint('CENTER');b.label:SetWidth(b:GetWidth()-20)
        else b.label:SetPoint('LEFT',26,0);b.label:SetWidth(b:GetWidth()-31)end
        b.label:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',primary and 14 or 10,primary and 'OUTLINE'or '')
        b.label:SetTextColor(unpack(primary and enabled and {.94,1,.96,1}or {.7,.68,.76,1}))
    end
    if b.icon then
        if primary then b.icon:Hide()else b.icon:Show()end
        b.icon:SetSize(primary and 23 or 14,primary and 23 or 14)
        b.icon:SetAlpha(primary and enabled and 1 or .55)
        app.try(b.icon.SetDesaturated,b.icon,true)
    end
end
function app.createButton(parent,x,y,w,label,click)
    local b=CreateFrame('Button',nil,parent);b:SetSize(w,28);b:SetPoint('TOPLEFT',x,y)
    app.try(b.SetNormalTexture,b,app.uiPath('Button'));app.try(b.SetPushedTexture,b,app.uiPath('ButtonDown'))
    app.try(b.SetHighlightTexture,b,app.uiPath('ButtonGlow'),'ADD');app.try(b.SetDisabledTexture,b,app.uiPath('ButtonDisabled'))
    b.icon=b:CreateTexture(nil,'OVERLAY',nil,5);b.icon:SetSize(22,22);b.icon:SetPoint('LEFT',7,0)
    b.label=b:CreateFontString(nil,'OVERLAY');b.label:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',10,'')
    b.label:SetPoint('LEFT',33,0);b.label:SetWidth(math.max(1,w-39));b.label:SetJustifyH('CENTER');b.label:SetTextColor(1,.9,.68)
    app.try(b.SetFontString,b,b.label)
    local nativeSet=b.SetText
    b.SetText=function(self,value)
        local clean=app.uiText(value);nativeSet(self,clean)
        if self.role==nil or not self.fixedRole then self.role=roleFor(clean)end
        app.try(self.SetNormalTexture,self,app.uiPath('Button_'..(self.role or 'info')))
        if not self.itemIcon then self.icon:SetTexture(app.uiPath('Icon_'..(self.role or 'info')))end
        if self.iconOnly or w<45 then self.label:Hide();self.icon:ClearAllPoints();self.icon:SetPoint('CENTER')end
    end
    b:SetText(label);b:SetScript('OnClick',function(self,...)
        app.flowLog('click.ui',{role=b.role,text=b:GetText()})
        if click then return click(self,...)end
    end)
    -- Native normal/disabled button textures are backgrounds, never icon covers.
    for _,getter in ipairs({'GetNormalTexture','GetPushedTexture','GetDisabledTexture'})do
        local tex=app.try(b[getter],b);if tex then app.try(tex.SetDrawLayer,tex,'BACKGROUND',-5)end
    end
    local nativeEnable,nativeDisable=b.Enable,b.Disable
    b.Enable=function(self)nativeEnable(self);self.icon:SetAlpha(1);app.try(self.icon.SetDesaturated,self.icon,false)end
    b.Disable=function(self)nativeDisable(self);self.icon:SetAlpha(.4);app.try(self.icon.SetDesaturated,self.icon,true)end
    b:SetScript('OnEnter',function(self)
        local lines=self.tipLines and self.tipLines()or {app.caption('hint_'..(self.role or 'info'))}
        app.showTip(self,self:GetText(),lines)
    end)
    b:SetScript('OnLeave',app.hideTip)
    return b
end

-- Ignore zero/empty icon IDs, try both client API generations, and always show
-- a real question-mark texture while uncached item data is loading.
function app.itemIcon(id)
    local function valid(v)return type(v)=='number'and v>0 or type(v)=='string'and v~=''end
    local icon=app.try(C_Item and C_Item.GetItemIconByID,id)
    if not valid(icon)then icon=app.try(GetItemIcon,id)end
    if not valid(icon)then
        local _,_,_,_,tex=app.try(C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant,id);icon=tex
    end
    if not valid(icon)then
        local _,_,_,_,_,_,_,_,_,tex=app.try(C_Item and C_Item.GetItemInfo or GetItemInfo,id);icon=tex
    end
    return valid(icon)and icon or 'Interface\\Icons\\INV_Misc_QuestionMark'
end
function app.addScaleGrip(f,name)
    local grip=CreateFrame('Button',nil,f);f.scaleGrip=grip
    grip:SetSize(18,18);grip:SetPoint('BOTTOMRIGHT',-1,1)
    local tex=grip:CreateTexture(nil,'OVERLAY',nil,7);tex:SetAllPoints();tex:SetTexture(app.uiPath('Resize'))
    grip:SetScript('OnEnter',function()app.showTip(grip,app.caption('resize_title'),{app.caption('resize_help')})end)
    grip:SetScript('OnLeave',app.hideTip)
    local function stop()
        local drag=grip.drag;grip.drag=nil
        if drag and (name=='CraftDejaWindow'or name=='CraftDejaNextStep')then local a,_,b,x,y=f:GetPoint();if name=='CraftDejaNextStep'then app.options.guidePosition={a,b,x,y}else app.options.position={a,b,x,y}end end
    end
    grip:SetScript('OnMouseDown',function(_,which)
        if which~='LeftButton'then return end
        local x,y=app.try(GetCursorPosition);if not x or not y then return end
        local scale=app.try(f.GetScale,f)or app.options.scale
        local effective=app.try(f.GetEffectiveScale,f)or scale
        grip.drag={x=x,y=y,scale=scale,w=f:GetWidth()*effective,h=(app.try(f.GetHeight,f)or 300)*effective,
            left=app.try(f.GetLeft,f),top=app.try(f.GetTop,f),effective=effective}
    end)
    grip:SetScript('OnMouseUp',stop);grip:SetScript('OnHide',stop)
    grip:SetScript('OnUpdate',function()
        local d=grip.drag;if not d then return end
        if type(IsMouseButtonDown)=='function'and not IsMouseButtonDown('LeftButton')then stop();return end
        local x,y=app.try(GetCursorPosition);if not x or not y then return end
        local ratio=1+((x-d.x)*d.w-(y-d.y)*d.h)/(d.w*d.w+d.h*d.h)
        local scale=math.max(.5,math.min(1.4,d.scale*ratio))
        f:SetScale(scale);app.options.windowScales=app.options.windowScales or {};app.options.windowScales[name]=scale
        if d.left and d.top then
            local effective=d.effective*scale/d.scale
            f:ClearAllPoints();f:SetPoint('TOPLEFT',UIParent,'BOTTOMLEFT',d.left*d.effective/effective,d.top*d.effective/effective)
        end
        if f==app.main then f.scale:SetText(math.floor(scale*100+.5)..'%')end
    end)
end
