AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

util.AddNetworkString('NPCJobs_OpenMenu')

function ENT:Initialize()
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal()
	self:SetSolid( SOLID_BBOX )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:CapabilitiesAdd( CAP_ANIMATEDFACE + CAP_TURN_HEAD )
	self:SetUseType( SIMPLE_USE )
	-- self:DropToFloor()
    self.jobs = self.jobs or {}
    self.name = self.name or 'Test'
    self.npc_id = self.npc_id or 'npc_test'

    self:SetModel('models/mossman.mdl')
end


function ENT:OnTakeDamage(dmginfo)
	return
end

function ENT:AcceptInput(inputName, user)
	if user:IsStalker() then return end

    local teams = self.jobs
    net.Start('NPCJobs_OpenMenu')
        net.WriteString(self.npc_id)
        net.WriteTable(teams)
    net.Send(user)
end
