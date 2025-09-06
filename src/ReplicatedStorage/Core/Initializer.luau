--[[

	This code was written by Scvrlae (@datonescvrlae) and is his property. Unauthorized use and/or
	distribution of this script is strongly prohibited! PLEASE ask first!

	  ██████  ▄████▄ ██▒   █▓ ██▀███   ██▓    ▄▄▄      ▓█████
	▒██    ▒ ▒██▀ ▀█▓██░   █▒▓██ ▒ ██▒▓██▒   ▒████▄    ▓█   ▀
	░ ▓██▄   ▒▓█    ▄▓██  █▒░▓██ ░▄█ ▒▒██░   ▒██  ▀█▄  ▒███
	  ▒   ██▒▒▓▓▄ ▄██▒▒██ █░░▒██▀▀█▄  ▒██░   ░██▄▄▄▄██ ▒▓█  ▄
	▒██████▒▒▒ ▓███▀ ░ ▒▀█░  ░██▓ ▒██▒░██████▒▓█   ▓██▒░▒████▒

	This script is part of the Vigorous framework owned and maintained by Scvrlae (@datonescvrlae).
	It is public and available for use by anyone for their games!

--]]

local Vigorous = require(game.ReplicatedStorage.Vigorous) --// Core module of the Vigorous framework
local module = {}

local function ConstructObject(Module: { [any]: any }, ...: any?): { [any]: any }
	--// Create a clone of the class module and use that as a base for the new object
	local NewObject = table.clone(Module)

	NewObject.new = nil --// We dont need it to have the .new() function

	--// Finally call the system constructor function and return the new object
	--// We don't need to reassign the NewObject var here btw
	Module.System.new(NewObject, ...)
	return NewObject
end

local function LoadModuleScript(moduleScript: ModuleScript)
	--// The pcall here helps us catch any errors the scripts might experience during requiring
	--// It's important we know this to know if we should proceed with processing
	local Module
	local success, _ = pcall(function()
		Module = require(moduleScript) --// Attempt to require the module
	end)

	--// Skip the processing for this module if it fails or doesn't have a system table
	if not success or not Module.System then return end

	if Module.System.new then
	--// We wanna abstract Module.new() to only take arguments needed for construction of the object
	
	--// To do so we need to set it to a new function that only takes those arguments
	--// and then inside we call the actual constructor that also takes the module as an additional argument
		Module.new = function(...: any?): { [any]: any }
			return ConstructObject(Module, ...)
		end
	end --// Please don't laugh at my way of implementing OOP if it works it works alright

	if Module.System.Require then
		Module.System:Require() --// Run the require system function
	end
end

function module:Start(localDirectory: PlayerScripts | ServerScriptService)
    	local directoriesToLoad = {
	--// The order all of these are in is very important
	--// We wanna make sure local directories are loaded before the shared ones
		localDirectory.Core,
		script.Parent,

		localDirectory.Modules, --// Use modules folders for game scripts!
		game.ReplicatedStorage.Modules
	}

	--// Iterate through every directory one by one, find all modules and load them
	for _, directory in directoriesToLoad do
		for _, findObject in directory:GetDescendants() do
			if not findObject:IsA("ModuleScript") then continue end

	--// After the previous if statement we're sure that the object is a module script
	--// That means we can safely call the LoadModuleScript function on it
			LoadModuleScript(findObject)
		end
	end

	Vigorous:GetModule("Core.Console").log("Test", "test")

	Vigorous.IsLoaded = true --// After loading set this key to true
end

return module
