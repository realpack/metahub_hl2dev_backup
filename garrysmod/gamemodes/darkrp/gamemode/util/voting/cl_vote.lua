local VoteVGUI = {}
local QuestionVGUI = {}
local PanelNum = 0
local LetterWritePanel

local function MsgDoVote(msg)
	if LocalPlayer():IsBanned() then return end
	local chatx, chaty = chat.GetChatBoxPos()
	local chatw, chath = chat.GetChatBoxSize()
	local x = chatx + chatw + 5

	local question = msg:ReadString()
	local voteid = msg:ReadShort()
	local timeleft = msg:ReadFloat()
	local steamid = msg:ReadString()
	if timeleft == 0 then
		timeleft = 100
	end
	local OldTime = CurTime()
	if not IsValid(LocalPlayer()) then return end -- Sent right before player initialisation

	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	local panel = ui.Create("ui_frame")
	panel:SetPos(0, ScrH() - 145)
	panel:MoveTo(x + PanelNum,  ScrH() - 145, 0.15, 0, 1)
	panel:SetTitle("Vote")
	panel:SetSize(140, 140)
	panel:SetSizable(false)
	panel:SetDraggable(false)
	panel:ShowCloseButton(false)
	function panel:Close()
		PanelNum = PanelNum - 142.5
		VoteVGUI[voteid .. "vote"] = nil

		local num = 5
		for k,v in SortedPairs(VoteVGUI) do
			v:SetPos(num, ScrH() - 145)
			num = num + 142.5
		end

		for k,v in SortedPairs(QuestionVGUI) do
			v:SetPos(num, ScrH() - 145)
			num = num + 302.5
		end
		self:Remove()
	end

	function panel:Think()
		self:SetTitle("Time: ".. tostring(math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999)))
		if timeleft - (CurTime() - OldTime) <= 0 then
			panel:Close()
		end
	end

	panel:SetKeyboardInputEnabled(false)
	panel:SetMouseInputEnabled(true)
	panel:SetVisible(true)

	for i = 22, string.len(question), 22 do
		if not string.find(string.sub(question, i - 20, i), "\n", 1, true) then
			question = string.sub(question, 1, i) .. "\n".. string.sub(question, i + 1, string.len(question))
		end
	end

	local label = ui.Create("DLabel", panel)
	label:SetPos(5, 35)
	label:SetText(question)
	label:SetFont('rp.ui.18')
	label:SizeToContents()

	local nextHeight = label:GetTall() > 78 and label:GetTall() - 78 or 0 // make panel taller for divider and buttons
	panel:SetTall(panel:GetTall() + nextHeight)

	local ybutton = ui.Create("DButton")
	ybutton:SetParent(panel)
	ybutton:SetPos(5, panel:GetTall() - 30)
	ybutton:SetSize(panel:GetWide()/2 -7.5, 25)
	ybutton:SetCommand("!")
	ybutton:SetText("Yes")
	ybutton.DoClick = function()
		LocalPlayer():ConCommand("vote " .. voteid .. " yea\n")
		panel:Close()
	end

	local nbutton = ui.Create("DButton")
	nbutton:SetParent(panel)
	nbutton:SetPos(panel:GetWide()/2 + 2.5, panel:GetTall() - 30)
	nbutton:SetSize(panel:GetWide()/2 -7.5, 25)
	nbutton:SetCommand("!")
	nbutton:SetText("No")
	nbutton.DoClick = function()
		LocalPlayer():ConCommand("vote " .. voteid .. " nay\n")
		panel:Close()
	end

	if LocalPlayer():IsAdmin() then
		local nbutton = ui.Create("DButton", panel)
		nbutton:SetSize(panel:GetWide()/2 - 15, 28)
		nbutton:SetPos(panel:GetWide() - nbutton:GetWide(), 0)
		nbutton:SetCommand("!")
		nbutton:SetText("Deny")
		nbutton.DoClick = function()
			RunConsoleCommand('ba', 'denyvote', steamid)
			panel:Close()
		end
		nbutton.Paint = function(self, w, h)
			draw.OutlinedBox(0, 0, w, h, (self.Hovered and ui.col.CloseHovered or ui.col.CloseBackground), ui.col.Outline)
		end
		nbutton:SetTextColor(ui.col.Close)
	end


	PanelNum = PanelNum + 142.5
	VoteVGUI[voteid .. "vote"] = panel
