--Zorc Necrophades, Creator of the Shadow Realm
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(s.indes)
	c:RegisterEffect(e3)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--cannot be fusion material
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL+EFFECT_CANNOT_BE_SYNCHRO_MATERIAL+EFFECT_CANNOT_BE_XYZ_MATERIAL+EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	c:RegisterEffect(e7)
	-- cannot lose the duel
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_LOSE_LP)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,0)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_CANNOT_LOSE_DECK)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EFFECT_CANNOT_LOSE_EFFECT)
	c:RegisterEffect(e10)
end
function s.efilter(e,c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_DIVINE)
end
function s.indes(e,c)
	return not c:IsAttribute(ATTRIBUTE_DIVINE)
end