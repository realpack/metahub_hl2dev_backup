ENT.Base = "base_anim"
ENT.Type = "anim"

ENT.PrintName = "Handcuffs Point (NoUse)"
ENT.Author = "pack"
ENT.Category = "MetaHub | Разработки"

function ENT:SetupDataTables()
  self:NetworkVar("Entity",0,"HandcuffsPlayer")
end
