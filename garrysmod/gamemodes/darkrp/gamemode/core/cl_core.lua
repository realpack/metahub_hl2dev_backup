GM.HandlePlayerSwimming 	= nil
GM.HandlePlayerNoClipping 	= nil

surface.CreateFont( "font_base", {font = "Exo 2 Semi Bold",size = 32,weight = 0,underline = true,extended = true,})
surface.CreateFont( "font_base_big", {font = "Arial",size = 81,weight = 500,extended = true,})
surface.CreateFont( "font_base_rotate", {font = "Tahoma",size = 38,weight = 0,extended = true,})
surface.CreateFont( "font_base_normal", {font = "Arial",size = 56,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_24", {font = "Arial",size = 24,weight = 500,extended = true,})
surface.CreateFont( "font_base_22", {font = "Arial",size = 22,weight = 500,extended = true,})
surface.CreateFont( "HUDNumber5", {font = "Arial",size = 22,weight = 500,extended = true,})
surface.CreateFont( "font_base_title", {font = "Arial",size = 38,weight = 0,extended = true,})
surface.CreateFont( "font_base_18", {font = "Arial",size = 18,weight = 500,extended = true,})
surface.CreateFont( "font_base_small", {font = "Default",size = 14,weight = 300,underline = true,extended = true,})
surface.CreateFont( "font_base_12", {font = "Default",size = 12,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_hud", {font = "Arial",size = 26,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_84_normal", {font = "Arial",size = 84,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_84", {font = "Exo 2 Semi Bold",size = 84,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_54", {font = "Exo 2 Semi Bold",size = 54,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_543", {font = "Exo 2 Semi Bold",size = 30,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_base_warning", {font = "Exo 2 Bold",size = 20,weight = 0,underline = true,extended = true})
surface.CreateFont( "font_notify", {font = "Arial",size = 18,weight = 500,extended = true})
surface.CreateFont( "font_base_45", {font = "Arial",size = 45,weight = 100, extended = true,})
surface.CreateFont( "font_roboto_24", { font = "Roboto", size = 24, weight = 100, extended = true })
surface.CreateFont( "font_roboto_21", { font = "Roboto", size = 21, weight = 100, extended = true })
surface.CreateFont( "font_base_big_s", {font = "Arial", blursize = 5, size = 81, weight = 500, extended = true})
surface.CreateFont( "font_base_large", {font = "Arial",extended = true,size = 100,weight = 500})

surface.CreateFont("3d2d",{font = "Arial",size = 130,weight = 500,shadow = true, antialias = true})

function GM:HUDDrawTargetID()
    return false
end


function draw.ShadowSimpleText(text, font, x, y, color, xAlign, yAlign)
    draw.SimpleText(text, font, x+1, y+1, Color(0,0,0,140), xAlign, yAlign)
    draw.SimpleText(text, font, x, y, color, xAlign, yAlign)
end

function draw.Arc( center, startang, endang, radius, roughness, thickness, color )
	draw.NoTexture()
	surface.SetDrawColor( color.r, color.g, color.b, color.a )
	local segs, p = roughness, {}
	for i2 = 0, segs do
		p[i2] = -i2 / segs * (math.pi/180) * endang - (startang/57.3)
	end
	for i2 = 1, segs do
		if endang <= 90 then
			segs = segs/2
		elseif endang <= 180 then
			segs = segs/4
		elseif endang <= 270 then
			segs = segs/6
		else
			segs = segs
		end
		local r1, r2 = radius, math.max(radius - thickness, 0)
		local v1, v2 = p[i2 - 1], p[i2]
		local c1, c2 = math.cos( v1 ), math.cos( v2 )
		local s1, s2 = math.sin( v1 ), math.sin( v2 )
		surface.DrawPoly{
			{ x = center.x + c1 * r2, y = center.y - s1 * r2 },
			{ x = center.x + c1 * r1, y = center.y - s1 * r1 },
			{ x = center.x + c2 * r1, y = center.y - s2 * r1 },
			{ x = center.x + c2 * r2, y = center.y - s2 * r2 },
		}
	end
end

colorModify = {
	["$pp_colour_addr"] = .01,
	["$pp_colour_addg"] = .02,
	["$pp_colour_addb"] = .12,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0.02,
	["$pp_colour_mulb"] = 0,
    ["$pp_colour_brightness"] = -0.02;
	["$pp_colour_contrast"] = 1.2;
	["$pp_colour_colour"] = 0.5;
}

hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()
	local frameTime = FrameTime();
	local interval = FrameTime() / 10;
	local curTime = CurTime();

    local brightness = colorModify["$pp_colour_brightness"]
    local contrast = colorModify["$pp_colour_contrast"]
    local color = colorModify["$pp_colour_colour"]


    if LocalPlayer():IsCP() and LocalPlayer():GetNetVar('CPMask') == true then
        color = 0.2
    else
        color = 0.5
    end

    brightness = math.Approach(brightness, colorModify["$pp_colour_brightness"], interval);
    contrast = math.Approach(contrast, colorModify["$pp_colour_contrast"], interval);
    color = math.Approach(color, colorModify["$pp_colour_colour"], interval);

	colorModify["$pp_colour_brightness"] = brightness;
	colorModify["$pp_colour_contrast"] = contrast;
	colorModify["$pp_colour_colour"] = color;

    DrawColorModify(colorModify)
end )

function draw.Icon( x, y, w, h, Mat, tblColor )
	surface.SetMaterial(Mat)
	surface.SetDrawColor(tblColor or Color(255,255,255,255))
	surface.DrawTexturedRect(x, y, w, h)
end

function GM:CalcView( pPlayer, origin, angles, fov ) -- Thx, Clockwork!
	if (pPlayer:GetMoveType() == 2 ) then
        if IsValid(pPlayer:GetActiveWeapon()) and string.sub(pPlayer:GetActiveWeapon():GetClass(), 1, 3 ) ~= 'swb' then
            local frameTime = FrameTime();

            local approachTime = frameTime * 2;
            local curTime = UnPredictedCurTime();
            local info = {speed = 1, yaw = 0.5, roll = 0.5};

            if (not self.HeadbobAngle) then
                self.HeadbobAngle = 0;
            end;

            if (not self.HeadbobInfo) then
                self.HeadbobInfo = info;
            end;

            self.HeadbobInfo.yaw = math.Approach(self.HeadbobInfo.yaw, info.yaw, approachTime);
            self.HeadbobInfo.roll = math.Approach(self.HeadbobInfo.roll, info.roll, approachTime);
            self.HeadbobInfo.speed = math.Approach(self.HeadbobInfo.speed, info.speed, approachTime);
            self.HeadbobAngle = self.HeadbobAngle + (self.HeadbobInfo.speed * frameTime);

            local yawAngle = math.sin(self.HeadbobAngle);
            local rollAngle = math.cos(self.HeadbobAngle);

            angles.y = angles.y + (yawAngle * self.HeadbobInfo.yaw);
            angles.r = angles.r + (rollAngle * self.HeadbobInfo.roll);

            local velocity = pPlayer:GetVelocity();
            local eyeAngles = pPlayer:EyeAngles();

            if (not self.VelSmooth) then self.VelSmooth = 0; end;
            if (not self.WalkTimer) then self.WalkTimer = 0; end;
            if (not self.LastStrafeRoll) then self.LastStrafeRoll = 0; end;

            self.VelSmooth = math.Clamp(self.VelSmooth * 0.9 + velocity:Length() * 0.1, 0, 700)
            self.WalkTimer = self.WalkTimer + self.VelSmooth * FrameTime() * 0.05

            self.LastStrafeRoll = (self.LastStrafeRoll * 3) + (eyeAngles:Right():DotProduct(velocity) * 0.0001 * self.VelSmooth * 0.3);
            self.LastStrafeRoll = self.LastStrafeRoll * 0.25;
            angles.r = angles.r + self.LastStrafeRoll;

            if (pPlayer:GetGroundEntity() != NULL) then
                angles.p = angles.p + math.cos(self.WalkTimer * 0.5) * self.VelSmooth * 0.000002 * self.VelSmooth;
                angles.r = angles.r + math.sin(self.WalkTimer) * self.VelSmooth * 0.000002 * self.VelSmooth;
                angles.y = angles.y + math.cos(self.WalkTimer) * self.VelSmooth * 0.000002 * self.VelSmooth;
            end;

            velocity = LocalPlayer():GetVelocity().z;

            if (velocity <= -1000 and LocalPlayer():GetMoveType() == MOVETYPE_WALK) then
                angles.p = angles.p + math.sin(UnPredictedCurTime()) * math.abs((velocity + 1000) - 16);
            end;
        end
	end;

	local view = self.BaseClass:CalcView(pPlayer, origin, angles, fov);

	return view;
end;


function DrawSimpleCircle(posx, posy, radius, color)
	local poly = { }
	local v = 40
	for i = 0, v do
		poly[i+1] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
	end

	draw.NoTexture()
	surface.SetDrawColor(color)
	surface.DrawPoly(poly)
end

concommand.Add( "cid_addname", function( ply, cmd, args )
    local steamid = util.SteamIDFrom64(args[1])
	if steamid then
        rp.names[steamid] = true
    end
end )

concommand.Add( "cid_clear", function( ply, cmd, args )
    rp.names = {}
end )

function Progress(p, t, n, netw, ent, color, snd)
    color = color or Color(255, 165, 2)
    snd = snd or ""
    ent = ent or ""
    local progress = vgui.Create( "DLabel" )
    progress:SetSize( 400, 30 )
    progress:Center()
    progress:SetText("")
    timer.Simple(0.15, function()
        if ent != "" then
            function progress:Think()
                local kek = {}
                kek.start = LocalPlayer():GetPos()
                kek.endpos = LocalPlayer():GetShootPos() + LocalPlayer():GetAimVector() * 128
                kek.filter = LocalPlayer()
                local trace = util.TraceLine(kek)

                if !input.IsKeyDown(KEY_E) or !LocalPlayer():Alive() or !trace.Entity or !IsValid(trace.Entity) or trace.Entity:GetClass() != ent then
                    progress:AlphaTo(0, 0.05, 0)
                    timer.Simple(0.05, function()
                        timer.Remove("progress_"..p:SteamID())
                        if timer.Exists("progress_sounds_"..p:SteamID()) then
                            timer.Remove("progress_sounds_"..p:SteamID())
                        end
                        progress:Remove()
                    end)
                end
            end
        else
            function progress:Think()
                if !input.IsKeyDown(KEY_E) or !LocalPlayer():Alive() then
                    progress:AlphaTo(0, 0.05, 0)
                    timer.Simple(0.05, function()
                        timer.Remove("progress_"..p:SteamID())
                        if timer.Exists("progress_sounds_"..p:SteamID()) then
                            timer.Remove("progress_sounds_"..p:SteamID())
                        end
                        progress:Remove()
                    end)
                end
            end
        end
    end)

    timer.Simple(0.1, function()
        function progress:Paint(w, h)
            draw.RoundedBox( 0, 0, 0, w, h, Color( 47,47,47, 100 ) )
            draw.RoundedBox( 0, 5, 5, w-10, h-10, Color( 5, 5, 5, 100 ) )
            draw.RoundedBox( 0, 5, 5, (((timer.TimeLeft( "progress_"..p:SteamID()) or 0)/t)*w)-10, h-10, Color(color.r, color.g, color.b, 150) )
            -- draw.OutlinedBox( 5, 5, w-10, h-10, 1, color_white )
            local remainingTime = string.FormattedTime( timer.TimeLeft( "progress_"..p:SteamID()), "%02i:%02i:%02i" )
            draw.SimpleText(n, "font_base_18", 10, h/2+1, Color(5,5,5), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(n, "font_base_18", 10, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(remainingTime, "font_base_18", w-75, h/2+1, Color(5,5,5), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(remainingTime, "font_base_18", w-75, h/2, Color(255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
        end
    end)

    if snd != "" then
        timer.Create("progress_sounds_"..p:SteamID(), 1, t, function()
            net.Start("gmt."..snd) net.SendToServer(LocalPlayer())
            if !IsValid(LocalPlayer()) then timer.Remove("progress_sounds_"..p:SteamID()) end
        end)
    end

    timer.Create("progress_"..p:SteamID(), t, 1, function()
        progress:AlphaTo(0, 0.05, 0)
        timer.Simple(0.05, function()
            timer.Remove("progress_"..p:SteamID())
            progress:Remove()
            net.Start("gmt."..netw)
            net.SendToServer()
        end)
    end)
end

-- function DoSex()
--     local progress = vgui.Create( "DLabel" )
--     progress:SetSize( ScrW(), ScrH() )
--     progress:SetText("")
--     function progress:Paint(w, h)
--         draw.Blur(self, 3)
--         draw.RoundedBox(0, 0, 0, w, h, Color(255, 107, 129, 235))
--         drawRotatedBox( "icon16/heart.png", w/2-64, h/2-64, 128+(math.sin(RealTime())*15), 129+(math.sin(RealTime())*15), (CurTime() * 64) % 360, Color( 5, 5, 5 ) )
--         drawRotatedBox( "icon16/heart.png", w/2-64, h/2-64, 128+(math.sin(RealTime())*15), 128+(math.sin(RealTime())*15), (CurTime() * 64) % 360, Color(214, 48, 49) )

--         drawRotatedBox( "icon16/heart.png", w/2+128, h/2+128, 128+(math.sin(RealTime())*15), 129+(math.sin(RealTime())*15), (CurTime() * 64) % 180, Color( 5, 5, 5 ) )
--         drawRotatedBox( "icon16/heart.png", w/2+128, h/2+128, 128+(math.sin(RealTime())*15), 128+(math.sin(RealTime())*15), (CurTime() * 64) % 180, Color(9, 132, 227) )
--     end

--     timer.Simple(0.75*20, function()
--         progress:Remove()
--     end)
-- end
