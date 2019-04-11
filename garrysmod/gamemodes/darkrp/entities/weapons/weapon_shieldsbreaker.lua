AddCSLuaFile()

if SERVER then
	util.AddNetworkString("onShieldLockpickCompleted")
end

if CLIENT then
	SWEP.PrintName = "Взлом Щитов"
	SWEP.Slot = 4
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server

SWEP.Author = "pack"
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "MetaHub Weapons"

SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")

SWEP.Primary.ClipSize = -1      -- Size of a clip
SWEP.Primary.DefaultClip = 0        -- Default number of bullets in a clip
SWEP.Primary.Automatic = false      -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1        -- Size of a clip
SWEP.Secondary.DefaultClip = -1     -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false        -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Holster( eWep )
	return true
end

function SWEP:PrimaryAttack()
	if not SERVER then return end

	local owner = self.Owner
	local trace = owner:GetEyeTrace()
	local target = trace.Entity

	if not (target:GetClass() == 'forcefield') then return end

	-- if ( self.Owner:IsPlayer() ) then
	-- 	if (meta.jobs[self.Owner:Team()].Type == TYPE_CITIZEN) then
	-- 		if (self.policeOnly) then
	-- 			self:EmitSound("buttons/button8.wav");
	-- 			self.Owner.nextFFTouch = CurTime() + 2.5;

	-- 			return;
	-- 		end;
	-- 	end;
	-- end;

    target.nextUse = CurTime() + 10;
    target:SetNetVar('PoliceOnly', false)

	target:EmitSound("buttons/button6.wav");

	self:Remove()
	-- target:SetCollisionGroup(COLLISION_GROUP_DEBRIS);

	-- timer.Simple(1.5, function()
    --     target:TimerCheckFeild(nil,1.5)
    -- end);
end
