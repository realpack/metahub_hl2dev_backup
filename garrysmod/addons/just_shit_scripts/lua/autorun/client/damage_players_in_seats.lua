local center_player_offset = Vector( 0,2.5,0 )
net.Receive( "damage_players_in_seats", function()
	local victim = net.ReadEntity()
	local seat = net.ReadEntity()
	if IsValid( victim ) and IsValid( seat ) then
		local trace_offset = net.ReadVector()
		local effect = EffectData()
			effect:SetEntity( victim )
			effect:SetOrigin( seat:LocalToWorld( seat:WorldToLocal( victim:GetBonePosition( 4 ) )+center_player_offset+trace_offset ) )
			-- effect:SetRadius( 1023 )
			-- effect:SetScale( 1023 )
		util.Effect( "BloodImpact", effect, false )
	end
end )

hook.Add("HUDPaint", "fading_door.HUDPaint", function()
	local ply = LocalPlayer()

	local ent = ply:GetEyeTrace().Entity
	if not IsValid(ent) then return end
	if not ent:GetNWBool("IsFadingDoor") then return end

	local text = function(hp)
		hp = math.ceil(hp)
		if hp >= 1250 then
			return "<color=55,255,0>"..hp
		elseif hp >= 1000 then
			return "<color=90,215,0>"..hp
		elseif hp >= 750 then
			return "<color=135,175,0>"..hp
		elseif hp >= 500 then
			return "<color=175,135,0>"..hp
		elseif hp >= 250 then
			return "<color=215,90,0>"..hp
		else
			return "<color=255,55,0>"..hp
		end
	end
	local mp = markup.Parse("<font=font_base_18>Целостность: "..text(ent:GetNWInt("PropHealth")).."/1500", 400)
	mp:Draw(ScrW()/2, ScrH()/2+45, 1, 1)
end)
