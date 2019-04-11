--[[-------------------------------------------------------------------------
	Лаунчер убеждается в том, что все необходимые данные могут быть загружены
	для предотвращения неизбежных ошибок во время работы без них
---------------------------------------------------------------------------]]
-- IGS.sh("dependencies/dep_sh.lua")
IGS.cl("dependencies/dep_cl.lua")

IGS.sh("dependencies/plurals.lua")
IGS.sh("dependencies/chatprint.lua")

IGS.sv("dependencies/queue.lua")
IGS.sv("dependencies/http.lua")

-- Антиконфликт с https://trello.com/c/3ti6xIjW/
IGS.sh("dependencies/dash/nw.lua")

-- if !dash then
IGS.sh("dependencies/dash/cmd.lua")
IGS.sh("dependencies/dash/hash.lua")
IGS.sh("dependencies/dash/misc.lua")
IGS.cl("dependencies/dash/wmat.lua")



IGS.sh("network/nw_sh.lua") -- для igs_servers в скором времени


-- Метаобъекты
IGS.dir("objects", IGS.sh)

-- IGS.sh("settings/config_sh.lua") -- тут не нужен еще
IGS.sv("settings/config_sv.lua") -- для фетча project key (Генерация подписи)


local ok = IGS.sv("fuse_sv.lua") -- предохранитель. Чтобы не загружался мусор
if SERVER and !ok then return end


IGS.sv("core_sv.lua") -- для фетча подписи

IGS.sv("apinator.lua")

-- После датапровайдера, хотя сработают все равно после первого входа игрока
IGS.sh("servers/serv_sh.lua")
IGS.sv("servers/serv_sv.lua")





--[[-------------------------------------------------------------------------
	Второй "этап" (для работы требовал загрузку серверов)
---------------------------------------------------------------------------]]
IGS.sh("settings/config_sh.lua")

IGS.sh("utils/ut_sh.lua")
IGS.sv("utils/ut_sv.lua")
IGS.cl("utils/ut_cl.lua")



IGS.sv("dependencies/resources.lua") -- иконки, моделька дропнутого итема

-- Нельзя ниже sh_additems
IGS.dir("extensions", IGS.sh)

IGS.sh("settings/sh_additems.lua")
IGS.sh("settings/sh_addlevels.lua")

IGS.sv("network/net_sv.lua")
IGS.cl("network/net_cl.lua")

-- если перенести отсюда выше, то могут начаться проблемы, связанные неизвестно с чем (bib nil)
IGS.sh("dependencies/bib.lua")

IGS.cl("interface/skin.lua")
-- IGS.cl("core_cl.lua")

-- Подключение VGUI компонентов
IGS.dir("interface/vgui", IGS.cl)

IGS.WIN = IGS.WIN or {}

IGS.cl("interface/core.lua")

IGS.dir("interface/activities", IGS.cl)
IGS.dir("interface/windows", IGS.cl)

IGS.dir("modules", nil, true)

IGS.sv("processor_sv.lua") -- начинаем обработку всего серверного в конце


--[[------------------------------
	Уродский кусок пост хуков
--------------------------------]]
if SERVER then
	IGS.ProtectedCall(function()
		hook.Run("IGS.Initialized") -- можно выполнять запросы (IGS.GetReady == true) (после установки igs_servers)
	end)
else
	hook.Add("IGS.OnSettingsUpdated","IGS.Initialized",function()
		hook.Run("IGS.Initialized")
	end)
end

hook.Run("IGS.Loaded") -- можно создавать итемы
