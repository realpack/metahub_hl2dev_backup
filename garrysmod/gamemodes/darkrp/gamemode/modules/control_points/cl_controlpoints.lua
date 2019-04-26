

-- local targets = {
-- 	{ pos = Vector('-3823.510254 -5466.013184 5722.686523'), name = 'A Point', active = true },
-- 	{ pos = Vector('-2764.006592 -3929.118164 5685.696289'), name = 'B Point', active = false },
-- 	{ pos = Vector('-676.363892 -6291.225098 5687.080566'), name = 'C Point', active = false },
-- 	{ pos = Vector('-1620.581787 -10587.125000 7903.734863'), name = 'D Point', active = false },
-- }

-- local point_active_lerp = 0
-- timer.Create('PointActive',1,0,function()
-- 	point_active_lerp = 0
-- end)

local scale = .58
local point_active = 0
local mat_cpp = Material('metaui/captureebalo/cpp.png', 'smooth noclamp')
hook.Add( "HUDPaint", "ControlPoints_HUDPaint", function()
    if not LocalPlayer():IsSuperAdmin() then return end

	local cin = (math.sin(CurTime()) + 1) /2
	local col = ColorAlpha(color_white,cin * 100+70)

    point_active = point_active or 0
    point_active = math.Approach(
        point_active, point_active,
        math.Clamp(
            math.abs((point_active - point_active) * FrameTime() * 2),
            FrameTime()/2,
            1
        )
    )

    point_active = point_active + .18
    if point_active >= 80 then
        point_active = 0
    end

    local i = 1
    local controls = ents.FindByClass('control_point')
	for k, ent in pairs(controls) do
        ent.point_lerp = ent.point_lerp or 0
        local pos, ang = ent:GetPos(), ent:GetAngles()
		local scr = (pos+ang:Up()*60):ToScreen()

        local text_align = TEXT_ALIGN_CENTER
        local text_name_x, text_name_y = 0, 0
        local text_team_x, text_team_y = 0, 0
        local text_chall_x, text_chall_y = 0, 0
        local draw_dist = true
        if table.HasValue(ents.FindInSphere(pos, ent:GetNWInt('Radius')), LocalPlayer()) then
            scr.x = ScrW() - 40
            scr.y = ScrH() - 50

            text_align = TEXT_ALIGN_RIGHT
            text_name_x, text_name_y = -30, -40
            text_team_x, text_team_y = -30, -40
            text_chall_x, text_chall_y = -30, -40
            draw_dist = false
        end
        -- scr.x = scr.x > ScrW()-60 and ScrW()-60 or scr.x < 60 and 60 or scr.x
        -- scr.y = scr.y > ScrH()-60 and ScrH()-60 or scr.y < 60 and 60 or scr.y

        local occupied = ent:GetNWInt( "Occupied" ) > 1 and 1 or ent:GetNWInt( "Occupied" )
        -- ent.point_lerp = Lerp(FrameTime()*3, ent.point_lerp or occupied, occupied or ent.point_lerp)
        ent.point_lerp = math.Approach(
            ent.point_lerp, occupied,
            math.Clamp(
                math.abs((occupied - ent.point_lerp) * FrameTime() * 2),
                FrameTime()/2,
                1
            )
        )

        local fraction_id = ent:GetNWString('Team')
        local fraction = rp.cfg.controlpoints_teams[fraction_id]
        if not fraction then return end

		draw.Arc( { y = scr.y, x = scr.x }, 0, 360, 40*scale, 6, 10*scale, Color(0,0,0,90) )

	    render.ClearStencil()
	    render.SetStencilEnable(true)

	        render.SetStencilWriteMask( 255 )
	        render.SetStencilTestMask( 255 )

	        render.SetStencilReferenceValue( 25 )
	        render.SetStencilFailOperation( STENCIL_REPLACE )

	        draw.Arc( {y =scr.y, x =scr.x}, 0, 360, 40*scale, 24, 10*scale, Color(255,255,255,255) )

	        render.SetStencilCompareFunction(STENCIL_EQUAL)

	        draw.NoTexture()
	        draw.Arc( {y =scr.y, x =scr.x}, 0, ent.point_lerp*360, 60*scale, 32, 45*scale,col )

	    render.SetStencilEnable(false)

		draw.Arc( {y =scr.y, x =scr.x}, 0, 360, 27*scale, 24, 27*scale, ColorAlpha(fraction.color,140) )

        if occupied ~= 1 then
		    draw.Arc( {y =scr.y, x =scr.x}, 0, 360, 40*scale+point_active, 24, 1, Color(255,255,255,255-point_active*28) )
        end

		local dist = math.sqrt(LocalPlayer():GetPos():DistToSqr(ent:GetPos()))*0.01905
		local icon_size = (32*scale)

		draw.Icon( scr.x-icon_size/2, scr.y-icon_size/2, icon_size, icon_size, rp.cfg.controlpoints_icon[ent:GetNWString('Icon')] or mat_cpp, color_white )
        draw.SimpleText(ent:GetNWString('Name') or ent, 'font_base_small', scr.x+text_name_x, scr.y+28+text_name_y, Color(0,0,0,140), text_align, 1)
		draw.SimpleText(ent:GetNWString('Name') or ent, 'font_base_small', scr.x+text_name_x, scr.y+28+text_name_y, col, text_align, 1)
        if fraction_id ~= 0 then
            draw.SimpleText(fraction.name or 'Control Point', 'font_base_12', scr.x+text_team_x, scr.y+40+text_team_y, Color(0,0,0,140), text_align, 1)
            draw.SimpleText(fraction.name or 'Control Point', 'font_base_12', scr.x+text_team_x, scr.y+40+text_team_y, col, text_align, 1)
        end
        if draw_dist then
            draw.SimpleText(math.Round(dist,1)..'м', 'font_base_small', scr.x, scr.y-28, Color(0,0,0,140), text_align, 1)
		    draw.SimpleText(math.Round(dist,1)..'м', 'font_base_small', scr.x, scr.y-28, col, text_align, 1)
        end
        if ent:GetNWBool( "Challenging" ) then
            draw.SimpleText('Оспаривание', 'font_base_12', scr.x+text_chall_x, scr.y+52+text_chall_y, Color(0,0,0,140), text_align, 1)
            draw.SimpleText('Оспаривание', 'font_base_12', scr.x+text_chall_x, scr.y+52+text_chall_y, Color(253,220,84,90), text_align, 1)
        end

        local line_wide = 100
		local x = ((ScrW()/2)-((line_wide+2)*i))+(#controls*line_wide)/2
		if fraction then
			draw.RoundedBox(0,x,105,line_wide,3,Color(0,0,0,130))
			draw.RoundedBox(0,x,105,occupied*line_wide,3,ColorAlpha(fraction.color,200))
            draw.SimpleText(ent:GetNWString( "Name" ),'font_base_12',x+(line_wide/2),108,Color(0,0,0,140),1)
			draw.SimpleText(ent:GetNWString( "Name" ),'font_base_12',x+(line_wide/2),108,Color(255,255,255,90),1)
			i = i + 1
		end
	end
end )

hook.Add( "PostDrawTranslucentRenderables", "ControlPoints_PostDrawTranslucentRenderables", function( bDepth, bSkybox )
	render.SetColorMaterial()
    for k, ent in pairs(ents.FindByClass('control_point')) do
        local fraction = rp.cfg.controlpoints_teams[ent:GetNWString('Team')]
        if not fraction then return end

	    render.DrawSphere( ent:GetPos(), ent:GetNWInt('Radius'), 30, 30, ColorAlpha(fraction.color,10) )
        render.DrawSphere( ent:GetPos(), -ent:GetNWInt('Radius'), 30, 30, ColorAlpha(fraction.color,10) )
    end
end )
