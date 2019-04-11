local oktools = {
	["#Tool.advdupe2.name"] = true,
	["#Tool.stacker.name"] 	= true
}

function GM:PlayerSpawnProp(pl, mdl)
	local tool = pl:GetTool()
	if pl.lastPropSpawn and (pl.lastPropSpawn > CurTime() - .25) and ((tool == nil) or not oktools[tool.Name]) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('SpawnPropsSoFast'))

		if pl.failedPropAttempts and (pl.failedPropAttempts >= 5) and (pl.toldStaff ~= true) then
			-- ba.notify_staff('# has been stopped from spawning more than 5 props in a second. Keep an eye on them!', pl)
			pl.toldStaff = true
		end

		pl.lastPropSpawn = CurTime()
		pl.failedPropAttempts = (pl.failedPropAttempts or 0) + 1

		return false
	end

	pl.toldStaff 			= nil
	pl.failedPropAttempts 	= nil
	pl.lastPropSpawn 		= CurTime()

	if rp.pp.IsBlockedModel(mdl) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PropNotWhitelisted'), mdl)

		local issuper = pl:IsSuperAdmin()

		if issuper then
			local pc_count =table.Count(rp.pp.ModelCache)

			if (pc_count >= 100) then
				pl:Notify(NOTIFY_ERROR, rp.Term('CacheFull'), pc_count)
				return false
			end

			rp.pp.ModelCache[mdl] = true
		end

		return pl:IsUserGroup('serverstaff') and true or false
	end

    return true
end

hook('PlayerSpawnedProp', 'pp.PlayerSpawnedProp', function(pl, mdl, ent)
	ent:CPPISetOwner(pl)
end)

hook('PlayerSpawnedVehicle', 'pp.PlayerSpawnedVehicle', function(pl, ent)
	ent:CPPISetOwner(pl)
end)

hook('PlayerSpawnedSENT', 'pp.PlayerSpawnedSENT', function(pl, ent)
	ent:CPPISetOwner(pl)
end)

function GM:CanTool(pl, trace, tool)
	return rp.pp.PlayerCanTool(pl, trace.Entity, tool)
end

hook('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent)
	if IsValid(ent) then
		local canphys = rp.pp.PlayerCanManipulate(pl, ent)

		if (not canphys) and ent.PhysgunPickup then
			canphys = ent:PhysgunPickup(pl)
		elseif ent.LazyFreeze then
			canphys = ((ent.ItemOwner == pl) or (ent.AllLazyFreeze == true)) and (not ent.BeingPhysed)
		end

		if (canphys == true) then
			ent.BeingPhysed = true
			hook.Call('PlayerPhysgunEntity', GAMEMODE, pl, ent)
		end

		return canphys
	end
	return false
end)

local vec = Vector(0,0,0)
function GM:PhysgunDrop(pl, ent)
	ent.BeingPhysed = false
	if IsValid(ent) and (not ent:IsPlayer()) then
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddAngleVelocity(phys:GetAngleVelocity() * -1)
			phys:SetVelocityInstantaneous(vec)
		end
	end
end

hook('OnPhysgunFreeze', 'pp.OnPhysgunFreeze', function(weapon, physobj, ent, pl)
	ent.BeingPhysed = false
	if IsValid(physobj) and (ent.ItemOwner == pl or ent.AllLazyFreeze) and ent.LazyFreeze then
		--physobj:Sleep()
		return false
	end
end)

function GM:GravGunOnPickedUp(pl, ent)
	if ent:IsConstrained() then
		DropEntityIfHeld(ent)
	end
end

function GM:GravGunPunt(pl, ent)
	if (pl:IsSuperAdmin()) then return true end

	DropEntityIfHeld(ent)
	return false
end

function GM:OnPhysgunReload(wep, pl)
	return false
end

function GM:GravGunPickupAllowed(pl, ent)
	if (ent:IsValid() and ent.GravGunPickupAllowed) then
		return ent:GravGunPickupAllowed(pl)
	end

	return true
end
