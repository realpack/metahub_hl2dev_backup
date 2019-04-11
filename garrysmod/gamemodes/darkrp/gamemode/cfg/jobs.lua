function PLAYER:LastBodygroup( index )
	local models = self:GetBodyGroups()[index].submodels
	return table.Count( models ) - 1 or 0
end

-- ply:SetBodygroup( 2, ply:LastBodygroup( 2 ) )

local cpcolor = Color(71, 71, 71, 200)

local cp_models = {
	"models/player/hl2_malecp1.mdl",
	"models/player/hl2_malecp10.mdl",
	"models/player/hl2_malecp2.mdl",
	"models/player/hl2_malecp11.mdl",
	"models/player/hl2_malecp7.mdl",
	"models/player/hl2_malecp13.mdl",
}

local cp2_models = {
	"models/player/hl2_elitmalecp1.mdl",
	"models/player/hl2_elitmalecp10.mdl",
	"models/player/hl2_elitmalecp11.mdl",
	"models/player/hl2_elitmalecp7.mdl",
	"models/player/hl2_elitmalecp13.mdl",
}

local citizens = {
	'models/tnb/citizens/male_01.mdl',
	'models/tnb/citizens/male_02.mdl',
	'models/tnb/citizens/male_03.mdl',
	'models/tnb/citizens/male_04.mdl',
	'models/tnb/citizens/male_05.mdl',
	'models/tnb/citizens/male_06.mdl',
	'models/tnb/citizens/male_07.mdl',
	'models/tnb/citizens/male_08.mdl',
	'models/tnb/citizens/male_09.mdl',
	'models/tnb/citizens/male_10.mdl',
}

local ind_models = {
	"models/industrial_uniforms/pm_industrial_uniform.mdl",
    "models/industrial_uniforms/pm_industrial_uniform2.mdl",
}

local loyal_models = {
	'models/player/scifi_male_01.mdl',
	'models/player/scifi_male_02.mdl',
	'models/player/scifi_male_03.mdl',
	'models/player/scifi_male_04.mdl',
	'models/player/scifi_male_07.mdl',
	'models/player/scifi_female_02.mdl',
	'models/player/scifi_female_01.mdl',
	'models/player/scifi_rochelle.mdl',
	'models/player/scifi_fang.mdl',
	'models/player/scifi_hawke.mdl',
}

local vort_models = {
	"models/player/vortigaunt.mdl",
}

TEAM_CITIZEN = rp.addTeam('Недавно Прибывший', {
	color = Color(102,153,102),
	model = false,
	description = [[
Недавно прибывший в Сити 18 человек, не прошедший проверку и идентификацию на получение CID-карты.
]],
	weapons = {},
	type = TEAMTYPE_CITIZEN,
	command = 'citizen',
	max = 0,
	salary = 45,
	admin = 0,
	hasLicense = false,
	candemote = false,
})

TEAM_CITIZEN24 = rp.addTeam('Гражданини Сити 18', {
	color = Color(102,153,102),
	model = false,
	description = [[
Расположенная в Европе, Женева, город отличался от остальных городов, управляемостью со стороны Альянса, почти фанатичным путем пропагандистских манипуляций.
Его обильные красные знамена взлетают по всему городу, создавая чувство Альянсовского национализма, после чего старый орел на гербе Женевы становится более жестким и постоянно наблюдающим.
На первый взгляд город напоминает шепот старого мира из-за своего поддельного положения престижа и комфорта, его дорожные и уличные здания остаются в хорошем состоянии и относительно чистыми.
В глубине города ходят слухи об активности сопротивления, хотя Департамент пропаганды, естественно, отрицает, что такие слухи могут быть чем-то иным, чем ложью.
]],
	weapons = {"id_citizen"},
	type = TEAMTYPE_CITIZEN,
	command = 'citizen24',
	max = 0,
	salary = 45,
	admin = 0,
	hasLicense = false,
		PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 0)
		ply:SetBodygroup(2, 0)
		ply:SetBodygroup(3, 0)
		ply:SetBodygroup(4, 0)
	end,
	candemote = false,
})

TEAM_ANTICITIZEN = rp.addTeam('Беженец', {
	color = Color(102,153,102),
	model = false,
	description = [[Гражданин, который сумел сбежать от гнетущего режима альянса и потерял свои очки лояльности. Вынужден скрываться от них в наиболее темных закоулках города ради своей же безопасности.]],
	weapons = {"id_citizen", "id_rebel"},
	radio = "rebel",
	type = TEAMTYPE_CITIZEN,
	command = 'anticitizen',
	max = 0,
	salary = 45,
	admin = 0,
	hasLicense = false,
	candemote = false,
	needbuy = true,
})

