AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	-- self:PhysicsInit(SOLID_VPHYSICS)
	-- self:SetMoveType(MOVETYPE_VPHYSICS)
	-- self:SetSolid(SOLID_VPHYSICS)
	-- self:SetUseType(SIMPLE_USE)
    self:SetModel('models/Police.mdl')

	self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal()
    self:SetSolid( SOLID_BBOX )
    self:SetMoveType( MOVETYPE_STEP )
    self:CapabilitiesAdd( CAP_ANIMATEDFACE + CAP_TURN_HEAD )
    self:SetUseType( SIMPLE_USE )
    self:DropToFloor()
end


function ENT:OnTakeDamage(dmginfo)
	return
end

util.AddNetworkString('NPCJail_OpenMenu')
util.AddNetworkString('NPCJail_GoPlayer')

function ENT:AcceptInput(inputName, user)
    local pls = ents.FindInSphere(self:GetPos(), 300)
    local no_citizens = true
    local citizens = {}
    for k, v in pairs(pls) do
        if v:IsPlayer() and not v:IsCP() then
            table.insert(citizens, v)
            if no_citizens then
                no_citizens = false
            end
        end
    end

    if no_citizens then
		rp.Notify(user, NOTIFY_ERROR, 'Рядом нет никого.')
    else
        if user:IsCP() then
            net.Start('NPCJail_OpenMenu')
                net.WriteTable(citizens)
            net.Send(user)
        end
    end
end

net.Receive('NPCJail_GoPlayer', function(len, player)
-- netstream.Hook("NPCJail_GoPlayer", function(player, data)
    local target = net.ReadEntity()
	-- local jail_id = net.ReadString()

    -- if not JAIL_VECTORS[jail_id] then
    --     return
    -- end

    if not player:IsCP() then
        return
    end

    if target:IsCP() or target:IsArrested() then
        return
    end

	local npc = false
    for _, ent in pairs(ents.FindInSphere(player:GetPos(), 300)) do
        if ent:GetClass() == 'combine_jail' then
            npc = ent
            break
        end
    end

	print(tostring(npc))
	print(not player:IsCP(), target:IsCP(), target:IsArrested(), target:GetPos():DistToSqr(npc:GetPos()) < 128^2 )


    if npc and target:GetPos():DistToSqr(npc:GetPos()) < 128^2 then
		target:Arrest(player, '')
        -- target:SetNVar('meta_jailed', true, NETWORK_PROTOCOL_PUBLIC)
        -- target:StripWeapons()
        -- target:SetPos(JAIL_VECTORS[jail_id])

        -- timer.Simple(120, function()
        --     -- target:SetNVar('meta_jailed', false, NETWORK_PROTOCOL_PUBLIC)
        --     target:Spawn()
        -- end)
    end
end)
