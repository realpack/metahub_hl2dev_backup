-- local function r(n) return math.Round(n, 0) end

-- concommand.Add('trace', function(pl)
-- 	local prop = pl:GetEyeTrace().Entity
-- 	if IsValid(prop) then
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, prop:GetClass())
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, 'mdl = \''..prop:GetModel()..'\',')
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, 'pos = Vector('..string.gsub(tostring(prop:GetPos()), ' ', ', ')..'),')
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, 'ang = Angle('..string.gsub(tostring(prop:GetAngles()), ' ', ', ')..'),')
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, 'mat = \'' .. prop:GetMaterial() .. '\',')
-- 	end
-- end)

-- concommand.Add('pos', function(pl)
-- 	local pos = pl:GetPos()
-- 	local ang = pl:GetAngles()
-- 	pl:PrintMessage(HUD_PRINTCONSOLE, 'Vector(' .. r(pos.x) .. ', ' .. r(pos.y) .. ', ' .. r(pos.z) ..'),' )
-- 	pl:PrintMessage(HUD_PRINTCONSOLE, 'Angle(' .. r(ang.x) .. ', ' .. r(ang.y) .. ', ' .. r(ang.z) ..'),' )
-- end)


-- local pq =  {}
-- concommand.Add('kom_pos', function(pl) -- COUNTER CLOCKWISE
-- 	pq[#pq + 1] = pl:GetPos()

-- 	if (#pq >= 4) then
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, '{x = ' .. r(pq[1].x) .. ', y = ' .. r(pq[1].y) ..', x2 = ' .. r(pq[1].x) .. ', y2 = ' .. r(pq[2].y) .. '},')
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, '{x = ' .. r(pq[1].x) .. ', y = ' .. r(pq[2].y) ..', x2 = ' .. r(pq[3].x) .. ', y2 = ' .. r(pq[2].y) .. '},')
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, '{x = ' .. r(pq[3].x) .. ', y = ' .. r(pq[2].y) ..', x2 = ' .. r(pq[3].x) .. ', y2 = ' .. r(pq[1].y) .. '},')
-- 		pl:PrintMessage(HUD_PRINTCONSOLE, '{x = ' .. r(pq[3].x) .. ', y = ' .. r(pq[1].y) ..', x2 = ' .. r(pq[1].x) .. ', y2 = ' .. r(pq[1].y) .. '},')
-- 		pq = {}
-- 	end
-- end)

