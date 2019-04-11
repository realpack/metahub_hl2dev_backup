if SERVER then
timer.Simple(1,
	function()
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;
		   
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."", "DATA");
		end;
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."/mgs_rock/", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."/mgs_rock/", "DATA");
		end;
	 
		for k, v in pairs(file.Find("jb/"..string.lower(game.GetMap()).."/mgs_rock/*.txt", "DATA")) do
			local rockPosFile = file.Read("jb/"..string.lower(game.GetMap()).."/mgs_rock/"..v, "DATA");
			 
			local spawnNumber = string.Explode(" ", rockPosFile);         
				   
			local rock = ents.Create("mgs_rock");
			rock:SetPos(Vector(spawnNumber[1], spawnNumber[2], spawnNumber[3]));
			rock:SetAngles(Angle(tonumber(spawnNumber[4]), spawnNumber[5], spawnNumber[6]));
			rock:Spawn();
			rock:SetMoveType(MOVETYPE_NONE)
			rock:GetPhysicsObject():EnableMotion(false);
		end;
	end
	);
	 
	function spawnrockPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local filerockName = args[1];
               
            if !filerockName then
                ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Choose a uniqueID for your rock.]] } chat.AddText(unpack(tab))");
                return;
            end;
		
			if file.Exists( "jb/"..string.lower(game.GetMap()).."/mgs_rock/mgs_rock_".. filerockName ..".txt", "DATA") then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[This uniqueID is already in use, choose another one or type 'swm_rock_remove "..filerockName.."' in console to remove this one.]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
			local rockVector = string.Explode(" ", tostring(ply:GetEyeTrace().HitPos));
			local rockAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
					
			local rock = ents.Create("mgs_rock");
			rock:SetPos(ply:GetEyeTrace().HitPos);
			rock:SetAngles(ply:GetAngles()+Angle(0, -180, 0));
			rock:Spawn();
			rock:SetMoveType(MOVETYPE_NONE)
			rock:GetPhysicsObject():EnableMotion(false);
					
			file.Write("jb/"..string.lower(game.GetMap()).."/mgs_rock/mgs_rock_".. filerockName ..".txt", ""..(rockVector[1]).." "..(rockVector[2]).." "..(rockVector[3]).." "..(rockAngles[1]).." "..(rockAngles[2]).." "..(rockAngles[3]).."", "DATA");
			ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[New pos for the rock has been set.]] } chat.AddText(unpack(tab))");
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");
		end;
	end;
	concommand.Add("mgs_rock_spawn", spawnrockPos);
	 
	function removerockPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local filerockName = args[1];
				   
			if !filerockName then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Please enter a name of file!]] } chat.AddText(unpack(tab))");
				return;
			end;
					   
			if file.Exists("jb/"..string.lower(game.GetMap()).."/mgs_rock/mgs_rock_"..filerockName..".txt", "DATA") then
				file.Delete("jb/"..string.lower(game.GetMap()).."/mgs_rock/mgs_rock_"..filerockName..".txt");
				ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[This rock has been removed. Restart your server!]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("mgs_rock_remove", removerockPos);
end