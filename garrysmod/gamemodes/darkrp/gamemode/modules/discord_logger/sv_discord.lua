GmLogger = GmLogger or {}
GmLogger.NameWebHook = 'Metahub'
GmLogger.SteamWebAPI = 'CCDCDFCDDF7D79DF108DFAC7207DC236'

function GmLogger.PostMessageInDiscord(strMessage)
    -- print(strMessage, color)
	local t_post = {}
	local content = strMessage

	local string_players = '``['..#player.GetAll()..'/'..game.MaxPlayers()..']`` '

    t_post.embeds = {
		{
			description = string_players..content,
            color = 0xe67e22
		}
	}

    local json_post = util.TableToJSON(t_post)
    local HTTPRequest = {
        ["method"] = "POST",
        ["url"] = 'http://185.248.100.183/webhook',
        ["type"] = "application/json",
        ["headers"] = {
            ["X-Auth-Token"] = "gw0e899wjeg9we78gh7weg",
            ["Content-Type"] = "application/json",
            ["Content-Length"] = string.len(json_post) or "0",
            ["Webhook-URL"] = "https://discordapp.com/api/webhooks/568211274647994368/28gVsynuoP5gZp-roW6oVh7VVDnEx_8RqZcPlWypZYBKVcqeWGH0FRgiWXAOFrHEMEM-"
        },
        ['success'] = function(c,b) print(c,b) end,
        ["body"] = json_post
    }

    HTTP(HTTPRequest)
end

-- function PostMessageInDiscord_Chat( player, text )
-- 	local name = player:Nick()
-- 	local steamID = player:SteamID()

-- 	text = string.gsub( text, "@", "" )

-- 	http.Fetch( 'http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=B2118375F04678BB2008920BAC81DCDC&steamids='..player:SteamID64(),
-- 		function( body, len, headers, code )
-- 			-- The first argument is the HTML we asked for.
-- 			local avatar_medium = util.JSONToTable(body)['response']['players'][1]['avatarmedium']
-- 			GmLogger.PostMessageInDiscord(text,"**"..name.."**(``"..steamID.."``)",avatar_medium,'%s',GmLogger.WebHookURL_Chat)
-- 		end,
-- 		function( error )
-- 			-- We failed. =(
-- 		end
-- 	 )
-- end


GmLogger.Hooks = {
	{
		hook = "CheckPassword", func = function(communityID, ip, serverPassword, enteredPassword, name)
			local steamID = util.SteamIDFrom64(communityID)

			GmLogger.PostMessageInDiscord("Player ".. "**"..name.."**(``"..steamID.."``) is attempting to connect.")
		end
	},
	{
		hook = "PlayerInitialSpawn", func = function(player)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("Player ".. "**"..name.."**(``"..steamID.."``) has spawned in the server")
		end
	},
	{
		hook = "PlayerDisconnected", func = function(player)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("Player ".. "**"..name.."**(``"..steamID.."``) has left the server")
		end
	},
	{
		hook = "PlayerSay", func = function(player, text, m_bToAll, m_bDead)
			local strMsg = string.Explode(" ",text)

			local name = player:Nick()
			local steamID = player:SteamID()

			-- print(strMsg[1][1] ~= '/')
			if strMsg[1][1] ~= '/' then
				GmLogger.PostMessageInDiscord( "**"..name.."**(``"..steamID.."``): "..text )
			end
		end
	},
	{
		hook = "CanDrive", func = function(player, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) attempted to drive entity \""..tostring(entity).."\"")
		end
	},
	{
		hook = "CanTool", func = function(player, trace, toolMode)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) used tool \""..toolMode.."\"")
		end
	},
	{
		hook = "OnPhysgunReload", func = function(weapon, player)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) un-froze (reloaded) using the physgun")
		end
	},
	{
		hook = "PlayerSpawnedProp", func = function(player, model, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned prop \"``"..tostring(entity).."`` ``("..model..")``\"")
		end
	},
	{
		hook = "PlayerSpawnedRagdoll", func = function(player, model, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned ragdoll \""..tostring(entity).." ("..model..")\"")
		end
	},
	{
		hook = "PlayerSpawnedVehicle", func = function(player, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned vehicle \""..tostring(entity).."\"")
		end
	},
	{
		hook = "PlayerSpawnedEffect", func = function(player, model, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned effect \""..tostring(entity).." ("..model..")\"")
		end
	},
	{
		hook = "PlayerSpawnedNPC", func = function(player, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned npc \""..tostring(entity).."\"")
		end
	},
	{
		hook = "PlayerSpawnedSENT", func = function(player, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned SENT \""..tostring(entity).."\"")
		end
	},
	{
		hook = "PlayerSpawnedSWEP", func = function(player, entity)
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) spawned SWEP \""..tostring(entity).."\"")
		end
	},
	{
		hook = "PlayerGiveSWEP", func = function(player, class, swep )
			local name = player:Nick()
			local steamID = player:SteamID()

			GmLogger.PostMessageInDiscord("**"..name.."**(``"..steamID.."``) give SWEP \""..class.."\" for **yourself**")
		end
	},
	{
		hook = "PlayerDeath", func = function(player, inflictor, attacker)
			if (attacker:IsPlayer()) then
				GmLogger.PostMessageInDiscord("**"..attacker:Nick().."**(``"..attacker:SteamID().."``) has killed **"..player:Nick().."**(``"..player:SteamID().."``).");
			else
				GmLogger.PostMessageInDiscord("``"..attacker:GetClass().."`` has killed **"..player:Nick().."**(``"..player:SteamID().."``).");
			end;
		end
	},
	{
		hook = "serverguard.RanCommand", func = function(player, commandTable, bSilent, arguments)
			if (util.IsConsole(player)) then
				GmLogger.PostMessageInDiscord(string.format(
					"Console ran command \"%s %s\"", commandTable.command, table.concat(arguments, " ")
				)); return;
			end;

			local steamID = player:SteamID()
			local playerNick = player:Nick();

			if (arguments and table.concat(arguments, " ") != "") then
				GmLogger.PostMessageInDiscord(string.format(
					"**%s**(``%s``) ran command \"``%s`` ``%s``\"", playerNick, steamID, commandTable.command, table.concat(arguments, " ")
				));
			else
				GmLogger.PostMessageInDiscord(string.format(
					"**%s**(``%s``) ran command \"``%s``\"", playerNick, steamID, commandTable.command
				));
			end;
		end
	}
}

