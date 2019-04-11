AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

-- function ENT:Initialize()
-- 	-- local intCount = self:GetNVar('Count')
-- 	self:SetModel('models/props/cs_assault/Money.mdl')

-- 	self:PhysicsInit( SOLID_VPHYSICS )
-- 	self:SetMoveType( MOVETYPE_VPHYSICS )
-- 	self:SetSolid( SOLID_VPHYSICS )

-- 	-- Wake the physics object up
-- 	local phys = self.Entity:GetPhysicsObject()
-- 	if (phys:IsValid()) then
-- 		phys:EnableMotion( true )
-- 		phys:Wake()
-- 	end
-- end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/props_junk/gascan001a.mdl")
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
		-- self:SetText("НАЖМИТЕ 'E'")
		-- self:DrawShadow(false)
		-- self:SetDispColor(COLOR_GREEN)
		-- self.canUse = true

		-- Use prop_dynamic so we can use entity:Fire("SetAnimation")
		self.dummy = ents.Create("prop_dynamic")
		self.dummy:SetModel("models/props_combine/combine_dispenser.mdl")
		self.dummy:SetPos(self:GetPos())
		self.dummy:SetAngles(self:GetAngles())
		self.dummy:SetParent(self)
		self.dummy:Spawn()
		self.dummy:Activate()

		self:DeleteOnRemove(self.dummy)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

function ENT:Use( pActivator, pCaller )
	self:Dispense( pActivator )
end

function ENT:CreateRation( pActivator )
	local entity = ents.Create("prop_physics")
	entity:SetAngles(self:GetAngles())
	entity:SetModel("models/weapons/w_package.mdl")
	entity:SetPos(self:GetPos())
	entity:Spawn()
	entity:SetNotSolid(true)
	entity:SetParent(self.dummy)
	entity:Fire("SetParentAttachment", "package_attachment")

	timer.Simple(1.5, function()
		if (IsValid(self) and IsValid(entity)) then
			entity:Remove()
			local Limit = 8

			local p = pActivator:GetInv()
			if (table.Count(p) >= Limit) then
				rp.Notify(pActivator, NOTIFY_GREEN, "В вашем чемодане нету места")
				return
			end

			local cl = rp.cfg.RationLevels[rp.teams[pActivator:Team()].type]

			local tab = {}
			tab.Class = cl

			local sh_data = false
			for i, s in pairs(rp.entities) do
				if s.ent == cl then
					sh_data = s
				end
			end

			if not sh_data then return end

			tab.Model = sh_data.model
			tab.Title = sh_data.name

			net.Start("Pocket.AddItem")
				net.WriteUInt(ID, 32)
				net.WriteString(tab.Title)
				net.WriteString('')
				net.WriteString(tab.Model)
			net.Send(pActivator)

			p[ID] = tab

			pActivator:SaveInv()

			ID = ID + 1

			-- pActivator:AddItem(FindItem(ration_type))
			-- meta.util.Notify('green', pActivator, 'Вы получили свой рацион. Мы положили его вам в инвентарь.')
			rp.Notify(pActivator, NOTIFY_GREEN, 'Вы получили свой рацион. Мы положили его вам в чемодан.')
		end
	end)
end

function ENT:Dispense( pActivator )
	self.rations = self.rations or {}

	local steam_id = pActivator:SteamID()

	if not self.rations[ steam_id ] or pActivator:IsUserGroup('founder') then
		self:EmitSound("ambient/machines/combine_terminal_idle4.wav")
		self:CreateRation( pActivator )
		self.dummy:Fire("SetAnimation", "dispense_package", 0)

		self.rations[ steam_id ] = true

		timer.Simple(900,function()
			self.rations[ steam_id ] = nil
		end)
	else
		-- meta.util.Notify('red', pActivator, 'Вы недавно уже получали рацион.')
		rp.Notify(pActivator, NOTIFY_ERROR, 'Вы недавно уже получали рацион.')
	end
end

function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end
