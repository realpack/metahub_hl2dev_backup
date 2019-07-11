TOOL.Category = "NPC Tools 2"
TOOL.Name = "NPC Spawn Creator - New!"
TOOL.Command = nil
TOOL.ConfigName = ""


local WEAPON_PROFICIENCY_RANDOM = 5

local ToolData = {
	preset = "Default",
	keyValues = {},
	relationships = {},
	
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
	{ name = "left" },
	{ name = "right" }
}

language.Add("tool.npctool_newspawner.name","NPC Spawn Creator - New!")
language.Add("tool.npctool_newspawner.desc","Create an automatic NPC Spawner")
language.Add("tool.npctool_newspawner.left","Create a spawner or select a route point")
language.Add("tool.npctool_newspawner.right","Remove the nearest spawner")

local REL_HATE = 1
local REL_FEAR = 2
local REL_LIKE = 3
local REL_NEUT = 4

local flags =
{
	{1        ,"Wait until seen"},
	{2        ,"Gag (No idle sounds until angry)"},
	{4        ,"Fall to ground (Otherwise teleport to ground)"},
	{8        ,"Drop healthkit"},
	{16       ,"Efficient"},
	{32       ,"N/A"},
	{64       ,"N/A"},
	{128      ,"Wait for script"},
	{256      ,"Long visibility"},
	{512     ,"Fade corpse"},
	{1024    ,"Think outside its potentially visible set"},
	{2048    ,"Template NPC"},
	{4096    ,"Alternate collision for this NPC"},
	{8192    ,"Don't drop weapons"},
	{16384   ,"Ignore player push"},
	{32768   ,"N/A"},
	{65536   ,"Follow player on spawn"},
	{131072  ,"Medic"},
	{262144  ,"Random head"},
	{524288  ,"Ammo resupplier"},
	{1048576 ,"Not commandable"},
	{2097152 ,"Don't use speech semaphore (obsolete)"},
	{4194304 ,"Random male head"},
	{8388608 ,"Random female head"},
	{16777216,"Use RenderBox in ActBusies"}
}
TOOL.ClientConVar["class"] = "npc_zombie"
TOOL.ClientConVar["squad"] = ""
for k,v in ipairs(flags) do
	TOOL.ClientConVar["flag"..k] = 0
end
TOOL.ClientConVar["equipment"] = ""
TOOL.ClientConVar["delay"] = 4
TOOL.ClientConVar["max"] = 4
TOOL.ClientConVar["total"] = 0
TOOL.ClientConVar["turnon"] = ""
TOOL.ClientConVar["turnoff"] = ""
TOOL.ClientConVar["starton"] = 1
TOOL.ClientConVar["startburrowed"] = 1
TOOL.ClientConVar["deleteonremove"] = 1
TOOL.ClientConVar["fadetime"] = 3
TOOL.ClientConVar["starthealth"] = 0
TOOL.ClientConVar["maxhealth"] = 0

TOOL.ClientConVar["showeffects"] = 1
TOOL.ClientConVar["proficiency"] = WEAPON_PROFICIENCY_AVERAGE
TOOL.ClientConVar["xp"] = 10

