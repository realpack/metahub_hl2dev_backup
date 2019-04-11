--
rp.marks = rp.marks or {}

function CreateMark( pos, title, text, icon, time )
	local index = table.insert(rp.marks, { pos = pos, title = title, text = text, icon = Material(icon) })

	timer.Create('MarkToRemove_#'..tostring(index), tonumber(time), 1, function()
        rp.marks[index] = false
		-- table.remove(rp.marks, index)
		-- timer.Destroy('MarkToRemove_#'..index)
	end)

	return index
end

net.Receive('CreateMark', function()
	local pos = net.ReadVector()
	local title = net.ReadString()
	local text = net.ReadString()
	local icon = net.ReadString()
	local time = net.ReadUInt(32)

	CreateMark( pos, title, text, icon, time )
end)

hook.Add('HUDPaint', 'DrawMarks', function()
	for i, mark in pairs(rp.marks) do
        if mark then
            local screen = mark.pos:ToScreen()

            local dist = LocalPlayer():GetPos():DistToSqr(mark.pos)
            local meters = math.Round( dist / 19050.0,1 )

            local ti = 'MarkToRemove_#'..tostring(i)
            -- if timer.TimeLeft(ti) then
            local time_left = math.Round( timer.TimeLeft(ti), 0)

            if time_left then
                screen.x = math.Clamp(screen.x, 50, ScrW()-50)
                screen.y = math.Clamp(screen.y, 30, ScrH()-30)

                if dist > 32^2 then
                    draw.Icon( screen.x-8, screen.y-10, 16, 16, mark.icon, color_white )
                    draw.ShadowSimpleText(mark.title, "font_base_22", screen.x, screen.y, Color( 48, 91, 144, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.ShadowSimpleText(mark.text, "font_base_small", screen.x, screen.y+34, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                    draw.ShadowSimpleText(' ('..meters..'м, '..tostring( time_left )..'сек до удаления)', "font_base_12", screen.x, screen.y+22, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end
            end
        end
        -- end
	end
end)
