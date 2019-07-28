local ipairs 	= ipairs
local IsValid 	= IsValid
local string 	= string
local table 	= table

function GM:CanChangeRPName(ply, RPname)
	if string.find(RPname, "\160") or string.find(RPname, " ") == 1 then -- disallow system spaces
		return false
	end

	if table.HasValue({"ooc", "shared", "world", "n/a", "world prop", "STEAM", 'stoned', 'penguin'}, RPname) and (not pl:IsRoot()) then
		return false
	end
end

function GM:CanDemote(pl, target, reason)end
function GM:CanVote(pl, vote)end
function GM:OnPlayerChangedTeam(pl, oldTeam, newTeam)end

function GM:CanDropWeapon(pl, weapon)

	if not IsValid(weapon) then return false end
	local class = string.lower(weapon:GetClass())

	if rp.cfg.DisallowDrop[class] then return false end

    -- PrintTable(pl.Weapons)
	if table.HasValue(pl.Weapons, weapon) then
        return false
    end


	for k, v in pairs(rp.shipments) do
		if v.entity ~= class then continue end

		return true
	end

	return false
end

function PLAYER:CanDropWeapon(weapon)
	return GAMEMODE:CanDropWeapon(self, weapon)
end

function GM:UpdatePlayerSpeed(pl)
	self:SetPlayerSpeed(pl, rp.cfg.WalkSpeed, rp.cfg.RunSpeed)
end

hook.Add('PlayerConnect', 'add_logger', function( name, ip )
    if file.Exists( "connects.txt", "GAME" ) then
        file.Write( "permaprops_permissions.txt", '' )
    end

    file.Append( "connects.txt", 'connect - '..name..' ('..ip..')\n' )
end)


timer.Simple(0.5, function()
	local GM = GAMEMODE
	GM.CalcMainActivity 		= nil
	GM.SetupMove 				= nil
	GM.FinishMove 				= nil
	GM.Move 					= nil
	GM.UpdateAnimation 			= nil
	GM.Think 					= nil
	GM.Tick 					= nil
	GM.PlayerTick 				= nil
	GM.PlayerPostThink 			= nil
	GM.KeyPress 				= nil
	GM.EntityRemoved 			= nil
	GM.EntityKeyValue 			= nil
	GM.HandlePlayerJumping 		= nil
	GM.HandlePlayerDucking 		= nil
	GM.HandlePlayerNoClipping 	= nil
	GM.HandlePlayerVaulting 	= nil
	GM.HandlePlayerSwimming 	= nil
	GM.HandlePlayerLanding 		= nil
	GM.HandlePlayerDriving 		= nil
end)

/*---------------------------------------------------------
 Gamemode functions
 ---------------------------------------------------------*/
local cp_doors_models = {
   'models/combine_gate_vehicle.mdl',
   'models/props_combine/combine_door01.mdl',
   'models/combine_gate_citizen.mdl',
}


function GM:PlayerUse(pl, ent)
    -- print(ent)
    -- print(ent.for_cp)
    -- print(ent, ent:IsDoor())
	if ent:MapCreationID() == 3634 or ent:MapCreationID() == 3635 then
		-- ent:Fire("setanimation","open",.1)
		ent:Fire('open')

		return true
	end
    if (ent:IsDoor() or ent:GetClass() == 'prop_dynamic' ) and table.HasValue(cp_doors_models,ent:GetModel()) then
        if pl:IsCP() then
            -- print(ent)
            ent:Fire("setanimation","open",.1)
            ent:Fire('open')

            timer.Simple(6, function()
                ent:Fire("setanimation","close",.1)
            end)
            return true
        else
            return false
        end
    end

	return not pl:IsStalker()
