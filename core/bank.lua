-- Globally used
local G = getfenv(0)
local select = select
local oGlow = oGlow

-- Bank
local GetContainerItemLink = GetContainerItemLink
local GetItemInfo = GetItemInfo

-- Addon
local hook = CreateFrame"Frame"
hook:SetParent"BankFrame"

local self, link, q
local update = function()
	for i=1, 28 do
		self = G["BankFrameItem"..i]
		link = GetContainerItemLink(-1, i)
	
		if(link and not oGlow.preventBank) then
			q = select(3, GetItemInfo(link))
			oGlow(self, q)
		elseif(self.bc) then
			self.bc:Hide()
		end
	end
end

hook:SetScript("OnShow", update)
hook:SetScript("OnEvent", update)
hook:RegisterEvent"PLAYERBANKSLOTS_CHANGED"
hook:RegisterEvent"BAG_UPDATE"

oGlow.updateBank = update
