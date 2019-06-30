TEAMTYPE_CITIZEN = 0
TEAMTYPE_COMBINE = 1
TEAMTYPE_SUP = 2
TEAMTYPE_RABEL = 3
TEAMTYPE_LOYAL = 4
TEAMTYPE_CWU = 5
TEAMTYPE_STALKER = 6
HANDCUFFED_DURATION = 3
UN_HANDCUFFED_DURATION = 3

function PLAYER:IsRabel()
	local job = rp.teams[self:Team()]
	if job and job.type == TEAMTYPE_RABEL then
		return true
	end

	return false
end

function PLAYER:IsLoyal()
	local job = rp.teams[self:Team()]
	if job and job.type == TEAMTYPE_LOYAL then
		return true
	end

	return false
end

rp.cfg.StartMoney 		= 1500
rp.cfg.StartKarma		= 50

rp.cfg.OrgCost 			= 25000

rp.cfg.HungerRate 		= 1200
rp.cfg.ThirstRate       = 1000

rp.cfg.DoorCostMin		= 200
rp.cfg.DoorCostMax 		= 20000
rp.cfg.PropertyTax		= 5

rp.cfg.PropLimit 		= 30

rp.cfg.RagdollDelete	= 60

rp.cfg.ChangeNamePrice	= 3000

-- Speed
rp.cfg.WalkSpeed 		= 100
rp.cfg.RunSpeed 		= 230

-- Printers
rp.cfg.PrintDelay 		= 180
rp.cfg.PrintAmount 		= 1000
rp.cfg.InkCost 			= 200

-- Hits
rp.cfg.HitExpire		= 600
rp.cfg.HitCoolDown 		= 300
rp.cfg.HitMinCost 		= 2000
rp.cfg.HitMaxCost 		= 100000

-- Afk
-- rp.cfg.AfkDemote 		= (60*60)*1
-- rp.cfg.AfkPropRemove 	= (60*60)*3
-- rp.cfg.AfkDoorSell 		= (60*60)*3

-- Lotto
-- rp.cfg.MinLotto 		= 1000
-- rp.cfg.MaxLotto 		= 1000000

rp.cfg.weaponCheckerHideDefault = true
rp.cfg.weaponCheckerHideNoLicense = false
rp.cfg.noStripWeapons = {
	'weapon_physcannon',
	'weapon_physgun',
	'gmod_tool',
	'keys',
	'pocket'
}

rp.cfg.RewardForMurder = {
	[TEAMTYPE_COMBINE] = {
		[TEAMTYPE_RABEL] = 1000,
	}
}

rp.cfg.RationLevels = {
	[TEAMTYPE_CITIZEN] = 'citizen_ration',
	[TEAMTYPE_LOYAL] = 'citizen_ration',
	[TEAMTYPE_COMBINE] = 'citizen_ration',
	[TEAMTYPE_CWU] = 'citizen_ration'
}

-- Combines
rp.cfg.LoyalTypes = {
	[TEAMTYPE_CITIZEN] = { text = 'Средний', col = Color(254,161,3) }, -- Или Color(255,165,0,255)
	[TEAMTYPE_COMBINE] = { text = 'Высокий', col = Color(50,200,50) },
	[TEAMTYPE_RABEL] = { text = 'Низкий', col = Color(204,51,51) },
	[TEAMTYPE_LOYAL] = { text = 'Высокий', col = Color(50,200,50) },
	[TEAMTYPE_COMBINE] = { text = 'Высокий', col = Color(50,200,50) },
}

rp.cfg.TypesCanCP = {
	[TEAMTYPE_SUP] = true,
	[TEAMTYPE_COMBINE] = true
}

-- rp.cfg.CaptureZones = {
-- 	["nexus"] = {
-- 		pos = Vector('1336.793945 8980.597656 536.015259'),
-- 		ang = Angle('-1.450747 -0.670851 0.265785'),
-- 		color = Color( 54,200,200 ),
-- 		name = 'Администрация',
-- 		radius = 400,
-- 	},
-- 	["park"] = {
-- 		pos = Vector('5903.124512 12759.245117 455.031250'),
-- 		ang = Angle('-4.537340 -90.687767 -0.207853'),
-- 		color = Color( 54,200,200 ),
-- 		name = 'Городской Парк C24',
-- 		radius = 600,
-- 	},
-- 	["trade"] = {
-- 		pos = Vector('6542.536621 4395.420410 7.031250'),
-- 		ang = Angle('-2.926968 159.671570 -0.455180'),
-- 		color = Color( 54,200,200 ),
-- 		name = 'Пристань',
-- 		radius = 300,
-- 	},
-- 	["plaza"] = {
-- 		pos = Vector('9720.645508 7778.965332 399.031250'),
-- 		ang = Angle('-1.543279 179.374313 0.499080'),
-- 		color = Color( 54,200,200 ),
-- 		name = 'Площадь',
-- 		radius = 400,
-- 	},
-- }

-- rp.cfg.CpatureTeamCP = {
-- 	TEAM_SYNTH1,
-- 	TEAM_SYNTH2,
-- 	TEAM_SYNTH3,
-- 	TEAM_SYNTH4,
-- 	TEAM_SYNTH5,
-- 	TEAM_UN1,
-- 	TEAM_UN2,
-- 	TEAM_UN3,
-- 	TEAM_UN4,
-- 	TEAM_UN5,
-- 	TEAM_UN6,
-- 	TEAM_UN7,
-- 	TEAM_UN8,
-- 	TEAM_S0,
-- 	TEAM_S1,
-- 	TEAM_S2,
-- 	TEAM_S3,
-- 	TEAM_S4,
-- 	TEAM_S5,
-- 	TEAM_S6,
-- 	TEAM_S7,
-- 	TEAM_S8,
-- 	TEAM_S9,
-- 	TEAM_COMBINE1,
-- 	TEAM_COMBINE2,
-- 	TEAM_COMBINE3,
-- 	TEAM_COMBINE4,
-- 	TEAM_COMBINE5,
-- 	TEAM_COMBINE6,
-- 	TEAM_COMBINE7,
-- 	TEAM_COMBINE8
-- }

-- rp.cfg.CpatureTeamRabel = {
-- 	TEAM_R1,
-- 	TEAM_R2,
-- 	TEAM_R3,
-- 	TEAM_R4,
-- 	TEAM_R5,
-- 	TEAM_R6,
-- 	TEAM_R7,
-- 	TEAM_VORT,
-- 	TEAM_R8
-- }

-- rp.cfg.CpatureTimeReward = 1000
-- rp.cfg.CpatureTimeToReward = 60*10

rp.cfg.controlpoints_icon = {
    ['Shield'] = Material('metaui/captureebalo/cpp.png', 'smooth noclamp'),
    ['Robot'] = Material('meta_ui/genders/robot.png', 'smooth noclamp'),
    ['Falcon'] = Material('meta_ui/metaui/falcon.png', 'smooth noclamp'),
    ['Shield2'] = Material('meta_ui/metaui/metascoreboard/staff.png', 'smooth noclamp'),
    ['User'] = Material('meta_ui/metaui/metascoreboard/user.png', 'smooth noclamp'),
    ['Vip'] = Material('meta_ui/metaui/metascoreboard/vip.png', 'smooth noclamp')
}

CONTROL_COMBINE = 1 -- Прописывать в профах control = CONTROL_COMBINE,
CONTROL_REBEL = 2

rp.cfg.controlpoints_teams = {
    [0] = { color = Color(191,191,191,255), name = 'Никто'},
    [CONTROL_COMBINE] = { color = Color(84,144,181,255), name = 'Альянс'},
    [CONTROL_REBEL] = { color = Color(255,37,37,255), name = 'Повстанческое движение'}
}

rp.cfg.Controls = {
    ['Test 1'] = {
        time = 200,
        radius = 220,
        icon = 'Shield',
        pos = Vector('900.455627 6166.350586 744.031250'),
        ang = Angle('0 -90 0')
    }
}

if SERVER then
	local function SpawnControls()
		for name, ct in pairs(rp.cfg.Controls) do
            local ent = ents.Create('control_point')
            ent:Spawn()
            ent:SetAngles( ct.ang )
            ent:SetPos( ct.pos )
            ent:SetNWString( "Name", name )
            ent:SetNWString( "Icon", 'Shield' )

            ent:SetNWInt( "Occupied", 100 )
            ent:SetNWBool( "CountBuff", true )
            ent:SetNWBool( "CountOccupied", true )
            ent:SetNWBool( "MomentOccupied", false )
            ent:SetNWInt( "Team", 0 )
            ent:SetNWInt( "Time", ct.time )
            ent:SetNWInt( "Radius", ct.radius )
		end
	end
	-- hook.Add( "PostCleanupMap", "SpawnControls_PostCleanupMap", SpawnControls)
	hook.Add( "InitPostEntity", "SpawnControls_InitPostEntity", SpawnControls)
end

rp.cfg.Doors = {
    {
        pos = Vector('2142.937500 -509.437500 595.406250'),
        ang = Angle('0 -180 0'),
        model = 'models/props_combine/combine_door01.mdl'
    },
    {
        pos = Vector('2374.781250 1111.281250 1011.406250'),
        ang = Angle('0 -90 0'),
        model = 'models/props_combine/combine_door01.mdl'
    },
    {
        pos = Vector('1903.781250 1436.562500 1395.406250'),
        ang = Angle('0 0 0'),
        model = 'models/props_combine/combine_door01.mdl'
    }
}

if SERVER then
	local function SpawnDoors()
		for name, d in pairs(rp.cfg.Doors) do
            local ent = ents.Create('prop_dynamic')
            ent:SetModel(d.model)
            ent:SetPos(d.pos)
            ent:SetAngles(d.ang)

            ent:SetKeyValue("solid", "6")
            ent:SetKeyValue("MinAnimTime", "1")
            ent:SetKeyValue("MaxAnimTime", "5")

            ent:Spawn()
            ent:Activate()
		end
	end
	-- hook.Add( "PostCleanupMap", "SpawnDoors_PostCleanupMap", SpawnDoors)
	hook.Add( "InitPostEntity", "SpawnDoors_InitPostEntity", SpawnDoors)
end

rp.cfg.TypesCanCP = {
	[TEAMTYPE_SUP] = true,
	[TEAMTYPE_COMBINE] = true,
}

rp.cfg.CPUpCodes = {
	['Код #404'] = 'Беспорядки на улицах',
	['Код #67'] = 'Ситуация не под контролем',
	['Код #4'] = 'Нужна помощь',
	['Код #7'] = 'Нападение на сотрудника',
	['Код #57'] = 'Ситуация под контролем',
	['Код #89'] = 'Требуется медицинская помощь',
	['Код #89b'] = 'Замечен враг',
	['Код #567'] = 'Замечены выстрелы',
	['Код #77'] = 'Нахожусь под огнём',
	['Код #963'] = 'Вернулся к патрулированию',
	['Код #222'] = 'Веду преследование',
	['Код #58'] = 'Враг уничтожен',
	['Код #f56'] = 'Местоположение',
	['Код #108'] = 'Замечены антигражданские действия',
	['Код #02'] = 'Нужно подкрепление',
	['Код #66'] = 'Сотрудник убит',
	['Код #02'] = 'Запрос о помощи, сотрудник ранен',
	['Код #833'] = 'Труп',
	['Код #0'] = 'Всё чисто, угрозы не обнаружено',
}

rp.cfg.InvLimit = 20

