ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Control Point"
ENT.Author = ""
ENT.Category = "RP"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
  self:NetworkVar("String",0,"Id")
  self:NetworkVar("String",1,"Fraction")
end
