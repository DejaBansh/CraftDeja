-- SPDX-License-Identifier: MIT
local _,app=...

function app.band(recipe,skill)
    if not recipe.yellow or not recipe.green or not recipe.grey then return nil end
    if skill>=recipe.grey then return "grey"end
    if skill>=recipe.green then return "green"end
    if skill>=recipe.yellow then return "yellow"end
    return "orange"
end

function app.probability(recipe,skill,live)
    local colour=live and recipe.colour or app.band(recipe,skill)
    if colour=="orange"then return 1,colour,false end
    if colour=="grey"or not colour then return 0,colour,false end
    if not recipe.rangeConflict and recipe.yellow and recipe.grey and recipe.grey>recipe.yellow then
        return math.max(0,math.min(1,(recipe.grey-skill)/(recipe.grey-recipe.yellow))),colour,true
    end
    return colour=="yellow"and 0.75 or 0.25,colour,true
end

-- A conservative credit IF the produced items are sold to a vendor.
-- Unknown output, enchants applied to equipment and uncertain quantities get no credit.
function app.vendorRevenue(recipe,memo)
    if recipe.isEnchantingRecipe==true or recipe.profession==333 and recipe.isEnchantingRecipe~=false then
        return 0,false,'not_item'
    end
    local id,minimum,maximum=recipe.outputItemID,recipe.outputMin,recipe.outputMax
    if not recipe.confirmed or not recipe.outputFromClient or type(id)~='number'or id<=0 or id~=math.floor(id)
        or type(minimum)~='number'or minimum~=minimum or minimum<1 or minimum>=math.huge or minimum~=math.floor(minimum)
        or maximum~=nil and (type(maximum)~='number'or maximum~=maximum or maximum<minimum or maximum>=math.huge or maximum~=math.floor(maximum))then
        return 0,false,'output_unverified'
    end
    local unit=app.vendorSellPrice and app.vendorSellPrice(id,memo)
    if unit==nil then return 0,false,'price_unknown'end
    local revenue=unit*minimum
    if revenue>=math.huge then return 0,false,'output_unverified'end
    return revenue,true,'client_vendor'
end

