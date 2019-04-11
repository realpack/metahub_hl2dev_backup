-- Юзается в функции IGS.Play для получения полной ссылки на звук
function IGS.GetSoundUrl(sSongUID)
	return IGS.C.SOUNDSURL .. IGS.C.RAG_SOUNDS[sSongUID] .. ".mp3"
end

-- Используется в основном в extra для воспроизведения звуков из Иисусьей тряпки
-- IGS.Play("ZAPLATITE_LI")
local fallback = function() end
function IGS.Play(sSongUID, cb)
	if !IGS.C.EnableSounds then return end
	sound.PlayURL( IGS.GetSoundUrl(sSongUID),"", cb or fallback)
end


-- Норм название сервера по его ИД
-- Если вернут "-", значит сервер скорее всего, отключен
function IGS.ServerName(iID)
	local serv_name = iID == 0 and "Откл." or IGS.SERVERS(iID)
	      serv_name = serv_name or "-" -- IGS.SERVERS(iID) вернул nil
	      -- serv_name = serv_name[1]:upper() .. serv_name:sub(2) -- апперкейсит первую букву

	return serv_name
end








--[[---------------------------
	Всякие помощнички
	чтобы не делать копипасту
-----------------------------]]
function IGS.ProcessActivate(dbID,cb)
	IGS.Activate(dbID,function(err)
		if !err then
			IGS.ShowNotify("Благодарим вас за использование нашей системы!", "Успешная активация")
		else
			IGS.ShowNotify(err, "Ошибка активации")
		end

		if cb then
			cb(err)
		end
	end)
end