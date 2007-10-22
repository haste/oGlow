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
