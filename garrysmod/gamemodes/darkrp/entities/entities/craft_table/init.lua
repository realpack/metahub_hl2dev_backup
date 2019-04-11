AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_c17/FurnitureTable003a.mdl" )

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
	self.InUse = false
end

util.AddNetworkString('OpenCraftMenu')
util.AddNetworkString('CraftItem')

local function FindItem(cl)
	local next = false
	if not next then for _, it in pairs(rp.shipments) do if it.entity == cl or it.name == cl then next = it break end end end
	if not next then for _, it in pairs(rp.entities) do if it.ent == cl or it.name == cl then next = it break end end end
	if not next then for name, it in pairs(rp.Foods) do if name == rp.inv.Wl[cl] or it.name == cl then next = it next.name = name break end end end

	return next
end

function ENT:Use( activator, caller )
    if not activator:IsCP() then
        net.Start('OpenCraftMenu')
        net.Send(activator)
    end
end

net.Receive('CraftItem', function( len, pl )
    if (pl.LastCraft or 0) > CurTime() then
        return
    end
    pl.LastCraft = CurTime() + 1

    local near = false
    for _, ent in pairs(ents.FindByClass('craft_table')) do
        if pl:GetPos():DistToSqr(ent:GetPos()) < 128^2 then
            near = true
            break
        end
    end

    if not near then return end

    local class = net.ReadString()
    if not class then return end

    local item = FindItem(class)
    if not item then return end

    local crafts = {}
    local counts = {}
    local recipe = rp.cfg.CraftRecipes[class]

    for cl, count in pairs(recipe) do
        for i, it in pairs(pl:GetInv()) do
            local it_store = FindItem(it.name or it.Title)
            local it_class = it_store.entity or it_store.ent
            local re_store = FindItem(cl)
            local item_class = re_store.ent or re_store.entity

            if it_class == cl then
                counts[item_class] = counts[item_class] or 0

                if it.count then
                    counts[item_class] = counts[item_class]+it.count
                else
                    counts[item_class] = counts[item_class]+1
                end

                crafts[cl] = crafts[cl] or false

                if crafts[cl] == false and item_class == cl and counts[item_class] >= count then
                    crafts[cl] = true
                end
            end
        end
    end

    local can_craft = not table.HasValue(crafts, false) and true or false
    if not can_craft then return end

    local inv = pl:GetInv()
    for k, item in pairs(inv) do
        local item_store = FindItem(item.Title)
        local item_class = item_store.ent or item_store.entity
        local count = recipe[item_class]
        if count then
            if item.count then
                if count >= item.count then
                    inv[k] = nil
                    count = count - item.count
                else
                    inv[k].count = inv[k].count - count
                end
            else
                inv[k] = nil
                count = count - 1
            end
        end
    end

    local tab = {}
    tab.Class = class

    local sh_data = FindItem(class)

    if not sh_data then return end

    tab.Model = sh_data.model
    tab.Title = sh_data.name

    net.Start("Pocket.AddItem")
        net.WriteUInt(ID, 32)
        net.WriteString(tab.Title)
        net.WriteString('')
        net.WriteString(tab.Model)
    net.Send(pl)

    inv[ID] = tab

    ID = ID + 1

    pl:SaveInv()
    pl:SendInv()
end)
