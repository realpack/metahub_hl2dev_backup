local function GetAllFiles( tab, folder, extension, path )
	local files, folders = file.Find( folder .. "/*", path )

	for k, v in ipairs( files ) do
		if ( v:EndsWith( extension ) ) then
			tab[#tab+1] = (folder .. v):lower()
		end
	end
	
	local i = 1
	local function doRecurse()
		GetAllFiles(tab, folder .. folders[i] .. "/", extension, path)
		i = i + 1
		
		if (folders[i]) then
			timer.Simple(0.1, doRecurse)
		else
			hook.Run( "SearchUpdate" ) 
		end
	end

	if (folders[1]) then
		doRecurse()
	else
		hook.Run("SearchUpdate")
	end
end


local model_list = nil
search.AddProvider(function(str)
	str = str:PatternSafe()

	if (model_list == nil) then
		model_list = {}
		GetAllFiles(model_list, "models/", ".mdl", "GAME")
	end

	local list = {}
	for k, v in ipairs(model_list) do
		if (v:find(str)) then
			if (UTIL_IsUselessModel(v)) then continue end

			local entry = {
				text = v:GetFileFromFilename(),
				func = function() RunConsoleCommand("gm_spawn", v) end,
				icon = spawnmenu.CreateContentIcon("model", g_SpawnMenu.SearchPropPanel, {model = v}),
				words = {v}
			}
			
			list[#list+1] = entry
			if (#list >= 128) then break end
		end
	end

	return list
end);