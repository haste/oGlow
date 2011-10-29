local _, ns = ...
local oGlow = ns.oGlow

local _VERSION = GetAddOnMetadata('oGlow', 'version')

local argcheck = oGlow.argcheck

local print = function(...) print("|cff33ff99oGlow:|r ", ...) end
local error = function(...) print("|cffff0000Error:|r "..string.format(...)) end

local pipesTable = ns.pipesTable
local filtersTable = ns.filtersTable
local displaysTable = ns.displaysTable

local numFilters = 0

local activeFilters = ns.activeFilters

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
