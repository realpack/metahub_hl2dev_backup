if (SERVER) then
	AddCSLuaFile( "shared.lua" )

	SWEP.AutoSwitchTo		= true
	SWEP.AutoSwitchFrom		= true
end

if ( CLIENT ) then
	SWEP.DrawAmmo			= true
	SWEP.PrintName			= "Обыск"
	SWEP.Author				= ""
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 54
end

SWEP.Category				= "MetaHub"
SWEP.Slot					= 3
SWEP.SlotPos				= 5
SWEP.Weight					= 5
SWEP.Spawnable     			= true
SWEP.AdminSpawnable  		= true

SWEP.ViewModel 				= ""
SWEP.WorldModel 			= ""

SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ''

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ''

function SWEP:Initialize()
	-- if (CLIENT) then return end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetDeploySpeed( 1 )
	return true
end

local bad_weapos = {
	['swb_357'] = true,
	['swb_ak47'] = true,
	['swb_ar2'] = true,
	['swb_aug'] = true,
	['swb_awp'] = true,
	['swb_deagle'] = true,
	['swb_famas'] = true,
	['swb_fiveseven'] = true,
	['swb_p90'] = true,
	['swb_g3sg1'] = true,
	['swb_glock18'] = true,
	['swb_mp5'] = true,
	['swb_galil'] = true,
	['swb_m249'] = true,
	['swb_m3super90'] = true,
	['swb_m4a1'] = true,
	['swb_mac10'] = true,
	['swb_smg'] = true,
	['swb_p228'] = true,
	['swb_scout'] = true,
	['swb_sg550'] = true,
	['swb_sg552'] = true,
	['swb_shotgun'] = true,
	['swb_tmp'] = true,
	['swb_ump'] = true,
	['swb_usp'] = true,
	['swb_xm1014'] = true,
	['swb_pistol'] = true,
}

function SWEP:PrimaryAttack()
	if SERVER then return end
	if ((self.nextAttack or 0) >= CurTime()) then
		return
	end

	self.nextAttack = CurTime() + 3


	local trace = self.Owner:GetEyeTrace()
	local target = trace.Entity

    if not target:IsPlayer() then return end
	local weps = target:GetWeapons()

	local result = {}

	for _, w in pairs(weps) do
		if bad_weapos[w:GetClass()] then
			table.insert(result, w:GetPrintName())
		end
	end

	-- local col, time = Color(90,90,90,255), '['..os.date(NOTIFY_DATE_FORMAT, os.time())..'] '
	-- if #result >= 1 then
	-- 	chat.AddText(col, time, color_white, string.Implode(", ", result))
	-- else
	-- 	chat.AddText(col, time, color_white, 'Нелегальные предметы отсутствуют')
	-- end

    rp.Notify(NOTIFY_GENERIC, #result >= 1 and string.Implode(", ", result) or 'Нелегальные предметы отсутствуют')


	self.Weapon:SetNextPrimaryFire(CurTime()+3)
	self.Weapon:SetNextSecondaryFire(CurTime()+3)
end


function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime()+1)
	self.Weapon:SetNextSecondaryFire(CurTime()+1)
end

function SWEP:Reload()
end
function SWEP:OnRemove()
	self:Holster()
end
