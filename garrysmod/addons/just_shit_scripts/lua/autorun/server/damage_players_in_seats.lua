local addon_name = "damage_players_in_seats"
local seat_class = "prop_vehicle_prisoner_pod"
_G[addon_name] = _G[addon_name] or {}
local addon = _G[addon_name]

CreateConVar( "dmg_ply_veh_seats", "1", FCVAR_ARCHIVE, "Allows damages for players who are on a vehicle seat. Has an effect on drivers only for SCars. Settings: 0/1" )
local dmg_ply_veh_seats = tobool( GetConVarNumber( "dmg_ply_veh_seats" ) )
cvars.AddChangeCallback( "dmg_ply_veh_seats", function( convar_name, value_old, value_new )
	dmg_ply_veh_seats = tobool( value_new )
end, addon_name )

util.AddNetworkString( addon_name )

function addon.EntityFireBullets( attacker, data, ... ) -- allows live-update
	local old_Callback = data.Callback
	function data.Callback( ply, tr, dmgInfo, ... )
		-- MsgN( table.ToString( tr, 'tr', true ) ) -- debug
		local seat = tr.Entity
		if seat:IsVehicle() and seat:GetClass() == seat_class then
			local veh
			if !dmg_ply_veh_seats then
				veh = seat:GetParent()
				if !IsValid( veh ) or !veh:IsVehicle() then
					veh = nil
				end
			end
			if dmg_ply_veh_seats or !veh then
				local victim = seat:GetDriver()
				if IsValid( victim ) then
					local victim_dmg = DamageInfo()
					victim_dmg:SetAttacker( dmgInfo:GetAttacker() )
					victim_dmg:SetDamage( dmgInfo:GetDamage() )
					victim_dmg:SetDamageForce( dmgInfo:GetDamageForce() )
					victim_dmg:SetDamagePosition( dmgInfo:GetDamagePosition() )
					victim_dmg:SetDamageType( bit.bor( dmgInfo:GetDamageType(), DMG_VEHICLE ) )
					victim_dmg:SetInflictor( dmgInfo:GetInflictor() )
					victim_dmg:SetMaxDamage( dmgInfo:GetMaxDamage() )
					victim:TakeDamageInfo( victim_dmg )
					local weapon = attacker:GetActiveWeapon()
					if !IsValid( weapon ) then
						weapon = attacker
					end
					net.Start( addon_name )
						net.WriteEntity( victim )
						net.WriteEntity( seat )
						local trace_offset = seat:WorldToLocal( weapon:GetPos() )
							trace_offset:Normalize()
							trace_offset:Mul(6)
						net.WriteVector( trace_offset )
					net.Broadcast() -- send blood
				end
			end
		end
		if isfunction( old_Callback ) then
			return old_Callback( ply, tr, dmgInfo, ... )
		end
	end
end

hook.Add( "PreGamemodeLoaded", addon_name, function()
	dmg_ply_veh_seats = tobool( GetConVarNumber( "dmg_ply_veh_seats" ) )
	local old_EntityFireBullets = GAMEMODE.EntityFireBullets
	function GAMEMODE:EntityFireBullets( attacker, data, ... ) -- no conflicts by using this instead of a returning hook
		addon.EntityFireBullets( attacker, data, ... ) -- allows live-update
		if isfunction( old_EntityFireBullets ) then
			old_EntityFireBullets( attacker, data, ... )
		end
		return true -- always return true to use the callback
	end
end )

hook.Add( "PlayerEnteredVehicle", addon_name, function( ply, seat )
	if seat.playerdynseat then
		seat:SetNotSolid( false )
		seat:SetCollisionGroup( COLLISION_GROUP_WEAPON ) -- must not collide with players when physics object removed
		seat:PhysicsDestroy()
	end
end )
