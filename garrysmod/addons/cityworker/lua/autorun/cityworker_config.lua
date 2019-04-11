CITYWORKER = CITYWORKER or {}

CITYWORKER.Config = CITYWORKER.Config or {}

--[[
  /$$$$$$  /$$   /$$                     /$$      /$$                     /$$
 /$$__  $$|__/  | $$                    | $$  /$ | $$                    | $$
| $$  \__/ /$$ /$$$$$$   /$$   /$$      | $$ /$$$| $$  /$$$$$$   /$$$$$$ | $$   /$$  /$$$$$$   /$$$$$$
| $$      | $$|_  $$_/  | $$  | $$      | $$/$$ $$ $$ /$$__  $$ /$$__  $$| $$  /$$/ /$$__  $$ /$$__  $$
| $$      | $$  | $$    | $$  | $$      | $$$$_  $$$$| $$  \ $$| $$  \__/| $$$$$$/ | $$$$$$$$| $$  \__/
| $$    $$| $$  | $$ /$$| $$  | $$      | $$$/ \  $$$| $$  | $$| $$      | $$_  $$ | $$_____/| $$
|  $$$$$$/| $$  |  $$$$/|  $$$$$$$      | $$/   \  $$|  $$$$$$/| $$      | $$ \  $$|  $$$$$$$| $$
 \______/ |__/   \___/   \____  $$      |__/     \__/ \______/ |__/      |__/  \__/ \_______/|__/
                         /$$  | $$
                        |  $$$$$$/
                         \______/

                                                v1.0.0
                                    By: Silhouhat (76561198072551027)
                                      Licensed to: 76561198046491539

--]]

-- How often should we check (in seconds) for City Workers with no assigned jobs, so we can give them?
CITYWORKER.Config.Time = 15

local citizen_models = {
    --female/женщ
    "models/player/tnb/citizens/female_01.mdl",
    "models/player/tnb/citizens/female_02.mdl",
    "models/player/tnb/citizens/female_03.mdl",
    "models/player/tnb/citizens/female_04.mdl",
    "models/player/tnb/citizens/female_05.mdl",
    "models/player/tnb/citizens/female_06.mdl",
    "models/player/tnb/citizens/female_07.mdl",
    "models/player/tnb/citizens/female_08.mdl",
    "models/player/tnb/citizens/female_09.mdl",
    "models/player/tnb/citizens/female_10.mdl",
    "models/player/tnb/citizens/female_11.mdl",
    --male/мужч
    "models/player/tnb/citizens/male_01.mdl",
    "models/player/tnb/citizens/male_02.mdl",
    "models/player/tnb/citizens/male_03.mdl",
    "models/player/tnb/citizens/male_04.mdl",
    "models/player/tnb/citizens/male_05.mdl",
    "models/player/tnb/citizens/male_06.mdl",
    "models/player/tnb/citizens/male_07.mdl",
    "models/player/tnb/citizens/male_08.mdl",
    "models/player/tnb/citizens/male_09.mdl",
    "models/player/tnb/citizens/male_10.mdl",
    --"models/player/tnb/citizens/male_11.mdl",
    --"models/player/tnb/citizens/male_12.mdl",
    --"models/player/tnb/citizens/male_13.mdl",
    --"models/player/tnb/citizens/male_14.mdl",
    --"models/player/tnb/citizens/male_15.mdl",
    --"models/player/tnb/citizens/male_16.mdl",
    --"models/player/tnb/citizens/male_17.mdl",
    --"models/player/tnb/citizens/male_18.mdl",
}


