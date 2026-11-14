-- SPDX-License-Identifier: MIT
local _,app=...
app.professionThemes={[40]=true,[171]=true,[333]=true,[164]=true,[165]=true,[197]=true,[202]=true,[185]=true,[129]=true,[186]=true}
app.themedWindows={}
function app.applyProfessionTheme(f,profession)
    if not f then return end
    if f.unifiedHosted then
        f:SetBackdrop(nil);if f.themeHeader then f.themeHeader:Hide()end
        return
    end
    local id=app.professionThemes[profession]and profession or 0
    if f.themeProfession~=id then
        f.themeProfession=id
        f:SetBackdrop({bgFile=app.uiPath(id~=0 and ('Profession_'..id)or 'Window')})
        if not f.themeHeader then f.themeHeader=f:CreateTexture(nil,'BACKGROUND',nil,7)end
        f.themeHeader:SetColorTexture(.07,.035,.12,1)
    end
    if id~=0 then
        f.themeHeader:ClearAllPoints();f.themeHeader:SetPoint('TOPLEFT',14,-10)
        f.themeHeader:SetSize(math.max(1,f:GetWidth()-28),math.max(68,f:GetHeight()*.15));f.themeHeader:Show()
    elseif f.themeHeader then f.themeHeader:Hide()end
end
function app.registerThemedWindow(f)
    app.themedWindows[#app.themedWindows+1]=f
    app.applyProfessionTheme(f,app.active and app.active.profile.id)
end
function app.refreshProfessionThemes()
    local id=app.active and app.active.profile.id
    for _,f in ipairs(app.themedWindows)do app.applyProfessionTheme(f,f.professionTheme or (f==app.catalogWindow and f.profession or id))end
end
