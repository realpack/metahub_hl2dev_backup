ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Раздатчик воды"
ENT.Category		= "SUP - Завод"
ENT.Author			= "Ferzux"
ENT.Contact			= "tochnonement@gmail.com"
ENT.Purpose			= "GMTech Entity"
ENT.Instructions	= "..."

ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Disabled")
	self:NetworkVar("Bool", 1, "Dispensing")
end