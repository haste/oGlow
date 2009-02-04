local quality = function(...)
	local quality

	for i=1, select('#', ...) do
		local itemLink = select(i, ...)

		if(itemLink) then
			local _, _, itemQuality= GetItemInfo(itemLink)
			if(quality) then
				quality = math.max(quality, itemQuality)
			else
				quality = itemQuality
			end
		end
	end

	if(quality > 1) then
		return quality
	end
end

oGlow:RegisterFilter('quality', quality)
