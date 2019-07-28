local math_round 	= math.Round
local math_max 	= math.max
local CurTime 		= CurTime

rp.Foods = {}

function rp.AddFoodItem(name, mdl, amount, thirst, price)
	rp.Foods[name] = { model = mdl, amount = amount, thirst = thirst, price = price } -- to laz
	rp.Foods[#rp.Foods + 1] = {name = name, model = mdl, amount = amount, thirst = thirst, price = price }
end

function PLAYER:GetHunger()
	return self:Alive() and math_max(math_round((((self:GetNetVar('Energy') or (CurTime() + rp.cfg.HungerRate)) - CurTime()) / rp.cfg.HungerRate) * 100, 0), 0) or 100
end

function PLAYER:GetThirst()
    -- local rate = rp.teams[self:Team()].type ~= TEAMTYPE_SUP and rp.cfg.ThirstRate or 0
    if rp.teams[self:Team()] and rp.teams[self:Team()].type == TEAMTYPE_SUP then
        return 100
    end
	return self:Alive() and math_max(math_round((((self:GetNetVar('Thirst') or (CurTime() + rp.cfg.ThirstRate)) - CurTime()) / rp.cfg.ThirstRate) * 100, 0), 0) or 100
end

nw.Register('Energy', {
	Read 	= function()
		return net.ReadUInt(32)
	end,
	Write 	= function(v)
		return net.WriteUInt(v, 32)
	end,
	LocalVar = true
})

nw.Register('Thirst', {
	Read 	= function()
		return net.ReadUInt(32)
	end,
	Write 	= function(v)
		return net.WriteUInt(v, 32)
	end,
	LocalVar = true
})
