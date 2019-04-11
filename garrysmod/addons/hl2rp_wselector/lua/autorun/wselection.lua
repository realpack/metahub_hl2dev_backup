-----------------------------------------------------

-----------------------------------------------------
if SERVER then return end

WeaponSelection = {}
local Time = 0
local Weapon_ID = 0
local WeaponsCount = 0
local Weapons = {}
local TitleOffset = 0

local blur = Material( "pp/blurscreen" )
local function drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

// Customize Your Button Color

/*
-- Black/Purple Skin:
local ButtonColor = Color(130,130,130,150)
local AmmoButton = Color(100,0,200,150)
*/
surface.CreateFont( "wepselect", { font = "Roboto", extended = true, size = 20 } )
surface.CreateFont( "wepselect_selected", { font = "Roboto", extended = true, size = 21 } )
-- Blue/Pink Skin:
local ButtonColor = Color(255, 87, 51)
local AmmoButton = Color(100,0,200,150)

local function GetWeaponType(class)
	if (string.find(class,"cw_") or class == "fists_weapon" or class == "weapon_fists" or class == "ultra_fists" or class == "stungun") then
		return "weapon"
	elseif (string.find(class,"weapon_") or string.find(class,"gmod_")) then
		return "job"
	else
		return "normal"
	end
end

local function GetWeaponCaching(weps)
	local tmp = {}
	for k,v in pairs(weps) do
		table.insert(tmp,v)
	end
	return tmp
end

function WeaponSelection:Draw()
	local Counter = 0
	local offset = (table.Count(Weapons)*18)
	TitleOffset = offset

	for k, v in pairs(Weapons) do
		if (v and IsValid(v)) then
			Counter = Counter + 1
			local type = GetWeaponType(v:GetClass())
			if (Counter == Weapon_ID) then
				if (type == "weapon" and v:GetClass() != "fists_weapon" and v:GetClass() != "weapon_fists" and v:GetClass() != "ultra_fists" and v:GetClass() != "stungun") then
					WeaponSelection:DrawAmmo(v,ScrW()-155,(ScrH()/2)-(TitleOffset)-30)
				end
				WeaponSelection:DrawWeaponItem(v:GetPrintName(),ScrW()-155,(ScrH()/2)-offset,type, true)
			else
				WeaponSelection:DrawWeaponItem(v:GetPrintName(),ScrW()-155,(ScrH()/2)-offset,type, false)
			end

			offset = offset - 30
		end
	end
end

function WeaponSelection:DrawAmmo(weapon,posx,posy)
	local BoxSize_W = 150
	local BoxSize_H = 25
	local BoxColor = AmmoButton
	draw.RoundedBox( 0, posx, posy, BoxSize_W, BoxSize_H, BoxColor )
	draw.SimpleText("Патроны : " ..weapon:Clip1() .. "/" ..LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()), "wepselect", posx + (BoxSize_W*0.5), posy + (BoxSize_H*0.5), TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function WeaponSelection:DrawWeaponItem(name,posx,posy,type, is_selected)
	local BoxSize_W = 150
	local BoxSize_H = 25
	--local BoxColor = Color( 0, 130, 200, 150 )
	local BoxColor = ButtonColor
	local TextColor = Color(255,255,255,255)
	local LineColor = Color(64, 105, 153)
	local LineDecal = 7
	if (type == "weapon") then
		LineColor = Color(64, 105, 153)
	elseif (type == "job") then
		LineColor = Color(64, 105, 153)
	else
		LineColor = Color(64, 105, 153)
	end

	-- drawBlur( posx, posy, BoxSize_W, BoxSize_H, 3, 6, 255 )
	-- draw.RoundedBox( 0, posx, posy, BoxSize_W, BoxSize_H, Color(200,50,50))
	-- draw.RoundedBox( 0, posx, posy, BoxSize_W, BoxSize_H, Color(52, 73, 94) )
	-- draw.RoundedBox( 0, posx+10, posy, BoxSize_W-148, BoxSize_H, color_white )

	draw.ShadowSimpleText(name, is_selected and "wepselect_selected" or "wepselect", posx + 150, posy + (BoxSize_H*0.5), is_selected and Color(112, 172, 250) or color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

	-- surface.SetDrawColor(LineColor)
	-- surface.DrawRect(posx, posy, 10, BoxSize_H )



end

function WeaponSelection:ShouldDraw()
	if (Time and Time + 1.5 > CurTime()) then
		return true
	end
	return false
end

function WeaponSelection:InitialCall()
	Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())
	local Current_Weapon = LocalPlayer():GetActiveWeapon()
	WeaponsCount = table.Count(Weapons)
	Weapon_ID = table.KeyFromValue(Weapons,Current_Weapon)
    timer.Create( "refresh_weapons", 0.5, 0, function()
		Weapons = GetWeaponCaching(LocalPlayer():GetWeapons())
		WeaponsCount = table.Count(Weapons)
	end)
end

function WeaponSelection:SetSelection(id)
	if (LocalPlayer():InVehicle()) then return false end
	Time = CurTime()
	WeaponSelection:InitialCall()
	Weapon_ID = id
end

-- We Force it to Draw!
function WeaponSelection:Call()
	if (WeaponSelection:ShouldDraw()) then
		Time = CurTime()
	else
		Time = CurTime()
		WeaponSelection:InitialCall()
	end
end

function WeaponSelection:NextWeapon()
	if (WeaponsCount > 0) then
	end
	if (!Weapon_ID) then Weapon_ID = 1 end
	if (WeaponsCount == Weapon_ID) then
		Weapon_ID = 1
	else
		Weapon_ID = Weapon_ID + 1
	end
end

function WeaponSelection:PrevWeapon()
	if (WeaponsCount > 0) then
	end
	if (!Weapon_ID) then Weapon_ID = 1 end
	if (Weapon_ID == 1) then
		Weapon_ID = WeaponsCount
	else
		Weapon_ID = Weapon_ID - 1
	end
end

function WeaponSelection:SelectWeapon()
	if (Weapon_ID and Weapons[Weapon_ID] and IsValid(Weapons[Weapon_ID])) then
		RunConsoleCommand("use",Weapons[Weapon_ID]:GetClass())
		timer.Destroy("refresh_weapons")
		Time = 0
	end
end

function WeaponSelection:Think()

end
