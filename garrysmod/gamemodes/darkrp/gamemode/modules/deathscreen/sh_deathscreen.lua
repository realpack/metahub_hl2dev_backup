local function respawntime(pl)
	return 40
end

if SERVER then
    rp.deathinfo = rp.deathinfo or {}

	util.AddNetworkString("RespawnTimer")
	hook.Add("PlayerDeath", "RespawnTimer", function(pPlayer)
		pPlayer.deadtime = RealTime()

        rp.deathinfo = rp.deathinfo or {}

		net.Start("RespawnTimer")
			net.WriteBool(true)
            if rp.deathinfo[pPlayer] then
                net.WriteTable(rp.deathinfo[pPlayer])
            else
                net.WriteTable({})
            end
		net.Send(pPlayer)

        rp.deathinfo[pPlayer] = nil
	end)

	hook.Add("PlayerDeathThink", "RespawnTimer", function(pPlayer)
		if pPlayer.deadtime and RealTime() - pPlayer.deadtime < respawntime(pPlayer) then
			return false
		end
	end)

	hook.Add("PlayerSpawn", "HideRespawnTimer", function(pPlayer)
		net.Start("RespawnTimer")
			net.WriteBool(false)
		net.Send(pPlayer)
	end)

    hook.Add("EntityTakeDamage", "DeathScreen_EntityTakeDamage", function( target, dmginfo )
        if target:IsPlayer() then
            rp.deathinfo[target] = rp.deathinfo[target] or {}

            local att = dmginfo:GetAttacker()
            local attacker = att:IsWorld() and 'worldspawn' or ( att.Name and att:Name() or ( att.Nick and att:Nick() or 'worldspawn' ) )

            local tm_c = color_white
            if not att:IsWorld() and att.Team and att:Team() then
                tm_c = team.GetColor(att:Team())
            end
            local att_color = att:IsWorld() and '<colour=255, 165, 0, 255>' or string.format('<colour=%s, %s, %s, %s>', tm_c.r, tm_c.g, tm_c.b, 255)
            table.insert(rp.deathinfo[target], {
                attacker = attacker,
                att_color = att_color,
                damage = dmginfo:GetDamage()
            })
        end
    end)
end



if CLIENT then

	local blur = Material('pp/blurscreen')
    local alpha_lerp, alpha = 0, 0
	net.Receive("RespawnTimer", function()
		if net.ReadBool() then
			local dead = RealTime()
            -- PrintTable(net.ReadTable() or {})
            local dmginfo = net.ReadTable() or {}

            alpha = 160
            local markup_string = ''

            if dmginfo then
                for i, case in pairs(dmginfo) do
                    markup_string = markup_string..'<font=font_roboto_24>'..case.att_color..tostring(case.attacker)..'</colour> нанёс вам <colour=214, 45, 32, 255>'..tostring( math.Round(case.damage) )..'</colour> урона </font>\n'
                end
            end

            local parsed = markup.Parse( markup_string )
			hook.Add("HUDPaint", "RespawnTimer", function()
				local time = math.Round(respawntime() - RealTime() + dead, 2)
                alpha_lerp = Lerp(FrameTime()*6,alpha_lerp or 0,alpha or 0) or 0

                local w, h = ScrW(), ScrH()
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(blur)
				for i = 1, 3 do
					blur:SetFloat('$blur', (i / 3) * 6)
					blur:Recompute()
					render.UpdateScreenEffectTexture()
					surface.DrawTexturedRect(0, 0, w, h)
				end


                draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, alpha_lerp))

                parsed:Draw( 30, 60, 0, 0 )

                local h = parsed:GetHeight()
				draw.SimpleText('Вас убили без причины?! Напишите @ и пиричину жалобы.', "font_roboto_21", 30, 70+h, Color(255,255,255,alpha_lerp*2), 0, 0)

				if time > 0 then
					draw.SimpleText('До возрождения '..time..' секунд', "font_roboto_24", 20, 20, Color(255,255,255,alpha_lerp*2), 0, 0)
				else
					draw.SimpleText('Нажмите любую кнопку для возрождения', "font_roboto_24", 20, 20, Color(255,255,255,alpha_lerp*2), 0, 0)
				end
			end)

			system.FlashWindow()
		else
			hook.Remove("HUDPaint", "RespawnTimer")
		end
	end)
end
