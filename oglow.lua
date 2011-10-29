local _, ns = ...
local oGlow = ns.oGlow

local _VERSION = GetAddOnMetadata('oGlow', 'version')

local argcheck = oGlow.argcheck

local print = function(...) print("|cff33ff99oGlow:|r ", ...) end
local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end

local pipesTable = ns.pipesTable
local filtersTable = {}
local displaysTable = {}

local numFilters = 0

local activeFilters = {}

local event_metatable = {
	__call = function(funcs, self, ...)
		for _, func in pairs(funcs) do
			func(self, ...)
		end
	end,
}

local ADDON_LOADED = function(self, event, addon)
	if(addon == 'oGlow') then
		if(not oGlowDB) then
			oGlowDB = {
				version = 0,
				EnabledPipes = {},
				EnabledFilters = {},
			}

			for pipe in next, pipesTable do
				self:EnablePipe(pipe)

				for filter in next, filtersTable do
					self:RegisterFilterOnPipe(pipe, filter)
				end
			end
		else
			for pipe in next, oGlowDB.EnabledPipes do
				self:EnablePipe(pipe)

				for filter, enabledPipes in next, oGlowDB.EnabledFilters do
					if(enabledPipes[pipe]) then
						self:RegisterFilterOnPipe(pipe, filter)
						break
					end
				end
			end
		end
	end
end

--[[ Filter API ]]

function oGlow:RegisterFilter(name, type, filter, desc)
	argcheck(name, 2, 'string')
	argcheck(type, 3, 'string')
	argcheck(filter, 4, 'function')
	argcheck(desc, 5, 'string', 'nil')

	if(filtersTable[name]) then return nil, 'Filter function is already registered.' end
	filtersTable[name] = {type, filter, name, desc}

	numFilters = numFilters + 1

	return true
end

do
	local function iter(_, n)
		local n, t = next(filtersTable, n)
		if(t) then
			return n, t[1], t[4]
		end
	end

	function oGlow.IterateFilters()
		return iter, nil, nil
	end
end

-- TODO: Validate that the display we try to use actually exists.
function oGlow:RegisterFilterOnPipe(pipe, filter)
	argcheck(pipe, 2, 'string')
	argcheck(filter, 3, 'string')

	if(not pipesTable[pipe]) then return nil, 'Pipe does not exist.' end
	if(not filtersTable[filter]) then return nil, 'Filter does not exist.' end

	-- XXX: Clean up this logic.
	if(not activeFilters[pipe]) then
		local filterTable = filtersTable[filter]
		local display = filterTable[1]
		activeFilters[pipe] = {}
		activeFilters[pipe][display] = {}
		table.insert(activeFilters[pipe][display], filterTable)
	else
		local filterTable = filtersTable[filter]
		local ref = activeFilters[pipe][filterTable[1]]

		for _, func in next, ref do
			if(func == filter) then
				return nil, 'Filter function is already registered.'
			end
		end
		table.insert(ref, filterTable)
	end

	if(not oGlowDB.EnabledFilters[filter]) then
		oGlowDB.EnabledFilters[filter] = {}
	end
	oGlowDB.EnabledFilters[filter][pipe] = true

	return true
end

oGlow.IterateFiltersOnPipe = function(pipe)
	local t = activeFilters[pipe]
	return coroutine.wrap(function()
		if(t) then
			for _, sub in next, t do
				for k, v in next, sub do
					coroutine.yield(v[3], v[1], v[4])
				end
			end
		end
	end)
end

function oGlow:UnregisterFilterOnPipe(pipe, filter)
	argcheck(pipe, 2, 'string')
	argcheck(filter, 3, 'string')

	if(not pipesTable[pipe]) then return nil, 'Pipe does not exist.' end
	if(not filtersTable[filter]) then return nil, 'Filter does not exist.' end

	--- XXX: Be more defensive here.
	local filterTable = filtersTable[filter]
	local ref = activeFilters[pipe][filterTable[1]]
	if(ref) then
		for k, func in next, ref do
			if(func == filterTable) then
				table.remove(ref, k)
				oGlowDB.EnabledFilters[filter][pipe] = nil

				return true
			end
		end
	end
end

function oGlow:GetNumFilters()
	return numFilters
end

--[[ Display API ]]

function oGlow:RegisterDisplay(name, display)
	argcheck(name, 2, 'string')
	argcheck(display, 3, 'function')

	displaysTable[name] = display
end

--[[ General API ]]

function oGlow:CallFilters(pipe, frame, ...)
	argcheck(pipe, 2, 'string')

	if(not pipesTable[pipe]) then return nil, 'Pipe does not exist.' end

	local ref = activeFilters[pipe]
	if(ref) then
		for display, filters in next, ref do
			-- TODO: Move this check out of the loop.
			if(not displaysTable[display]) then return nil, 'Display does not exist.' end

			for i=1,#filters do
				local func = filters[i][2]

				-- drop out of the loop if we actually do something nifty on a frame.
				if(displaysTable[display](frame, func(...))) then break end
			end
		end
	end
end

oGlow:RegisterEvent('ADDON_LOADED', ADDON_LOADED)

oGlow.argcheck = argcheck

oGlow.version = _VERSION
_G.oGlow = oGlow
