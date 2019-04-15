local function GetUsersGroups(ply, cback)
	http.Fetch("https://api.steampowered.com/ISteamUser/GetUserGroupList/v1/?key="..Tasks.Config.SteamAPIKey.."&steamid=" .. ply:SteamID64(), function(payload)
		local parsedPayload = util.JSONToTable(payload)
		local groups = parsedPayload["response"].groups
		cback(groups)
	end)
end

function Tasks.SteamGroup.IsInGroup(ply, cback)
	GetUsersGroups(ply, function(groups)
		for _, group in ipairs(groups) do
			if group.gid == Tasks.Config.GroupID then
				cback(true)
				return
			end
		end
		cback(false)
	end)
end