TEAM_R1 = rp.addTeam('Рекрут', {
	color = Color(102,153,102),
	model = false,
	description = [[
Начальное звено в повстанческой сети. Несогласный с диктатурой в городе, вынужден скрываться в сетях канализаций Сити-18.
]],
	weapons = {"id_citizen", "id_rebel", "swb_p228"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r1',
	max = 0,
	salary = 45,
	admin = 0,
	hasLicense = false,
	candemote = false,
	needbuy = true,
})

TEAM_R2 = rp.addTeam('Повстанец', {
	color = Color(102,153,102),
	model = false,
	description = [[
Верный член Сопротивления, который твердо для себя решил, что станет верным защитником всех, кто не согласен с диктатурой в Сити-18.
]],
	weapons = {"id_citizen", "id_rebel", "swb_smg"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r2',
	max = 0,
	flashlight = true,
	salary = 45,
	admin = 0,
	needteam = 'r1',
	hasLicense = false,
	candemote = false,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetArmor(100) end,
})

TEAM_R3 = rp.addTeam('Штурмовик', {
	color = Color(102,153,102),
	model = false,
	description = [[
Член сопротивления, неплохо обращающийся с тяжелым оружием.
]],
	weapons = {"id_citizen", "id_rebel", "swb_shotgun", "swb_galil", "ammothreeaura"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r3',
	max = 3,
	flashlight = true,
	salary = 45,
	admin = 0,
	needteam = 'r2',
	hasLicense = false,
	candemote = false,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(200) end,
})

TEAM_R4 = rp.addTeam('Медик', {
	color = Color(102,153,102),
	model = false,
	description = [[
Человек, обладающий познаниями и навыками медицины, которые он использует во благо постанческого движения Сити-18.
]],
	weapons = {"id_citizen", "id_rebel", "ultheal", "weapon_medkit", "swb_smg"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r4',
	max = 4,
	salary = 45,
	flashlight = true,
	admin = 0,
	needteam = 'r3',
	hasLicense = false,
	candemote = false,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetArmor(100) end,
})

TEAM_R5 = rp.addTeam('Специалист', {
	color = Color(102,153,102),
	model = "models/jessev92/hl2/characters/kurt_ply.mdl",
	description = [[
Верный боец сопротивления, который, проявив смелость, решился выйти на поверхность, чтобы активно докладывать командованию об обстановке в Сити-18.
]],
	weapons = {"id_citizen", "id_rebel", "swb_usp", "swb_scout", 'hook'},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r5',
	max = 3,
	salary = 45,
	admin = 0,
	flashlight = true,
	hasLicense = false,
	candemote = false,
	needbuy = true,
	needteam = 'r4',
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetArmor(150) end,
})

TEAM_R6 = rp.addTeam('Боец H.E.C.U', {
	color = Color(102,153,102),
	model = "models/hgrunt2.mdl",
	description = [[
Человек попавший в это время прямиком из черной мезы, неизвестно как и зачем, но известно одно - Он решил объеденится с сопротивлением и дать отпор Альянсу!
]],
	weapons = {"id_rebel", "swb_m4a1", "m9k_rpg7", "m9k_m61_frag"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r6',
	max = 3,
	salary = 45,
	admin = 0,
	flashlight = true,
	hasLicense = false,
	candemote = false,
	needbuy = true,
	needteam = 'r5',
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(250) end,
})

TEAM_R7 = rp.addTeam('Лидер Сопротивления', {
	color = Color(102,153,102),
	model = false,
	description = [[
Лицо повстанческого движения в Сити-18, под своим чутким руководством, он объединил всех повстанцев города под единым знаменем, чтобы в подходящий момент повести их к победе.]],
	weapons = {"id_citizen", "id_rebel", "swb_ar2"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r7',
	max = 1,
	salary = 45,
	admin = 0,
	flashlight = true,
	hasLicense = false,
	candemote = false,
	needbuy = true,
	needteam = 'r6',
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(300) end,
})

TEAM_R8 = rp.addTeam('Бывший Сотрудник ГСР', {
	color = Color(102,153,102),
	model = false,
	description = [[]],
	weapons = {"id_citizen", "id_rebel", "swb_usp"},
	radio = "rebel",
	type = TEAMTYPE_RABEL,
	command = 'r8',
	max = 1,
	salary = 45,
	admin = 0,
	flashlight = true,
	hasLicense = false,
	candemote = false,
	needbuy = true,
	cook = true,
	needteam = 'r1',
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(300) end,
})

TEAM_CRIME = rp.addTeam("Гражданин Вор", {
	color = Color(57, 112, 50, 200),
	model = nil,
	type = TEAMTYPE_CITIZEN,
	description = [[
	Гражданин, который выбрал нейтральную сторону, выживающий с помощью грабежа и мелких краж.]],
	weapons = {"id_citizen", "takemoney"},
	command = "crime",
	max = 4,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 1)
	end,
	needbuy = true,
})

TEAM_CRIME2 = rp.addTeam("Профессиональный Вор", {
	color = Color(57, 112, 50, 200),
	model = nil,
	type = TEAMTYPE_CITIZEN,
	description = [[
	Человек, который отлично разбирается в тонкостях воровского дела, и научился взламывать разного рода замки с помощью своих подручных инструментов.]],
	weapons = {"id_citizen", "weapon_hl2pipe", "lockpick", "takemoney"},
	command = "crime2",
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 1)
	end,
	needbuy = true,
	needteam = 'crime',
})


TEAM_CRIME3 = rp.addTeam("Взломщик", {
	color = Color(57, 112, 50, 200),
	model = nil,
	type = TEAMTYPE_CITIZEN,
	description = [[
	Бывалый грабитель, с помощью добытых знаний сконструировал приспособление, которое может взламывать электронные замки.]],
	weapons = {"id_citizen", "swb_knife", "lockpick", "keypad_cracker", "cw_p99", "takemoney", 'weapon_shieldsbreaker'},
	command = "crime3",
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 1)
	end,
	needbuy = true,
	needteam = 'crime2',
})

TEAM_CRIMES = rp.addTeam("Шпион Альянса", {
	color = Color(150, 92, 22, 200),
	model = "models/tnb/citizens/male_29.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Синтетический юнит Альянса, разработанный для внедрения в ряды повстанцев. Внешне похож на человека, но под повязкой имеет глаз со встроенным чипом, для передачи данных.]],
	weapons = {"id_citizen", "id_rebel", "swb_knife", "itemstore_pickup", "swb_usp", "swb_tmp"},
	radio = "cpu",
	flashlight = true,
	command = "crimes",
	needbuy = true,
	needteam = 'crime2',
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(150) end,
	max = 1
})

TEAM_HITMAN = rp.addTeam("Наёмник", {
	color = Color(57, 112, 50),
	model = nil,
	type = TEAMTYPE_CITIZEN,
	description = [[
	Обыватель преступного мира, который не брезгует убийством людей для получения наживы.]],
	weapons = {"lockpick", "swb_knife", "id_citizen"},
	command = "hit",
	max = 4,
	hitman = true,
	needbuy = true,
	needteam = 'crime3',
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 1)
	end,
})

TEAM_UN1 = rp.addTeam("RCT", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Начальный юнит гражданской обороны, который прошел первичный курс подготовки.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "rct",
	mask_group = 1,
	mask_type = 'metropolice_blue',
	needbuy = true,
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(1, 0)
		ply:SetBodygroup(3, 0)
		ply:SetBodygroup(4, 0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetArmor(200) end,
})

TEAM_UN2 = rp.addTeam("i6", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Юнит, заслуживший свое первое повышение, во время службы.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "pvt",
	mask_group = 2,
	mask_type = 'metropolice_blue',
	needbuy = true,
	needteam = 'rct',
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(3, 2)
		ply:SetBodygroup(1, 0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetArmor(200) end,
})

TEAM_UN3 = rp.addTeam("i5", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Юнит гражданской обороны, сумевший проявить себя перед командованием и получил возможность показать свои командирские навыки.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "cpl",
	max = 4,
	mask_group = 5,
	mask_type = 'metropolice_blue',
	needbuy = true,
	needteam = 'pvt',
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(3, 2)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(1, 0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetArmor(200) end,
})

TEAM_ALTER = rp.addTeam("i5", {
	color = Color(71, 71, 71, 200),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[]],
	weapons = {"id_rebel"},
	command = "reb3",
	radio = "cpu",
	mask_group = 5,
	mask_type = 'metropolice_blue',
	police = true,
	flashlight = true,
	max = 2,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(3, 2)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(1, 0)
	end,
	needbuy = true,
	needteam = 'cp1',
	PlayerSpawn = function(ply) ply:SetHealth(100) ply:SetArmor(200) end,
})

TEAM_UN4 = rp.addTeam("i4", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Сотрудник гражданской обороны, проявивший себя, как достойный командир группы и тем самым, получил повышение.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "sgt",
	mask_group = 4,
	mask_type = 'metropolice_red',
	needbuy = true,
	needteam = 'cp1',
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(3, 2)
		ply:SetSkin(1)
		ply:SetBodygroup(4, 0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetArmor(200) end,
})

TEAM_UN5 = rp.addTeam("i3", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Следую��ий по иерархии званий в ГО. Верный и преданный слуга Альянса, не имеющий человеческих чувствю]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	mask_group = 3,
	mask_type = 'metropolice_red',
	needbuy = true,
	needteam = 'sgt',
	command = "i3",
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 1)
		ply:SetSkin(1)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetArmor(200) end,
})

TEAM_UN6 = rp.addTeam("i2", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Командует Штрафбатом, а так же младшим составом ГО. Не имеет почти ничего общего с человеком.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "CPT",
	mask_group = 7,
	mask_type = 'metropolice_red',
	needbuy = true,
	needteam = 'i3',
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(4, 0)
		ply:SetBodygroup(5, 1)
		ply:SetSkin(3)
		ply:SetBodygroup(3, 0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetArmor(200) end,
})

