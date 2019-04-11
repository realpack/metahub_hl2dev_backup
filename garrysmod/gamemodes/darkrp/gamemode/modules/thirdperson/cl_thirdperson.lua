
thirdperson_enabled = thirdperson_enabled or false
local dist = dist or 0
local freecam_ang = nil

thirtperson = thirtperson or {
    x = 120,
    y = 100,
    z = 40
}
-- local x = 120
-- local y = 100
-- local z = 15

local xmin, xmax = 0, 200
local ymin, ymax = -100, 100
local zmin, zmax = -100, 100

local fov = 90
local dist = 1

local view = {}

thirtperson.x = CreateClientConVar('thirtperson_x', "60", true, false)
thirtperson.y = CreateClientConVar('thirtperson_y', "60", true, false)
thirtperson.z = CreateClientConVar('thirtperson_z', "40", true, false)

hook.Add("CalcView","Thirdperson",function(pl,pos,ang,fov,nearz,farz)
	pl.camera_ang = pl:EyeAngles()

    local x = tonumber(thirtperson.x:GetString())
    local y = tonumber(thirtperson.y:GetString())
    local z = tonumber(thirtperson.z:GetString())

	y = y < .5 and (y-.5)/2 or y-.5
	y = y *2 * 100
	z = z < .5 and (z-.5)/2 or z-.5
	z = z *2 * -120

    -- print(x, y, z)

	if ((thirdperson_enabled or dist > 0)) then
		if (thirdperson_enabled) then
			dist = math.min(dist + (1 - dist) * FrameTime() * 6, 1)
			if (dist > .99) then dist = 1 end
		else
			dist = math.max(dist - dist * FrameTime() * 6, 0)
			if (dist < .01) then dist = 0 end
		end

		if (freecam_ang and !pl:KeyDown(IN_WALK)) then
			pl.camera_ang = Angle(freecam_ang.p, freecam_ang.y, freecam_ang.r)
			freecam_ang = nil
		elseif (!freecam_ang and pl:KeyDown(IN_WALK)) then
			freecam_ang = Angle(pl.camera_ang.p, pl.camera_ang.y, pl.camera_ang.r)
		end

		pos = pos + (pl.camera_ang:Forward() * (-x)) + (pl.camera_ang:Right() * (y)) + (pl.camera_ang:Up() * (z))

		local hulltr = util.TraceHull({
			start = pl:GetShootPos(),
			endpos = pos,
			filter = player.GetAll(),
			mask = MASK_SHOT_HULL,
			mins = Vector(-10, -10, -10),
			maxs = Vector(10, 10, 10)
		})

		if (hulltr.Hit) then
			pos = hulltr.HitPos + (pl:GetShootPos() - hulltr.HitPos):GetNormal() * 10
		end

		local aimtr = util.TraceLine({
			start = pos + (pl.camera_ang:Forward() * (-z + 45)),
			endpos = pos + (pl.camera_ang:Forward() * 100000),
			filter = pl
		})

		view.origin = pos
		view.fov = fov
		view.angles = pl.camera_ang
		view.drawviewer = true

		if (thirdperson_enabled and pl:GetMoveType() == MOVETYPE_NOCLIP) then
			pl:SetEyeAngles(freecam_ang or pl.camera_ang)
		-- elseif (thirdperson_enabled and !pl:KeyDown(IN_WALK)) then
		-- 	local newAng = (aimtr.HitPos - pl:EyePos()):Angle()
		-- 	lastAim = lastAim or pl:EyeAngles()

		-- 	local minYaw = math.NormalizeAngle(pl.camera_ang.y - 45)
		-- 	local maxYaw = math.NormalizeAngle(pl.camera_ang.y + 45)
		-- 	local newYaw = math.NormalizeAngle(newAng.y)

		-- 	lastAim.p = math.Clamp(lastAim.p + FrameTime() + (3 * (newAng.p > lastAim.p and 1 or -1)), (newAng.p > lastAim.p and lastAim.p or newAng.p), (newAng.p > lastAim.p and newAng.p or lastAim.p))
		-- 	lastAim.y = math.Clamp(lastAim.y + FrameTime() + (3 * (newAng.y > lastAim.y and 1 or -1)), (newAng.y > lastAim.y and lastAim.y or newAng.y), (newAng.y > lastAim.y and newAng.y or lastAim.y))
		-- 	lastAim.r = math.Clamp(lastAim.r + FrameTime() + (3 * (newAng.r > lastAim.r and 1 or -1)), (newAng.r > lastAim.r and lastAim.r or newAng.r), (newAng.r > lastAim.r and newAng.r or lastAim.r))

		-- 	pl:SetEyeAngles(newAng)
		end

		return view
	else
		if (view and view.drawviewer) then
			view.drawviewer = false
			return view
		end
	end
end)

hook.Add("ShouldDrawLocalPlayer","Thirdperson_ShouldDrawPlayer",function(pPlayer)
	return thirdperson_enabled
end)


net.Receive("thirdperson_toggle", function()
    if !( LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_UNASSIGNED ) then
		thirdperson_enabled = not thirdperson_enabled
	end
end)
