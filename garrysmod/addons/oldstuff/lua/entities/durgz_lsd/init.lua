AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.MODEL = "models/bioshockinfinite/hext_bottle_lager.mdl"


ENT.LASTINGEFFECT = 60; --how long the high lasts in seconds

--called when you use it (after it sets the high visual values and removes itself already)
function ENT:High(activator,caller)
    local sayings = {
        "щас бы футбольчик посмотреть",
    }
    self:Say(activator, sayings)
end
