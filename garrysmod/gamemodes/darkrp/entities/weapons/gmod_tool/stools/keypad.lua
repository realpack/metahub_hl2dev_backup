TOOL.Category = "Roleplay"
TOOL.Name = "Keypad"
TOOL.Command = nil

TOOL.ClientConVar['weld'] = '1'
TOOL.ClientConVar['freeze'] = '1'

TOOL.ClientConVar['password'] = ''
TOOL.ClientConVar['secure'] = '0'

TOOL.ClientConVar['repeats_granted'] = '0'
TOOL.ClientConVar['repeats_denied'] = '0'

TOOL.ClientConVar['length_granted'] = '4'
TOOL.ClientConVar['length_denied'] = '0.1'

TOOL.ClientConVar['delay_granted'] = '0'
TOOL.ClientConVar['delay_denied'] = '0'

TOOL.ClientConVar['init_delay_granted'] = '0'
TOOL.ClientConVar['init_delay_denied'] = '0'

TOOL.ClientConVar['key_granted'] = '0'
TOOL.ClientConVar['key_denied'] = '0'

cleanup.Register("keypads")

if(CLIENT) then
	language.Add("tool.keypad.name", "Keypad")
	language.Add("tool.keypad.0", "Left Click: Create, Right Click: Update")
	language.Add("tool.keypad.desc", "Creates Keypads for secure access")

	language.Add("Undone_Keypad", "Undone Keypad")
	language.Add("Cleanup_keypads", "Keypads")
	language.Add("Cleaned_keypads", "Cleaned up all Keypads")

	language.Add("SBoxLimit_keypads", "You've hit the Keypad limit!")
end

function TOOL:SetupKeypad(ent, pass)
	local data = {
		Password = pass,

		RepeatsGranted = self:GetClientNumber("repeats_granted"),
		RepeatsDenied = self:GetClientNumber("repeats_denied"),

		LengthGranted = math.Clamp(self:GetClientNumber("length_granted"), 4, 10),
		LengthDenied = self:GetClientNumber("length_denied"),

		DelayGranted = math.Clamp(self:GetClientNumber("delay_granted"), 4, 10),
		DelayDenied = self:GetClientNumber("delay_denied"),

		InitDelayGranted = self:GetClientNumber("init_delay_granted"),
		InitDelayDenied = self:GetClientNumber("init_delay_denied"),

		KeyGranted = self:GetClientNumber("key_granted"),
		KeyDenied = self:GetClientNumber("key_denied"),

		Secure = util.tobool(self:GetClientNumber("secure")),

		Owner = self:GetOwner()
	}

	ent:SetData(data)
end

function TOOL:RightClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() ~= "keypad") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = tonumber(ply:GetInfo("keypad_password"))

	local spawn_pos = tr.HitPos
	local trace_ent = tr.Entity

	if(password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0"))) then
		ply:ChatPrint("Invalid password!")
		return false
	end

	if(trace_ent:GetClass() == "keypad" and trace_ent.KeypadData.Owner == ply) then
		self:SetupKeypad(trace_ent, password) -- validated password

		return true
	end
end

function TOOL:LeftClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() == "player") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = self:GetClientNumber("password")

	local spawn_pos = tr.HitPos + tr.HitNormal
	local trace_ent = tr.Entity

	if(password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0"))) then
		ply:ChatPrint("Invalid password!")
		return false
	end

	if(not self:GetWeapon():CheckLimit("keypads")) then return false end

	local ent = ents.Create("keypad")
	ent:SetPos(spawn_pos)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()
	ent:SetPlayer(ply)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Activate()

	local phys = ent:GetPhysicsObject() -- rely on this being valid

	self:SetupKeypad(ent, password)

	undo.Create("Keypad")
		if(util.tobool(self:GetClientNumber("freeze"))) then
			phys:EnableMotion(false)
		end

		if(util.tobool(self:GetClientNumber("weld"))) then
			phys:EnableMotion(false) -- The timer allows the keypad to fall slightly, no thanks

			timer.Simple(0, function()
				if(IsValid(ent) and IsValid(trace_ent)) then
					local weld = constraint.Weld(ent, trace_ent)
				end
			end)

			ent:GetPhysicsObject():EnableCollisions(false)
		end

		undo.AddEntity(ent)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCount("keypads", ent)
	ply:AddCleanup("keypads", ent)

	return true
end


if(CLIENT) then
	local function ResetSettings(ply)
		ply:ConCommand("keypad_repeats_granted 0")
		ply:ConCommand("keypad_repeats_denied 0")
		ply:ConCommand("keypad_length_granted 4")
		ply:ConCommand("keypad_length_denied 0.1")
		ply:ConCommand("keypad_delay_granted 0")
		ply:ConCommand("keypad_delay_denied 0")
		ply:ConCommand("keypad_init_delay_granted 0")
		ply:ConCommand("keypad_init_delay_denied 0")
	end

	concommand.Add("keypad_reset", ResetSettings)

	function TOOL.BuildCPanel(CPanel)
		local r, l = CPanel:TextEntry("4 Digit Password", "keypad_password")
		r:SetTall(22)

		CPanel:ControlHelp("Allowed Digits: 1-9")

		CPanel:CheckBox("Secure Mode", "keypad_secure")
		CPanel:CheckBox("Weld and Freeze", "keypad_weld")
		CPanel:CheckBox("Freeze", "keypad_freeze")

		local ctrl = vgui.Create("CtrlNumPad", CPanel)
			ctrl:SetConVar1("keypad_key_granted")
			ctrl:SetConVar2("keypad_key_denied")
			ctrl:SetLabel1("Access Granted")
			ctrl:SetLabel2("Access Denied")
		CPanel:AddPanel(ctrl)

		CPanel:Button("Reset Settings", "keypad_reset")

		CPanel:Help("")
		CPanel:Help("Settings when access granted")

		CPanel:NumSlider("Hold Length", "keypad_length_granted", 4, 10, 2)
		CPanel:NumSlider("Initial Delay", "keypad_init_delay_granted", 0, 10, 2)
		CPanel:NumSlider("Multiple Press Delay", "keypad_delay_granted", 0, 10, 2)
		CPanel:NumSlider("Additional Repeats", "keypad_repeats_granted", 0, 5, 0)

		
		CPanel:Help("")
		CPanel:Help("Settings when access denied")

		CPanel:NumSlider("Hold Length", "keypad_length_denied", 0.1, 10, 2)
		CPanel:NumSlider("Initial Delay", "keypad_init_delay_denied", 0, 10, 2)
		CPanel:NumSlider("Multiple Press Delay", "keypad_delay_denied", 0, 10, 2)
		CPanel:NumSlider("Additional Repeats", "keypad_repeats_denied", 0, 5, 0)
	end
end