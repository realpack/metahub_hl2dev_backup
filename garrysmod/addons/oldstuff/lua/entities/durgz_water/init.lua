AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/props_junk/garbage_milkcarton001a.mdl"

ENT.HASHIGH = false

ENT.LASTINGEFFECT = 0;

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
	self:Soberize(activator)
end
