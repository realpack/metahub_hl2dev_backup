/*****************
* CONFIGURATIONS
******************/

if SERVER then
	resource.AddWorkshop("1092167608")
end


/*****************
* ADDON CONFIG
******************/
----------------------------------
	-- PLEASE SET BASE OF YOUR GAMEMODE ( 2.5 (2.5.0 or 2.5.1) or 2.4 (2.4.3))
	MGS_GM_VERSION = 2.5
	-- Draw distance
	MGS_DISTANCE = 512
	-- Tools which helps players break rocks.
	MGS_MINING_TOOLS = {"mgs_pickaxe"}

	-- NEW -- Set 'true' to set new method of changing time in factory. Time will be set by ore's times which you will set in ore settings.
	MGS_NEW_TIME = true
----------------------------------
/*****************
* ROCKS CONFIG
******************/
----------------------------------
	-- Set Maximum number of ores which will be spawned.
	MGS_CREATE_ORE = 5
	-- Set rocks' health.
	MGS_ROCK_HEALTH = 15
	-- Respawning rocks time.
	MGS_ROCK_REPLACE_TIMER = 60

	--Custom models for rocks.
	MGS_ROCK_MODELS = {"models/props/cs_militia/militiarock05.mdl", "models/props/cs_militia/militiarock03.mdl"}
----------------------------------
/*****************
* ORES CONFIG
******************/
----------------------------------
	-- Removing ore time which isn't used.
	MGS_ORE_REMOVE_TIME = 60

	-- Custom models for ores
	MGS_ORE_MODELS = {"models/props_junk/rock001a.mdl"}

	-- Ore types
	-- Example: "Gold" - name for ore,
	--		   	"Color(255,255,0)" -- color,
	--		   	"10" - cost for one kg,
	--		  	"math.Rand(7,15)" - random mass also you can use "15" or another integer value.
	--    NEW   "0.5" - chance between 0 and 1. Less this number, more likely that ore will be spawned.
	--    NEW   "20" - time for ore to be broken.

	MGS_ORE_TYPES = {
		{"Ruby", Color(255,0,0), 3, math.Rand(7, 15), 0.2, 10},
		{"Gold", Color(255,255,0), 10, math.Rand(5, 10), 0.5, 20},
		{"Diamond", Color(100,100,255), 100, math.Rand(1, 5), 0.9, 30}
	}
----------------------------------
/*****************
* FACTORY CONFIG
******************/
----------------------------------
	-- Crushing time.
	MGS_CRUSH_TIME = 20
	-- Safe mode. If you sets 'false' it will spawn money as entity, else money would be add to player.
	MGS_SAFEMODE = false
	-- Enable crush effects.
	MGS_CRUSH_EFFECT = true
----------------------------------
