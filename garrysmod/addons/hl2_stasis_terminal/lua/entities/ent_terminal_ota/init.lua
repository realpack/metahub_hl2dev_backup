AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("stasis.open_terminal")
util.AddNetworkString("stasis.give_something")

function ENT:Initialize()
	self:SetModel( "models/props_combine/combine_interface001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE )

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end

end

function ENT:AcceptInput(_, ply)
	local job = rp.teams[ply:Team()]

	if not job.type == TEAMTYPE_COMBINE then
		meta.util.Notify("red", ply, "Нет доступа. Вам нужен юнит CPU.")
		return
	end

	net.Start("stasis.open_terminal")
	net.Send(ply)
end

net.Receive("stasis.give_something", function(len, ply)
	if ply:GetNWBool("cpota") then
		meta.util.Notify("red", ply, "У вас уже есть разрешение.")
		return
	end

	if not ply:CanAfford(STASIS_PRICE) then
		meta.util.Notify("red", ply, "У вас не хватает денег.")
		return
	end

	ply:EmitSound("buttons/blip1.wav")
	ply:SetNWBool("cpota", true)
	ply:AddMoney(-STASIS_PRICE)

	meta.util.Notify("green", ply, "Вам выдано разрешение на перевод в сверхчеловеческий отдел!")
end)
