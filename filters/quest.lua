local questString = ITEM_BIND_QUEST

local tip = _G.oGlowTip
if(not tip) then
	tip = CreateFrame('GameTooltip', 'oGlowTip')
	tip:SetOwner(WorldFrame, 'ANCHOR_NONE')
	tip.r, tip.l = {}, {}

	for i=1,3 do
		tip.l[i], tip.r[i] = tip:CreateFontString(nil, nil, "GameFontNormal"), tip:CreateFontString(nil, nil, "GameFontNormal")
		tip:AddFontStrings(tip.l[i], tip.r[i])
	end
end

local quest = function(...)
	for i=1, select('#', ...) do
		local itemLink = select(i, ...)

		if(itemLink) then
			tip:ClearLines()
			tip:SetHyperlink(itemLink)

			if(tip:NumLines() > 1 and tip.l[2]:GetText() == questString) then
				return 'Quest'
			end
		end
	end
end

oGlow:RegisterColor('Quest', 1, 1, 0)
oGlow:RegisterFilter('quest', 'Border', quest, [[]])