timer.Simple(.1, function()
	rp.cfg.CanBrokenTerminal = { -- С ними будут терминалы ломатся.
		TEAM_CITYWORKER,
		TEAM_S3
	}
	rp.cfg.ChangeTeamForDeath = { -- Первый тем кем надо быть, а второй на что меняет.
		[TEAM_R8] = TEAM_CITIZEN24,
		[TEAM_UN8] = TEAM_CITIZEN24,
		[TEAM_S9] = TEAM_CITIZEN24,
		[TEAM_COMBINE8] = TEAM_CITIZEN24,
		[TEAM_SYNTH6] = TEAM_CITIZEN24,
		[TEAM_CITIZEN3] = TEAM_CITIZEN24,
		[TEAM_CITIZEN4] = TEAM_CITIZEN24,
		[TEAM_HERO2] = TEAM_CITIZEN24,
		[TEAM_HERO8] = TEAM_CITIZEN24,
		[TEAM_ALTER] = TEAM_CITIZEN24,
		[TEAM_STATICREBEL] = TEAM_CITIZEN24,
		[TEAM_ANTICITIZEN] = TEAM_CITIZEN24,

	}

	rp.cfg.TeamSpawns = {
		rp_city17_metahub_v2 = {
			[TEAM_UN1] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN2] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN3] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN4] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN5] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN6] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN7] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_UN8] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S0] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S1] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S2] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S3] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S4] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S5] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_ALTER] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S6] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S7] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S8] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_S9] = { Vector('4138.747070 872.212952 138.031250'), Vector('4133.701660 1083.363281 138.031250'), Vector('4138.596680 1315.873413 138.031250') },
			[TEAM_COMBINE1] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE2] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_STATICREBEL] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE3] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE4] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE5] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE6] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE7] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_COMBINE8] = { Vector('5686.538086 -2049.889648 1674.031250') },
			[TEAM_SYNTH1] = { Vector('4999.836426 3256.924561 1674.031250') },
			[TEAM_SYNTH2] = { Vector('4999.836426 3256.924561 1674.031250') },
			[TEAM_SYNTH3] = { Vector('4999.836426 3256.924561 1674.031250') },
			[TEAM_SYNTH4] = { Vector('4999.836426 3256.924561 1674.031250') },
			[TEAM_SYNTH5] = { Vector('4999.836426 3256.924561 1674.031250') },
			[TEAM_SYNTH6] = { Vector('4999.836426 3256.924561 1674.031250') },
			[TEAM_CITIZEN1] = { Vector('-310.309113 -1257.680908 114.031250') },
			[TEAM_CITIZEN2] = { Vector('-310.309113 -1257.680908 114.031250') },
			[TEAM_CITIZEN3] = { Vector('-310.309113 -1257.680908 114.031250') },
			[TEAM_CITIZEN4] = { Vector('6402.031250 456.956085 3733.161133') },
			[TEAM_STALKER] = { Vector('6243.923828 2831.841797 1131.031250') },
			[TEAM_TRADE] = { Vector('-3657.035645 2672.417725 144.031250') },
			[TEAM_METH] = { Vector('-3657.035645 2672.417725 144.031250') },
			[TEAM_VORT] = { Vector('-3657.035645 2672.417725 144.031250') },
			[TEAM_CITYWORKER] = { Vector('-473.388519 1453.749390 300.031250') },
			[TEAM_CWU1] = { Vector('-473.388519 1453.749390 300.031250') },
			[TEAM_CWU3] = { Vector('-473.388519 1453.749390 300.031250') },
			[TEAM_CWU4] = { Vector('-473.388519 1453.749390 300.031250') },
            [TEAM_CWUMED] = { Vector('-473.388519 1453.749390 300.031250') },
            [TEAM_CWUTRADE] = { Vector('-473.388519 1453.749390 300.031250') },
			[TEAM_R1] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R2] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R3] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R4] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R5] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R6] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R7] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_R8] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO1] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO2] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO3] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO4] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO5] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO6] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO7] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO8] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO9] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			[TEAM_HERO10] = { Vector('954.595703 1044.845825 -1363.968750'), Vector('956.849609 1199.787720 -1363.968750'), Vector('957.870300 1340.682495 -1363.968750') },
			-- [TEAM_METH] = { Vector('947.396179 2444.477539 736.152100') },
			[TEAM_CRIME] = { Vector('-1100.391479 2912.780273 272.965271') },
			[TEAM_CRIME2] = { Vector('-1100.391479 2912.780273 272.965271') },
			[TEAM_CRIME3] = { Vector('-1100.391479 2912.780273 272.965271') },
			[TEAM_CRIMES] = { Vector('-1100.391479 2912.780273 272.965271') },
			[TEAM_HITMAN] = { Vector('-1100.391479 2912.780273 272.965271') },
			[TEAM_CWUWORK1] = { Vector('625.172546 -3554.649658 144.031250') },
			[TEAM_CWUVORT2] = { Vector('625.172546 -3554.649658 144.031250') },
			[TEAM_CITIZEN] = {
				Vector('-4752.786621 -190.964874 112.031250'),
				Vector('-4652.786621 -190.964874 112.031250'),
				Vector('-4552.786621 -190.964874 112.031250'),
				Vector('-4452.786621 -190.964874 112.031250'),
				Vector('-4752.786621 -290.964874 112.031250'),
				Vector('-4652.786621 -290.964874 112.031250'),
				Vector('-4552.786621 -290.964874 112.031250'),
				Vector('-4452.786621 -290.964874 112.031250'),
			},
			[TEAM_CITIZEN24] = { Vector('-1846.059570 -97.825989 208.031250') }
		}
	}

	rp.cfg.SupTeamType = TEAMTYPE_SUP
	rp.cfg.SupCommander = {
		[TEAM_COMBINE6] = true,
		[TEAM_COMBINE8] = true,
		[TEAM_SYNTH6] = true,
	}
	rp.cfg.SupProtocols = {
		[1] = 'СОН', -- Первый дефолдный
		[2] = 'МЕЧ',
		[3] = 'ЩИТ',
		[4] = 'УДАР',
		[5] = 'ДОЛГ',
		[6] = 'НОВА',
		[7] = 'ПОЛНОЧЬ',
		[8] = 'МЯТЕЖ',
		[9] = 'АВТОНОМ',
		[10] = 'СБОР',
		[11] = 'ОПЛОТ',
	}

	rp.cfg.TimerStalker = 600 -- Время на которое дается сталкер
	rp.cfg.CanManageStalker	= { -- Те кто могут выдавать сталкеров
		[TEAM_UN8] = true,
		[TEAM_S8] = true,
		[TEAM_S9] = true,
		[TEAM_COMBINE6] = true,
		[TEAM_COMBINE8] = true,
		[TEAM_SYNTH6] = true,
	}
	rp.cfg.CanManageCode = { -- Те кто могут менять рп код
		[TEAM_UN8] = true,
		[TEAM_S8] = true,
		[TEAM_S9] = true,
		[TEAM_COMBINE6] = true,
		[TEAM_COMBINE8] = true,
		[TEAM_SYNTH6] = true,
		[TEAM_CWU4] = true,
		[TEAM_CITIZEN4] = true,
	}
	rp.cfg.CombineCupboard = {
		[TEAM_UN1] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife"},
		[TEAM_UN2] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife"},
		-- [TEAM_REB3] = {"swb_pistol", "findbadweapons", "stun_baton", "handcuffs", "swb_knife"},
		[TEAM_UN3] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_smg"},
		[TEAM_ALTER] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_smg"},
		[TEAM_UN4] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_smg"},
		[TEAM_UN5] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_smg", "m9k_m61_frag"},
		[TEAM_UN6] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_smg", "m9k_m61_frag"},
		[TEAM_UN7] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_smg", "m9k_m61_frag"},
		[TEAM_UN8]  = {"weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_mp5", "m9k_m61_frag"},
		-- [TEAM_ODMEN] = {"swb_mp5", "findbadweapons", "stun_baton", "handcuffs", "swb_knife"},
		[TEAM_S0] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "ultheal", "ammothreeaura", "med_kit_nn", "swb_mac10", "swb_knife"},
		[TEAM_S1] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "weapon_smallriotshield", "swb_knife"},
		[TEAM_S2] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_m3super90", "swb_knife"},
		[TEAM_S3] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_ump", "swb_knife", "cp_fort", "weapon_wrench",'constructable_turret','repair_tool_evan'},
		[TEAM_S4] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_tmp", "swb_knife", "m9k_m61_frag", "weapon_controllable_manhack"},
		[TEAM_S5] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_awp", "swb_knife", "weapon_controllable_manhack", "hook"},
		[TEAM_S6] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_p90", "weapon_slam", "weapon_rpg", "swb_knife"},
		[TEAM_S7] = {"weaponchecker", "stun_baton", "handcuffs", "swb_glock18", "swb_knife", "swb_scout",'cloaking-3'},
		[TEAM_S8] = {"weaponchecker", "stun_baton", "handcuffs", "swb_glock18", "swb_knife", "swb_xm1014"},
		[TEAM_S9] = {"swb_pistol", "weaponchecker", "stun_baton", "handcuffs", "swb_sg552", "swb_knife", "weapon_controllable_manhack"},
		-- [TEAM_SUP1] = {"swb_357", "findbadweapons",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2"},
		-- [TEAM_SUP2] = {"swb_357", "findbadweapons",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_STATICREBEL] = {"swb_357", "weaponchecker", "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		-- [TEAM_REB7] = {"swb_357", "findbadweapons",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_COMBINE1] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_smg"},
		[TEAM_COMBINE2] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_COMBINE3] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_m3super90"},
		[TEAM_COMBINE4] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_m249", "m9k_m61_frag"},
		[TEAM_COMBINE5] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_sg552"},
		[TEAM_COMBINE6] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "m9k_m61_frag"},
		[TEAM_COMBINE7] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_xm1014", "m9k_m61_frag"},
		[TEAM_COMBINE8] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_SYNTH1] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_SYNTH2] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_SYNTH3] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_SYNTH4] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_SYNTH5] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "weapon_752_m2_flamethrower", "swb_tmp", "m9k_m61_frag"},
		[TEAM_SYNTH6] = {"swb_357", "weaponchecker",  "stun_baton", "handcuffs", "swb_knife", "swb_ar2", "m9k_m61_frag"},
		[TEAM_CWU4] = {"swb_pistol", "weaponchecker",  "stun_baton", "handcuffs"},
	}
	rp.cfg.NickNameRegex = {
		-- [TEAM_COMBINE2] = 'CPU:%s.%s'
		[TEAM_UN1] = 'CPU:%s.%s',
		[TEAM_UN2] = 'CPU:%s.%s',
		[TEAM_UN3] = 'CPU:%s.%s',
		[TEAM_UN4] = 'CPU:%s.%s',
		[TEAM_UN5] = 'CPU:%s.%s',
		[TEAM_UN6] = 'CPU:%s.%s',
		[TEAM_UN7] = 'CPU:%s.%s',
		[TEAM_UN8] = 'CPU:%s.%s',
		[TEAM_ALTER] = 'CPU:%s.%s',
		--
		[TEAM_S0] = 'SCPU:%s.%s',
		[TEAM_S1] = 'SCPU:%s.%s',
		[TEAM_S2] = 'SCPU:%s.%s',
		[TEAM_S3] = 'SCPU:%s.%s',
		[TEAM_S4] = 'SCPU:%s.%s',
		[TEAM_S5] = 'SCPU:%s.%s',
		[TEAM_S6] = 'SCPU:%s.%s',
		[TEAM_S7] = 'SCPU:%s.%s',
		[TEAM_S8] = 'SCPU:%s.%s',
		[TEAM_S9] = 'SCPU:%s.%s',
		--
		[TEAM_COMBINE1] = 'SUP:%s.%s',
		[TEAM_COMBINE2] = 'SUP:%s.%s',
		[TEAM_COMBINE3] = 'SUP:%s.%s',
		[TEAM_COMBINE4] = 'SUP:%s.%s',
		[TEAM_COMBINE5] = 'SUP:%s.%s',
		[TEAM_COMBINE6] = 'SUP:%s.%s',
		[TEAM_COMBINE7] = 'SUP:%s.%s',
		[TEAM_COMBINE8] = 'SUP:%s.%s',
		[TEAM_STATICREBEL] = 'SUP:%s.%s',
		--
		[TEAM_SYNTH1] = 'SYNTH:%s.%s',
		[TEAM_SYNTH2] = 'SYNTH:%s.%s',
		[TEAM_SYNTH3] = 'SYNTH:%s.%s',
		[TEAM_SYNTH4] = 'SYNTH:%s.%s',
		[TEAM_SYNTH5] = 'SYNTH:%s.%s',
		[TEAM_SYNTH6] = 'SYNTH:%s.%s',
		--
		[TEAM_CWU4] = 'ГСР:%s.%s',
	}
	rp.cfg.AliveCodes 		= {
		['red'] = { text = 'Красный код', color = rp.col.Red },
		['yellow'] = { text = 'Желтый код', color = rp.col.Orange },
		['work'] = { text = 'Рабочая фаза', color = rp.col.Blue }
	}
	rp.cfg.Trash = {
		['trash_paper'] = 200,
		['trash_can'] = 300,
		['trash_bottle'] = 200,
		['trash_metal'] = 45,
		['trash_tools'] = 44,
		['trash_carbon'] = 22,
		['trash_lether'] = 23,
		['trash_wood'] = 34,
	}
	rp.cfg.ExtraRationMoney = { -- Зарплата с рационов.
		[TEAM_CITIZEN24] = 350,
		[TEAM_ANTICITIZEN] = 350,
		[TEAM_CRIME] = 250,
		[TEAM_CRIME2] = 300,
		[TEAM_CRIME3] = 350,
		[TEAM_CRIMES] = 450,
		[TEAM_HITMAN] = 450,
		[TEAM_UN1] = 250,
		[TEAM_UN2] = 350,
		[TEAM_UN3] = 450,
		[TEAM_UN4] = 550,
		[TEAM_UN5] = 650,
		[TEAM_UN6] = 750,
		[TEAM_UN7] = 850,
		[TEAM_UN8] = 1000,
		[TEAM_S0] = 250,
		[TEAM_S1] = 350,
		[TEAM_S3] = 450,
		[TEAM_S4] = 550,
		[TEAM_S5] = 650,
		[TEAM_S6] = 750,
		[TEAM_S7] = 850,
		[TEAM_S8] = 950,
		[TEAM_S9] = 1050,
		[TEAM_COMBINE1] = 550,
		-- [TEAM_COMBINE22] = 650,
		[TEAM_COMBINE3] = 750,
		[TEAM_COMBINE4] = 850,
		[TEAM_COMBINE5] = 950,
		[TEAM_COMBINE6] = 1050,
		[TEAM_COMBINE7] = 1150,
		[TEAM_COMBINE2] = 1250,
		[TEAM_SYNTH1] = 650,
		[TEAM_SYNTH2] = 750,
		[TEAM_SYNTH3] = 850,
		[TEAM_SYNTH4] = 950,
		[TEAM_SYNTH5] = 1150,
		[TEAM_CITIZEN1] = 650,
		[TEAM_CITIZEN2] = 850,
		[TEAM_CITIZEN3] = 1150,
		[TEAM_CITYWORKER] = 450,
		[TEAM_CWU1] = 650,
		[TEAM_CWU3] = 850,
		[TEAM_CWU4] = 1500,
        [TEAM_CWUMED] = 650,
        [TEAM_CWUTRADE] = 700,
		[TEAM_TRADE] = 650,
		[TEAM_METH] = 850,
		[TEAM_VORT] = 1050,
	}
