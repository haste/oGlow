local update = function(self, event)
	if(MerchantFrame:IsShown()) then
		if(MerchantFrame.selectedTab == 1) then
			for i=1, MERCHANT_ITEMS_PER_PAGE do
				local index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
				local itemLink = GetMerchantItemLink(index)
				local slotFrame = _G['MerchantItem' .. i .. 'ItemButton']

				self:CallFilters('merchant', slotFrame, itemLink)
			end
		else
			for i=1, BUYBACK_ITEMS_PER_PAGE do
				local itemLink = GetBuybackItemInfo(i)
				local slotFrame = _G['MerchantItem' .. i .. 'ItemButton']

				self:CallFilters('merchant', slotFrame, itemLink)
			end
		end
	end
end

local enable = function(self)
	self:RegisterEvent('MERCHANT_UPDATE', update)
	self:RegisterEvent('MERCHANT_SHOW', update)
end

local disable = function(self)
	self:UnregisterEvent('MERCHANT_UPDATE', update)
	self:UnregisterEvent('MERCHANT_SHOW', update)
end

oGlow:RegisterPipe('merchant', enable, disable, update)
