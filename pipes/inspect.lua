-- Not update - so let's bail out early.
do return end

if(select(4, GetAddOnInfo("Fizzle"))) then return end

-- Globally used
local G = getfenv(0)
local select = select
local pairs = pairs
local oGlow = oGlow

local hook = CreateFrame"Frame"
local items = {
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
}

local q
local update = function()
	if(not InspectFrame:IsShown()) then return end
	local unit = InspectFrame.unit
	for i, key in pairs(items) do
		local link = GetInventoryItemLink(unit, i)
		local self = G["Inspect"..key.."Slot"]

		if(link and not oGlow.preventInspect) then
			q = select(3, GetItemInfo(link))
			oGlow(self, q)
		elseif(self.bc) then
			self.bc:Hide()
		end
	end
end

hook["PLAYER_TARGET_CHANGED"] = update
hook["ADDON_LOADED"] = function(addon)
	if(addon == "Blizzard_InspectUI") then
		hook:SetScript("OnShow", update)
		hook:SetParent"InspectFrame"

		hook:RegisterEvent"PLAYER_TARGET_CHANGED"
		hook:UnregisterEvent"ADDON_LOADED"
	end
end

hook:SetScript("OnEvent", function(self, event, ...)
	self[event](...)
end)

-- Check if it's already loaded by some add-on
if(IsAddOnLoaded("Blizzard_InspectUI")) then
	hook:SetScript("OnShow", update)
	hook:SetParent"InspectFrame"
else
	hook:RegisterEvent"ADDON_LOADED"
end

oGlow.updateInspect = update
