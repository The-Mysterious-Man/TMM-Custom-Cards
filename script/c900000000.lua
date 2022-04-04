--Zorc Necrophades
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Special Summon procedure
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--summon cannot be negated
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.econ)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	--Cannot be Tributed
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e6)
	--Cannot be used as material for a Fusion/Synchro/Xyz/Link Summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e7:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e7)
	--Cannot be destroyed by battle
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e8:SetValue(s.batfilter)
	c:RegisterEffect(e8)
	--atk
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SET_ATTACK_FINAL)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_DELAY)
	e9:SetRange(LOCATION_MZONE)
	e9:SetValue(s.adval)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e10)
	-- Cannot Lose the Duel
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e11:SetCode(EFFECT_CANNOT_LOSE_LP)
	e11:SetRange(LOCATION_MZONE)
	e11:SetTargetRange(1,0)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e13)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandlerPlayer()
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,0,c,POS_FACEDOWN)
	return Duel.GetMZoneCount(tp,rg)>0 and #rg>4 and aux.SelectUnselectGroup(rg,e,tp,55,#rg,aux.ChkfMMZ(1),0)
end
function s.mmzfilter(c,tp)
	return c:IsInMainMZone(tp) and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,0,c,POS_FACEDOWN)
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if ft<=0 then
		g1=Duel.SelectMatchingCard(tp,s.mmzfilter,tp,LOCATION_MZONE,0,1,1,true,c,tp)
		if g1 and #g1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			g2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,0,4,#rg,true,Group.FromCards(c,g1:GetFirst()),POS_FACEDOWN)
			if g2 and #g2>0 then
				g1:Merge(g2)
				g1:KeepAlive()
				e:SetLabelObject(g1)
				return true
			end
		end
	else
		g1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,0,55,#rg,true,c,POS_FACEDOWN)
		if g1 and #g1>0 then
			g1:KeepAlive()
			e:SetLabelObject(g1)
			return true
		end
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	g:DeleteGroup()
end
function s.econ(e)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.batfilter(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) or c:IsAttribute(ATTRIBUTE_WATER) or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_EARTH) or
c:IsAttribute(ATTRIBUTE_WIND)
end
function s.filter(c)
	return c:IsFaceup() and not c:IsHasEffect(id)
end
function s.adval(e,c)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g==0 then 
		return
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		if not tg:IsExists(aux.TRUE,1,e:GetHandler()) then
			g:RemoveCard(e:GetHandler())
			tg,val=g:GetMaxGroup(Card.GetAttack)
		end
		return val
	end
end