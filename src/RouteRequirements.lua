-- SPDX-License-Identifier: MIT
local _,app=...
local rods={[7421]=true,[7795]=true,[13628]=true,[13702]=true,[20051]=true}
function app.routePrerequisiteRecipes(session,roots)
    local needed,chains={},{}
    local function physical(r)
        return r and rods[r.id]and r.confirmed and r.materialsFromClient and r.outputFromClient
            and r.outputMin==1 and r.outputMax==1 and r.outputItemID and not r.isEnchantingRecipe
    end
    local function find(name,item)
        local found
        for id in pairs(rods)do
            local r=session.recipes[id]
            if physical(r)and (item and r.outputItemID==item or name and (r.liveName==name or r.outputName==name))then
                if found then return end;found=r
            end
        end
        return found
    end
    for id,root in pairs(roots)do
        local list,seen={},{}
        local function visit(r)
            if seen[r.id]then return end;seen[r.id]=true
            local stock=app.inventoryFor(r.outputItemID)
            if stock and stock.total and stock.total>=1 then return end
            local requirement=app.missingCraftRequirement(r,true)
            local lower=requirement and find(requirement.name)
            if lower then visit(lower)end
            for _,g in ipairs(r.groups or {})do
                if #g.choices==1 and g.amount==1 then local prev=find(nil,g.choices[1]);if prev then visit(prev)end end
            end
            needed[r.id]=r;list[#list+1]=r.id
        end
        local requirement=app.missingCraftRequirement(root,true)
        local r=requirement and find(requirement.name)
        if r then visit(r)end
        if #list>0 then chains[id]=list end
    end
    return needed,chains
end
local evaluate=app.evaluateRoute
app.evaluateRoute=function(model,segments,reuse)
    if not model.prerequisites then return evaluate(model,segments,reuse)end
    local expanded,seen,mapping={}, {},{}
    for stage,s in ipairs(segments)do
        for _,id in ipairs(model.prerequisites[s.recipe]or {})do
            if not seen[id]then
                seen[id]=true;expanded[#expanded+1]={recipe=id,from=s.from,to=s.from,crafts=1,prerequisite=true}
                mapping[#expanded]=stage
            end
        end
        expanded[#expanded+1]=s;mapping[#expanded]=stage
    end
    local cost,why=evaluate(model,expanded,reuse)
    if cost then
        cost.prerequisiteSegments={}
        for _,s in ipairs(expanded)do if s.prerequisite then cost.prerequisiteSegments[#cost.prerequisiteSegments+1]=s end end
        cost.segments=segments
        for _,t in ipairs(cost.transfers)do t.stage=mapping[t.stage]or t.stage end
    end
    return cost,why
end
