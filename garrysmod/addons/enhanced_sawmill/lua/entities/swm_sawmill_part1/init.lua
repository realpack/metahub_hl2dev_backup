AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate1x2.mdl")
	self:SetMaterial("models/props_pipes/GutterMetal01a")

end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
