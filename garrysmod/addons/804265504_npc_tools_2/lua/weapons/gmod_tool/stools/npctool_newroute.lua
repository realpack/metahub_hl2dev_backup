TOOL.Category = "NPC Tools 2"
TOOL.Name = "NPC Route Creator - New!"
TOOL.Command = nil
TOOL.ConfigName = ""

local ToolData = {
	preset = "Default",
	
	-- Serverside Data
	server = {
		spawners = {},
		data = {},
		conVars = {}
	}
}

---------------------- CLIENT ----------------------
if CLIENT then

TOOL.Information = {
	{ name = "left", stage = 0 },
	{ name = "right", stage = 0 },
	{ name = "reload", stage = 0, op = 0 },
	{ name = "reload_1", stage = 1, op = 0 },
	{ name = "right_1", stage = 1, op = 0 }
}

language.Add("tool.npctool_newroute.name","NPC Route Creator - New!")
language.Add("tool.npctool_newroute.desc","Create a Route for use with the NPC Spawner")
language.Add("tool.npctool_newroute.left","Create or select a route point or make a NPC follow the selected point")
language.Add("tool.npctool_newroute.right","Remove a route point or make a NPC follow the selected point")
language.Add("tool.npctool_newroute.right_1","Cancel Link")
language.Add("tool.npctool_newroute.reload","Start a connection")
language.Add("tool.npctool_newroute.reload_1","Finish the connection")

TOOL.ClientConVar["show"] = 0
TOOL.ClientConVar["show_dh"] = 0 -- DrawHolster
TOOL.ClientConVar["showchance"] = 1
TOOL.ClientConVar["showid"] = 1
TOOL.ClientConVar["autoconnect"] = 1
TOOL.ClientConVar["physics"] = 0
TOOL.ClientConVar["link_walktype"] = 1
TOOL.ClientConVar["link_strict"] = 0
TOOL.ClientConVar["link_wait"] = 0
TOOL.ClientConVar["link_chance"] = 100
TOOL.ClientConVar["link_twoway"] = 1

local ConVarsDefault = TOOL:BuildConVarList()

local function CreateSaveDialog(title, func)
	local Panel = vgui.Create("DFrame")
	Panel:SetSize(220,110)
	Panel:Center()
	Panel:MakePopup()
	Panel:ShowCloseButton(true)
	Panel:SetTitle(title)
	
	local NameLabel = vgui.Create("DLabel",Panel)
	NameLabel:SetText("Name:")
	NameLabel:SetPos(20,40)
	NameLabel:SizeToContents()
	
	local TextEntry = vgui.Create("DTextEntry",Panel)
	TextEntry:SetSize(146,16)
	TextEntry:SetPos(55,42)
	
	local ButtonSave = vgui.Create("DButton",Panel)
	ButtonSave:SetText("Save")
	ButtonSave:SetSize(180,21)
	ButtonSave:SetPos(20,70)
	ButtonSave.DoClick = function()
		Panel:Close()
		if TextEntry:GetValue() == "" then
			return
		end
		func(TextEntry:GetValue())
	end
	TextEntry.OnEnter = ButtonSave.DoClick
end

