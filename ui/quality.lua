local _, ns = ...
local oGlow = ns.oGlow

local colorTable = ns.colorTable

local frame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
frame:Hide()
frame.name = 'Quality'
frame.parent = 'oGlow'

local Hex = function(r, g, b)
	if(type(r) == "table") then
		if(r.r) then
			r, g, b = r.r, r.g, r.b
		else
			r, g, b = unpack(r)
		end
	end

	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

frame:SetScript('OnShow', function(self)
	self:CreateOptions()
	self:SetScript('OnShow', nil)
end)

local createFontString = function(parent, template)
	local label = parent:CreateFontString(nil, nil, template or 'GameFontHighlight')
	label:SetJustifyH'LEFT'

	return label
end

function frame:CreateOptions()
	local title = createFontString(self, 'GameFontNormalLarge')
	title:SetPoint('TOPLEFT', 16, -16)
	title:SetText'oGlow: Quality filter'

	local thresLabel = createFontString(self, 'GameFontNormalSmall')
	thresLabel:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -16)
	thresLabel:SetText('Quality Threshold')

	local thesDDown = CreateFrame('Button', 'oGlowOptFQualityThreshold', self, 'UIDropDownMenuTemplate')
	thesDDown:SetPoint('TOPLEFT', thresLabel, 'BOTTOMLEFT', -16, 0)

	do
		local DropDown_OnClick = function(self)
			oGlowDB.FilterSettings.quality = self.value - 1
			oGlow:CallOptionCallbacks()
			UIDropDownMenu_SetSelectedID(self:GetParent().dropdown, self:GetID())
		end

		local DropDown_OnEnter = function(self)
			GameTooltip:SetOwner(self, 'ANCHOR_TOPLEFT')
			GameTooltip:SetText('Controls the lowest item quality color that should be displayed.', nil, nil, nil, nil, 1)
		end

		local DropDown_OnLeave = GameTooltip_Hide

		local UpdateSelected = function(self)
			local filters = oGlowDB.FilterSettings
			local threshold = 1
			if(filters and filters.quality) then
				threshold = filters.quality
			end

			UIDropDownMenu_SetSelectedID(thesDDown, threshold + 2)
		end

		local DropDown_init = function(self)
			local info

			for i=0,7 do
				info = UIDropDownMenu_CreateInfo()
				info.text = Hex(colorTable[i]) .._G['ITEM_QUALITY' .. i .. '_DESC']
				info.value = i
				info.func = DropDown_OnClick

				UIDropDownMenu_AddButton(info)
			end
		end

		thesDDown:SetScript('OnEnter', DropDown_OnEnter)
		thesDDown:SetScript('OnLeave', DropDown_OnLeave)

		function frame:refresh()
			UIDropDownMenu_Initialize(thesDDown, DropDown_init)
			UpdateSelected()
		end
		self:refresh()
	end
end

InterfaceOptions_AddCategory(frame)
