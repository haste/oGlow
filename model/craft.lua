local G = getfenv(0)
local select = select
local oGlow = oGlow

-- Craft

local frame, link, q, icon
local update = function(id)
	icon = G["CraftIcon"]
	link = GetCraftItemLink(id)

	if(link and not oGlow.preventCraft) then
		q = select(3, GetItemInfo(link))
		oGlow(icon, q)
	elseif(icon.bc) then
		icon.bc:Hide()
	end

	for i=1, GetCraftNumReagents(id) do
		frame = G["CraftReagent"..i]
		link = GetCraftReagentItemLink(id, i)

		if(link) then
			q = select(3, GetItemInfo(link))
			point = G["CraftReagent"..i.."IconTexture"]

			oGlow(frame, q, point)
		elseif(frame.bc) then
			frame.bc:Hide()
		end
	end
end

if(IsAddOnLoaded("Blizzard_CraftUI")) then
	hooksecurefunc("CraftFrame_SetSelection", update)
else
	local hook = CreateFrame"Frame"

	hook:SetScript("OnEvent", function(self, event, addon)
		if(addon == "Blizzard_CraftUI") then
			hooksecurefunc("CraftFrame_SetSelection", update)
			hook:UnregisterEvent"ADDON_LOADED"
			hook:SetScript("OnEvent", nil)
		end
	end)
	hook:RegisterEvent"ADDON_LOADED"
end

oGlow.updateCraft = update