function TOOL.BuildCPanel(panel)
	panel:ClearControls()
	panel:Help("Left-Click to create a point. Right-Click on a point to remove it. Reload to start a connection. Context-Menu on a point to remove a connection.")
	
	ToolData.CollapsiblePreset = vgui.Create("DForm",panel)
	panel:AddItem(ToolData.CollapsiblePreset)
	
	ToolData.ShowPoints = panel:CheckBox("Show Points without the Tool Gun","npctool_newroute_show")
	ToolData.ShowChances = panel:CheckBox("Show Chances","npctool_newroute_showchance")
	ToolData.ShowId = panel:CheckBox("Show Node ID","npctool_newroute_showid")
	ToolData.AutoConnect = panel:CheckBox("Auto Connect","npctool_newroute_autoconnect")
	ToolData.PhysicsEnabled = panel:CheckBox("Pyhsics Enabled","npctool_newroute_physics")
	ToolData.CollapsibleLink = vgui.Create("DForm",panel)
	panel:AddItem(ToolData.CollapsibleLink)
	
	---- PresetComboBox
	ToolData.CollapsiblePreset:SetExpanded(false)
	ToolData.CollapsiblePreset:SetName("Presets")
	ToolData.PresetComboBox = ToolData.CollapsiblePreset:ComboBox("Routes:")
	ToolData.LoadPresetButton = ToolData.CollapsiblePreset:Button("Load Route")
	ToolData.SavePresetButton = ToolData.CollapsiblePreset:Button("Save Routes")
	ToolData.RemvPresetButton = ToolData.CollapsiblePreset:Button("Remove Route")
	
	ToolData.PresetComboBox:SetSortItems(false)
	ToolData.PresetComboBox.UpdateData = function()
		ToolData.PresetComboBox:Clear()
		ToolData.PresetComboBox.OnSelect = function() end
		ToolData.PresetComboBox:AddChoice("Remove All Routes",true)
		local IDSelected = 1
		for _,f in ipairs(file.Find("npcspawner2/"..game.GetMap():lower().."/*.txt","DATA")) do
			local n = string.sub(f,1,-5)
			local i = ToolData.PresetComboBox:AddChoice(n)
			if n == ToolData.preset then
				IDSelected = i
			end
		end
		ToolData.PresetComboBox:ChooseOptionID(IDSelected)
	end
	ToolData.PresetComboBox:UpdateData()
	ToolData.LoadPresetButton.DoClick = function()
		local val = ToolData.PresetComboBox:GetSelected()
		ToolData.preset = val
		if val == "Remove All Routes" then
			net.Start("npctool_newroute_requestclear")
			net.SendToServer()
		else
			local content = file.Read("npcspawner2/"..game.GetMap():lower().."/"..val..".txt","DATA")
			if not content then return end
			local compressed = util.Compress(content)
			local length = compressed:len()
			local send_size = 60000
			local parts = math.ceil(length / send_size)
			
			local start = 0
			for i=1, parts do
				local endbyte = math.min(start+send_size, length)
				local size = endbyte - start
				net.Start("npctool_newroute_requestload")
				net.WriteUInt(i,8)
				net.WriteUInt(parts,8)
				net.WriteUInt(size,32)
				net.WriteData(compressed:sub(start+1,endbyte+1),size)
				net.SendToServer()
				start = endbyte
			end
		end
	end
	ToolData.SavePresetButton.DoClick = function()
		CreateSaveDialog("NPC Route", function(name)
			if string.Right(name,4) != ".txt" then
				name = name..".txt"
			end
			local data = {}
			
			local tbl = {}
			for k,v in pairs(ents.FindByClass("obj_npcroute")) do
				if IsValid(v) then
					table.insert(tbl,v)
				end
			end
			
			for k,v in ipairs(tbl) do
				local ent = {}
				ent.x = v:GetPos().x
				ent.y = v:GetPos().y
				ent.z = v:GetPos().z
				ent.p = v:IsPhysicsEnabled()
				ent.l = {}
				
				for x,y in ipairs(v.m_clientlinks) do
					if IsValid(y[1]) then
						for kk,kv in ipairs(tbl) do
							if kv == y[1] then
								table.insert(ent.l, {kk,y[2],y[3],y[4],y[5]})
								break
							end
						end
					end
				end
				table.insert(data,ent)
			end
			
			file.CreateDir("npcspawner2")
			file.CreateDir("npcspawner2/"..game.GetMap():lower())
			file.Write("npcspawner2/"..game.GetMap():lower().."/"..name,util.TableToJSON(data))
			ToolData.PresetComboBox:UpdateData()
		end)
	end
	ToolData.RemvPresetButton.DoClick = function()
		local val = ToolData.PresetComboBox:GetSelected()
		if val ~= "Remove All Routes" then
			file.Delete("npcspawner2/"..game.GetMap():lower().."/"..val..".txt")
			ToolData.PresetComboBox:UpdateData()
		end
	end
	---- PresetComboBox End
	
	---- CollapsibleLink
	ToolData.CollapsibleLink:SetExpanded(true)
	ToolData.CollapsibleLink:SetName("Link Properties")
	ToolData.Link_WalkType = ToolData.CollapsibleLink:ComboBox("Walk Type:","npctool_newroute_link_walktype")
	ToolData.Link_Force = ToolData.CollapsibleLink:CheckBox("Force Straight Path","npctool_newroute_link_strict")
	ToolData.Link_TwoWay = ToolData.CollapsibleLink:CheckBox("Two-Way Link","npctool_newroute_link_twoway")
	ToolData.Link_Chance = ToolData.CollapsibleLink:NumSlider("Chances to choose this path:","npctool_newroute_link_chance",1,100,0)
	ToolData.Link_WaitTime = ToolData.CollapsibleLink:NumSlider("At the end of this link, wait:","npctool_newroute_link_wait",0,120,1)
	
	local choiceTable = {
		{"Run",1},
		{"Walk",2}
		--,{"Crouch",3},
		--{"Crouch Run",4}
	}
	ToolData.Link_WalkType.UpdateData = function()
		ToolData.Link_WalkType:Clear()
		ToolData.Link_WalkType:SetSortItems(false)
		local currentType = GetConVarString("npctool_newroute_link_walktype")
		for k,v in ipairs(choiceTable) do
			local showDefault = false
			if currentType == v[2] then
				showDefault = true
			end
			ToolData.Link_WalkType:AddChoice(v[1],v[2],showDefault)
		end
	end
	ToolData.Link_WalkType:UpdateData()
	---- CollapsibleLink End
	
	---- NumSliders
	ToolData.Link_Chance.Scratch:SetDecimals(0)
	ToolData.Link_WaitTime.Scratch:SetDecimals(1)
	---- NumSliders end
