if SERVER then
    AddCSLuaFile("shared.lua")
end

SWEP.PrintName = "Аура Аммуниции 3-го"
SWEP.Author = "KTKycT (Comet)"
SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.Description = "AOE пополнение патронов союзников."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = "ЛКМ для активации"
SWEP.IsDarkRPMedKit = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category				= "Контент CWRP"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix  = "rpg"
SWEP.ViewModel = "models/weapons/v_hands.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true

SWEP.Primary.Recoil = 0
SWEP.Primary.ClipSize  = -1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic  = true
SWEP.Primary.Delay = 45
SWEP.Primary.Ammo = "none"


SWEP.Secondary.Recoil = 0
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Delay = 0.3
SWEP.Secondary.Ammo = "none"
SWEP.Cd = 0
SWEP.Activeskil = 0
SWEP.Colors = Color(0, 0, 0, 255)
SWEP.Whatwrite = 0

function SWEP:Initialize()
self:SetHoldType("normal")
end

function SWEP:Deploy()
    if CLIENT or not IsValid(self:GetOwner()) then return true end
    self:GetOwner():DrawWorldModel(false)
    return true
end


function SWEP:PrimaryAttack()
if timer.RepsLeft( "AMCD" ..self.Owner:UserID() ) != nil or timer.RepsLeft( "AM2CD" ..self.Owner:UserID() ) != nil then
if (SERVER) then DarkRP.notify(self.Owner, 1, 5, "У одной из ваших аур не откатилось CD") self:SetNextPrimaryFire(CurTime() + 1 ) end
else
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
timer.Create( "AM3deploy" ..self.Owner:UserID(), 1, 15, function ()
	targetheal = ents.FindInSphere(self.Owner:GetPos(), 140)
	for _, hply in pairs(targetheal) do
		if hply:IsPlayer() and hply:Alive() then
			if (SERVER) then
				local wep = hply:GetActiveWeapon()
				-- print(game.GetAmmoName(wep:GetPrimaryAmmoType()))
				if game.GetAmmoName(wep:GetPrimaryAmmoType()) then
					hply:GiveAmmo(5, game.GetAmmoName(hply:GetActiveWeapon():GetPrimaryAmmoType()))
				end
			end
		end
	end
 ef = EffectData()
	ef:SetOrigin(self.Owner:GetPos()+Vector(0,0,2))
	util.Effect("ammoaurarad", ef,true,true)

	end)

targetheal = ents.FindInSphere(self.Owner:GetPos(), 140)
for _, hply in pairs(targetheal) do
		if hply:IsPlayer() then
			if (SERVER) then hply:GiveAmmo( 2, 10 , false) hply:GiveAmmo( 3, 8 , false) end
		end
	end

if self.Cd == nil or 0 then
timer.Create( "AM3CD" ..self.Owner:UserID(), 1, 45, function () end) else return end
end
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
self.Cd = timer.RepsLeft( "AM3CD" ..self.Owner:UserID() )
self.Activeskil = timer.RepsLeft( "AM3deploy" ..self.Owner:UserID() )

if (self.Cd == nil or self.Cd == 0) then
	self.Whatwrite = ""
	self.Colors = Color(0, 255, 0, 200)
elseif self.Cd >=31 then
	self.Colors = Color(0, 255, 255, 200)
elseif self.Cd <= 30 then
	self.Whatwrite = self.Cd
	self.Colors = Color(255, 0, 0, 200)
end

end

function SWEP:DrawHUD()
	draw.RoundedBoxEx(10,ScrW()/2-50, ScrH()/2+410, 100, 100, self.Colors, true,true,true,true)
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial(Material( "skilliconammoraura3.png" ))
	surface.DrawTexturedRect( ScrW()/2-50, ScrH()/2+410, 100, 100 )

	draw.SimpleText( self.Whatwrite , "CloseCaption_Bold", ScrW()/2-2, ScrH()/2+460, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end