ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Battery"
ENT.Author = "Tomas"
ENT.Spawnable = false
ENT.AdminSpawnable = false


function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end