TEAM_UN7 = rp.addTeam("i1", {
	color = Color(71, 71, 71),
	model = cp_models,
	type = TEAMTYPE_COMBINE,
	description = [[
Правая рука Sectorial Commander. Командует младшим составом ГО.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "LT",
	max = 1,
	mask_group = 6,
	mask_type = 'metropolice_red',
	needbuy = true,
	needteam = 'cpt',
	salary = 45,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(3, 0)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(5, 1)
		ply:SetSkin(3)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(150) ply:SetArmor(200) end,
})

TEAM_UN8 = rp.addTeam("Sectorial.Commander", {
	color = Color(71, 71, 71),
	model = "models/player/combine/male_08.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[
Верный слуга альянса, которого назначили в качестве командующего ГО в данном секторе.]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	command = "CO",
	needbuy = true,
	needteam = 'LT',
	salary = 45,
	max = 1,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(2, 1)
		ply:SetBodygroup(4, 1)
		ply:SetSkin(2)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(200) end,
})

-- ============================================================== --
-- =        СПЕЦ. ЮНИТЫ  //  ВСЕ ПРАВА ЗАЩИЩЕНЫ МУГАЛЬНЫМ       = --
-- ============================================================== --


TEAM_S0 = rp.addTeam("ZIEGLER", {
	color = Color(51, 89, 160, 200),
	model = "models/player/hl2_malecp13.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Юнит специального отделения ГО, деятельность которого направлена на поддержание уровня боеспособности остальных бойцов.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s1",
	mask_group = 2,
	mask_type = 'metropolice_yellow',
	max = 4,
	PlayerLoadout = function(ply)
		ply:SetSkin(4)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(3, 0)
		ply:SetBodygroup(4, 1)
	end,
	needbuy = true,
	needteam = 'i3',
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(250) end,
})

TEAM_S1 = rp.addTeam("SHIELD", {
	color = Color(51, 89, 160, 200),
	model = cp2_models,
	type = TEAMTYPE_COMBINE,
	description = [[Юнит специального отделения ГО, который, находясь впереди всех, принимает весь удар на себя.]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	command = "s2",
	needteam = 's1',
	mask_group = 2,
	mask_type = 'metropolice_blue',
	max = 4,
	PlayerLoadout = function(ply)
		ply:SetSkin(1)
		ply:SetBodygroup(3, 2)
		ply:SetBodygroup(4, 0)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(6, 1)
		ply:SetBodygroup(7, 1)
	end,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(300) end,
})

TEAM_S2 = rp.addTeam("HEAVY", {
	color = Color(51, 89, 160, 200),
	model = "models/tnb/combine/combine_dvl.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Тяжелый юнит специального отделения ГО, оснащенный тяжелейшей броней и вооружением.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s3",
	needteam = 's2',
	max = 3,
	mask_group = 1,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 0)
	end,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(400) end,
})

TEAM_S3 = rp.addTeam("ENGINEER", {
	color = Color(51, 89, 160, 200),
	model = cp2_models,
	type = TEAMTYPE_COMBINE,
	description = [[Юнит специального отделения ГО, занимающийся в основном обустройкой постов альянса по городу.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s4",
	needteam = 's3',
	mask_group = 4,
	mask_type = 'metropolice_yellow',
	max = 2,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(6, 1)
		ply:SetSkin(1)
	end,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_S4 = rp.addTeam("POLICE", {
	color = Color(51, 89, 160, 200),
	model = "models/novacp_player/novacp.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Особый патрульный юнит специального отделения ГО, следящий за порядком внутри ГО.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s5",
	needteam = 's4',
	max = 3,
	mask_group = 1,
	mask_type = 'metropolice_red',
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(250) end,
})

TEAM_S5 = rp.addTeam("ASSASSIN", {
	color = Color(51, 89, 160, 200),
	model = "models/assassin/fassassin.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Прошедший особую систему подготовки юнит специального отделения ГО, предназначенный для скрытного устранения целей.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s6",
	needteam = 's5',
	max = 2,
	mask_group = 1,
	mask_type = 'combine_elite_blue',
	police = true,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(200) end,
})

TEAM_S6 = rp.addTeam("EOD", {
	color = Color(51, 89, 160, 200),
	model = cp2_models,
	type = TEAMTYPE_COMBINE,
	description = [[Юнит специального отделения ГО, которому не составит труда подорвать группу врагов, при помощи своего арсенала.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s7",
	needteam = 's6',
	mask_group = 4,
	mask_type = 'metropolice_red',
	max = 2,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(3, 2)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(6, 1)
		ply:SetSkin(3)
		ply:SetBodygroup(5, 1)
		ply:SetBodygroup(7, 1)
	end,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(250) end,
})

TEAM_S7 = rp.addTeam("LEAK", {
	color = Color(51, 89, 160, 200),
	model = 'models/player/leak_combine_elite_sniper_fc.mdl',
	type = TEAMTYPE_COMBINE,
	description = [[Развед.юнит специального отделения ГО, главной особенностью которого является невидимость.]],
	weapons = {"itemstore_pickup"},
	radio = "cpu",
	flashlight = true,
	command = "s8",
	needteam = 's7',
	mask_group = 1,
	max = 1,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(200) end,
})

TEAM_S8 = rp.addTeam("REAPER", {
	color = Color(51, 89, 160, 200),
	model = 'models/jessev92/player/hl2/conceptbine.mdl',
	type = TEAMTYPE_COMBINE,
	description = [[Заместитель командира специального отдела ГО, строгий и требовательный командир]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s9",
	max = 1,
	needbuy = true,
	needteam = 's8',
	mask_group = 1,
	mask_type = 'combine_soldier_red',
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(400) end,
})

TEAM_S9 = rp.addTeam("PHOENIX", {
	color = Color(51, 89, 160, 200),
	model = "models/player/hl2_malecp13.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Командующий юнит, который руководит всем специальным отделением ГО.]],
	weapons = {""},
	radio = "cpu",
	flashlight = true,
	command = "s10",
	needteam = 's9',
	max = 1,
	needbuy = true,
	mask_group = 6,
	mask_type = 'metropolice_red',
	PlayerLoadout = function(ply)
		ply:SetSkin(3)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 1)
		ply:SetBodygroup(5, 1)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(400) end,
})

TEAM_COMBINE1 = rp.addTeam('RISE', {
	color = Color(150,170,200),
	model = { "models/player/combine_super_elite_soldier.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine1',
	needteam = 'i3',
	max = 0,
	salary = 45,
	admin = 0,
	mask_group = 1,
	mask_type = 'combine_soldier_blueq',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_COMBINE2 = rp.addTeam('STATIC', {
	color = Color(150,170,200),
	model = { "models/player/combine_super_elite_soldier_armored.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine22',
	needteam = 'combine1',
	max = 0,
	salary = 45,
	admin = 0,
	mask_group = 0,
	mask_type = 'combine_soldier_blue',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_STATICREBEL = rp.addTeam("STATIC", {
	color = Color(38, 97, 204, 200),
	model = { "models/player/combine_super_elite_soldier_armored.mdl" },
	type = TEAMTYPE_SUP,
	description = [[]],
	weapons = {"id_rebel"},
	radio = "cpu",
	command = "reb7",
	needteam = 'combine22',
	flashlight = true,
	needbuy = true,
	radio = "cpu",
	max = 1,
	mask_group = 0,
	mask_type = 'combine_soldier_blue',
	police = true,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_COMBINE3 = rp.addTeam('STRIKE', {
	color = Color(150,170,200),
	model = { "models/player/combine_shotgunner_armored.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine3',
	needteam = 'combine22',
	max = 0,
	salary = 45,
	admin = 0,
	mask_group = 0,
	mask_type = 'combine_soldier_red',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_COMBINE4 = rp.addTeam('RHINO', {
	color = Color(150,170,200),
	model = { "models/player/combine_heavy.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine4',
	needteam = 'combine3',
	max = 0,
	salary = 45,
	admin = 0,
	mask_group = 0,
	mask_type = 'combine_elite_red',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(350) end,
})

TEAM_COMBINE5 = rp.addTeam('PRIME', {
	color = Color(150,170,200),
	model = { "models/player/combine_advisor_guard_soldier_armored.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine5',
	needteam = 'combine4',
	max = 0,
	salary = 45,
	admin = 0,
	mask_group = 0,
	mask_type = 'combine_soldier_blue',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_COMBINE6 = rp.addTeam('ORDER', {
	color = Color(150,170,200),
	model = { "models/player/police_elite.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine6',
	needteam = 'combine5',
	max = 1,
	salary = 45,
	admin = 0,
	mask_group = 0,
	mask_type = 'metropolice_red',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_COMBINE7 = rp.addTeam('NOVA', {
	color = Color(150,170,200),
	model = { "models/player/combine_guard_armored.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine7',
	needteam = 'combine6',
	max = 0,
	salary = 45,
	admin = 0,
	mask_group = 0,
	mask_type = 'combine_soldier_yellow',
	police = true,
	needbuy = true,
	hasLicense = false,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})

TEAM_COMBINE8 = rp.addTeam('SUPERIOR', {
	color = Color(150,170,200),
	model = { "models/player/combine_super_soldier_armored.mdl" },
	description = [[]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	type = TEAMTYPE_SUP,
	command = 'combine2',
	needteam = 'combine7',
	max = 1,
	salary = 45,
	admin = 0,
	needbuy = true,
	hasLicense = false,
	mask_group = 0,
	mask_type = 'combine_elite_red',
	police = true,
	candemote = false,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(300) end,
})
-- ============================================================== --
-- =        ПОВСТАНЦЫ  //  ВСЕ ПРАВА ЗАЩИЩЕНЫ МУГАЛЬНЫМ         = --
-- ============================================================== --
TEAM_SYNTH1 = rp.addTeam("X1", {
	color = Color(28, 80, 175, 200),
	model = { "models/synth/elite_brown_pm.mdl" },
	type = TEAMTYPE_SUP,
	description = [[ДОСТУП С EUCLID]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	crateWeapon = {},
	command = "synth1",
	max = 4,
	needbuy = true,
	mask_group = 1,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(400) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "euclid" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" end,
})

TEAM_SYNTH2 = rp.addTeam("X2", {
	color = Color(28, 80, 175, 200),
	model = { "models/synth/elite_green_pm.mdl" },
	type = TEAMTYPE_SUP,
	description = [[ДОСТУП С EUCLID]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	crateWeapon = {},
	command = "synth2",
	max = 3,
	needbuy = true,
	mask_group = 1,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(450) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "euclid" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" end,
})

TEAM_SYNTH3 = rp.addTeam("X3", {
	color = Color(28, 80, 175, 200),
	model = { "models/synth/elite_pm_police.mdl" },
	type = TEAMTYPE_SUP,
	description = [[ДОСТУП С KETER]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	crateWeapon = {},
	command = "synth3",
	max = 2,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(500) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" end,
})

TEAM_SYNTH4 = rp.addTeam("ZEN", {
	color = Color(28, 80, 175, 200),
	model = { "models/player/cmb_synth_soldier_pm.mdl" },
	type = TEAMTYPE_SUP,
	description = [[ДОСТУП С AFINA]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	crateWeapon = {},
	command = "synth4",
	max = 1,
	needbuy = true,
	mask_group = 1,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(550) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" end,
})

TEAM_SYNTH5 = rp.addTeam("CREMATOR", {
	color = Color(28, 80, 175, 200),
	model = { "models/player/cremator_player.mdl" },
	type = TEAMTYPE_SUP,
	description = [[ДОСТУП С THAMIEL]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	crateWeapon = {},
	command = "synth5",
	max = 2,
	needbuy = true,
	mask_group = 1,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(600) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "thaumiel" end,
})

TEAM_SYNTH6 = rp.addTeam("TRU", {
	color = Color(28, 80, 175, 200),
	model = { "models/player/cmb_synth_elite_pm.mdl" },
	type = TEAMTYPE_SUP,
	description = [[ДОСТУП С APOLLO]],
	weapons = {},
	radio = "cpu",
	flashlight = true,
	crateWeapon = {},
	command = "synth6",
	max = 1,
	needbuy = true,
	mask_group = 1,
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(650) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" end,
})

TEAM_CITIZEN1 = rp.addTeam("Авторитетный Гражданин", {
	color = Color(178, 35, 35),
	model = loyal_models,
	description = [[]],
	weapons = {"id_loyal_l1"},
	type = TEAMTYPE_LOYAL,
	command = "citizen2",
	max = 5,
	needbuy = true,
	PlayerLoadout = function(ply)
		ply:SetSkin(1)
		ply:SetBodygroup(2, 0)
		ply:SetBodygroup(3, 0)
		local bodys = ply:GetBodyGroups()
		ply:SetBodygroup( 4, ply:LastBodygroup(4) )
		ply:SetBodygroup( 5, ply:LastBodygroup(5) )
		ply:SetBodygroup( 6, ply:LastBodygroup(6) )
		ply:SetBodygroup( 7, ply:LastBodygroup(7) )
		ply:SetBodygroup(8, 0)
	end,
})

TEAM_CITIZEN2 = rp.addTeam("Элитный Гражданин", {
	color = Color(178, 35, 35),
	model = loyal_models,
	description = [[]],
	weapons = {"stunstick", "id_loyal_l2"},
	command = "citizen3",
	max = 3,
	needbuy = true,
	needteam = 'citizen2',
	type = TEAMTYPE_LOYAL,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 0)
		ply:SetBodygroup(2, 0)
		ply:SetBodygroup(3, 0)
		local bodys = ply:GetBodyGroups()
		ply:SetBodygroup( 4, ply:LastBodygroup(4) )
		ply:SetBodygroup( 5, ply:LastBodygroup(5) )
		ply:SetBodygroup( 6, ply:LastBodygroup(6) )
		ply:SetBodygroup( 7, ply:LastBodygroup(7) )
		ply:SetBodygroup(8, 0)
	end,
})

TEAM_CITIZEN3 = rp.addTeam("Референт Администрации", {
	color = Color(178, 35, 35),
	model = loyal_models,
	type = TEAMTYPE_LOYAL,
	description = [[]],
	weapons = {"stunstick", "swb_usp", "id_loyal_l3"},
	command = "citizen4",
	max = 2,
	needbuy = true,
	needteam = 'citizen3',
	PlayerLoadout = function(ply)
		ply:SetSkin(2)
		ply:SetBodygroup(2, 0)
		ply:SetBodygroup(3, 0)
		local bodys = ply:GetBodyGroups()
		ply:SetBodygroup( 4, ply:LastBodygroup(4) )
		ply:SetBodygroup( 5, ply:LastBodygroup(5) )
		ply:SetBodygroup( 6, ply:LastBodygroup(6) )
		ply:SetBodygroup( 7, ply:LastBodygroup(7) )
		ply:SetBodygroup(8, 0)
	end,
})

TEAM_CITIZEN4 = rp.addTeam("Администратор Сити 18", {
	color = Color(178, 35, 35),
	model = "models/player/scifi_bill.mdl",
	type = TEAMTYPE_COMBINE,
	description = [[Управляет городом и проводит трансляции связанные с пропагандой из здания администрации Сити 18]],
	weapons = {"stunstick", "swb_usp"},
	command = "citizen5",
	needteam = 'citizen4',
	max = 1,
	radio = "cpu",
	mask_group = 1,
	needbuy = true,

})
-- TEAM_COMBINE3 = rp.addTeam('I3', {
-- 	color = Color(150,170,200),
-- 	model = cp_models,
-- 	description = [[
-- Очередной даун под номером 3
-- Очередной даун под номером 3
-- Очередной даун под номером 3
-- Очередной даун под номером 3
--     ]],
-- 	weapons = {},
--     type = TEAMTYPE_COMBINE,
-- 	command = 'combine3',
-- 	max = 0,
-- 	salary = 45,
-- 	admin = 0,
--     needbuy = true,
-- 	hasLicense = false,
-- 	candemote = false,
--
-- })
-- TEAM_COMBINE4 = rp.addTeam('I4', {
-- 	color = Color(150,170,200),
-- 	model = cp_models,
-- 	description = [[
-- Очередной даун под номером 4
-- Очередной даун под номером 4
-- Очередной даун под номером 4
-- Очередной даун под номером 4
-- Очередной даун под ном��ром 4
-- Очередной даун под номером 4
-- Очередной даун под номером 4
-- Очередной даун под номером 4
--     ]],
-- 	weapons = {},
--     type = TEAMTYPE_COMBINE,
-- 	command = 'combine4',
-- 	max = 0,
-- 	salary = 45,
-- 	admin = 0,
--     needbuy = true,
-- 	hasLicense = false,
-- 	candemote = false,
--
-- })

TEAM_CWUWORK1 = rp.addTeam("ГСР Рабочий Завода", {
	color = Color(0, 156, 204),
	type = TEAMTYPE_CWU,
	model = ind_models,
	description = [[]],
	weapons = {"id_cwu",'mgs_pickaxe'},
	command = "cwuvort2",
	max = 4,
	needbuy = true,
})

TEAM_CWUVORT2 = rp.addTeam("ГСР Рабочий Вортигонт", {
	color = Color(0, 156, 204),
	type = TEAMTYPE_CWU,
	model = "models/player/bms_vortigaunt.mdl",
	description = [[]],
	weapons = {"id_cwu",'swm_chopping_axe'},
	command = "cwuvort1",
	max = 4,
	needbuy = true,
})


TEAM_STALKER = rp.addTeam('Сталкер', {
	color = Color(102,153,102),
	model = "models/stalker_player/stalker_player.mdl",
	description = [[ ]],
	weapons = {},
	type = TEAMTYPE_CITIZEN,
	command = 'stalker',
	max = 0,
	salary = 0,
	admin = 0,
	hasLicense = false,
	candemote = false
})
local mario_desc = [[Марио Роджерс родился в США, штат Теннеси, всю свою юность провел в бедном районе города Франклин, его семье всегда не хватало денег поэтому уже с раннего возраста начал вести криминальный обр��з жизни. Уже в подростковом возрасте задумался о дальнейшей жизни и внезапно прекратил свою криминальную деятельность, вследствии чего был выгнан из дома за “неуважение” к семье. Из-за продолжительного скитания по улицам и игнорирования его существования людьми снова начал воровать, в итоге был арестован за многочисленные кражи со взломом. После освобождения переехал в самый безопасный, по статистике, штат Мэн, но не успев начать мирную жизнь началась Семичасовая война и ему пришлось бежать в канализации, где он предпочел стать преступником.]]
TEAM_HERO1 = rp.addTeam("Марио", {
	color = Color(234, 32, 39, 200),
	model = "models/tnb/citizens/male_67.mdl",
	type = TEAMTYPE_CITIZEN,
	description = mario_desc,
	weapons = {"swb_ak47", "lockpick", "swb_knife", "takemoney"},
	command = "mario",
	max = 1,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(200) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "euclid" or  ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная проф��ссия доступна только с Евклид!",
	})
local eva_desc = [[Ева Борджер - корреспондент канадского отделения BBC. Ева прославилась своими критическими статьями об ущемлении индейского населения страны. Она, рискуя своим положением, рассказывала людям правду, не боясь оскорбить какого-нибудь влиятельного чиновника или бизнесмена.
Во время начала Семичасовой войны девушка работала на востоке страны на границе с США, собирая информацию о китобоях, чьей деятельн��сти мешали нефтяные платформы крупного топливного монополиста. После начала воздушной тревоги она двинулась к эпицентр�� событий, пытаясь запечатлеть бомбардировку и десант оккупантов на взятую с собой камеру. Не бросая аппаратуру, Ева перемещалась по зоне боевых действий до тех пор, пока сопротивление не стихло. Только тогда она присоединилась к очередному конвою беженцев, двигающегося в сторону Огасты.
Поскольку всевозможное проявление свободомыслия при Новом Режиме каралось смертью, Ева, не желая подстраиваться под новые условия, стала скрываться от властей и всячески мешать их деятельности, кооперируясь с различными группами находившихся вне закона граждан.]]
TEAM_HERO2 = rp.addTeam("Ева", {
	color = Color(155, 89, 182, 200),
	model = "models/tnb/citizens/female_15.mdl",
	description = eva_desc,
	weapons = {"swb_mp5", "lockpick", "swb_knife"},
	command = "eva",
	type = TEAMTYPE_CITIZEN,
	max = 1,
	radio = "rebel",
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(300) end,
	needbuy = true,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "euclid" or  ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Евклид!",
})
local oneeye_desc = [[Одноглазый - неизвестный наемник, по некоторой информации, ранее служивший в 16-м пехотном полке 7-го корпуса армии США. После расформирования 7-го корпуса подался на работу в американскую ЧВК MPRI. Является ветераном войны в Персидском заливе, так-же в середине 1990-х годов в ходе гражданской войны в Югославии в составе вышеупомянутой ЧВК, занимался подготовкой хорватской армии и 5-го корпуса армии Бос��ии и Герцего��ины. В 1999 году в составе той же ЧВК MPRI по контракту прибыл в Колумбию  для работы с военными в период войн�� с наркотиками. Однако, к 2000 году, после прогремевшего на весь мир инцидента в “Чёрной Мезе”, и начавшимся по всему миру беспорядочными портальными штормами, бежал из Колумбии обратно в США. Прибыв в Нью-Йорк, вступил в мест��ое ополчение, которое помимо охраны периметра города, занималось рейдами загород, в поисках выживших людей и припасов. Во время начавшейся 7-часовой войны против Земли, наемник бежал в Канаду. Но, поняв что силы инопланетных интервентов повсюду, транзитом через Канадскую провинцию Квебек, в обход одноименной столицы, прибыл в штат Мэн, где осел среди групп беженцев из крупных городов. За 4 года до начала основных событий, с подачи Неизвестного, начал осуществлять д��ятельность наемного убийцы, принимая заказы как на жителей запретных секторов, так и на жителей City 16. Кличку “Одноглазого” получил за отсутствия левого глаза. Историю о потере своего глаза, наемник предпочитает не рассказывать.]]
TEAM_HERO3 = rp.addTeam("Одноглазый", {
	color = Color(41, 128, 185, 200),
	model = "models/tnb/citizens/male_29.mdl",
	description = oneeye_desc,
	weapons = {"swb_deagle"},
	command = "oneeye",
	max = 1,
	type = TEAMTYPE_CITIZEN,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 8)
		ply:SetBodygroup(2, 5)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 3)
		ply:SetSkin(0)
	end,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(200) ply:SetArmor(200) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "euclid" or  ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Евклид!",
})
local blueeyes_desc = [[Андроид, разработанный в Amaria Industries - Крупной довоенной корпорации, занимавшаяся разработкой оружия, бытовой техники, фармацевтической продукцией и прочих предметов широкого потребления и не только. Штаб-квартира корпорации располагается в городе Токио, Япония, ныне известном как Сити-8. Мощные связи этой организации в довоенном мире позволили ей выжить при установлении режима Альянса и, в конечном итоге стать одним из крупнейших производителей военной техники Альянса на Земле. Помимо этого, Амария также является разработчиком хим. добавок включаемы�� в рац��оны простых граждан и питательных масел, используемых для питания солдат ОТА. Хотя Амарии и позволили остаться, ее положение в эпоху Альянса шатко как никогда.
Данный андроид является диверсантом и разведчиком, созданным для проникновение в человеческие общества, преимущественно в  группы Сопротивления, и лоялистов, благодаря специальному пластику и технологиям голографической маскировки, может быть замаскирован под человека. Центральный процессор андроида сделан по принципу искусственной нейронной сети. Процессор  функционирует в расширенном режиме (с возможностью обучения).
Однако во время одного из многочисленного полевого теста, у андроида случилась критическая ошибка в протоколе самообучения, благодаря которому, он смог сбежать с полигона Альянса. Поиски беглого робота в лесах, пустынях и городах бывшей Японии к никчему не привели, а в это время андроид уже был далеко от того места где его создали.]]
TEAM_HERO4 = rp.addTeam("Синеглазый", {
	color = Color(112, 161, 200, 200),
	model = "models/tnb/citizens/male_19.mdl",
	description = blueeyes_desc,
	weapons = {"swb_tmp", "swb_usp"},
	command = "blueeyes",
	max = 1,
	type = TEAMTYPE_RABEL,
	radio = "rebel",
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 12)
		ply:SetBodygroup(2, 4)
		ply:SetBodygroup(3, 0)
		ply:SetBodygroup(4, 0)
		ply:SetSkin(0)
	end,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(250) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Кетер!",
})
local major_desc = [[Майор Уильям Овербек - ветеран войны в Персидском заливе, отслужил в 3-м батальоне специальных во��ск 7-го корпуса армии США с 1981 по 1992. После войны, и расформирования 7-го корпуса поселился в штате Массачусетс.
Во время начала портальных штормов, возглавил полицию, и небольшое ополчение граждан, для защиты города от новоприбывших гостей из Зена. Позже, принял беженцев из Британии, которые прибыли на заржавевшим грузовом пароме, и даже смог познакомится с одним из них - с Лейем МакТавишем.
После того, как региональный штаб потерял связь с ячейкой сопротивления в Сити-16, ставка приняло решение послать на выяснение Майора Овербека и 1-го сержанта Лейя. После прибытия в сектор, было уже ясно что местная ячейка была уничтожена, а горстка выживших повстанцев пустилась во все тяжки. Теперь, когда у местной ячейки появился новый командир, Майору придется не просто возродить из пепла ячейку, но и ско��рдинировать выживших повстанцев и привлечь новых людей , и сделать то, чего не смогли его менее успешные преемники - уничтожить Нексус Надзора.]]
TEAM_HERO5 = rp.addTeam("Майор Овербек", {
	color = Color(0, 148, 50, 200),
	model = "models/tnb/citizens/male_75.mdl",
	description = major_desc,
	weapons = {"swb_m4a1"},
	command = "major",
	max = 1,
	type = TEAMTYPE_RABEL,
	radio = "rebel",
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 15)
		ply:SetBodygroup(2, 4)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 3)
		ply:SetSkin(0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(250) ply:SetArmor(250) end,
	needbuy = true,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Кетер!",
})
local mac_desc = [[Сержант МакТавиш начал службу в 22-м полку SAS в 1997-м, на базе в Креденхилле. Прежде ч����м ста��ь бойцом SAS, Лей ранее прослужил 4 года в 2-м батальоне Королевского английского полка 7-й пехотной бригады Британской армии. Служба Лея в 22-м полку представляла собой отрабатывание различных методик стрель��ы и ближнего боя.
Во время начала портальных штормов, бежал из Британии на одном из грузовых паромов, державший курс США, штат Массачусетс. Там-же познакомился с Уильямом Овербеком.
После того, как региональный штаб потерял связь с ячейкой сопротивления в Сити-16, ставка приняло решение послать на выяснение Майора Овербека и Штаб-сержанта сержанта Лейя. После прибытия в сектор, было уже ясно что местная ячейка была уничтожена, а горстка выживших повстанцев пустилась во все тяжки. Теперь, когда у местной ячейки появился новый командир, Сержанту придется возглавить сброд из вчерашних бр��дяг, но и организовать людей, превратив их из толпы в бойцов Сопротивления, и сделать то, ради чего его сюда послали вместе с Майором - уничтожить Нексус Надзора.]]
TEAM_HERO6 = rp.addTeam("Штаб-сержант МакТавиш", {
	color = Color(211, 84, 0, 200),
	model = "models/tnb/citizens/male_24.mdl",
	description = mac_desc,
	weapons = {"swb_m3super90"},
	command = "mactavish",
	max = 1,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 13)
		ply:SetBodygroup(2, 5)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 3)
		ply:SetSkin(0)
	end,
	type = TEAMTYPE_RABEL,
	radio = "rebel",
	PlayerSpawn = function(ply) ply:SetHealth(300) ply:SetArmor(300) end,
	needbuy = true,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Афина!",
})
local maria_desc = [[Мария Беккер - молодая девушка родом из Лос-Анджелеса. Огромное состояние и неблагораз��мие её родителей привели к распутному образу жизни Марии. Учась ещё в средней школе, она стала заводилой на всевозможных алкогольных вечеринках золотой молодёжи города - ни одно событие, связанное с мажорными детишками, не обходилось без неё. Подобное времяпрепровождение, несомненно, негативно сказалось на учебной успеваемости девушки, однако весь разврат, захлестнувший её жизнь, впоследствии заставил её измениться… Во время очередной тусовки парень Марии (к слову, он был у неё уже пятым по счёту) употребил какую-то дрянь, от которой его состояние сильно ухудшилось. Потоки отвратительной рвоты, льющейся изо рта подростка, бьющегося в конвульсиях, перепугали всех окружающих. Тусовщики бросились бежать, только одна Мария осталась с умирающим - она просто застыла от шока…
Глупые д��ти, ко��орых позже допрашивали полицейские, обвинили во всём свою подругу, Марию. Хотя медицинская экспертиза и опровергла её причастность к прои��ошедшему, отношения со сверстниками у молодой девушки были испорчены.
Остаток школьной жизни ей пришлось провести в одиночестве.
Мария переосмыслила всё происходившее с ней за последние годы - она ударилась в химию с биологией, поняла, что должна предотвращать нелепые смерти, подобные той, случившейся пару лет назад…
Родители оплатили девушке обучение в престижном медицинском университете на севере страны. Мария стала усердно заниматься преподаваемыми дисциплинами, она мечтала об успешной карьере в здравоохранительной сфере, однако этому было не суждено сбыться - началась семичасовая война.]]
TEAM_HERO7 = rp.addTeam("Мария", {
	color = Color(255, 195, 18, 200),
	model = "models/tnb/citizens/female_53.mdl",
	description = maria_desc,
	weapons = {"swb_mp5", "swb_mac10", "med_kit"},
	command = "maria",
	max = 1,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 15)
		ply:SetBodygroup(2, 1)
		ply:SetBodygroup(3, 1)
		ply:SetBodygroup(4, 3)
		ply:SetSkin(0)
	end,
	needbuy = true,
	type = TEAMTYPE_RABEL,
	radio = "rebel",
	PlayerSpawn = function(ply) ply:SetHealth(350) ply:SetArmor(350) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "euclid" or  ply:GetNWString("serverguard_rank") == "keter" or ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Евклида!",
})
local unkn_desc = [[Доподлинно, ничего неизвестно об этом контрабандисте, кроме того что он носит противогаз с тонированными линзами и  дорогое довоенное пальто. Откуда он пришел, кто он такой, и какие цели он преследует - до сих пор остается загадкой. Загадкой остается и вопрос, откуда он берет оружие, которое он так свобод��о прод��ет всякому сброду вроде рейдеров в запретном районе. Ходили слухи, что оружие он берет с секретных складов Армии США, однако, так называемые “экспедиции”  - группы организованных беженцев, рейдеров  или пов��танцев так и ничего не смогли найти.
Так-же, ползет слух, что он как-то причастен к уничтожению ячейки сопротивления в Сити-16, однако это как было, так и останется на уровне домыслов.]]
TEAM_HERO8 = rp.addTeam("Неизвестный", {
	color = Color(52, 73, 94, 200),
	model = "models/tnb/citizens/male_miller.mdl",
	description = unkn_desc,
	weapons = {"swb_ar2"},
	command = "unknown",
	max = 1,
	needbuy = true,
	type = TEAMTYPE_CITIZEN,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 0)
		ply:SetBodygroup(2, 0)
		ply:SetBodygroup(3, 0)
		ply:SetBodygroup(4, 0)
		ply:SetSkin(0)
	end,
	PlayerSpawn = function(ply) ply:SetHealth(350) ply:SetArmor(350) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "afina" or ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Афина!",
})
local drake_desc = [[Нейтан Дрейк - опытный охотник за сокровищами, готовый “всадить пулю в лоб” любому, кто встанет на его пути. Мать Нейтана рано умерла, отец отказался от него. Воспитанием Дрейка занимался его старший брат Сэм, замеченный в преступной деятельности. Он же и соблазнил Нейта сбежать из христианского приюта, где тот был вынужден содержаться.
Братья всё сознательное детство занимались криминалом, и поэтому, когда они узнали о том, кто выкупил все вещи их покойной матери, занимавшейся изучением истории и оставившей после себя много ценного, не долго раздумывая проникли в чужой дом. Именно тогда Нейт и Сэм, найдя дневник матери, узнали, что она была не унылым историком-ар��ивист��м, а самым настоящим авантюристом, ищущим древние затерянные сокровища.
Братья продолжили дело покойной родительницы. Послужной список их специфической деятельности крайне велик, они жили этим делом. И даже после событий семичасовой войны, ��есмотря на необходимость разделиться на время, авантюристы продолжают поиск сокровищ.
Нейт, переходя из одной подпольной группировки в другую, добрался до штата Мэн, где по его данным находится человек, имеющий информацию о редчайшем кладе, который совсем недавно был найден Альянсом и сохранен в качестве диковинной реликвии.
(ДОСТУП С AFINA)]]
TEAM_HERO9 = rp.addTeam("Дрейк", {
	color = Color(18, 203, 196, 200),
	model = "models/tnb/citizens/male_88.mdl",
	description = drake_desc,
	weapons = {"swb_galil", "lockpick"},
	command = "drake",
	max = 1,
	type = TEAMTYPE_CITIZEN,
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(400) ply:SetArmor(400) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Таумиель!",
})
local valeria_desc = [[Валерия Лев��льд - молодая девушка, выросшая в семье пожарников. Она пошла по стопам отца, отучившись в школе со спортивным уклоном, пройдя подготовительные курсы по оказанию первой помощи и заступив на службу в пожарный департамент города Огаста, штат Мэн, США. Девушка хорошо проявила себя в первые месяцы работы: она быстро научилась преодолевать горящие препятствия, проникать в задымленные помещения через узкие проемы, выносить на себе людей, пострадавших от ожогов. Валерия всегда была готова столкнуться с опасностью лицом к лицу, за что её называли самой храброй ��евушк��й горо��а.
Во время начала Семичасовой войны девушка находилась на службе. Она с коллегами в срочном порядке была вызвана для тушения пожара в городской больнице после завершения бомбардировки Альянса. Саперная служба была занята, в связи с чем пожарным пришлось действовать вслепую. Во время обхода хирургического отделения (ДОСТУП С THAUMIEL)]]
TEAM_HERO10 = rp.addTeam("Валерия", {
	color = Color(255, 71, 87, 200),
	model = "models/tnb/citizens/female_28.mdl",
	description = valeria_desc,
	weapons = {"swb_mp5", "swb_usp"},
	command = "valeria",
	max = 1,
	type = TEAMTYPE_RABEL,
	radio = "rebel",
	needbuy = true,
	PlayerSpawn = function(ply) ply:SetHealth(450) ply:SetArmor(450) end,
	customCheck = function(ply) return ply:GetNWString("serverguard_rank") == "apollo" or ply:GetNWString("serverguard_rank") == "thaumiel" or ply:GetNWString("serverguard_rank") == "founder" or ply:GetNWString("serverguard_rank") == "serverstaff" or ply:GetNWString("serverguard_rank") == "moderator" end,
	CustomCheckFailMsg = "Данная профессия доступна только с Таумиель!",
})

TEAM_TRADE = rp.addTeam("Торговец", {
	color = Color(57, 112, 50),
	model = nil,
	type = TEAMTYPE_CITIZEN,
	description = [[]],
	weapons = {"id_citizen"},
	command = "trade",
	max = 2,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 1)
	end,
	needbuy = true,
})

TEAM_METH = rp.addTeam("Варщик Мета", {
	color = Color(57, 112, 50),
	model = nil,
	type = TEAMTYPE_CITIZEN,
	description = [[]],
	weapons = {"id_citizen"},
	command = "meth23",
	max = 3,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 1)
	end,
	needbuy = true,
})

TEAM_VORT = rp.addTeam("Свободный Вортигонт", {
	color = Color(57, 112, 50),
	model = vort_models,
	type = TEAMTYPE_CITIZEN,
	description = [[]],
	weapons = {"swep_vortigaunt_beam", "id_vortigaunt"},
	command = "vort2",
	max = 4,
	needbuy = true,
})

TEAM_CITYWORKER = rp.addTeam("ГСР Рабочий", {
	color = Color(0, 156, 204),
	model = nil,
	type = TEAMTYPE_CWU,
	description = [[]],
	weapons = {"id_cwu", "cityworker_pliers", "cityworker_shovel", "cityworker_wrench", "weapon_wrench"},
	command = "cwu1",
	max = 5,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 2)
		ply:SetBodygroup(2, 4)
	end,
	needbuy = true,
})

TEAM_CWU1 = rp.addTeam("ГСР Повар", {
	color = Color(0, 156, 204),
	model = nil,
	type = TEAMTYPE_CWU,
	description = [[]],
	weapons = {"id_cwu"},
	command = "cwu2",
	cook = true,
	max = 4,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 2)
		ply:SetBodygroup(2, 4)
	end,
	needbuy = true,
})

-- TEAM_CWU2 = rp.addTeam("ГСР Продавец", {
-- 	color = Color(0, 156, 204),
-- 	model = nil,
-- 	type = TYPE_CWU,
-- 	description = [[
-- Альянс отнял у людей многое. Свободу, развлечения, нормальную жизнь. Человечество в упадке. Даже не гитаре сыграть не дадут! Но ведь Сити 17 повезло с вами? Ведь вы бывший складской рабочий! Используя свои таланты, а также смекалку, организуйте продажу разных предметов Гражданским Лицам!
-- Разрешено:
-- - Выполнять предоставляемую Альянсом работу.
-- - Залезать на крыши, мосты, фонари и прочие сооружения для выполнения своей работы.
-- - Во время рабочей фазы продолжать выполнять свою стандартную работу.
-- - Во время рабочей фазы помогать сотрудникам ГО с выдачей и реализацией работы для гражданских.
-- Запрещено:
-- - Работать во время КК.
-- - Находиться на улице во время КК.
-- - Сотрудничать с Сопротивлением.
-- - Сотрудничать с Преступным миро��.
-- - Нахо��иться в Некс��с-Центре.
-- ]],
-- 	weapons = {"id_cwu"},
-- 	command = "cwu3",
-- 	max = 4,
-- 	PlayerLoadout = function(ply)
-- 		ply:SetBodygroup(1, 2)
-- 		ply:SetBodygroup(2, 4)
-- 	end,
-- })

TEAM_CWU3 = rp.addTeam("ГСР Уборщик", {
	color = Color(0, 156, 204),
	type = TEAMTYPE_CWU,
	model = nil,
	description = [[]],
	weapons = {"id_cwu"},
	command = "cwu4",
	max = 6,
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 2)
		ply:SetBodygroup(2, 4)
	end,
	needbuy = true,
})

TEAM_CWU4 = rp.addTeam("Надзиратель", {
	color = Color(0, 156, 204),
	type = TEAMTYPE_COMBINE,
	model = "models/tnb/combine/metrocop.mdl",
	description = [[Специальный юнит отдела гражданской обороны СИТИ 18 следящий за сотрудниками ГСР]],
	weapons = {"id_cwu", "stun_baton", "swb_pistol"},
	command = "cwu5",
	max = 2,
	mask_group = 1,
	mask_type = 'metropolice_white',
	PlayerLoadout = function(ply)
		ply:SetBodygroup(1, 5)
	end,
	needbuy = true,
})

local TEAM_ADMIN = TEAM_ADMIN or 666
-- Door Groups
rp.AddDoorGroup('', TEAM_ADMIN)
local cps = {}
for t, job in pairs(rp.teams) do
	if rp.cfg.TypesCanCP[job.type] or job.police then
		table.insert(cps, t)
	end
end
-- loadstring('print(1)')
-- PrintTable(cps)
rp.AddDoorGroup('Гражданская Оборона', cps)
-- -- Agenda
-- rp.AddAgenda('Mob Agenda', TEAM_MOBBOSS, {TEAM_GANGSTER})
-- rp.AddAgenda('Police Agenda', TEAM_CHIEF, {TEAM_SWAT, TEAM_SWATLEAD, TEAM_POLICE})
-- rp.AddAgenda('Hobo Agenda', TEAM_HOBOKING, {TEAM_HOBO})
-- rp.AddAgenda('Hoe Agenda', TEAM_PIMP, {TEAM_WHORE})
-- -- Group Chat
-- rp.addGroupChat(TEAM_MOBBOSS, TEAM_GANGSTER)
-- rp.addGroupChat(TEAM_CHIEF, TEAM_POLICE, TEAM_MAYOR, TEAM_SWAT, TEAM_SWATLEAD)
-- rp.addGroupChat(TEAM_HOBOKING, TEAM_HOBO)
-- rp.addGroupChat(TEAM_PIMP, TEAM_WHORE)
-- Deault Team
rp.DefaultTeam = TEAM_CITIZEN
-- Hit system
rp.HitmanTeam = TEAM_HITMAN
-- Police classes
-- rp.CivilProtection = {
-- 	[TEAM_CHIEF] = true,
-- 	[TEAM_POLICE] = true,
-- 	[TEAM_SWAT] = true,
-- 	[TEAM_SWATLEAD] = true,
-- 	[TEAM_MAYOR] = true
--  }
-- Mayor
-- rp.MayorTeam = TEAM_MAYOR
-- Gov classes
-- rp.Government = {
-- 	[TEAM_MAYOR] = true,
-- }
-- for k, v in pairs(cps) do
--     cps[v] = 1000,
-- end

rp.cfg.NPCs = {
	['rp_c18_updated'] = {
		['reg_npc'] = {
            title = 'Регистрация в Сити 18',
			color = Color(255,255,255,255),
			pos = Vector('677.613220 -2817.400635 722.031250'),
			Ang = Angle('4.898315 -0.029352 0.000000'),
			model = 'models/Police.mdl',
			ang = Angle('0 -90 0'),
			jobs = {
				[TEAM_CITIZEN24] = 0,
			}
		},
		['crime_npc'] = {
            title = 'Криминальный Авторитет',
			color = Color(255,255,255,255),
			pos = Vector('-499.215698 3823.459473 910.031250'),
			Ang = Angle('4.562819 -126.236130 0.000000'),
			model = 'models/Eli.mdl',
			jobs = {
				[TEAM_CRIME] = 10000,
				[TEAM_TRADE] = 15000,
				[TEAM_METH] = 25000,
				[TEAM_CRIME2] = 55000,
				[TEAM_CRIME3] = 85000,
				[TEAM_CRIMES] = 100000,
				[TEAM_HITMAN] = 150000,
			}
		},
		['cwu_npc'] = {
            title = 'ГСР',
			color = Color(255,255,255,255),
			pos = Vector('4900.031250 700.009216 1010.031250'),
			Ang = Angle('1.677497 179.471313 0.000000'),
			model = 'models/Humans/Group02/Female_03.mdl',
			jobs = {
				[TEAM_CITYWORKER] = 4000,
				[TEAM_CWUWORK1] = 8000,
				[TEAM_CWUVORT2] = 13000,
				[TEAM_CWU1] = 15000,
				-- [TEAM_CWU2] = 10000,
				[TEAM_CWU3] = 25000,
				[TEAM_CWU4] = 50000,
			}
		},
		['loyal_npc'] = {
            title = 'Центр Лояльности',
			color = Color(255,255,255,255),
			pos = Vector('-711.189819 -1263.968750 706.031250'),
			Ang = Angle('6.240301 -88.065125 0.000000'),
			model = 'models/mossman.mdl',
			jobs = {
				[TEAM_CITIZEN1] = 50000,
				[TEAM_CITIZEN2] = 100000,
				[TEAM_CITIZEN3] = 150000,
				[TEAM_CITIZEN4] = 250000,
			}
		},
		['rebel_npc'] = {
            title = 'Повстанческое Движение',
			color = Color(255,255,255,255),
			pos = Vector('997.177368 4563.531738 636.031250'),
			Ang = Angle('3.220815 -122.613106 0.000000'),
			model = 'models/Humans/Group03/male_06.mdl',
			jobs = {
				[TEAM_R1] = 1500,
				[TEAM_R2] = 8000,
				[TEAM_R3] = 25000,
				[TEAM_R4] = 45000,
				[TEAM_R8] = 15000,
				[TEAM_R5] = 80000,
				[TEAM_R6] = 125000,
				[TEAM_R7] = 200000,
				[TEAM_VORT] = 50000
			}
		},
		 ['synth_npc'] = {
             title = 'Синтетический Отдел',
			 color = Color(255,255,255,255),
			pos = Vector('1660.671997 158.998627 1476.031250'),
			ang = Angle('0.092631 89.959465 0.000000'),
			model = 'models/Combine_Super_Soldier.mdl',
			jobs = {
				[TEAM_SYNTH1] = 50000,
				[TEAM_SYNTH2] = 80000,
				[TEAM_SYNTH3] = 100000,
				[TEAM_SYNTH4] = 150000,
				[TEAM_SYNTH5] = 200000,
				[TEAM_SYNTH6] = 250000,
			}
		},
		['cpu_npc'] = {
            title = 'CPU.RCT.3322',
			color = Color(255,255,255,255),
			pos = Vector('2493.968750 689.537109 962.031250'),
			ang = Angle('1.367537 0.842179 0.000000'),
			model = 'models/Police.mdl',
			jobs = {
				[TEAM_UN1] = 2500,
				[TEAM_UN2] = 10000,
				[TEAM_UN3] = 20000,
				[TEAM_UN4] = 40000,
				[TEAM_UN5] = 70000,
				[TEAM_UN6] = 100000,
				[TEAM_UN7] = 200000,
				[TEAM_UN8] = 350000
			}
		},
		['scpu_npc'] = {
            title = 'SCPU.SHIELD.3223',
			color = Color(255,255,255,255),
			pos = Vector('1964.102051 399.992615 962.031250'),
			ang = Angle('1.568820 -36.935345 0.000000'),
			model = 'models/Combine_Soldier.mdl',
			jobs = {
				[TEAM_S0] = 8000,
				[TEAM_S1] = 16000,
				[TEAM_S2] = 34000,
				[TEAM_S3] = 50000,
				[TEAM_S4] = 80000,
				[TEAM_S5] = 120000,
				[TEAM_S6] = 120000,
				[TEAM_S7] = 200000,
				[TEAM_S8] = 300000,
				[TEAM_S9] = 350000,
			}
		},
		['sup_npc'] = {
            title = 'SUP.NOVA.2332',
			color = Color(255,255,255,255),
			pos = Vector('2395.893555 584.898804 1476.031250'),
			ang = Angle('2.306914 -88.946381 0.000000'),
			model = 'models/Combine_Super_Soldier.mdl',
			jobs = {
				[TEAM_COMBINE1] = 20000,
				[TEAM_COMBINE2] = 40000,
				[TEAM_COMBINE3] = 60000,
				[TEAM_COMBINE4] = 80000,
				[TEAM_COMBINE5] = 100000,
				[TEAM_COMBINE6] = 160000,
				[TEAM_COMBINE7] = 220000,
				[TEAM_COMBINE8] = 300000,
			}
		},
		['fake_npc'] = {
            title = 'C#U.#5.43#7',
			color = Color(255,255,255,255),
			pos = Vector('1235.167480 4765.824707 636.031250'),
			ang = Angle('3.112095 -165.431976 0.000000'),
			model = 'models/Police.mdl',
			jobs = {
				[TEAM_ALTER] = 40000,
				[TEAM_STATICREBEL] = 100000
			}
		},
		['hero_npc'] = {
            title = 'Барни Калхаун',
			color = Color(255,255,255,255),
			pos = Vector('1053.456177 4116.964844 606.031250'),
			ang = Angle('1.166204 89.489426 0.000000'),
			model = 'models/Barney.mdl',
			jobs = {
				[TEAM_HERO1] = 40000,
				[TEAM_HERO2] = 80000,
				[TEAM_HERO3] = 120000,
				[TEAM_HERO4] = 160000,
				[TEAM_HERO5] = 180000,
				[TEAM_HERO6] = 220000,
				[TEAM_HERO7] = 260000,
				[TEAM_HERO8] = 300000,
				[TEAM_HERO9] = 340000,
				[TEAM_HERO10] = 380000
			}
		}
	}
}
if SERVER then
	local function SpawnNPCs()
		for map, npcs in pairs(rp.cfg.NPCs) do
			if game.GetMap() == map then
				for id, data in pairs(npcs) do
					local ent = ents.Create('npc_jobs')
					ent:Spawn()
					ent:SetPos(data.pos)
					if data.model then
						ent:SetModel(data.model)
					end
					-- ent:DropToFloor()
					ent:SetAngles(data.ang or Angle(0,0,0))

					-- PrintTable(data.jobs)
					ent.jobs = data.jobs
                    ent:SetTitle(data.title)
					-- ent:SetTitleColor(table.ToString(data.title))
				end
			end
		end
	end
	hook.Add( "PostCleanupMap", "SpawnNPCs_PostCleanupMap", SpawnNPCs)
	hook.Add( "InitPostEntity", "SpawnNPCs_InitPostEntity", SpawnNPCs)
end