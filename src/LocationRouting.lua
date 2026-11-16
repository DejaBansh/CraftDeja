-- SPDX-License-Identifier: MIT
local _,app=...
local function finite(n)return type(n)=='number'and n==n and math.abs(n)<math.huge end
local function xy(p)
    if not p then return end
    local x,y=app.try(p.GetXY,p)
    if not x then x,y=p.x,p.y end
    if finite(x)and finite(y)then return x,y end
end
local function world(map,x,y)
    if not map or not finite(x)or not finite(y)or x<0 or x>1 or y<0 or y>1 then return end
    local point=app.try(CreateVector2D,x,y)or {x=x,y=y}
    local continent,p=app.try(C_Map and C_Map.GetWorldPosFromMapPos,map,point)
    local wx,wy=xy(p)
    if finite(continent)and wx and wy then return continent,wx,wy end
end
function app.locationContext()
    local map=app.try(C_Map and C_Map.GetBestMapForUnit,'player')
    local x,y=xy(map and app.try(C_Map and C_Map.GetPlayerMapPosition,map,'player'))
    if x and (x<0 or x>1 or y<0 or y>1)then x,y=nil,nil end
    local continent,wx,wy=world(map,x,y)
    return {map=map,x=x,y=y,continent=continent,wx=wx,wy=wy}
end
function app.validLocation(row)
    return type(row.map)=='number'and row.map>0 and row.map<math.huge and row.map==math.floor(row.map)
        and finite(row.x)and row.x>=0 and row.x<=100 and finite(row.y)and row.y>=0 and row.y<=100
end
-- World coordinates are comparable only on the same world/continent. Without
-- that proof prefer the current map; percentages on different maps are not yards.
function app.locationScore(row,c)
    if not app.validLocation(row)then return 4,0 end
    if c.continent then
        local continent,x,y=world(row.map,row.x/100,row.y/100)
        if continent==c.continent and x and y then return 0,(x-c.wx)^2+(y-c.wy)^2 end
    end
    if row.map==c.map then
        if c.x and c.y then return 1,(row.x-c.x*100)^2+(row.y-c.y*100)^2 end
        return 1,30000
    end
    return 3,0
end
function app.locationBefore(a,b,c)
    local ar,ad=app.locationScore(a,c);local br,bd=app.locationScore(b,c)
    if ar~=br then return ar<br end
    if ad~=bd then return ad<bd end
    local ai,bi=a.id or a.npc or 0,b.id or b.npc or 0
    if ai~=bi then return ai<bi end
    if (a.map or 0)~=(b.map or 0)then return(a.map or 0)<(b.map or 0)end
    if (a.x or 0)~=(b.x or 0)then return(a.x or 0)<(b.x or 0)end
    return(a.y or 0)<(b.y or 0)
end
