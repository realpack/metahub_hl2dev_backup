if TRIGON then return end

net.Receive("TL.sayColor",function()
	chat.AddText(unpack(net.ReadTable()))
end)

if SERVER then
util.AddNetworkString("TL.sayColor")


local function sayColor(targ, ...)
	local args = {...}
	-- PrintTable(args)
	net.Start("TL.sayColor")
		net.WriteTable(IsColor(args[1]) and args or args[1])
	net[targ and "Send" or "Broadcast"](targ)
end

local PLAYER = FindMetaTable("Player")
function PLAYER:ChatPrintColor(...)
	sayColor(self, ...)
end

chat = chat or {}
function chat.AddTextSV(...)
	sayColor(nil,...)
end
end