function PLAYER:GetStamina()
	return self:GetNetVar('Stamina') or 0
end
