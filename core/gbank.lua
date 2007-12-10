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

local update = function()
	local tab = GetCurrentGuildBankTab()
	local index, column, q
	for i=1, MAX_GUILDBANK_SLOTS_PER_TAB do
		index = math.fmod(i, NUM_SLOTS_PER_GUILDBANK_GROUP)
		if(index == 0) then
			index = NUM_SLOTS_PER_GUILDBANK_GROUP
		end
		column = ceil((i-0.5)/NUM_SLOTS_PER_GUILDBANK_GROUP)

		local link = GetGuildBankItemLink(tab, i)
		local slot = _G["GuildBankColumn"..column.."Button"..index]
		if(link and not oGlow.preventGBank) then
			q = select(3, GetItemInfo(link))
			oGlow(slot, q)
		elseif(slot.bc) then
			slot.bc:Hide()
		end
	end
end

local event = CreateFrame"Frame"
event:SetScript("OnEvent", function(self, event, ...)
	if(event == "GUILDBANKFRAME_OPENED") then
		self:RegisterEvent"GUILDBANKBAGSLOTS_CHANGED"
		self:Show()
	elseif(event == "GUILDBANKBAGSLOTS_CHANGED") then
		self:Show()
	elseif(event == "GUILDBANKFRAME_CLOSED") then
		self:UnregisterEvent"GUILDBANKBAGSLOTS_CHANGED"
		self:Hide()
	end
end)

local delay = 0
event:SetScript("OnUpdate", function(self, elapsed)
	delay = delay + elapsed
	if(delay > .05) then
		update()
	
		delay = 0
		self:Hide()
	end
end)

event:RegisterEvent"GUILDBANKFRAME_OPENED"
event:RegisterEvent"GUILDBANKFRAME_CLOSED"
event:Hide()

oGlow.updateGBank = update
