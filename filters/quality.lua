local quality = function(itemLink)
	if(itemLink) then
		local _, _, quality = GetItemInfo(itemLink)

		if(quality > 1) then
			return quality
		end
	end
end

oGlow:RegisterFilter('quality', quality)
