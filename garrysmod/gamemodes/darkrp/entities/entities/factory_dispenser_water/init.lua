AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self:SetModel( "models/hunter/tubes/tube1x1x2c.mdl" )
	self:SetMaterial( "phoenix_storms/MetalSet_1-2" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Drop(ent)
	local ent = ents.Create( ent )
	ent:SetPos( self:GetPos() + ( self:GetForward() * 3 ) + ( self:GetUp() * 15 ) )
	ent:SetAngles( self:GetAngles() + Angle( 0, 0, 90 ) )
	ent:Spawn()
	ent:Activate()
	ent:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 10 )
end

function ENT:Toggle()

	if self:GetDisabled() then
		self:SetDisabled(false)
		self:EmitSound("buttons/button6.wav")
	else
		self:SetDisabled(true)
		self:EmitSound("buttons/lever6.wav")
	end

end

function ENT:Use(activator)
	if self:GetDisabled() then return end
	if self:GetDispensing() then return end
	if activator:IsCP() then return end

    if nw.GetGlobal('CPCode') ~= 'work' then
        rp.Notify(activator, NOTIFY_ERROR, 'Сейчас не рабочая фаза.')
        return
    end

	self:SetDispensing(true)
	self:EmitSound("buttons/button3.wav")
	timer.Simple(0.5, function()
		self:EmitSound("buttons/button4.wav")
		timer.Simple(SoundDuration("buttons/button4.wav")-1, function()
			self:Drop("factory_water")
			self:SetDispensing(false)
		end)
	end)
end
