local scr_w, scr_h = ScrW(), ScrH()

hook.Add('PostRenderVGUI','PostRenderVGUI_HUD',function()
	local cin = (math.sin(CurTime() * 3) + 4) / 10

	if LocalPlayer():GetHunger() <= 0 or LocalPlayer():GetThirst() <= 0 and LocalPlayer():Alive() or LocalPlayer():Health() <= 30 then
		local col = Color(cin * 150, 0, 0, -cin * (-LocalPlayer():Health()) * 2 )

        draw.TexturedQuad
        {
            texture = surface.GetTextureID "gui/gradient",
            color = col,
            x = 0,
            y = 0,
            w = scr_w*.1,
            h = scr_h
        }
        surface.DrawTexturedRectRotated( scr_w/2, 0 + (scr_w*.1)/2,scr_w*.1,scr_w, -90 )
        surface.DrawTexturedRectRotated( scr_w - (scr_w*.1)/2, scr_w*.1,scr_w*.1,scr_w, -180 )
        surface.DrawTexturedRectRotated( scr_w/2, scr_h - (scr_w*.1)/2,scr_w*.1,scr_w, 90 )
    end
end)

function GM:HUDShouldDraw(name)
	if name == "CHudHealth" or
		name == "CHudBattery" or
		name == "CHudSuitPower" or
        name == "CHudAmmo" or
		(HelpToggled and name == "CHudChat") then
			return false
	end

    return true
end

local show_laws = CreateClientConVar("show_laws", "1")
local time = CurTime()
hook.Add("Think", "laws_think", function()
	if time > CurTime() then return end

	if input.IsKeyDown(KEY_F7) then
		show_laws:SetBool(not show_laws:GetBool())
		time = CurTime() + 0.3
	end
end)

-- stamina icons
local standing = Material('metahub/stamina/standing.png', 'noclamp smooth')
local walking = Material('metahub/stamina/walking.png', 'noclamp smooth')
local run = Material('metahub/stamina/run.png', 'noclamp smooth')
local nostamina = Material('metahub/stamina/nostamina.png', 'noclamp smooth')
local stomach = Material('metahub/stamina/stomach.png', 'noclamp smooth')

local laws_box_wide = 450
local cpmask = true

local combine_overlay = Material("effects/combine_binocoverlay", 'noclamp smooth')

local drawplayers = {}
local frames = 0

hook.Add("RenderScene", "NameTags", function(vector, ang, fov)
	frames = FrameNumber()
end)

hook.Add("UpdateAnimation", "NameTags", function(pPlayer)
	-- if not (pPlayer ~= LocalPlayer() and not pPlayer:ShouldDrawLocalPlayer()) then return end
    if pPlayer == LocalPlayer() then return end
	drawplayers[pPlayer] = frames
end)

function PLAYER:CanSeeEnt(ent)
    local min, max = ent:WorldSpaceAABB()

    local wide = min.x + max.x

    local tall = min.y + max.y

    if self:IsLineOfSightClear(ent) then
    	return true
    end

    if self:IsLineOfSightClear(min) then
    	return true
    end

    if self:IsLineOfSightClear(max) then
    	return true
    end

	return false
end

