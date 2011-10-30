local _, ns = ...
local oGlow = ns.oGlow

ns.createFontString = function(parent, template)
	local label = parent:CreateFontString(nil, nil, template or 'GameFontHighlight')
	label:SetJustifyH'LEFT'

	return label
end
