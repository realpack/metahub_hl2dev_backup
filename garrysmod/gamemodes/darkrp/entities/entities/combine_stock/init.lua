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
    if not activator:IsCP() and nw.GetGlobal('CPCode') ~= 'red' then
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
    'swb_aug',
    'swb_m4a1',
    'swb_usp',
    'swb_m249',
    'swb_ar2',
    'swb_357',
    'swb_shotgun',
}

-- netstream.Hook( "HackStockMenu", function( ply, data )
net.Receive('HackStockMenu', function( len, ply )
    if CLIENT then return end

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

    -- ent:Remove()

    timer.Simple(1, function()
        if not ent then return end
        -- ent:Remove()
        nw.SetGlobal('CPCode', 'red')
        BroadcastLua( "surface.PlaySound('gmtech_dispatch/1/jw.mp3')" )
        rp.NotifyAll(NOTIFY_ERROR, 'Цитадель объявила красный код. Причина: Взлом арсенала, '..ply:Name()..'.' )

        -- print('------------------------|')

        local Limit = rp.cfg.InvLimit
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

        ply:SaveInv()
        ply:SendInv()
        rp.Notify(ply, NOTIFY_GREEN, 'Вы взломали арсенал альянса. Мы заполнили ваш инвентарь большим количеством оружия, удачи!')
    end)
end )