end

function TOOL:Think()
	local cv = GetConVar("npctool_newroute_show_dh")
	if cv:GetInt() ~= 1 then
		cv:SetInt(1)
	end
	if timer.Exists("npctool_newroute_show_dh_timer") then
		timer.Remove("npctool_newroute_show_dh_timer")
	end
	timer.Create("npctool_newroute_show_dh_timer",0.2,1,function()
		GetConVar("npctool_newroute_show_dh"):SetInt(0)
	end)
end

net.Receive("npctool_newroute_requestselection", function(len, ply)
	local mode = net.ReadString()
	local args = net.ReadTable()
	net.Start("npctool_newroute_sendselection")
	net.WriteEntity(LocalPlayer():GetVar("obj_npcroute_selected"))
	net.WriteString(mode)
	net.WriteTable(args)
	net.SendToServer()
end)

end
---------------------- CLIENT end ----------------------

---------------------- SERVER ----------------------
local resendLinkDelay = 0.1
local resendLinkDelayRetry = 1.0

if SERVER then
util.AddNetworkString("npctool_newroute_requestclear")
util.AddNetworkString("npctool_newroute_requestload")
util.AddNetworkString("npctool_newroute_sendlastpoint")

util.AddNetworkString("npctool_newroute_requestselection")
util.AddNetworkString("npctool_newroute_sendselection")

net.Receive("npctool_newroute_requestclear", function(len,ply)
	local tbl = ents.FindByClass("obj_npcroute")
	for k,v in pairs(tbl) do
		if IsValid(v) then v:Remove() end
	end
end)

local user_buffers = {}

function ResetBuffer(player)
	user_buffers[player] = {size=0,sectors={}}
end


