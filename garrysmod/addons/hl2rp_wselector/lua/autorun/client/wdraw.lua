hook.Add("HUDPaint", "jtmbbhud", function()

 	if (WeaponSelection:ShouldDraw()) then
		WeaponSelection:Draw()
	end

end)