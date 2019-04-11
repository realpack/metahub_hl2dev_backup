local ply = FindMetaTable("Player")
local ent = FindMetaTable("Entity")
DarkRP = {}
function DarkRP.formatMoney(t)
	return rp.FormatMoney(t)
end
function isArrested(p)
	return p:IsArrested()
end
function DarkRP.textWrap(gs, f, s)
	return string.Wrap(f, gs, s)
end
function ply:isArrested()
	return self:IsArrested()
end
function ply:isCP()
	return self:IsCP()
end
function ply:isWanted()
	return self:IsWanted()
end
function ply:isMayor()
	return self:IsMayor()
end
function ply:GetAgendaText()
	return nw.GetGlobal('Agenda;' .. self:Team())
end
function DarkRP.setPreferredJobModel(_,model)
	rp.RunCommand('model', model)
end
function ply:getEyeSightHitEntity(searchDistance, hitDistance, filter)
    searchDistance = searchDistance or 100
    hitDistance = (hitDistance or 15) * (hitDistance or 15)

    filter = filter or function(p) return p:IsPlayer() and p ~= self end

    self:LagCompensation(true)

    local shootPos = self:GetShootPos()
    local entities = ents.FindInSphere(shootPos, searchDistance)
    local aimvec = self:GetAimVector()

    local smallestDistance = math.huge
    local foundEnt

    for k, ent in pairs(entities) do
        if not IsValid(ent) or filter(ent) == false then continue end

        local center = ent:GetPos()

        -- project the center vector on the aim vector
        local projected = shootPos + (center - shootPos):Dot(aimvec) * aimvec

        if aimvec:Dot((projected - shootPos):GetNormalized()) < 0 then continue end

        -- the point on the model that has the smallest distance to your line of sight
        local nearestPoint = ent:NearestPoint(projected)
        local distance = nearestPoint:DistToSqr(projected)

        if distance < smallestDistance then
            local trace = {
                start = self:GetShootPos(),
                endpos = nearestPoint,
                filter = {self, ent}
            }
            local traceLine = util.TraceLine(trace)
            if traceLine.Hit then continue end

            smallestDistance = distance
            foundEnt = ent
        end
    end

    self:LagCompensation(false)

    if smallestDistance < hitDistance then
        return foundEnt, math.sqrt(smallestDistance)
    end

    return nil
end

function ent:isDoor()
	return self:IsDoor()
end

function ply:getDarkRPVar(sd)
	if sd == "job" then
		return self:GetJobName()
	end
	if sd == "HasGunlicense" then
		return self:HasLicense()
	end
	if sd == "Arrested" then
		return self:IsArrested()
	end
	if sd == "Energy" then
		return self:GetHunger()
	end
	if sd == "money" then
		return self:GetMoney()
	end
	if sd == "salary" then
		return self:GetSalary()
	end
	if sd == "wanted" then
		return self:IsWanted()
	end
	if sd == "wantedReason" then
		return self:GetWantedReason()
	end
	if sd == "agenda" then
		return nw.GetGlobal('Agenda' .. self:Team())
	end
	if sd == "channelID" then
		return self:GetNWFloat("channelID",0)
	end
	if sd == "channelName" then
		return self:GetNWString("channelName","")
	end
end

function ply:getJobTable()
	for k,v in pairs(rp.teams) do
		if self:GetJob() == k then
			return v
		end
	end
end
function ply:canAfford(sd)
	if tonumber(self:GetMoney()) >= tonumber(sd) then return true else return false end
end

if SERVER then
	function ply:addMoney(sd)
		self:AddMoney(sd or 1)
	end
	function ply:unArrest()
		self:UnArrest()
	end
	function DarkRP.createMoneyBag(p,a)
		rp.SpawnMoney(p,a)
	end
	function DarkRP.notify(ply,t,ti,te)
		rp.Notify(ply,t,te)
	end
end
timer.Simple(1,function()
	RPExtraTeams = rp.teams
	CustomShipments = rp.shipments
end)