function GmLogger.DetectHook(strHook,callback)
	-- GmLogger.PostMessageInDiscord('*Hook '..strHook..' is detected and active.*')
	hook.Add(strHook,strHook..'_GmLogger',callback)
end

for _, v in pairs(GmLogger.Hooks) do
	GmLogger.DetectHook(v.hook,v.func)
end

GmLogger.Initialized = true

local function ban_to_discord(title, text)
    local t_post = {}
    t_post.embeds = {
        {
            title = title,
            description = text,
            color = 0x3d92ff
        }
    }
    t_post.username = 'CW'
    t_post.content = ''

    local json_post = util.TableToJSON(t_post)
    local HTTPRequest = {
        ["method"] = "POST",
        ["url"] = 'https://discordapp.com/api/webhooks/533177776539172864/NsHV7wtKRmqnZ9YEWmvW-YOR1VzZXd5zyfK4XNjRfh71pPq9ZEf57ZTrnmKtm6mIXVg7',
        ["type"] = "application/json",
        ["headers"] = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = string.len(json_post) or "0"
        },
        ["body"] = json_post
    }

    HTTP(HTTPRequest)
end

hook.Add('serverguard.PlayerBanned','fweg', function(player, length, reason, admin)
    local pname = (player.Name and player.SteamID) and player:Name()..'(``'..player:SteamID()..'``)' or player
    local aname = (admin.Name and admin.SteamID) and admin:Name()..'(``'..admin:SteamID()..'``)' or tostring(admin)
    aname = aname == '[NULL Entity]' and '``Console``' or aname



    -- local endtime = length == 0 and 'Навсегда' or tostring(os.date("%H:%M:%S - %d/%m/%Y",length+os.time()))
    -- local hours = math.Round(length / 3600)
    -- local endtime = length <= 0 and 'Навсегда' or hours >= 1 and tostring(hours)..' hour(s)' or tostring(math.Round(length / 60))..' minute(s)'
    local endtime = length == 0 and 'Навсегда' or length >= 1440 and math.Round(length / 1440)..' hour(s)' or tostring(length)..' minute(s)'

    -- local starttime = tostring(os.date("%H:%M:%S - %d/%m/%Y",os.time()))
    ban_to_discord(tostring(aname)..' забанил '..tostring(pname), 'Причина: ``'..tostring(reason)..'``. Продолжительность: ``'..endtime..'``.')
end)
