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
local GetItemInfo = GetItemInfo
local select = select
local type = type

-- Containers
local GetContainerItemLink = GetContainerItemLink
local GetItemQualityColor = GetItemQualityColor

-- Character/PaperDoll
local GetInventoryItemQuality = GetInventoryItemQuality

-- core functionality
local createBorder = function(self)
	local bc = self:CreateTexture(nil, "OVERLAY")

	bc:SetTexture"Interface\\Buttons\\UI-ActionButton-Border"
	bc:SetBlendMode"ADD"
	bc:SetAlpha(.8)

	bc:SetHeight(68)
	bc:SetWidth(68)
	bc:SetPoint("CENTER", self, 0, 1)
	self.bc = bc
end

local funcs = {
	ContainerFrame = function(self)
		local s, b = self:GetID(), self:GetParent():GetID()

		local l = GetContainerItemLink(b, s)
		if(not l) then
			if(self.bc and self.bc:IsShown()) then self.bc:Hide() end
			return
		end

		local q = select(3, GetItemInfo(l))
		if(q > 1) then
			if(not self.bc) then createBorder(self) end

			local r, g, b = GetItemQualityColor(q)
			self.bc:SetVertexColor(r, g, b)
			if(not self.bc:IsShown()) then self.bc:Show() end
		end
	end,
	PaperDollFram = function(self)
		local i = self:GetID()
		local q = GetInventoryItemQuality("player", i)

		if(q and q > 1) then
			if(not self.bc) then createBorder(self) end

			local r, g, b = GetItemQualityColor(q)
			self.bc:SetVertexColor(r, g, b)
			if(not self.bc:IsShown()) then self.bc:Show() end
		end
	end,
}

hooksecurefunc("SetItemButtonTexture", function(self)
	if(InCombatLockdown()) then return end

	local parent = self:GetParent():GetName()
	if(parent and type(parent) == "string") then
		parent = parent:sub(1, -2)

		local func = funcs[parent]
		if(func) then func(self) end
	end
end)
