timer.Simple(1, function()
	for k,v in pairs(ents.FindByModel('models/bm/nbasizeketball.mdl')) do
		local phys = v:GetPhysicsObject()
		if not IsValid(phys) then continue end
		phys:EnableMotion(true)
		phys:Wake()
	end
end)
