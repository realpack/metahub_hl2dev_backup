rp.include_cl 'cl_init.lua'
rp.include_sh 'shared.lua'

function ENT:Use(activator, caller, usetype, value)
	if caller:IsPlayer() and (not caller:IsBanned()) and (not caller:IsJailed()) and ((not caller['NextUse' .. self:GetClass()]) or (caller['NextUse' .. self:GetClass()] <= CurTime())) and self:CanUse(caller) then
		self:PlayerUse(caller)
	end
 end

function ENT:PlayerUse(pl)

end

function ENT:CanUse(pl)
	return true
end

function ENT:NextUse(pl, time)
	pl['NextUse' .. self:GetClass()] = (CurTime() + time)
end

function ENT:OnTakeDamage(dmg)
	if self.MaxHealth then
		self.MaxHealth = self.MaxHealth - (dmg:GetDamage() * 0.5)
		if (self.MaxHealth <= 0) then
			if self.ExplodeOnRemove then
				self:Explode()
			else
				self:Remove()
			end
			local owner = self.ItemOwner
			if IsValid(owner) then
				owner:Notify(NOTIFY_ERROR, rp.Term('YourEntDestroyed'), self.PrintName)
			end
		end
	end
end

function ENT:Explode()
	local pos = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(pos)
	effectdata:SetOrigin(pos)
	effectdata:SetScale(1)
	util.Effect('Explosion', effectdata)
end