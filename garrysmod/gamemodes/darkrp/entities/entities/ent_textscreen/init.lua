-- resource.AddFile("resource/fonts/SHREK___.TTF")

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:DrawShadow( false )
	self:SetModel("models/hunter/plates/plate1x1.mdl")
	self:SetMaterial("models/effects/vol_light001")
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	for i = 1, 3 do
		self:SetNetVar("Text"..i, "")
		self:SetNetVar("r"..i, 255)
		self:SetNetVar("g"..i, 255)
		self:SetNetVar("b"..i, 255)
		self:SetNetVar("a"..i, 255)
		self:SetNetVar("size"..i, 50)
	end
	self.heldby = 0
	self:SetMoveType(MOVETYPE_NONE)
end

function ENT:PhysicsUpdate(phys)
	if self.heldby <= 0 then
		phys:Sleep()
	end
end

local function textscreenpickup(ply, ent)
	if IsValid(ent) and ent:GetClass() == "ent_textscreen" then
		ent.heldby = ent.heldby+1
	end
end
hook.Add("PhysgunPickup", "textscreenpreventtravelpickup", textscreenpickup)

local function textscreendrop(ply, ent)
	if IsValid(ent) and ent:GetClass() == "ent_textscreen" then
		ent.heldby = ent.heldby-1
	end
end
hook.Add("PhysgunDrop", "textscreenpreventtraveldrop", textscreendrop)

function ENT:UpdateText(NewFont, NewText, NewColor, NewSize)
	for i = 1, 3 do
		if NewFont[i] and NewText[i] and NewColor[i] and NewSize[i] then
			self:SetNetVar("Font"..i, NewFont[i])
			self:SetNetVar("Text"..i, NewText[i])
			self:SetNetVar("r"..i, NewColor[i].r)
			self:SetNetVar("g"..i, NewColor[i].g)
			self:SetNetVar("b"..i, NewColor[i].b)
			self:SetNetVar("a"..i, NewColor[i].a)
			self:SetNetVar("size"..i, NewSize[i])
		end
	end
end

local function textscreencantool(ply, trace, tool)
	if IsValid(trace.Entity) and trace.Entity:GetClass() == "textscreen" then
		if !(tool == "ent_textscreen" or tool == "remover") then
			return false
		end
	end
end
hook.Add("CanTool", "textscreenpreventtools", textscreencantool)
