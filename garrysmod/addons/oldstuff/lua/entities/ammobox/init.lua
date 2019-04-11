-- ==================================================== --
-- =     АКЛАЙ В АРМИИ - ЛОХ  //  ЯЩИК СДЕЛАН МНОЮ    = --
-- ==================================================== --

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self.Entity:SetModel("models/Items/ammoCrate_Rockets.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
  self.Entity:SetUseType(SIMPLE_USE)
	local phys = self.Entity:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
	self.uses = 999999 --сколько могут взять
	 self.difference = 0
end

function ENT:SpawnFunction(ply, tr)

	if not tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal*16 --базовый спавн, нужный для каждого ентити 
	local ent = ents.Create("ammobox")
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	return ent

end





function ENT:Use(activator, caller )
	
	if ( activator:IsPlayer() ) then --
		-- 
		activator:GiveAmmo(50,"357")
    activator:GiveAmmo(50,"ar2")
    activator:GiveAmmo(50,"xbowbolt")
    activator:GiveAmmo(50,"smg1")
    activator:GiveAmmo(50,"pistol")
    activator:GiveAmmo(50,"buckshot")
	activator:GiveAmmo(3,"RPG_Round")
	activator:GiveAmmo(6,"Grenade")
    self.uses = (self.uses - 1)
  end
  
  if ( activator:IsPlayer() ) then --
		-- 
		local armor = activator:Armor() --
    self.difference = (100 - armor) 
    if  armor <  100 then
      activator:SetArmor(armor + self.difference) --армор выдавать?
    end
	end
  
  if (self.uses< 1) then --если нет патронов, ящик пропадает :(
  	self.Entity:Remove()
  end

end