end
usermessage.Hook("DoVote", MsgDoVote)

local function KillVoteVGUI(msg)
	local id = msg:ReadShort()

	if VoteVGUI[id .. "vote"] and VoteVGUI[id .. "vote"]:IsValid() then
		VoteVGUI[id.."vote"]:Close()

	end
end
usermessage.Hook("KillVoteVGUI", KillVoteVGUI)

net("DoQuestion", function()
	local chatx, chaty = chat.GetChatBoxPos()
	local chatw, chath = chat.GetChatBoxSize()
	local x = chatx + chatw + 5

	local question = net.ReadString()
	local quesid = net.ReadString()
	local timeleft = net.ReadFloat()
	if timeleft == 0 then
		timeleft = 100
	end
	local OldTime = CurTime()
	LocalPlayer():EmitSound("Town.d1_town_02_elevbell1", 100, 100)
	local panel = ui.Create("ui_frame")
	panel:SetPos(0, ScrH() - 145)
	panel:MoveTo(x + PanelNum,  ScrH() - 145, 0.15, 0, 1)
	panel:SetSize(300, 140)
	panel:SetSizable(false)
	panel:SetKeyboardInputEnabled(false)
	panel:SetMouseInputEnabled(true)
	panel:SetVisible(true)
	panel:ShowCloseButton(false)

	function panel:Close()
		PanelNum = PanelNum - 302.5
		QuestionVGUI[quesid .. "ques"] = nil
		local num = 5
		for k,v in SortedPairs(VoteVGUI) do
			v:SetPos(num, ScrH() - 145)
			num = num + 142.5
		end

		for k,v in SortedPairs(QuestionVGUI) do
			v:SetPos(num, ScrH() - 145)
			num = num + 302.5
		end

		self:Remove()
	end

	function panel:Think()
		self:SetTitle("Time: ".. tostring(math.Clamp(math.ceil(timeleft - (CurTime() - OldTime)), 0, 9999)))
		if timeleft - (CurTime() - OldTime) <= 0 then
			panel:Close()
		end
	end

	local label = ui.Create("DLabel")
	label:SetParent(panel)
	label:SetPos(5, 35)
	label:SetText(question)
	label:SetFont('rp.ui.18')
	label:SizeToContents()

	local ybutton = ui.Create("DButton")
	ybutton:SetParent(panel)
	ybutton:SetPos(5, panel:GetTall() - 30)
	ybutton:SetSize(panel:GetWide()/2 -7.5, 25)
	ybutton:SetText("Yes")
	ybutton:SetVisible(true)
	ybutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 1\n")
		panel:Close()
	end

	local nbutton = ui.Create("DButton")
	nbutton:SetParent(panel)
	nbutton:SetPos(panel:GetWide()/2 + 2.5, panel:GetTall() - 30)
	nbutton:SetSize(panel:GetWide()/2 -7.5, 25)
	nbutton:SetText("No")
	nbutton:SetVisible(true)
	nbutton.DoClick = function()
		LocalPlayer():ConCommand("ans " .. quesid .. " 2\n")
		panel:Close()
	end

	PanelNum = PanelNum + 302.5
	QuestionVGUI[quesid .. "ques"] = panel
end)

net("KillQuestionVGUI", function()
	local id = net.ReadString()

	if QuestionVGUI[id .. "ques"] and QuestionVGUI[id .. "ques"]:IsValid() then
		QuestionVGUI[id .. "ques"]:Close()
	end
end)

local function DoVoteAnswerQuestion(ply, cmd, args)
	if not args[1] then return end

	local vote = 0
	if tonumber(args[1]) == 1 or string.lower(args[1]) == "yes" or string.lower(args[1]) == "true" then vote = 1 end

	for k,v in pairs(VoteVGUI) do
		if Valiui_panel(v) then
			local ID = string.sub(k, 1, -5)
			VoteVGUI[k]:Close()
			RunConsoleCommand("vote", ID, vote)
			return
		end
	end

	for k,v in pairs(QuestionVGUI) do
		if Valiui_panel(v) then
			local ID = string.sub(k, 1, -5)
			QuestionVGUI[k]:Close()
			RunConsoleCommand("ans", ID, vote)
			return
		end
	end
end
concommand.Add("rp_vote", DoVoteAnswerQuestion)