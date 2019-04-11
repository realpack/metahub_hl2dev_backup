function ENTITY:InBox(p1, p2)
	return self:GetPos():WithinAABox(p1, p2) 
end

local s = rp.cfg.Spawns[game.GetMap()]
function ENTITY:InSpawn()
	if not s then return false end
	if self.IsInSpawn and (self.IsInSpawn >= CurTime()) then return true end
	return self:InBox(s[1], s[2])
end

local wep_classes = {
	weapon_crowbar 		= true,
	weapon_stunstick 	= true,
	weapon_c4 			= true
}
function ENTITY:IsIllegalWeapon()
	return wep_classes[self:GetClass()] and wep_classes[self:GetClass()] or (string.sub(self:GetClass(), 0, 3) == 'swb')
end

-- Sight checks
if (SERVER) then return end

-- I try too hard
local LocalPlayer 			= LocalPlayer 
local GetPos 				= ENTITY.GetPos
local EyePos 				= ENTITY.EyePos
local DistToSqr 			= VECTOR.DistToSqr
local IsLineOfSightClear 	= ENTITY.IsLineOfSightClear
local util_TraceLine 		= util.TraceLine

local lp
local trace = {
	mask 	= -1,
	filter 	= {},
}

function ENTITY:InSight()
	return false
end

function PLAYER:InSight()
	return false
end

function ENTITY:InTrace()
	return false
end

function PLAYER:InTrace()
	return false
end

hook('Think', 'VisChecks', function()
	if IsValid(LocalPlayer()) then
		lp = LocalPlayer()
		trace.filter[1] = LocalPlayer()

		function ENTITY:InSight()
			if (DistToSqr(GetPos(self), GetPos(lp)) < 250000) then
				return IsLineOfSightClear(lp, self)
			end
			return false
		end

		function PLAYER:InSight()
			if (DistToSqr(EyePos(self), EyePos(lp)) < 250000) then
				return IsLineOfSightClear(lp, self)
			end
			return false
		end

		function ENTITY:InTrace()
			trace.start 	= EyePos(lp)
			trace.endpos 	= GetPos(self)
			trace.filter[2] = self

			return not util_TraceLine(trace).Hit
		end

		function PLAYER:InTrace()
			trace.start 	= EyePos(lp)
			trace.endpos 	= EyePos(self)
			trace.filter[2] = self

			return not util_TraceLine(trace).Hit
		end

		hook.Remove('Think', 'VisChecks')
	end
end)