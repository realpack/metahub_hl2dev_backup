ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Combine Terminal"
ENT.Author = ""
ENT.Category = "MetaHub"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar("Entity",1,"owning_ent")
end
