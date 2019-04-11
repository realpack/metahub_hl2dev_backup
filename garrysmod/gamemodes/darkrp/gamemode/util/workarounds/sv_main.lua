local IsValid = IsValid
local ipairs = ipairs

timer.Destroy('HostnameThink')

ENTITY._SetHealth = ENTITY._SetHealth or ENTITY.SetHealth
ENTITY.SetHealth = function(self, amt)
	if IsValid(self) and self:IsPlayer() and (amt > 500) then
		return self:_SetHealth(500)
	end
	return self:_SetHealth(amt)
end

function ENTITY:IsConstrained()
	local c = self.Constraints
	if c then
		for k, v in ipairs(c) do
			if v:IsValid() then 
				return true 
			end
			c[k] = nil
		end
	end
	return false
end

_G.RunString 		= function() end -- We dont use these.
_G.RunStringEx 		= function() end 
_G.CompileString 	= function() end 
_G.CompileFile 		= function() end 