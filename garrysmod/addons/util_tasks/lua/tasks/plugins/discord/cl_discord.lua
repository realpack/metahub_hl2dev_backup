local connectionURI = "http://127.0.0.1:%s"
local minPort = 6463
local maxPort = 6473
local portCount = maxPort - minPort
local rpcURI

local prnt = print
local print = function(...)
    prnt("SUP.Rewards | Discord: ", ...)
end

local function FindPort(port, count, cback)
	if count == portCount then
		return
	end

	http.Fetch(string.format(connectionURI, port), function(body)
		if not string.match(body, "Authorization Required") then
			FindPort(port + 1, count + 1, cback)
			return
		end
        cback(port)
	end, function()
		FindPort(port + 1, count + 1, cback)
	end)
end

local function PostRequest(body, url, cback)
    HTTP {
        method = "POST",
        url = url,
        type = "application/json",
        headers = nil,
        body = util.TableToJSON(body),
        success = function(status, payload)
            if cback then cback(util.JSONToTable(payload)) end
        end,
        failed = function(error) print("ОШИБКА: " .. error) end
    }
end

local function LoadAssests(cback)
    local assetsURI = string.format("https://discordapp.com/api/v6/oauth2/applications/%s/assets", Tasks.Config.DiscordClientID)
    http.Fetch(assetsURI, function(body)
        cback()
    end)
end

function Tasks.Discord.Join()
    local body = {
        cmd = "AUTHORIZE",
		args = {
			client_id = Tasks.Config.DiscordClientID,
			scopes = {"identify", "guilds.join"}
		},
        nonce = tostring(SysTime())
    }
    PostRequest(body, rpcURI, function(payload)
		PrintTable(payload)
        if !payload.data.message then
            net.Start("Tasks.Discord.AuthCode")
                net.WriteString(payload.data.code)
            net.SendToServer()
        end
    end)
end

hook.Add("InitPostEntity", "Tasks.Discord.Setup", function()
    FindPort(minPort, 0, function(port)
        print("Discord port found")
        LoadAssests(function()
            print("Discord assets loaded")
            rpcURI = string.format("http://127.0.0.1:%s/rpc?v=1&client_id=%s", port, Tasks.Config.DiscordClientID)
        end)
    end)
end)
