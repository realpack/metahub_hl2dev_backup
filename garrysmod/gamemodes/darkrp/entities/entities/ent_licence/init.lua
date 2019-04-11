AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_lab/clipboard.mdl')

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self:PhysWake()
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	rp.Notify(pl, NOTIFY_GREEN, rp.Term('GunLicenseActive'))
	pl:SetNetVar('HasGunlicense', true)

	self:Remove()
end