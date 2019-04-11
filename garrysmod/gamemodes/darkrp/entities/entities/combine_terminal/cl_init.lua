include('shared.lua')

local time = CurTime()
function ENT:DrawTranslucent()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		-- print(self:GetNetVar('TerminalRepair'))

		cam.Start3D2D(self:GetPos()+self:GetUp()*60, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.SimpleTextOutlined( 'Терминал Альянса', "font_base_large", -3, 0, Color(173,236,168), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				if self:GetNetVar('TerminalBreak') then
					draw.SimpleTextOutlined( 'Сломан ('..tostring(self:GetNetVar('TerminalRepair')..'%')..')', "font_base_54", -3, 100, rp.col.Red, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				else
					draw.SimpleTextOutlined( 'Работает', "font_base_54", -3, 100, rp.col.Green, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				end
			render.PopFilterMin()
		cam.End3D2D()
	end

	if not self:GetNetVar('TerminalBreak') then return end

	if time < CurTime() then
		time = CurTime() + .3
		local ang = self:GetAngles()
		local pos = self:GetPos()+ang:Up()*45+ang:Right()*math.random(-30,30)+ang:Forward()*math.random(-20,20)
		local sparks = ParticleEmitter( pos )
		local smoke = ParticleEmitter( pos )

		for i = 1, 10 do
			local part = sparks:Add( "effects/spark", pos )
			if ( part ) then
				part:SetDieTime( 2 )

				part:SetStartAlpha( 255 )
				part:SetEndAlpha( 0 )

				part:SetStartSize( 1 )
				part:SetEndSize( 0 )

				part:SetGravity( Vector( 0, 0, -250 )+ang:Forward()*250 )
				part:SetVelocity( VectorRand() * 70 )
			end
		end

		-- local part = smoke:Add( table.Random({"effects/muzzleflash1","effects/muzzleflash3","effects/muzzleflash4"}), pos )
		local part = smoke:Add( "particles/smokey", pos )
		if ( part ) then
			part:SetDieTime( 1 )

			part:SetStartAlpha( math.random(0,255) )
			part:SetEndAlpha( math.random(0,20) )

			part:SetStartSize( 10 )
			part:SetEndSize( 0 )

			part:SetGravity( Vector( 0, 0, 250 ) )
			part:SetVelocity( Vector( math.random(-30,30), math.random(-30,30), 0) )
		end
	end
end
