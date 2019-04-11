if SERVER then
timer.Simple(1,
	function()
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;
		   
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."", "DATA");
		end;
		
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."/factories/", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."/factories/", "DATA");
		end;
	 
		for k, v in pairs(file.Find("jb/"..string.lower(game.GetMap()).."/factories/*.txt", "DATA")) do
			local factoryPosFile = file.Read("jb/"..string.lower(game.GetMap()).."/factories/"..v, "DATA");
			 
			local spawnNumber = string.Explode(" ", factoryPosFile);         
				   
			local factory = ents.Create("mgs_factory");
			factory:SetPos(Vector(spawnNumber[1], spawnNumber[2], spawnNumber[3]+30));
			factory:SetAngles(Angle(tonumber(spawnNumber[4]), spawnNumber[5], spawnNumber[6]));
			factory:Spawn();
			factory:GetPhysicsObject():EnableMotion(false);
		end;
	end
	);
	 
	function spawnfactoryPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local filefactoryName = args[1];
               
            if !filefactoryName then
                ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Choose a uniqueID for your Mining System.]] } chat.AddText(unpack(tab))");
                return;
            end;
		
			if file.Exists( "jb/"..string.lower(game.GetMap()).."/factories/mgs_factory_".. filefactoryName ..".txt", "DATA") then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[This uniqueID is already in use, choose another one or type 'mgs_factory_remove "..filefactoryName.."' in console to remove this one.]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
			local factoryVector = string.Explode(" ", tostring(ply:GetEyeTrace().HitPos));
			local factoryAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
			
			local factory = ents.Create("mgs_factory");
			factory:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,30));
			factory:SetAngles(ply:GetAngles()+Angle(0, -180, 0));
			factory:Spawn();
			factory:GetPhysicsObject():EnableMotion(false);
					
			file.Write("jb/"..string.lower(game.GetMap()).."/factories/mgs_factory_".. filefactoryName ..".txt", ""..(factoryVector[1]).." "..(factoryVector[2]).." "..(factoryVector[3]).." "..(factoryAngles[1]).." "..(factoryAngles[2]).." "..(factoryAngles[3]).."", "DATA");
			ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[New pos for the Mining System has been set.]] } chat.AddText(unpack(tab))");
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");
		end;
	end;
	concommand.Add("mgs_factory_spawn", spawnfactoryPos);
	 
	function removefactoryPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local filefactoryName = args[1];
				   
			if !filefactoryName then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Please enter a name of file!]] } chat.AddText(unpack(tab))");
				return;
			end;
					   
			if file.Exists("jb/"..string.lower(game.GetMap()).."/factories/mgs_factory_"..filefactoryName..".txt", "DATA") then
				file.Delete("jb/"..string.lower(game.GetMap()).."/factories/mgs_factory_"..filefactoryName..".txt");
				ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[This Mining System has been removed. Restart your server!]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Mining System - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("mgs_factory_remove", removefactoryPos);
end