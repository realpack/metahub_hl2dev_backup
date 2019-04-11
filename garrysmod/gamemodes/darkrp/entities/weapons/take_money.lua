-- Seconds to pass until Pickpocketing is done (default: 10)
local PPConfig_Duration = 8

-- Minimum money that can be stolen from the player (default: 400)
local PPConfig_MoneyFrom = 500

-- Maximumum money that can be stolen from the player (default: 700)
local PPConfig_MoneyTo = 2000

-- Seconds to wait until next Pickpocketing (default: 60)
local PPConfig_Wait = 3

-- Distance able to be stolen from (default: 100)
local PPConfig_Distance = 120

-- Should stealing emit a silent sound (true or false) (default: true)
local PPConfig_Sound = true

-- Hold down to keep Pickpocketing (true or false) (default: false)
local PPConfig_Hold = false

if SERVER then

	if PPConfig_Sound then
		resource.AddFile( "sound/pickpocket/pick.wav" )
	end

	AddCSLuaFile( "shared.lua" )

	util.AddNetworkString( "pickpocket_time" )

else

	SWEP.PrintName = "Карманные Кражи"
	SWEP.Slot = 0
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true

end

SWEP.Base = "weapon_base"

SWEP.Author = "lordtobi"
SWEP.Instructions = "Щелкните левой кнопкой мыши что бы начать"
SWEP.IconLetter = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model( "" )
SWEP.WorldModel = Model( "" )

SWEP.UseHands = true

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "MetaHub"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

//Initialize\\
function SWEP:Initialize()
	self:SetWeaponHoldType( "normal" )
end

if CLIENT then

	net.Receive( "pickpocket_time", function()
		local wep = net.ReadEntity()

		wep.IsPickpocketing = true
		wep.StartPick = CurTime()
		wep.EndPick = CurTime() + PPConfig_Duration
	end )

end

//Primary Attack\\
function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire(CurTime() + 120)

	if self.IsPickpocketing then return end

	local trace = self.Owner:GetEyeTrace()
	local e = trace.Entity

	if SERVER then

		self.IsPickpocketing = true
		self.StartPick = CurTime()

		net.Start( "pickpocket_time" )
		net.WriteEntity( self )
		net.Send(self.Owner)

		self.EndPick = CurTime() + PPConfig_Duration

	end

	self:SetWeaponHoldType( "pistol" )

	if SERVER then

		if PPConfig_Sound then
			self.Owner:EmitSound( Sound( "pickpocket/pick.wav" ) )
		end

		timer.Create( "PickpocketSounds", 1, PPConfig_Duration, function()

			if not self:IsValid() then
				return
			end

			if PPConfig_Sound then
				self.Owner:EmitSound( Sound( "pickpocket/pick.wav" ) )
			end

		end )

	end

	if CLIENT then

		self.Dots = self.Dots or ""

		timer.Create( "PickpocketDots", 0.5, 0, function()

			if not self:IsValid() then
				timer.Destroy( "PickpocketDots" )
				return
			end

			local len = string.len( self.Dots )
			local dots = { [0] = ".", [1] = "..", [2] = "...", [3] = "" }

			self.Dots = dots[len]

		end )

	end

end

//Holster\\
function SWEP:Holster()

	self.IsPickpocketing = false

	if SERVER then
		timer.Destroy( "PickpocketSounds" )
	end

	if CLIENT then
		timer.Destroy( "PickpocketDots" )
	end

	return true
end

//OnRemove\\
function SWEP:OnRemove()
	self:Holster()
end

local tbl_teams = {
	[TEAM_CRIME] = { min = 500, max = 850 },
	[TEAM_CRIME2] = { min = 700, max = 1100 },
	[TEAM_CRIME3] = { min = 900, max = 1450 },
	[TEAM_HERO1] = { min = 1000, max = 1500 },
}

