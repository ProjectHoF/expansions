--유니온 #CHA.OS(Conflict of Highlight After Opening Stage)
local m=112603053
local cm=_G["c"..m]
function cm.initial_effect(c)

	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.spcon1)
	e6:SetCost(cm.spcost1)
	e6:SetTarget(cm.sptg1)
	e6:SetOperation(cm.spop1)
	c:RegisterEffect(e6)
	
	--M Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.mcon)
	e1:SetCost(cm.localcost)
	e1:SetTarget(cm.mtg)
	e1:SetOperation(cm.mop)
	c:RegisterEffect(e1)
	
	--S Search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(cm.scon)
	e2:SetCost(cm.localcost)
	e2:SetTarget(cm.stg)
	e2:SetOperation(cm.sop)
	c:RegisterEffect(e2)
	
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetCost(cm.recost)
	e3:SetTarget(cm.retg)
	e3:SetOperation(cm.reop)
	c:RegisterEffect(e3)
	
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe91))
	e4:SetValue(500)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	
	--equip
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(m,0))
	ea:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ea:SetCategory(CATEGORY_EQUIP)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ea:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	ea:SetTarget(cm.eqtg0)
	ea:SetOperation(cm.eqop0)
	c:RegisterEffect(ea)
	
	--unequip
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(m,1))
	eb:SetCategory(CATEGORY_SPECIAL_SUMMON)
	eb:SetType(EFFECT_TYPE_QUICK_O)
	eb:SetCode(EVENT_FREE_CHAIN)
	eb:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	eb:SetRange(LOCATION_SZONE)
	eb:SetTarget(cm.sptg0)
	eb:SetOperation(cm.spop0)
	c:RegisterEffect(eb)
	
	--destroy sub
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_EQUIP)
	ec:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ec:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	ec:SetValue(cm.repval0)
	c:RegisterEffect(ec)

	--eqlimit
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetCode(EFFECT_EQUIP_LIMIT)
	ed:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ed:SetValue(cm.eqlimit)
	c:RegisterEffect(ed)

end

--eqlimit
function cm.eqlimit(e,c)
	return c:IsSetCard(0xe91) or e:GetHandler():GetEquipTarget()==c
end


--equip
function cm.filter0(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0xe91) and ct2==0
end
function cm.eqtg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter0(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter0,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.filter0,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not cm.filter0(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	aux.SetUnionState(c)
end

--unequip
function cm.sptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end

--destroy sub
function cm.repval0(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end

--spsummon
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_UNION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--M Search
function cm.mcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.localcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.mfilter(c)
	return c:IsSetCard(0xe91) and c:IsType(TYPE_MONSTER) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.mtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD)
end
function cm.mop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--S Search
function cm.scon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.sfilter(c)
	return c:IsSetCard(0xe91) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD)
end
function cm.sop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_ONFIELD,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--remove
function cm.cfilter(c)
	return c:IsSetCard(0xe91) and c:IsAbleToGraveAsCost()
end
function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.filter2(c)
	return bit.band(c:GetType(),0x400)==0x400 and c:IsAbleToHand()
end
function cm.filter4(c)
	return c:IsAbleToRemove()
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter4,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.filter4,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil):GetFirst()
	if not tc then return end
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if mg:GetCount()>0 and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=mg:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

