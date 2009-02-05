local update = function(self)
	for i=1,28 do
		local slotFrame = _G['BankFrameItem' .. i]
		local slotLink = GetContainerItemLink(-1, i)

		self:CallFilters('bank', slotFrame, slotLink)
	end
end

local enable = function(self)
	self:RegisterEvent('PLAYERBANKSLOTS_CHANGED', update)
end

local disable = function(self)
	self:UnregisterEvent('PLAYERBANKSLOTS_CHANGED', update)
end

oGlow:RegisterPipe('bank', enable, disable, update)
