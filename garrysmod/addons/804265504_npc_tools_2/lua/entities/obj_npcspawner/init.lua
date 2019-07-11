
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

numpad.Register("npctool_spawner_turnon",function(pl,ent,pID)
	if(!ent:IsValid()) then return end
	ent:SetEnabled(true)
end)
numpad.Register("npctool_spawner_turnoff",function(pl,ent,pID)
	if(!ent:IsValid()) then return end
	ent:SetEnabled(false)
end)

AccessorFunc(ENT,"m_class","NPCClass",FORCE_STRING)
AccessorFunc(ENT,"m_squad","Squad",FORCE_STRING)
AccessorFunc(ENT,"m_equipment","NPCEquipment",FORCE_STRING)
AccessorFunc(ENT,"m_keyon","KeyTurnOn",FORCE_NUMBER)
AccessorFunc(ENT,"m_keyoff","KeyTurnOff",FORCE_NUMBER)
AccessorFunc(ENT,"m_delay","SpawnDelay",FORCE_NUMBER)
AccessorFunc(ENT,"m_max","MaxNPCs",FORCE_NUMBER)
AccessorFunc(ENT,"m_total","TotalNPCs",FORCE_NUMBER)
AccessorFunc(ENT,"m_bStartOn","StartOn",FORCE_BOOL)
AccessorFunc(ENT,"m_bDeleteOnRemove","DeleteOnRemove",FORCE_BOOL)
AccessorFunc(ENT,"m_bEnabled","Enabled",FORCE_BOOL)
AccessorFunc(ENT,"m_bPatrolWalk","PatrolWalk",FORCE_BOOL)
AccessorFunc(ENT,"m_patrolType","PatrolType",FORCE_NUMBER)
AccessorFunc(ENT,"m_bStrict","StrictMovement",FORCE_BOOL)
AccessorFunc(ENT,"m_spawnflags","NPCSpawnflags",FORCE_NUMBER)
AccessorFunc(ENT,"m_bBurrowed","NPCBurrowed",FORCE_BOOL)
AccessorFunc(ENT,"m_tbKeyValues","NPCKeyValues")
AccessorFunc(ENT,"m_proficiency","NPCProficiency",FORCE_NUMBER)
AccessorFunc(ENT,"m_tbNPCData","NPCData")
AccessorFunc(ENT,"m_patrolRoute","PatrolRoute")
AccessorFunc(ENT,"m_xp","XP",FORCE_NUMBER)
AccessorFunc(ENT,"m_startEntity","StartEntity")
AccessorFunc(ENT,"m_fadeTime","FadeTime",FORCE_NUMBER)
AccessorFunc(ENT,"m_patrolPointsDisabled","PatrolPointsDisabled",FORCE_BOOL)
AccessorFunc(ENT,"m_autoReverseRelationship","ReverseRelationship",FORCE_BOOL)
AccessorFunc(ENT,"m_dHealth","ScrNPCHealth",FORCE_NUMBER)
AccessorFunc(ENT,"m_dMaxHealth","ScrNPCMaxHealth",FORCE_NUMBER)

function ENT:UpdateRelationship(targetEnt)
	if targetEnt:IsNPC() then
		local class = self:GetNPCClass()
		local targetClass = targetEnt.ClassName or targetEnt:GetClass()
		local disposition = self.m_tbRelationships[targetClass:lower()]
		-- The second half of the next statement means: "if the NPC is different from us"
		if disposition and ((targetClass ~= class) or (not table.HasValue(self.m_tbNPCs,targetEnt))) then
			for _,npc in ipairs(self.m_tbNPCs) do
				if IsValid(npc) then
					npc:AddEntityRelationship(targetEnt, disposition)
					if targetEnt:IsNPC() and self:GetReverseRelationship() then
						targetEnt:AddEntityRelationship(npc,disp)
					end
				end
			end
		end
	elseif targetEnt:IsPlayer() then
		local class = self:GetNPCClass()
		local targetClass = targetEnt.ClassName or targetEnt:GetClass()
		local specificTargetClass = targetEnt:GetClass() .. ".team[" .. targetEnt:Team() .. "]"
		
		local disposition = self.m_tbRelationships[specificTargetClass:lower()]
		if not disposition then
			disposition = self.m_tbRelationships[targetClass:lower()]
		end
		if disposition then
			for _,npc in ipairs(self.m_tbNPCs) do
				if IsValid(npc) then
					npc:AddEntityRelationship(targetEnt, disposition)
				end
			end
		end
	end
