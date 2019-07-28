local CurTime 		= CurTime
local math_abs		= math.abs
local math_clamp	= math.Clamp
local math_max 		= math.max

timer.Create("HungerUpdate", 5, 0, function()
	for k, v in ipairs(player.GetAll()) do
        if IsValid(v) and v:Alive() then
            local job = rp.teams[v:Team()]
            if job and job.type == TEAMTYPE_SUP or v:Team() == TEAM_HERO4 then
                for _, ent in pairs(ents.FindByClass('combine_terminal')) do
                    if v:GetPos():DistToSqr(ent:GetPos()) < 128^2 then
                        v:AddHunger(10)
                        v:AddThirst(10)
                    end
                end
            else
                if ((v:GetHunger() <= 0) or (v:GetThirst() <= 0)) then
                    local shouldHunger = hook.Call("PlayerHasHunger", nil, v)
                    if (shouldHunger == nil) then shouldHunger = true end

                    if (shouldHunger) then
                        v:SetHealth(v:Health() - 7.5)
                        v:EmitSound(Sound("vo/npc/male01/moan0" .. math.random(1, 5) .. ".wav"), 65)
                        if (v:Health() <= 0) then
                            v:Kill()
                        end
                    end
                end
            end
        end
	end
end)

hook.Add("PlayerSpawn", "Hungermod_PlayerSpawn", function(pl)
	if pl:GetNetVar('Energy') then
		pl:SetNetVar("Energy", CurTime() + rp.cfg.HungerRate)
	end
    if pl:GetNetVar('Thirst') then
        pl:SetNetVar("Thirst", CurTime() + rp.cfg.ThirstRate)
    end
end)

hook.Add("PlayerEntityCreated", "Hungermod_PlayerEntityCreated", function(pl)
	pl:SetNetVar("Energy", CurTime() + rp.cfg.HungerRate)
    pl:SetNetVar("Thirst", CurTime() + rp.cfg.ThirstRate)
end)

function PLAYER:SetHunger(amount, noclamp)
	if noclamp then
		amount = math_max(0, (amount/100 * rp.cfg.HungerRate))
	else
		amount = math_clamp((amount/100 * rp.cfg.HungerRate), 0, rp.cfg.HungerRate)
	end
	self:SetNetVar('Energy', CurTime() + amount)
end

function PLAYER:AddHunger(amount)
	self:SetHunger(self:GetHunger() + amount)
end

function PLAYER:TakeHunger(amount)
	self:AddHunger(-math_abs(amount))
end

function PLAYER:SetThirst(amount, noclamp)
	if noclamp then
		amount = math_max(0, (amount/100 * rp.cfg.ThirstRate))
	else
		amount = math_clamp((amount/100 * rp.cfg.ThirstRate), 0, rp.cfg.ThirstRate)
	end
	self:SetNetVar('Thirst', CurTime() + amount)
end

function PLAYER:AddThirst(amount)
	self:SetThirst(self:GetThirst() + amount)
end

function PLAYER:TakeThirst(amount)
	self:AddThirst(-math_abs(amount))
end

local function BuyFood(pl, args)
	if args == "" then return "" end
	if not rp.Foods[args] then return "" end

	if pl:GetCount('spawned_food') >= 15 then
		pl:Notify(NOTIFY_ERROR, rp.Term('FoodLimitReached'))
		return
	end

	local trace = {}
	trace.start = pl:EyePos()
	trace.endpos = trace.start + pl:GetAimVector() * 85
	trace.filter = pl

	local tr = util.TraceLine(trace)

    local job = rp.teams[pl:Team()]
	if not job.cook then
		-- pl:Notify(NOTIFY_ERROR, rp.Term('ThereIsACook'))
		return ""
	end

	if not rp.Foods[args] then return end

	local cost = rp.Foods[args].price
	if pl:CanAfford(cost) then
		pl:AddMoney(-cost)
	else
		pl:Notify(NOTIFY_ERROR, rp.Term('CannotAfford'))
		return ""
	end

	rp.Notify(pl, NOTIFY_GREEN, rp.Term('RPItemBought'), args, rp.FormatMoney(cost))

	local SpawnedFood = ents.Create("spawned_food")
	SpawnedFood:SetPos(tr.HitPos)
	SpawnedFood:SetModel(rp.Foods[args].model)
    -- PrintTable(rp.Foods[args])
	SpawnedFood.ItemOwner = pl
	SpawnedFood:Spawn()

	SpawnedFood.FoodEnergy = rp.Foods[args].amount
    SpawnedFood.FoodThirst = rp.Foods[args].thirst

	pl:_AddCount("spawned_food", SpawnedFood)
    pl:AddCleanup("spawned_food", SpawnedFood)
	return ""
end
rp.AddCommand("/buyfood", BuyFood)
