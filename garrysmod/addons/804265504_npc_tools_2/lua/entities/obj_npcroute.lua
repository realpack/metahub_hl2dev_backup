AddCSLuaFile()

DEFINE_BASECLASS("base_edit")

ENT.PrintName		= "NPC Route Point"
ENT.Author			= "SGH"
ENT.Information		= "A Route Point for use with NPC Tools 2."
ENT.Category		= "NPC Tools 2"
ENT.Editable		= false
ENT.Spawnable		= true
ENT.AdminOnly		= false

---------------------- CLIENT ----------------------
if CLIENT then

local showEnts
local showEntsDH
local showChances
local showId

function ShouldDraw()
	if not showEnts or not showEntsDH then
		showEnts = GetConVar("npctool_newroute_show")
		showEntsDH = GetConVar("npctool_newroute_show_dh")
	end
	
	if showEnts and showEntsDH then
		return showEnts:GetBool() or showEntsDH:GetBool()
	end
	return false
end

function ENT:PhysgunPickup(ply)
	return ShouldDraw()
end

function UpdateEntityDrawState(ent)
	if ShouldDraw() then
		ent:SetNoDraw(false)
	else
		ent:SetNoDraw(true)
	end
end

function UpdateEveryEntityDrawState()
	for k,v in pairs(ents.FindByClass("obj_npcroute")) do
		UpdateEntityDrawState(v)
	end
end

cvars.AddChangeCallback("npctool_newroute_show", UpdateEveryEntityDrawState)
cvars.AddChangeCallback("npctool_newroute_show_dh", UpdateEveryEntityDrawState)

local beamMaterial = Material("trails/physbeam")
local beamColor = Color(255,255,255,255)

function isHigher(ent1, ent2)
	return ent1:GetVar("CreationIndex") > ent2:GetVar("CreationIndex")
end

function LinkOffset(ent1, ent2)
	if isHigher(ent1,ent2) then
		return Vector(0,0,-4)
	end
	return Vector(0,0,4)
end

hook.Add("RenderScreenspaceEffects","obj_npcroute_render_links",function()
	if not ShouldDraw() then return end
	local all = ents.FindByClass("obj_npcroute")
	if all[1] then
		cam.Start3D(EyePos(),EyeAngles())
		render.SetMaterial(beamMaterial)
		for k,v in ipairs(all) do
			for x,y in ipairs(v.m_clientlinks or {}) do
				if IsValid(y[1]) then
					local distance = v:GetPos():Distance(y[1]:GetPos())
					local offset = LinkOffset(v,y[1])
					render.DrawBeam(v:GetPos()+offset, y[1]:GetPos()+offset, 2.5, CurTime() + (2*(distance/75)), CurTime(), beamColor)
				end
			end
		end
		
		if not showChances then
			showChances = GetConVar("npctool_newroute_showchance")
		end
		if showChances and showChances:GetBool() then
			local posBase
			for k,v in ipairs(all) do
				for x,y in ipairs(v.m_clientlinks or {}) do
					if IsValid(y[1]) then
						local off = LinkOffset(v,y[1]) * 1
						local posAbs = (v:GetPos() + y[1]:GetPos() ) / 2
						local diff = y[1]:GetPos() - v:GetPos()
						local ang = diff:Angle()
						
						ang = diff:Angle()
						ang.z = 90
						posBase = Vector(0,off.z + 5,0)
						posBase:Rotate(ang)
						posBase:Add(posAbs)
						cam.Start3D2D(posBase,ang,0.3)
						draw.DrawText("Chance: "..y[5],"DermaDefault",0,0,Color(255,255,255,255),TEXT_ALIGN_CENTER)
						cam.End3D2D()
						
						ang = (Vector(0,0,0) - diff):Angle()
						ang.z = 90
						posBase = Vector(0,off.z + 5,0)
						posBase:Rotate(ang)
						posBase:Add(posAbs)
						cam.Start3D2D(posBase,ang,0.3)
						draw.DrawText("Chance: "..y[5],"DermaDefault",0,0,Color(255,255,255,255),TEXT_ALIGN_CENTER)
						cam.End3D2D()
					end
				end
			end
		end
		
		if not showId then
			showId = GetConVar("npctool_newroute_showid")
		end
		if showId and showId:GetBool() then
			for k,v in ipairs(all) do
				local pos = v:GetPos() + Vector(0,0,14)
				local ang = LocalPlayer():EyeAngles()
				ang:RotateAroundAxis(ang:Forward(),90)
				ang:RotateAroundAxis(ang:Right(),90)
				ang.x = 0
				ang.z = 90
				cam.Start3D2D(pos,ang,0.3)
				draw.DrawText(""..v:EntIndex(),"DermaDefault",0,0,Color(255,255,255,255),TEXT_ALIGN_CENTER)
				cam.End3D2D()
			end
		end
		cam.End3D()
	end
end)