end

function ENT:UpdateSingleRelationship(npc, targetEnt)
	if not IsValid(npc) then return end
	if targetEnt:IsNPC() then
		local class = self:GetNPCClass()
		local targetClass = targetEnt.ClassName or targetEnt:GetClass()
		local disposition = self.m_tbRelationships[targetClass:lower()]
		-- The second half of the next statement means: "if the NPC is different from us"
		if disposition and ((targetClass ~= class) or (not table.HasValue(self.m_tbNPCs,targetEnt))) then
			npc:AddEntityRelationship(targetEnt, disposition)
			if targetEnt:IsNPC() and self:GetReverseRelationship() then
				targetEnt:AddEntityRelationship(npc,disp)
			end
		end
	elseif targetEnt:IsPlayer() then
		local class = self:GetNPCClass()
		local targetClass = targetEnt.ClassName or targetEnt:GetClass()
		local specificTargetClass = targetEnt:GetClass() .. ".team[" .. targetEnt:Team() .. "]"
		
		local disposition = self.m_tbRelationships[specificTargetClass:lower()]
		if not disposition then
			disposition = self.m_tbRelationships[targetClass:lower()]
		end
		if disposition then
			npc:AddEntityRelationship(targetEnt, disposition)
		end
	end
end

function ENT:Initialize()
	self:SetNotSolid(true)
	self:DrawShadow(false)
	
	numpad.OnDown(self.entOwner,self:GetKeyTurnOn(),"npctool_spawner_turnon",self)
	numpad.OnDown(self.entOwner,self:GetKeyTurnOff(),"npctool_spawner_turnoff",self)
	
	self:SetEnabled(false)
	self.m_nextSpawn = CurTime() +self:GetSpawnDelay()
	self.m_tbNPCs = {}
	self.m_tbPatrolPoints = self.m_tbPatrolPoints || {}
	self.m_tbRelationships = self.m_tbRelationships || {}
	self.m_autoReverseRelationship = true
	if self:GetStartOn() then self:SetEnabled(true) end
	if(self.m_bShowEffects == nil) then self:ShowEffects(true) end
	self.m_tbClients = {}
	self.m_tbNPCData = self.m_tbNPCData || {}
	local idx = self:EntIndex()
	hook.Add("OnPlayerChangedTeam","npcspawner_updaterelationships"..idx, function(ent)
		if(!self:IsValid()) then hook.Remove("OnPlayerChangedTeam","npcspawner_updaterelationships"..idx)
		elseif IsValid(ent) then self:UpdateRelationship(ent) end
	end)
	hook.Add("OnEntityCreated","npcspawner_updaterelationships" .. idx,function(ent)
		if(!self:IsValid()) then hook.Remove("OnEntityCreated","npcspawner_updaterelationships" .. idx)
		elseif IsValid(ent) then self:UpdateRelationship(ent) end
	end)
end

function ENT:GetNPCData() return self.m_tbNPCData end

function ENT:ShowEffects(b)
	self.m_bShowEffects = b
	if(!b) then
		if(IsValid(self.m_entEffect)) then self.m_entEffect:Remove() end
		self.m_entEffect = nil
		return
	end
	if(IsValid(self.m_entEffect)) then return end
	local e = ents.Create("env_effectscript")
	e:SetPos(self:GetPos())
	e:SetParent(self)
	e:SetModel("models/Effects/teleporttrail_Alyx.mdl")
	e:SetKeyValue("scriptfile","scripts/effects/testeffect.txt")
	e:Spawn()
	e:Activate()
	e:Fire("SetSequence","teleport",0)
	self:DeleteOnRemove(e)
	self.m_nextEffect = CurTime() +8
	self.m_entEffect = e
end

