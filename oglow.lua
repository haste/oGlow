local _VERSION = GetAddOnMetadata('oGlow', 'version')

local function argcheck(value, num, ...)
	assert(type(num) == 'number', "Bad argument #2 to 'argcheck' (number expected, got "..type(num)..")")

	for i=1,select("#", ...) do
		if type(value) == select(i, ...) then return end
	end

	local types = strjoin(", ", ...)
	local name = string.match(debugstack(2,2,0), ": in function [`<](.-)['>]")
	error(("Bad argument #%d to '%s' (%s expected, got %s"):format(num, name, types, type(value)), 3)
end

local print = function(...) print("|cff33ff99oGlow:|r ", ...) end
local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end

local pipesTable = {}
local filtersTable = {}
local activeFilters = {}

local colorTable = setmetatable(
	{},

	-- We mainly want to handle item quality coloring, so this acts as a fallback.
	-- The bonus of doing this is that we don't really have to make any updates to
	-- the add-on if any new item colors are added. It also caches unlike the old
	-- version.
	{__index = function(self, val)
		argcheck(val, 2, 'string', 'number')
		local r, g, b = GetItemQualityColor(val)
		self[val] = {r, g, b}

		return self[val]
	end}
)

local event_metatable = {
	__call = function(funcs, self, ...)
		for _, func in ipairs(funcs) do
			func(self, ...)
		end
	end,
}

local createBorder = function(self, point)
	local bc = self.oGlowBC
	if(not bc) then
		if(not self:IsObjectType'Frame') then
			bc = self:GetParent():CreateTexture(nil, 'OVERLAY')
		else
			bc = self:CreateTexture(nil, "OVERLAY")
		end

		bc:SetTexture"Interface\\Buttons\\UI-ActionButton-Border"
		bc:SetBlendMode"ADD"
		bc:SetAlpha(.8)

		bc:SetWidth(70)
		bc:SetHeight(70)

		bc:SetPoint("CENTER", point or self)
		self.oGlowBC = bc
	end

	return bc
end

local oGlow = CreateFrame('Frame', 'oGlow')
function oGlow:RegisterColor(name, r, g, b)
	argcheck(name, 2, 'string', 'number')
	argcheck(r, 3, 'number')
	argcheck(g, 4, 'number')
	argcheck(b, 5, 'number')

	-- Silently fail.
	if(colorTable[name]) then
		return nil, string.format('Color [%s] is already registered.', name)
	else
		colorTable[name] = {r, g, b}
	end

	return true
end

--[[ Event API ]]

local RegisterEvent = oGlow.RegisterEvent
function oGlow:RegisterEvent(event, func)
	argcheck(event, 2, 'string')

	if(type(func) == 'string' and type(self[func]) == 'function') then
		func = self[func]
	end

	local curev = self[event]
	if(curev and func) then
		if(type(curev) == 'function') then
			self[event] = setmetatable({curev, func}, event_metatable)
		else
			for _, infunc in ipairs(curev) do
				if(infunc == func) then return end
			end

			table.insert(curev, func)
		end
	elseif(self:IsEventRegistered(event)) then
		return
	else
		if(func) then
			self[event] = func
		elseif(not self[event]) then
			error("Handler for event [%s] does not exist.", event)
		end

		RegisterEvent(self, event)
	end
end

local UnregisterEvent = oGlow.UnregisterEvent
function oGlow:UnregisterEvent(event, func)
	argcheck(event, 2, 'string')

	local curev = self[event]
	if(type(curev) == 'table' and func) then
		for k, infunc in ipairs(curev) do
			if(infunc == func) then
				curev[k] = nil

				if(#curev == 0) then
					table.remove(curev, k)
					UnregisterEvent(self, event)
				end
			end
		end
	else
		self[event] = nil
		UnregisterEvent(self, event)
	end
end

oGlow:SetScript('OnEvent', function(self, event, ...)
	self[event](self, event, ...)
end)

--[[ Pipe API ]]

function oGlow:RegisterPipe(pipe, enable, disable, update)
	argcheck(pipe, 2, 'string')
	argcheck(enable, 3, 'function')
	argcheck(disable, 4, 'function', 'nil')
	argcheck(update, 5, 'function')

	-- Silently fail.
	if(pipesTable[pipe]) then
		return nil, string.format('Pipe [%s] is already registered.')
	else
		pipesTable[pipe] = {
			enable = enable;
			disable = disable;
			update = update;
		}
	end

	return true
end

function oGlow:EnablePipe(pipe)
	argcheck(pipe, 2, 'string')

	local ref = pipesTable[pipe]
	if(ref and not ref.isActive) then
		ref.enable(self)
		ref.isActive = true

		return true
	end
end

function oGlow:DisablePipe(pipe)
	argcheck(pipe, 2, 'string')

	local ref = pipesTable[pipe]
	if(ref and ref.isActive) then
		if(ref.disable) then ref.disable(self) end
		ref.isActive = nil

		return true
	end
end

function oGlow:IsPipeEnabled(pipe)
	argcheck(pipe, 2, 'string')

	return pipesTable[pipe].isActive
end

function oGlow:UpdatePipe(pipe)
	argcheck(pipe, 2, 'string')

	local ref = pipesTable[pipe]
	if(ref and ref.isActive) then
		ref.update(self)

		return true
	end
end

--[[ Filter API ]]

function oGlow:RegisterFilter(name, filter)
	argcheck(name, 2, 'string')
	argcheck(filter, 3, 'function')

	if(filtersTable[name]) then return nil, 'Filter function is already registered.' end
	filtersTable[name] = filter

	return true
end

function oGlow:RegisterFilterOnPipe(pipe, filter)
	argcheck(pipe, 2, 'string')
	argcheck(filter, 3, 'string')

	if(not pipesTable[pipe]) then return nil, 'Pipe does not exist.' end
	if(not filtersTable[filter]) then return nil, 'Filter does not exist.' end
	if(not activeFilters[pipe]) then
		activeFilters[pipe] = {}
		table.insert(activeFilters[pipe], filtersTable[filter])
	else
		filter = filtersTable[filter]
		local ref = activeFilters[pipe]

		for _, func in ipairs(ref) do
			if(func == filter) then
				return nil, 'Filter function is already registered.'
			end
		end

		table.insert(ref, filter)
		return true
	end
end

function oGlow:UnregisterFilterOnPipe(pipe, filter)
	argcheck(pipe, 2, 'string')
	argcheck(filter, 3, 'string')

	if(not pipesTable[pipe]) then return nil, 'Pipe does not exist.' end
	if(not filtersTable[filter]) then return nil, 'Filter does not exist.' end

	local ref = activeFilters[pipe]
	if(ref) then
		filter = filtersTable[filter]

		for k, func in ipairs(ref) do
			if(func == filter) then
				table.remove(ref, k)
				return true
			end
		end
	end
end

-- Probably very temporary.
function oGlow:CallFilters(pipe, frame, ...)
	argcheck(pipe, 2, 'string')

	if(not pipesTable[pipe]) then return nil, 'Pipe does not exist.' end

	local ref = activeFilters[pipe]
	if(ref) then
		for _, func in ipairs(ref) do
			local color = func(...)

			if(color) then
				local bc = createBorder(frame)
				local rgb = colorTable[color]

				if(rgb) then
					bc:SetVertexColor(rgb[1], rgb[2], rgb[3])
					bc:Show()

					-- The other filters lost the game.
					break
				end
			elseif(frame.oGlowBC) then
				frame.oGlowBC:Hide()
			end
		end
	end
end

oGlow.version = _VERSION
