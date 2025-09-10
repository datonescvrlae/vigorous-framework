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
local module = Vigorous:Register("Core.Console")

local LogLevel = Vigorous:GetModule("Core.LogLevel")

function module.log(logLevel: string, message: string)
       if typeof(message) ~= "string" or typeof(logLevel) ~= "string" then return end

       local NewLogLevel = LogLevel.new(logLevel) --// Construct a new object from the LogLevel class

       --// Make sure that the given log level is a valid one aka we have an object
       --// If the log level object is nil that means it was invalid
       if NewLogLevel then
              local timestamp = os.date("[%H:%M:%S]")

       --// We can get the script that called the .log() function through the debug library

       --// It's important to note that that will return the whole path that we need to split first
       --// Only then we can go ahead and grab the last position which is the script's name
              local sourceArray = string.split(debug.info(2, "s"), ".")
              local logSource = sourceArray[#sourceArray]
              
              local concatMessage = timestamp .." [".. logSource .."/".. logLevel .."]: ".. message

       --// Log the concated message using the correct logger function
              NewLogLevel.log(concatMessage)
       end
end

return module
