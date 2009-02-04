local player = function(self, event, index)
	local slotFrame = _G["TradePlayerItem"..index.."ItemButton"]
	local slotLink = GetTradePlayerItemLink(index)

	self:CallFilters('trade', slotFrame, slotLink)
end

local target = function(self, event, index)
	local slotFrame = G["TradeRecipientItem"..index.."ItemButton"]
	local slotLink = GetTradeTargetItemLink(index)

	self:CallFilters('trade', slotFrame, slotLink)
end

local update = function(self)
	for i=1,7 do
		player(self, nil, i)
		target(self, nil, i)
	end
end

local enable = function(self)
	self:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:RegisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

local disable = function(self)
	self:UnregisterEvent("TRADE_PLAYER_ITEM_CHANGED", player)
	self:UnregisterEvent("TRADE_TARGET_ITEM_CHANGED", target)
end

oGlow:RegisterPipe('trade', enable, disable, update)
