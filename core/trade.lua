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

-- Globally used
local G = getfenv(0)
local oGlow = oGlow

-- Trade
local GetItemInfo = GetItemInfo
local GetTradePlayerItemLink = GetTradePlayerItemLink

-- Addon
local hook = CreateFrame"Frame"

local q
local setQuality = function(self, link)
	if(link and not oGlow.preventTrade) then
		q = select(3, GetItemInfo(link))
		oGlow(self, q)
	elseif(self.bc) then
		self.bc:Hide()
	end
end

local update = function()
	for i=1,7 do
		hook["TRADE_PLAYER_ITEM_CHANGED"](i)
		hook["TRADE_TARGET_ITEM_CHANGED"](i)
	end
end

hook["TRADE_SHOW"] = update
hook["TRADE_UPDATE"] = update

local self, link
hook["TRADE_PLAYER_ITEM_CHANGED"] = function(index)
	self = G["TradePlayerItem"..index.."ItemButton"]
	link = GetTradePlayerItemLink(index)

	setQuality(self, link)
end

hook["TRADE_TARGET_ITEM_CHANGED"] = function(index)
	self = G["TradeRecipientItem"..index.."ItemButton"]
	link = GetTradeTargetItemLink(index)

	setQuality(self, link)
end

hook:SetScript("OnEvent", function(self, event, id)
	self[event](id)
end)

hook:RegisterEvent"TRADE_SHOW" -- isn't used?
hook:RegisterEvent"TRADE_UPDATE" -- isn't used?
hook:RegisterEvent"TRADE_PLAYER_ITEM_CHANGED"
hook:RegisterEvent"TRADE_TARGET_ITEM_CHANGED"

oGlow.updateTrade = update
