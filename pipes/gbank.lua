local update = function(self)
	local tab = GetCurrentGuildBankTab()
	for i=1, MAX_GUILDBANK_SLOTS_PER_TAB do
		local index = math.fmod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
		if(index == 0) then
			index = NUM_SLOTS_PER_GUILDBANK_GROUP
		end
		local column = math.ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)

		local slotLink = GetGuildBankItemLink(tab, i)
		local slotFrame = _G["GuildBankColumn"..column.."Button"..index]

		self:CallFilters('gbank', slotFrame, slotLink)
	end
end

local enable = function(self)
	self:RegisterEvent('GUILDBANKBAGSLOTS_CHANGED', update)
	self:RegisterEvent('GUILDBANKFRAME_OPENED', update)
end

local disable = function(self)
	self:UnregisterEvent('GUILDBANKBAGSLOTS_CHANGED', update)
	self:UnregisterEvent('GUILDBANKFRAME_OPENED', update)
end

oGlow:RegisterPipe('gbank', enable, disable, update)
