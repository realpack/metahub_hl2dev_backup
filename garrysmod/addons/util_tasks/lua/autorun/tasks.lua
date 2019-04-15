if (SERVER) then
	AddCSLuaFile()
	AddCSLuaFile("tasks/load.lua")
end

include("tasks/load.lua")