function ENT:Draw()
	if ShouldDraw() then
		self:DrawModel()
	end
end

function ENT:SetClientLinks(links)
	self.m_clientlinks = links
end

local selectedEntity

function ENT:SetSelected()
	self:ClearSelection()
	selectedEntity = self
	selectedEntity:SetMaterial("gmod/obj_npcroute_selected")
	
	LocalPlayer():SetVar("obj_npcroute_selected", self)
end

function ENT:GetCurrentSelection()
	return selectedEntity
end

function ENT:ClearSelection()
	if IsValid(selectedEntity) then
		selectedEntity:SetMaterial("gmod/obj_npcroute")
	end
	selectedEntity = nil
	LocalPlayer():SetVar("obj_npcroute_selected", nil)
end

net.Receive("obj_npcroute_select_entity",function()
	if IsValid(selectedEntity) then
		selectedEntity:SetMaterial("gmod/obj_npcroute")
	end
	selectedEntity = nil
	
	local newSelection = net.ReadEntity()
	if IsValid(newSelection) then
		newSelection:SetSelected()
	end
end)

net.Receive("obj_npcroute_updatelinks",function()
	local sourceEntity = net.ReadEntity()
	local linkTable = net.ReadTable()
	if IsValid(sourceEntity) and sourceEntity.SetClientLinks then
		sourceEntity:SetClientLinks(linkTable)
	end
end)
end
---------------------- CLIENT end ----------------------

local clientIndex = 0
function ENT:Initialize()
	BaseClass.Initialize(self)
	self:SetMaterial("gmod/obj_npcroute")
	
	if CLIENT then
		clientIndex = clientIndex + 1
		self:SetVar("CreationIndex",clientIndex)
		self.m_clientlinks = {}
		UpdateEntityDrawState(self)
		return
	end
	
	self.m_autoUpdateLocked = false
	self:SetPhysicsEnabled(true)
	self.m_queuedNPCs = {}
	self.m_npcs = {}
	self.m_links = {}
end

function ENT:IsPhysicsEnabled()
	return self:GetMoveType() == MOVETYPE_VPHYSICS
end

function ENT:HasDirectLinkTo(ent)
	for k,v in ipairs(self.m_links or self.m_clientlinks) do
		if v[1] == ent then return true end
	end
	return false
end

---------------------- SERVER ----------------------
if SERVER then
hook.Add("PlayerInitialSpawn","obj_npcroute_initial_send_links",function(ply)
	for k,v in ipairs(ents.FindByClass("obj_npcroute")) do
		v:UpdateClientLinks(ply)
	end
end)
util.AddNetworkString("obj_npcroute_updatelinks")
util.AddNetworkString("obj_npcroute_select_entity")

function ENT:PhysgunPickup(ply)
	return (ply:GetInfoNum("npctool_newroute_show",0) ~= 0)
end
function ENT:RemoveLink(id)
	table.remove(self.m_links, id)
	self:UpdateClientLinks()
end
function ENT:RemoveAllLinks()
	self.m_links = {}
	self:UpdateClientLinks()
end
function ENT:RemoveLinkToEntity(ent)
	for k,v in ipairs(self.m_links) do
		if v[1] == ent then
			table.remove(self.m_links, k)
			self:UpdateClientLinks()
			return
		end
	end
	self:UpdateClientLinks()
end

