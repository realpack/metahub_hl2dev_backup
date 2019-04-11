hook.Add("PlayerBindPress", "bindlolwtf", function(ply, bind, pressed)

	if not IsValid(ply) then return end
	if bind == "invnext" and pressed and !input.IsMouseDown(MOUSE_LEFT) then
		if (!ply:InVehicle()) then
			WeaponSelection:Call()
			WeaponSelection:NextWeapon()
		end
		return true
	elseif bind == "invprev" and pressed and !input.IsMouseDown(MOUSE_LEFT) then
		if (!ply:InVehicle()) then
		 	WeaponSelection:Call()
		 	WeaponSelection:PrevWeapon()
		 end
		return true
	elseif bind == "+attack" then
		if (WeaponSelection:ShouldDraw()) then
			WeaponSelection:Call()
			WeaponSelection:SelectWeapon()
			return true
		end
	elseif string.sub(bind, 1, 4) == "slot" and pressed then
      local idx = tonumber(string.sub(bind, 5, -1)) or 1
      WeaponSelection:SetSelection(idx)
      return true
	end

end)