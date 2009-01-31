local oGlow = CreateFrame('Frame', 'oGlow')

local colorTable = setmetatable(
	{},

	{__index = function(self, val)
		local r, g, b = GetItemQualityColor(val)
		self[val] = {r, g, b}

		return self[val]
	end},
)

local createBorder = function(self, point)
	local bc = self:CreateTexture(nil, "OVERLAY")
	bc:SetTexture"Interface\\Buttons\\UI-ActionButton-Border"
	bc:SetBlendMode"ADD"
	bc:SetAlpha(.8)

	bc:SetWidth(70)
	bc:SetHeight(70)

	bc:SetPoint("CENTER", point or self)
	self.bc = bc
end

function oGlow:RegisterColor(name, r, g, b)
	colorTable[name] = {r, g, b}
end
