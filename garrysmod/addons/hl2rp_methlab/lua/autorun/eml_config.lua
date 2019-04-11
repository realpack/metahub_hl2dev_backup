--I moved everything  to one file.

-- Drawing 3D2D things distance.
EML_DrawDistance = 256;

-- Change sound level, sound pitch and sound volume.
EML_Sound_Level = 60; -- How far you can hear.
EML_Sound_Pitch = 100; -- How fast sound is.
EML_Sound_Volume = 0.2; -- How loud sound is.

-- Enable or disable smoke.
EML_Smoke_Enable = true;

EML_NoCollide_Cookware = true; -- Cookware are no collide for players.
EML_NoCollide_Ingredients = true; -- Ingredients are no collide for players.

-- Allow physgun drag and drop on entities.
EML_Ingredients_Physgun = true; -- Allow physgun use on iodine, muriatic acid, sulfur and water.
EML_Products_Physgun = true; -- Allow physgun use on crystalized iodine, red phosphorus, meth.
EML_Cookware_Physgun = true; -- Allow physgun use on pot, special pot and jar.

EML_Gas_Physgun = true; -- Allow physgun use on gas canister.
EML_Stove_Physgun = true; -- Allow physgun use on stove.


-- Stove consumption on heat amount.
EML_Stove_Consumption = 1;
-- Stove heat amount.
EML_Stove_Heat = 1;
-- Amount of gas inside.
EML_Stove_Storage = 600;
-- Can grab with gravity gun?
EML_Stove_GravityGun = true;
-- 0 - Can't be exploded/destroyed; 1 - Can be destroyed without explosion; 2 - Explodes after taking amount of damage.
EML_Stove_ExplosionType = 2;
-- Stove health if type 1 or 2.
EML_Stove_Health = 400;
-- Stove explosion damage if type 2.
EML_Stove_ExplosionDamage = 100;
-- Stove smoke color.
EML_Stove_SmokeColor_R = 100;
EML_Stove_SmokeColor_G = 100;
EML_Stove_SmokeColor_B = 0;
-- Stove indicator color.
EML_Stove_IndicatorColor = Color(255, 222, 0, 255);
-- Stove underwater explosion
EML_Stove_ExplodeUnderwater = true;


-- Pot default time.
EML_Pot_StartTime = 120;
-- Default time, which will be added to pot on collision with Muriatic Acid.
EML_Pot_OnAdd_MuriaticAcid = 10;
-- Default time, which will be added to pot on collision with Liquid Sulfur.
EML_Pot_OnAdd_LiquidSulfur = 10;
-- Change to false if you won't water/iodine/acid/sulfur disappear on empty.
EML_Pot_DestroyEmpty = true;


-- Special Pot default time.
EML_SpecialPot_StartTime = 160;
-- Default time, which will be added to pot on collision with Red Phosphorus.
EML_SpecialPot_OnAdd_RedPhosphorus = 20;
-- Default time, which will be added to pot on collision with Crystallized Iodine.
EML_SpecialPot_OnAdd_CrystallizedIodine = 20;
-- Change to false if you won't Red Phosphorus/Crystallized Iodine disappear on empty.
EML_SpecialPot_DestroyEmpty = true;


-- Default Liquid Sulfur amount.
EML_Sulfur_Amount = 2;
EML_Sulfur_Color = Color(243, 213, 19, 255);
-- Default Muriatic Acid amount.
EML_MuriaticAcid_Amount = 3;
EML_MuriaticAcid_Color = Color(160, 221, 99, 255);
-- Default Liquid Iodine amount.
EML_Iodine_Amount = 2;
EML_Iodine_Color = Color(137, 69, 54, 255);
-- Default Water amount.
EML_Water_Amount = 3;
EML_Water_Color = Color(133, 202, 219, 255);


-- Meth value modifier. (1500/lbs)
EML_Meth_ValueModifier = 120;
-- Meth addicted person (I don't like NPCs at all).
EML_Meth_UseSalesman = true;
-- Make player wanted once he sold meth?
EML_Meth_MakeWanted = true;

-- Type 'methbuyer_setpos <name>' to add NPC on map (at your target position and faces to you).
-- Type 'methbuyer_remove <name>' to remove NPC from map.

-- Use text above salesman's head?
EML_Meth_SalesmanText = true;
-- Salesman name.
EML_Meth_Salesman_Name = "Скупщик Мета";
-- Salesman name color.
EML_Meth_Salesman_Name_Color = Color(1, 241, 249, 255);
-- Salesman phrases if player don't have meth.
EML_Meth_Salesman_NoMeth = {
	"Есть мет?",
	"дайте мне синюю малышку!",
	"мет, мет, мет?",
	"Мне нужен мет!"
	};
-- Salesman sounds if player don't have meth.
EML_Meth_Salesman_NoMeth_Sound = {
	"vo/npc/male01/gethellout.wav",
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/no01.wav",
	"vo/npc/male01/ohno.wav"	
	};
-- Salesman phrases if player got meth.
EML_Meth_Salesman_GotMeth = {
	"Ох как вставило",
	"Аргх как хорошо то",
	"О боже мой",
	"Спасибо тебе огромное"
	};	
-- Salesman phrases if player don't have meth.	
EML_Meth_Salesman_GotMeth_Sound = {
	"vo/npc/male01/yeah02.wav",
	"vo/npc/male01/finally.wav",
	"vo/npc/male01/oneforme.wav",
	};

-- It starts on 0%.
EML_Jar_StartProgress = 0;
-- Minimal speed on shaking. (25 is ok)
EML_Jar_MinShake = 25;
-- Minimal speed on shaking. (1000 is ok)
EML_Jar_MaxShake = 1000;
-- Progress on correct shaking.
EML_Jar_CorrectShake = 4;
-- Progress on correct shaking.
EML_Jar_WrongShake = 1;
-- Change to false if you won't acid/iodine/water disappear on empty.
EML_Jar_DestroyEmpty = true;


-- Default gas amount in gas canister.
EML_Gas_Amount = 900;
-- 0 - Can't be exploded/destroyed; 1 - Can be destroyed without explosion; 2 - Explodes instantly.
EML_Gas_ExplosionType = 0;
-- Removes when out of gas.
EML_Gas_Remove = true;