function ENT:OnRemove()
	local parentPoint = self.parentPoint
	if not IsValid(parentPoint) then
		return
	end
	
	for k,v in pairs(player.GetHumans()) do
		if v:GetVar("obj_npcroute_selected") == self then
			parentPoint:SetSelected(v)
		end
	end
end

function ENT:SetSelected(ply, delay)
	local fnc = function()
		net.Start("obj_npcroute_select_entity")
		net.WriteEntity(self)
		net.Send(ply)
		ply:SetVar("obj_npcroute_selected", self) -- Only used for OnRemove.
		self:UpdateClientLinks(ply)
	end
	
	if delay == true then
		timer.Simple(0.1, fnc)
	else
		fnc()
	end
end

function ENT:UpdateClientLinks(ply)
	net.Start("obj_npcroute_updatelinks")
	net.WriteEntity(self)
	net.WriteTable(self.m_links)
	if ply then
		net.Send(ply)
	else
		net.Broadcast()
	end
end

function ENT:SetPhysicsEnabled(bEnabled)
	if bEnabled == true then
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetMoveType(MOVETYPE_VPHYSICS)
	else
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetMoveType(MOVETYPE_NONE)
	end
end

function ENT:QueueNPC(ent)
	table.insert(self.m_queuedNPCs, ent)
end

function ENT:AddNPC(ent, comingFrom)
	if IsValid(ent) and ent:IsNPC() then
		for k,v in ipairs(self.m_npcs) do
			if v[1] == ent then
				return true
			end
		end
		
		local link = self:FindLink(comingFrom)
		if not link then
			return false
		end
		
		-- Third item is:
		-- 0: Target not reached
		-- 1: Target reached, waiting
		-- 2: Target reached, waiting finished
		table.insert(self.m_npcs, {ent,link,0})
		return true
	end
	return false
end

function ENT:LockAutoUpdate()
	self.m_autoUpdateLocked = true
end

function ENT:UnlockAutoUpdate()
	self.m_autoUpdateLocked = false
end

function ENT:CreateLink(newEnt, walkType, strict, waitTime, chance)
	if chance > 0 and IsValid(newEnt) and newEnt:GetClass() == "obj_npcroute" then
		if self:HasDirectLinkTo(newEnt) then return false end
		table.insert(self.m_links, {newEnt, walkType, strict~=0, waitTime, chance})
		if self.m_autoUpdateLocked == false then
			self:UpdateClientLinks()
		end
		return true
	end
	return false
end

function ENT:MarkNpcFinishedWaiting(npc)
	for k,v in ipairs(self.m_npcs) do
		if v[1] == npc then
			self.m_npcs[k][3] = 2
		end
	end
end

function ENT:FindLink(comingFrom)
	local availableLinks = {}
	local maxDice = 0
	for k,v in ipairs(self.m_links) do
		if IsValid(v[1]) and v[1] ~= comingFrom then
			table.insert(availableLinks, v)
			maxDice = maxDice + v[5]
		end
	end
	if #availableLinks == 1 then
		return availableLinks[1]
	elseif #availableLinks > 1 then
		local dice = math.random(1,maxDice)
		for k,v in ipairs(availableLinks) do
			if dice <= v[5] then
				return v
			else
				dice = dice - v[5]
			end
		end
	end
	return self.m_links[1] -- Returns "comingFrom" or "nil"
end

local idle = {
	ACT_IDLE,
	ACT_IDLE_STEALTH,
	ACT_IDLE_ANGRY_MELEE,
	ACT_IDLE_RELAXED,
	ACT_IDLE_SMG1_RELAXED,
	ACT_IDLE_AIM_STEALTH,
	ACT_IDLE_MANNEDGUN,
	ACT_IDLE_ANGRY_PISTOL,
	ACT_IDLE_SHOTGUN_RELAXED,
	ACT_IDLE_RIFLE,
	ACT_IDLE_AIM_RELAXED,
	ACT_IDLE_ON_FIRE,
	ACT_IDLE_SHOTGUN_AGITATED,
	ACT_IDLE_ANGRY_SMG1,
	ACT_IDLE_PISTOL,
	ACT_IDLE_AIM_RIFLE_STIMULATED,
	ACT_IDLE_AGITATED,
	ACT_IDLE_CARRY,
	ACT_IDLE_RPG,
	ACT_IDLE_HURT,
	ACT_IDLE_ANGRY_RPG,
	ACT_IDLE_ANGRY_SHOTGUN,
	ACT_IDLE_SUITCASE,
	ACT_IDLE_SMG1_STIMULATED,
	ACT_IDLE_MELEE,
	ACT_IDLE_ANGRY,
	ACT_IDLE_AIM_STIMULATED,
	ACT_IDLE_AIM_AGITATED,
	ACT_IDLE_PACKAGE,
	ACT_IDLE_STEALTH_PISTOL,
	ACT_IDLE_SMG1,
	ACT_IDLE_RPG_RELAXED,
	ACT_IDLE_SHOTGUN_STIMULATED,
	ACT_IDLE_STIMULATED
}

	--	SetLastPosition
	--		Vector
	-- 	SetSchedule:
	-- 		SCHED_FORCED_GO
	-- 		SCHED_FORCED_GO_RUN
