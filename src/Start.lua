-- SPDX-License-Identifier: MIT
-- CraftDeja 3: new implementation, requirements-driven profession adviser.
local identifier,app=...
_G.CraftDeja=app
app.identifier=identifier
app.release="3.9.0-beta.14"
app.sessions={}
app.catalog={}
app.names={}
app.professionOrder={333,171,164,165,197,202,185,129,186}
app.supported={}
for _,id in ipairs(app.professionOrder)do app.supported[id]=true end
app.options={flowLogging=true,scale=0.8,language="auto",prices="auto",green=true,visible=true,unverifiedSources=false,shoppingPoints=5,shoppingGoal="next",shoppingTolerance=10,guideSeenV1=false,inventoryAlts=false}

function app.try(callback,...)
    if type(callback)~="function"then return nil end
    local ok,a,b,c,d,e,f,g,h,i,j,k,l=pcall(callback,...)
    if ok then return a,b,c,d,e,f,g,h,i,j,k,l end
end
function app.copy(input)
    local result={}
    for k,v in pairs(input or {})do result[k]=v end
    return result
end
function app.initialize()
    if type(CraftDejaDB)~="table"then CraftDejaDB={}end
    local saved=CraftDejaDB
    saved.options=type(saved.options)=="table"and saved.options or {}
    for key,value in pairs(app.options)do if saved.options[key]==nil then saved.options[key]=value end end
    saved.characters=type(saved.characters)=="table"and saved.characters or {}
    local character=app.try(UnitGUID,"player")or "local"
    saved.characters[character]=saved.characters[character]or {vendor={},seen={},transitions={}}
    app.saved=saved;app.options=saved.options;app.character=saved.characters[character];app.characterKey=character
    app.character.vendor=app.character.vendor or {};app.character.seen=app.character.seen or {};app.character.transitions=app.character.transitions or {}
end
function app.lang()
    if app.options.language=="de"or app.options.language=="en"then return app.options.language end
    return app.try(GetLocale)=="deDE"and "de"or "en"
end
function app.caption(key,...)
    local language=app.lang()
    local text=(app.words[language]or {})[key]or app.words.en[key]or key
    if select('#',...)>0 then text=string.format(text,...)end
    return app.uiText and app.uiText(text)or text
end
function app.recipeName(recipe)
    local gameLanguage=app.try(GetLocale)=="deDE"and "de"or "en"
    if recipe.liveName and app.lang()==gameLanguage then return recipe.liveName end
    local name=(app.names[app.lang()]or {})[recipe.id]
    return name or recipe.liveName or app.caption("recipe_number",recipe.id)
end
function app.money(value)
    if type(value)~="number"then return app.caption("missing_price")end
    if value<0 then return '-'..app.money(-value)end
    if value>0 and value<1 then return '<1c'end
    local n=math.floor(value+0.5)
    if n>=10000 then return string.format("%dg %ds %dc",math.floor(n/10000),math.floor(n/100)%100,n%100)end
    if n>=100 then return string.format("%ds %dc",math.floor(n/100),n%100)end
    return n.."c"
end
function app.professionName(id)
    return (app.professionLabels[app.lang()]or app.professionLabels.en)[id]or tostring(id or "?")
end
function app.origin(recipe)
    local labels={}
    for _,kind in ipairs(recipe.sources or {})do labels[#labels+1]=app.caption("origin_"..kind)end
    if #labels==0 then labels[1]=app.caption("unknown")end
    local text=table.concat(labels,", ")
    if recipe.sourceUnconfirmed then text=text.." "..app.caption("unconfirmed_short")end
    return text
end
function app.url(id)return "https://www.wowhead.com/forever/"..(app.lang()=="de"and "de/"or "").."spell="..tostring(id)end
