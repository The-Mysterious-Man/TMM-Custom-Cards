-- Kuriknight
local s,id=GetID()
function s.initial_effect(c)
	--Becomes a Normal Monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetValue(s.val2)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetValue(s.val3)
	c:RegisterEffect(e7)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetValue(s.tglimit)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(s.tglimit)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end
function s.val(e,c)
	return c:GetLevel()*-300
end
function s.val2(e,c)
	return c:GetRank()*-300
end
function s.val3(e,c)
	return c:GetLink()*-1000
end
function s.tglimit(e,c)
	return c~=e:GetHandler()
end