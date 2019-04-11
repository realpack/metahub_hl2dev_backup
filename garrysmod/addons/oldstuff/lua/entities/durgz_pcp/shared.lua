ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Бутылка Отчистителя"
ENT.Nicknames = {"Пивасик"}
ENT.OverdosePhrase = {"перепил" }
ENT.Author = "Jared DeVries"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Information	 = "GODLIKE!!!" 
ENT.Category = "Бармен"
ENT.TRANSITION_TIME = 3

--function for high visuals

if(CLIENT)then


	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.77; --1 is max, 0 is nothing at all
	
	
	local function DoPCP()
		if(!DURGZ_LOST_VIRGINITY)then return end

		local pl = LocalPlayer();
		
		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = 1
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
		
		
		if( pl:GetNWFloat("durgz_pcp_high_start") && pl:GetNWFloat("durgz_pcp_high_end") > CurTime() )then
		
		      local pf = 1;
		
			if( pl:GetNWFloat("durgz_pcp_high_start") + TRANSITION_TIME > CurTime() )then
			
				local s = pl:GetNWFloat("durgz_pcp_high_start");
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);
				
			elseif( pl:GetNWFloat("durgz_pcp_high_end") - TRANSITION_TIME < CurTime() )then
			
				local e = pl:GetNWFloat("durgz_pcp_high_end");
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);
				
			end
				
				tab[ "$pp_colour_addr" ] = pf*math.random(0,1);
			    tab[ "$pp_colour_addg" ] = pf*math.random(0,1);
			    tab[ "$pp_colour_addb" ] = pf*math.random(0,1);
			    DrawColorModify(tab);
		end
	end
	
	hook.Add("RenderScreenspaceEffects", "durgz_pcp_high", DoPCP)
end
