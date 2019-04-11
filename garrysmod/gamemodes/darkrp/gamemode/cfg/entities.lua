--
-- -- Printers
-- rp.AddEntity("Money Printer",{
-- 	ent = "money_printer",
-- 	model = "models/props_c17/consolebox01a.mdl",
-- 	price = 3000,
-- 	max = 2,
-- 	cmd = "/buyprinter",
-- 	pocket = false
-- })

-- rp.AddEntity("Printer Ink Upgrade",{
-- 	ent = "money_printer_ink",
-- 	model = "models/props_lab/reciever01d.mdl",
-- 	price = 400,
-- 	max = 4,
-- 	cmd = "/buyinker"
-- })

-- rp.AddEntity("Printer Fixer",{
-- 	ent = "money_printer_fix",
-- 	model = "models/props_c17/tools_wrench01a.mdl",
-- 	price = 500,
-- 	max = 4,
-- 	cmd = "/buyprintfix"
-- })

-- rp.AddEntity("Money Basket", {
-- 	ent = "money_basket",
-- 	model = "models/props_junk/PlasticCrate01a.mdl",
-- 	price = 500,
-- 	max = 4,
-- 	cmd = "/buybasket",
-- 	pocket = false
-- })

-- rp.AddEntity("STD Meds", "ent_stdmeds", "models/jaanus/aspbtl.mdl", 100, 4, "/buystdmeds")

-- rp.AddEntity("Picture Frame", {
-- 	ent = "ent_picture",
-- 	model = "models/hunter/plates/plate1x1.mdl",
-- 	price = 2000,
-- 	max = 1,
-- 	cmd = "/buypic",
-- 	pocket = false
-- })

-- rp.AddEntity("Metal Detector", {
-- 	ent = "metal_detector",
-- 	model = "models/props_wasteland/interior_fence002e.mdl",
-- 	price = 7500,
-- 	max = 1,
-- 	cmd = "/buymetal",
-- 	pocket = false
-- })

-- -- Hobo
-- rp.AddEntity("Donation Box", {
-- 	ent = "donation_box",
-- 	model = "models/props/CS_militia/footlocker01_open.mdl",
-- 	price = 1500,
-- 	max = 4,
-- 	cmd = "/buybox",
-- 	allowed = {TEAM_HOBO, TEAM_HOBOKING, TEAM_DJ},
-- 	pocket = false
-- })


-- -- DJ
-- rp.AddEntity("Radio", {
-- 	ent = "media_radio",
-- 	model = "models/props_lab/citizenradio.mdl",
-- 	price = 900,
-- 	max = 1,
-- 	cmd = "/buyradio",
-- 	allowed = TEAM_DJ,
-- 	pocket = false
-- })

-- -- Notes
-- rp.AddEntity("Note", {
-- 	ent = "ent_note",
-- 	model = "models/props_c17/paper01.mdl",
-- 	price = 500,
-- 	max = 2,
-- 	cmd = "/note",
-- 	pocket = false,
-- 	onSpawn = function(ent, pl)
-- 		if (IsValid(pl.LastNote)) then
-- 			pl.LastNote:Remove()
-- 		end

-- 		pl.LastNote = ent

-- 		rp.Notify(pl, NOTIFY_GREEN, rp.Term('USENote'))
-- 	end
-- })
rp.AddEntity("Денежный Принтер", {
	ent = "boost_printer_green",
	model = "models/props_c17/consolebox01a.mdl",
	price = 150,
	allowed = {TEAM_CITIZEN24, TEAM_R2, TEAM_CITIZEN1, TEAM_CITIZEN2, TEAM_CITIZEN3},
	cmd = '/mon1', -- Если команды нету, то предмет нельзя купить.
	max = 2,
	pocket = true
})

