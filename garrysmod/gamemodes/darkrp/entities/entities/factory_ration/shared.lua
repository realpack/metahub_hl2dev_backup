ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Рацион"
ENT.Category		= "SUP - Завод"
ENT.Author			= "Ferzux"
ENT.Contact			= "tochnonement@gmail.com"
ENT.Purpose			= "GMTech Entity"
ENT.Instructions	= "..."

ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Done")
	self:NetworkVar("Int", 1, "Food")
	self:NetworkVar("Int", 2, "Water")
end