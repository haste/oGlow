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
local pairs = pairs
local oGlow = oGlow

-- Addon
local GetInventoryItemQuality = GetInventoryItemQuality
local CharacterFrame = CharacterFrame

local items = {
	[0] = "Ammo",
	"Head 1",
	"Neck",
	"Shoulder 2",
	"Shirt",
	"Chest 3",
	"Waist 4",
	"Legs 5",
	"Feet 6",
	"Wrist 7",
	"Hands 8",
	"Finger0",
	"Finger1",
	"Trinket0",
	"Trinket1",
	"Back",
	"MainHand 9",
	"SecondaryHand 10",
	"Ranged 11",
	"Tabard",
}

local q, key, self
local update = function()
	if(not CharacterFrame:IsShown()) then return end
	for i, value in pairs(items) do
		key, index = string.split(" ", value)
		q = GetInventoryItemQuality("player", i)
		self = G["Character"..key.."Slot"]

		if(oGlow.preventCharacter) then
			q = 0
		elseif(GetInventoryItemBroken("player", i)) then
			q = 100
		elseif(index and GetInventoryAlertStatus(index) == 3) then
			q = 99
		end

		oGlow(self, q)
	end
end

local hook = CreateFrame"Frame"
hook:SetParent"CharacterFrame"
hook:SetScript("OnShow", update)
hook:SetScript("OnEvent", function(self, event, unit) if(unit == "player") then update() end end)
hook:RegisterEvent"UNIT_INVENTORY_CHANGED"

oGlow.updateCharacter = update
