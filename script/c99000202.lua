--Code Name: Sirius
local m=99000202
local cm=_G["c"..m]
function cm.initial_effect(c)
	--MyuMyuMyu
	local e0=Effect.CreateEffect(c)	
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetCountLimit(1)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.myucon)
	e0:SetOperation(cm.myuop)
	c:RegisterEffect(e0)
	--disable summon
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetRange(LOCATION_HAND)
	ea:SetCode(EFFECT_CANNOT_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetCondition(cm.myucon)
	ea:SetTargetRange(1,0)
	ea:SetTarget(cm.myulimit)
	c:RegisterEffect(ea)
	--disable set
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(eb)
	--disable spsummon
	local ec=ea:Clone()
	ec:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(ec)
	--public
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetCode(EFFECT_PUBLIC)
	ed:SetCondition(cm.myucon)
	ed:SetRange(LOCATION_HAND)
	c:RegisterEffect(ed)
	--replace
   	local ee=Effect.CreateEffect(c)
	ee:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ee:SetCode(EFFECT_SEND_REPLACE)
	ee:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee:SetRange(LOCATION_HAND)
	ee:SetCondition(cm.myucon)
	ee:SetTarget(cm.myureptg)
	ee:SetValue(cm.myurepval)
	c:RegisterEffect(ee)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m+1000)
	e2:SetCondition(cm.condtion)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
	--avoid damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetCondition(cm.myucon)
	e4:SetValue(0)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
end
function cm.myucon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:GetOwner()==1-tp
end
function cm.myuop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(99000202,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.myulimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetFlagEffect(99000202)>0
end
function cm.myureptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and not (re:IsActiveType(TYPE_MONSTER) and
		re:GetHandler():IsSetCard(0x1c20) and bit.band(r,REASON_EFFECT)~=0) end
	return true
end
function cm.myurepval(e,c)
	return true
end
function cm.filter(c)
	return c:IsSetCard(0xc20) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(99000202)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1c20)
		and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,c)
	end
end
function cm.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsAbleToGraveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end