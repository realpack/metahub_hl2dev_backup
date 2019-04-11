include('shared.lua')

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		cam.Start3D2D(self:GetPos()+self:GetUp()*14, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.SimpleTextOutlined( 'Тяжелый ящик', "font_base_large", -3, 0, Color(238,212,185), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined( 'Получите деньги, отнеся ящик в Офис ГСР!', "font_base_54", -3, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			render.PopFilterMin()
		cam.End3D2D()
	end
end

net.Receive('SetBoxBool', function()
	local pPlayer = net.ReadEntity()
	-- local eEnt = data.eEnt or false
    local wear = net.ReadBool()
	pPlayer.bWearBox = wear

	if wear then
		local eModel = ClientsideModel('models/props_junk/cardboard_box003a.mdl')
		eModel.paretPlayer = pPlayer
		pPlayer.eModelBox = eModel
	else
		if pPlayer and pPlayer.eModelBox then
			pPlayer.eModelBox:Remove()
		end
	end

	-- if eEnt and IsValid(eEnt) and eEnt:GetClass() == 'ent_fabrik_npc' then
	-- 	sprawl.util.AddNotify( "Вы принесли коробку назначенное место, вот ваши деньги. +$"..eEnt.MoneyForBox, NOTIFY_SELL, 3 )
	-- end
end);
