util.AddNetworkString("WalkieTalkie_SpeakerToggle")
util.AddNetworkString("WalkieTalkie_MicroToggle")
-- util.AddNetworkString("WalkieTalkie.ChangeChannel")

util.AddNetworkString('WalkieTalkie_ChatAddText')

function ChatAddText(target, ...)
    net.Start('WalkieTalkie_ChatAddText')
        net.WriteTable({...})
    net.Send(target)
end

function ChatAddTextAll(...)
    net.Start('WalkieTalkie_ChatAddText')
        net.WriteTable({...})
    net.Broadcast()
end


net.Receive("WalkieTalkie_SpeakerToggle", function(len, ply)
    ply.walkie_talkie.speaker = not ply.walkie_talkie.speaker

    local str = not ply.walkie_talkie.speaker and "выключили" or "включили"
    -- meta.util.Notify('yellow', ply, "Вы "..str.." рацию.")
    rp.Notify(ply, NOTIFY_GENERIC, "Вы "..str.." рацию.")
end)

net.Receive("WalkieTalkie_MicroToggle", function(len, ply)
    ply.walkie_talkie.micro = not ply.walkie_talkie.micro

    local str = not ply.walkie_talkie.micro and "выключили" or "включили"
    -- meta.util.Notify('yellow', ply, "Вы "..str.." микрофон рации.")
    rp.Notify(ply, NOTIFY_GENERIC, "Вы "..str.." микрофон рации.")

    print(ply, ply.walkie_talkie.micro)
end)

hook.Add("PlayerInitialSpawn", "WalkieTalkie_PlayerInitialSpawn", function(ply)
    ply.walkie_talkie = ply.walkie_talkie or {}
    ply.walkie_talkie.speaker = false
    ply.walkie_talkie.micro = false
end)

hook.Add("PlayerCanHearPlayersVoice", "WalkieTalkie_PlayerCanHearPlayersVoice", function(listener, talker)
    if not talker or not listener then return end
    if not talker.walkie_talkie or not listener.walkie_talkie then return end

    local job_l = rp.teams[listener:Team()]
    local job_t = rp.teams[talker:Team()]
    local listener_s, listener_m = listener.walkie_talkie.speaker, listener.walkie_talkie.micro
    local talker_s, talker_m = talker.walkie_talkie.speaker, talker.walkie_talkie.micro

    -- print(listener, job_l.radio, job_t.radio)
    -- print(job_l and job_l.radio and job_t and job_t.radio and job_l.radio == job_t.radio)
    if talker_m and talker_s and listener_s then
        if job_l and job_l.radio and job_t and job_t.radio and job_l.radio == job_t.radio then
            return true
        end
    end

    return (listener.CanHear and listener.CanHear[talker] or false), true
end)

local function find_players_in_radio(radio)
    local targets = {}

    for k, v in pairs(player.GetAll()) do
        local job = rp.teams[v:Team()]

        if job and job.radio and job.radio == radio then
            table.insert(targets, v)
        end
    end

    return targets
end

local function send_group_message(ply, radio, text)
    if not radio then
        -- meta.util.Notify("red", ply, "Вы не можете использовать групповой чат.")
        rp.Notify(ply, NOTIFY_ERROR, "Вы не можете использовать групповой чат.")
        return
    end

    text = string.gsub(text, "/g", "", 1)

    ChatAddText(find_players_in_radio(radio), Color(135, 102, 245), "[Рация] ", ply, color_white, ': ', text)
end

hook.Add("PlayerSay", "WalkieTalkie_PlayerSay", function(ply, text, teamonly)
    local job = rp.teams[ply:Team()]
    local args = string.Explode(" ", text)

    if not job.radio then return end

    if args[1] == "/g" then

        send_group_message(ply, job.radio, text)

        return ""
    end

 	if teamonly then
 		send_group_message(ply, job.radio, text)
 		return ""
 	end
end)
