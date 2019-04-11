--require 'fps'

if not engine.RealFrameTime then return end

local FPS       = engine.RealFrameTime

local LagTime   	= 0
local FullTick 		= engine.TickInterval()
local AdjustedTick	= FullTick * 1.3
local PropsFroze 	= false

local function FreezeProps()
    for k, v in ipairs(ents.GetAll()) do
        if IsValid(v) and rp.nodamage[v:GetClass()] then
            local phys = v:GetPhysicsObject()
            if IsValid(phys) then
                phys:EnableMotion(false)
            end
            constraint.RemoveAll(v)
        end
    end
end

local function RemoveHighRisk()
	for k, v in ipairs(ents.GetAll()) do
		if v.HighLagRisk then
			v:Remove()
		end
	end
end

hook('Tick', 'rp.antilag.Tick', function()
    if (AdjustedTick <= FPS()) then
        LagTime = LagTime + FullTick
        if (LagTime >= 3) and (not PropsFroze) then
            ba.notify_staff('The server has been heavily lagging for a few seconds, all props have been frozen and unwelded, please stay vigulant, if this repeats drop what you\'re doing and investigate.')
            FreezeProps()
            PropsFroze = true
        elseif (LagTime >= 5) then
            ba.notify_staff('The server has been heavily lagging for over 5 seconds, small entities have been removed, all props have been frozen again, please drop your current task and investigate NOW!!')
            FreezeProps()
            RemoveHighRisk()
            LagTime = 0
        end
    else
        LagTime = 0
        PropsFroze = false
    end
end)