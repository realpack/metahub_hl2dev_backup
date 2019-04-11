AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/sawblade001a.mdl")

end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
