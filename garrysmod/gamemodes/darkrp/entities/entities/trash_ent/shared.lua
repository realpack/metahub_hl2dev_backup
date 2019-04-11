ENT.Type            = "anim"
ENT.Base            = "base_anim"
ENT.PrintName       = "Scrapmetal 2"
ENT.Information		= "\nPress E to pickup trash."
ENT.Category		= "MetaHub"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.TakeDuration        = 3

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
end
