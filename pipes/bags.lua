local hook

local update = function(self)
	if(oGlow:IsPipeEnabled'bags') then
		local id = self:GetID()
		local name = self:GetName()
		local size = self.size

		for i=1, size do
			local bid = size - i + 1
			local slotFrame = _G[name .. 'Item' .. bid]
			local slotLink = GetContainerItemLink(id, i)

			oGlow:CallFilters('bags', slotFrame, slotLink)
		end
	end
end

local enable = function(self)
	if(not hook) then
		hooksecurefunc("ContainerFrame_Update", update)
		hook = true
	end
end

-- ....
local disable = function()
end

oGlow:RegisterPipe('bags', enable, disable, update)