end)

rp.cfg.DefaultLaws 		= [[
Запрет на Неадекватное поведение
Запрет на Быстрый бег, оскорбление Гражданских.
Запрет на Бездействие (искл. Вокзал)
Запрет на Отвлечение от службы сотрудников ГО
Запрет на Игнорирование предупреждений от представителей ГО
Запрет на Оскорбление сотрудника ГО ( перевоспитание/карцер )
Запрет на Не предоставление своих идентификационных данных, CID карт.
Запрет на собрания гражданских в общественных местах (Больше 3 гражданских - Мятеж)
Запрет на контакт и оказание помощи Повстанческому Движению]]

rp.cfg.DisallowDrop = {
	arrest_stick 	= true,
	door_ram 		= true,
	gmod_camera 	= true,
	gmod_tool 		= true,
	keys 			= true,
	med_kit 		= true,
	pocket 			= true,
	stunstick 		= false,
	unarrest_stick 	= false,
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun 	= true,
	weaponchecker 	= true,
	weapon_fists 	= true
}

rp.cfg.DefaultWeapons = {
	'weapon_physcannon',
	'weapon_physgun',
	'gmod_tool',
	'keys',
	'pocket'
}

rp.cfg.AdminWeapons = {
  "weapon_keypadchecker",
}

-- Bail Machine
rp.cfg.BailMachines = {
	rp_downtown_sup_b5c = {
		{
			Pos =  Vector(-1804.494873, -578.091919, -112.372955),
			Ang = Angle(0, 0, 0),
		},
		{
			Pos = Vector(-1508.957520, -464.528656, 26.956495),
			Ang = Angle(0, 180, 0),
		},
	},
	rp_c18_sup_b1 = {
		{
			Pos = Vector(1746.195313, -1210.773560, 1668.341675),
			Ang = Angle(-0.009, -154.152, -0.693),
		},
		{
			Pos = Vector(2454.931885, 877.869263, 965.826965),
			Ang = Angle(0.006, 44.813, 0.046),
		},
	}
}
rp.cfg.BailMachines['rp_downtown_sup_b5c_night'] = rp.cfg.BailMachines['rp_downtown_sup_b5c']

-- Cop shops
rp.cfg.CopShops = {
	rp_downtown_sup_b5c = {
		Pos = Vector(-2838, -495, -156),
		Ang = Angle(0, 0, 0),
	},
	rp_c18_sup_b1 = {
		Pos = Vector(1916, 713, 1010),
		Ang = Angle(0, 0, 0),
	},
	rp_downtown_v4c_v2 = {
		Pos = Vector(-1976.700073, 339.000000, -159.968750),
		Ang = Angle(0, 0, 0),
	},
}
rp.cfg.CopShops['rp_downtown_sup_b5c_night'] = rp.cfg.CopShops['rp_downtown_sup_b5c']

-- Craft
rp.cfg.CraftLimits = 5
rp.cfg.CraftRecipes = {
	['swb_357'] = {
		['trash_metal'] = 2,
		['trash_wood'] = 1,
		['trash_bottle'] = 2,
	},
	-- ['swb_awp'] = {
	-- 	['trash_metal'] = 4,
	-- 	['trash_wood'] = 2,
	-- 	['trash_bottle'] =2 ,
	-- 	['trash_tools'] = 2
	-- },
	['swb_deagle'] = {
		['trash_metal'] = 3,
		['trash_wood'] = 2,
		['trash_tools'] = 1
	},
	['swb_famas'] = {
		['trash_carbon'] = 2,
		['trash_metal'] = 3,
		['trash_tools'] = 1
	},
	['swb_fiveseven'] = {
		['trash_metal'] = 2,
		['trash_tools'] = 1,
		['trash_bottle'] = 1
	},
	['swb_p90'] = {
		['trash_metal'] = 2,
		['trash_tools'] = 1,
	},
	-- ['swb_g3sg1'] = {
	-- 	['trash_metal'] = 4,
	-- 	['trash_carbon'] = 3,
	-- 	['trash_tools'] = 2
	-- },
	-- ['swb_glock18'] = {
	-- 	['trash_metal'] = 2,
	-- 	['trash_bottle'] = 2,
	-- },
	['swb_mp5'] = {
		['trash_metal'] = 3,
		['trash_wood'] = 2,
		['trash_tools'] = 2
	},
	-- ['swb_galil'] = {
	-- 	['trash_metal'] = 2,
	-- 	['trash_wood'] = 2,
	-- 	['trash_tools'] = 1
	-- },
	-- ['swb_m249'] = {
	-- 	['trash_metal'] = 6,
	-- 	['trash_tools'] = 5,
	-- },
	-- ['swb_m3super90'] = {
	-- 	['trash_metal'] = 4,
	-- 	['trash_tools'] = 2,
	-- 	['trash_carbon'] = 3,
	-- },
	-- ['swb_m4a1'] = {
	-- 	['trash_metal'] = 4,
	-- 	['trash_tools'] = 3,
	-- 	['trash_bottle'] = 3,
	-- },
	['swb_mac10'] = {
		['trash_metal'] = 2,
		['trash_bottle'] = 1,
	},
	['swb_smg'] = {
		['trash_metal'] = 2,
		['trash_wood'] = 1,
		['trash_tools'] = 1,
	},
	['swb_p228'] = {
		['trash_metal'] = 2,
		['trash_bottle'] = 2,
		['trash_carbon'] = 1,
	},
	['swb_scout'] = {
		['trash_metal'] = 2,
		['trash_carbon'] = 4,
		['trash_tools'] = 1
	},
	['swb_sg550'] = {
		['trash_metal'] = 2,
		['trash_carbon'] = 4,
		['trash_tools'] = 2
	},
	['swb_sg552'] = {
		['trash_metal'] = 5,
		['trash_tools'] = 2,
	},
	-- ['swb_m3super90'] = {
	-- 	['trash_metal'] = 3,
	-- 	['trash_tools'] = 2,
	-- },
	['swb_tmp'] = {
		['trash_metal'] = 2,
		['trash_bottle'] = 3,
	},
	['swb_ump'] = {
		['trash_metal'] = 2,
		['trash_carbon'] = 4,
		['trash_tools'] = 1
	},
	['swb_usp'] = {
		['trash_metal'] = 3,
		['trash_bottle'] = 2,
		['trash_tools'] = 1
	},
	-- ['swb_xm1014'] = {
	-- 	['trash_metal'] = 5,
	-- 	['trash_tools'] = 3,
	-- },
	['swb_pistol'] = {
		['trash_metal'] = 2,
		['trash_carbon'] = 1,
		['trash_bottle'] = 3,
		['trash_tools'] =2
	},
	-- ['trash_paper'] = {
	--     ['trash_can'] = 2,
	--     ['hat'] = 2,
	--     ['cw_357'] = 1,
	--     ['trash_bottle'] = 10,
	-- },
	-- ['cw_357'] = {
	--     ['trash_can'] = 2,
	--     ['hat'] = 1,
	-- },
	-- ['hat'] = {
	--     ['trash_can'] = 2,
	--     ['cw_357'] = 1,
	-- },
	-- ['trash_bottle'] = {
	--     ['trash_can'] = 2,
	--     ['hat'] = 2,
	--     ['cw_357'] = 1,
	-- },
}

-- Spawn
rp.cfg.SpawnDisallow = {
	prop_physics		= true,
	media_radio 		= true,
	media_tv 			= true,
	ent_textscreen 		= true,
	ent_picture 		= true,
	gmod_rtcameraprop	= true,
	metal_detector		= true
}

rp.cfg.Spawns = {
	rp_city17_metahub_v2 = {
		-- Vector(5641.457520, 10454.310547, 760.031250),
		-- Vector(6086.138184, 10427.055664, 760.031250)
	}
}

rp.cfg.SpawnPos = {
	rp_city17_metahub_v2 = {
        Vector('-4752.786621 -190.964874 112.031250'),
        Vector('-4652.786621 -190.964874 112.031250'),
        Vector('-4552.786621 -190.964874 112.031250'),
        Vector('-4452.786621 -190.964874 112.031250'),
        Vector('-4752.786621 -290.964874 112.031250'),
        Vector('-4652.786621 -290.964874 112.031250'),
        Vector('-4552.786621 -290.964874 112.031250'),
        Vector('-4452.786621 -290.964874 112.031250'),
	}
}

-- Jail
rp.cfg.WantedTime		= 180
rp.cfg.WarrantTime		= 180
rp.cfg.ArrestTimeMin 	= 120
rp.cfg.ArrestTimeMax 	= 300

rp.cfg.Jails = {
	rp_city17_metahub_v2 = {
		Vector('4317.746582 795.168030 138.031250'),
	}
}

rp.cfg.JailPos = {
	rp_city17_metahub_v2 = {
		Vector('4317.746582 795.168030 138.031250'),
	}
}

-- -- Theater
-- rp.cfg.Theaters = {
-- 	rp_downtown_sup_b5c = {
-- 		Screen = {
-- 			Pos = Vector(-3373, -3367, 205),
-- 			Ang = Angle(0,180,90),
-- 			Scale = 0.23
-- 		},
-- 		Projector = {
-- 			Pos = Vector(-3538.600098, -2593.199951, -27.545000),
-- 			Ang = Angle(-0.000, 0.000, -0.000),
-- 		},
-- 	},
-- 	rp_c18_sup_b1 = {
-- 		Screen = {
-- 			Pos = Vector(-2600, 1115, 1075),
-- 			Ang = Angle(0,90,90),
-- 			Scale = 0.16
-- 		},
-- 		Projector = {
-- 			Pos = Vector(-2446.300049, 1204.500000, 848.949402),
-- 			Ang = Angle(-0.000, -90.000, 0.000),
-- 		},
-- 	},
-- 	rp_downtown_v4c_v2 = {
-- 		Screen = {
-- 			Pos = Vector(-1943.411133, 2124.596191, -71.473183),
-- 			Ang = Angle(-89.996, 89.982, 180.000),
-- 			Scale = 0.25
-- 		},
-- 		Projector = {
-- 			Pos =  Vector(-1911.208984, 2097.991211, -173.941406),
-- 			Ang = Angle(90.000, -0.220, 180.000),
-- 		},
-- 	},
-- }
-- rp.cfg.Theaters['rp_downtown_sup_b5c_night'] = rp.cfg.Theaters['rp_downtown_sup_b5c']

-- Kombat
-- rp.cfg.KombatRoom = {
-- 	rp_downtown_sup_b5c = {
-- 		Vector(-5313, -2167, -620),
-- 		Vector(-4244, -1174, -375),
-- 	},
-- 	rp_c18_sup_b1 = {
-- 		Vector(842, -133, 501),
-- 		Vector(1607, 607, -59),
-- 	}
-- }
-- rp.cfg.KombatRoom['rp_downtown_sup_b5c_night'] = rp.cfg.KombatRoom['rp_downtown_sup_b5c']

