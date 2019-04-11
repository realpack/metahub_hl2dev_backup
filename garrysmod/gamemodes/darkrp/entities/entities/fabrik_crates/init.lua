AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/props_junk/cardboard_box003a.mdl')

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end
end

util.AddNetworkString('SetBoxBool')

function ENT:AcceptInput( Name, pActivator, pCaller )
	if not pActivator.bWearBox then
		if ((self.nextUse or 0) >= CurTime()) then
			return
		end
		self.nextUse = CurTime() + 1

        -- print(1)

		if pActivator:IsCP() then
			-- meta.util.Notify('red', pActivator, 'Вы не можете это сделать.')
            rp.Notify(pActivator, NOTIFY_GENERIC, 'Вы не можете это сделать.')
			return
		end

		pActivator.WeaponsBox = {}

		for _, wep in pairs(pActivator:GetWeapons()) do
			if wep:GetClass() then
				table.insert(pActivator.WeaponsBox, wep:GetClass())
			end
		end

        -- print(2)

        rp.Notify(pActivator, NOTIFY_GENERIC, 'Вы взяли коробку в руки, теперь отнесить ее на склад.')

		pActivator:StripWeapons()

		pActivator:SelectWeapon('weapon_hands')
		local SWEP = pActivator:GetActiveWeapon()
		function SWEP:Holster()
			return false
		end

        -- print(3)


		-- meta.util.Notify('yellow', pActivator, 'Вы взяли коробку в руки, теперь отнесить ее на склад.')

		-- CreatePoint({pActivator}, ents.FindByClass('fabrik_npc')[1]:GetPos(), '', 'Склад')


		-- netstream.Start(player.GetAll(), "SetBoxBool", {pPlayer = pActivator,bWearBox = true});
        net.Start('SetBoxBool')
            net.WriteEntity(pActivator)
            net.WriteBool(true)
        net.Send(player.GetAll())
		pActivator.bWearBox = true
	end
end

function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end