TOOL.preset = "Default"

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
	panel:Help("Left-Click to create a spawner. Right-Click to remove a spawner. Left-Click on a patrol point to make NPCs follow that node.")
	
	ToolData.PresetComboBox = panel:ComboBox("Preset:")
	ToolData.SavePresetButton = panel:Button("Save Preset")
	
	ToolData.NpcClassSearchBox = panel:TextEntry("Search NPC:")
	ToolData.NpcClassList = vgui.Create("DListView",panel)
	ToolData.NpcClassList:SetHeight(150)
	panel:AddItem(ToolData.NpcClassList)
	
	ToolData.CollapsibleFlag = vgui.Create("DForm",panel)
	panel:AddItem(ToolData.CollapsibleFlag)
	
	ToolData.Equipment = panel:ComboBox("Equipment","npctool_newspawner_equipment")
	ToolData.Proficiency = panel:ComboBox("Proficiency","npctool_newspawner_proficiency")
	ToolData.SpawnDelay = panel:NumSlider("Spawn Delay","npctool_newspawner_delay",1,180,1)
	ToolData.MaxAliveNPCs = panel:NumSlider("Max Alive NPCs","npctool_newspawner_max",1,50,0)
	ToolData.TotalNPCAmount = panel:NumSlider("Total NPC Amount","npctool_newspawner_total",0,250,0)
	ToolData.FadeTime = panel:NumSlider("Fade after seconds","npctool_newspawner_fadetime",0,360,1)
	panel:ControlHelp("Only works when Keep Corpses is enabled.")
	ToolData.Inputs = panel:AddControl("Numpad", {Label = "#Turn On", Label2 = "#Turn Off", Command = "npctool_newspawner_turnon", Command2 = "npctool_newspawner_turnoff", ButtonSize=16})
	
	ToolData.ShowEffects = panel:CheckBox("Show Effects","npctool_newspawner_showeffects")
	ToolData.StartOn = panel:CheckBox("Start On","npctool_newspawner_starton")
	ToolData.StartBurrowed = panel:CheckBox("Start Burrowed","npctool_newspawner_startburrowed")
	ToolData.RemoveNPCs = panel:CheckBox("Remove spawned NPCs on removal","npctool_newspawner_deleteonremove")
	
	ToolData.StartHealth = panel:NumSlider("Start Health","npctool_newspawner_starthealth",0,1000,0)
	ToolData.MaxHealth = panel:NumSlider("Max Health","npctool_newspawner_maxhealth",0,1000,0)
	
	ToolData.CollapsibleKeyVal = vgui.Create("DForm",panel)
	panel:AddItem(ToolData.CollapsibleKeyVal)
	
	ToolData.CollapsibleRel = vgui.Create("DForm",panel)
	panel:AddItem(ToolData.CollapsibleRel)
	
	if LevelSystemConfiguration then
		ToolData.Experience = panel:NumSlider("Give XP","npctool_newspawner_xp",0,16777215,0)
	end
	
	---- PresetComboBox
	ToolData.PresetComboBox:SetSortItems(false)
	ToolData.PresetComboBox.UpdateData = function()
		ToolData.PresetComboBox:Clear()
		ToolData.PresetComboBox.OnSelect = function() end
		ToolData.PresetComboBox:AddChoice("Default",true)
		local IDSelected = 1
		
		for _,f in ipairs(file.Find("npcspawner2/*.txt","DATA")) do
			local n = string.sub(f,1,-5)
			local i = ToolData.PresetComboBox:AddChoice(n)
			if n == ToolData.preset then
				IDSelected = i
			end
		end
		ToolData.PresetComboBox:ChooseOptionID(IDSelected)
		ToolData.PresetComboBox.OnSelect = function(_,__,val)
			ToolData.preset = val
			ToolData.keyValues = {}
			ToolData.relationships = {}
			if val == "Default" then
				for k,v in pairs(ConVarsDefault) do
					RunConsoleCommand(k,v)
				end
			else
				local content = file.Read("npcspawner2/" .. val .. ".txt","DATA")
				if not content then return end
				
				local data = util.JSONToTable(content)
				if data.keyValues then
					ToolData.keyValues = data.keyValues
				end
				if data.relationships then
					ToolData.relationships = data.relationships
				end
				for k,v in pairs(ConVarsDefault) do
					if k:StartWith("npctool_newspawner_") and data.cvars[k:sub( ("npctool_newspawner_"):len()+1)] then
						RunConsoleCommand(k,data.cvars[k:sub( ("npctool_newspawner_"):len()+1)])
					end
				end
			end
			
			ToolData.NpcClassSearchBox:SetValue("")
			for k,v in pairs(ToolData) do
				if type(v) == "Panel" and v.UpdateDataUI and type(v.UpdateDataUI) == "function" then
					v:UpdateDataUI()
				end
			end
		end
	end
	ToolData.PresetComboBox:UpdateData()
	---- PresetComboBox End
	
	---- SavePresetButton
	ToolData.SavePresetButton.DoClick = function()
		CreateSaveDialog("NPC Spawner Settings", function(name)
			if string.Right(name,4) != ".txt" then
				name = name .. ".txt"
			end
			local data = {}
			data.cvars = {}
			for k,v in pairs(ConVarsDefault) do
				if k:StartWith("npctool_newspawner_") then
					data.cvars[k:sub( ("npctool_newspawner_"):len()+1 )] = GetConVarString(k)
				end
			end
			data.keyValues = ToolData.keyValues
			data.relationships = ToolData.relationships
			file.CreateDir("npcspawner2")
			file.Write("npcspawner2/"..name,util.TableToJSON(data))
			ToolData.PresetComboBox:UpdateData()
		end)
	end
	---- SavePresetButton End
	
	---- NpcClassList
	ToolData.NpcClassList:SetMultiSelect(false)
	ToolData.NpcClassList:AddColumn("Name")
	ToolData.NpcClassList:AddColumn("Subclass")
	ToolData.NpcClassList:AddColumn("Codename")
	ToolData.NpcClassList.UpdateData = function()
		ToolData.NpcClassList:Clear()
	
		local filter = ToolData.NpcClassSearchBox:GetValue():lower()
		
		local NpcList = {}
		for k,v in pairs(list.Get("NPC")) do
			if (filter == "") or
				(v.Name:lower():find(filter,1,true) ~= nil) or
				(v.Class:lower():find(filter,1,true) ~= nil) or
				(k:lower():find(filter,1,true) ~= nil) then
				table.insert(NpcList,{v.Name,v.Class,k})
			end
		end
		table.sort(NpcList, function(a,b) return a[1]:lower() < b[1]:lower() end)
		
		-- Disable sending commands right now
		ToolData.NpcClassList.OnRowSelected = function() end
		
		local selectedLine
		local currentClass = GetConVarString("npctool_newspawner_class") or ConVarsDefault["npctool_newspawner_class"]
		for k,v in ipairs(NpcList) do
			local currentLine = ToolData.NpcClassList:AddLine(v[1],v[2],v[3])
			currentLine:SetSortValue(1, v[1]:lower())
			currentLine:SetSortValue(2, v[2]:lower())
			currentLine:SetSortValue(3, v[3]:lower())
			if currentClass:lower() == v[3]:lower() then
				selectedLine = currentLine
			end
		end

		-- Allow sending commands
		ToolData.NpcClassList.OnRowSelected = function(_,__,row)
			if row and row.GetColumnText and row:GetColumnText(3) then
				RunConsoleCommand("npctool_newspawner_class",row:GetColumnText(3))
			end
		end
		
		if selectedLine then
			ToolData.NpcClassList:SelectItem(selectedLine)
		end
	end
	ToolData.NpcClassList.UpdateDataUI = ToolData.NpcClassList.UpdateData
	ToolData.NpcClassList:UpdateData()
	ToolData.NpcClassSearchBox:SetUpdateOnType(true)
	ToolData.NpcClassSearchBox.OnValueChange = function()
		ToolData.NpcClassList:UpdateData()
	end
	
	---- NpcClassList End
	
	---- CollapsibleFlag
	ToolData.CollapsibleFlag:SetExpanded(false)
	ToolData.CollapsibleFlag:SetName("Spawn Flags")
	ToolData.CollapsibleFlag:ControlHelp("This only works only on certain subclasses.")
	
	for k,v in ipairs(flags) do
		ToolData["Flag"..k] = ToolData.CollapsibleFlag:CheckBox(""..v[1]..": "..v[2],"npctool_newspawner_flag"..k)
		ToolData["Flag"..k].UpdateData = function(this)
			local conVar = GetConVar("npctool_newspawner_flag"..k)
			if conVar then
				this:SetValue(conVar:GetBool())
			else
				this:SetValue(ConVarsDefault["npctool_newspawner_flag"..k] or false)
			end
		end
		ToolData["Flag"..k].UpdateDataUI = ToolData["Flag"..k].UpdateData
		ToolData["Flag"..k]:UpdateData()
	end
	---- CollapsibleFlag End
	
	---- Equipment
	ToolData.Equipment:SetSortItems(false)
	ToolData.Equipment.UpdateData = function()
		ToolData.Equipment:Clear()
		ToolData.Equipment:AddChoice("Default","_default_weapon")
		ToolData.Equipment:AddChoice("Unarmed","")
		ToolData.Equipment:ChooseOptionID(1)
		local currentEquipment = GetConVarString("npctool_newspawner_equipment") or ConVarsDefault["npctool_newspawner_equipment"]
		local filter = {}
		for k,data in ipairs(list.Get("NPCUsableWeapons")) do
			local showDefault = false
			if currentEquipment == data.class then
				showDefault = true
			end
			ToolData.Equipment:AddChoice(data.title,data.class,showDefault)
			filter[k] = true
		end
		
		for k,data in pairs(list.Get("NPCUsableWeapons")) do
			if not filter[k] then
				local showDefault = false
				if currentEquipment == data.class then
					showDefault = true
				end
				ToolData.Equipment:AddChoice(data.title,data.class,showDefault)
			end
		end
	end
	ToolData.Equipment.UpdateDataUI = ToolData.Equipment.UpdateData
	ToolData.Equipment:UpdateData()
	---- Equipment End
	
	---- Proficiency
	ToolData.Proficiency:SetSortItems(false)
	local choiceTable = {
		{"Poor",WEAPON_PROFICIENCY_POOR},
		{"Average",WEAPON_PROFICIENCY_AVERAGE},
		{"Good",WEAPON_PROFICIENCY_GOOD},
		{"Very Good",WEAPON_PROFICIENCY_VERY_GOOD},
		{"Perfect",WEAPON_PROFICIENCY_PERFECT},
		{"Insane", 5},
		{"Random",WEAPON_PROFICIENCY_RANDOM}
	}
	ToolData.Proficiency.UpdateData = function()
		ToolData.Proficiency:Clear()
		
		local currentProficiency = GetConVarString("npctool_newspawner_proficiency") or ConVarsDefault["npctool_newspawner_proficiency"]
		for k,v in ipairs(choiceTable) do
			local showDefault = false
			if currentProficiency == v[2] then
				showDefault = true
			end
			ToolData.Proficiency:AddChoice(v[1],v[2],showDefault)
		end
	end
	ToolData.Proficiency.UpdateDataUI = ToolData.Proficiency.UpdateData
	ToolData.Proficiency:UpdateData()
	---- Proficiency End
	
	---- CollapsibleKeyVal
	ToolData.CollapsibleKeyVal:SetExpanded(false)
	ToolData.CollapsibleKeyVal:SetName("Key Values")
	ToolData.KeyValList = vgui.Create("DListView",ToolData.CollapsibleKeyVal)
	ToolData.KeyValList:SetHeight(150)
	ToolData.CollapsibleKeyVal:AddItem(ToolData.KeyValList)
	ToolData.KeyValList:AddColumn("Key")
	ToolData.KeyValList:AddColumn("Value")
	ToolData.KeyValList.UpdateData = function(KVList)
		KVList:Clear()
		local keyValList = {}
		for k,v in pairs(ToolData.keyValues) do
			table.insert(keyValList,{k,v})
		end
		table.sort(keyValList,function(a,b) return a[1]:lower() < b[1]:lower() end)
		for k,v in ipairs(keyValList) do
			local currentLine = KVList:AddLine(v[1],v[2])
			currentLine:SetSortValue(1,v[1]:lower())
			currentLine:SetSortValue(2,v[2]:lower())
		end
	end
	ToolData.KeyValList.UpdateDataUI = ToolData.KeyValList.UpdateData
	ToolData.KeyValList:UpdateData()
	ToolData.AddKeyValue = ToolData.CollapsibleKeyVal:Button("Add Keyvalue")
	ToolData.RemoveKeyValue = ToolData.CollapsibleKeyVal:Button("Remove Keyvalue")
	ToolData.ClearKeyValues = ToolData.CollapsibleKeyVal:Button("Clear Keyvalues")
	
	ToolData.AddKeyValue.DoClick = function()
		local x,y = gui.MousePos()
		local Panel = vgui.Create("DFrame")
		Panel:SetSize(192,113)
		Panel:SetPos(x-96,y-56)
		Panel:MakePopup()
		Panel:ShowCloseButton(true)
		Panel:SetTitle("Add KeyValue")
		
		local KeyLabel = vgui.Create("DLabel",Panel)
		KeyLabel:SetText("Key:")
		KeyLabel:SetPos(12,35)
		KeyLabel:SizeToContents()
		
		local KeyTextEntry = vgui.Create("DTextEntry",Panel)
		KeyTextEntry:SetSize(100,16)
		KeyTextEntry:SetPos(80,35)
		
		local ValueLabel = vgui.Create("DLabel",Panel)
		ValueLabel:SetText("Value:")
		ValueLabel:SetPos(12,60)
		ValueLabel:SizeToContents()
		
		local ValueTextEntry = vgui.Create("DTextEntry",Panel)
		ValueTextEntry:SetSize(100,16)
		ValueTextEntry:SetPos(80,60)
		
		local OkButton = vgui.Create("DButton",Panel)
		OkButton:SetText("OK")
		OkButton:SetSize(168,16)
		OkButton:SetPos(12,85)
		OkButton.DoClick = function()
			Panel:Close()
			if KeyTextEntry:GetValue() == "" then
				return
			end
			ToolData.keyValues[KeyTextEntry:GetValue()] = ValueTextEntry:GetValue()
			ToolData.KeyValList:UpdateData()
		end
	end
	ToolData.RemoveKeyValue.DoClick = function()
		local selection = ToolData.KeyValList:GetSelected()
		for k,v in ipairs(selection) do
			ToolData.keyValues[v:GetColumnText(1)] = nil
		end
		ToolData.KeyValList:UpdateData()
	end
	ToolData.ClearKeyValues.DoClick = function()
		ToolData.keyValues = {}
		ToolData.KeyValList:UpdateData()
	end
	---- CollapsibleKeyVal End
	
	---- CollapsibleRel
	ToolData.CollapsibleRel:SetExpanded(false)
	ToolData.CollapsibleRel:SetName("Relationships")
	ToolData.RelationshipList = vgui.Create("DListView",ToolData.CollapsibleRel)
	ToolData.RelationshipList:SetHeight(150)
	ToolData.CollapsibleRel:AddItem(ToolData.RelationshipList)
	ToolData.RelationshipList:AddColumn("Relationship")
	ToolData.RelationshipList:SetHideHeaders(true)
	ToolData.RelationshipList.UpdateData = function(RelList)
		RelList:Clear()
		for k,v in pairs(ToolData.relationships) do
			local strText
			if v == REL_HATE then strText = "Hates "
			elseif v == REL_FEAR then strText = "Fears "
			elseif v == REL_LIKE then strText = "Likes "
			elseif v == REL_NEUT then strText = "Is neutral to "
			else strText = "Invalid relationship with "
			end
			
			local name = language.GetPhrase("#"..k)
			if name[1] == "#" then name = k end
			
			local currentLine = ToolData.RelationshipList:AddLine(strText .. k)
			currentLine:SetSortValue((strText..k):lower())
			currentLine.internalKey = k
		end
	end
	ToolData.RelationshipList.UpdateDataUI = ToolData.RelationshipList.UpdateData
	ToolData.RelationshipList:UpdateData()
	ToolData.AddRelationship = ToolData.CollapsibleRel:Button("Add Relationship")
	ToolData.RemoveRelationship = ToolData.CollapsibleRel:Button("Remove Relationship")
	ToolData.ClearRelationships = ToolData.CollapsibleRel:Button("Clear Relationships")
	
	ToolData.AddRelationship.DoClick = function()
		local x,y = gui.MousePos()
		local Panel = vgui.Create("DFrame")
		Panel:SetSize(300,113)
		Panel:SetPos(x - 96, y - 56)
		Panel:MakePopup()
		Panel:ShowCloseButton(true)
		Panel:SetTitle("Add Relationship")
		
		local TargetLabel = vgui.Create("DLabel",Panel)
		TargetLabel:SetText("Target:")
		TargetLabel:SetPos(12,35)
		TargetLabel:SizeToContents()
		
		local TargetComboBox = vgui.Create("DComboBox",Panel)
		TargetComboBox:SetSize(208,16)
		TargetComboBox:SetPos(80,35)
		TargetComboBox:SetSortItems(false)
		local choices = {}
		
		for _,npc in pairs(list.Get("NPC")) do
			table.insert(choices,{npc.Name,npc.Class})
		end
		table.sort(choices, function(a,b) return a[1]:lower() < b[1]:lower() end)
		
		TargetComboBox:AddChoice("Player","Player",true)
		local sortedTeamTable = {}
		for k,v in pairs(team.GetAllTeams()) do
			if k ~= 0 or v.Joinable then -- Team 0 -> Joining/Connecting
				table.insert(sortedTeamTable, {k,v})
			end
		end
		table.sort(sortedTeamTable, function(a,b) return a[1] < b[1] end)
		for k,v in ipairs(sortedTeamTable) do
			TargetComboBox:AddChoice("Player: Team " .. v[2].Name,"Player.team["..v[1].."]")
		end
		for k,v in ipairs(choices) do
			TargetComboBox:AddChoice(v[1],v[2])
		end
		
		local RelLabel = vgui.Create("DLabel",Panel)
		RelLabel:SetText("Relationship:")
		RelLabel:SetPos(12,60)
		RelLabel:SizeToContents()
		
		local RelComboBox = vgui.Create("DComboBox",Panel)
		RelComboBox:SetSize(208,16)
		RelComboBox:SetPos(80,60)
		RelComboBox:SetSortItems(false)
		RelComboBox:AddChoice("Hate", REL_HATE, true)
		RelComboBox:AddChoice("Fear", REL_FEAR)
		RelComboBox:AddChoice("Neutral", REL_NEUT)
		RelComboBox:AddChoice("Like", REL_LIKE)
		
		local OkButton = vgui.Create("DButton",Panel)
		OkButton:SetText("OK")
		OkButton:SetSize(276,16)
		OkButton:SetPos(12,85)
		OkButton.DoClick = function()
			Panel:Close()
			local __,NPC = TargetComboBox:GetSelected()
			local _,Rel = RelComboBox:GetSelected()
			if NPC and Rel then
				ToolData.relationships[NPC] = Rel
			end
			ToolData.RelationshipList:UpdateData()
		end
	end
	ToolData.RemoveRelationship.DoClick = function()
		local selection = ToolData.RelationshipList:GetSelected()
		for k,v in ipairs(selection) do
			ToolData.relationships[v.internalKey] = nil
		end
		ToolData.RelationshipList:UpdateData()
	end
	ToolData.ClearRelationships.DoClick = function()
		ToolData.relationships = {}
		ToolData.RelationshipList:UpdateData()
	end
	---- CollapsibleRel End
	
	---- NumSliders
	ToolData.SpawnDelay.Scratch:SetDecimals(1)
	ToolData.MaxAliveNPCs.Scratch:SetDecimals(0)
	ToolData.TotalNPCAmount.Scratch:SetDecimals(0)
	ToolData.FadeTime.Scratch:SetDecimals(1)
	ToolData.StartHealth.Scratch:SetDecimals(0)
	ToolData.MaxHealth.Scratch:SetDecimals(0)
	if ToolData.Experience then
		ToolData.Experience.Scratch:SetDecimals(0)
	end
	---- NumSliders end
