local update = function(id)
	if(oGlow:IsPipeEnabled'tradeskill') then
		local itemLink = GetTradeSkillItemLink(id)

		if(itemLink) then
			oGlow:CallFilters('tradeskill', TradeSkillSkillIcon, itemLink)
		end

		for i=1, GetTradeSkillNumReagents(id) do
			local reagentFrame = _G['TradeSkillReagent'.. i]
			local reagentLink = GetTradeSkillReagentItemLink(id, i)

			oGlow:CallFilters('tradeskill', reagentFrame, reagentLink)
		end
	end
end

local function ADDON_LOADED(self, event, addon)
	if(addon == 'Blizzard_TradeSkillUI') then
		hooksecurefunc('TradeSkillFrame_SetSelection', update)
		self:UnregisterEvent(event, ADDON_LOADED)
	end
end

local enable = function(self)
	if(IsAddOnLoaded("Blizzard_TradeSkillUI")) then
		hooksecurefunc("TradeSkillFrame_SetSelection", update)
	else
		self:RegisterEvent("ADDON_LOADED", ADDON_LOADED)
	end
end

local disable = function(self)
	self:UnregisterEvent('ADDON_LOADED', ADDON_LOADED)
end

oGlow:RegisterPipe('tradeskill', enable, disable, update)
