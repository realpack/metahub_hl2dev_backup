if SERVER then
	AddCSLuaFile()
end

ENT.Base                  = "base_ai"
ENT.Type                  = "ai"
ENT.PrintName             = "Терминал Стазис"
ENT.Category              = "Metahub - Stasis"
ENT.Spawnable             = true

local STASIS_PRICE = 3000

function ENT:Initialize()

	if ( CLIENT ) then return end

	self:SetModel( "models/props_combine/breenpod.mdl" )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

end

function ENT:UpdateStatus(ply, num)
	timer.Simple(5, function()
		meta.util.Notify("cyan", ply, "Стадия "..num.."/5")
		ply:EmitSound("npc/metropolice/gear"..math.random(1, 6)..".wav")

		if num ~= 5 then
			self:UpdateStatus(ply, num + 1)
		else
			ply:Freeze(false)
			ply:SetNWBool("cpota", false)
			ply:SetTeam( TEAM_SUP1 )
			ply:Spawn()
		end
	end)
end

function ENT:AcceptInput(type_, ply)
	if not ply:GetNWBool("cpota") then
		meta.util.Notify("red", ply, "Вы не можете использовать терминал.")
		return
	end

	ply:Freeze(true)
	ply:SelectWeapon("weapon_hands")
	ply:SetPos(STASIS_POS)
	ply:SetEyeAngles(STASIS_ANGLE)
	ply:SetRenderMode( RENDERMODE_TRANSALPHA )
	ply:Fire( "alpha", visibility, 0 )

	self:UpdateStatus(ply, 1)
end

function ENT:Draw()
	self:DrawModel()
end
