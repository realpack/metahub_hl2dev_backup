ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "[MGS] Wooden Cart"
ENT.Author = "James"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",0,"owning_ent")
end