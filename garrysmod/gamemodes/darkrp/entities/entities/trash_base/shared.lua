ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Trash Base"
ENT.Author = ""
ENT.Category = "Metahub"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity",1,"owning_ent")
end
