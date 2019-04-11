
-----------------------------------------------------
TOOL.Category		= "Roleplay"
TOOL.Name			= "#Textscreen"
TOOL.Command		= nil
TOOL.ConfigName		= ""

local allowablefonts = {
	"Tahoma",
	"Helvetica",
	"Trebuchet MS",
	"Sans",
	"Arial",
	"Impact",
	"Broadway",
	"Webdings",
	"Snap ITC",
	"Papyrus",
	"Old English Text MT",
	"Mistral",
	"Lucida Handwriting",
	"Jokerman",
	"Freestyle Script",
	"Bradley Hand ITC",
	"Stencil",
	"Shrek"
}

local createdfonts = {
}

local function getFont(name, size)
	if (!createdfonts[name] or !createdfonts[name][size]) then
		local fd = {
			font = name,
			size = size,
			weight = 1500,
			shadow = true,
			antialias = true,
			symbol = (name == "Webdings")
		}
			
		surface.CreateFont('CV' .. name .. size, fd)
		
		createdfonts[name] = createdfonts[name] or {}
		createdfonts[name][size] = true
	end
	
	 return ('CV' .. name .. size)
end


local TextBox = {}
local linelabels = {}
local labels = {}
local fontpickers = {}
local sliders = {}
for i = 1, 3 do
	TOOL.ClientConVar[ "font"..i ] = allowablefonts[1]
	TOOL.ClientConVar[ "text"..i ] = ""
	TOOL.ClientConVar[ "size"..i ] = 20
	TOOL.ClientConVar[ "r"..i ] = 255
	TOOL.ClientConVar[ "g"..i ] = 255
	TOOL.ClientConVar[ "b"..i ] = 255
	TOOL.ClientConVar[ "a"..i ] = 255
end

cleanup.Register("textscreens")

if (CLIENT) then
	language.Add("Tool.textscreen.name", "Textscreen")
	language.Add("Tool.textscreen.desc", "Create a textscreen with multiple lines, font colours and sizes.")	

	language.Add("Tool.textscreen.0", "Left Click: Spawn a textscreen Right Click: Update textscreen with settings")
	language.Add("Tool_textscreen_0", "Left Click: Spawn a textscreen Right Click: Update textscreen with settings")

	language.Add("Undone.textscreens", "Undone textscreen")
	language.Add("Undone_textscreens", "Undone textscreen")
	language.Add("Cleanup.textscreens", "Textscreens")
	language.Add("Cleanup_textscreens", "Textscreens")
	language.Add("Cleaned.textscreens", "Cleaned up all textscreens")
	language.Add("Cleaned_textscreens", "Cleaned up all textscreens")
	
	language.Add("SBoxLimit.textscreens", "You've hit the textscreen limit!")
	language.Add("SBoxLimit_textscreens", "You've hit the textscreen limit!")
end

function TOOL:LeftClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end

	local Ply = self:GetOwner()
	local Font = {}
	local Text = {}
	local color = {}
	local size = {}
	for i = 1, 3 do
		local font = self:GetClientInfo("font"..i)
		for k, v in ipairs(allowablefonts) do
			if (v == font) then
				table.insert(Font, i, k)
			end
		end
		if (!Font[i]) then Font[i] = 1 end
		
		table.insert(Text, i, self:GetClientInfo("text"..i))
		table.insert(color, i, Color(tonumber(self:GetClientInfo("r"..i)), tonumber(self:GetClientInfo("g"..i)), tonumber(self:GetClientInfo("b"..i)), tonumber(self:GetClientInfo("a"..i))))
		table.insert(size, i, tonumber(self:GetClientInfo("size"..i)))
	end

	local SpawnPos = tr.HitPos
	
	if not (self:GetWeapon():CheckLimit("textscreens")) then return false end

	local TextScreen = ents.Create("ent_textscreen")
	TextScreen:SetPos(SpawnPos)
	TextScreen:Spawn()
	TextScreen:UpdateText(Font, Text, color, size)
	local angle = tr.HitNormal:Angle()
	angle:RotateAroundAxis(tr.HitNormal:Angle():Right(), -90)
	angle:RotateAroundAxis(tr.HitNormal:Angle():Forward(), 90)
	TextScreen:SetAngles(angle)
	TextScreen:Activate()
  TextScreen:SetNVar('PropOwner', Ply, NETWORK_PROTOCOL_PUBLIC)
  TextScreen:CPPISetOwner(Ply)
	
	undo.Create("textscreens")

	undo.AddEntity(TextScreen)
	undo.SetPlayer(Ply)
	undo.Finish()

	Ply:AddCount("textscreens", TextScreen)
	Ply:AddCleanup("textscreens", TextScreen)

	return true
end