//Pickpocket Succeed\\
function SWEP:Succeed()

	self.IsPickpocketing = false

	self:SetWeaponHoldType( "normal" )

	self.Weapon:SetNextPrimaryFire( CurTime() + PPConfig_Wait )

	local trace = self.Owner:GetEyeTrace()
	local target = trace.Entity

	if SERVER then
		timer.Destroy( "PickpocketSounds" )
	else
		timer.Destroy( "PickpocketDots" )
	end


	if SERVER then
		local money

		if not tbl_teams[self.Owner:Team()] then return end
		tn = tbl_teams[self.Owner:Team()]
		local need = math.random(tn.min,tn.max)

		if target:GetMoney() >= need then
			money = need
		end

		-- if SERVER then
			-- DarkRP.payPlayer( target, self.Owner, money )
		-- target:AddMoney(-money)
		-- self.Owner:AddMoney(money)

		if tonumber(money) > 0 then
			target:AddMoney(-money)
			self.Owner:AddMoney(money)

			rp.Notify(self.Owner, NOTIFY_GENERIC, 'Получилось, ' .. formatMoney(money) .. ' я смог позаимствовать.')
		else
			rp.Notify(self.Owner, NOTIFY_ERROR, 'Не получилось.')
		end

		-- else
		-- 	if tonumber(money) > 0 then
		-- 		self.Owner:PrintMessage( HUD_PRINTTALK, "Получилось, " .. formatMoney(money) .. " Я смог позаимствовать." )
		-- 	else
		-- 		self.Owner:PrintMessage( HUD_PRINTTALK, "Получилось, Черт он бомжара даже 250К Нету." )
		-- 	end
		-- end
	end

	-- if self.Owner:Team() == TEAM_CRIME then
	-- 	moneyneedtakec = math.random( 500, 1500 )
	-- elseif self.Owner:Team() == TEAM_CRIME2 then
	-- 	moneyneedtakec = math.random( 1000, 3500 )
	-- elseif self.Owner:Team() == TEAM_HEROMARIO then
	-- 	moneyneedtakec = math.random( 1000, 4000 )
	-- else
	-- 	self.Owner:PrintMessage( HUD_PRINTTALK, "Вы не вор, по крайне мере у вас не прямые руки." )
	-- 	return
	-- end



	-- if target:getDarkRPVar( "money" ) > moneyneedtakec then
	-- 	money = target:getDarkRPVar( "money" )
	-- end

	-- if SERVER then
	-- 	DarkRP.payPlayer( target, self.Owner, money )
	-- else
	-- 	if tonumber(money) > 0 then
	-- 		self.Owner:PrintMessage( HUD_PRINTTALK, "Получилось, " .. money .. "К Я смог позаимствовать." )
	-- 	else
	-- 		self.Owner:PrintMessage( HUD_PRINTTALK, "Получилось, Черт он бомжара даже 250К Нету." )
	-- 	end
	-- end
end

//Pickpocket Fail\\
function SWEP:Fail()

	self.IsPickpocketing = false

	self:SetWeaponHoldType( "normal" )

	if SERVER then
		timer.Destroy( "PickpocketSounds" )
	else
		timer.Destroy( "PickpocketDots" )
	end

end

//Think\\
function SWEP:Think()

	local ended = false

	if self.IsPickpocketing and self.EndPick then

		local trace = self.Owner:GetEyeTrace()

		if not IsValid( trace.Entity ) and not ended then
			ended = true
			self:Fail()
		end

		if trace.HitPos:Distance( self.Owner:GetShootPos() ) > PPConfig_Distance and not ended then
			ended = true
			self:Fail()
		end

		if PPConfig_Hold and not self.Owner:KeyDown( IN_ATTACK ) and not ended then
			ended = true
			self:Fail()
		end

		if self.EndPick <= CurTime() and not ended then
			ended = true
			self:Succeed()
		end

	end

end

//Draw HUD\\
function SWEP:DrawHUD()

	if self.IsPickpocketing and self.EndPick then

		self.Dots = self.Dots or ""

		local w = ScrW()
		local h = ScrH()
		local x, y, width, height = w / 2 - w / 10, h / 2 - 60, w / 5, h / 15

		draw.RoundedBox( 0, x, y, width, height, Color( 10, 10, 10, 120 ) )
		surface.SetDrawColor(201,201,201)
		surface.DrawOutlinedRect(x,y,width,height)
		local time = self.EndPick - self.StartPick
		local curtime = CurTime() - self.StartPick
		local status = math.Clamp( curtime / time, 0, 1)
		local stat = math.Round(math.Clamp(100*(curtime/time), 0, 100),0)
		local BarWidth = status * ( width - 16 )

		draw.RoundedBox( 0, x + 8, y + 8, BarWidth, height - 16, Color( 255 - ( status * 255 ), 0 + ( status * 255 ), 0, 255 ) )

		draw.SimpleText("В процессе" .." "..stat.."%", "Trebuchet24", w/2, y + height/2, Color(255,255,255,255), 1, 1)

	end

end

//Secondary Attack\\
function SWEP:SecondaryAttack()
end
