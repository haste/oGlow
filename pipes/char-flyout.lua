-- TODO:
--  - Prevent unnecessary double updates.
--  - Write a description.

local hook
local _E

local getID = function(loc)
	local player, bank, bags, slot, bag = EquipmentManager_UnpackLocation(loc)
	if(not player and not bank and not bags) then return end

	if(not bags) then
		return GetInventoryItemID('player', slot)
	else
		return GetContainerItemID(bag, slot)
	end
end

local pipe = function(self)
	if(oGlow:IsPipeEnabled'char-flyout') then
		local location, id = self.location
		if(location and location < EQUIPMENTFLYOUT_FIRST_SPECIAL_LOCATION) then
			id = getID(location)
		end

		return oGlow:CallFilters('char-flyout', self, _E and id)
	end
end

local update = function(self)
	local buttons = EquipmentFlyoutFrame.buttons
	for _, button in next, buttons do
		pipe(button)
	end
end

local enable = function(self)
	_E = true

	if(not hook) then
		hooksecurefunc('EquipmentFlyout_DisplayButton', pipe)
		hook = true
	end
end

local disable = function(self)
	_E = nil

	update(self)
end

oGlow:RegisterPipe('char-flyout', enable, disable, update, 'Character equipment flyout frame', nil)
