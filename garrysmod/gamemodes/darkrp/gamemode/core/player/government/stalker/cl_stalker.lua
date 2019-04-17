
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

local soundtranslate = {
    ['0'] = "npc/overwatch/radiovoice/zero.wav",
    ['1'] = "npc/overwatch/radiovoice/one.wav",
    ['2'] = "npc/overwatch/radiovoice/two.wav",
    ['3'] = "npc/overwatch/radiovoice/three.wav",
    ['4'] = "npc/overwatch/radiovoice/four.wav",
    ['5'] = "npc/overwatch/radiovoice/five.wav",
    ['6'] = "npc/overwatch/radiovoice/six.wav",
    ['7'] = "npc/overwatch/radiovoice/seven.wav",
    ['8'] = "npc/overwatch/radiovoice/eight.wav",
    ['9'] = "npc/overwatch/radiovoice/nine.wav"
}

local sound_die = "npc/overwatch/radiovoice/lostbiosignalforunit.wav"
net.Receive('LostSignalCP', function()
    local rpid = net.ReadString()
    local ply = net.ReadEntity()

    if not ply:IsCP() then return end

    ply:EmitSound('npc/overwatch/radiovoice/die'..math.random(1,3)..'.wav')

    timer.Simple(.5, function()
        ply:EmitSound(sound_die)
        timer.Simple(SoundDuration(sound_die), function()
            for i = 1, #rpid do
                local char = rpid[i]

                if soundtranslate[char] and ply and IsValid(ply) then
                    i = i -1
                    timer.Simple(.65*i, function()
                        ply:EmitSound(soundtranslate[char])
                    end)
                end
            end
        end)
    end)
end)