function TOOL:RightClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end

	local Ply = self:GetOwner()
	local Font = {}
	local Text = {}
	local color = {}
	local size = {}
	for i = 1, 3 do
		local font = self:GetClientInfo("font"..i)
		for k, v in ipairs(allowablefonts) do
			if (v == font) then
				table.insert(Font, i, k)
			end
		end
		if (!Font[i]) then Font[i] = 1 end
		
		table.insert(Text, i, self:GetClientInfo("text"..i))
		table.insert(color, i, Color(tonumber(self:GetClientInfo("r"..i)), tonumber(self:GetClientInfo("g"..i)), tonumber(self:GetClientInfo("b"..i)), tonumber(self:GetClientInfo("a"..i))))
		table.insert(size, i, tonumber(self:GetClientInfo("size"..i)))
	end

	local TraceEnt = tr.Entity

	if (TraceEnt:IsValid() and TraceEnt:GetClass() == "ent_textscreen") then
		TraceEnt:UpdateText(Font, Text, color, size)
		return true
	end
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {	Text = "#Tool.textscreen.name", Description	= "#Tool.textscreen.desc" } )
	resetall = vgui.Create("DButton", resetbuttons)
	resetall:SetSize(100, 25)	
	resetall:SetText("Сбросить всё")
	resetall.DoClick = function()
		local menu = DermaMenu()
		menu:AddOption("Сбросить шрифт", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_font"..i, "Tahoma")
			end
		end)
		menu:AddOption("Сбросить цвета", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
			end
		end)
		menu:AddOption("Сбросить размер", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
			end			
		end)
		menu:AddOption("Сбросить текст", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end
		end)
		menu:AddOption("Сбросить всё", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end
		end)
		menu:Open()
	end
	CPanel:AddItem(resetall)
	resetline = vgui.Create("DButton")
	resetline:SetSize(100, 25)	
	resetline:SetText("Сбросить строку")
	resetline.DoClick = function()
		local menu = DermaMenu()
		for i = 1, 3 do
			menu:AddOption("Сбросить строку "..i, function()
				RunConsoleCommand("textscreen_font"..i, "Tahoma")
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end)
		end
		menu:AddOption("Сбросить все строки", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_font"..i, "Tahoma")
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end			
		end)
		menu:Open()
	end
	CPanel:AddItem(resetline)

	for i = 1, 3 do
		linelabels[i] = CPanel:AddControl("Label", {
			Text = "Line "..i,
			Description = "Line "..i
		})
		linelabels[i]:SetFont("Default")
		CPanel:AddControl("Color", {
			Label = "Line "..i.." font color",
			Red = "textscreen_r"..i,
			Green = "textscreen_g"..i,
			Blue = "textscreen_b"..i,
			Alpha = "textscreen_a"..i,
			ShowHSV = 1,
			ShowRGB = 1,
			Multiplier = 255
		})
		fontpickers[i] = vgui.Create("DComboBox")
		for k, v in ipairs(allowablefonts) do fontpickers[i]:AddChoice(v) end
		fontpickers[i]:ChooseOption("Tahoma")
		fontpickers[i].OnSelect = function(pnl, idx, value)
			RunConsoleCommand("textscreen_font"..i, value)
			labels[i]:SetFont(getFont(value or allowablefonts[1], math.Round(sliders[i]:GetValue())))
		end
		
		CPanel:AddItem(fontpickers[i])
		sliders[i] = vgui.Create("DNumSlider")
		sliders[i]:SetText("Размер шрифта")
		sliders[i]:SetMinMax(20, 100)
		sliders[i]:SetDecimals(0)
		sliders[i]:SetValue(20)
		sliders[i]:SetConVar("textscreen_size"..i)
		sliders[i].OnValueChanged = function(panel, value)
			local str, data = fontpickers[i]:GetSelected()
			str = str or allowablefonts[1]
			labels[i]:SetFont(getFont(str, math.Round(value)))
		end
		CPanel:AddItem(sliders[i])
		TextBox[i] = vgui.Create("DTextEntry")
		TextBox[i]:SetUpdateOnType(true)
		TextBox[i]:SetEnterAllowed(true)
		TextBox[i]:SetConVar("textscreen_text"..i)
		TextBox[i]:SetValue(GetConVarString("textscreen_text"..i))
		TextBox[i].OnTextChanged = function()
			labels[i]:SetText(TextBox[i]:GetValue())
		end
		CPanel:AddItem(TextBox[i])
		labels[i] = CPanel:AddControl("Label", {
			Text = "Line "..i,
			Description = "Line "..i
		})
		labels[i]:SetFont("Default")
		labels[i].Think = function()
			labels[i]:SetColor(Color(GetConVarNumber("textscreen_r"..i), GetConVarNumber("textscreen_g"..i), GetConVarNumber("textscreen_b"..i), GetConVarNumber("textscreen_a"..i)))
		end
	end
end