hook.Add('HUDPaint', 'vgui_HUDPaint', function()
    draw.ShadowSimpleText('MetaHub.ru / Discord: https://discord.gg/gxmHRSB', "font_base_18", ScrW()/2, 10, Color(255, 148, 0), TEXT_ALIGN_CENTER)

    do -- gradient
    	local col = Color(0,0,0,90)

        draw.TexturedQuad
        {
            texture = surface.GetTextureID "gui/gradient",
            color = col,
            x = 0,
            y = 0,
            w = scr_w*.1,
            h = scr_h
        }
        surface.DrawTexturedRectRotated( scr_w/2, 0 + (scr_w*.1)/2,scr_w*.1,scr_w, -90 )
        surface.DrawTexturedRectRotated( scr_w - (scr_w*.1)/2, scr_w*.1,scr_w*.1,scr_w, -180 )
        surface.DrawTexturedRectRotated( scr_w/2, scr_h - (scr_w*.1)/2,scr_w*.1,scr_w, 90 )
    end

    do -- ammo
        if IsValid(ply:GetActiveWeapon()) then
            local wep = LocalPlayer():GetActiveWeapon();
            local clip = wep:Clip1() or 0;
            local maxammo = LocalPlayer():GetAmmoCount(ply:GetActiveWeapon():GetPrimaryAmmoType())
            local sw, sh = ScrW() -350, ScrH() -80
            -- if (ply:GetActiveWeapon():GetClass() == "weapon_physcannon") then return false end

            if clip and clip > 0 and (ply:GetActiveWeapon():GetClass() ~= "weapon_physcannon") then
                if clip <= 10 or clip > 4 then
                    draw.ShadowSimpleText(clip, "font_base_title", 244 + sw, 6 + sh, Color(255, 148, 0), TEXT_ALIGN_RIGHT)
                elseif clip <= 4 then
                    draw.ShadowSimpleText(clip, "font_base_title", 244 + sw, 6 + sh, Color(255, 0, 0), TEXT_ALIGN_RIGHT)
                else
                    draw.ShadowSimpleText(clip, "font_base_title", 244 + sw, 6 + sh, color_white, TEXT_ALIGN_RIGHT)
                end
                draw.ShadowSimpleText("/ "..maxammo, "font_base_hud", 250 + sw, 23 + sh, color_white, TEXT_ALIGN_LEFT)
            end
        end
    end

    do -- hitman
        if LocalPlayer():IsHitman() then
            local w = 200
            local x, y = 10, 56
            local hits = table.Filter(player.GetAll(), function(pl) return pl:HasHit() and (pl ~= LocalPlayer()) end)

            if (#hits >= 1) then
                local c = 1

                for k, v in ipairs(hits) do
                    if IsValid(v) and v:GetNetVar('Name') then
                        draw.ShadowSimpleText(v:GetNetVar('Name'), 'font_base_22', x, 17 + (c * 18) + y, team.GetColor(v:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        local cost = rp.FormatMoney(v:GetHitPrice())
                        draw.ShadowSimpleText(cost, 'font_base_22', (w - 5), 17 + (c * 18) + y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        c = c + 1
                    end
                end
            else
                draw.SimpleText('Нет заказов', 'font_base_22', x, 35 + y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end
    end

    do -- cpmask
        local job = rp.teams[LocalPlayer():Team()]
        if job and job.mask_group and LocalPlayer():GetNetVar('CPMask') then
            overlay = combine_overlay
            overlay:SetFloat("$alpha", "0.3")
            overlay:Recompute()

            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(overlay)
            surface.DrawTexturedRect(0, 0, ScrW(), ScrH())

            for _, ent in pairs(ents.FindByClass('forcefield')) do
                if ent and IsValid(ent) and LocalPlayer():GetPos():DistToSqr(ent:GetPos()) <= 512^2 then
                    local ang = ent:GetAngles()
                    local pos = ent:GetPos() + ang:Up()*53

                    local scr = pos:ToScreen()
                    if scr.visible then
                        -- draw.RoundedBox(0, scr.x-50, scr.y-50, 100, 100, color_white)
                        draw.ShadowSimpleText('Силовое поле #'..ent:EntIndex(), "DermaDefault", scr.x, scr.y-15, Color( 255, 255, 255, 255 ), 1, 0)
                        local po = ent:GetNetVar('PoliceOnly')
                        draw.ShadowSimpleText(po and 'Закрыто' or 'Открыто', "DermaDefault", scr.x, scr.y, po and rp.col.Red or rp.col.Green, 1, 0)
                    end
                end
            end

			if nw.GetGlobal('CPTerminal') then
				local text = string.Wrap('font_base_12', string.Implode("\n", nw.GetGlobal('CPTerminal')), 900)

				for i = #text, 1, -1 do
					draw.ShadowSimpleText('- '..text[i], 'font_base_12', 25, (100 + (i * -15)) + (#text*15), Color(255,255,255,140), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				end
			end


            local prot = LocalPlayer():GetNetVar('CPProtocol')
            if prot and job.type == rp.cfg.SupTeamType then
                draw.ShadowSimpleText('Протокол: '..prot, 'font_base_22', 70, 36, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
            end

            local cin = (math.sin(CurTime()) + 1) / 2
            local cin2 = (math.sin(CurTime()) + 1) / 2 + .3
            -- print(cin2)

            local ra = 20*(cin+.5)
            local ro = 180 - ra*2
            local rotate = cin*360

            local cfn = frames-1

            for pPlayer, frame in pairs(drawplayers) do

                if pPlayer and pPlayer:GetMoveType() == MOVETYPE_NOCLIP then continue end

                local bone = pPlayer:LookupBone( 'ValveBiped.Bip01_Head1' )
                if LocalPlayer():CanSeeEnt(pPlayer) and (LocalPlayer():GetPos():DistToSqr(pPlayer:GetPos()) < 256^2) and bone then
                    local pos = pPlayer:GetBonePosition( bone ):ToScreen()
                    -- local pos = (pPlayer:EyePos()+Vector(0,0,3)):ToScreen()
                    if not pos.visible then continue end

                    if pPlayer.Alive and not pPlayer:Alive() then continue end
                    if cfn ~= frames and (cfn+1) ~= frames then continue end


                    -- print((dist^(1/3)/100))
                    local scale = 1

                    draw.Arc( {x = pos.x, y = pos.y}, ra+rotate, ro, 60/scale, 32/scale, 6, Color(240,240,240,90*(cin+.8)) )
                    draw.Arc( {x = pos.x, y = pos.y}, ro+(ra*3)+rotate, ro, 60/scale, 32/scale, 6, Color(240,240,240,90*(cin+.8)) )

                    draw.Arc( {x = pos.x, y = pos.y}, ra-rotate, ro, 50/scale, 32/scale, 2, Color(240,240,240,90*(cin+.5)) )
                    draw.Arc( {x = pos.x, y = pos.y}, ro+(ra*3)-rotate, ro, 50/scale, 32/scale, 2, Color(240,240,240,90*(cin+.5)) )

                    if pPlayer:IsCP() then
                        draw.Arc( {x = pos.x, y = pos.y}, ra-cin2*360, ro, 65/scale, 32/scale, 5, Color(25,106,255,90*(cin+.5)) )
                        draw.Arc( {x = pos.x, y = pos.y}, ro+(ra*3)-cin2*360, ro, 65/scale, 32/scale, 5, Color(25,106,255,90*(cin+.5)) )
                    elseif pPlayer:IsRabel() then
                        draw.Arc( {x = pos.x, y = pos.y}, ra-cin2*360, ro, 65/scale, 32/scale, 5, Color(214,45,32,90*(cin+.5)) )
                        draw.Arc( {x = pos.x, y = pos.y}, ro+(ra*3)-cin2*360, ro, 65/scale, 32/scale, 5, Color(214,45,32,90*(cin+.5)) )
                    elseif pPlayer:IsLoyal() then
                        draw.Arc( {x = pos.x, y = pos.y}, ra-cin2*360, ro, 65/scale, 32/scale, 5, Color(92,184,92,90*(cin+.5)) )
                        draw.Arc( {x = pos.x, y = pos.y}, ro+(ra*3)-cin2*360, ro, 65/scale, 32/scale, 5, Color(92,184,92,90*(cin+.5)) )
                    end
                end
            end
        end

    end

	do -- rpcode
		local code = nw.GetGlobal('CPCode')
		if code and code ~= '' then
			local dcode = rp.cfg.AliveCodes[code]
			draw.ShadowSimpleText('Статус: ', 'font_base_22', 70, 14, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.ShadowSimpleText(dcode.text, 'font_base_22', 144, 14, dcode.color or color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end
	end

    do -- stamina
		local mat_stamina = standing
        local stamina = LocalPlayer():GetStamina()

		if stamina <= 1 then
			mat_stamina = nostamina
		elseif stamina <= 40 then
			mat_stamina = stomach
		elseif LocalPlayer():KeyDown( IN_SPEED ) then
			mat_stamina = run
		elseif LocalPlayer():KeyDown( IN_FORWARD ) or LocalPlayer():KeyDown( IN_BACK ) then
			mat_stamina = walking
		end

		draw.Icon(10,20,48,48,mat_stamina)
    end

    do -- laws
        if show_laws:GetBool() then
            local x = scr_w - laws_box_wide - 10
            local text 	= string.Wrap('font_base_18', (nw.GetGlobal('TheLaws') or rp.cfg.DefaultLaws), laws_box_wide - 6)

            draw.RoundedBox(0, x, 17, laws_box_wide, 34 + (#text * 18), Color(0,0,0,90))
            draw.ShadowSimpleText('(F7 - Закрыть правила)', 'font_base_18', scr_w - laws_box_wide, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT)

            for k, v in ipairs(text) do
                draw.ShadowSimpleText(v, 'font_base_18', scr_w - laws_box_wide, 34 + (k * 18), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            end
        end
    end

    do -- prop_protect
        local trace = LocalPlayer():GetEyeTrace()
        local target = trace.Entity
        local owner = target:GetNWEntity('PropGetOwner')
        if target and IsValid(target) and owner and IsValid(owner) and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == 'weapon_physgun' then
            draw.ShadowSimpleText(owner:Name(), 'font_base_small', 10, ScrH()*.5, team.GetColor(owner:Team()), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end
end)

local voice_icon = Material('metahub/micro.png')
hook.Add("PostDrawTranslucentRenderables", "NameTags", function(depth, sky)
	if depth or sky then return end


	local ang = Angle(0, EyeAngles().y - 90, 90)
	local eyepos = EyePos()

	local counter = 0
	local cfn = frames-1
	for pPlayer, frames in pairs(drawplayers) do
		if not pPlayer:IsValid() then
			drawplayers[pPlayer] = nil
			continue
		end

		if pPlayer.Alive and not pPlayer:Alive() then continue end
		if cfn ~= frames and (cfn+1) ~= frames then continue end

		local eye

		local boneId = pPlayer:LookupBone("ValveBiped.Bip01_Head1")
		if boneId then
			eye = (pPlayer:GetBonePosition(boneId))
		else
			eye = pPlayer:GetPos()
		end

		-- if pPlayer.InVehicle and pPlayer:InVehicle() then
			-- -- eye.z = math.max(eye.z + 9, getroof(pPlayer:GetVehicle()) + 5)
		-- else
			eye.z = eye.z + 10
		-- end

		if cfn == frames and (eyepos:DistToSqr(eye) > 256^2 ) then continue end

		counter = counter + 1
		oy = 0

		cam.Start3D2D(eye, ang, 0.05)
			if pPlayer:IsPlayer() then
				-- draw.SimpleTagText(pPlayer:Name(), "font_base_84", color_white)
				-- draw.SimpleTagText(team.GetName(pPlayer:Team()), "font_base_normal", team.GetColor(pPlayer:Team()))

                if pPlayer:Name() ~= 'Незнакомец' then
                    draw.ShadowSimpleText(pPlayer:Name(), 'font_base_normal', 0, 0, Color(255,255,255,255), 1, 1)
                end
                if pPlayer:IsSpeaking() then
					draw.Icon( -32, -32-50+oy, 64, 64, voice_icon, color_orange )
				end
			end
		cam.End3D2D()
	end
end)

