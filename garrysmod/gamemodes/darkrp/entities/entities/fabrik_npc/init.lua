AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:SetHullType( HULL_HUMAN ) -- Sets the hull type, used for movement calculations amongst other things.
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX ) -- This entity uses a solid bounding box for collisions.
	self:SetSequence( self:LookupSequence( "idle" ) )
	self:SetUseType( SIMPLE_USE ) -- Makes the ENT.Use hook only get called once at every use.
	-- self:DropToFloor()
	self:SetModel('models/Characters/hostage_04.mdl')
	self:SetMaxYawSpeed( 90 ) --Sets the angle by which an NPC can rotate at once.
end

function ENT:AcceptInput( Name, pActivator, pCaller )
	if Name == "Use" and pCaller:IsPlayer() then
        print(pActivator.bWearBox)
		if (pActivator.bWearBox) then
			-- netstream.Start(player.GetAll(), "SetBoxBool", {pPlayer = pActivator,bWearBox = false,eEnt = self});
            net.Start('SetBoxBool')
                net.WriteEntity(pActivator)
                net.WriteBool(false)
            net.Send(player.GetAll())
			pActivator.bWearBox = false

			local SWEP = pActivator:GetActiveWeapon()
			function SWEP:Holster()
				return true
			end

			for _, wep in pairs(pActivator.WeaponsBox) do
				if wep then
					pActivator:Give(wep)
				end
			end

			-- meta.util.Notify('green', pActivator, 'За коробку вы получили '..formatMoney(self.MoneyForBox)..'.')
            rp.Notify(pActivator, NOTIFY_GENERIC, 'За коробку вы получили '..rp.FormatMoney(self.MoneyForBox)..'.')
			pActivator:AddMoney(self.MoneyForBox)
		else
			-- meta.util.Notify('red', pActivator, 'У вас нету коробки, зачем вы сюда пришли?')
            rp.Notify(pActivator, NOTIFY_GENERIC, 'У вас нету коробки, зачем вы сюда пришли?')
		end
	end
end

function ENT:isPlayerNear(pPlayer)
	return (self:GetPos():DistToSqr(pPlayer:GetPos()) <= 5000)
end

function ENT:Think()
    -- We don't need to think, we are just a prop after all!
end

if SERVER then
	hook.Add( "KeyPress", "CheckPlayerJumping", function(pPlayer, key)
		if ( key == IN_JUMP and pPlayer.bWearBox) then
			-- netstream.Start(player.GetAll(), "SetBoxBool", {pPlayer = pPlayer,bWearBox = false,eEnt = false});
            net.Start('SetBoxBool')
                net.WriteEntity(pPlayer)
                net.WriteBool(false)
            net.Send(player.GetAll())
			pPlayer.bWearBox = false

			local SWEP = pPlayer:GetActiveWeapon()
			function SWEP:Holster()
				return true
			end

			for _, wep in pairs(pPlayer.WeaponsBox) do
				if wep then
					pPlayer:Give(wep)
				end
			end

			-- sprawl.util.AddNotify(pPlayer,'Вы уронили ящик. :C', 1, 2)
		end
	end)
end