rp.AddEntity("Улучшенный Принтер", {
	ent = "boost_printer_yellow",
	model = "models/props_c17/consolebox01a.mdl",
	price = 450,
	allowed = {TEAM_CITIZEN1, TEAM_CITIZEN2, TEAM_CITIZEN3},
	cmd = '/mon2', -- Если команды нету, то предмет нельзая купить.
	max = 2,
	pocket = true
})

rp.AddEntity("Качественный Принтер", {
	ent = "boost_printer_red",
	model = "models/props_c17/consolebox01a.mdl",
	price = 750,
	allowed = {TEAM_CITIZEN1, TEAM_CITIZEN2, TEAM_CITIZEN3},
	cmd = '/mon3', -- Если команды нету, то предмет нельзя купить.
	max = 3,
	pocket = true
})


rp.AddEntity("Профессиональный Принтер", {
	ent = "boost_printer_purple",
	model = "models/props_c17/consolebox01a.mdl",
	price = 1050,
	allowed = {TEAM_CITIZEN1, TEAM_CITIZEN2, TEAM_CITIZEN3},
	cmd = '/mon4', -- Если команды нету, то предмет нельзя купить.
	max = 3,
	pocket = true
})

-- Notes
rp.AddEntity("Помятая бумага (Мусор)", {
	ent = "trash_paper",
	model = "models/props_junk/garbage_carboard002a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Ржавая банка (Мусор)", {
	ent = "trash_can",
	model = "models/props_junk/garbage_metalcan001a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Пустая бутылка (Мусор)", {
	ent = "trash_bottle",
	model = "models/props_junk/garbage_plasticbottle003a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Дерево", {
	ent = "trash_wood",
	model = "models/props_c17/FurnitureDrawer001a_Chunk03.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Ткань", {
	ent = "trash_lether",
	model = "models/props_c17/playground_swingset_seat01a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Метал", {
	ent = "trash_metal",
	model = "models/props_debris/metal_panel01a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Инструменты", {
	ent = "trash_tools",
	model = "models/props_c17/tools_wrench01a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

rp.AddEntity("Карбон", {
	ent = "trash_carbon",
	model = "models/props_c17/lamp001a.mdl",
	price = 100,
	allowed = {},
	max = 2,
	pocket = true
})

-- Mayor
-- rp.AddShipment("Gun License","models/props_lab/clipboard.mdl", "ent_licence", 1250, 10, true, 100, false, {TEAM_MAYOR})

rp.AddEntity("Пищевой Рацион", {
	ent = "citizen_ration",
	model = "models/pg_plops/pg_food/pg_tortellinar.mdl",
	price = 900,
	-- cmd = '/t',
	max = 1,
	pocket = true
})

-- Gun Dealer
-- rp.AddWeapon("Revolver", "models/weapons/w_357.mdl", "cw_357", 10000, 10, false, 1300, false, {TEAM_CITIZEN})
rp.AddClothe("Шапка с Повязкой", "models/tnb/items/beaniewrap.mdl", "hat", 500, 10, true, 1300, false, {}, {key=4,value=1,buff=0.16})
rp.AddClothe("Повязка", "models/tnb/items/facewrap.mdl", "beret", 300, 10, true, 1300, false, {}, {key=4,value=1,buff=0.16})
rp.AddClothe("Противогаз", "models/tnb/items/beaniewrap.mdl", "gas", 600, 10, true, 1300, false, {}, {key=4,value=2,buff=0.18})
rp.AddClothe("Перчатки", "models/tnb/items/beaniewrap.mdl", "gloves", 250, 10, true, 1300, false, {}, {key=3,value=1,buff=0.6})
rp.AddClothe("Штаны", "models/tnb/items/pants_citizen.mdl", "pants", 750, 10, true, 1300, false, {}, {key=2,value=2,buff=0.20})
rp.AddClothe("Повстанческие Штаны", "models/tnb/items/pants_rebel.mdl", "pants2", 900, 10, true, 1300, false, {}, {key=4,value=1,buff=0.16})
rp.AddClothe("Лёгкая Броня", "models/tnb/items/shirt_rebel1.mdl", "pants3", 1200, 10, true, 1300, false, {}, {key=1,value=7,buff=0.30})
rp.AddClothe("Стандартная Броня", "models/tnb/items/shirt_rebel_molle.mdl", "pants4", 1500, 10, true, 1300, false, {}, {key=1,value=8,buff=0.40})
rp.AddClothe("Особая Броня", "models/tnb/items/shirt_rebelbag.mdl", "pants5", 1800, 10, true, 1300, false, {}, {key=1,value=15,buff=0.50})
rp.AddClothe("Броня ГО", "models/tnb/items/shirt_rebelmetrocop.mdl", "pants6", 2500, 10, true, 1300, false, {}, {key=1,value=14,buff=0.60})
rp.AddClothe("Броня Надзора", "models/tnb/items/shirt_rebeloverwatch.mdl", "pants7", 4000, 10, true, 1300, false, {}, {key=1,value=13,buff=0.70})
rp.AddClothe("Тёплая Одежда", "models/tnb/items/wintercoat.mdl", "pants8", 2000, 10, true, 1300, false, {}, {key=1,value=16,buff=0.20})
rp.AddClothe("Пальто", "models/tnb/items/trenchcoat.mdl", "pants9", 1800, 10, true, 1300, false, {}, {key=1,value=3,buff=0.25})

rp.AddWeapon("Pistol", "models/weapons/w_pist_usp.mdl", "swb_pistol", 6200, 10, false, 1300, false, {})
rp.AddWeapon("SMG", "models/weapons/w_pist_usp.mdl", "swb_smg", 8200, 10, false, 1300, false, {})
rp.AddWeapon("AWP", "models/weapons/3_snip_awp.mdl", "swb_awp", 10000, 10, false, 1300, false, {})
rp.AddWeapon("AK47", "models/weapons/3_rif_ak47.mdl", "swb_ak47", 8000, 10, false, 1100, false, {TEAM_HERO8})
rp.AddWeapon("Desert Eagle", "models/weapons/3_pist_deagle.mdl", "swb_deagle", 6500, 10, false, 800, false, {TEAM_HERO8})
rp.AddWeapon("Famas", "models/weapons/3_rif_famas.mdl", "swb_famas", 7500, 10, false, 1050, false, {TEAM_HERO8})
rp.AddWeapon("Fiveseven", "models/weapons/3_pist_fiveseven.mdl", "swb_fiveseven", 6000, 10, false, 750, false, {TEAM_HERO8})
rp.AddWeapon("P90", "models/weapons/3_smg_p90.mdl", "swb_p90", 7295, 10, false, 1005, false, {TEAM_HERO8})
rp.AddWeapon("Glock", "models/weapons/3_pist_glock18.mdl", "swb_glock18", 6200, 10, false, 770, false, {TEAM_HERO8})
rp.AddWeapon("G3", "models/weapons/3_snip_g3sg1.mdl", "swb_g3sg1", 9000, 10, false, 1200, false, {TEAM_HERO8})
rp.AddWeapon("MP5", "models/weapons/3_smg_mp5.mdl", "swb_mp5", 6500, 10, false, 950, false, {TEAM_HERO8})
rp.AddWeapon("UMP45", "models/weapons/3_smg_ump45.mdl", "swb_ump", 6800, 10, false, 980, false, {TEAM_HERO8})
rp.AddWeapon("Galil", "models/weapons/3_rif_galil.mdl", "swb_galil", 8000, 10, false, 1100, false, {TEAM_HERO8})
rp.AddWeapon("Mac10", "models/weapons/3_smg_mac10.mdl", "swb_mac10", 6000, 10, false, 900, false, {TEAM_HERO8})
rp.AddWeapon("M249", "models/weapons/3_mach_m249para.mdl", "swb_m249", 40000, 5, false, 10000, false, {TEAM_HERO8})
rp.AddWeapon("M3 Super 90", "models/weapons/3_shot_m3super90.mdl", "swb_m3super90", 7000, 10, false, 1000, false, {TEAM_HERO8})
rp.AddWeapon("P228", "models/weapons/3_pist_p228.mdl", "swb_p228", 6000, 10, false, 750, false, {TEAM_HERO8})
rp.AddWeapon("SG550", "models/weapons/3_snip_sg550.mdl", "swb_sg550", 6000, 10, false, 750, false, {TEAM_HERO8})
rp.AddWeapon("SG552", "models/weapons/3_rif_sg552.mdl", "swb_sg552", 9500, 10, false, 1250, false, {TEAM_HERO8})
rp.AddWeapon("AUG", "models/weapons/3_rif_aug.mdl", "swb_aug", 8500, 10, false, 1150, false, {TEAM_HERO8})
rp.AddWeapon("Scout", "models/weapons/3_snip_scout.mdl", "swb_scout", 8500, 10, false, 1150, false, {TEAM_HERO8})
rp.AddWeapon("TMP", "models/weapons/3_smg_tmp.mdl", "swb_tmp", 6300, 10, false, 930, false, {TEAM_HERO8})
rp.AddWeapon("XM1014", "models/weapons/3_shot_xm1014.mdl", "swb_xm1014", 6300, 10, false, 930, false, {TEAM_HERO8})
rp.AddWeapon("M4A1", "models/weapons/3_rif_m4a1.mdl", "swb_m4a1", 8000, 10, false, 1100, false, {TEAM_HERO8})
rp.AddWeapon("USP", "models/weapons/3_pist_usp.mdl", "swb_usp", 6000, 10, false, 750, false, {TEAM_HERO8})
rp.AddWeapon("357", "models/weapons/w_357.mdl", "swb_357", 7500, 10, false, 900, false, {TEAM_HERO8})

rp.AddWeapon("Взлом Барьера", "models/props_c17/tools_wrench01a.mdl", "weapon_shieldsbreaker", 200, 10, true, 900, false, {TEAM_R8})
rp.AddWeapon("Элитные Сигареты", "models/props_c17/tools_wrench01a.mdl", "weapon_ciga_cheap", 50, 10, false, 900, false, {TEAM_R8})
rp.AddWeapon("Заменитель Сигарет", "models/props_c17/tools_wrench01a.mdl", "weapon_ciga_blat", 50, 10, false, 900, false, {TEAM_R8})
rp.AddWeapon("Взломщик", "models/props_c17/tools_wrench01a.mdl", "lockpick", 7500, 10, false, 550, false, {TEAM_R8})
rp.AddEntity("Батарея Принтера", "boost_battery", "models/props_c17/consolebox05a.mdl", 100, 10, "/buybatt", TEAM_R8, false)
rp.AddEntity("Охлаждение Принтера", "boost_cooling", "models/props_junk/PropaneCanister001a.mdl", 120, 10, "/buycool", TEAM_R8, false)
rp.AddEntity("Батарея Принтера", "boost_battery", "models/props_c17/consolebox05a.mdl", 100, 10, "/buybatt", TEAM_CITIZEN2, false)
rp.AddEntity("Охлаждение Принтера", "boost_cooling", "models/props_junk/PropaneCanister001a.mdl", 120, 10, "/buycool", TEAM_CITIZEN2, false)
rp.AddEntity("Батарея Принтера", "boost_battery", "models/props_c17/consolebox05a.mdl", 100, 10, "/buybatt", TEAM_CITIZEN3, false)
rp.AddEntity("Охлаждение Принтера", "boost_cooling", "models/props_junk/PropaneCanister001a.mdl", 120, 10, "/buycool", TEAM_CITIZEN3, false)
---
-- rp.AddWeapon("Взлом Барьера", "models/props_c17/tools_wrench01a.mdl", "weapon_shieldsbreaker", 200, 10, true, 900, false, {TEAM_CWU2})
-- rp.AddWeapon("Элитные Сигареты", "models/props_c17/tools_wrench01a.mdl", "weapon_ciga_cheap", 50, 10, false, 900, false, {TEAM_CWU2})
-- rp.AddWeapon("Заменитель Сигарет", "models/props_c17/tools_wrench01a.mdl", "weapon_ciga_blat", 50, 10, false, 900, false, {TEAM_CWU2})
-- rp.AddWeapon("Взломщик", "models/props_c17/tools_wrench01a.mdl", "lockpick", 7500, 10, false, 550, false, {TEAM_CWU2})
-- rp.AddEntity("Батарея Принтера", "boost_battery", "models/props_c17/consolebox05a.mdl", 100, 10, "/buybatt", TEAM_CWU2, false)
-- rp.AddEntity("Охлаждение Принтера", "boost_cooling", "models/props_junk/PropaneCanister001a.mdl", 120, 10, "/buycool", TEAM_CWU2, false)


rp.AddEntity("Газ", "eml_gas", "models/props_c17/canister02a.mdl", 40, 4, "/buymet2", TEAM_METH, true)
rp.AddEntity("Банка", "eml_jar", "models/props_junk/garbage_metalcan002a.mdl", 35, 4, "/buymet4", TEAM_METH, true)
rp.AddEntity("Кастрюля", "eml_pot", "models/props_interiors/pot02a.mdl", 25, 4, "/buymet6", TEAM_METH, true)
rp.AddEntity("Специальная Кастрюля", "eml_spot", "models/props_interiors/pot02a.mdl", 40, 4, "/buymet8", TEAM_METH, true)
rp.AddEntity("Плита", "eml_stove", "models/props_wasteland/kitchen_stove001a.mdl", 150, 1, "/buymet9", TEAM_METH, true)
rp.AddEntity("Вода", "eml_water", "models/props_junk/garbage_milkcarton001a.mdl", 20, 4, "/buymet11", TEAM_METH, true)
rp.AddEntity("Йод", "eml_iodine", "models/props_junk/garbage_milkcarton001a.mdl", 30, 4, "/buymet12", TEAM_METH, true)
rp.AddEntity("Сульфур", "eml_sulfur", "models/props_junk/garbage_milkcarton001a.mdl", 25, 4, "/buymet13", TEAM_METH, true)
rp.AddEntity("Соляная Кислота", "eml_macid", "models/props_junk/garbage_milkcarton001a.mdl", 40, 4, "/buymet14", TEAM_METH, true)

-- Black Market Dealer
rp.AddEntity("Батарея Принтера", "boost_battery", "models/props_c17/consolebox05a.mdl", 100, 10, "/buybatt27", TEAM_TRADE, false)
rp.AddEntity("Охлаждение Принтера", "boost_cooling", "models/props_junk/PropaneCanister001a.mdl", 120, 10, "/buycool122", TEAM_TRADE, false)
rp.AddEntity("Гитара", "guitar_stalker", "models/props_junk/PropaneCanister001a.mdl", 250, 10, "/buycool122", TEAM_TRADE, false)
rp.AddEntity("Сигарета", "weapon_ciga_pachka", "models/props_junk/PropaneCanister001a.mdl", 150, 10, "/buycool123", TEAM_TRADE, false)
rp.AddEntity("Отмычка", "lockpick", "models/props_junk/PropaneCanister001a.mdl", 450, 10, "/buycool124", TEAM_TRADE, false)
rp.AddEntity("Взлом Щитов", "weapon_shieldsbreaker", "models/props_junk/PropaneCanister001a.mdl", 500, 10, "/buycool125", TEAM_TRADE, false)

-- Bartender
-- rp.AddShipment("Beer", "models/drug_mod/alcohol_can.mdl", "durgz_alcohol", 500, 12, false, 50, false, {TEAM_BARTENDER})
-- rp.AddShipment("Water", "models/drug_mod/the_bottle_of_water.mdl", "durgz_water", 600, 24, false, 30, false, {1})
-- rp.AddShipment("Milk","models/props_junk/garbage_milkcarton001a.mdl", "ent_milk", 3500, 10, false, 300, false, {TEAM_BARTENDER})

-- medic
-- rp.AddShipment("Aspirin", "models/jaanus/aspbtl.mdl", "durgz_aspirin", 450, 10, false, 55, false, {TEAM_DOCTOR})
-- rp.AddShipment("Health Pack","models/Items/HealthKit.mdl", "ent_medpack", 4000, 10, false, 550,false,{TEAM_DOCTOR})
-- rp.AddEntity("Денежный Принтер", "boost_printer_green", "models/props_c17/consolebox01a.mdl", 150, 2, "/buyprindef", TEAM_CITIZEN24, false)
-- rp.AddEntity("Улучшенный Принтер", "boost_printer_yellow", "models/props_c17/consolebox01a.mdl", 450, 2, "/buyprindef2", TEAM_CITIZEN1, false)
-- rp.AddEntity("Качественный Принтер", "boost_printer_red", "models/props_c17/consolebox01a.mdl", 650, 2, "/buyprindef3", TEAM_CITIZEN2, false)
-- rp.AddEntity("Профессиональный Принтер", "boost_printer_purple", "models/props_c17/consolebox01a.mdl", 900, 3, "/buyprindef4", TEAM_CITIZEN3, false)

-- drug dealer
-- rp.AddDrug('Weed', 'durgz_weed', 'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl', 250, TEAM_DRUGDEALER)
-- rp.AddDrug('Cigarettes', 'durgz_cigarette', 'models/boxopencigshib.mdl', 150, TEAM_DRUGDEALER)
-- rp.AddDrug('Heroin', 'durgz_heroine', 'models/katharsmodels/syringe_out/syringe_out.mdl', 1000, TEAM_DRUGDEALER)
-- rp.AddDrug('LSD', 'durgz_lsd', 'models/smile/smile.mdl', 300, TEAM_DRUGDEALER)
-- rp.AddDrug('Shrooms', 'durgz_mushroom', 'models/ipha/mushroom_small.mdl', 275, TEAM_DRUGDEALER)
-- rp.AddDrug('Coke', 'durgz_cocaine', 'models/cocn.mdl', 400, TEAM_DRUGDEALER)
-- rp.AddDrug('Meth', 'durgz_meth', 'models/cocn.mdl', 500, TEAM_DRUGDEALER)
-- rp.AddDrug('Bath Salts', 'durgz_bathsalts', 'models/props_lab/jar01a.mdl', 150, TEAM_DRUGDEALER)

-- rp.AddEntity("Pot", {
-- 	ent = "weed_plant",
-- 	model = "models/alakran/marijuana/pot_empty.mdl",
-- 	price = 250,
-- 	max = 10,
-- 	cmd = "/buypot",
-- 	allowed = {TEAM_DRUGDEALER},
-- 	pocket = false
-- })

-- rp.AddEntity("Seed", {
-- 	ent = "seed_weed",
-- 	model = "models/Items/AR2_Grenade.mdl",
-- 	price = 40,
-- 	max = 20,
-- 	cmd = "/buyseed",
-- 	allowed = {TEAM_DRUGDEALER}
-- })

-- rp.AddEntity("Drug lab", {
-- 	ent = "drug_lab",
-- 	model = "models/props_lab/crematorcase.mdl",
-- 	price = 1000,
-- 	max = 2,
-- 	cmd = "/buydruglab",
-- 	allowed = {TEAM_DRUGDEALER},
-- 	pocket = false
-- })

-- rp.AddEntity("Microwave", {
-- 	ent = "microwave",
-- 	model = "models/props/cs_office/microwave.mdl",
-- 	price = 1000,
-- 	max = 4,
-- 	cmd = "/buymicrowave",
-- 	allowed = TEAM_COOK,
-- 	pocket = false
-- })

-- hook.Call('rp.AddEntities', GAMEMODE)

-- Cook
rp.AddFoodItem("Банан", "models/props/cs_italy/bananna.mdl", 10, 10/2)
rp.AddFoodItem("Связка бананов", "models/props/cs_italy/bananna_bunch.mdl", 10, 10/2)
rp.AddFoodItem("Вода", "models/bioshockinfinite/xoffee_mug_closed.mdl", 20, 20/2)
rp.AddFoodItem("Бутылка газировки", "models/props_junk/GlassBottle01a.mdl",20, 20/2)
-- rp.AddFoodItem("Popcan", "models/props_junk/PopCan01a.mdl", 5, 5/2)
rp.AddFoodItem("Бутылка воды", "models/props_junk/garbage_plasticbottle003a.mdl", 15, 15/2)
rp.AddFoodItem("Еда из рациона", "models/foodnhouseholdaaaaa/combirationc.mdl", 30, 30/2)
-- rp.AddFoodItem("Bottle1", "models/props_junk/garbage_glassbottle001a.mdl", 10, 10/2)
-- rp.AddFoodItem("Bottle2", "models/props_junk/garbage_glassbottle002a.mdl", 10, 10/2)
-- rp.AddFoodItem("Bottle3", "models/props_junk/garbage_glassbottle003a.mdl", 10, 10/2)
rp.AddFoodItem("Апельсин", "models/props/cs_italy/orange.mdl",20, 20/2)
-- rp.AddFoodItem("Burger", "models/food/burger.mdl", 50, 50/2)
-- rp.AddFoodItem("Hotdog", "models/food/hotdog.mdl", 45, 45/2)
rp.AddFoodItem("Лапша", "models/props_junk/garbage_takeoutcarton001a.mdl", 40, 40/2)

rp.AddAmmoType("Pistol", "Pistol Ammo", "models/Items/BoxSRounds.mdl", 50, 50)
rp.AddAmmoType("Buckshot", "Shotgun Ammo", "models/Items/BoxBuckshot.mdl", 50, 25)
rp.AddAmmoType("smg1", "SMG Ammo ", "models/Items/BoxSRounds.mdl", 100, 100)
rp.AddAmmoType("Rifle", "Rifle Ammo ", "models/Items/BoxSRounds.mdl", 100, 50)
rp.AddAmmoType("AR2", "Rifle Ammo ", "models/Items/BoxSRounds.mdl", 100, 50)

-- -- Copshop
-- rp.AddCopItem('Riot Shield', {
-- 	Price = 750,
-- 	Weapon = 'weapon_shield',
-- 	Model = 'models/custom/ballisticshield.mdl',
-- })

-- rp.AddCopItem('Ammo Pack', {
-- 	Price = 500,
-- 	Model = 'models/Items/BoxSRounds.mdl',
-- 	Callback = function(pl)
-- 		for k, v in ipairs(rp.ammoTypes) do
-- 			pl:GiveAmmo(120, v.ammoType, true)
-- 		end
-- 	end
-- })

-- rp.AddCopItem('C4', {
-- 	Price = 20000,
-- 	Model = 'models/weapons/2_c4_planted.mdl',
-- 	Callback = function(pl)
-- 		pl:Give('weapon_c4')
-- 	end
-- })

-- rp.AddCopItem('Health', {
-- 	Price = 250,
-- 	Model = 'models/Items/HealthKit.mdl',
-- 	Callback = function(pl)
-- 		pl:SetHealth(100)
-- 	end
-- })

-- rp.AddCopItem('Armor', {
-- 	Price = 300,
-- 	Model = 'models/props_junk/cardboard_box004a.mdl',
-- 	Callback = function(pl)
-- 		pl:SetArmor(100)
-- 	end
-- })
