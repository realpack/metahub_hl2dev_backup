local time = CurTime()

radio_s = radio_s or false
micro_s = micro_s or false

hook.Add( "Think", "WalkieTalkie_Think", function()
    local job = rp.teams[LocalPlayer():Team()]

    if job and not job.radio then return end
	if time > CurTime() then return end

	if input.IsKeyDown(KEY_LSHIFT) and input.IsKeyDown(KEY_M) then
		net.Start("WalkieTalkie_SpeakerToggle")
        net.SendToServer()
		radio_s = not radio_s
        time = CurTime() + 0.2
	end

	if input.IsKeyDown(KEY_LSHIFT) and input.IsKeyDown(KEY_T) then
		net.Start("WalkieTalkie_MicroToggle")
        net.SendToServer()
		micro_s = not micro_s
        time = CurTime() + 0.2
	end
end )

hook.Add("HUDPaint", "WalkieTalkie_HUDPaint", function()
	local ply = LocalPlayer()

	if not ply or not rp.teams[ply:Team()] then return end
	local should_show = rp.teams[ply:Team()].radio and true or false

	if not should_show then return end

	local phrase_s = radio_s and "<color=50,200,50>включена</color>" or "<color=200,50,50>выключена</color>"
	local phrase_m = micro_s and "<color=50,200,50>включен</color>" or "<color=200,50,50>выключен</color>"

	local mark = markup.Parse("<font=font_base_18>Рация: "..phrase_s.." (Shift+M)", 400)
	mark:Draw(ScrW()-10, 15, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

	local mark = markup.Parse("<font=font_base_18>Микрофон: "..phrase_m.." (Shift+T)", 400)
	mark:Draw(ScrW()-10, 35, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
end)

net.Receive('WalkieTalkie_ChatAddText', function()
    local data = net.ReadTable()
    if not istable(data) then return end

    chat.AddText(unpack(data))
end)
