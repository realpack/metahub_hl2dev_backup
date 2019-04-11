
-- Cigarette SWEP by Mordestein (based on Vape SWEP by Swamp Onions)

if CLIENT then
	include('weapon_ciga/cl_init.lua')
else
	include('weapon_ciga/shared.lua')
end

SWEP.PrintName = "Заменитель"

SWEP.Instructions = "LMB: deshevo kurit"

SWEP.ViewModel = "models/mordeciga/mordes/oldcigshib.mdl"
SWEP.WorldModel = "models/mordeciga/mordes/oldcigshib.mdl"

SWEP.cigaID = 3

SWEP.cigaAccentColor = Vector(1,1,1.1)
