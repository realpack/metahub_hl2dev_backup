rp.include_sh 'shared.lua'

function ENT:Draw()
	self:DrawModel()
	if self.Draw3D2D and self:InSight() then
		self:Draw3D2D()
	end
end