local MaxDistanceThreshold = 200
local MaxOverthrowDistance = 40
--local MaxDistanceThresholdSquared = MaxDistanceThreshold * MaxDistanceThreshold

function CalcNextStep(npc, target, deny_overthrow)
	local vecDirection = target
	vecDirection:Sub(npc:GetPos())
	
	local currentDistance = vecDirection:Length()
	if currentDistance > MaxDistanceThreshold then
		vecDirection:Normalize()
		vecDirection:Mul(MaxDistanceThreshold)
	elseif deny_overthrow==true then
		-- Simply go to target
		vecDirection:Add(npc:GetPos())
		vecDirection:Add(Vector(0,0,6))
		return vecDirection
	else
		-- Overshoot, so that the NPC keeps running if it has to
		vecDirection:Normalize()
		vecDirection:Mul(currentDistance + MaxOverthrowDistance)
	end
	vecDirection:Add(npc:GetPos())
	vecDirection:Add(Vector(0,0,6))
	return vecDirection
end

local Actions = {
	-- Run
	{
		-- Start
		function(npc, target)
			npc:SetLastPosition(CalcNextStep(npc,target))
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
		end,
		-- Tick
		function(npc, target)
			if target then
				npc:SetLastPosition(CalcNextStep(npc,target))
				npc:SetSchedule(SCHED_FORCED_GO_RUN)
			end
		end,
		-- End
		function(npc)
		end
	},
	-- Walk
	{
		-- Start
		function(npc, target)
			npc:SetLastPosition(CalcNextStep(npc,target,true))
			npc:SetSchedule(SCHED_FORCED_GO)
		end,
		-- Tick
		function(npc, target)
			if target then
				npc:SetLastPosition(CalcNextStep(npc,target,true))
				npc:SetSchedule(SCHED_FORCED_GO)
			end
		end,
		-- End
		function(npc)
		end
	}
--[[
	-- STILL NOT WORKING PROPERLY. Don't uncomment, it's unhelpful as of now.
	-- Crouch
	,{
		-- Start
		function(npc, target)
			local vecDirection = target;
			vecDirection:Sub(npc:GetPos())
			if vecDirection:Length() > MaxDistanceThreshold then
				vecDirection:Normalize()
				vecDirection:Mul(MaxDistanceThreshold)
			end
			vecDirection:Add(npc:GetPos())
			npc:SetLastPosition(vecDirection + Vector(0,0,6))
			npc:SetSchedule(SCHED_FORCED_GO)
			npc:SetMovementActivity(ACT_WALK_CROUCH)
		end,
		-- Tick
		function(npc, target)
			if target then
				local vecDirection = target;
				vecDirection:Sub(npc:GetPos())
				if vecDirection:Length() > MaxDistanceThreshold then
					vecDirection:Normalize()
					vecDirection:Mul(MaxDistanceThreshold)
				end
				vecDirection:Add(npc:GetPos())
				npc:SetLastPosition(vecDirection + Vector(0,0,6))
				npc:SetSchedule(SCHED_FORCED_GO)
			end
			npc:SetMovementActivity(ACT_WALK_CROUCH)
		end,
		-- End
		function(npc)
			npc:SetMovementActivity(ACT_WALK)
		end
	},
	-- Crouch Run
	{
		-- Start
		function(npc, target)
			local vecDirection = target;
			vecDirection:Sub(npc:GetPos())
			if vecDirection:Length() > MaxDistanceThreshold then
				vecDirection:Normalize()
				vecDirection:Mul(MaxDistanceThreshold)
			end
			vecDirection:Add(npc:GetPos())
			npc:SetLastPosition(vecDirection + Vector(0,0,6))
			npc:SetSchedule(SCHED_FORCED_GO_RUN)
			
			npc:CapabilitiesClear()
			npc:CapabilitiesAdd(CAP_MOVE_CRAWL)
			npc:SetMovementActivity(ACT_RUN_CROUCH)
			npc:ResetSequence(npc:LookupSequence("ACT_RUN_CROUCH"))
		end,
		-- Tick
		function(npc, target)
			if target then
				local vecDirection = target;
				vecDirection:Sub(npc:GetPos())
				if vecDirection:Length() > MaxDistanceThreshold then
					vecDirection:Normalize()
					vecDirection:Mul(MaxDistanceThreshold)
				end
				vecDirection:Add(npc:GetPos())
				npc:SetLastPosition(vecDirection + Vector(0,0,6))
				npc:SetSchedule(SCHED_FORCED_GO_RUN)
			end
			
			npc:SetMovementActivity(ACT_RUN_CROUCH)
			npc:SetSequence(npc:LookupSequence("ACT_RUN_CROUCH"))
		end,
		-- End
		function(npc)
			npc:SetMovementActivity(ACT_RUN)
		end
	}
--]]
}

