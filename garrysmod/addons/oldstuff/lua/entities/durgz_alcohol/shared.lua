ENT.Type = "anim"
ENT.Base = "durgz_base"
ENT.PrintName = "Водка"
ENT.Nicknames = {
    "Водка",
}
ENT.OverdosePhrase = {"выпил слишком много", "отравился", "не смог исследовать новые пути развития человечества"}
ENT.Author = "Phillip Penrose"
ENT.Category = "Бармен"
ENT.Spawnable = true
ENT.AdminSpawnable = true 
ENT.Information	 = "Drink your troubles away... Just kidding, this is light beer. You won't even get a buzz." 

ENT.TRANSITION_TIME = 6

if(CLIENT)then
	
	
	
	local TRANSITION_TIME = ENT.TRANSITION_TIME; --transition effect from sober to high, high to sober, in seconds how long it will take etc.
	local HIGH_INTENSITY = 1; --1 is max, 0 is nothing at all
	
	
	local function DoAlcohol()
		if(!DURGZ_LOST_VIRGINITY)then return; end
		--self:SetNWFloat( "SprintSpeed"
		local pl = LocalPlayer();
		
		
		
		if( pl:GetNWFloat("durgz_alcohol_high_start") && pl:GetNWFloat("durgz_alcohol_high_end") > CurTime() )then
		
			if( pl:GetNWFloat("durgz_alcohol_high_start") + TRANSITION_TIME > CurTime() )then
			
				local s = pl:GetNWFloat("durgz_alcohol_high_start");
				local e = s + TRANSITION_TIME;
				local c = CurTime();
				local pf = (c-s) / (e-s);
				
				DrawMotionBlur( 0.03, pf*HIGH_INTENSITY, 0);
				
			elseif( pl:GetNWFloat("durgz_alcohol_high_end") - TRANSITION_TIME < CurTime() )then
			
				local e = pl:GetNWFloat("durgz_alcohol_high_end");
				local s = e - TRANSITION_TIME;
				local c = CurTime();
				local pf = 1 - (c-s) / (e-s);
				
				DrawMotionBlur( 0.03, pf*HIGH_INTENSITY, 0);
				
			else
				
				DrawMotionBlur( 0.03, HIGH_INTENSITY, 0);
				
			end
			
			
		end
	end
	hook.Add("RenderScreenspaceEffects", "durgz_alcohol_high", DoAlcohol)
	
end
