AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName 					= 'Руки / Ключи'
	SWEP.Slot 						= 1
	SWEP.SlotPos 					= 0
	SWEP.Instructions 				= 'Left or right click to toggle lock or knock\nReload to sell a door'
end

SWEP.ViewModel 					= Model('models/weapons/v_hands.mdl')
SWEP.ViewModelFOV 				= 62

SWEP.HitDistance				= 100

local bell = {
	sound = Sound('ambient/alarms/warningbell1.wav'),
	delay = 10
}

local knock = {
	sound = Sound('physics/wood/wood_crate_impact_hard2.wav'),
	delay = 5
}

local LockDoor

function SWEP:PreDrawViewModel(vm)
	vm:SetMaterial('engine/occlusionproxy')
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	
	self.Primary.Sound = {
		Sound('npc/metropolice/gear1.wav'),
		Sound('npc/metropolice/gear2.wav'),
		Sound('npc/metropolice/gear3.wav'),
		Sound('npc/metropolice/gear4.wav'),
		Sound('npc/metropolice/gear5.wav'),
		Sound('npc/metropolice/gear6.wav')
	}
	
	self._Reload.Delay = 2
end

function SWEP:Deploy()
	if timer.Exists("KeyHands") then timer.Remove("KeyHands") end -- Fucking SWEP function order
	if not self.UseHands then self.UseHands = true end
	timer.Create("KeyHands", 1, 1, function() self.UseHands = false end)
end

if SERVER then

	LockDoor = function(self, lock) 
		self.Owner:LagCompensation(true)
			local ent = self.Owner:GetEyeTrace().Entity
		self.Owner:LagCompensation(false)

		if not IsValid(ent) or not ent:IsDoor() or (ent:GetPos():Distance(self.Owner:GetPos()) > self.HitDistance) then return end

		local IsOwner = (ent:DoorOwnedBy(self.Owner) or ent:DoorCoOwnedBy(self.Owner))

		if (not IsOwner) then
			if lock and (not ent.NextKnock or ent.NextKnock <= CurTime()) then
				self.Owner:EmitSound(knock.sound, 100, math.random(90, 110))
				ent.NextKnock = CurTime() + knock.delay
			elseif ((not ent.NextBell) or (ent.NextBell <= CurTime())) and IsValid(ent:DoorGetOwner()) then
				rp.Notify(ent:DoorGetOwner(), NOTIFY_GENERIC, rp.Term('PlayerRangDoorbell'))
				self.Owner:EmitSound(bell.sound, 100, 110)
				ent.NextBell = CurTime() + bell.delay
			end
			
			self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
			return
		end
		
		if (ent.PickedAt and ent.PickedAt + 2 > CurTime()) then
			rp.Notify(self.Owner, NOTIFY_GENERIC, rp.Term('KeysCooldown'))
			return
		end
		
		self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_GMOD_GESTURE_ITEM_PLACE, true)
		self.Owner:EmitSound(self.Primary.Sound[math.random(1,6)])
		
		ent:DoorLock(lock)
		rp.Notify(self.Owner, NOTIFY_GENERIC, lock and rp.Term('DoorLocked') or rp.Term('DoorUnlocked'))
	end

end

function SWEP:PrimaryAttack()
	if SERVER then LockDoor(self, true) end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:SecondaryAttack()
	if SERVER then LockDoor(self, false) end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Reload()
	if not self:CanReload() then return end
	
	if SERVER then
		self.Owner:LagCompensation(true)
			local ent = self.Owner:GetEyeTrace().Entity
		self.Owner:LagCompensation(false)

		if IsValid(ent) then
			local ownedBy = (ent:DoorOwnedBy(self.Owner) or ent:DoorCoOwnedBy(self.Owner))

			if not ent:IsDoor() or (ent:DoorIsOwnable() and not ownedBy) or (not ent:DoorIsOwnable() and not ownedBy) or (ent:GetPos():Distance(self.Owner:GetPos()) > self.HitDistance) then
				return
			end

			net.Start('rp.keysMenu')
			net.Send(self.Owner)
		end
	end
	
	self:SetNextReload(CurTime() + self._Reload.Delay)
end

function SWEP:OnRemove()
	if timer.Exists("KeyHands") then timer.Remove("KeyHands") end
	
	if not IsValid(self.Owner) then return end
	
	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then vm:SetMaterial("") end
end

function SWEP:Holster()
	self:OnRemove()
	return true
end
