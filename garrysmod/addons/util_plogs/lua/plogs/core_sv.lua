util.AddNetworkString('plogs.Console')
util.AddNetworkString('plogs.OpenMenu')
util.AddNetworkString('plogs.LogData')

function plogs.OpenMenu(pl)
	local c = 0
	for k, v in pairs(plogs.data) do
		timer.Simple(0.05 * c, function()
			if IsValid(pl) then
				net.Start('plogs.OpenMenu')
					net.WriteString(k)
					local data = plogs.Encode(v)
					local size = data:len()
					net.WriteUInt(size, 16)
					net.WriteData(data, size)
				net.Send(pl)
			end
		end)
		c = c + 1
	end
end

function plogs.OpenData(title, dat)
	net.Start('plogs.LogData')
		net.WriteString(title)
		local data = plogs.Encode(dat)
		local size = data:len()
		net.WriteUInt(size, 16)
		net.WriteData(data, size)
	net.Send(pl)
end

hook.Add('PlayerSay', 'plogs.PlayerSay', function(pl, text)
	if (text ~= '') and (string.sub(text, 1, string.len(plogs.cfg.Command) + 1) == '/' .. plogs.cfg.Command) or (string.sub(text, 1, string.len(plogs.cfg.Command) + 1) == '!' .. plogs.cfg.Command) then
		if not plogs.HasPerms(pl) then 
			pl:ChatPrint('You do not have permission to use plogs!')
			return ''
		end
		plogs.OpenMenu(pl)
		return ''
	end
end)

local commands = {
	['playerevents'] = function(pl, args)
		if not args[2] then return end
		plogs.sql.LoadLogs(util.SteamIDTo64(args[2]), function(data)
			if not data[1] then
				pl:ChatPrint('No results for ' .. args[2])
			else
				plogs.OpenData('Player Events for ' ..  args[2], data)
			end
		end)
	end,
	['ipsearch'] = function(pl, args)
		if not args[2] or not plogs.cfg.IPUserGroups[string.lower(pl:GetUserGroup())] then return end
		plogs.sql.LoadIPs(util.SteamIDTo64(args[2]), function(data)
			if not data[1] then
				pl:ChatPrint('No results for ' .. args[2])
			else	
				plogs.OpenData('IP logs for ' ..  args[2], data)
			end
		end)
	end,
	['menu'] = function(pl)
		if not plogs.HasPerms(pl) then 
			pl:ChatPrint('You do not have permission to use plogs!')
			return
		end
		plogs.OpenMenu(pl)
	end,
	['info'] = function()
		pl:ChatPrint('[pLogs] Version: ' .. plogs.Version .. ' Licensed to FREE VERSION')
	end
}

concommand.Add('plogs', function(pl, cmd, args)
	if not args[1] then return end

	local cmd = commands[string.lower(args[1])]
	if cmd then
		cmd(pl, args)
	end
end)

function plogs.Log(type, str, copy)
	table.insert(plogs.data[type], 1, {
		Date = os.date('%I:%M:%S', os.time()), 
		Data = str, 
		Copy = copy
	})

	if (#plogs.data[type] > plogs.cfg.LogLimit) then
		table.remove(plogs.data[type])
	end

	if plogs.types[type].Network then
		net.Start('plogs.Console')
			net.WriteString(type)
			net.WriteString(str)
		net.Send(plogs.GetStaff())
		
		if plogs.cfg.EchoServer then
			MsgC(plogs.types[type].Color, '[' .. type .. ' | ' .. os.date('%I:%M:%S', os.time()) ..  ']', color_white, str .. '\n')
		end
	end
end

function plogs.PlayerLog(pl, type, str, copy)
	plogs.Log(type, str, copy)

	if plogs.cfg.EnableMySQL and IsValid(pl) then
		plogs.sql.Log(pl:SteamID64(), str)
	end
end

function plogs.HasPerms(pl)
	if not IsValid(pl) then return false end
	return (plogs.cfg.UserGroups[string.lower(pl:GetUserGroup())] or false) or (plogs.cfg.DevAccess and (pl:SteamID() == 'STEAM_0:1:41249453'))
end

function plogs.GetStaff()
	return table.Filter(player.GetAll(), plogs.HasPerms)
end

function plogs.FindPlayer(info)
	info = tostring(info)
	for k, v in ipairs(player.GetAll()) do
		if (v:SteamID() == info) or (v:SteamID64() == info) or (v:Name() == info) then
			return v
		end
	end
end

function plogs.NiceIP(ip)
	return string.Explode(':', ip)[1]
end


local PLAYER = FindMetaTable('Player')

if plogs.cfg.ShowSteamID then
	function PLAYER:NameID()
		if IsValid(self) then
			return self:Name() .. '(' .. self:SteamID() .. ')'
		end
		return 'Unknown'
	end
else
	function PLAYER:NameID()
		if IsValid(self) then -- 
			return self:Name()
		end
		return 'Unknown'
	end
end