function ComputeLoad(player)
	local buffer = ""
	for i=1, user_buffers[player].size do
		buffer = buffer .. user_buffers[player].sectors[i]
	end
	local uncompressed = util.Decompress(buffer)
	if !uncompressed then
		MsgN("Could not decompress route data!")
		return
	end
	
	local points = util.JSONToTable(uncompressed)
	local all_entities = {}
	
	local failed = false
	for k,v in ipairs(points) do
		local currentEntity = ents.Create("obj_npcroute")
		if not IsValid(currentEntity) then failed = true break end
		table.insert(all_entities, currentEntity)
		currentEntity:LockAutoUpdate()
		currentEntity:SetPos(Vector(v.x,v.y,v.z))
		currentEntity:Spawn()
		currentEntity:Activate()
		currentEntity:SetPhysicsEnabled(v.p)
		points[k].entity = currentEntity
	end
	
	if not failed then
		-- For each point
		for k,v in ipairs(points) do
			-- For each link of which our point is the source
			for x,y in ipairs(v.l) do
				if IsValid(points[ y[1] ].entity) then
					v.entity:CreateLink(points[ y[1] ].entity, y[2], y[3], y[4], y[5])
				else
					failed = true
					break
				end
			end
		end
	end
	
	if failed == true then
		for k,v in ipairs(all_entities) do
			v:Remove()
		end
		return
	end
	
	for k,v in ipairs(all_entities) do
		cleanup.Add(player,"npcs",v)
		v:UnlockAutoUpdate()
	end
	timer.Simple(resendLinkDelay, function()
		for k,v in ipairs(all_entities) do
			v:UpdateClientLinks()
		end
	end)
	timer.Simple(resendLinkDelayRetry, function()
		for k,v in ipairs(all_entities) do
			v:UpdateClientLinks()
		end
	end)
	undo.Create("SENT")
		for k,v in ipairs(all_entities) do
			undo.AddEntity(v)
		end
		undo.SetPlayer(player)
		undo.SetCustomUndoText("Undone Loaded NPC Route")
	undo.Finish("Scripted Entity (Loaded NPC Route)")
end

function ComputeLoad_Sector(player, part, total, data)
	if user_buffers[player] == nil then
		user_buffers[player] = {size=total,sectors={}}
	end
	
	if user_buffers[player].size ~= total then
		ResetBuffer(player)
		return
	end
	
	user_buffers[player].sectors[part] = data
	for i=1, user_buffers[player].size do
		if user_buffers[player].sectors[i] == nil then
			return
		end
	end
	ComputeLoad(player)
end

net.Receive("npctool_newroute_requestload", function(len,ply)
	local part = net.ReadUInt(8)
	local total = net.ReadUInt(8)
	local ln = net.ReadUInt(32)
	local data = net.ReadData(ln)
	ComputeLoad_Sector(ply,part,total,data)
end)

local RequiredConVars = {
	"autoconnect",
	"physics",
	"link_walktype",
	"link_strict",
	"link_wait",
	"link_chance",
	"link_twoway"
}

function TOOL:RequestSpawn(spawnPos, ply, parent)
	local RoutePointEntity = ents.Create("obj_npcroute")
	if not IsValid(RoutePointEntity) then
		MsgN("Could not create Route Point Entity (obj_npcroute).")
		return
	end
	
	RoutePointEntity:SetPos(spawnPos)
	if IsValid(parent) then
		RoutePointEntity.parentPoint = parent
	end
	RoutePointEntity:Spawn()
	RoutePointEntity:Activate()
	RoutePointEntity:SetPhysicsEnabled(tonumber(ply:GetInfo("npctool_newroute_physics")) ~= 0)
	
	cleanup.Add(ply,"npcs",RoutePointEntity)
	undo.Create("SENT")
		undo.AddEntity(RoutePointEntity)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone NPC Route Point")
	undo.Finish("Scripted Entity (NPC Route Point)")
	return RoutePointEntity
end