end


---- Spawn Logic: Client
net.Receive("npctool_newspawner_requestspawn", function(len,pl)
	local HitPos = net.ReadVector()
	local SelEntity = LocalPlayer():GetVar("obj_npcroute_selected")
	net.Start("npctool_newspawner_spawn")
		net.WriteTable(ToolData.keyValues)
		net.WriteTable(ToolData.relationships)
		net.WriteVector(HitPos)
		net.WriteEntity(SelEntity)
	net.SendToServer()
end)

net.Receive("npctool_newspawner_requestunspawn", function(len,pl)
	local HitPos = net.ReadVector()
	net.Start("npctool_newspawner_unspawn")
		net.WriteVector(HitPos)
	net.SendToServer()
end)
---- Spawn Logic: Client end

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
end
---------------------- CLIENT end ----------------------

---------------------- SERVER ----------------------
if SERVER then

local RequiredConVars = {
	"class",
	"squad",
	"flag1",
	"flag2",
	"flag3",
	"flag4",
	"flag5",
	"flag6",
	"flag7",
	"flag8",
	"flag9",
	"flag10",
	"flag11",
	"flag12",
	"flag13",
	"flag14",
	"flag15",
	"flag16",
	"flag17",
	"flag18",
	"flag19",
	"flag20",
	"flag21",
	"flag22",
	"flag23",
	"flag24",
	"flag25",
	"equipment",
	"delay",
	"max",
	"total",
	"turnon",
	"turnoff",
	"starton",
	"startburrowed",
	"deleteonremove",
	"showeffects",
	"proficiency",
	"xp",
	"fadetime",
	"starthealth",
	"maxhealth"
}

