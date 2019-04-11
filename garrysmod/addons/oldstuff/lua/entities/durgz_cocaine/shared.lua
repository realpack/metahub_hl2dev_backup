ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Кофеин"
ENT.Nicknames = {"кофе"}
ENT.OverdosePhrase = {"передазировка кофе"}
ENT.Author = "Arash Ansari"
ENT.Category = "Бармен"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.Information	 = "Looks like sugar to me..." 

--function for high visuals

ENT.TRANSITION_TIME = 5


if(CLIENT)then

	local cdw, cdw2, cdw3
	cdw2 = -1
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 0.8; --1 is max, 0 is nothing at all
	local STROBE_PACE = 1
	
	local function DoCocaine()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNWFloat( "SprintSpeed"
		local pl = LocalPlayer();
		local pf;
		
		local tab = {}
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = 0
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
		
		
		if( pl:GetNWFloat("durgz_cocaine_high_start") && pl:GetNWFloat("durgz_cocaine_high_end") > CurTime() )then
		
			if( pl:GetNWFloat("durgz_cocaine_high_start") + TRANSITION_TIME > CurTime() )then
			
				local s = pl:GetNWFloat("durgz_cocaine_high_start");
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				pf = (c-s) / (e-s);
				
				pf = pf*HIGH_INTENSITY
				
				
				
			elseif( pl:GetNWFloat("durgz_cocaine_high_end") - TRANSITION_TIME < CurTime() )then
			
				local e = pl:GetNWFloat("durgz_cocaine_high_end");
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				pf = 1 - (c-s) / (e-s);
				
				pf = pf*HIGH_INTENSITY
				
				pl:SetDSP(1)
				
				
				
			else
			
				
				pf = HIGH_INTENSITY;
				
			end
			
			
				
			if( !cdw || cdw < CurTime() )then
				cdw = CurTime() + STROBE_PACE
				cdw2 = cdw2*-1
			end
			if( cdw2 == -1 )then
				cdw3 = 2
			else
				cdw3 = 0
			end
			local ich = (cdw2*((cdw - CurTime())*(2/STROBE_PACE)))+cdw3 - 1
			
			DrawMaterialOverlay("highs/shader3",  pf*ich*0.05	)
			DrawSharpen(pf*ich*5, 2) 
			
		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_cocaine_high", DoCocaine)
end
