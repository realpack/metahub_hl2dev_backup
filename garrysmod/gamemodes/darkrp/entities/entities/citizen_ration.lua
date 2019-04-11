AddCSLuaFile()
DEFINE_BASECLASS( "ration_base" )

ENT.PrintName = "Citizen Ration"
ENT.Spawnable = true

function ENT:Initialize()
    self:SetModel("models/pg_plops/pg_food/pg_tortellinar.mdl")

	if not SERVER then return end
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( true )
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )
end

function ENT:Use(activator,caller)
	-- local random_food = FindItem('ration1')
    -- local random_food2 = FindItem('soda')
    local random_money = math.random(100,800)

	-- ENT:AddItem(activator, '')
	local food1 = self:AddItem(activator, 'Бутылка воды')
	local food2 = self:AddItem(activator, 'Еда из рациона')
    -- activator:SaveInv()
    -- print(1, food1,food2)

    activator:SaveInv()
    activator:SendInv()

	rp.Notify(activator, NOTIFY_GREEN, 'Вы открыли "Стандартный Рацион".')
	rp.Notify(activator, NOTIFY_GREEN, 'В рационе вы нашли '..food1..', '..food2..', '..rp.FormatMoney(random_money)..' наличными.')

    self:ExtraRationMoney(activator)

    -- activator:AddItem(random_food)
    -- activator:AddItem(random_food2)
    activator:AddMoney(random_money)

    self:Remove()
end
