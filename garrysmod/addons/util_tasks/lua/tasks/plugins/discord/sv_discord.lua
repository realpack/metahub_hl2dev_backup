util.AddNetworkString("Tasks.Discord.AuthCode")

local endpoint = "https://discordapp.com/api/v6"

local function GetAuthToken(code, ply, cback)
    local params = {
		grant_type = "authorization_code",
		code = code,
		client_id = Tasks.Config.DiscordClientID,
		client_secret = Tasks.Config.DiscordClientSecret,
		redirect_uri = Tasks.Config.DiscordRedirectURI
	}
    http.Post(endpoint .. "/oauth2/token", params, function(result)
		local data = util.JSONToTable(result)
		if data and data.access_token then
            cback(data.access_token)
		else
			print("Ошибка выдачи доступа для: " .. ply:Nick() .. ", код: " .. code)
		end
    end)
end

local function GetUserID(token, cback)
    local headers = {
        ["Authorization"] = "Bearer " .. token,
        ["Content-Length"] = "0",
        ["User-Agent"] = "TasksDiscord ("..Tasks.Config.Website..", 1.0.0)"
    }
    http.Fetch(endpoint .. "/users/@me", function(body)
        local data = util.JSONToTable(body)
        cback(data.id)
    end, function(error)
        print("SUP.Rewards | ОШИБКА: " .. error)
    end, headers)
end

local function JoinGuild(token, userID, cback)
    local body = util.TableToJSON {
        access_token = token
    }
    local headers = {
        ["Authorization"] = "Bot " .. Tasks.Config.BotToken,
        ["Content-Length"] = tostring(string.len(body)),
        ["User-Agent"] = "TasksDiscord ("..Tasks.Config.Website..", 1.0.0)"
    }
    HTTP {
        method = "PUT",
        url = endpoint .. "/guilds/"..Tasks.Config.DiscordID.."/members/"..userID,
        type = "application/json",
        body = body,
        headers = headers,
        success = function(status, payload) 
            cback(status)
        end,
        failed = function(error) print("SUP.Rewards | ОШИБКА: " .. error) end
    }
end

function Tasks.Discord.Joined(ply, cback)
    Tasks.Notify(ply, "Добавляем вас в Discord...")
    timer.Simple(10, function()
        if !IsValid(ply) then
            cback(false)
        else
            cback(ply.JoinedDiscord)
        end
    end)
end

net.Receive("Tasks.Discord.AuthCode", function(l, ply)
    if ply.DiscordNextAuth and CurTime() < ply.DiscordNextAuth then return end
    ply.DiscordNextAuth = CurTime() + 30
    local code = net.ReadString()
    GetAuthToken(code, ply, function(token)
        print("SUP.Rewards | Получаю доступ ("..token..") для " .. ply:Nick())
        GetUserID(token, function(userID)
            JoinGuild(token, userID, function(status)
                if status == 204 or status == 201 then
                    print("SUP.Rewards | Игрок в Discord! " .. ply:Nick())
                    ply.JoinedDiscord = true
                end
            end)
        end)
    end)
end)