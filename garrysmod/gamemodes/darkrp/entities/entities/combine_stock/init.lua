AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()
	self:SetModel( "models/cca_tech_props/combine_cargo01a.mdl" )

    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- self:SetNVar('Items',{},NETWORK_PROTOCOL_PRIVATE)

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )
	self.InUse = false
end

util.AddNetworkString('OpenStockMenu')
util.AddNetworkString('HackStockMenu')

function ENT:Use( activator, caller )
    if not activator:IsCP() then
        net.Start('OpenStockMenu')
        net.Send(activator)
    end
	-- if self.InUse then
	-- 	meta.util.Notify('red', activator, 'Кто-то уже лутает этот портфель.')
	-- 	return
	-- end


	-- if self and activator and self:GetNVar('Items') then
	-- 	local to_t = { entity = self, items = self:GetNVar('Items') }
	-- 	if to_t then
	-- 		netstream.Start( activator, "OpenCrateMenu", to_t )
	-- 	end
	-- end
	-- self.InUse = true
end

local table_random = {
    'cw_357',
}

-- netstream.Hook( "HackStockMenu", function( ply, data )
net.Receive('HackStockMenu', function( len, ply )
    local ent = false
    for _, e in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
        if e:GetClass() == 'combine_stock' then
            ent = e
            break
        end
    end

    if not ent then
        return
    end

    nw.SetGlobal('CPCode', 'red')
    rp.NotifyAll(NOTIFY_ERROR, 'Цитадель объявила красный код. Причина: Взлом арсенала, '..ply:Name()..'.' )

    local Limit = 8
    local item_names = {}
    for i = 1, 20 do
        local p = ply:GetInv()
        if (table.Count(p) < Limit) then
            local cl = table.Random(table_random)
            local b = math.random(1, 2)==2
            if b then
                local tab = {}
                tab.Class = cl

                local sh_data = false
                for i, s in pairs(rp.shipments) do
                    if s.entity == cl then
                        sh_data = s
                    end
                end
                if not sh_data then return end

                tab.Model = sh_data.model
                tab.Title = sh_data.name

                item_names[ID] = tab.Title

                p[ID] = tab

                ID = ID + 1
            end
        end
    end

    if ent then
        ply:SaveInv()
        ply:SendInv()
        rp.Notify(ply, NOTIFY_GREEN, 'Вы взламали арсинал альянса. Мы заполнили ваш инвентарь большим количеством оружия, удачи!')
    end
    ent:Remove()
end )