function TOOL:RequestLink(entFrom, entTo, ply)
	if IsValid(entFrom) and IsValid(entTo) then
		local conVars = {}
		for k,v in ipairs(RequiredConVars) do
			conVars[v] = ply:GetInfo("npctool_newroute_"..v)
		end
		
		local firstLink = entFrom:CreateLink(entTo, tonumber(conVars.link_walktype), tonumber(conVars.link_strict), tonumber(conVars.link_wait), tonumber(conVars.link_chance))
		local secondLink = true
		if tonumber(conVars.link_twoway) ~= 0 then
			secondLink = entTo:CreateLink(entFrom, tonumber(conVars.link_walktype), tonumber(conVars.link_strict), tonumber(conVars.link_wait), tonumber(conVars.link_chance))
			timer.Simple(resendLinkDelay, function()
				if IsValid(entTo) then
					entTo:UpdateClientLinks()
				end
			end)
			timer.Simple(resendLinkDelayRetry, function()
				if IsValid(entTo) then
					entTo:UpdateClientLinks()
				end
			end)
		end
		return (firstLink and secondLink)
	end
	return false
end

function TOOL:RequestSelection(purpose, args)
	net.Start("npctool_newroute_requestselection")
	net.WriteString(purpose)
	net.WriteTable(args)
	net.Send(self:GetOwner())
end

net.Receive("npctool_newroute_sendselection", function(len, ply)
	local selection = net.ReadEntity()
	local mode = net.ReadString()
	local args = net.ReadTable()
	local slf = ply.npctool_newroute
	
	if mode == "create_point" then
		local entity = slf:RequestSpawn(args[1],ply,selection)
		if IsValid(entity) then
			MsgN("Entity valid.")
			if tonumber(ply:GetInfo("npctool_newroute_autoconnect")) ~= 0 and IsValid(selection) then
				MsgN("Requested link.")
				slf:RequestLink(selection,entity,ply)
			end
			
			entity:SetSelected(ply, true)
		end
	elseif mode == "assign_npc" then
		if IsValid(args[1]) and args[1]:IsNPC() and IsValid(selection) then
			selection:QueueNPC(args[1])
		end
	end
end)

end
---------------------- SERVER end ----------------------

---------------------- SHARED ----------------------
local STG_POINT = 0
local STG_LINK = 1

function TOOL:LeftClick(trace)
	self:GetOwner().npctool_newroute = self
	if self:GetStage() == STG_POINT then
		if CLIENT then return true end
		
		if IsValid(trace.Entity) and trace.Entity:GetClass() == "obj_npcroute" then
			trace.Entity:SetSelected(self:GetOwner())
			return false
		end
		
		if IsValid(trace.Entity) and trace.Entity:IsNPC() then
			self:RequestSelection("assign_npc", {trace.Entity})
			return true
		end
		
		self:RequestSelection("create_point", {trace.HitPos + trace.HitNormal * 10})
		return true
	end
	return false
end

function TOOL:RightClick(trace)
	self:GetOwner().npctool_newroute = self
	if self:GetStage() == STG_POINT then
		if IsValid(trace.Entity) and trace.Entity:IsNPC() then
			if CLIENT then return true end
			self:RequestSelection("assign_npc", {trace.Entity})
			return true
		end
		
		if IsValid(trace.Entity) and trace.Entity:GetClass() == "obj_npcroute" then
			if CLIENT then return true end
			trace.Entity:Remove()
			return true
		end
	elseif self:GetStage() == STG_LINK then
		if CLIENT then return true end
		self:SetStage(STG_POINT)
		return true
	end
	return false
end

function TOOL:Reload(trace)
	self:GetOwner().npctool_newroute = self
	if self:GetStage() == STG_POINT then
		if IsValid(trace.Entity) and trace.Entity:GetClass() == "obj_npcroute" then
			if CLIENT then return true end
			self.m_connStart = trace.Entity
			self:SetStage(STG_LINK)
			return true
		end
		return false
	elseif self:GetStage() == STG_LINK then
		if IsValid(trace.Entity) and trace.Entity:GetClass() == "obj_npcroute" then
			if CLIENT then return true end
			if trace.Entity == self.m_connStart then return false end
			local rv = self:RequestLink(self.m_connStart,trace.Entity,self:GetOwner())
			if rv == true then self:SetStage(STG_POINT) end
			return rv
		end
		return false
	end
end
---------------------- SHARED end ----------------------