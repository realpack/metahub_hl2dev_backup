IGS.ProtectedCall(function() -- IGS.C.SOCKETPORT будет лишь внутри
	if !SOCKY then
		for i = 1,10 do
			IGS.print(Color(255,255 - i * 22,i * 10),
				" >>> Сокет модуль не установлен. " ..
				"Убедитесь, что в /lua/bin есть .dll файл. " ..
				"ДЕНЬГИ БУДУТ НАЧИСЛЯТЬСЯ ПОСЛЕ ПЕРЕЗАХОДА <<< "
			)
		end

		return
	end

	if !IGS.C.SOCKETPORT then
		IGS.print(Color(250,50,50), "Порт сокета не установлен!!")
		return
	end

	IGS.SOCK = SOCKY( IGS.C.SOCKETPORT )

	local OBJ = IGS.SOCK
	OBJ:SetBurstLimit(50, 60) -- 50 messages per minute

	OBJ:AddCallback(function(clOBJ)
		local cl = clOBJ.sock -- :receive некорректно работает на объект

		-- local all = cl:receive("*a")
		-- print("all", all)

		local pass = cl:receive(32)
		IGS.dprint("SOCK: PASS", pass)
		SOCKY.assert(clOBJ, pass == IGS.C.ProjectKey, "Incorrect IGS pass: " .. tostring(pass), 5)

		local size = tonumber(cl:receive(6))
		IGS.dprint("SOCK: SIZE", size)
		local sDat = cl:receive(size)

		local tDat = SOCKY.assert(clOBJ, util.JSONToTable(sDat), "Мусор вместо JSON: " .. sDat)
		if !tDat.ok then
			IGS.LogError(tDat.error)
			return
		end

		if IGS.DEBUG then
			PrintTable(tDat)
		end

		-- {cp = true/false, data = {}, ok = true, method = "payment"}
		hook.Run("IGS.NewSocketMessage", tDat.data, tDat.method, tDat)
	end, "IGS")
end)
