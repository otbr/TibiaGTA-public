local CHANNEL = 8

local muted = Condition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT)
muted:setParameter(CONDITION_PARAM_SUBID, CHANNEL)
muted:setParameter(CONDITION_PARAM_TICKS, 3600000)

function canJoin(player)
	return (player:getVocation():getId() == 1) or (player:getAccountType() >= ACCOUNT_TYPE_GOD)
end

function onSpeak(player, type, message)

	if player:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_HELP) then
		player:sendCancelMessage("You are muted from the Help channel for using it inappropriately.")
		return false
	end

	local playerAccountType = player:getAccountType()
	if playerAccountType >= ACCOUNT_TYPE_TUTOR then
		if string.sub(message, 1, 6) == "!mute " then
			local targetName = string.sub(message, 7)
			local target = Player(targetName)
			if target ~= nil then
				if playerAccountType > target:getAccountType() then
					if not target:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_HELP) then
						target:addCondition(muted)
						sendChannelMessage(CHANNEL_HELP, TALKTYPE_CHANNEL_R1, target:getName() .. " has been muted by " .. player:getName() .. " for using Help Channel inappropriately.")
					else
						player:sendCancelMessage("That player is already muted.")
					end
				else
					player:sendCancelMessage("You are not authorized to mute that player.")
				end
			else
				player:sendCancelMessage(RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE)
			end
			return false
		elseif string.sub(message, 1, 8) == "!unmute " then
			local targetName = string.sub(message, 9)
			local target = Player(targetName)
			if target ~= nil then
				if playerAccountType > target:getAccountType() then
					if target:getCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_HELP) then
						target:removeCondition(CONDITION_CHANNELMUTEDTICKS, CONDITIONID_DEFAULT, CHANNEL_HELP)
						sendChannelMessage(CHANNEL_HELP, TALKTYPE_CHANNEL_R1, target:getName() .. " has been unmuted by " .. player:getName() .. ".")
					else
						player:sendCancelMessage("That player is not muted.")
					end
				else
					player:sendCancelMessage("You are not authorized to unmute that player.")
				end
			else
				player:sendCancelMessage(RETURNVALUE_PLAYERWITHTHISNAMEISNOTONLINE)
			end
			return false
		end
	end
	
	local playerAccountType = player:getAccountType()
	if type == TALKTYPE_CHANNEL_Y then
		if playerAccountType >= ACCOUNT_TYPE_SENIORTUTOR then
			type = TALKTYPE_CHANNEL_O
		end
	elseif type == TALKTYPE_CHANNEL_O then
		if playerAccountType < ACCOUNT_TYPE_SENIORTUTOR then
			type = TALKTYPE_CHANNEL_Y
		end
	elseif type == TALKTYPE_CHANNEL_R1 then
		if playerAccountType < ACCOUNT_TYPE_GAMEMASTER and not getPlayerFlagValue(player, PlayerFlag_CanTalkRedChannel) then
			type = TALKTYPE_CHANNEL_Y
		end
	end
	return type
end
