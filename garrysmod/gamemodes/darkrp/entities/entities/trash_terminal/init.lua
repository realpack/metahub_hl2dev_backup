AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel( "models/props_combine/combine_interface003.mdl" )

    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )
end


function ENT:OnTakeDamage(dmginfo)
	return
end

util.AddNetworkString('TrashTerminal_OpenMenu')
util.AddNetworkString('TrashTerminal_SaleItem')

function ENT:AcceptInput(inputName, user)
	local prot = nw.GetGlobal('CPCode')
    -- print(prot)

	if prot == 'work' then
		net.Start('TrashTerminal_OpenMenu')
			net.WriteEntity(self)
		net.Send(user)
	else
		rp.Notify(user, NOTIFY_ERROR, 'Должна быть рабочая фаза чтобы вы смогли продвать мусор!')
	end
end

net.Receive('TrashTerminal_SaleItem', function(len, pPlayer)
    local near_npc = false
    local item_id = tonumber(net.ReadString())
    local target = net.ReadEntity()

    if pPlayer:GetPos():DistToSqr(target:GetPos()) < 128^2 then
        for k, item in pairs(pPlayer:GetInv()) do
            if k == item_id then
                local price = rp.cfg.Trash[item.Class]

				if not price then return end
				price = price*1.6

                pPlayer:AddMoney(price)

				pPlayer:GetInv()[k] = nil
				pPlayer:SaveInv()
				net.Start("Pocket.RemoveItem")
					net.WriteUInt(k, 32)
				net.Send(pPlayer)

				rp.Notify(pPlayer, NOTIFY_GREEN, 'Вы продали "'..item.Title..'" и получили за это '..rp.FormatMoney(price)..'!')
                break
            end
        end
    end
end)

-- netstream.Hook('TrashTerminal_SaleAllItems',function(pPlayer, data)
--     local near_npc = false
--     local target = data.npc

--     if pPlayer:GetPos():DistToSqr(target:GetPos()) < 128^2 then
-- 		near_npc = true
-- 	end

--     local с_items = {}
-- 	local inv_items = pPlayer:GetItems()
-- 	if near_npc then
-- 		for k, item in pairs(inv_items) do
--             local price = TRASH_RANDOM_ITEMS[item.ID]
-- 			if price then
-- 				pPlayer:AddMoney(price)

-- 				meta.util.Notify('blue', pPlayer, 'Вы продали "'..item.Name..'" и получили за это '..formatMoney(price)..'!')

--                 с_items[k] = true
-- 			end
-- 		end
-- 	end

--     for k, v in pairs(с_items) do -- fuck u, Lua
--         if v == true then
--             table.remove(inv_items, k)
--         end
--     end

-- 	if #inv_items <= 0 then
-- 		inv_items = {}
-- 	end

-- 	pPlayer:SaveInventory(inv_items)
-- end)
