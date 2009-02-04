local quality = function(...)
	local quality = -1

	for i=1, select('#', ...) do
		local itemLink = select(i, ...)

		if(itemLink) then
			local _, _, itemQuality= GetItemInfo(itemLink)
			quality = math.max(quality, itemQuality)
		end
	end

	if(quality > 1) then
		return quality
	end
end

oGlow:RegisterFilter('quality', quality)