-- Configuration for the DarkRP job.
-- CITYWORKER.Config.Job = {
--     name = "Сотрудник ГСР",

--     color = Color(236, 204, 104),
--     model = citizen_models,
--     description = [[Представитель гражданского союза рабочих, выдает прибывшим в сити гражданам различного рода работу.]],
--     weapons = {"cityworker_pliers", "cityworker_shovel", "cityworker_wrench", "id4"},
--     command = "cwu",
--     max = 0,
--     salary = 45,
--     admin = 0,
--     hasLicense = false,
--     candemote = true,

--     type = "cwu",
--     unlockCost = 8000,
--     OnPlayerChangedTeam = function(ply)
--         timer.Simple(0.1, function()
--             ply:SetBodygroup(2, 2)
--             ply:SetBodygroup(3, 0)
--             ply:SetBodygroup(4, 0)
--             ply:SetBodygroup(5, 0)
--             ply:SetSkin(2)
--             ply:SetModel(ply:getRegisteredModel())
--         end)
--     end,
-- }

------------
-- RUBBLE --
------------

CITYWORKER.Config.Rubble = {}

-- Whether or not rubble is enabled or disabled.
CITYWORKER.Config.Rubble.Enabled = true

-- Rubble models and the range of time (in seconds) it takes to clear them.
CITYWORKER.Config.Rubble.Models = {
    ["models/props_debris/concrete_debris128pile001a.mdl"] = { min = 20, max = 30 },
    ["models/props_debris/concrete_debris128pile001b.mdl"] = { min = 10, max = 15 },
    ["models/props_debris/concrete_floorpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_cornerpile01a.mdl"] = { min = 10, max = 20 },
    ["models/props_debris/concrete_spawnplug001a.mdl"] = { min = 5, max = 10 },
    ["models/props_debris/plaster_ceilingpile001a.mdl"] = { min = 10, max = 15 },
}

-- Payout per second it takes to clear a given pile of rubble.
-- (i.e. 10 seconds = 10 * 30 = 300)
CITYWORKER.Config.Rubble.Payout = 9

-------------------
-- FIRE HYDRANTS --
-------------------

CITYWORKER.Config.FireHydrant = {}

-- Whether or not fire hydrants are enabled or disabled.
CITYWORKER.Config.FireHydrant.Enabled = false

-- The range for how long it takes to fix a fire hydrant.
-- Maximum value: 255 seconds.
CITYWORKER.Config.FireHydrant.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix a fire hydrant.
CITYWORKER.Config.FireHydrant.Payout = 8

-----------
-- LEAKS --
-----------

CITYWORKER.Config.Leak = CITYWORKER.Config.Leak or {}

-- Whether or not leaks are enabled or disabled.
CITYWORKER.Config.Leak.Enabled = true

-- The range for how long it takes to fix a leak.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Leak.Time = { min = 10, max = 30 }

-- Payout per second it takes to fix a leak.
CITYWORKER.Config.Leak.Payout = 14

--------------
-- ELECTRIC --
--------------

CITYWORKER.Config.Electric = CITYWORKER.Config.Electric or {}

-- Whether or not electrical problems are enabled or disabled.
CITYWORKER.Config.Electric.Enabled = true

-- The range for how long it takes to fix an electrical problem.
-- Maximum value: 255 seconds.
CITYWORKER.Config.Electric.Time = { min = 20, max = 30 }

-- Payout per second it takes to fix an electrical problem.
CITYWORKER.Config.Electric.Payout = 13

----------------------------
-- LANGUAGE CONFIGURATION --
----------------------------

CITYWORKER.Config.Language = {
    ["FireHydrant"]         = "Чиню Гидрант...",
    ["Leak"]                = "Исправляю утечку..",
    ["Electric"]            = "Исправляю проблемы с Электроснабжением...",
    ["Rubble"]              = "Убираю Завал...",

    ["CANCEL"]              = "Нажмите F2 для отмены.",
    ["PAYOUT"]              = "Вы получили %s за свою работу!",
    ["CANCEL"]              = "Вы отменили действие!",
    ["NEW_JOB"]             = "У вас есть новая работа!",
    ["NOT_CITY_WORKER"]     = "Вы не Сотрудник ГСР!",
    ["JOB_WORKED"]          = "Тут всё исправлено!",
    ["ASSIGNED_ELSE"]       = "Другой Сотрудник ГСР уже занялся данной проблемой!",
}
