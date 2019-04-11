ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "NPC for take jobs"
ENT.Spawnable = true
ENT.Category = "MetaHub"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"Title")
    self:NetworkVar("String",1,"TitleColor")
end
