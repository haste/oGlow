local update = function(id)
	if(oGlow:IsPipeEnabled'craft') then
		local itemLink = GetCraftItemLink(id)

		if(itemLink) then
			oGlow:CallFilters('craft', CraftIcon, itemLink)
		end

		for i=1, GetCraftNumReagents(id) do
			local reagentFrame = _G['CraftReagent'..i..'IconTexture']
			local reagentLink = GetCraftReagentItemLink(id, i)

			oGlow:CallFilters('craft', reagentFrame, reagentLink)
		end
	end
end

local function ADDON_LOADED(self, event, addon)
	hooksecurefunc("CraftFrame_SetSelection", update)
	self:UnregisterEvent(event, ADDON_LOADED)
end

local endable = function(self)
	if(IsAddOnLoaded("Blizzard_CraftUI")) then
		hooksecurefunc("CraftFrame_SetSelection", update)
	else
		self:RegisterEvent('ADDON_LOADED', ADDON_LOADED)
	end

end

local disable = function(self)
	self:UnregisterEvent('ADDON_LOADED', ADDON_LOADED)
end

oGlow:RegisterPipe('craft', enable, disable, update)
