-- После вызова этой функции загружается вторая часть скрипта
-- Т.е. не вызвать функцию - не запустится скрипт
-- Она не вызывается, если сервер отключен или произошла ошибка в ходе выполнения запроса на получение списка серверов
local function onReady()
	IGS.SERVERS.Broadcast()

	IGS.SetReady(true)

	IGS.SetServerVersion(IGS.Version)
end

local function addServerLocally(id, name, enabled)
	-- Lua refresh
	-- assert(!IGS.SERVERS.MAP[id],"Хмм. Здесь не должно такого быть")

	if true    then IGS.SERVERS.TOTAL   = IGS.SERVERS.TOTAL   + 1 end
	if enabled then IGS.SERVERS.ENABLED = IGS.SERVERS.ENABLED + 1 end

	IGS.SERVERS.MAP[id] = name
end

local function addCurrentServerLocally(id, name, sock_port)
	IGS.SERVERS.CURRENT = id
	addServerLocally(id, name, true)

	IGS.C.SOCKETPORT = sock_port
end

local function registerCurrentServer(ip,port, fOnSuccess)
	IGS.AddServer(ip, port, function(id)
		IGS.print(
			"CEPBEP 3APEruCTPuPOBAH nO9 I9: " .. id .. "\n" ..
			"CMEHuTE uM9 B nAHEJIu gm-donate.ru/panel/projects/" .. IGS.C.ProjectID
		)

		local sock_port = port + 10
		addCurrentServerLocally(id, ip .. ":" .. port, sock_port) -- нужно снаружи SetServerSocketPort для IGS.SERVERS:ID()
		IGS.SetServerName( GetConVarString("hostname") )
		IGS.SetServerSocketPort(sock_port, function()
			fOnSuccess()

			IGS.print(
				"COKET CEPBEPA HACTpOEH. nOPT: " .. sock_port .. "\n" ..
				"ECJIu C4ET nOnOJIH9ETC9 HE MrHOBEHHO, TO CMEHuTE IP HA 6OJIEE 6JIU3Kuu K nOPTy CEPBEPA"
			)
		end)
	end)
end

local function loadServersOrRegisterCurrent(d, local_ip)
	local serv_port = tonumber( game.GetIPAddress():match(":(.+)$") )

	-- reset
	IGS.SERVERS.TOTAL   = 0
	IGS.SERVERS.ENABLED = 0

	local currentDisabled
	for _,v in ipairs(d) do -- -- `ID`,`Name`,`IP`,`Port`,`SocketPort`,`Disabled`
		local disabled = tobool(v.Disabled)

		-- Текущий сервер
		if v.IP == local_ip and v.Port == serv_port then
			if disabled then currentDisabled = true end
			addCurrentServerLocally(v.ID, v.Name, v.SocketPort) -- sock may be nil
		else
			addServerLocally(v.ID, v.Name, !disabled)
		end
	end

	if currentDisabled then
		IGS.print(Color(255,50,50), "3TOT CEPBEP OTKJII04EH. 3ArPy3KA nPEKPAwEHA")
		return -- не даем выполнить onReady()
	end

	-- Сервер не зарегистрирован
	if !IGS.SERVERS.CURRENT then
		IGS.print("3TOT CEPBEP HE 3APEruCTPuPOBAH. CO39AEM!")
		registerCurrentServer(local_ip,serv_port, onReady)
	else
		onReady()
	end
end

timer.Simple(0,function() -- фетч заработает только так в этот момент
	IGS.GetExternalIP(function(local_ip)
		IGS.GetServers(function(dat)
			loadServersOrRegisterCurrent(dat, local_ip)
		end, true) -- include disabled
	end)
end)


local OBJMETH = table.concat(IGS_SERVERS_GET,":") -- servers.get
hook.Add("IGS.OnApiError","NotifyAboutImpossibleLoading",function(object,method)
	if (object .. "." .. method) == OBJMETH then
		for i = 1,30 do
			IGS.print(Color(255,0,0), "NEVOZMOZNO ZAGRUZIT SKRIPT. VAZNIE DANNIE NE POLUCHENI")
		end
	end
end)
