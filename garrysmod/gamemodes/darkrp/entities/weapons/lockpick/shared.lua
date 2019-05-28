
-----------------------------------------------------
if SERVER then
	AddCSLuaFile("shared.lua")
	util.AddNetworkString("lockpick_time")
	-- resource.AddFile("models/weapons/c_lockpick.mdl")
	-- resource.AddFile("models/code_gs/weapons/w_lockpick.mdl")
	-- resource.AddFile("materials/code_gs/models/weapons/lockpick.vmt")
	-- resource.AddFile("materials/models/custom/hqlockpick.vmt")
	-- resource.AddFile("materials/models/custom/hqlockpick.vtf")
end

if CLIENT then
	SWEP.PrintName = "Отмычка"
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")
SWEP.Spawnable = true
SWEP.Category = "RP"
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")
SWEP.Primary.ClipSize = -1 -- Size of a clip
SWEP.Primary.DefaultClip = 0 -- Default number of bullets in a clip
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1 -- Size of a clip
SWEP.Secondary.DefaultClip = -1 -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""
SWEP.LockPickTime = 30

--[[---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
	self:SetHoldType("pistol")
end

if CLIENT then
	net.Receive("lockpick_time", function(len)
		local wep = net.ReadEntity()
		local time = net.ReadUInt(32)
		wep.LockPickTime = time
		wep.EndPick = CurTime() + time
	end)
end

--[[---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	if self.IsLockPicking then return end
	local trace = self.Owner:GetEyeTrace()
	local e = trace.Entity
	if SERVER and e.isFadingDoor then return end
	if not IsValid(e) or trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or (not e:IsDoor() and not e:IsVehicle() and not string.find(string.lower(e:GetClass()), "vehicle") or e.isFadingDoor) then return end
	if (e:GetNetVar("DoorData") == false) then return end

	if IsValid(self.Owner) and self.Owner:GetTeamTable().lockpicktime then
		self.LockPickTime = 30 * self.Owner:GetTeamTable().lockpicktime
	else
		self.LockPickTime = 30
	end

	hook.Call("PlayerStartLockpicking", nil, self.Owner, e)
	self.IsLockPicking = true
	self.StartPick = CurTime()

	if SERVER then
		net.Start("lockpick_time")
		net.WriteEntity(self)
		net.WriteUInt(self.LockPickTime, 32)
		net.Send(self.Owner)
	end

	self.EndPick = CurTime() + self.LockPickTime
	self:SetHoldType("pistol")

	if SERVER then
		timer.Create("LockPickSounds", 1, self.LockPickTime, function()
			if not IsValid(self) then return end
			local snd = {1, 3, 4}
			self:EmitSound("weapons/357/357_reload" .. tostring(snd[math.random(1, #snd)]) .. ".wav", 50, 100)
		end)
	elseif CLIENT then
		self.Dots = self.Dots or ""

		timer.Create("LockPickDots", 0.5, 0, function()
			if not self:IsValid() then
				timer.Remove("LockPickDots")

				return
			end

			local len = string.len(self.Dots)

			local dots = {
				[0] = ".",
				[1] = "..",
				[2] = "...",
				[3] = ""
			}

			self.Dots = dots[len]
		end)
	end
end

function SWEP:Holster()
	self.IsLockPicking = false

	if SERVER then
		timer.Remove("LockPickSounds")
	end

	if CLIENT then
		timer.Remove("LockPickDots")
	end

	return true
end

function SWEP:Succeed()
	self.IsLockPicking = false
	self:SetHoldType("normal")
	local trace = self.Owner:GetEyeTrace()

	if trace.Entity.isFadingDoor and trace.Entity.fadeActivate then
		if not trace.Entity.fadeActive then
			trace.Entity:fadeActivate()

			timer.Simple(5, function()
				if trace.Entity.fadeActive then
					trace.Entity:fadeDeactivate()
				end
			end)
		end
	elseif IsValid(trace.Entity) and trace.Entity.Fire then
		if (trace.Entity.Locked) then
			trace.Entity.PickedAt = CurTime()
		end

		trace.Entity:DoorLock(not trace.Entity.Locked)
		trace.Entity:Fire("open", "", .6)
		trace.Entity:Fire("setanimation", "open", .6)
		hook.Call("PlayerFinishLockpicking", nil, self.Owner, trace.Entity)
	end

	if SERVER then
		timer.Remove("LockPickSounds")
	end

	if CLIENT then
		timer.Remove("LockPickDots")
	end
end

function SWEP:Fail()
	self.IsLockPicking = false
	self:SetHoldType("normal")

	if SERVER then
		timer.Remove("LockPickSounds")
	end

	if CLIENT then
		timer.Remove("LockPickDots")
	end
end

function SWEP:Think()
	if self.IsLockPicking then
		local trace = self.Owner:GetEyeTrace()

		if not IsValid(trace.Entity) then
			self:Fail()
		end

		if trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or (not trace.Entity:IsDoor() and not trace.Entity:IsVehicle() and not string.find(string.lower(trace.Entity:GetClass()), "vehicle") and not trace.Entity.isFadingDoor) then
			self:Fail()
		end

		if self.EndPick <= CurTime() then
			self:Succeed()
		end
	end
end

function SWEP:DrawHUD()
	if self.IsLockPicking then
		self.Dots = self.Dots or ""
		local x, y = (ScrW() / 2) - 150, (ScrH() / 2) - 25
		local w, h = 300, 50
		local time = self.EndPick - self.StartPick
		local status = (CurTime() - self.StartPick) / time
		rp.ui.DrawProgress(x, y, w, h, status)
		draw.ShadowSimpleText("Взламываю" .. self.Dots, "font_base_24", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, 255), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end

function SWEP:DrawWorldModel()
	-- self.Hand = nil
    if not self.Owner or not IsValid(self.Owner) then return end
	if (not self.Hand) then
		self.Hand = self.Owner:LookupAttachment("anim_attachment_rh")
	end

	if (not self.Hand) then
		self:DrawModel()

		return
	end

	local hand = self.Owner:GetAttachment(self.Hand)
	self:SetRenderOrigin(hand.Pos + (hand.Ang:Right() * 5.5) + (hand.Ang:Up() * -1.5))
	hand.Ang:RotateAroundAxis(hand.Ang:Right(), 90)
	hand.Ang:RotateAroundAxis(hand.Ang:Up(), 180)
	self:SetRenderAngles(hand.Ang)
	self:DrawModel()
end
