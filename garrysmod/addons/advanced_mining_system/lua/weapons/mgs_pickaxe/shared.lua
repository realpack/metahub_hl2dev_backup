if CLIENT then
	SWEP.PrintName = "Pickaxe"
	SWEP.Slot = 1
	SWEP.SlotPos = 5
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server

SWEP.Author = ""
SWEP.Instructions = "Left click to break something"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_mgs_pickaxe.mdl")
SWEP.WorldModel = Model("models/weapons/w_mgs_pickaxe.mdl")
SWEP.HoldType = "melee";

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "DarkRP (Utility)"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 13;
SWEP.Primary.Delay = 0.5;
SWEP.Primary.Ammo = "";

--[[-------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SendWeaponAnim(ACT_VM_HOLSTER);
end

function SWEP:DoHitEffects()
	local trace = self.Owner:GetEyeTraceNoCursor();
	
	if (((trace.Hit or trace.HitWorld) and self.Owner:GetShootPos():Distance(trace.HitPos) <= 64)) then
		self:SendWeaponAnim(ACT_VM_HITCENTER);
		self:EmitSound("weapons/crossbow/hitbod2.wav");
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("npc/vort/claw_swing2.wav");
	end;
end;

function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

--[[-------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self:DoAnimations();
	self:DoHitEffects();
	
	if (SERVER) then
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true);
		end;
		
		local trace = self.Owner:GetEyeTraceNoCursor();
		
		if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 64) then
			if (IsValid(trace.Entity)) then
				self.Owner:FireBullets({
					Spread = Vector(0, 0, 0),
					Damage = 1,
					Tracer = 0,
					Force = 1,
					Num = 1,
					Src = self.Owner:GetShootPos(),
					Dir = self.Owner:GetAimVector()
				});
			end;
		end;
		
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false);
		end;
	end;
end

function SWEP:Holster()
	return true
end

function SWEP:Think()
end

function SWEP:DrawHUD()
end

function SWEP:SecondaryAttack()
end
