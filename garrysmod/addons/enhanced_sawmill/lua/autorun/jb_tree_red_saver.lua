if SERVER then
timer.Simple(1,
	function()
		if !file.IsDir("jb", "DATA") then
			file.CreateDir("jb", "DATA");
		end;
		   
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."", "DATA");
		end;
	 
		if !file.IsDir("jb/"..string.lower(game.GetMap()).."/redtree/", "DATA") then
			file.CreateDir("jb/"..string.lower(game.GetMap()).."/redtree/", "DATA");
		end;
	 
		for k, v in pairs(file.Find("jb/"..string.lower(game.GetMap()).."/redtree/*.txt", "DATA")) do
			local treePosFile = file.Read("jb/"..string.lower(game.GetMap()).."/redtree/"..v, "DATA");
			 
			local spawnNumber = string.Explode(" ", treePosFile);         
				   
			local tree = ents.Create("swm_wood_red");
			tree:SetPos(Vector(spawnNumber[1], spawnNumber[2], spawnNumber[3]));
			tree:SetAngles(Angle(tonumber(spawnNumber[4]), spawnNumber[5], spawnNumber[6]));
			tree:Spawn();
			tree:SetMoveType(MOVETYPE_NONE)
			tree:GetPhysicsObject():EnableMotion(false);
		end;
	end
	);
	 
	function spawnTreePos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileTreeName = args[1];
               
            if !fileTreeName then
                ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Choose a uniqueID for your tree.]] } chat.AddText(unpack(tab))");
                return;
            end;
		
			if file.Exists( "jb/"..string.lower(game.GetMap()).."/redtree/swm_wood_".. fileTreeName ..".txt", "DATA") then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[This uniqueID is already in use, choose another one or type 'swm_tree_red_remove "..fileTreeName.."' in console to remove this one.]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
			local treeVector = string.Explode(" ", tostring(ply:GetEyeTrace().HitPos));
			local treeAngles = string.Explode(" ", tostring(ply:GetAngles()+Angle(0, -180, 0)));
					
			local tree = ents.Create("swm_wood_red");
			tree:SetPos(ply:GetEyeTrace().HitPos);
			tree:SetAngles(ply:GetAngles()+Angle(0, -180, 0));
			tree:Spawn();
			tree:SetMoveType(MOVETYPE_NONE)
			tree:GetPhysicsObject():EnableMotion(false);
					
			file.Write("jb/"..string.lower(game.GetMap()).."/redtree/swm_wood_".. fileTreeName ..".txt", ""..(treeVector[1]).." "..(treeVector[2]).." "..(treeVector[3]).." "..(treeAngles[1]).." "..(treeAngles[2]).." "..(treeAngles[3]).."", "DATA");
			ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[New pos for the Red tree has been set.]] } chat.AddText(unpack(tab))");
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");
		end;
	end;
	concommand.Add("swm_tree_red_spawn", spawnTreePos);
	 
	function removeTreePos(ply, cmd, args)
		if (ply:IsAdmin() or ply:IsSuperAdmin()) then
			local fileTreeName = args[1];
				   
			if !fileTreeName then
				ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Please enter a name of file!]] } chat.AddText(unpack(tab))");
				return;
			end;
					   
			if file.Exists("jb/"..string.lower(game.GetMap()).."/redtree/swm_wood_"..fileTreeName..".txt", "DATA") then
				file.Delete("jb/"..string.lower(game.GetMap()).."/redtree/swm_wood_"..fileTreeName..".txt");
				ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[This Red tree has been removed. Restart your server!]] } chat.AddText(unpack(tab))");
				return;
			end;
				   
		else
			ply:SendLua("local tab = {Color(0,255,0,255), [[Sawmill - ]], Color(255,255,255), [[Only admins and superadmins can perform this action.]] } chat.AddText(unpack(tab))");                       
		end;
	end;
	concommand.Add("swm_tree_red_remove", removeTreePos);
end