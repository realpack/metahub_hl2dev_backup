local err =
	!IGS.C.ProjectID and
	"Для работы автодоната нужно установить настройщик " ..
	"(Скачивать на странице проекта gm-donate.ru/panel)"

	-- Не указаны настройки
	or (IGS.C.ProjectID == 0 or IGS.C.ProjectKey == "") and
	"Укажите данные проекта в config_sv.lua !!! " ..
	"Без них автодонат не будет работать"

	-- Сингл или локалка
	or (game.SinglePlayer() or !game.IsDedicated()) and
	"Автодонат не работает в локалке и сингле"

if err then
	local function notif(pl,text)
		if IsValid(pl) then
			pl:ChatPrint(text)
		end
	end

	local function openURL(pl,url)
		if IsValid(pl) then
			pl:SendLua([[gui.OpenURL("]] .. url .. [[")]])
		end
	end

	hook.Add("PlayerInitialSpawn","IGSFail",function(pl)
		timer.Simple(20,function()
			timer.Create("IGSFail",1,60,function()
				notif(pl,"[IGS] " .. err)
			end)

			timer.Simple(30,function()
				openURL(pl,"https://gm-donate.ru/instructions")
			end)
		end)
	end)

	timer.Create("IGSFail",.5,0,function()
		MsgC(Color(255,0,0),err .. "\n")
	end)

	return false
end

return true