AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString('Citizen_TerminalOpenMenu')
util.AddNetworkString('Citizen_ChangeCharacter')

function ENT:Initialize()
	self:SetModel( "models/props_combine/combine_interface003.mdl" )

    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )
end

function ENT:Use(pl)
	local job = rp.teams[pl:Team()]
    if not (job.model) then
        net.Start('Citizen_TerminalOpenMenu')
        net.Send(pl)
    end
end

net.Receive('Citizen_ChangeCharacter', function( len, pl )
	local name = net.ReadString()
	local model = net.ReadString()

	local gender = tostring(pl:GetNetVar('Gender') == 1 and '0' or '1')

	local next = false
    if table.HasValue(rp.cfg.DefaultModels['0'], model) or table.HasValue(rp.cfg.DefaultModels['1'], model) then next = true end
	-- for _, mdl in pairs(rp.cfg.DefaultModels[gender]) do
	-- 	if model == mdl then
	-- 		next = true
	-- 		break
	-- 	end
	-- end

	local len = string.len(name)
	local low = string.lower(name)

	if len > 20 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RPNameLong'), 21)
		return
	elseif len < 3 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RPNameShort'), 2)
		return
	end

	local canChangeName = hook.Call("CanChangeRPName", GAMEMODE, pl, low)
	if canChangeName == false then
		return
	end

	local allowed = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0',
	'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
	'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
	'z', 'x', 'c', 'v', 'b', 'n', 'm', ' ',
	'(', ')', '[', ']', '!', '@', '#', '$', '%', '^', '&', '*', '-', '_', '=', '+', '|', '\\'}

	for k in string.gmatch(name, ".") do
		if not table.HasValue(allowed, string.lower(k)) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('RPNameUnallowed'), k)
			return ""
		end
	end


	-- if not next then return end

	if not pl:CanAfford(rp.cfg.ChangeNamePrice) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return ""
	end

	rp.data.SetName(pl, name, function()
        if next then
            rp.data.SetModel(pl, model, function()
                pl:SetModel(model)
                pl:AddMoney(-rp.cfg.ChangeNamePrice)
                pl:SetVar('Model', model)
            end)
        end
        pl:SetNetVar('Gender', gender)
        rp.data.SetGender(pl, gender)
	end)
end)
