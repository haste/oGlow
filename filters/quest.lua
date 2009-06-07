local quest = function(...)
	for i=1, select('#', ...) do
		local itemLink = select(i, ...)

		if(itemLink) then
			local _, _, _, _, _, type = GetItemInfo(itemLink)
			if(type == 'Quest') then
				return 'Quest'
			end
		end
	end
end

oGlow:RegisterColor('Quest', 1, 1, 0)
oGlow:RegisterFilter('quest', 'Border', quest, [[]])