end
function GM:PlayerSpawnSENT(pl, model) return pl:IsSuperAdmin() end
function GM:PlayerSpawnSWEP(pl, class, model) return pl:IsSuperAdmin() end
function GM:PlayerGiveSWEP(pl, class, model) return pl:IsSuperAdmin() end
function GM:PlayerSpawnVehicle(pl, model) return pl:IsSuperAdmin() end
function GM:PlayerSpawnNPC(pl, model) return pl:HasAccess('*') end
function GM:PlayerSpawnRagdoll(pl, model) return pl:HasAccess('*') end
function GM:PlayerSpawnEffect(pl, model) return pl:HasAccess('*') end
function GM:PlayerSpray(pl) return false end
function GM:CanDrive(pl, ent) return true end
function GM:CanProperty(pl, property, ent) return false end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	if ent.PhysgunFreeze and (ent:PhysgunFreeze(pl) == false) then
		return false
	end

	if ( ent:GetPersistent() ) then return false end

	-- Object is already frozen (!?)
	if ( !phys:IsMoveable() ) then return false end
	if ( ent:GetUnFreezable() ) then return false end

	phys:EnableMotion( false )

	-- With the jeep we need to pause all of its physics objects
	-- to stop it spazzing out and killing the server.
	if ( ent:GetClass() == "prop_vehicle_jeep" ) then

		local objects = ent:GetPhysicsObjectCount()

		for i = 0, objects - 1 do

			local physobject = ent:GetPhysicsObjectNum( i )
			physobject:EnableMotion( false )

		end

	end

	-- Add it to the player's frozen props
	pl:AddFrozenPhysicsObject( ent, phys )

	return true
end

function GM:PlayerShouldTaunt(pl, actid) return true end
function GM:CanTool(pl, trace, mode) return not pl:IsArrested() end

function GM:CanPlayerSuicide(pl)
	if pl:IsArrested() then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideJail'))
	elseif pl:IsWanted() then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideWanted'))
	elseif pl:IsFrozen() then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideFrozen'))
	elseif (pl:GetKarma() > 0) or ((pl.LastSuicide ~= nil) and pl.LastSuicide >= CurTime()) then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideLiveFor'))
	else
		pl:Notify(NOTIFY_ERROR, rp.Term('YouSuicided'))
		pl:EmitSound('ambient/creatures/town_child_scream1.wav')
		pl.LastSuicide = CurTime() + 2
		return true
	end

	return false
end

function GM:PlayerSpawnProp(ply, model)
	if ply:IsStalker() or ply:IsArrested() or ply:IsFrozen() then return false end

	model = string.gsub(tostring(model), "\\", "/")
	model = string.gsub(tostring(model), "//", "/")

	return ply:CheckLimit('props')
end


function GM:ShowSpare1(ply)
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].ShowSpare1 then
		return rp.teams[ply:Team()].ShowSpare1(ply)
	end
end

function GM:ShowSpare2(ply)
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].ShowSpare2 then
		return rp.teams[ply:Team()].ShowSpare2(ply)
	end
end

function GM:OnNPCKilled(victim, ent, weapon)
	-- If something killed the npc
	if ent then
		if ent:IsVehicle() and ent:GetDriver():IsPlayer() then ent = ent:GetDriver() end

		-- If we know by now who killed the NPC, pay them.
		if IsValid(ent) and ent:IsPlayer() then
			local xp = rp.Karma(ent, 5, 75)
			local money = rp.Karma(ent, 5, 100)
			ent:AddMoney(money)
			rp.Notify(ent, NOTIFY_GREEN, rp.Term('+Money'), money)
		end
	end
end

local player_GetAll 	= player.GetAll
local GetShootPos 		= PLAYER.GetShootPos
local DistToSqr 		= VECTOR.DistToSqr
timer.Create('PlayerHearVoice', 0.5, 0, function()
	local pls = player_GetAll()
	for a = 1, #pls do
		for b = 1, #pls do
			if (not pls[a].CanHear) then
				pls[a].CanHear = {}
			end
			if (DistToSqr(GetShootPos(pls[a]), GetShootPos(pls[b])) <= 302500) and (pls[a] ~= pls[b]) then
				pls[a].CanHear[pls[b]] = true
			else
				pls[a].CanHear[pls[b]] = false
			end
		end
	end
end)

function string.StripPort(ip)
	local p =string.find(ip, ':')
	if (not p) then return ip end
	return string.sub(ip, 1, p - 1)
end

-- function GM:PlayerCanHearPlayersVoice(listener, talker)
	-- return (listener.CanHear and listener.CanHear[talker] or false), true
-- end

function GM:DoPlayerDeath(pl, attacker, dmginfo)
	pl:CreateRagdoll()

	pl.LastRagdoll = (CurTime() + rp.cfg.RagdollDelete)
end

