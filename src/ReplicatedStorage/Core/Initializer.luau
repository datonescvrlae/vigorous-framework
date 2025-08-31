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

local Vigorous = require(game.ReplicatedStorage.Vigorous)
local module = {}

local function LoadModuleScript(moduleScript: ModuleScript)
	--// The pcall here helps us catch any errors the scripts might experience during requiring
	--// It's important we know this to know if we should proceed with processing
	local Module
	local success, _ = pcall(function()
		Module = require(moduleScript) --// Attempt to require the module
	end)

	
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

	Vigorous.IsLoaded = true --// After loading set this key to true
end

return module
