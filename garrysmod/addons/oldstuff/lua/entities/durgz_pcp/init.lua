AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/props_junk/garbage_plasticbottle001a.mdl"

ENT.MASS = 2; --the model is too heavy so we have to override it with THIS

ENT.LASTINGEFFECT = 20; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
		
	local sayings = {
	    "щас блевану",
        "господи, почему я это вообще выпил",
	}
	self:Say(activator, sayings)
		
end

