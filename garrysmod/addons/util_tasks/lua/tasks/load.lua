Tasks = Tasks or {}

Tasks.IncludeSV = (SERVER) and include or function() end
Tasks.IncludeCL = (SERVER) and AddCSLuaFile or include
Tasks.IncludeSH = function(path) 
	Tasks.IncludeSV(path) 
	Tasks.IncludeCL(path)
end

local files, folders = file.Find("tasks/plugins/*", "LUA")
for k, v in ipairs(folders) do
	Tasks.IncludeSH("plugins/" .. v .. "/sh_load.lua")
	print("Tasks | Loaded plugin: " .. v)
end


Tasks.Config = Tasks.Config or {}
Tasks.IncludeSH("sh_config.lua")
Tasks.IncludeSV("sv_config.lua")
Tasks.IncludeSV("data/sv_data.lua")

Tasks.Language = Tasks.Language or {}
Tasks.IncludeSH("languages/" .. Tasks.Config.Language .. ".lua")

function Tasks.GetPhrase(phrase)
	return Tasks.Language[phrase]
end

function Tasks.RPCash(amount)
	return function(ply) ply:addMoney(amount) end
end

function Tasks.PS1(amount)
	return function(ply) ply:PS_GivePoints(amount) end
end

function Tasks.PS2(amount)
	return function(ply) ply:PS2_AddStandardPoints(amount) end
end

function Tasks.PS2_Premium(amount)
	return function(ply) ply:PS2_AddPremiumPoints(amount) end
end

function Tasks.ULXGroup(group)
	return function(ply) RunConsoleCommand("ulx", "adduserid", ply:SteamID(), group) end
end

local currency = Tasks.Config.DefaultReward
if currency == "darkrp" then
	Tasks.DefaultRewardFunc = Tasks.RPCash
elseif currency == "ps1" then
	Tasks.DefaultRewardFunc = Tasks.PS1
elseif currency == "ps2" then
	Tasks.DefaultRewardFunc = Tasks.PS2
elseif currency == "ps2_premium" then
	Tasks.DefaultRewardFunc = Tasks.PS2_Premium
end

Tasks.IncludeSH("tasks.lua")

Tasks.IncludeSH("core/sh_time.lua")

Tasks.IncludeCL("ui/frame.lua")
Tasks.IncludeCL("ui/cl_menu.lua")

Tasks.IncludeCL("core/cl_tasks.lua")
Tasks.IncludeSV("core/sv_tasks.lua")


print("Tasks | Loaded")