-- -- Dumpsters
-- rp.cfg.Dumpsters = {
-- 	rp_downtown_sup_b5c = {
-- 		{Vector(-1078.358643, 2029.177124, -169.767410), Angle(0, 0, 0)},
-- 		{Vector(-3173.637207, -1692.055420, -170.330276), Angle(0, 0, 0)},
-- 		{Vector(-780.621826, -1970.168945, -170.088562), Angle(0, -90, 0)},
-- 		{Vector(100.398178, -537.862976, -294.299866), Angle(0, 90, 0)},
-- 		{Vector(1837.878784, -2176.435791, -137.308685), Angle(0, 180, 0)},
-- 		{Vector(3692.299561, -3298.900146, -105.411743), Angle(0, 90, 0)},
-- 		{Vector(3044.721924, 2677.100098, -169.308685), Angle(0, 90, 0)},
-- 		{Vector(1700.366333, 309.102722, -169.308685), Angle(0, 90, 0)},
-- 		{Vector(2149.900146, 2078.684326, -169.308685), Angle(0, -180, 0)},
-- 	},
-- 	rp_c18_sup_b1 = {
-- 		{Vector(1234.892334, -2138.017822, 690.691284), Angle(0, -90, 0)},
-- 		{Vector(3357.300049, -113.900002, 690.691284), Angle(0, 0, 0)},
-- 		{Vector(-970.200012, 5169.500000, 882.691284), Angle(0, 90, 0)},
-- 		{Vector(-1480.983154, 1957.133911, 874.691284), Angle(0, 90, 0)},
-- 		{Vector(1469.599976, 3333.699951, 1170.691284), Angle(0, -90, 0)},
-- 	},
-- 	rp_downtown_v4c_v2 ={
-- 		{Vector(3385.900146, 542.071350, -169.308685), Angle(0, 180, 0)},
-- 		{Vector(3948.614014, 2021.133911, -169.308685), Angle(0, 90, 0)},
-- 		{Vector(-461.800018, 3205.134033, -168.699997), Angle(0, 90, 0)},
-- 		{Vector(-1077.597534, 2079.100098, -169.308685), Angle(0, 0, 0)},
-- 		{Vector(-4476.597656, 2812.528809, -177.308685), Angle(0, 0, 0)},
-- 	}
-- }
-- rp.cfg.Dumpsters['rp_downtown_sup_b5c_night'] = rp.cfg.Dumpsters['rp_downtown_sup_b5c']

-- rp.cfg.KombatPos = {
-- 	['sup_silenthill_b5'] = {
-- 		Box = {
-- 			{x = -6462, y = 4089, x2 = -6462, y2 = 3316},
-- 			{x = -6462, y = 3316, x2 = -5691, y2 = 3316},
-- 			{x = -5691, y = 3316, x2 = -5691, y2 = 4089},
-- 			{x = -5691, y = 4089, x2 = -6462, y2 = 4089}
-- 		},
-- 		SpawnPoint = Vector(-6089, 3697, -296),
-- 		ZCutOff = -375,
-- 		MaxPlayers = 25
-- 	},
-- 	rp_c18_sup_b1= {
-- 		Box = {
-- 			{x = 857, y = -147, x2 = 857, y2 = -148},
-- 			{x = 857, y = -148, x2 = 1601, y2 = -148},
-- 			{x = 1601, y = -148, x2 = 1601, y2 = -147},
-- 			{x = 1601, y = -147, x2 = 857, y2 = -147},
-- 		},
-- 		SpawnPoint = Vector(1165, 299, 288),
-- 		ZCutOff = 155,
-- 		MaxPlayers = 15
-- 	},
-- 	rp_downtown_sup_b5c = {
-- 		Box = {
-- 			{x = -5144, y = -2039, x2 = -5144, y2 = -1299},
-- 			{x = -5144, y = -1299, x2 = -4385, y2 = -1299},
-- 			{x = -4385, y = -1299, x2 = -4385, y2 = -2039},
-- 			{x = -4385, y = -2039, x2 = -5144, y2 = -2039},
-- 		},
-- 		SpawnPoint = Vector(-4703, -1642, -530),
-- 		ZCutOff = -650,
-- 		MaxPlayers = 15
-- 	},
-- 	rp_downtown_sup_b5c_night = {
-- 		Box = {
-- 			{x = -5144, y = -2039, x2 = -5144, y2 = -1299},
-- 			{x = -5144, y = -1299, x2 = -4385, y2 = -1299},
-- 			{x = -4385, y = -1299, x2 = -4385, y2 = -2039},
-- 			{x = -4385, y = -2039, x2 = -5144, y2 = -2039},
-- 		},
-- 		SpawnPoint = Vector(-4703, -1642, -485),
-- 		ZCutOff = -555,
-- 		MaxPlayers = 15
-- 	},
-- }

