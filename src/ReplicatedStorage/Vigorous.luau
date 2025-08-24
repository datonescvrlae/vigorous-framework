--[[

	This code was written by Scvrlae (@datonescvrlae) and is his property. Unauthorized use and/or
	distribution of this script is strongly prohibited! PLEASE ask first!

	  ██████  ▄████▄ ██▒   █▓ ██▀███   ██▓    ▄▄▄      ▓█████
	▒██    ▒ ▒██▀ ▀█▓██░   █▒▓██ ▒ ██▒▓██▒   ▒████▄    ▓█   ▀
	░ ▓██▄   ▒▓█    ▄▓██  █▒░▓██ ░▄█ ▒▒██░   ▒██  ▀█▄  ▒███
	  ▒   ██▒▒▓▓▄ ▄██▒▒██ █░░▒██▀▀█▄  ▒██░   ░██▄▄▄▄██ ▒▓█  ▄
	▒██████▒▒▒ ▓███▀ ░ ▒▀█░  ░██▓ ▒██▒░██████▒▓█   ▓██▒░▒████▒

	This script is part of the Vigorous framework owned and maintained by Scvrlae (@datonescvrlae).
	It is private and only given out to select individuals that want it!

--]]

local module = {
	IsLoaded = false -- Defines whether the core is fully loaded or not
}

local moduleRegistry = {}

function module:Register(moduleName: string, moduleData: { [any]: any}? ): { [any]: any }
	if typeof(moduleName) ~= "string" then return end
	if moduleData and typeof(moduleData) ~= "table" then return end

	-- The Module var will always end up being an empty table here but there's a difference

	-- If a module is already in the registry that means a script already tried to fetch it
	-- and so we NEED to use that stored table instead of a completely fresh one
	local Module = moduleRegistry[moduleName] or {}

	Module.System = {} -- Table for things like the constructor function and so on
	Module.ClassName = moduleName

	for key, value in moduleData or {} do
		Module[key] = value
	end

	-- Besides the obvious storing we also return the module so the script can continue editing it
	moduleRegistry[moduleName] = Module
	return Module
end

function module:GetModule(moduleName: string): { [any]: any }?
	if typeof(moduleName) ~= "string" then return end

	local Module = moduleRegistry[moduleName]

	-- If no module with the name is found and ONLY if core is still in the loading phase
	-- then we insert a temporary module table into the registry

	-- This allows using :GetModule() at the top of the script even if the module is registered later
	if not Module and not module.IsLoaded then
		local TempModule = {}

		moduleRegistry[moduleName] = TempModule
		return TempModule
	end

	return Module -- Return the found module or nil if not found
end

return module