timer.Create('RemoveRagdolls', 30, 0, function()
	local pls = player.GetAll()
	for i = 1, #pls do
		if pls[i].LastRagdoll and (pls[i].LastRagdoll <= CurTime()) then
			local rag = pls[i]:GetRagdollEntity()
			if IsValid(rag) then
				rag:Remove()
			end
		end
	end
end)

function GM:PlayerDeathThink(pl)
	if (not pl.NextReSpawn or pl.NextReSpawn < CurTime()) and (pl:KeyPressed(IN_ATTACK) or pl:KeyPressed(IN_ATTACK2) or pl:KeyPressed(IN_JUMP) or pl:KeyPressed(IN_FORWARD) or pl:KeyPressed(IN_BACK) or pl:KeyPressed(IN_MOVELEFT) or pl:KeyPressed(IN_MOVERIGHT) or pl:KeyPressed(IN_JUMP)) then
		pl:Spawn()
	end
end

function GM:PlayerDeath(ply, weapon, killer)
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].PlayerDeath then
		rp.teams[ply:Team()].PlayerDeath(ply, weapon, killer)
	end

	ply:Extinguish()

	if ply:GetNetVar('HasGunlicense') then ply:SetNetVar('HasGunlicense', nil) end

	if ply:InVehicle() then ply:ExitVehicle() end

    if killer:IsPlayer() then
        local job = rp.teams[ply:Team()]
        local kjob = rp.teams[killer:Team()]

        if job and kjob and rp.cfg.RewardForMurder[kjob.type] and rp.cfg.RewardForMurder[kjob.type][job.type] then
            local reward = rp.cfg.RewardForMurder[kjob.type][job.type]

            killer:Notify(NOTIFY_GENERIC, 'Вы получили награду в размере '..rp.FormatMoney(reward)..', за убийство "'..ply:Name()..'".')
            killer:AddMoney(reward)
        end
    end

	ply.NextReSpawn = CurTime() + 1

    if rp.cfg.ChangeTeamForDeath[ply:Team()] then
        ply:SetTeam(rp.cfg.ChangeTeamForDeath[ply:Team()])
    end

    if ply:IsCP() then
        net.Start('LostSignalCP')
            net.WriteString(ply:GetNWString("RPID"))
            net.WriteEntity(ply)
        net.Send(player.GetAll())

        AddLineTerminal(string.format( 'Биосигнал потерян %s.', ply:Name() ))
        for _, v in pairs(player.GetAll()) do
            if v:IsCP() then
                CreateMark( v, ply:GetPos(), ply:Name(), 'Биосигнал потерян', 'icon16/cross.png', 25 )
            end
        end
    end
end

function GM:PlayerCanPickupWeapon(ply, weapon)
	if ply:IsArrested() then return false end
	if weapon and weapon.PlayerUse == false then return false end

	if rp.teams[ply:Team()] and rp.teams[ply:Team()].PlayerCanPickupWeapon then
		rp.teams[ply:Team()].PlayerCanPickupWeapon(ply, weapon)
	end
	return true
end

local function HasValue(t, val)
	for k, v in ipairs(t) do
		if (string.lower(v) == string.lower(val)) then
			return true
		end
	end
end

function GM:PlayerSetModel(pl)
	if rp.teams[pl:Team()] and rp.teams[pl:Team()].PlayerSetModel then
		return rp.teams[pl:Team()].PlayerSetModel(pl)
	end

	-- if (pl:GetVar('Model') ~= nil) and istable(rp.teams[pl:Team()].model) and HasValue(rp.teams[pl:Team()].model, pl:GetVar('Model')) then
	-- 	pl:SetModel(pl:GetVar('Model'))
	-- else
	-- 	pl:SetModel(team.GetModel(pl:GetJob() or 1))
	-- end

    local model = rp.teams[pl:Team()].model
    if model then
        pl:SetModel(istable(model) and table.Random(model) or model)
    else
        if pl:GetVar('Model') ~= nil then
            pl:SetModel(pl:GetVar('Model'))
        else
            local random_gender = tostring(math.random(0, 1))
            local model = team.GetModel(pl:GetJob() or 1) == false and table.Random(rp.cfg.DefaultModels[random_gender]) or team.GetModel(pl:GetJob() or 1)
            -- print(pl, table.Random(rp.cfg.DefaultModels[random_gender]))
            pl:SetModel(model)
        end
    end

	pl:SetupHands()