local function FindNearbySpawner(pos, range)
	local entities = ents.FindInSphere(pos,range)
	local nearest = {}
	for k,v in ipairs(entities) do
		if v:GetClass() == "obj_npcspawner" then
			local entDistance = pos:Distance(v:GetPos())
			if (nearest[1] == nil) or (nearest[1] < entDistance) then
				nearest[1] = entDistance
				nearest[2] = v
			end
		end
	end
	return nearest[2]
end

function TOOL:RequestUnspawn(hitPos, ply)
	local selSpawner = FindNearbySpawner(hitPos, 64)
	if IsValid(selSpawner) then
		selSpawner:Remove()
		return true
	end
	return false
end

local function RequestSpawn(keyValues, relationships, spawnPos, ply, startEnt)
	ToolData.server.data.keyValues = keyValues
	ToolData.server.data.relationships = relationships
	ToolData.server.data.spawnPos = spawnPos
	ToolData.server.data.spawnAngle = ply:GetAimVector():Angle().y
	for k,v in ipairs(RequiredConVars) do
		ToolData.server.conVars[v] = ply:GetInfo("npctool_newspawner_"..v)
	end
	
	local NPCData = list.Get("NPC")[ToolData.server.conVars.class]
	if not NPCData then
		ErrorNoHalt("Warning: Invalid NPC type: "..ToolData.server.conVars.class)
		return
	end
	local NPCClass = NPCData.Class
	if not NPCClass then
		ErrorNoHalt("Warning: NPC type "..ToolData.server.conVars.class.." does not have a valid NPC class.")
		return
	end
	
	local NPCSpawner = ents.Create("obj_npcspawner")
	if not IsValid(NPCSpawner) then
		MsgN("Could not create NPC Spawner Entity (obj_npcspawner).")
		return
	end
	
	NPCSpawner:SetPos(ToolData.server.data.spawnPos)
	NPCSpawner:SetAngles(Angle(0,ToolData.server.data.spawnAngle,0))
	NPCSpawner:SetNPCClass(NPCClass)
	NPCSpawner:SetNPCData(NPCData)
	NPCSpawner:SetNPCBurrowed(ToolData.server.conVars.startburrowed)
	NPCSpawner:SetNPCKeyValues(ToolData.server.keyValues)
	
	if ToolData.server.conVars.equipment ~= "" then
		NPCSpawner:SetNPCEquipment(ToolData.server.conVars.equipment)
	end
	
	local flagInt = 0
	local baseFlag = "flag"
	local currentFlag = 1
	local currentFlagValue = 1
	while ToolData.server.conVars[baseFlag..currentFlag] ~= nil do
		if tonumber(ToolData.server.conVars[baseFlag..currentFlag]) == 1 then
			flagInt = flagInt + currentFlagValue
		end
		currentFlagValue = currentFlagValue * 2
		currentFlag = currentFlag + 1
	end
	
	NPCSpawner:SetNPCSpawnflags(flagInt)
	NPCSpawner:SetNPCProficiency(ToolData.server.conVars.proficiency)
	NPCSpawner:SetEntityOwner(ply)
	NPCSpawner:SetKeyTurnOn(ToolData.server.conVars.turnon)
	NPCSpawner:SetKeyTurnOff(ToolData.server.conVars.turnoff)
	NPCSpawner:SetSpawnDelay(ToolData.server.conVars.delay)
	NPCSpawner:SetMaxNPCs(ToolData.server.conVars.max)
	NPCSpawner:SetTotalNPCs(ToolData.server.conVars.total)
	
	NPCSpawner:SetStartOn(ToolData.server.conVars.starton)
	NPCSpawner:SetDeleteOnRemove(ToolData.server.conVars.deleteonremove)
	NPCSpawner:SetXP(ToolData.server.conVars.xp or 10)
	NPCSpawner:SetStartEntity(startEnt)
	NPCSpawner:SetFadeTime(ToolData.server.conVars.fadetime)
	NPCSpawner:SetScrNPCHealth(ToolData.server.conVars.starthealth)
	NPCSpawner:SetScrNPCMaxHealth(ToolData.server.conVars.maxhealth)
	
	for k,v in pairs(ToolData.server.data.relationships) do
		NPCSpawner:SetDisposition(k,v)
	end
	NPCSpawner:SetPatrolPointsDisabled(true)
	NPCSpawner:Spawn()
	NPCSpawner:Activate()
	NPCSpawner:ShowEffects(tonumber(ToolData.server.conVars.showeffects) ~= 0)
	cleanup.Add(ply,"npcs",NPCSpawner)
	undo.Create("SENT")
		undo.AddEntity(NPCSpawner)
		undo.SetPlayer(ply)
		undo.SetCustomUndoText("Undone NPC Spawner")
	undo.Finish("Scripted Entity (NPC Spawner)")
end

util.AddNetworkString("npctool_newspawner_requestspawn")
util.AddNetworkString("npctool_newspawner_spawn")
util.AddNetworkString("npctool_newspawner_requestunspawn")
util.AddNetworkString("npctool_newspawner_unspawn")

net.Receive("npctool_newspawner_spawn", function(len,ply)
	local keyValues = net.ReadTable()
	local relationships = net.ReadTable()
	local spawnPos = net.ReadVector()
	local selEntity = net.ReadEntity()
	RequestSpawn(keyValues,relationships,spawnPos,ply,selEntity)
end)

end
---------------------- SERVER end ----------------------

---------------------- SHARED ----------------------
function TOOL:LeftClick(trace)
	if CLIENT then return true end
	if IsValid(trace.Entity) and trace.Entity:GetClass() == "obj_npcroute" then
		trace.Entity:SetSelected(self:GetOwner())
		return true
	end
	net.Start("npctool_newspawner_requestspawn")
	net.WriteVector(trace.HitPos)
	net.Send(self:GetOwner())
	return true
end

function TOOL:RightClick(trace)
	if CLIENT then return true end
	return self:RequestUnspawn(trace.HitPos, self:GetOwner())
end
---------------------- SHARED end ----------------------