function ENT:AddPatrolPoint(vec)
	self.m_tbPatrolPoints = self.m_tbPatrolPoints || {}
	local ent = ents.Create("obj_patrolpoint")
	ent:SetPos(vec)
	ent:SetWalk(self:GetPatrolWalk())
	ent:SetType(self:GetPatrolType())
	ent:SetStrictMovement(self:GetStrictMovement())
	ent:Spawn()
	ent:Activate()
	local ptype = self:GetPatrolType()
	if ptype == 3 && self.m_tbPatrolPoints[1] then ent:SetNextPatrolPoint(self.m_tbPatrolPoints[1])
	elseif ptype == 2 && #self.m_tbPatrolPoints > 0 then ent:SetLastPatrolPoint(self.m_tbPatrolPoints[#self.m_tbPatrolPoints]) end
	if self.m_tbPatrolPoints[#self.m_tbPatrolPoints] then self.m_tbPatrolPoints[#self.m_tbPatrolPoints]:SetNextPatrolPoint(ent) end
	table.insert(self.m_tbPatrolPoints, ent)
	
	self:DeleteOnRemove(ent)
end

function ENT:SetEntityOwner(ent)
	self.entOwner = ent
end

function ENT:SpawnNPC()
	for i = #self.m_tbNPCs,1,-1 do
		local ent = self.m_tbNPCs[i]
		if (not IsValid(ent)) or (ent:Health() < 0)then
			table.remove(self.m_tbNPCs,i)
		end
	end
	
	if(#self.m_tbNPCs >= self:GetMaxNPCs()) then
		return
	end
	
	if self.m_obbMaxNPC then
		-- Anything blocking the spawn?
		for _,ent in ipairs(ents.FindInBox(self:LocalToWorld(self.m_obbMinNPC) +self:GetUp() *25,self:LocalToWorld(self.m_obbMaxNPC) +self:GetUp() *25)) do
			if IsValid(ent) and (IsValid(ent:GetPhysicsObject()) or ent:IsNPC() or ent:IsPlayer()) and !ent:IsWeapon() then
				return
			end
		end
	end
	
	-- Spawn sound fx
	if self.m_bShowEffects then
		self:EmitSound("beams/beamstart5.wav",75,100)
	end
	
	local class = self:GetNPCClass()
	local npc = ents.Create(class)
	if not IsValid(npc) then
		ErrorNoHalt("Warning: Invalid npc class '" .. class .. "' for NPC Spawner! Removing...")
		self:Remove()
		return
	end
	
	table.insert(self.m_tbNPCs,npc)
	if IsValid(self.entOwner) then
		cleanup.Add(self.entOwner,"npcs",npc)
	end
	
	npc:SetPos(self:GetPos() + self:GetUp() * 25)
	npc:SetAngles(Angle(0,self:GetAngles().y,0))
	local equip = self:GetNPCEquipment()
	local spawnflags = self:GetNPCSpawnflags()
	local burrowed = self:GetNPCBurrowed()
	local data = self:GetNPCData()
	local flags = spawnflags || 0
	local keyvalues = self:GetNPCKeyValues()
	local squad = self:GetSquad()
	local proficiency = self:GetNPCProficiency()
	local tbRel = self.m_tbRelationships
	local startEnt = self:GetStartEntity()
	local startHealth = self:GetScrNPCHealth()
	local maxHealth = self:GetScrNPCMaxHealth()
	
	if equip ~= "" and equip ~= "_default_weapon" then
		local realEquipment = ""
		for k,v in pairs(list.Get("NPCUsableWeapons")) do
			if v.class == equip then
				realEquipment = v.class
				break
			end
		end
		equip = realEquipment
	end
	
	if equip and equip ~= "_default_weapon" then
		npc:SetKeyValue("additionalequipment",equip)
		npc.Equipment = equip
	end
	if data.SpawnFlags then
		flags = bit.bor(flags,data.SpawnFlags)
	end
	npc:SetKeyValue("spawnflags",flags)
	if burrowed then
		npc:SetKeyValue("startburrowed","1")
	end
	if data.KeyValues then
		for key,val in pairs(data.KeyValues) do
			npc:SetKeyValue(key,val)
		end
	end
	if keyvalues then
		for key,val in pairs(keyvalues) do
			npc:SetKeyValue(key,val)
		end
	end
	
	npc:Spawn()
	npc:Activate()
	
	if data.Model then
		npc:SetModel(data.Model)
	end
	
	if data.Skin then
		npc:SetSkin(data.Skin)
	end
	
	if proficiency == 5 then
		npc:SetCurrentWeaponProficiency(math.random(0,4))
	elseif proficiency != 6 then
		npc:SetCurrentWeaponProficiency(proficiency)
	end
	
	if burrowed then
		npc:Fire("unburrow","",0)
	end
	if (not equip) or equip == "" then
		npc:Fire("HolsterAndDestroyWeapon","",0)
	end
	
	if not self.m_obbMaxNPC then
		self.m_obbMinNPC = npc:OBBMins()
		self.m_obbMaxNPC = npc:OBBMaxs()
	end
	
	if squad and squad ~= "" then
		npc:Fire("setsquad",squad,0)
	end
	
	if maxHealth and maxHealth > 0 then
		npc:SetMaxHealth(maxHealth)
	end
	
	if startHealth and startHealth > 0 then
		npc:SetHealth(startHealth)
	end
	
	if self:GetDeleteOnRemove() then
		self:DeleteOnRemove(npc)
	end
	
	if IsValid(startEnt) then
		startEnt:QueueNPC(npc)
	elseif self.m_tbPatrolPoints[1] and (not self:GetPatrolPointsDisabled()) then
		self.m_tbPatrolPoints[1]:AddNPC(npc)
	end
	
	local total = self:GetTotalNPCs()
	if total > 0 then
		total = total - 1
		self:SetTotalNPCs(total)
		if total == 0 then
			for _,npc in ipairs(self.m_tbNPCs) do
				if npc:IsValid() then
					self:DontDeleteOnRemove(npc)
				end
			end
			self:Remove()
			return
		end
	end
	
	npc:SetVar("GiveXP",self:GetXP())
	npc:SetVar("FadeTime",self:GetFadeTime())
	for k,v in ipairs(ents.GetAll()) do
		self:UpdateSingleRelationship(npc,v)
	end
end

hook.Add("CreateEntityRagdoll","obj_npcspawner_fadetime",function(src,dst)
	if src:GetVar("FadeTime") and src:GetVar("FadeTime") > 0 then
		local val = src:GetVar("FadeTime")
		timer.Simple(val,
		function()
			if IsValid(dst) then
				dst:Fire("FadeAndRemove",0.5)
			end
		end)
	end
end)

function ENT:SetDisposition(class,disp)
	self.m_tbRelationships = self.m_tbRelationships || {}
	self.m_tbRelationships[class:lower()] = disp
end


function ENT:Think()
	if(IsValid(self.m_entEffect) && CurTime() > self.m_nextEffect) then self.m_entEffect:Fire("SetSequence","teleport",0); self.m_nextEffect = CurTime() +8 end
	if(!self:GetEnabled()) then return end
	if(CurTime() >= self.m_nextSpawn) then
		self.m_nextSpawn = CurTime() + self:GetSpawnDelay()
		self:SpawnNPC()
	end
end

function ENT:AcceptInput(cvar,activator,caller) end

function ENT:OnRemove()
	hook.Remove("OnEntityCreated","npcspawner_updaterelationships" .. self:EntIndex())
	hook.Remove("OnPlayerChangedTeam","npcspawner_updaterelationships" .. self:EntIndex())
end

local hook = (hook.GetTable()["OnNPCKilled"] or {})["manolis:MVLevels:OnNPCKilledBC"]
if hook then
	hook.Add("OnNPCKilled","manolis:MVLevels:OnNPCKilledBC",function(npc,killer,weapon)
		if(LevelSystemConfiguration.NPCXP) then
			if(npc != killer) then // Not a suicide? Somehow.
				if(killer:IsPlayer()) then
					local XP = killer:addXP(npc:GetVar("GiveXP") or LevelSystemConfiguration.NPCXPAmount, true)
					if(XP) then
						DarkRP.notify(killer, 0,4,'You got '..XP..'XP for killing an NPC.')
					end
				end
			end
		end
	end)
end