include("shared.lua")

surface.CreateFont ("EntityFont", { size = 42, weight = 500, antialias = true, font = "Roboto Lt" })
surface.CreateFont( "EntityFontSmall", { size = 20, weight = 300, antialias = true, font = "Uni Sans" })

function ENT:Draw()

	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local AngModel = self:GetAngles()

	Ang:RotateAroundAxis( Ang:Forward(), 90 )
	Ang:RotateAroundAxis( Ang:Right(), 90 )
	Ang:RotateAroundAxis( Ang:Up(), 0 )

	local AlphaColor = -LocalPlayer():GetPos():Distance(self:GetPos()) + 255

	-- if AlphaColor >= 0 then
	-- 	cam.Start3D2D(Pos + Ang:Up() * 15 + Ang:Right() * -55 + Ang:Forward() * 0 , Ang, 0.1)
	-- 		draw.SimpleText(TitleStringArmory,"EntityFont",0+1,0+1,Color(0,0,0,AlphaColor),TEXT_ALIGN_CENTER)
	-- 		draw.SimpleText(TitleStringArmory,"EntityFont",0,0,Color(255,255,255,AlphaColor),TEXT_ALIGN_CENTER)
	-- 	cam.End3D2D()

	-- 	local AlphaColor = (-LocalPlayer():GetPos():Distance(self:GetPos()) + 255/1.5) * 2
	-- 	for k, v in pairs(ValidTeamsArmory) do AmountTeams = k end

	-- 	cam.Start3D2D(Pos + Ang:Up() * 15 + Ang:Right() * -60 + Ang:Forward() * 0 , Ang, 0.1)
	-- 		draw.SimpleText(OnlyForStringArmory,"EntityFontSmall",0+1,100+1,Color(0,0,0,AlphaColor),TEXT_ALIGN_CENTER)
	-- 		draw.SimpleText(OnlyForStringArmory,"EntityFontSmall",0,100,Color(255,255,255,AlphaColor),TEXT_ALIGN_CENTER)
	-- 		for k, v in pairs(ValidTeamsArmory) do
	-- 			TeamColor = team.GetColor(v)
	-- 			draw.SimpleText(team.GetName(ValidTeamsArmory[k]),"EntityFontSmall",0+1,14*k+100+1,Color(0,0,0,AlphaColor),TEXT_ALIGN_CENTER)
	-- 			draw.SimpleText(team.GetName(ValidTeamsArmory[k]),"EntityFontSmall",0,14*k+100,Color(255,255,255,AlphaColor),TEXT_ALIGN_CENTER)
	-- 		end
	-- 	cam.End3D2D()
	-- end
end
