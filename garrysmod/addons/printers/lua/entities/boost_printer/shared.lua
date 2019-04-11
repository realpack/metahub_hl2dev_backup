ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer"
ENT.Author = "Tomas (fixed shit by roni_sl)"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.printer_type = "blue"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 0, "Battery")
	self:NetworkVar("Int", 1, "Heat")
	self:NetworkVar("Int", 2, "PrintSpeed")
	self:NetworkVar("Int", 3, "PrintedMoney")
	self:NetworkVar("Int", 4, "Cooling")
	self:NetworkVar("Int", 5, "PrintRate")
end