local DistanceData = {
	[""] = {
		AcceptableDistanceXY = 64,
		AcceptableDistanceZ = 80
	},
	npc_strider = {
		AcceptableDistanceXY = 64,
		AcceptableDistanceZ = 512
	}
}

function GetAcceptableDistanceXY(npc_class)
	return (DistanceData[npc_class] or DistanceData[""]).AcceptableDistanceXY
end

function GetAcceptableDistanceZ(npc_class)
	return (DistanceData[npc_class] or DistanceData[""]).AcceptableDistanceZ
end

function DistanceCheck(PosA, PosB, npc_class)
	local accXY = GetAcceptableDistanceXY(npc_class)
	local accZ = GetAcceptableDistanceZ(npc_class)
	
	if math.abs(PosA.z - PosB.z) > accZ then
		return false
	end
	if Vector(PosA.x, PosA.y, 0):Distance(Vector(PosB.x, PosB.y, 0)) > accXY then
		return false
	end
	
	return true
end

function ENT:Think()
	for i=#self.m_npcs,1,-1 do
		-- NPC Invalid								Point Invalid
		if not IsValid(self.m_npcs[i][1]) or not IsValid(self.m_npcs[i][2][1]) then
			table.remove(self.m_npcs,i)
		end
	end
	for i=#self.m_queuedNPCs,1,-1 do
		if not IsValid(self.m_queuedNPCs[i]) then
			table.remove(self.m_queuedNPCs,i)
		end
	end
	
	local markRemoved = {}
	local markQueueRemoved = {}
	
	for k,v in ipairs(self.m_npcs) do
		local npc = v[1]
		local link = v[2]
		local waitedTime = v[3]
		
		if (npc:GetNPCState() <= NPC_STATE_ALERT or link[3]) then
			local targetPos = link[1]:GetPos()
			local currentPos = npc:GetPos()
			
			if DistanceCheck(currentPos, targetPos, npc:GetClass()) then
				self.m_npcs[k][3] = 1
				v[3] = 1
				-- waitTime
				if link[4] > 0 then
					timer.Simple(link[4], function()
						self:MarkNpcFinishedWaiting(npc)
					end)
				else
					self:MarkNpcFinishedWaiting(npc)
					v[3] = 2
				end
			end
			
			if v[3] == 0 then
				if table.HasValue(idle,npc:GetActivity()) and (!npc.sm_investigating or npc.sm_investigating==0) then
					-- Is idling. Start walking
					Actions[link[2]][1](npc, targetPos)
				end
				
				-- Has yet to reach: Tick.
				Actions[link[2]][2](npc, targetPos)
			elseif v[3] == 1 then
				-- Reached, waiting: Tick.
				Actions[link[2]][2](npc)
			elseif v[3] == 2 then
				-- Finished waiting: Finish.
				Actions[link[2]][3](npc)
				link[1]:AddNPC(npc,self)
				table.insert(markRemoved, npc)
			end
		end
	end
	
	for k,v in ipairs(self.m_queuedNPCs) do
		local npc = v
		
		local targetPos = self:GetPos()
		local currentPos = npc:GetPos()
		
		if DistanceCheck(currentPos, targetPos, npc:GetClass()) then
			table.insert(markQueueRemoved,npc)
			self:AddNPC(npc)
		elseif table.HasValue(idle,npc:GetActivity()) and (!npc.sm_investigating or npc.sm_investigating==0) then
			-- Start Running
			Actions[1][1](npc, targetPos)
		else
			-- Tick
			Actions[1][2](npc, targetPos)
		end
	end
	
	for k,v in ipairs(markRemoved) do
		for k1,v1 in ipairs(self.m_npcs) do
			if v1[1] == v then
				table.remove(self.m_npcs,k1)
				break
			end
		end
	end
	for k,v in ipairs(markQueueRemoved) do
		for k1,v1 in ipairs(self.m_queuedNPCs) do
			if v1 == v then
				table.remove(self.m_queuedNPCs,k1)
				break
			end
		end
	end
