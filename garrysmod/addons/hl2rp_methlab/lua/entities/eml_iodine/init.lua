AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
include("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_lab/jar01b.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	
	self:SetNWInt("distance", EML_DrawDistance);
	self:SetNWInt("amount", EML_Iodine_Amount);
	self:SetNWInt("maxAmount", EML_Iodine_Amount);
	self:SetPos(self:GetPos()+Vector(0, 0, 8));

	if EML_NoCollide_Ingredients then
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON);
	end;
end;
 
function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("eml_iodine");
	ent:SetPos(trace.HitPos + trace.HitNormal * 16);
	ent:Spawn();
	ent:Activate();
     
	return ent;
end;

function ENT:OnTakeDamage(dmginfo)
	self:VisualEffect();
end;

function ENT:VisualEffect()
	local effectData = EffectData();	
	effectData:SetStart(self:GetPos());
	effectData:SetOrigin(self:GetPos());
	effectData:SetScale(8);	
	util.Effect("GlassImpact", effectData, true, true);
	self:Remove();
end;

