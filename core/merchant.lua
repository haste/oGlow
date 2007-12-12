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

-- Merchant
local GetMerchantNumItems = GetMerchantNumItems
local GetMerchantItemLink = GetMerchantItemLink

local numPage = MERCHANT_ITEMS_PER_PAGE

-- Addon
local MerchantFrame = MerchantFrame

local update = function()
	if(MerchantFrame.selectedTab == 1) then
		local numItems = GetMerchantNumItems()
		for i=1, numPage do
			local index = (((MerchantFrame.page - 1) * numPage) + i)
			local link = GetMerchantItemLink(index)
			local button = G["MerchantItem"..i.."ItemButton"]

			if(link and not oGlow.preventMerchant) then
				local q = select(3, GetItemInfo(link))
				oGlow(button, q)
			elseif(button.bc) then
				button.bc:Hide()
			end
		end
	else
		local numItems = GetNumBuybackItems()
		for i=1, numPage do
			local index = (((MerchantFrame.page - 1) * numPage) + i)
			local link = GetBuybackItemLink(index)
			local button = G["MerchantItem"..i.."ItemButton"]

			if(link and not oGlow.preventBuyback) then
				local q = select(3, GetItemInfo(link))
				oGlow(button, q)
			elseif(button.bc) then
				button.bc:Hide()
			end
		end
	end
end

hooksecurefunc("MerchantFrame_Update", update)
oGlow.updateMerchant = update
