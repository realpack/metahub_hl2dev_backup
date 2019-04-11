ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Хранилище"
ENT.Category		= "SUP - Основное"
ENT.Author			= "Ferzux"
ENT.Contact			= "tochnonement@gmail.com"
ENT.Purpose			= "GMTech Entity"
ENT.Instructions	= "..."

ENT.Spawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Opened")
end