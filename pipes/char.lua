if(select(4, GetAddOnInfo("Fizzle"))) then return end

local slots = {
	"Head",
	"Neck",
	"Shoulder",
	"Shirt",
	"Chest",
	"Waist",
	"Legs",
	"Feet",
	"Wrist",
	"Hands",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand",
	"SecondaryHand",
	"Ranged",
	"Tabard",
	'Ammo',
}

local update = function(self)
	for key, slotName in ipairs(slots) do
		-- Ammo is located at 0.
		local slotID = key % 20
		local slotFrame = _G['Character' .. slotName .. 'Slot']
		local slotLink = GetInventoryItemLink('player', slotID)

		self:CallFilters('char', slotFrame, slotLink)
	end
end

local UNIT_INVENTORY_CHANGED = function(self, event, unit)
	if(unit == 'player') then
		update(self)
	end
end

local enable = function(self)
	self:RegisterEvent('UNIT_INVENTORY_CHANGED', UNIT_INVENTORY_CHANGED)
end

local disable = function(self)
	self:UnregisterEvent('UNIT_INVENTORY_CHANGED', UNIT_INVENTORY_CHANGED)
end

oGlow:RegisterPipe('char', enable, disable, update)
