AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')
 
function ENT:Initialize()
 
	self:SetModel( "models/cca_tech_props/combine_cargo01a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	self:GetPhysicsObject():SetMass(105);
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

util.AddNetworkString("gmt.robstorage")
net.Receive("gmt.robstorage", function(l, p)
	local ent = p.usedEnt
	ent:EmitSound("physics/cardboard/cardboard_box_break2.wav")
		local randomweapons = {"swb_ak47","swb_mp5","swb_fiveseven","swb_p228","swb_ump","swb_mac10"}
		local randomitems = {"clothes_torse_rebexheavy","clothes_torse_rebheavy","clothes_torse_rebeasy"}

		local rnd = math.random(1,3)
		if rnd == 1 then
			p:addMoney(math.random(1000,5000))
		elseif rnd == 2 then
			addInv(p, table.Random(randomweapons))
		elseif rnd == 3 then
			addInv(p, table.Random(randomitems))
		end

	p.usedEnt = nil
end)

util.AddNetworkString("gmt.openbox")
net.Receive("gmt.openbox", function(l, p)
	local ent = p.usedEnt
	ent:Open()
	p.usedEnt = nil
end)

util.AddNetworkString("gmt.fail")
net.Receive("gmt.fail", function(l, p)
	local ent = p.usedEnt
	ent:Alarm()
	p.usedEnt = nil
end)

util.AddNetworkString("gmt.sndspam1")
net.Receive("gmt.sndspam1", function(l, p)
	p:EmitSound("physics/metal/metal_box_impact_hard"..math.random(1,3)..".wav")
end)

util.AddNetworkString("gmt.sndspam2")
net.Receive("gmt.sndspam2", function(l, p)
	p:EmitSound("physics/body/body_medium_impact_soft"..math.random(1,7)..".wav")
end)

function ENT:Close()
	self:SetModel( "models/cca_tech_props/combine_cargo01a.mdl" )
	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetOpened(false)
	timer.Simple(60, function() self:Remove() end)
end

function ENT:Alarm()
	timer.Create("alarm_"..self:EntIndex(), 5, 12, function()
		self:EmitSound("gmtech_sounds/alarm_moon.wav")
	end)
end

function ENT:Open()
	for k, v in pairs(player.GetAll()) do
		if v:isCP() then
			sendGPS(v, self:GetPos(), "Обнаружен сбой в защите контейнера!", "icon16/stop.png", 90)
		end
	end

	self:EmitSound("physics/metal/metal_box_break1.wav")
	self:SetHacked(true)
	self:EmitSound("buttons/lever1.wav")
	timer.Simple(0.75, function()
		self:EmitSound("buttons/lever4.wav")
		timer.Simple(1, function()
			self:EmitSound("buttons/lever5.wav")
			timer.Simple(1, function()
				self:EmitSound("physics/metal/metal_box_break1.wav")
				self:SetModel("models/cca_tech_props/combine_cargo_open01a.mdl")
				self:SetOpened(true)
				local effectdata = EffectData()
				effectdata:SetOrigin( self:GetPos() )
				effectdata:SetMagnitude( 10 )
				util.Effect( "ElectricSpark", effectdata )
				timer.Simple(30, function() self:Close() self:Alarm() end)
			end)
		end)
	end)
end


function ENT:Use( activator )
	if !activator:isCP() then
		if self:GetOpened() then
			activator.usedEnt = self
			activator:SendLua("Progress(LocalPlayer(), 5, 'Поиск вещей', 'robstorage', 'ent_cpbox', gmt.color.blue, 'sndspam2')")
		else
			if !self:GetHacked() then
				activator.usedEnt = self
				activator:SendLua("Hack(5, 'openbox')")
			end
		end
	end
end