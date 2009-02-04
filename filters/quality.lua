local quality = function(itemLink)
	local _, _, quality = GetItemInfo(itemLink)

	if(quality > 1) then
		return quality
	end
end

oGlow:RegisterFilter('quality', quality)
