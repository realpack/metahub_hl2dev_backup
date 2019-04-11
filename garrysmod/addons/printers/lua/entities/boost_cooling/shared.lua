ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Cooling Cell"
ENT.Author = "Tomas"
ENT.Spawnable = false
ENT.AdminSpawnable = false


function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end