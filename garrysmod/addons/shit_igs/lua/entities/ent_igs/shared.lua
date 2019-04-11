ENT.Type      = "anim"
ENT.Base      = "base_anim"
ENT.PrintName = "Донат итем"
ENT.Author    = "gm-donate.ru"
ENT.Category  = "IGS"

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("String", 0, "UID")
	self:NetworkVar("Bool",   0, "Global")
	self:NetworkVar("Int",    0, "Amount")
end
