-- SPDX-License-Identifier: MIT
local _,app=...
local elapsed=0
local words={en={recipe_source_map='Show recipe source on map',recipe_source_missing='No compatible source with coordinates is recorded. Open the recipe details for its known sources.',recipe_source_reference='Reference location; check the recipe offer in game.',recipe_source_marked='Recipe source marked on the map.',recipe_source_coordinates='Use the source coordinates above.',recipe_source_learn='Learn %s at the source shown below.'},de={recipe_source_map='Rezeptquelle auf Karte zeigen',recipe_source_missing='Keine passende Rezeptquelle mit Koordinaten gespeichert. Die Rezeptdetails zeigen die bekannten Bezugsquellen.',recipe_source_reference='Referenzstandort; Rezeptangebot im Spiel pruefen.',recipe_source_marked='Rezeptquelle auf der Karte markiert.',recipe_source_coordinates='Nutze die Koordinaten der Rezeptquelle oben.',recipe_source_learn='Lerne %s bei der unten angezeigten Bezugsquelle.'}}
for lang,entries in pairs(words)do for k,v in pairs(entries)do app.words[lang][k]=v end end
local function validLocation(v)
    return type(v.map)=='number'and v.map>0 and v.map<math.huge and v.map==math.floor(v.map)
        and type(v.x)=='number'and v.x>=0 and v.x<=100
        and type(v.y)=='number'and v.y>=0 and v.y<=100
end
-- Recipe-specific sources apply to every profession. A rank trainer is not
-- evidence that it teaches a particular recipe; never substitute one here.
function app.recipeSourceTarget(recipe)
    if not recipe then return nil end
    local faction=app.playerFaction()
    local map=app.try(C_Map and C_Map.GetBestMapForUnit,'player')
    local pos=map and app.try(C_Map and C_Map.GetPlayerMapPosition,map,'player')
    local x,y
    if pos then x,y=app.try(pos.GetXY,pos);if not x then x,y=pos.x,pos.y end end
    local best,score
    for _,source in ipairs(app.sourceList(recipe))do
        local kind=source.kind
        if (kind=='trainer'or kind=='vendor'or kind=='questgiver'or kind=='object')and validLocation(source)
            and (source.side=='Both'or faction and source.side==faction)then
            local same=source.map==map
            local distance=same and type(x)=='number'and type(y)=='number'and ((source.x-x*100)^2+(source.y-y*100)^2)or 10000
            local value=(same and 0 or 100000)+distance
            if not score or value<score then best=app.copy(source);score=value end
        end
    end
    if best then best.npc=best.id;best.name=app.sourceTitle(best)end
    return best
end
function app.recipeLearningTask(recipe)
    local source=app.recipeSourceTarget(recipe)
    local key='learn:'..recipe.id
    if source then key=key..':'..tostring(source.id)..':'..source.map..':'..source.x..':'..source.y end
    return {kind='learn',key=key,recipe=recipe,sourceTarget=source,
        body=app.caption(source and 'recipe_source_learn'or 'step_learn',app.recipeName(recipe))}
end
function app.showRecipeSource(recipe)
    local source=app.recipeSourceTarget(recipe)
    if not source then
        app.showDetails(recipe,false,true)
        return false
    end
    if not WorldMapFrame then app.try(C_AddOns and C_AddOns.LoadAddOn,'Blizzard_WorldMap')end
    local marked=app.markMerchant(source)
    if WorldMapFrame then
        app.try(WorldMapFrame.Show,WorldMapFrame)
        app.try(WorldMapFrame.SetMapID,WorldMapFrame,source.map)
        app.updateMerchantMarker(1)
    end
    app.flowLog('recipe_source.mark',{recipe=recipe.id,npc=source.id,map=source.map,x=source.x,y=source.y,marked=marked})
    return marked
end
function app.setMerchantMarker(v)
    app.mapTarget={name=v.name,map=v.map,x=v.x,y=v.y,npc=v.npc}
    if app.character then app.character.mapTarget=app.copy(app.mapTarget)end
    return WorldMapFrame and type(WorldMapFrame.GetCanvas)=='function'or false
end
function app.updateMerchantMarker(delta)
    elapsed=elapsed+delta;if elapsed<.1 then return end;elapsed=0
    local v=app.mapTarget or app.character and app.character.mapTarget
    local map=WorldMapFrame
    if not v or not map or not map:IsShown()or app.try(map.GetMapID,map)~=v.map then
        if app.mapPin then app.mapPin:Hide()end;return
    end
    local canvas=app.try(map.GetCanvas,map)or map.ScrollContainer and map.ScrollContainer.Child
    if not canvas then return end
    local width,height=app.try(canvas.GetSize,canvas)
    if not width or not height or width<=0 or height<=0 then return end
    if not app.mapPin then
        local pin=CreateFrame('Button',nil,canvas);app.mapPin=pin;pin:SetSize(56,63)
        pin.logo=pin:CreateTexture(nil,'ARTWORK');pin.logo:SetAllPoints();pin.logo:SetTexture(app.uiPath('MapLogo'))
        pin.name=pin:CreateFontString(nil,'OVERLAY');pin.name:SetFont(STANDARD_TEXT_FONT or 'Fonts\\FRIZQT__.TTF',11,'OUTLINE')
        pin.name:SetPoint('BOTTOM',pin,'TOP',0,1);pin.name:SetText('CraftDeja');pin.name:SetTextColor(1,.95,.76)
        pin:SetScript('OnEnter',function(self)
            app.showTip(self,'CraftDeja - '..self.target.name,{app.merchantLocation(self.target),app.caption('map_pin_hint')})
        end);pin:SetScript('OnLeave',app.hideTip)
        pin:SetScript('OnClick',function()
            if app.try(IsControlKeyDown)then
                app.mapTarget=nil;if app.character then app.character.mapTarget=nil end;pin:Hide()
            end
        end)
    end
    local pin=app.mapPin;pin.target=v
    app.try(pin.SetParent,pin,canvas);app.try(pin.SetFrameLevel,pin,(app.try(canvas.GetFrameLevel,canvas)or 1)+1000)
    pin:ClearAllPoints();pin:SetPoint('BOTTOM',canvas,'TOPLEFT',width*v.x/100,-height*v.y/100)
    pin:Show()
end
