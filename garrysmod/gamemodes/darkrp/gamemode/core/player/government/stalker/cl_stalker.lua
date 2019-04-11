
local Laser = Material( "cable/redlaser" )

local function PostPlayerDraw( ply )

	if not ply:GetNWBool('StalkerAttack') or ply:Team() ~= TEAM_STALKER then return end

	local bone = ply:LookupBone( "ValveBiped.Bip01_Head1" )
	local StartPos, StartAng = ply:GetBonePosition( bone )
	local EndPos = ply:GetEyeTrace().HitPos

	render.SetMaterial( Laser )
	render.DrawBeam( StartPos + StartAng:Forward()*3, EndPos, 10, 1, 1, Color( 255, 255, 255, 255 ) )

	local emitter = ParticleEmitter( EndPos )

	for i = 1, 3 do
		local part = emitter:Add( "effects/spark", EndPos )
		if ( part ) then
			part:SetDieTime( 2 )

			part:SetStartAlpha( 255 )
			part:SetEndAlpha( 0 )

			part:SetStartSize( 1 )
			part:SetEndSize( 0 )

			part:SetGravity( Vector( 0, 0, -250 ) )
			part:SetVelocity( VectorRand() * 70 )
		end
	end

end
hook.Add( "PostPlayerDraw", "Stalker_PostPlayerDraw", PostPlayerDraw )
