if SERVER then
timer.Simple(1,
	function()
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;
		   
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."", "DATA");
		end;
		
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."/sawmills/", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."/sawmills/", "DATA");
		end;
	 
		for k, v in pairs(file.Find("jb/"..string.lower(game.GetMap()).."/sawmills/*.txt", "DATA")) do
			local sawmillPosFile = file.Read("jb/"..string.lower(game.GetMap()).."/sawmills/"..v, "DATA");
			 
			local spawnNumber = string.Explode(" ", sawmillPosFile);         
				   
			local sawmill = ents.Create("swm_sawmill");
			sawmill:SetPos(Vector(spawnNumber[1], spawnNumber[2], spawnNumber[3]+30));
			sawmill:SetAngles(Angle(tonumber(spawnNumber[4]), spawnNumber[5], spawnNumber[6]));
			sawmill:Spawn();
			sawmill:GetPhysicsObject():EnableMotion(false);
		end;
	end
	);
	 
	function spawnSawmillPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileSawmillName = args[1];
               
            if !fileSawmillName then
                ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Choose a uniqueID for your Sawmill.]] } chat.AddText(unpack(tab))");
                return;
            end;
		
			if file.Exists( "jb/"..string.lower(game.GetMap()).."/sawmills/swm_sawmill_".. fileSawmillName ..".txt", "DATA") then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[This uniqueID is already in use, choose another one or type 'swm_sawmill_remove "..fileSawmillName.."' in console to remove this one.]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
			local sawmillVector = string.Explode(" ", tostring(ply:GetEyeTrace().HitPos));
			local sawmillAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
			
			local sawmill = ents.Create("swm_sawmill");
			sawmill:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,30));
			sawmill:SetAngles(ply:GetAngles()+Angle(0, -180, 0));
			sawmill:Spawn();
			sawmill:GetPhysicsObject():EnableMotion(false);
					
			file.Write("jb/"..string.lower(game.GetMap()).."/sawmills/swm_sawmill_".. fileSawmillName ..".txt", ""..(sawmillVector[1]).." "..(sawmillVector[2]).." "..(sawmillVector[3]).." "..(sawmillAngles[1]).." "..(sawmillAngles[2]).." "..(sawmillAngles[3]).."", "DATA");
			ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[New pos for the Sawmill has been set.]] } chat.AddText(unpack(tab))");
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");
		end;
	end;
	concommand.Add("swm_sawmill_spawn", spawnSawmillPos);
	 
	function removeSawmillPos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileSawmillName = args[1];
				   
			if !fileSawmillName then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Please enter a name of file!]] } chat.AddText(unpack(tab))");
				return;
			end;
					   
			if file.Exists("jb/"..string.lower(game.GetMap()).."/sawmills/swm_sawmill_"..fileSawmillName..".txt", "DATA") then
				file.Delete("jb/"..string.lower(game.GetMap()).."/sawmills/swm_sawmill_"..fileSawmillName..".txt");
				ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[This Sawmill has been removed. Restart your server!]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("swm_sawmill_remove", removeSawmillPos);
end