rp.cfg.VoiceCommands = {
    [TEAMTYPE_CITIZEN] = {
		{ title = "Логично", text = "Логично", sound = "vo/npc/%s01/answer03.wav" },
		{ title = "Не думай", text = "Не думай об этом", sound = "vo/npc/%s01/answer04.wav" },
		{ title = "Понятно", text = "Понятно", sound = "vo/npc/%s01/answer07.wav" },
		{ title = "Поговорим об", text = "Поговорим об этом позже", sound = "vo/npc/%s01/answer05.wav" },
		{ title = "Не говори", text = "Не говори так громко", sound = "vo/npc/%s01/answer10.wav" },
		{ title = "Зачем мне", text = "Зачем мне это говоришь?", sound = "vo/npc/%s01/answer24.wav" },
		{ title = "Ну и", text = "Ну и ну", sound = "vo/npc/%s01/answer25.wav" },
		{ title = "Упс", text = "Упс", sound = "vo/npc/%s01/whoops01.wav" },
		{ title = "Извини", text = "Извини", sound = "vo/npc/%s01/sorry01.wav" },
		{ title = "Простите", text = "Простите", sound = "vo/npc/%s01/pardonme02.wav" },
		{ title = "Окей", text = "Окей", sound = "vo/npc/%s01/ok01.wav" },
		{ title = "Отлично", text = "Отлично", sound = "vo/npc/%s01/nice.wav" },
		{ title = "Потрясающе", text = "Потрясающе", sound = "vo/npc/%s01/fantastic01.wav" },
		{ title = "Гражданская Оборона", text = "Гражданская Оборона!", sound = "vo/npc/%s01/cps01.wav" },
		{ title = "Ты ко мне?", text = "Ты ко мне?", sound = "vo/npc/%s01/answer30.wav" },
		{ title = "Даже думать", text = "Даже думать страшно", sound = "vo/npc/%s01/answer12.wav" },
		{ title = "Подумай лучше", text = "Подумай лучше о работе", sound = "vo/npc/%s01/answer19.wav" },
		{ title = "Не переживай", text = "Не переживай", sound = "vo/npc/%s01/answer36.wav" },
		{ title = "Занят", text = "Занят", sound = "vo/npc/%s01/busy02.wav" },
		{ title = "Привет", text = "Привет", sound = "vo/npc/%s01/hi01.wav" },
		{ title = "Ведите нас!",          text = "Ведите нас!",            sound = "vo/npc/%s01/leadtheway01.wav" },
		{ title = "Вперед!",              text = "Вперед!",                sound = "vo/npc/%s01/letsgo01.wav" },
		{ title = "Сюда!",                text = "Сюда!",                  sound = "vo/npc/%s01/overhere01.wav" },
		{ title = "Кого нибудь ждем?",    text = "Кого нибудь ждем?",      sound = "vo/npc/%s01/waitingsomebody.wav" },
		{ title = "Берегись!",            text = "Берегись!",              sound = "vo/npc/%s01/watchout.wav" },
		{ title = "А вот и мы!",          text = "А вот и мы!",            sound = "vo/npc/%s01/watchout.wav" },
		{ title = "Спасайся!",            text = "Спасайся!",              sound = "vo/npc/%s01/runforyourlife01.wav" },
		{ title = "Мы готовы!",           text = "Мы готовы!",             sound = "vo/npc/%s01/readywhenyouare01.wav" },
		{ title = "Туда!",                text = "Туда!",                  sound = "vo/npc/%s01/overthere01.wav" },
		{ title = "Прикрой, перезаряжу!", text = "Прикрой, перезаряжу!",   sound = "vo/npc/%s01/coverwhilereload01.wav" },
	},
	[TEAMTYPE_COMBINE] = {
		{ title = "0", text = "Ноль.", sound = "npc/metropolice/vo/zero.wav" },
		{ title = "1", text = "Один.", sound = "npc/metropolice/vo/one.wav" },
		{ title = "10", text = "Десять.", sound = "npc/metropolice/vo/ten.wav" },
		{ title = "10-0 мэнхэк в действии ", text = "10-0,  мэнхэк в действии!", sound = "npc/metropolice/vo/tenzerovisceratorishunting.wav" },
		{ title = "100", text = "100.", sound = "npc/metropolice/vo/onehundred.wav" },
		{ title = "10-103 TAG", text = "Возможно у меня 10-103, оповестите свободных", sound = "npc/metropolice/vo/possible10-103alerttagunits.wav" },
		{ title = "10-107", text = "У меня здесь 10-107,поддержите с возд��ха .", sound = "npc/metropolice/vo/gota10-107sendairwatch.wav" },
		{ title = "10-108", text = "10-108!", sound = "npc/metropolice/vo/wehavea10-108.wav" },
		-- { title = "10-14", text = "Holding on 10-14 duty, eh, code four.", sound = "npc/metropolice/vo/holdingon10-14duty.wav" },
		{ title = "10-15", text = "Приготовьтесь к 10-15.", sound = "npc/metropolice/vo/preparefor1015.wav" },
		{ title = "10-2", text = "10-2.", sound = "npc/metropolice/vo/ten2.wav" },
		{ title = "10-25", text = "Кто-нибудь, доложите по 10-25.", sound = "npc/metropolice/vo/unitreportinwith10-25suspect.wav" },
		{ title = "10-30", text = "10-30, 10-20. Код отзыва - 2.", sound = "npc/metropolice/vo/Ihave10-30my10-20responding.wav" },
		{ title = "10-4", text = "10-4.", sound = "npc/metropolice/vo/ten4.wav" },
		{ title = "10-65", text = "Офицер 10-65.", sound = "npc/metropolice/vo/unitis10-65.wav" },
		{ title = "10-78", text = "База, 10-78, офицер под угрозой!", sound = "npc/metropolice/vo/dispatchIneed10-78.wav" },
		{ title = "10-8 ", text = "10-8, жду указаний.", sound = "npc/metropolice/vo/ten8standingby.wav" },
		{ title = "10-8", text = "Офицер на дежурстве, 10-8.", sound = "npc/metropolice/vo/unitisonduty10-8.wav" },
		{ title = "10-91", text = "10-91 убита...", sound = "npc/metropolice/vo/ten91dcountis.wav" },
		{ title = "10-97 ", text = "10-97, Скрылся при появлении полиции.", sound = "npc/metropolice/vo/ten97suspectisgoa.wav" },
		{ title = "10-97", text = "10-97.", sound = "npc/metropolice/vo/ten97.wav" },
		{ title = "10-99", text = "Офицер убит,код 10-99, повторяю, код 10-99!", sound = "npc/metropolice/vo/officerdownIam10-99.wav" },
		{ title = "11-44", text = "Требуется 11-44 зачистка.", sound = "npc/metropolice/vo/get11-44inboundcleaningup.wav" },
		{ title = "11-6", text = "Объект 11-6, на 10-20 ", sound = "npc/metropolice/vo/suspect11-6my1020is.wav" },
		{ title = "11-99", text = "11-99, Нападение на офицера!", sound = "npc/metropolice/vo/11-99officerneedsassistance.wav" },
		{ title = "Два", text = "Two.", sound = "npc/metropolice/vo/two.wav" },
		{ title = "Двадцать", text = "Twenty.", sound = "npc/metropolice/vo/twenty.wav" },
		{ title = "Двести", text = "Two-hundred.", sound = "npc/metropolice/vo/twohundred.wav" },
		{ title = "Три", text = "Three.", sound = "npc/metropolice/vo/three.wav" },
		{ title = "Тридцать", text = "Thirty.", sound = "npc/metropolice/vo/thirty.wav" },
		{ title = "Триста", text = "Three-hundred.", sound = "npc/metropolice/vo/threehundred.wav" },
		{ title = "34S AT", text = "Внимание всем,у нас 3-4", sound = "npc/metropolice/vo/allunitsbol34sat.wav" },
		{ title = "Четыре", text = "4.", sound = "npc/metropolice/vo/four.wav" },
		{ title = "Сорок", text = "40.", sound = "npc/metropolice/vo/fourty.wav" },
		{ title = "404", text = "404 zone.", sound = "npc/metropolice/vo/404zone.wav" },
		{ title = "408", text = "У меня здесь на месте 408.", sound = "npc/metropolice/vo/Ivegot408hereatlocation.wav" },
		{ title = "415B", text = "Is 415b.", sound = "npc/metropolice/vo/is415b.wav" },
		{ title = "Пять", text = "Five.", sound = "npc/metropolice/vo/five.wav" },
		{ title = "Пятьдесят", text = "Fifty.", sound = "npc/metropolice/vo/fifty.wav" },
		{ title = "Пятьсот пять", text = "Dispatch, we need AirWatch, subject is 505!", sound = "npc/metropolice/vo/airwatchsubjectis505.wav" },
		{ title = "6", text = "Шесть.", sound = "npc/metropolice/vo/six.wav" },
		{ title = "60", text = "Шестьдесят.", sound = "npc/metropolice/vo/sixty.wav" },
		{ title = "603", text = "Шесть ноль три , вторжение.", sound = "npc/metropolice/vo/unlawfulentry603.wav" },
		{ title = "63", text = "63, Причинение вреда.", sound = "npc/metropolice/vo/criminaltrespass63.wav" },
		{ title = "7", text = "Семь.", sound = "npc/metropolice/vo/seven.wav" },
		{ title = "70", text = "Семьдесят.", sound = "npc/metropolice/vo/seventy.wav" },
		{ title = "8", text = "8.", sound = "npc/metropolice/vo/eight.wav" },
		{ title = "80", text = "80.", sound = "npc/metropolice/vo/eighty.wav" },
		{ title = "9", text = "9.", sound = "npc/metropolice/vo/nine.wav" },
		{ title = "90", text = "90.", sound = "npc/metropolice/vo/ninety.wav" },
		{ title = "Граната", text = "Это граната!", sound = "npc/metropolice/vo/thatsagrenade.wav" },
		{ title = "Вижу его", text = "Вижу его!", sound = "npc/metropolice/vo/acquiringonvisual.wav" },
		{ title = "Выполняй", text = "Выполняй.", sound = "npc/metropolice/vo/administer.wav" },
		{ title = "Виновен в нападении", text = "Виновен в вооруженном нападении, 10-0.", sound = "npc/metropolice/vo/confirmadw.wav" },
		{ title = "Есть", text = "Есть.", sound = "npc/metropolice/vo/affirmative.wav" },
		{ title = "Всем юнитам, вперёд", text = "Всем выдвигаться!", sound = "npc/metropolice/vo/allunitsmovein.wav" },
		{ title = "Отсечь", text = "Отсечь.", sound = "npc/metropolice/vo/amputate.wav" },
		{ title = "Нарушитель", text = "Нарушитель.", sound = "npc/metropolice/vo/anticitizen.wav" },
		{ title = "Дезинфекция", text = "Дезинфекция.", sound = "npc/combine_soldier/vo/antiseptic.wav" },
		{ title = "Аспект", text = "Аспект.", sound = "npc/combine_soldier/vo/apex.wav" },
		{ title = "Применить", text = "Применить.", sound = "npc/metropolice/vo/apply.wav" },
		{ title = "Всем на позицию ��ля аре��та", text = "Всем выйти на позицию для ареста!", sound = "npc/metropolice/vo/movetoarrestpositions.wav" },
		{ title = "На то��ке", text = "На точке.", sound = "npc/metropolice/vo/atcheckpoint.wav" },
		{ title = "На месте, докладываю", text = "Отряд на месте, докладываю.", sound = "npc/metropolice/vo/ptatlocationreport.wav" },
		{ title = "Прикройте, отхожу", text = "Прикройте меня, отхожу", sound = "npc/metropolice/vo/backmeupImout.wav" },
		{ title = "Назад", text = "Назад!", sound = "npc/metropolice/vo/backup.wav" },
		{ title = "НОЖ", text = "НОЖ.", sound = "npc/combine_soldier/vo/blade.wav" },
		{ title = "Тяжело ранен", text = "Объект, тяжело ранен!", sound = "npc/metropolice/vo/suspectisbleeding.wav" },
		{ title = "Следить за радаром", text = "Следите за показаниями на радаре.", sound = "npc/metropolice/vo/catchthatbliponstabilization.wav" },
		{ title = "Порядок", text = "Полный порядок..", sound = "npc/metropolice/vo/blockisholdingcohesive.wav" },
		{ title = "Поддержка 243", text = "КП, необходима слежка с воздуха за подозреваемыми 243 .", sound = "npc/metropolice/vo/cpbolforthat243.wav" },
		{ title = "Банка 1", text = "Подними эту б��нку.", sound = "npc/metropolice/vo/pickupthecan1.wav" },
		{ title = "Банка 2", text = "Подними, банку!!", sound = "npc/metropolice/vo/pickupthecan2.wav" },
		{ title = "Банка 3", text = "Я сказал подними банку!!", sound = "npc/metropolice/vo/pickupthecan3.wav" },
		{ title = "Положи в мусорку 1", text = "А теперь, положи её в мусорку.", sound = "npc/metropolice/vo/putitinthetrash1.wav" },
		{ title = "Положи в мусорку 2", text = "Я сказал положи её в мусорку!!", sound = "npc/metropolice/vo/putitinthetrash2.wav" },
		{ title = "Ты её перевернул", text = "Ты её перевернул, подними!", sound = "npc/metropolice/vo/youknockeditover.wav" },
		{ title = "Канал", text = "Канал.", sound = "npc/metropolice/vo/canal.wav" },
		{ title = "Район каналов", text = "Район каналов!", sound = "npc/metropolice/vo/canalblock.wav" },
		{ title = "Клеймить", text = "Клеймить.", sound = "npc/metropolice/vo/cauterize.wav" },
		{ title = "Проверить численность", text = "Проверить численность.", sound = "npc/metropolice/vo/checkformiscount.wav" },
		{ title = "Назначенные точки", text = "Выйти к назначенным точкам.", sound = "npc/metropolice/vo/proceedtocheckpoints.wav" },
		{ title = "Общес��венная служба", text = "Докладываю об гражданине призванном к добровольной обществен��ой службе, номер Т94-332.", sound = "npc/metropolice/vo/citizensummoned.wav" },
		{ title = "Гражданин", text = "Гражданин.", sound = "npc/metropolice/vo/citizen.wav" },
		{ title = "Зарегистрировать смерть объекта", text = "Зарегистрировать смерть объекта; квартал готов к зачистке.", sound = "npc/metropolice/vo/classifyasdbthisblockready.wav" },
		{ title = "Чисто", text = "Чисто.", sound = "npc/combine_soldier/vo/cleaned.wav" },
		{ title = "Код 100", text = "Чисто, код 100.", sound = "npc/metropolice/vo/clearandcode100.wav" },
		{ title = "На точку сбора", text = "Всем на точку сбора!", sound = "npc/metropolice/vo/allunitscloseonsuspect.wav" },
		{ title = "Приближаюсь", text = "Приближаюсь!", "npc/combine_soldier/vo/closing.wav", sound = "npc/combine_soldier/vo/closing2.wav" },
		{ title = "Код 100", text = "Код 100.", sound = "npc/metropolice/vo/code100.wav" },
		{ title = "Код  2", text = "Всем юнитам, код 2!", sound = "npc/metropolice/vo/allunitscode2.wav" },
		{ title = "Код  3", text = "Офицер погиб, запрос юнитов, код 3 к моим 10-20!", sound = "npc/metropolice/vo/officerdowncode3tomy10-20.wav" },
		{ title = "Код 7", text = "Код 7 .", sound = "npc/metropolice/vo/code7.wav" },
		{ title = "Трущобы", text = "Зона ветхих зданий!", sound = "npc/metropolice/vo/condemnedzone.wav" },
		{ title = "Контакт 243", text = "Контакт с подозреваемым 243, я 10-20 .", sound = "npc/metropolice/vo/contactwith243suspect.wav" },
		{ title = "Контакт с целью 2", text = "Контакт с целью 2!", sound = "npc/metropolice/vo/contactwithpriority2.wav" },
		{ title = "Контакт", text = "Контакт!", sound = "npc/combine_soldier/vo/contact.wav" },
		{ title = "Убит", text = "Убит.", sound = "npc/combine_soldier/vo/contained.wav" },
		{ title = "Контроль 100", text = "Местность под сто процентным контролем, никаких следов 647-E.", sound = "npc/metropolice/vo/control100percent.wav" },
		{ title = "Секция управления", text = "Секция управления!", sound = "npc/metropolice/vo/controlsection.wav" },
		{ title = "Соединяюсь", text = "Соединяюсь .", sound = "npc/metropolice/vo/converging.wav" },
		{ title = "Вас понял", text = "Вас понял.", sound = "npc/combine_soldier/vo/copythat.wav" },
		{ title = "Понял", text = "Понял.", sound = "npc/metropolice/vo/copy.wav" },
		{ title = "Прикрой", text = "Прикрой!", sound = "npc/combine_soldier/vo/coverhurt.wav" },
		{ title = "Командный Пункт под угрозой", text = "Командный Пункт под угрозой, установить заново !", sound = "npc/metropolice/vo/cpiscompromised.wav" },
		{ title = "КП необходимо", text = "КП, необходимо установить периметр...", sound = "npc/metropolice/vo/cpweneedtoestablishaperimeterat.wav" },
		{ title = "КП уничтожен", text = "КП уничтожен, сдерживание невозможно!", sound = "npc/metropolice/vo/cpisoverrunwehavenocontainment.wav" },
		{ title = "Кинжал", text = "Кинжал.", sound = "npc/combine_soldier/vo/dagger.wav" },
		{ title = "Убито", text = "Убито...", sound = "npc/metropolice/vo/dbcountis.wav" },
		{ title = "Защитник", text = "Защитник!", sound = "npc/metropolice/vo/defender.wav" },
		{ title = "Заброшенный район", text = "Заброшенный район.", sound = "npc/metropolice/vo/deservicedarea.wav" },
		{ title = "Подозреваемый опознан", text = "Подозреваемый опознан как...", sound = "npc/metropolice/vo/designatesuspectas.wav" },
		{ title = "Уничтожить укрытие", text = "Уничтожить укрытие!", sound = "npc/metropolice/vo/destroythatcover.wav" },
		{ title = "Огонь по укрытию", text = "Огонь по укрытию!", sound = "npc/metropolice/vo/firetodislocateinterpose.wav" },
		{ title = "Пост снят", text = "Пост снят.", sound = "npc/metropolice/vo/dismountinghardpoint.wav" },
		{ title = "База ориентировка", text = "База обновляет ориентировку .", sound = "npc/metropolice/vo/dispupdatingapb.wav" },
		{ title = "Район распределения ", text = "Район распределения  .", sound = "npc/metropolice/vo/distributionblock.wav" },
		{ title = "Документ", text = "Документ.", sound = "npc/metropolice/vo/document.wav" },
		{ title = "Стоять", text = "Стоять!", sound = "npc/metropolice/vo/dontmove.wav" },
		{ title = "ECHO", text = "Echo.", sound = "npc/combine_soldier/vo/echo.wav" },
		{ title = "ENGAGING", text = "Engaging!", sound = "npc/combine_soldier/vo/engaging.wav" },
		{ title = "Новый КП", text = "Вышел из строя, установить новый КП!", sound = "npc/metropolice/vo/establishnewcp.wav" },
		{ title = "Огонь по укрытию", text = "Огонь по укрытию!", sound = "npc/metropolice/vo/firingtoexposetarget.wav" },
		{ title = "Внешняя сила", text = "Юрисдикция внешних сил.", sound = "npc/metropolice/vo/externaljurisdiction.wav" },
		{ title = "Приговор", text = "Приговор приведен в исполнение.", sound = "npc/metropolice/vo/finalverdictadministered.wav" },
		{ title = "Последнее предупреждение", text = "Последнее предупреждение!", sound = "npc/metropolice/vo/finalwarning.wav" },
		{ title = "Первое предупреждение", text = "Первое предупреждение, отойти!", sound = "npc/metropolice/vo/firstwarningmove.wav" },
		{ title = "FIST", text = "Fist.", sound = "npc/combine_soldier/vo/fist.wav" },
		{ title = "FLASH", text = "Flash.", sound = "npc/combine_soldier/vo/flash.wav" },
		{ title = "FLATLINE", text = "Flatline.", sound = "npc/combine_soldier/vo/flatline.wav" },
		{ title = "FLUSH", text = "Flush.", sound = "npc/combine_soldier/vo/flush.wav" },
		{ title = "Нежить", text = "У меня здесь нежить!", sound = "npc/metropolice/vo/freenecrotics.wav" },
		{ title = "Ложись", text = "Ложись!", sound = "npc/metropolice/vo/getdown.wav" },
		{ title = "Убирайся", text = "Убирайся вон!", sound = "npc/metropolice/vo/getoutofhere.wav" },
		{ title = "Поступают 647E", text = "От наблюдателей еще поступают 647E", sound = "npc/metropolice/vo/stillgetting647e.wav" },
		{ title = "GHOST", text = "Ghost.", sound = "npc/combine_soldier/vo/ghost.wav" },
		{ title = "Вперед", text = "Отряд, вперед.", sound = "npc/metropolice/vo/ptgoagain.wav" },
		{ title = "Вижу цель!", text = "Вижу цель!!", sound = "npc/combine_soldier/vo/gosharp.wav" },
		{ title = "Захожу", text = "Прикройте меня,я захожу!", sound = "npc/metropolice/vo/covermegoingin.wav" },
		{ title = "Труп", text = "У нас тут труп, отме��ите 11-42.", sound = "npc/metropolice/vo/wegotadbherecancel10-102.wav" },
		{ title = "Вижу его", text = "Вижу его, подозреваемые 10-20...", sound = "npc/metropolice/vo/gothimagainsuspect10-20at.wav" },
		{ title = "Есть один сообщник", text = "Есть один сообщник!", sound = "npc/metropolice/vo/gotoneaccompliceherea.wav" },
		{ title = "Здесь подозреваемый", text = "Здесь подозреваемый один!", sound = "npc/metropolice/vo/gotsuspect1here.wav" },
		{ title = "Граната", text = "Граната!", sound = "npc/metropolice/vo/grenade.wav" },
		{ title = "GRID", text = "Grid.", sound = "npc/combine_soldier/vo/grid.wav" },
		{ title = "Хаха", text = "Хаха.", sound = "npc/metropolice/vo/chuckle.wav" },
		{ title = "HAMMER", text = "Hammer.", sound = "npc/combine_soldier/vo/hammer.wav" },
		{ title = "В боевой машине", text = "В боевой машине,готов к действию", sound = "npc/metropolice/vo/isathardpointreadytoprosecute.wav" },
		{ title = "В машине", text = "В машине,сканирую.", sound = "npc/metropolice/vo/hardpointscanning.wav" },
		{ title = "HELIX", text = "Helix.", sound = "npc/combine_soldier/vo/helix.wav" },
		{ title = "На помощь", text = "На помощь!", sound = "npc/metropolice/vo/help.wav" },
		{ title = "Герой", text = "Герой!", sound = "npc/metropolice/vo/hero.wav" },
		{ title = "Уходит 148", text = "Уходит 148!", sound = "npc/metropolice/vo/hesgone148.wav" },
		{ title = "Высокая важность", text = "Район высокой важности.", sound = "npc/metropolice/vo/highpriorityregion.wav" },
		{ title = "Стоять", text = "Стоять нам месте!", sound = "npc/metropolice/vo/holditrightthere.wav" },
		{ title = "Оставаться", text = "Оставаться на позиции.", sound = "npc/metropolice/vo/holdthisposition.wav" },
		{ title = "Стоять", text = "Стоять!", sound = "npc/metropolice/vo/holdit.wav" },
		{ title = "HUNTER", text = "Hunter.", sound = "npc/combine_soldier/vo/hunter.wav" },
		{ title = "HURRICANE", text = "Hurricane.", sound = "npc/combine_soldier/vo/hurricane.wav" },
		{ title = "Я сказал отойти", text = "Я сказал отойти.", sound = "npc/metropolice/vo/Isaidmovealong.wav" },
		{ title = "ICE", text = "Ice.", sound = "npc/combine_soldier/vo/ice.wav" },
		{ title = "На позиции", text = "На позиции.", sound = "npc/metropolice/vo/inposition.wav" },
		{ title = "INBOUND", text = "Inbound.", sound = "npc/combine_soldier/vo/inbound.wav" },
		{ title = "INFECTED", text = "Infected.", sound = "npc/combine_soldier/vo/infected.wav" },
		{ title = "Инфекция", text = "Инфекция!", sound = "npc/metropolice/vo/infection.wav" },
		{ title = "Зараженный район", text = "Зараженный район.", sound = "npc/metropolice/vo/infestedzone.wav" },
		{ title = "Ввести", text = "Ввести!", sound = "npc/metropolice/vo/inject.wav" },
		{ title = "Предотвратить", text = "Предотвратить.", sound = "npc/metropolice/vo/innoculate.wav" },
		{ title = "Вмешаться", text = "Вмешаться!", sound = "npc/metropolice/vo/intercede.wav" },
		{ title = "Соединить���я", text = "Соединиться!", sound = "npc/metropolice/vo/interlock.wav" },
		{ title = "Расследовать", text = "Расследовать.", sound = "npc/metropolice/vo/investigate.wav" },
		{ title = "Расследую", text = "Расследую 10-103.", sound = "npc/metropolice/vo/investigating10-103.wav" },
		{ title = "Ион", text = "Ион.", sound = "npc/combine_soldier/vo/ion.wav" },
		{ title = "Это 10-108", text = "Это 10-108!", sound = "npc/metropolice/vo/is10-108.wav" },
		{ title = "Офицер 10-8", text = "Офицер 10-8, жду указаний.", sound = "npc/metropolice/vo/unitis10-8standingby.wav" },
		{ title = "Приближаюсь", text = "Приближаюсь к подозреваемому!", sound = "npc/metropolice/vo/isclosingonsuspect.wav" },
		{ title = "Убить", text = "Убить!!", sound = "npc/metropolice/vo/isdown.wav" },
		{ title = "Отряд близко", text = "Отряд на подходе.", sound = "npc/combine_soldier/vo/unitisinbound.wav" },
		{ title = "Отряд атакует", text = "Отряд атакует..", sound = "npc/combine_soldier/vo/unitismovingin.wav" },
		{ title = "Выдвигаюсь", text = "Выдвигаюсь!", sound = "npc/metropolice/vo/ismovingin.wav" },
		{ title = "Есть попадание", text = "Есть попадание.", sound = "npc/metropolice/vo/ispassive.wav" },
		{ title = "Готов", text = "Готов начинать!", sound = "npc/metropolice/vo/isreadytogo.wav" },
		{ title = "Изолировать", text = "Изолировать!", sound = "npc/metropolice/vo/isolate.wav" },
		{ title = "Ястреб", text = "Ястреб!", sound = "npc/combine_soldier/vo/judge.wav" },
		{ title = "Подозреваемый, готовьтесь", text = "Подозреваемый, готовьтесь к отправлению правосудия!", sound = "npc/metropolice/vo/prepareforjudgement.wav" },
		{ title = "Юрисдикция стабилизации", text = "Юрисдикция стабилизации.", sound = "npc/metropolice/vo/stabilizationjurisdiction.wav" },
		{ title = "Явись", text = "Явись!", sound = "npc/metropolice/vo/jury.wav" },
		{ title = "Продолжаем", text = "Продолжаем!", sound = "npc/metropolice/vo/keepmoving.wav" },
		{ title = "Воздух", text = "Воздух!", sound = "npc/metropolice/vo/king.wav" },
		{ title = "Скрывается", text = "Скрывается, виден на расстоянии...", sound = "npc/metropolice/vo/hidinglastseenatrange.wav" },
		{ title = "Лидер", text = "Лидер.", sound = "npc/combine_soldier/vo/leader.wav" },
		{ title = "Нарушитель уровня 3", text = "Здесь нарушитель порядка третьего уровня!", sound = "npc/metropolice/vo/level3civilprivacyviolator.wav" },
		{ title = "Линия", text = "Линия!", sound = "npc/metropolice/vo/line.wav" },
		{ title = "Местонахождение?", text = "Местонахождение?", sound = "npc/metropolice/vo/location.wav" },
		{ title = "Оставаться на месте", text = "Всем, оставаться на месте.!", sound = "npc/metropolice/vo/lockyourposition.wav" },
		{ title = "Фиксировать", text = "Фиксировать!", sound = "npc/metropolice/vo/lock.wav" },
		{ title = "Осторожно", text = "Осторожно!", sound = "npc/metropolice/vo/lookout.wav" },
		{ title = "Паразиты", text = "Паразиты!", sound = "npc/metropolice/vo/looseparasitics.wav" },
		{ title = "Цели не вижу", text = "Цели не вижу!", sound = "npc/combine_soldier/vo/lostcontact.wav" },
		{ title = "Боезапас на исходе", text = "Боезапас на исходе, иду в укрытие!", sound = "npc/metropolice/vo/runninglowonverdicts.wav" },
		{ title = "Магнат", text = "Магнат.", sound = "npc/combine_soldier/vo/mace.wav" },
		{ title = "Поддерживать К��", text = "Внимание всем, поддерживать КП!", sound = "npc/metropolice/vo/allunitsmaintainthiscp.wav" },
		{ title = "Неповиновение", text = "Выдаю предписание о неповиновении.", sound = "npc/metropolice/vo/issuingmalcompliantcitation.wav" },
		{ title = "Неподчинение 10-107", text = "Неподчинение 10-107, 10-20. Пресекать.", sound = "npc/metropolice/vo/malcompliant10107my1020.wav" },
		{ title = "Злоумышленник", text = "Злоумышленник!", sound = "npc/metropolice/vo/malignant.wav" },
		{ title = "Объект подходит", text = "Объект подходит по ориентировке.", sound = "npc/metropolice/vo/matchonapblikeness.wav" },
		{ title = "Сопротивление", text = "Сопротивление, продолжаю задержание!", sound = "npc/metropolice/vo/minorhitscontinuing.wav" },
		{ title = "Проходи", text = "Проходи!", sound = "npc/metropolice/vo/movealong.wav" },
		{ title = "Назад", text = "Назад, немедленно!", sound = "npc/metropolice/vo/movebackrightnow.wav" },
		{ title = "Вперёд", text = "Вперёд!", sound = "npc/combine_soldier/vo/movein.wav" },
		{ title = "Двигайся", text = "Двигайся!", sound = "npc/metropolice/vo/moveit.wav" },
		{ title = "Двигайся", text = "Двигайся!", sound = "npc/metropolice/vo/move.wav" },
		{ title = "Выхожу из боя", text = "Выхожу из боя!", sound = "npc/metropolice/vo/movingtocover.wav" },
		{ title = "Двигаюсь к машине", text = "Двигаюсь к машине!", sound = "npc/metropolice/vo/movingtohardpoint.wav" },
		{ title = "Нежить", text = "Нежить!", sound = "npc/metropolice/vo/necrotics.wav" },
		{ title = "Помощь нужна?", text = "Помощь нужна ?", sound = "npc/metropolice/vo/needanyhelpwiththisone.wav" },
		{ title = "Необходима помощь", text = "Необходима помощь, 11-99!", sound = "npc/metropolice/vo/officerneedsassistance.wav" },
		{ title = "Нужна помощь", text = "Офицеру нужна помощь!", sound = "npc/metropolice/vo/officerneedshelp.wav" },
		{ title = "Отбой 647", text = "Чисто, отбой по 647, и по 10-107.", sound = "npc/metropolice/vo/clearno647no10-107.wav" },
		{ title = "Нет контакта", text = "Нет контакта!", sound = "npc/metropolice/vo/nocontact.wav" },
		{ title = "NO I'M GOOD", text = "No, I'm good.", text = "vo/trainyard/ba_noimgood.wav" },
		{ title = "Не вижу", text = "Не вижу подозреваемого.", sound = "npc/metropolice/vo/novisualonupi.wav" },
		{ title = "Кочевник", text = "Кочевник.", sound = "npc/combine_soldier/vo/nomad.wav" },
		{ title = "Не граж��анин.", text = "Не гражданин.", sound = "npc/metropolice/vo/noncitizen.wav" },
		{ title = "Не патрулируемый", text = "Не патрулируемый район.", sound = "npc/metropolice/vo/nonpatrolregion.wav" },
		{ title = "Вирусное загр��знение", text = "Вирусное загрязнение!", sound = "npc/metropolice/vo/non-taggedviromeshere.wav" },
		{ title = "Нова", text = "Нова.", sound = "npc/combine_soldier/vo/nova.wav" },
		{ title = "Убирайся", text = "А теперь, убирайся!", sound = "npc/metropolice/vo/nowgetoutofhere.wav" },
		{ title = "Мятеж", text = "Мятеж!", sound = "npc/metropolice/vo/outbreak.wav" },
		{ title = "Центр", text = "Центр.", sound = "npc/combine_soldier/vo/overwatch.wav" },
		{ title = "Восстанавливаю порядок", text = "Восстанавливаю порядок!", sound = "npc/metropolice/vo/pacifying.wav" },
		{ title = "Крик 1", text = "Агх!", sound = "npc/metropolice/pain1.wav" },
		{ title = "Крик 2", text = "Оуч!", sound = "npc/metropolice/pain2.wav" },
		{ title = "Крик 3", text = "Ой!", sound = "npc/metropolice/pain3.wav" },
		{ title = "Крик 4", text = "Ауч!", sound = "npc/metropolice/pain4.wav" },
		{ title = "Патруль", text = "Патруль!", sound = "npc/metropolice/vo/patrol.wav" },
		{ title = "Пихта", text = "Пихта.", sound = "npc/combine_soldier/vo/payback.wav" },
		{ title = "Фантом", text = "Фантом.", sound = "npc/combine_soldier/vo/phantom.wav" },
		{ title = "Ответьте на 647Е", text = "Внимание, ответьте на 647Е, как слышно?", sound = "npc/metropolice/vo/anyonepickup647e.wav" },
		{ title = "На позиции в машине", text = "В машине на позиции.", sound = "npc/metropolice/vo/inpositionathardpoint.wav" },
		{ title = "Прибыть для задержания", text = "Прибыть для задержания.", sound = "npc/metropolice/vo/positiontocontain.wav" },
		{ title = "Возможно 404", text = "Возможно здесь 404!", sound = "npc/metropolice/vo/possible404here.wav" },
		{ title = "Возможно 647E", text = "Возможно 647-E, наблюдение с воздуха.", sound = "npc/metropolice/vo/possible647erequestairwatch.wav" },
		{ title = "Доложить о сообщниках", text = "Доложить о появлении сообщников.", sound = "npc/metropolice/vo/reportsightingsaccomplices.wav" },
		{ title = "Нарушение 3 уровня", text = "Возможно нарушение порядка третьего уровня!", sound = "npc/metropolice/vo/possiblelevel3civilprivacyviolator.wav" },
		{ title = "Рассматриваю 10-107", text = "Рассматриваю 10-107, будьте инфо��мированы.", sound = "npc/metropolice/vo/preparingtojudge10-107.wav" },
		{ title = "Давление", text = "Давление!", sound = "npc/metropolice/vo/pressure.wav" },
		{ title = "Подтвердите контакт", text = "Подтвердите контакт с целью один.", sound = "npc/metropolice/vo/confirmpriority1sighted.wav" },
		{ title = "Здесь нарушитель два", text = "Здесь нарушитель два.", sound = "npc/metropolice/vo/priority2anticitizenhere.wav" },
		{ title = "Производственный блок", text = "Производственный блок.", sound = "npc/metropolice/vo/productionblock.wav" },
		{ title = "Последнее предупреждение", text = "Готов пресечь нарушение. Последнее предупреждение!", sound = "npc/metropolice/vo/readytoprosecutefinalwarning.wav" },
		{ title = "Пресечь", text = "Пресечь!", sound = "npc/metropolice/vo/prosecute.wav" },
		{ title = "Сдерживание", text = "Сдерживание.", sound = "npc/combine_soldier/vo/procecuting." },
		{ title = "Преступление пресечено", text = "Преступление пресечено.", sound = "npc/metropolice/vo/protectioncomplete.wav" },
		{ title = "Быстрый", text = "Быстрый!", sound = "npc/metropolice/vo/quick.wav" },
		{ title = "Чайка", text = "Чайка.", sound = "npc/combine_soldier/vo/quicksand.wav" },
		{ title = "Расстояние", text = "Расстояние.", sound = "npc/combine_soldier/vo/range.wav" },
		{ title = "Рейнджер", text = "Рейнджер.", sound = "npc/combine_soldier/vo/ranger.wav" },
		{ title = "Бритва", text = "Бритва.", sound = "npc/combine_soldier/vo/razor.wav" },
		{ title = "Готов к отсечению", text = "Готов к отсечению!!", sound = "npc/metropolice/vo/readytoamputate.wav" },
		{ title = "Заряды к бою", text = "Заряды к бою!", sound = "npc/combine_soldier/vo/readycharges.wav" },
		{ title = "К бою готов", text = "К бою готов.", sound = "npc/metropolice/vo/readytojudge.wav" },
		{ title = "Готов к пресечению", text = "Готов к пресечению!", sound = "npc/metropolice/vo/readytoprosecute.wav" },
		{ title = "Оружие к бою", text = "Оружие к бою!", sound = "npc/combine_soldier/vo/readyweapons.wav" },
		{ title = "Томагавк", text = "Томагавк.", sound = "npc/combine_soldier/vo/reaper.wav" },
		{ title = "Отрядам код 3", text = "Отрядам поддержки, код 3!", sound = "npc/metropolice/vo/reinforcementteamscode3.wav" },
		{ title = "Чисто ", text = "Докладываю, чисто.", sound = "npc/combine_soldier/vo/reportingclear.wav" },
		{ title = "Всем ��оложить", text = "Всем отрядам, доложить на КП.", sound = "npc/metropolice/vo/cprequestsallunitsreportin.wav" },
		{ title = "Передвижение подозреваемого", text = "Докладываю, передвижение подоз��еваем��го!", sound = "npc/metropolice/vo/allunitsreportlocationsuspect.wav" },
		{ title = "Доложить статус", text = "Отряд ГО, доложите статус.", sound = "npc/metropolice/vo/localcptreportstatus.wav" },
		{ title = "Измененный район", text = "Измененный район.", sound = "npc/metropolice/vo/repurposedarea.wav" },
		{ title = "Жилой Квартал", text = "Жилой Квартал.", sound = "npc/metropolice/vo/residentialblock.wav" },
		{ title = "Всем постам код 3 3", text = "Всем постам, внимание, код 3!", sound = "npc/metropolice/vo/allunitsrespondcode3.wav" },
		{ title = "Что-то есть.", text = "Что-то есть..", sound = "npc/metropolice/vo/responding2.wav" },
		{ title = "Ограничить", text = "Ограничить!", sound = "npc/metropolice/vo/restrict.wav" },
		{ title = "Закрытый", text = "Закрытый.", sound = "npc/metropolice/vo/restrictedblock.wav" },
		{ title = "Зона ограничения", text = "Зона ограничения!", sound = "npc/metropolice/vo/terminalrestrictionzone.wav" },
		{ title = "Рота", text = "Рота!", sound = "npc/combine_soldier/vo/ripcord.wav" },
		{ title = "Вас понял", text = "Вас понял!", sound = "npc/metropolice/vo/rodgerthat.wav" },
		{ title = "Фараон", text = "Фараон!", sound = "npc/metropolice/vo/roller.wav" },
		{ title = "Убегает", text = "Он убегает!!", sound = "npc/metropolice/vo/hesrunning.wav" },
		{ title = "Поддерживать КП.", text = "Всем постам, код 1, поддерживать Командный Пункт!", sound = "npc/metropolice/vo/sacrificecode1maintaincp.wav" },
		{ title = "Дикарь", text = "Дикарь.", sound = "npc/combine_soldier/vo/savage.wav" },
		{ title = "Доспех", text = "Доспех.", sound = "npc/combine_soldier/vo/scar.wav" },
		{ title = "Искать", text = "Искать!", sound = "npc/metropolice/vo/search.wav" },
		{ title = "Поиск подозреваемых", text = "Поиск подозреваемых, без изменений. ", sound = "npc/metropolice/vo/searchingforsuspect.wav" },
		{ title = "Второе предупреждение", text = "Это второе предупреждение!", sound = "npc/metropolice/vo/thisisyoursecondwarning.wav" },
		{ title = "В секторе опасные формы жизни", text = "В секторе опасные формы жизни.", sound = "npc/combine_soldier/vo/confirmsectornotsterile.wav" },
		{ title = "В секторе опасность", text = "В секторе опасность.", sound = "npc/combine_soldier/vo/sectorisnotsecure.wav" },
		{ title = "Чисто, выдвинуться", text = "В точке нападения всё чисто, выдв��нутьс��!", sound = "npc/metropolice/vo/assaultpointsecureadvance.wav" },
		{ title = "Чисто", text = "Чисто.", sound = "npc/combine_soldier/vo/secure.wav" },
		{ title = "Приговор вынесен", text = "Приговор вынесен.", sound = "npc/metropolice/vo/sentencedelivered.wav" },
		{ title = "Служить", text = "Служить.", sound = "npc/metropolice/vo/serve.wav" },
		{ title = "Тень", text = "Тень.", sound = "npc/combine_soldier/vo/shadow.wav" },
		{ title = "Зона поражения", text = "Зона поражения.", sound = "npc/combine_soldier/vo/sharpzone.wav" },
		{ title = "Черт", text = "Черт!", sound = "npc/metropolice/vo/shit.wav" },
		{ title = "Перестрелка", text = "Перестрелка, нарушители с оружием!", sound = "npc/metropolice/vo/shotsfiredhostilemalignants.wav" },
		{ title = "Крыло", text = "Крыло.", sound = "npc/combine_soldier/vo/slam.wav" },
		{ title = "Сабля", text = "Сабля.", sound = "npc/combine_soldier/vo/slash.wav" },
		{ title = "Угроза обществу", text = "Угроза обществу.", sound = "npc/metropolice/vo/sociocide.wav" },
		{ title = "Всё в порядке", text = "Здесь всё в порядке.", sound = "npc/metropolice/vo/wearesociostablethislocation.wav" },
		{ title = "Рапира", text = "Spear.", sound = "npc/combine_soldier/vo/spear.wav" },
		{ title = "Стилет", text = "Стилет.", sound = "npc/combine_soldier/vo/stab.wav" },
		{ title = "Жду указаний", text = "Жду указаний.", sound = "npc/combine_soldier/vo/standingby].wav" },
		{ title = "Звезда", text = "Звезда.", sound = "npc/combine_soldier/vo/star.wav" },
		{ title = "Район станции", text = "Район станции.", sound = "npc/metropolice/vo/stationblock.wav" },
		{ title = "Внимательно", text = "Внимательно.", sound = "npc/combine_soldier/vo/stayalert.wav" },
		{ title = "Стерилизовать", text = "Стерилизовать!", sound = "npc/metropolice/vo/sterilize.wav" },
		{ title = "Буря", text = "Буря.", sound = "npc/combine_soldier/vo/storm.wav" },
		{ title = "Гарпун", text = "Гарпун.", sound = "npc/combine_soldier/vo/striker.wav" },
		{ title = "Объект 505", text = "Объект, код 505!", sound = "npc/metropolice/vo/subjectis505.wav" },
		{ title = "Объект движется быстро", text = "Всем постам, объект движется на большой скорости!", sound = "npc/metropolice/vo/subjectisnowhighspeed.wav" },
		{ title = "Объект", text = "Объект!", sound = "npc/metropolice/vo/subject.wav" },
		{ title = "Сильва", text = "Сильва.", sound = "npc/combine_soldier/vo/sundown.wav" },
		{ title = "Зафиксировано нападение", text = "Пр��дположительно зафиксировано нападение.", sound = "npc/metropolice/vo/dispreportssuspectincursion.wav" },
		{ title = "Новая позиция объекта", text = "Новое местонахождение объекта...", sound = "npc/metropolice/vo/supsecthasnowmovedto.wav" },
		{ title = "Объект идёт по каналам", text = "Объект идёт по узким каналам в...", sound = "npc/metropolice/vo/suspectusingrestrictedcanals.wav" },
		{ title = "Прекратить", text = "Прекратить!", sound = "npc/metropolice/vo/suspend.wav" },
		{ title = "Гусар", text = "Гусар.", sound = "npc/combine_soldier/vo/sweeper.wav" },
		{ title = "Выдвигаюсь", text = "Выдвигаюсь!", sound = "npc/combine_soldier/vo/sweepingin.wav" },
		{ title = "Продолжаю поиск", text = "Продолжаю поиск!", sound = "npc/metropolice/vo/sweepingforsuspect.wav" },
		{ title = "Гепард", text = "Гепард.", sound = "npc/combine_soldier/vo/swift.wav" },
		{ title = "Булат", text = "Булат.", sound = "npc/combine_soldier/vo/sword.wav" },
		{ title = "Есть 10-91Д", text = "Есть 10-91Д.", sound = "npc/metropolice/vo/tag10-91d.wav" },
		{ title = "Жук убит", text = "Жук убит!", sound = "npc/metropolice/vo/tagonebug.wav" },
		{ title = "Зомби убит", text = "Зомб�� убит!", sound = "npc/metropolice/vo/tagonenecrotic.wav" },
		{ title = "Паразит уничтожен", text = "Паразит уничтожен!", sound = "npc/metropolice/vo/tagoneparasitic.wav" },
		{ title = "Собираюсь посмотреть", text = "Собираюсь посмотреть!", sound = "npc/metropolice/vo/goingtotakealook.wav" },
		{ title = "Иду в укрытие", text = "Иду в укрытие!", sound = "npc/metropolice/vo/takecover.wav" },
		{ title = "Стук", text = "Стук!", sound = "npc/metropolice/vo/tap.wav" },
		{ title = "Цель", text = "Цель.", sound = "npc/combine_soldier/vo/target.wav" },
		{ title = "Отряд на позиции, вперёд", text = "Отряд на позиции, вперёд!.", sound = "npc/metropolice/vo/teaminpositionadvance.wav" },
		{ title = "Команда стабилизации на позиции", text = "Команда стабилизации на позициях.", sound = "npc/combine_soldier/vo/stabilizationteamholding.wav" },
		{ title = "Вижу его", text = "Вижу его в...", sound = "npc/metropolice/vo/therehegoeshesat.wav" },
		{ title = "Вон он", text = "Вон он!", sound = "npc/metropolice/vo/thereheis.wav" },
		{ title = "Следопыт", text = "Следопыт.", sound = "npc/combine_soldier/vo/tracker.wav" },
		{ title = "Транзитный район", text = "Транзитный райо��.", sound = "npc/metropolice/vo/transitblock.wav" },
		{ title = "Неприятности?", text = "Ищешь непр��ятности?", sound = "npc/metropolice/vo/lookingfortrouble.wav" },
		{ title = "Офицер под огнём", text = "Офицер под огнём, ухожу в укрытие!", sound = "npc/metropolice/vo/officerunderfiretakingcover.wav" },
		{ title = "Союз", text = "Союз!", sound = "npc/metropolice/vo/union.wav" },
		{ title = "Объектов нет", text = "В зоне объектов нет.", sound = "npc/metropolice/vo/suspectlocationunknown.wav" },
		{ title = "Вот он", text = "Вот он!", sound = "npc/metropolice/vo/hesupthere.wav" },
		{ title = "Неизвестный", text = "Неизвестный.", sound = "npc/metropolice/vo/upi.wav" },
		{ title = "Объект не обнаружен", text = "Объект не обнаружен.", sound = "npc/metropolice/vo/utlthatsuspect.wav" },
		{ title = "Объект не обнаружен", text = "Объект не обнаружен.", sound = "npc/metropolice/vo/utlsuspect.wav" },
		{ title = "Удалить его", text = "Удалить его!", sound = "npc/metropolice/vo/vacatecitizen.wav" },
		{ title = "Бобер", text = "Бобер.", sound = "npc/combine_soldier/vo/vamp.wav" },
		{ title = "Хочешь в участок?", text = "Хочешь в участок?", sound = "npc/metropolice/vo/youwantamalcomplianceverdict.wav" },
		{ title = "Порок", text = "Порок!", sound = "npc/metropolice/vo/vice.wav" },
		{ title = "Виктор", text = "Виктор!", sound = "npc/metropolice/vo/victor.wav" },
		{ title = "Контакт", text = "Контакт.", sound = "npc/combine_soldier/vo/viscon.wav" },
		{ title = "Опасные формы жизни", text = "Опасные формы жизни.", sound = "npc/combine_soldier/vo/visualonexogen.wav" },
		{ title = "Второе предупреждение", text = "Второе предупреждение!", sound = "npc/metropolice/vo/secondwarning.wav" },
		{ title = "Река", text = "Река.", sound = "npc/metropolice/vo/wasteriver.wav" },
		{ title = "Осторожно", text = "Осторожно!", sound = "npc/metropolice/vo/watchit.wav" },
		{ title = "Набор рабочих", text = "Набор рабочих.", sound = "npc/metropolice/vo/workforceintake.wav" },
		{ title = "Добей его", text = "Отлично, добей его.", sound = "npc/combine_soldier/vo/thatsitwrapitup.wav" },
		{ title = "Рентген", text = "Рентген!", sound = "npc/metropolice/vo/xray.wav" },
		{ title = "Желтый", text = "Желтый!", sound = "npc/metropolice/vo/yellow.wav" },
		{ title = "YEP", text = "Yep.", sound = "npc/metropolice/mc1ans_yep.wav" },
		{ title = "Можешь идти", text = "Порядок, можешь идти.", sound = "npc/metropolice/vo/allrightyoucango.wav" },
		{ title = "Зона", text = "Зона!", sound = "npc/metropolice/vo/zone.wav" },
	}
}
rp.cfg.VoiceCommands[TEAMTYPE_SUP] = rp.cfg.VoiceCommands[TEAMTYPE_COMBINE]
rp.cfg.VoiceCommands[TEAMTYPE_CWU] = rp.cfg.VoiceCommands[TEAMTYPE_CITIZEN]
rp.cfg.VoiceCommands[TEAMTYPE_RABEL] = rp.cfg.VoiceCommands[TEAMTYPE_CITIZEN]
rp.cfg.VoiceCommands[TEAMTYPE_LOYAL] = rp.cfg.VoiceCommands[TEAMTYPE_CITIZEN]

