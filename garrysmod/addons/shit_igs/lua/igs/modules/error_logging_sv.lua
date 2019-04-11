hook.Add("IGS.OnApiError", "LogError", function(sObject, sMethod, REQ)
	local err  = REQ.response.error
	local body = REQ.response.body
	local par  = REQ.p

	if err == "http_error" then
		IGS.print(Color(255,0,0), "CEPBEPA GMD BPEMEHHO HE9OCTynHbI. y}{e PEWAEM nPO6JIEMy")
	end

	-- if IGS.DEBUG then
		-- PrintTable(d)
		IGS.print("Method:",sObject .. "/" .. sMethod)
		IGS.print("Error: " .. err)
		if err == "invalid_response" then
			IGS.print(body)
		end
		PrintTable(par)
	-- end

	local sparams = "\n"
	for k,v in pairs(par) do
		sparams = sparams .. ("\t%s = %s\n"):format(k,v)
	end

	local split = string.rep("-",50)
	local err_log =
		os.date("%Y-%m-%d %H:%M\n") ..
		split ..
		"\nMethod: " .. sMethod ..
		"\nError: "  .. err ..
		"\nParams: " .. sparams ..
		split .. "\n\n\n"


	file.Append("igs_errors.txt",err_log)
end)
