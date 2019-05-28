/*****************
* CONFIGURATIONS
******************/

if SERVER then
	resource.AddWorkshop("322897174")
end

/*****************
* ADDON CONFIG
******************/
----------------------------------
	-- PLEASE SET BASE OF YOUR GAMEMODE ( 2.5 (2.5.0 or 2.5.1) or 2.4 (2.4.3))
	SWM_GM_VERSION = 2.5
	-- Draw distance
	SWM_DISTANCE = 512
	-- Tools which helps players cut trees.
	SWM_CUTTING_TOOLS = {"swm_chopping_axe"}
----------------------------------
/*****************
* TREES CONFIG
******************/
----------------------------------
	-- Set tree's health.
	SWM_TREE_HEALTH = 25
	-- Respawning trees time.
	SWM_TREE_REPLACE_TIMER = 20
	-- Set Red tree's health
	SWM_TREE_RED_HEALTH = 30
	-- Respawning Red trees time
	SWM_TREE_RED_REPLACE_TIMER = 30

	--Custom models for standart trees
	SWM_TREE_MODELS =		{"models/props_junk/wood_crate001a.mdl"}
	--Custom models for Red trees
	SWM_TREE_RED_MODELS =   {"models/props_junk/wood_crate002a.mdl"}
----------------------------------
/*****************
* LOGS CONFIG
******************/
----------------------------------
	-- Price for one Log.
	SWM_LOG_PRICE = 200
	-- Removing log time which isn't used
	SWM_LOG_REMOVE_TIME = 120
	-- Maximum logs in cart.
	SWM_CART_MAX_LOGS = 10
----------------------------------
/*****************
* SAWMILL CONFIG
******************/
----------------------------------
	-- Sawing time.
	SWM_SAW_TIME = 10
	-- Safe mode. If you sets 'false' it will spawn money as entity, else money would be add to player.
	SWM_SAFEMODE = false
	-- Enable sawing effects.
	SWM_SAW_EFFECT = true
----------------------------------
