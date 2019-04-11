ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Коробка"
ENT.Category		= "SUP - Основное"
ENT.Author			= "Ferzux"
ENT.Contact			= "tochnonement@gmail.com"
ENT.Purpose			= "GMTech Entity"
ENT.Instructions	= "..."

ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Opened")
	self:NetworkVar("Bool", 1, "Hacked")
end