AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/props_wasteland/cargo_container01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetOpened(true)
end

util.AddNetworkString("gmt.opens")
net.Receive("gmt.opens", function(l, p)
	local ent = p.usedEnt
	if ent:GetOpened() then
		ent:Open()
	end
	p.usedEnt = nil
end)

function ENT:Open()
	self:SetOpened(false)

	local button = ents.Create( "ent_cpbox" )
	if ( !IsValid( button ) ) then return end
	button:SetModel( "models/props_junk/TrashDumpster02.mdl" )
	button:SetPos( self:GetPos()+self:GetRight()*-240+self:GetUp()*12 )
	button:Spawn()
    button:Activate()
	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos()+self:GetRight()*-210+self:GetUp()*12 )
	effectdata:SetMagnitude(3)
	effectdata:SetScale(2)
	effectdata:SetRadius(2)
	util.Effect( "Sparks", effectdata )
    timer.Simple(1200, function() self:SetOpened(true) end)
end

function ENT:Use( activator )
	if !activator:isCP() then
		if self:GetOpened() then		
			activator.usedEnt = self
			activator:SendLua("Progress(LocalPlayer(), 5, 'Взлом', 'opens', 'ent_cpstorage', gmt.color.green, 'sndspam1')")
		else
			notify(activator, "Контейнер пуст, ожидайте прибытия нового.")
		end
	end
end