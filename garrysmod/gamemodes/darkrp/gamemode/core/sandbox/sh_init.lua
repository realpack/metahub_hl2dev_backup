cleanup.Register( "props" )
cleanup.Register( "ragdolls" )
cleanup.Register( "effects" )
cleanup.Register( "npcs" )
cleanup.Register( "constraints" )
cleanup.Register( "ropeconstraints" )
cleanup.Register( "sents" )
cleanup.Register( "vehicles" )

function GM:PlayerNoClip( pl, on )
	return false
end

if (SERVER) then
	function GM:PlayerShouldTakeDamage( ply, attacker )
		return true
	end

	function GM:CreateEntityRagdoll( entity, ragdoll )
		-- Replace the entity with the ragdoll in cleanups etc
		undo.ReplaceEntity( entity, ragdoll )
		cleanup.ReplaceEntity( entity, ragdoll )
	end

	function GM:CanEditVariable( ent, ply, key, val, editor )
		return false
	end
	
	return
end

function GM:OnUndo(name, strCustomString)
	notification.AddLegacy((strCustomString and strCustomString or "#Undone_" .. name), NOTIFY_UNDO, 2)
	
	surface.PlaySound( "buttons/button15.wav" )
end

function GM:OnCleanup( name )
	notification.AddLegacy("#Cleaned_" .. name, NOTIFY_CLEANUP, 5)
	
	surface.PlaySound( "buttons/button15.wav" )
end