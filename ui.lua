local backdrop = {
	bgFile = [[Interface\ChatFrame\ChatFrameBackground]], tile = true, tileSize = 16,
	edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]], edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4},
}

local frame = CreateFrame('Frame', nil, InterfaceOptionsFramePanelContainer)
frame.name = 'oGlow'
frame:Hide()

frame:SetScript('OnShow', function(self)
	local title = self:CreateFontString(nil, 'ARTWORK', 'GameFontNormalLarge')
	title:SetPoint('TOPLEFT', 16, -16)
	title:SetText'oGlow - Not tested on animals!'

	local subtitle = self:CreateFontString(nil, 'ARTWORK', 'GameFontHighlightSmall')
	subtitle:SetPoint('TOPLEFT', title, 'BOTTOMLEFT', 0, -8)
	subtitle:SetPoint('RIGHT', self, -32, 0)
	subtitle:SetNonSpaceWrap(true)
	subtitle:SetJustifyH'LEFT'
	-- Might be useful later~
	--subtitle:SetText('Configurations are awesome!')

	local scroll = CreateFrame("ScrollFrame", nil, self)
	scroll:SetPoint('TOPLEFT', subtitle, 'BOTTOMLEFT', 0, -8)
	scroll:SetPoint("BOTTOMRIGHT", 0, 4)

	local scrollchild = CreateFrame("Frame", nil, self)
	scrollchild:SetPoint"LEFT"
	scrollchild:SetHeight(scroll:GetHeight())
	scrollchild:SetWidth(scroll:GetWidth())

	scroll:SetScrollChild(scrollchild)
	scroll:UpdateScrollChildRect()
	scroll:EnableMouseWheel(true)

	local _BACKDROP = {
		bgFile = [[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		tile = true, tileSize = 8, edgeSize = 16,
		insets = {left = 2, right = 2, top = 2, bottom = 2}
	}

	local check_OnClick = function(self)
		local pipe = self:GetParent().pipe
		if(self:GetChecked()) then
			oGlow:EnablePipe(pipe)
		else
			oGlow:DisablePipe(pipe)
		end

		oGlow:UpdatePipe(pipe)
	end

	local slider = CreateFrame("Slider", nil, scroll)
	local rows = {}
	local i = 1
	for pipe, active, name, desc in oGlow.IteratePipes() do
		local row = CreateFrame('Button', nil, scrollchild)

		row:SetBackdrop(_BACKDROP)
		row:SetBackdropBorderColor(.3, .3, .3)
		row:SetBackdropColor(.1, .1, .1, .5)

		if(i == 1) then
			row:SetPoint('TOP', 0, -8)
		else
			row:SetPoint('TOP', rows[i-1], 'BOTTOM')
		end

		row:SetPoint('LEFT', 6, 0)
		-- leave some space for the scrollbar.
		row:SetPoint('RIGHT', -30, 0)
		row:SetHeight(24)

		local check = CreateFrame('CheckButton', nil, row)
		check:SetSize(16, 16)
		check:SetPoint('LEFT', 10, 0)
		check:SetPoint('TOP', 0, -4)

		check:SetNormalTexture[[Interface\Buttons\UI-CheckBox-Up]]
		check:SetPushedTexture[[Interface\Buttons\UI-CheckBox-Down]]
		check:SetHighlightTexture[[Interface\Buttons\UI-CheckBox-Highlight]]
		check:SetCheckedTexture[[Interface\Buttons\UI-CheckBox-Check]]

		check:RegisterForClicks('LeftButtonUp', 'RightButtonUp')
		check:SetChecked(active)

		check:SetScript('OnClick', check_OnClick)
		row.check = check

		local label = row:CreateFontString(nil, nil, 'GameFontHighlight')
		label:SetPoint('LEFT', check, 'RIGHT', 5, -1)
		label:SetJustifyH'LEFT'
		label:SetText(name)
		row.label = labela

		row.pipe = pipe

		rows[i] = row
		i = i + 1
	end
	self.rows = rows

	slider:SetWidth(16)

	slider:SetPoint("TOPRIGHT", -8, -24)
	slider:SetPoint("BOTTOMRIGHT", -8, 24)

	local up = CreateFrame("Button", nil, slider)
	up:SetPoint("BOTTOM", slider, "TOP")
	up:SetSize(16, 16)
	up:SetNormalTexture[[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Up]]
	up:SetPushedTexture[[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Down]]
	up:SetDisabledTexture[[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Disabled]]
	up:SetHighlightTexture[[Interface\Buttons\UI-ScrollBar-ScrollUpButton-Highlight]]

	up:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	up:GetHighlightTexture():SetBlendMode("ADD")

	up:SetScript("OnClick", function(self)
		local box = self:GetParent()
		box:SetValue(box:GetValue() - box:GetHeight()/2)
		PlaySound("UChatScrollButton")
	end)

	local down = CreateFrame("Button", nil, slider)
	down:SetPoint("TOP", slider, "BOTTOM")
	down:SetSize(16, 16)
	down:SetNormalTexture[[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Up]]
	down:SetPushedTexture[[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Down]]
	down:SetDisabledTexture[[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Disabled]]
	down:SetHighlightTexture[[Interface\Buttons\UI-ScrollBar-ScrollDownButton-Highlight]]

	down:GetNormalTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetPushedTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetDisabledTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetHighlightTexture():SetTexCoord(1/4, 3/4, 1/4, 3/4)
	down:GetHighlightTexture():SetBlendMode("ADD")

	down:SetScript("OnClick", function(self)
		local box = self:GetParent()
		box:SetValue(box:GetValue() + box:GetHeight()/2)
		PlaySound("UChatScrollButton")
	end)

	slider:SetThumbTexture[[Interface\Buttons\UI-ScrollBar-Knob]]
	local thumb = slider:GetThumbTexture()
	thumb:SetSize(16, 24)
	thumb:SetTexCoord(1/4, 3/4, 1/8, 7/8)

	slider:SetScript("OnValueChanged", function(self, val, ...)
		local min, max = self:GetMinMaxValues()
		if(val == min) then up:Disable() else up:Enable() end
		if(val == max) then down:Disable() else down:Enable() end

		scroll.value = val
		scroll:SetVerticalScroll(val)
		scrollchild:SetPoint('TOP', 0, val)
	end)

	slider:SetMinMaxValues(0,550)
	slider:SetValue(0)

	self:SetScript('OnShow', nil)
end)

InterfaceOptions_AddCategory(frame)

SLASH_OGLOW_UI1 = '/oglow'
SlashCmdList['OGLOW_UI'] = function()
	InterfaceOptionsFrame_OpenToCategory'oGlow'
end
