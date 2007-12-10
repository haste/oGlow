--[[-------------------------------------------------------------------------
  Copyright (c) 2007, Trond A Ekseth
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of oGlow nor the names of its contributors
        may be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

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
