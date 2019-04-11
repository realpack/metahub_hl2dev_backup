AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:SetModel( "models/props_c17/Lockers001a.mdl" )

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
end


function ENT:Use( activator, caller )
    if not activator:IsCP() then
        rp.Notify(activator, NOTIFY_ERROR, 'Вы не можете использовать шкаф.')
        return
    end

    if rp.cfg.CombineCupboard[activator:Team()] then
        for _, wep in pairs(rp.cfg.CombineCupboard[activator:Team()]) do
            activator:Give(wep)
        end

        local wep = activator:GetActiveWeapon()
        local weps = rp.cfg.CombineCupboard[activator:Team()]
        if weps and table.HasValue(weps, wep:GetClass()) then
            activator:SetAmmo(400, game.GetAmmoName(wep:GetPrimaryAmmoType()))
        else
            rp.Notify(activator, NOTIFY_ERROR, 'Вы не можете взять амуницию на это оружие.')
        end
    end

end
