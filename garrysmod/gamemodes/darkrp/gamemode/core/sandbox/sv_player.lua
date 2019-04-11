-- Accumulate limits
function GM:PlayerSpawnedRagdoll( ply, model, ent )
	ply:AddCount( "ragdolls", ent )
end

function GM:PlayerSpawnedProp( ply, model, ent )
	if ply:IsStalker() or ply:IsArrested() or ply:IsFrozen() then return false end

	ply:AddCount( "props", ent )
end

function GM:PlayerSpawnedEffect( ply, model, ent )
	ply:AddCount( "effects", ent )
end

function GM:PlayerSpawnedVehicle( ply, ent )
	ply:AddCount( "vehicles", ent )
end

function GM:PlayerSpawnedNPC( ply, ent )
	ply:AddCount( "npcs", ent )
end

function GM:PlayerSpawnedSENT( ply, ent )
	ply:AddCount( "sents", ent )
end

function GM:PlayerSpawnedSWEP( ply, ent )
	ply:AddCount( "sents", ent )
end

-- Numpad buttons
function GM:PlayerButtonDown( ply, btn )
	numpad.Activate( ply, btn )
end

function GM:PlayerButtonUp( ply, btn )
	numpad.Deactivate( ply, btn )
end