rp.cfg.DefaultModels = {
	['0'] = {
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
		'models/tnb/citizens/male_11.mdl',
		'models/tnb/citizens/male_12.mdl',
		'models/tnb/citizens/male_13.mdl',
		'models/tnb/citizens/male_14.mdl',
		'models/tnb/citizens/male_15.mdl',
		'models/tnb/citizens/male_16.mdl',
		'models/tnb/citizens/male_17.mdl',
		'models/tnb/citizens/male_18.mdl',
		'models/tnb/citizens/male_20.mdl',
		'models/tnb/citizens/male_21.mdl',
		'models/tnb/citizens/male_22.mdl',
		'models/tnb/citizens/male_23.mdl',
		'models/tnb/citizens/male_24.mdl',
		'models/tnb/citizens/male_25.mdl',
		'models/tnb/citizens/male_26.mdl',
		'models/tnb/citizens/male_27.mdl',
		'models/tnb/citizens/male_28.mdl',
		'models/tnb/citizens/male_29.mdl',
		'models/tnb/citizens/male_30.mdl',
		'models/tnb/citizens/male_31.mdl',
		'models/tnb/citizens/male_32.mdl',
		'models/tnb/citizens/male_33.mdl',
		'models/tnb/citizens/male_34.mdl',
		'models/tnb/citizens/male_35.mdl',
		'models/tnb/citizens/male_36.mdl',
		'models/tnb/citizens/male_37.mdl',
		'models/tnb/citizens/male_38.mdl',
		'models/tnb/citizens/male_39.mdl',
		'models/tnb/citizens/male_40.mdl',
		'models/tnb/citizens/male_41.mdl',
		'models/tnb/citizens/male_42.mdl',
		'models/tnb/citizens/male_43.mdl',
		'models/tnb/citizens/male_44.mdl',
		'models/tnb/citizens/male_45.mdl',
		'models/tnb/citizens/male_46.mdl',
		'models/tnb/citizens/male_47.mdl',
		'models/tnb/citizens/male_48.mdl',
		'models/tnb/citizens/male_49.mdl',
		'models/tnb/citizens/male_50.mdl',
		'models/tnb/citizens/male_51.mdl',
		'models/tnb/citizens/male_52.mdl',
		'models/tnb/citizens/male_53.mdl',
		'models/tnb/citizens/male_54.mdl',
		'models/tnb/citizens/male_55.mdl',
		'models/tnb/citizens/male_56.mdl',
		'models/tnb/citizens/male_57.mdl',
		'models/tnb/citizens/male_58.mdl',
		'models/tnb/citizens/male_59.mdl',
		'models/tnb/citizens/male_60.mdl',
		'models/tnb/citizens/male_61.mdl',
		'models/tnb/citizens/male_62.mdl',
		'models/tnb/citizens/male_63.mdl',
		'models/tnb/citizens/male_64.mdl',
		'models/tnb/citizens/male_65.mdl',
		'models/tnb/citizens/male_66.mdl',
		'models/tnb/citizens/male_67.mdl',
		'models/tnb/citizens/male_68.mdl',
		'models/tnb/citizens/male_69.mdl',
		'models/tnb/citizens/male_70.mdl',
		'models/tnb/citizens/male_71.mdl',
		'models/tnb/citizens/male_72.mdl',
		'models/tnb/citizens/male_73.mdl',
		'models/tnb/citizens/male_74.mdl',
		'models/tnb/citizens/male_75.mdl',
		'models/tnb/citizens/male_76.mdl',
		'models/tnb/citizens/male_77.mdl',
		'models/tnb/citizens/male_78.mdl',
		'models/tnb/citizens/male_79.mdl',
		'models/tnb/citizens/male_80.mdl',
		'models/tnb/citizens/male_81.mdl',
		'models/tnb/citizens/male_82.mdl',
		'models/tnb/citizens/male_83.mdl',
		'models/tnb/citizens/male_84.mdl',
		'models/tnb/citizens/male_85.mdl',
		'models/tnb/citizens/male_86.mdl',
		'models/tnb/citizens/male_87.mdl',
		'models/tnb/citizens/male_88.mdl',
		'models/tnb/citizens/male_89.mdl',
		'models/tnb/citizens/male_90.mdl',
		'models/tnb/citizens/male_91.mdl',
		'models/tnb/citizens/male_92.mdl',
		'models/tnb/citizens/male_93.mdl',
		'models/tnb/citizens/male_94.mdl',
		'models/tnb/citizens/male_95.mdl',
		'models/tnb/citizens/male_96.mdl',
		'models/tnb/citizens/male_97.mdl',
		'models/tnb/citizens/male_98.mdl',
	},
	['1'] = {
		'models/tnb/citizens/female_01.mdl',
		'models/tnb/citizens/female_02.mdl',
		'models/tnb/citizens/female_03.mdl',
		'models/tnb/citizens/female_04.mdl',
		'models/tnb/citizens/female_05.mdl',
		'models/tnb/citizens/female_06.mdl',
		'models/tnb/citizens/female_07.mdl',
		'models/tnb/citizens/female_08.mdl',
		'models/tnb/citizens/female_09.mdl',
		'models/tnb/citizens/female_10.mdl',
		'models/tnb/citizens/female_11.mdl',
		'models/tnb/citizens/female_12.mdl',
		'models/tnb/citizens/female_13.mdl',
		'models/tnb/citizens/female_14.mdl',
		'models/tnb/citizens/female_15.mdl',
		'models/tnb/citizens/female_16.mdl',
		'models/tnb/citizens/female_17.mdl',
		'models/tnb/citizens/female_18.mdl',
		'models/tnb/citizens/female_19.mdl',
		'models/tnb/citizens/female_20.mdl',
		'models/tnb/citizens/female_21.mdl',
		'models/tnb/citizens/female_22.mdl',
		'models/tnb/citizens/female_23.mdl',
		'models/tnb/citizens/female_24.mdl',
		'models/tnb/citizens/female_25.mdl',
		'models/tnb/citizens/female_26.mdl',
		'models/tnb/citizens/female_27.mdl',
		'models/tnb/citizens/female_28.mdl',
		'models/tnb/citizens/female_29.mdl',
		'models/tnb/citizens/female_30.mdl',
		'models/tnb/citizens/female_31.mdl',
		'models/tnb/citizens/female_32.mdl',
		'models/tnb/citizens/female_33.mdl',
		'models/tnb/citizens/female_34.mdl',
		'models/tnb/citizens/female_35.mdl',
		'models/tnb/citizens/female_36.mdl',
		'models/tnb/citizens/female_37.mdl',
		'models/tnb/citizens/female_38.mdl',
		'models/tnb/citizens/female_39.mdl',
		'models/tnb/citizens/female_40.mdl',
		'models/tnb/citizens/female_41.mdl',
		'models/tnb/citizens/female_42.mdl',
		'models/tnb/citizens/female_43.mdl',
		'models/tnb/citizens/female_44.mdl',
		'models/tnb/citizens/female_45.mdl',
		'models/tnb/citizens/female_46.mdl',
		'models/tnb/citizens/female_47.mdl',
		'models/tnb/citizens/female_48.mdl',
		'models/tnb/citizens/female_49.mdl',
		'models/tnb/citizens/female_50.mdl',
		'models/tnb/citizens/female_51.mdl',
		'models/tnb/citizens/female_52.mdl',
		'models/tnb/citizens/female_53.mdl',
		'models/tnb/citizens/female_54.mdl',
		'models/tnb/citizens/female_55.mdl',
		'models/tnb/citizens/female_56.mdl',
		'models/tnb/citizens/female_57.mdl',
		'models/tnb/citizens/female_58.mdl',
		'models/tnb/citizens/female_59.mdl',
		'models/tnb/citizens/female_60.mdl',
		'models/tnb/citizens/female_61.mdl',
		'models/tnb/citizens/female_62.mdl',
		'models/tnb/citizens/female_63.mdl',
		'models/tnb/citizens/female_64.mdl',
		'models/tnb/citizens/female_65.mdl',
		'models/tnb/citizens/female_66.mdl',
		'models/tnb/citizens/female_67.mdl',
		'models/tnb/citizens/female_68.mdl',
	}
}