end

end
---------------------- SERVER end ----------------------

---------------------- SHARED ----------------------

local propClass = {
	["prop_detail"] = true,
	["prop_door_rotating"] = true,
	["prop_dynamic"] = true,
	["prop_dynamic_ornament"] = true,
	["prop_dynamic_override"] = true,
	["prop_physics"] = true,
	["prop_physics_multiplayer"] = true,
	["prop_physics_override"] = true,
	["prop_ragdoll"] = true,
	["prop_static"] = true
}


local function IsEligibleForLos(ent)
	return IsValid(ent) and ent.IsEFlagSet and ent.AddEFlags and ent.RemoveEFlags
end

properties.Add("npctools2_start_block_los", {
	MenuLabel = "Block NPC LOS",
	Order = 9997,
	MenuIcon = "icon16/door.png",
	Filter = function(self, ent, ply, skip_f_chk)
		if not IsValid(ent) then return false end
		if not propClass[ent:GetClass():lower()] then return false end
		if not IsEligibleForLos(ent) then return false end
		if not gamemode.Call("CanProperty", ply, "los", ent) then return false end
		
		if ent:IsEFlagSet(EFL_DONTBLOCKLOS) or skip_f_chk then return true end
		return false
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
			ent:RemoveEFlags(EFL_DONTBLOCKLOS)
		self:MsgEnd()
	end,
	Receive = function(self, length, player)
		local ent = net.ReadEntity()
		if not self:Filter(ent, player, true) then return end
		ent:RemoveEFlags(EFL_DONTBLOCKLOS)
	end
})

properties.Add("npctools2_end_block_los", {
	MenuLabel = "Stop blocking NPC LOS",
	Order = 9998,
	MenuIcon = "icon16/door_open.png",
	Filter = function(self, ent, ply, skip_f_chk)
		if not IsValid(ent) then return false end
		if not propClass[ent:GetClass():lower()] then return false end
		if not IsEligibleForLos(ent) then return false end
		if not gamemode.Call("CanProperty", ply, "los", ent) then return false end
		
		if (not ent:IsEFlagSet(EFL_DONTBLOCKLOS)) or skip_f_chk then return true end
		return false
	end,
	Action = function(self, ent)
		self:MsgStart()
			net.WriteEntity(ent)
			ent:AddEFlags(EFL_DONTBLOCKLOS)
		self:MsgEnd()
	end,
	Receive = function(self, length, player)
		local ent = net.ReadEntity()
		if not self:Filter(ent, player, true) then return end
		ent:AddEFlags(EFL_DONTBLOCKLOS)
	end
})

