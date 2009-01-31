local oGlow = CreateFrame('Frame', 'oGlow')

local colorTable = setmetatable(
	{},

	-- We mainly want to handle item quality coloring, so this acts as a fallback.
	-- The bonus of doing this is that we don't really have to make any updates to
	-- the add-on if any new item colors are added. It also caches unlike the old
	-- version.
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
	self.oGlowBC = bc
end


function oGlow:RegisterColor(name, r, g, b)
	colorTable[name] = {r, g, b}
end
