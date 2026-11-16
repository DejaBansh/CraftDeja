-- SPDX-License-Identifier: MIT
local _,app=...
local function clone(t)local n={};for k,v in pairs(t or {})do n[k]=v end;return n end
function app.routeExpectedCrafts(model,r,from,to)
    local attempts=0;local gain=math.max(1,r.points or 1)
    for at=from,to-1,gain do
        local p,colour
        if model.chance then p,colour=model.chance(r,at)else p,colour=app.probability(r,at,at==model.start)end
        if not app.routeFinite(p)or p<=0 or p>1 or colour=='green'and not model.green then return nil end
        attempts=attempts+1/p
    end
    return math.ceil(attempts-.00000001),attempts
end
local function eligible(model,r,at)
    return not r.disabled and not r.cooldown and not r.noSkill and r.craftLimit==nil and not r.rangeConflict
        and r.allowed~=false and r.skill and r.skill<=at and (not r.grey or at<r.grey)
end
local function ends(model,r,at)
    local set={};local points=math.max(1,r.points or 1)
    local function add(n)
        if type(n)=='number'and n>at then
            n=math.min(model.target,at+math.ceil((n-at)/points)*points)
            if n<=model.target and (not r.grey or n<=r.grey+points-1)then set[n]=true end
        end
    end
    add(at+points);add(model.target);add(r.yellow);add(r.green);add(r.grey)
    for _,other in pairs(model.recipes)do add(other.skill)end
    for _,rank in ipairs(model.ranks or {})do add(rank.skill);add(rank.fromCap)end
    local list={};for n in pairs(set)do list[#list+1]=n end;table.sort(list);return list
end
local function score(model,result,reuse)
    local n=result.net
    if reuse then
        -- Search ordering only. Final comparisons always use the full ledger.
        for item,qty in pairs(result.remaining)do
            if model.intermediates[item]then
                local value=app.routeCurveCost(model.prices[item],qty)
                if value then n=n-value end
            end
        end
    end
    return n
end
local function signature(segments)
    local keys={};for _,s in ipairs(segments)do keys[#keys+1]=s.recipe..':'..s.to end;return table.concat(keys,',')
end
local function addState(bucket,state,width)
    for _,old in ipairs(bucket)do if old.key==state.key then return end end
    bucket[#bucket+1]=state
    table.sort(bucket,function(a,b)
        if a.cost.provisional~=b.cost.provisional then return not a.cost.provisional end
        if a.score~=b.score then return a.score<b.score end
        return a.key<b.key
    end)
    while #bucket>width do table.remove(bucket)end
end
local function withRanks(model,cost)
    local cap=model.cap;local level=model.characterLevel
    for _,rank in ipairs(model.ranks or {})do
        if cap<model.target and rank.fromCap==cap then
            if not rank.toCap or rank.toCap<=cap or rank.level and (not level or level<rank.level)then
                cost.provisional=true;cost.reasons['rank_blocked:'..cap]=true;return
            end
            cost.visits=cost.visits+1
            if app.routeFinite(rank.cost)then
                cost.cashLearning=cost.cashLearning+rank.cost;cost.cash=cost.cash+rank.cost;cost.net=cost.net+rank.cost
            else cost.provisional=true;cost.reasons['rank_fee_unknown:'..cap]=true end
            cost.ranks=cost.ranks or {};cost.ranks[#cost.ranks+1]=rank;cap=rank.toCap
        end
    end
    if cap<model.target then cost.provisional=true;cost.reasons.rank_unavailable=true end
    if cost.provisional then cost.knownNet=nil;cost.knownCash=nil else cost.knownNet=cost.net;cost.knownCash=cost.cash end
end

-- Bounded beam search across complete same-target routes. The bound and the
-- candidate count are exposed; this is not a claim of an unrestricted optimum.
function app.newRouteSearch(model)
    model.intermediates=model.intermediates or {}
    for _,r in pairs(model.recipes)do for id in pairs(r.inputs or {})do model.intermediates[id]=true end end
    local result={model=model,compared=0,expansions=0,candidates={},limited=false,done=false}
    result.thread=coroutine.create(function()
        if not model.start or not model.target or model.target<=model.start or model.target>450 then
            result.error='invalid_goal';result.done=true;return
        end
        local width=model.width or 8;local work=0
        local function complete(cost)
            result.compared=result.compared+1
            local key=signature(cost.segments)..':'..cost.mode
            for i,old in ipairs(result.candidates)do
                if old.routeKey==key then
                    if app.routeBetter(cost,old)then table.remove(result.candidates,i)else return end
                    break
                end
            end
            cost.routeKey=key;result.candidates[#result.candidates+1]=cost
            table.sort(result.candidates,app.routeBetter)
            while #result.candidates>12 do table.remove(result.candidates)end
        end
        local recipeIDs={};for id in pairs(model.recipes)do recipeIDs[#recipeIDs+1]=id end;table.sort(recipeIDs)
        local function seed(reuse)
            local values,choice={[model.target]=0},{}
            local operations=0
            for at=model.target-1,model.start,-1 do
                local best=math.huge
                for _,id in ipairs(recipeIDs)do
                    local r=model.recipes[id]
                    if eligible(model,r,at)then
                        local p,colour
                        if model.chance then p,colour=model.chance(r,at)else p,colour=app.probability(r,at,at==model.start)end
                        if p and p>0 and (colour~='green'or model.green)then
                            local cost=0
                            for item,n in pairs(r.inputs)do cost=cost+(app.routeCurveCost(model.prices[item],n)or 0)end
                            local credit=(r.sell or 0)*(r.outputMin or 0)
                            if reuse and r.outputItem and model.intermediates[r.outputItem]then credit=app.routeCurveCost(model.prices[r.outputItem],r.outputMin or 0)or credit end
                            local next=math.min(model.target,at+math.max(1,r.points or 1))
                            local score=(cost-credit)/p+(values[next]or math.huge)
                            if score<best then best=score;choice[at]=id end
                        end
                    end
                    operations=operations+1;if operations>=16 then operations=0;coroutine.yield()end
                end
                values[at]=best
            end
            local list={};local at=model.start
            while at<model.target do
                local id=choice[at];if not id then return end
                local r=model.recipes[id];local to=math.min(model.target,at+math.max(1,r.points or 1));local last=list[#list]
                if last and last.recipe==id then last.to=to else list[#list+1]={recipe=id,from=at,to=to}end
                at=to
            end
            for _,s in ipairs(list)do s.crafts,s.expected=app.routeExpectedCrafts(model,model.recipes[s.recipe],s.from,s.to)end
            for _,use in ipairs({false,true})do
                local cost=app.evaluateRoute(model,list,use)
                if cost then cost.target=model.target;cost.start=model.start;withRanks(model,cost);complete(cost)end
            end
        end
        seed(false);seed(true)
        -- Complete chains at meaningful switch points enter the comparison
        -- before the beam budget can be exhausted by many short prefixes.
        local chainWork,chainNodes=0,0
        local function chain(at,segments,used)
            if chainNodes>=512 or #segments>=4 then return end
            for _,id in ipairs(recipeIDs)do
                local r=model.recipes[id]
                if not used[id]and eligible(model,r,at)then
                    for _,to in ipairs(ends(model,r,at))do
                        if to==model.target or to>at+1 then
                            local count,expected=app.routeExpectedCrafts(model,r,at,to)
                            if count then
                                chainNodes=chainNodes+1
                                local list={};for i,s in ipairs(segments)do list[i]=s end
                                list[#list+1]={recipe=id,from=at,to=to,crafts=count,expected=expected}
                                if to==model.target then
                                    for _,reuse in ipairs({false,true})do
                                        local cost=app.evaluateRoute(model,list,reuse)
                                        if cost then
                                            cost.start=model.start;cost.target=model.target;withRanks(model,cost)
                                            complete(cost)
                                        end
                                    end
                                else
                                    local nextUsed=clone(used);nextUsed[id]=true;chain(to,list,nextUsed)
                                end
                                chainWork=chainWork+1;if chainWork>=4 then chainWork=0;coroutine.yield()end
                            end
                        end
                        if chainNodes>=512 then return end
                    end
                end
            end
        end
        chain(model.start,{},{});result.chainNodes=chainNodes
        for mode,reuse in ipairs({false,true})do
            local modeLimited=false
            local buckets={[model.start]={{segments={},key='',score=0}}}
            for at=model.start,model.target-1 do
                for _,state in ipairs(buckets[at]or {})do
                    for _,id in ipairs(recipeIDs)do
                        local r=model.recipes[id]
                        if eligible(model,r,at)then
                            for _,to in ipairs(ends(model,r,at))do
                                local segments={};for i,s in ipairs(state.segments)do segments[i]=clone(s)end
                                local last=segments[#segments];local from=last and last.recipe==id and last.from or at
                                local count,expected=app.routeExpectedCrafts(model,r,from,to)
                                if count then
                                    local segment={recipe=id,from=from,to=to,crafts=count,expected=expected}
                                    if last and last.recipe==id then segments[#segments]=segment else segments[#segments+1]=segment end
                                    local cost=app.evaluateRoute(model,segments,reuse)
                                    if cost then
                                        result.expansions=result.expansions+1;cost.target=to;cost.start=model.start
                                        if to==model.target then
                                            withRanks(model,cost);complete(cost)
                                        else
                                            buckets[to]=buckets[to]or {}
                                            addState(buckets[to],{segments=segments,cost=cost,key=signature(segments),score=score(model,cost,reuse)},width)
                                        end
                                    end
                                end
                                work=work+1
                                if work>=4 then work=0;coroutine.yield()end
                                if result.expansions>=mode*math.floor((model.maxExpansions or 4000)/2)then result.limited=true;modeLimited=true;break end
                            end
                        end
                        if modeLimited then break end
                    end
                    if modeLimited then break end
                end
                if modeLimited then break end
            end
        end
        table.sort(result.candidates,app.routeBetter)
        result.best=result.candidates[1]
        if result.best then
            local alternative
            for i=2,#result.candidates do
                local c=result.candidates[i]
                if signature(c.segments)~=signature(result.best.segments)or c.mode~=result.best.mode then alternative=c;break end
            end
            result.alternative=alternative
            result.saving=alternative and not alternative.provisional and not result.best.provisional and alternative.net-result.best.net or nil
        else result.error='no_complete_route'end
        result.done=true
    end)
    return result
end
function app.advanceRouteSearch(search)
    if not search.done then
        local ok,err=coroutine.resume(search.thread)
        if not ok then search.done=true;search.error=tostring(err)end
    end
    return search.done
end
function app.solveRoute(model)
    local search=app.newRouteSearch(model)
    while not search.done do app.advanceRouteSearch(search)end
    return search
end