if SERVER then
	util.AddNetworkString("obj_npcroute_sync_los_status")
	hook.Add("PlayerInitialSpawn", "SyncLosStatus", function(ply)
		timer.Simple(0.1, function()
			if not IsValid(ply) then return end
			
			local entTable = {}
			for k,v in ipairs(ents.GetAll()) do
				if IsEligibleForLos(v) then
					table.insert(entTable, {v, v:IsEFlagSet(EFL_DONTBLOCKLOS)})
				end
			end
			
			if #entTable > 0 then
				net.Start("obj_npcroute_sync_los_status")
				net.WriteTable(entTable)
				net.Send(ply)
			end
		end)
	end)
	hook.Add("OnEntityCreated", "SyncLosStatus", function(ent)
		if IsEligibleForLos(ent) then
			timer.Simple(0.1, function()
				if IsEligibleForLos(ent) then
					net.Start("obj_npcroute_sync_los_status")
					local tbl = {}
					table.insert(tbl, {ent, ent:IsEFlagSet(EFL_DONTBLOCKLOS) })
					net.WriteTable(tbl)
					net.Broadcast()
				end
			end)
		end
	end)
else
	net.Receive("obj_npcroute_sync_los_status", function(len, ply)
		local tbl = net.ReadTable()
		for k,v in pairs(tbl) do
			if IsValid(v[1]) then
				if v[2] == true then
					v[1]:AddEFlags(EFL_DONTBLOCKLOS)
				else
					v[1]:RemoveEFlags(EFL_DONTBLOCKLOS)
				end
			end
		end
	end)
end

properties.Add("npctools2_remove_link", {
	MenuLabel = "Remove Links",
	Order = 9999,
	MenuIcon = "icon16/link_delete.png",
	Filter = function(self, ent, ply)
		if not IsValid(ent) then
			return false
		end
		if not gamemode.Call("CanProperty",ply,"npctools2_remove_link",ent) then return false end
		if ent:GetClass() ~= "obj_npcroute" then
			return false
		end
		return true
	end,
	MenuOpen = function(self, option, ent, tr)
		option:SetText("Node ID: "..ent:EntIndex())
		
		local allLinks = {}
		for k,v in ipairs(ent.m_links or ent.m_clientlinks) do
			table.insert(allLinks, {v[1],1})
		end
		for k,v in ipairs(ents.FindByClass("obj_npcroute")) do
			if v:HasDirectLinkTo(ent) then
				table.insert(allLinks, {v,2})
			end
		end
		table.sort(allLinks, function(a,b)
			if a[1]:EntIndex() == b[1]:EntIndex() then
				return a[2] < b[2]
			end
			return a[1]:EntIndex() < b[1]:EntIndex()
		end)
		if #allLinks > 0 then
			local subMenu = option:AddSubMenu()
			subMenu:AddOption("Remove All Links", function()
				self:RemoveAll(ent)
			end)
			
			for k,v in ipairs(allLinks) do
				if v[2] == 1 then
					subMenu:AddOption("Remove Link to " .. v[1]:EntIndex(), function() self:Remove(ent, v[1]) end)
				elseif v[2] == 2 then
					subMenu:AddOption("Remove Link from "..v[1]:EntIndex(), function() self:Remove(v[1], ent) end)
				end
			end
		end
	end,
	Action = function() end,
	Remove = function(self, ent, to)
		self:MsgStart()
			net.WriteString("ONE")
			net.WriteEntity(ent)
			net.WriteEntity(to)
		self:MsgEnd()
	end,
	RemoveAll = function(self, ent)
		self:MsgStart()
			net.WriteString("ALL")
			net.WriteEntity(ent)
		self:MsgEnd()
	end,
	Receive = function(self, length, player)
		local mode = net.ReadString()
		
		local ent = net.ReadEntity()
		if not IsValid(ent) then
			return
		end
		if not self:Filter(ent,player) then
			return
		end
		
		if mode == "ONE" then
			local otherEnt = net.ReadEntity()
			ent:RemoveLinkToEntity(otherEnt)
		elseif mode == "ALL" then
			ent:RemoveAllLinks()
			for k,v in ipairs(ents.FindByClass("obj_npcroute")) do
				if v ~= ent and v:HasDirectLinkTo(ent) then
					v:RemoveLinkToEntity(ent)
				end
			end
		end
	end
})