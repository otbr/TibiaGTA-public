local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local condition = Condition(CONDITION_MANASHIELD)
condition:setParameter(CONDITION_PARAM_TICKS, 90000000)
combat:addCondition(condition)

function onCastSpell(creature, var)
	return combat:execute(creature, var)
end