end

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(1)

	for k, v in ipairs(ents.GetAll()) do
		if IsValid(v) and (v.deleteSteamID == ply:SteamID()) then
			ply:_AddCount(v:GetClass(), v)
			v.ItemOwner = ply
			if v.Setowning_ent then
				v:Setowning_ent(ply)
			end
			v.deleteSteamID = nil
			timer.Destroy("Remove"..v:EntIndex())
		end
	end
end

local map = game.GetMap()
local lastpos


function GM:PlayerSelectSpawn(pl)
	local pos
    local TeamSpawns 	= rp.cfg.TeamSpawns[map]
    local JailSpawns 	= rp.cfg.JailPos[map]
    local NormalSpawns 	= rp.cfg.SpawnPos[map]

	if pl:IsArrested() then
		pos = JailSpawns[math.random(1, #JailSpawns)]
	elseif (TeamSpawns[pl:Team()] ~= nil) then
		pos = TeamSpawns[pl:Team()][math.random(1, #TeamSpawns[pl:Team()])]
	else
		pos = NormalSpawns[math.random(1, #NormalSpawns)]
		if (pos == lastpos) then
			pos = NormalSpawns[math.random(1, #NormalSpawns)]
		end
		lastpos = pos
		return self.SpawnPoint, util.FindEmptyPos(pos)
	end
	return self.SpawnPoint, util.FindEmptyPos(pos)
end

function GM:PlayerSpawn(ply)
    ply:ConCommand('cid_clear')

	player_manager.SetPlayerClass(ply, 'rp_player')

	ply:SetNoCollideWithTeammates(false)
	ply:UnSpectate()
	ply:SetHealth(100)
	ply:SetJumpPower(200)

	GAMEMODE:SetPlayerSpeed(ply, rp.cfg.WalkSpeed, rp.cfg.RunSpeed)

	ply:Extinguish()
	if IsValid(ply:GetActiveWeapon()) then
		ply:GetActiveWeapon():Extinguish()
	end

	if ply.demotedWhileDead then
		ply.demotedWhileDead = nil
		ply:ChangeTeam(rp.DefaultTeam)
	end

	ply:GetTable().StartHealth = ply:Health()
	gamemode.Call("PlayerSetModel", ply)
	gamemode.Call("PlayerLoadout", ply)

	local _, pos = self:PlayerSelectSpawn(ply)
	ply:SetPos(pos)

	local view1, view2 = ply:GetViewModel(1), ply:GetViewModel(2)
	if IsValid(view1) then
		view1:Remove()
	end
	if IsValid(view2) then
		view2:Remove()
	end

	local job = rp.teams[ply:Team()]
	if job then
		if job.PlayerSpawn then
			job.PlayerSpawn(ply)
		end
		if job.type == rp.cfg.SupTeamType then
			ply:SetNetVar('CPProtocol', rp.cfg.SupProtocols[1])
		end
	end

	ply:AllowFlashlight(true)
    ply:SetNetVar('CPMask', true)

    if file.Exists( "connects.txt", "GAME" ) then
        file.Write( "permaprops_permissions.txt", '' )
    end

    file.Append( "connects.txt", 'spawn - '..ply:Name()..'('..ply:SteamID()..')'..' ('..ply:IPAddress()..')]\n' )
end

function GM:PlayerLoadout(ply)
	if ply:IsArrested() then return end

	player_manager.RunClass(ply, "Spawn")

	local Team = ply:Team() or 1

	if not rp.teams[Team] then return end

    local job = rp.teams[ply:Team()]
	if job.PlayerLoadout then
		job.PlayerLoadout(ply)
	end

    ply:SetNWString('RPID', math.random(10000,99999))

    if Team ~= TEAM_STALKER then
        for k, v in ipairs(rp.teams[Team].weapons or {}) do
            ply:Give(v)
        end

        for k, v in ipairs(rp.cfg.DefaultWeapons) do
            ply:Give(v)
        end

        if ply:IsAdmin() then
            ply:Give("weapon_keypadchecker")
        end
    end

    if job.mask_group then
        ply:SetBodygroup(2,job.mask_group)
    end

    ply:SetHealth(job.health and job.health or 100)
	ply:SelectWeapon('weapon_physgun')

	ply.Weapons = ply:GetWeapons()
end

local function removeDelayed(ent, ply)
	ent.deleteSteamID = ply:SteamID()
	timer.Create("Remove" .. ent:EntIndex(), (ent.RemoveDelay or math.random(180, 900)), 1, function()
		SafeRemoveEntity(ent)
	end)
end

-- Remove shit on disconnect
function GM:PlayerDisconnected(ply)
	if ply:IsAgendaManager() then
		nw.SetGlobal('Agenda;' .. ply:Team(), nil)
	end

    rp.ArrestedPlayers[ply:SteamID64()] = nil

	if ply:IsMayor() then
		nw.SetGlobal('mayorGrace', nil)
		rp.resetLaws()
	end

	for k, v in ipairs(ents.GetAll()) do
		-- Remove right away or delayed
		if (v.ItemOwner == ply) and not v.RemoveDelay or v.Getrecipient and (v:Getrecipient() == ply) then
			v:Remove()
		elseif (v.RemoveDelayed or v.RemoveDelay) and (v.ItemOwner == ply) then
			removeDelayed(v, ply)
		end

		-- Unown all doors
		if IsValid(v) and v:IsDoor() then
			if v:DoorOwnedBy(ply) then
				v:DoorUnOwn()
			elseif v:DoorCoOwnedBy(ply) then
				v:DoorUnCoOwn(ply)
			end
		end

		-- Remove all props
		if IsValid(v) and ((v:CPPIGetOwner() ~= nil) and not IsValid(v:CPPIGetOwner())) or (v:CPPIGetOwner() == ply) then
			v:Remove()
		end
	end

	rp.inv.Data[ply:SteamID64()] = nil

	GAMEMODE.vote.DestroyVotesWithEnt(ply)

	if rp.teams[ply:Team()].mayor and nw.GetGlobal('lockdown') then -- Stop the lockdown
		GAMEMODE:UnLockdown(ply)
	end

	if rp.teams[ply:Team()] and rp.teams[ply:Team()].PlayerDisconnected then
		rp.teams[ply:Team()].PlayerDisconnected(ply)
	end
end

function GM:GetFallDamage(pl, speed)
	local dmg = (speed / 15)
	local ground = pl:GetGroundEntity()
	if ground:IsPlayer() then
		ground:TakeDamage(dmg * 1.3, pl, pl)
	end
	return dmg
end

local remove = {
	/*['env_fire'] = true,
	['trigger_hurt'] = true,
	['prop_dynamic'] = true,
	['prop_door_rotating'] = true,
	['light'] = true,
	['spotlight_end'] = true,
	['beam'] = true,
	['env_sprite'] = true,
	['light_spot'] = true,
	['point_template'] = true,*/

	['prop_physics'] = true,
	['prop_physics_multiplayer'] = true,
	['prop_ragdoll'] = true,
	-- ['ambient_generic'] = true,
	-- ['func_tracktrain'] = true,
	['func_reflective_glass'] = true,
	['info_player_terrorist'] = true,
	['info_player_counterterrorist'] = true,
	-- ['env_soundscape'] 	= true,
	['point_spotlight'] = true,
	['ai_network'] 		= true,

	-- map shit
	['lua_run'] 			= true,
	['logic_timer'] 		= true,
	['trigger_multiple']	= true
}

function GM:InitPostEntity()
	local physData 								= physenv.GetPerformanceSettings()
	physData.MaxVelocity 						= 1000
	physData.MaxCollisionChecksPerTimestep		= 10000
	physData.MaxCollisionsPerObjectPerTimestep 	= 2
	physData.MaxAngularVelocity					= 3636

	physenv.SetPerformanceSettings(physData)

	game.ConsoleCommand("sv_allowcslua 0\n")
	game.ConsoleCommand("physgun_DampingFactor 0.9\n")
	game.ConsoleCommand("sv_sticktoground 0\n")
	game.ConsoleCommand("sv_airaccelerate 100\n")

	for _, ent in ipairs(ents.GetAll()) do
		if remove[ent:GetClass()] then
			ent:Remove()
		end
    end

    for k, v in ipairs(ents.FindByClass('info_player_start')) do
		if util.IsInWorld(v:GetPos()) and (not self.SpawnPoint) then
			self.SpawnPoint = v
		else
			v:Remove()
		end
	end
end