function app.quote(recipe,prices,sellPrices)
    if not recipe.complete then return nil end
    local selections,total,providers={},0,{}
    for index,group in ipairs(recipe.groups or {})do
        local selected,unit,provider
        local preferred=app.preferredOwnedReagent and app.preferredOwnedReagent(recipe,index)
        for _,id in ipairs(group.choices)do
            local price,name=app.unitPrice(id,prices)
            if price and (not unit or price<unit or id==preferred)and (not preferred or selected~=preferred or id==preferred)then selected,unit,provider=id,price,name end
        end
        if not selected or not group.amount or group.amount<=0 then return nil end
        selections[#selections+1]={item=selected,amount=group.amount,unit=unit}
        total=total+group.amount*unit
        providers[provider or "AH"]=true
    end
    if total<=0 then return nil end
    local labels={};for name in pairs(providers)do labels[#labels+1]=name end;table.sort(labels)
    local revenue,known,status=app.vendorRevenue(recipe,sellPrices)
    return{cost=total,netCost=total-revenue,vendorRevenue=revenue,vendorRevenueKnown=known,vendorStatus=status,
        inputs=selections,provider=table.concat(labels,"+")}
end

local function prefer(left,right)
    if not right then return true end
    local difference=left.unitSkill-right.unitSkill
    if math.abs(difference)>0.000001 then return difference<0 end
    if left.chance~=right.chance then return left.chance>right.chance end
    return left.recipe.id<right.recipe.id
end

function app.marketView(session)
    local snapshot={profile=session.profile,recipes=session.recipes,quotes={},prices={},sellPrices={},eligibility={},acquisition={}}
    for id,recipe in pairs(session.recipes)do
        snapshot.quotes[id]=app.quote(recipe,snapshot.prices,snapshot.sellPrices)
        local allowed,reason=app.canRecommend(recipe);snapshot.eligibility[id]={allowed=allowed,reason=reason}
    end
    return snapshot
end

function app.selectionAt(snapshot,level,actual)
    local known,unknown,safe=nil,nil,nil
    local missing,unchecked=0,0
    for id,recipe in pairs(snapshot.recipes)do
        local futureOK=actual or not recipe.rangeConflict
        local rankOK=recipe.learned or (not recipe.referenceHidden and recipe.skill and level>=recipe.skill)
        local cached=snapshot.eligibility and snapshot.eligibility[id]
        local allowed,accessReason
        if cached then allowed,accessReason=cached.allowed,cached.reason else allowed,accessReason=app.canRecommend(recipe)end
        -- Reject impossible entries before evaluating probabilities. Unknown
        -- access still participates in the separate unverified-source count.
        if recipe.confirmed and rankOK and (not recipe.learned and accessReason=='access_unknown'
            or allowed and not recipe.disabled and not recipe.cooldown and recipe.craftLimit~=0 and not recipe.noSkill and futureOK)then
        local probability,colour,estimated=app.probability(recipe,level,actual)
        local greenOK=colour~="green"or (app.options.green and recipe.green and not recipe.rangeConflict and level<(recipe.grey or recipe.green))
        if recipe.confirmed and not recipe.learned and rankOK and probability>0 and accessReason=='access_unknown'then unchecked=unchecked+1 end
        if allowed and recipe.confirmed and not recipe.disabled and not recipe.cooldown and recipe.craftLimit~=0 and not recipe.noSkill and futureOK and rankOK and probability>0 and greenOK then
            local quote=snapshot.quotes[id]
            if quote then
                local gain=probability*math.min(recipe.points or 1,math.max(1,snapshot.profile.cap-level))
                local candidate={recipe=recipe,quote=quote,chance=probability,colour=colour,estimated=estimated,unitSkill=(quote.netCost or quote.cost)/gain}
                if recipe.learned then
                    if prefer(candidate,known)then known=candidate end
                    if colour~="green"and prefer(candidate,safe)then safe=candidate end
                else
                    local assessment=app.learningAssessment and app.learningAssessment(snapshot,recipe,level)
                    candidate.acquisition=assessment
                    candidate.needsCostCheck=assessment and not assessment.known or false
                    if (not assessment or not assessment.known or assessment.worth)and prefer(candidate,unknown)then unknown=candidate end
                end
            elseif recipe.learned then missing=missing+1 end
        end
        end
    end
    if known and known.colour=="green"and safe and known.unitSkill>=safe.unitSkill then known=safe end
    if known and known.colour=="green"then
        known.greenExtra=true
        known.saving=safe and safe.unitSkill>0 and (1-known.unitSkill/safe.unitSkill)or nil
    end
    return known,unknown,missing,unchecked
end

function app.decide(snapshot)
    local profile=snapshot.profile
    if profile.skill>=profile.cap then return nil,"rank_full"end
    local now,learn,missing,unchecked=app.selectionAt(snapshot,profile.skill,true)
    if not now then
        if learn then now=learn;now.needsLearning=true else return nil,missing>0 and "no_prices"or (unchecked>0 and "no_verified_source"or "none")end
    end
    local recipe=now.recipe
    -- Continue while this recipe remains the cheapest expected skill gain,
    -- including green casts. Colour alone is not an economic switch point.
    local ceiling=recipe.grey and not recipe.rangeConflict and recipe.grey or profile.skill+1
    ceiling=math.min(profile.cap,ceiling)
    if type(recipe.craftLimit)=='number'then ceiling=math.min(ceiling,profile.skill+recipe.craftLimit*(recipe.points or 1))end
    local plan={profile=profile,current=now,stop=ceiling,missing=missing,unchecked=unchecked,snapshot=snapshot}
    for future=profile.skill+1,ceiling do
        local alternative,unlearned=app.selectionAt(snapshot,future,false)
        if unlearned and (not alternative or prefer(unlearned,alternative))then alternative=unlearned;alternative.needsLearning=true end
        if alternative and alternative.recipe.id~=recipe.id then
            plan.stop=future;plan.followup={level=future,candidate=alternative};break
        elseif future==ceiling then plan.followup={level=future,candidate=alternative}end
    end
    if learn and now.recipe.learned and prefer(learn,now)then
        learn.needsLearning=true;plan.followup={level=profile.skill,candidate=learn}
        plan.stop=math.min(plan.stop,profile.skill+(recipe.points or 1))
    end
    return plan
end

function app.expectedCraftAttempts(recipe,skill,target)
    if target<=skill then return 0,false end
    local expected,estimated={},false
    expected[target]=0
    for value=target-1,skill,-1 do
        local p,_,uncertain=app.probability(recipe,value,recipe.rangeConflict or not(recipe.yellow and recipe.green and recipe.grey))
        if p<=0 then return nil,"no_progress"end
        local following=math.min(target,value+(recipe.points or 1))
        expected[value]=1/p+expected[following];estimated=estimated or uncertain
    end
    return math.ceil(expected[skill]-0.00000001),estimated
end

-- Values refer to this material plan only, not a complete multi-recipe route.
-- Owned reagents still have value. A resale credit never pays the upfront bill.
function app.planCostBreakdown(plan,quote)
    local material=quote.cost*plan.crafts
    local vendor=(quote.vendorRevenue or 0)*plan.crafts
    return {material=material,owned=plan.stockKnown and material-plan.purchase or nil,
        purchase=plan.stockKnown and plan.purchase or nil,purchaseUpper=plan.purchase,
        vendor=vendor,net=material-vendor}
end

function app.materialPlan(recipe,requested)
    local session=app.active
    if not session or session.profile.id~=recipe.profession then return nil,"other_prof"end
    local allowed,accessReason=app.canRecommend(recipe)
    if not allowed then return nil,accessReason end
    local skill=session.profile.skill
    if recipe.noSkill or recipe.colour=="grey"then return nil,"no_progress"end
    local limit=recipe.grey and not recipe.rangeConflict and recipe.grey or skill+1
    if recipe.green and skill>=recipe.green then
        local decision=app.decision
        if not decision or decision.current.recipe.id~=recipe.id or not decision.current.greenExtra then return nil,"green_rejected"end
        limit=recipe.grey
    end
    local decision=app.decision
    if decision and decision.current.recipe.id==recipe.id then limit=math.min(limit,decision.stop)end
    local target=math.min(math.floor(tonumber(requested)or limit),limit,session.profile.cap)
    if type(recipe.craftLimit)=='number'then target=math.min(target,skill+recipe.craftLimit*(recipe.points or 1))end
    if target<=skill then return nil,"target_low"end
    local prices={}
    local quote=app.quote(recipe,prices)
    if not quote then return nil,"no_prices"end
    local crafts,estimated=app.expectedCraftAttempts(recipe,skill,target)
    if not crafts then return nil,estimated end
    local expected=crafts
    local green=(app.band(recipe,skill)=='green' or recipe.colour=='green') and crafts>1 and not recipe.craftLimit
    local reserve=green and app.character and app.character.greenReserve
    if reserve and reserve.recipe==recipe.id and reserve.target==target then crafts=2*expected end
    if type(recipe.craftLimit)=='number'then crafts=math.min(crafts,recipe.craftLimit)end
    local totals={}
    for _,input in ipairs(quote.inputs)do
        local item=totals[input.item]or {id=input.item,total=0,unit=input.unit}
        item.total=item.total+input.amount*crafts;totals[input.item]=item
    end
    local rows,sum,complete={},0,true
    for id,item in pairs(totals)do
        item.locations=app.inventoryFor and app.inventoryFor(id)
        item.owned=item.locations and item.locations.total or app.owned(id)
        item.buy=math.max(0,item.total-(item.owned or 0))
        item.name=app.itemName(id)
        sum=sum+item.buy*item.unit
        if item.owned==nil then complete=false end
        rows[#rows+1]=item
    end
    table.sort(rows,function(a,b)return a.id<b.id end)
    local plan={recipe=recipe,from=skill,target=target,crafts=crafts,estimated=estimated,rows=rows,purchase=sum,stockKnown=complete,capped=tonumber(requested)and target<tonumber(requested)}
    plan.expectedCrafts=math.min(expected,recipe.craftLimit or expected)
    if green then
        plan.reserveEligible=true
        plan.reserveExtra=0
        for _,row in ipairs(rows)do
            local baseline=row.total*expected/crafts
            local owned=(row.owned or 0)+(app.confirmedMail and app.confirmedMail(row.id) or 0)
            plan.reserveExtra=plan.reserveExtra+(math.max(0,2*baseline-owned)-math.max(0,baseline-owned))*row.unit
        end
    end
    plan.costs=app.planCostBreakdown(plan,quote)
    return plan
end

function app.rangeText(recipe)
    if not recipe.yellow or not recipe.green or not recipe.grey then return app.caption("ranges_unknown")end
    local function interval(a,b)return a and b and b>a and (a.."-"..(b-1))or "-"end
    local function colour(key,hex,value)return '|cff'..hex..app.caption(key)..' '..value..'|r'end
    return colour('orange','ffa449',interval(recipe.skill,recipe.yellow))..' · '..
        colour('yellow','ffe05e',interval(recipe.yellow,recipe.green))..' · '..
        colour('green','69da85',interval(recipe.green,recipe.grey))..'\n|cffaaaaaa'..app.caption('grey_at',recipe.grey)..'|r'
end
