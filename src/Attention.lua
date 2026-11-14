-- SPDX-License-Identifier: MIT
local _,app=...
local critical={station=true,mail=true,vendor=true,bank=true,alt=true,learn=true,rank=true,craft_native=true,ah_confirm=true}
function app.taskAttention(f,task,bodyY,bodyHeight)
    if not f.attention then
        f.attention=f:CreateTexture(nil,'BACKGROUND',nil,3);f.attention:SetTexture(app.uiPath('Card'))
        f.alertTitle=app.createLabel(f,11,18,0,324,{1,.82,.38})
        f:SetScript('OnUpdate',function(self,delta)
            if not self.attentionActive then return end
            self.pulseElapsed=(self.pulseElapsed or 0)+delta;self.pulseTick=(self.pulseTick or 0)+delta
            if self.pulseTick<.05 then return end;self.pulseTick=0
            self.attention:SetAlpha(.52+.25*math.cos(self.pulseElapsed*math.pi*2/1.6))
        end)
    end
    f.attentionActive=critical[task.kind]or false
    f.body:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',f.attentionActive and 14 or 12,'')
    if f.attentionActive then
        f.attention:ClearAllPoints();f.attention:SetPoint('TOPLEFT',12,-bodyY+20);f.attention:SetSize(336,bodyHeight+28)
        f.attention:Show();f.alertTitle:ClearAllPoints();f.alertTitle:SetPoint('TOPLEFT',18,-bodyY+16)
        f.alertTitle:SetText(app.caption('task_important'));f.alertTitle:Show();f.body:SetTextColor(1,.9,.58)
    else f.attention:Hide();f.alertTitle:Hide();f.body:SetTextColor(.9,.87,.94)end
end
function app.isImportantTask(task)return critical[task.kind]or false end
function app.hideNativeCue()
    if app.nativeCue then app.nativeCue:Hide()end
end
function app.updateNativeCue(task,plan)
    if app.try(UnitCastingInfo,'player')or app.try(UnitChannelInfo,'player')then app.hideNativeCue();return end
    if not plan or not app.professionOpen or (task.kind~='craft'and task.kind~='craft_native')then app.hideNativeCue();return end
    local page=ProfessionsFrame and ProfessionsFrame.CraftingPage;local form=page and page.SchematicForm
    local info=form and app.try(form.GetRecipeInfo,form)
    if not info or info.recipeID~=plan.recipe.id then app.hideNativeCue();return end
    local h=app.nativeCraftHandoff
    local count=h and h.count or task.batch
    local allCount=page and app.try(page.GetCraftableCount,page)
    local button
    if count and count>0 and allCount==count and page.CreateAllButton then button=page.CreateAllButton
    elseif h then button=h.button end
    if not button or app.try(button.IsVisible or button.IsShown,button)==false or app.try(button.IsEnabled,button)==false then app.hideNativeCue();return end
    if not app.nativeCue then
        local f=CreateFrame('Frame',nil,UIParent);app.nativeCue=f
        f:SetSize(190,74);f:SetFrameStrata('TOOLTIP');f:EnableMouse(false);f:SetClampedToScreen(true)
        f.label=app.createLabel(f,12,0,0,190,{1,.88,.48});f.label:SetJustifyH('CENTER');f.label:SetHeight(20)
        f.arrow=f:CreateTexture(nil,'OVERLAY');f.arrow:SetSize(44,44);f.arrow:SetPoint('BOTTOM',0,0);f.arrow:SetTexture(app.uiPath('ArrowDown'))
        f:SetScript('OnUpdate',function(self,delta)
            if app.try(UnitCastingInfo,'player')or app.try(UnitChannelInfo,'player')then self:Hide();return end
            if not app.professionOpen or app.try(self.target.IsVisible or self.target.IsShown,self.target)==false then self:Hide();return end
            self.elapsed=(self.elapsed or 0)+delta;self.tick=(self.tick or 0)+delta
            if self.tick<.05 then return end;self.tick=0
            self.arrow:SetAlpha(.65+.35*(.5+.5*math.cos(self.elapsed*math.pi*2/1.3)))
        end)
    end
    local f=app.nativeCue;f.target=button;f.count=count;f.isAll=button==page.CreateAllButton
    f:ClearAllPoints();f:SetPoint('BOTTOM',button,'TOP',0,5)
    f.label:SetText(app.caption('craft_cue_click',count));f:Show()
    if h then
        if h.guideButton and h.guideButton~=button then app.try(h.guideButton.UnlockHighlight,h.guideButton)end
        if h.button~=button then app.try(h.button.UnlockHighlight,h.button)end
        h.guideButton=button;app.try(button.LockHighlight,button)
    end
end
