ENT.Type            = "anim"
ENT.Base            = "base_gmodentity"

ENT.PrintName       = "Fire Hydrant"
ENT.Category        = "City Worker"
ENT.Author          = "Silhouhat"
ENT.Contact 	    = "contact@silhouhat.com"

ENT.Spawnable   	= false

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "Leaking" )
end