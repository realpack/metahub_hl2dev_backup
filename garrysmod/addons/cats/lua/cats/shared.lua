-- proudly coded by chelog

if SERVER then function ScrW() return 1920 end function ScrH() return 1080 end end cats = cats or {} cats.config = {}
-- ^
-- | please do not touch these

------------------------------------------------------
-- BASIC CONFIG
------------------------------------------------------

-- positions
cats.config.spawnSize = { 450, 220 }
cats.config.spawnPosAdmin = { ScrW() - 500, 50 }
cats.config.spawnPosUser = { ScrW() - 500, ScrH() - 250 }

-- appearance
cats.config.punchCardMode = 'dots' -- 'line', 'dots' or 'columns'
cats.config.punchCardStart = 5

-- rating
cats.config.defaultRating = 3
cats.config.ratingTimeout = 60

-- sound
cats.config.newTicketSound = 'buttons/bell1.wav'

-- language
cats.lang = {
    openTickets = "Открытые жалобы",
    myTicket = "Моя жалоба",
    userDisconnected = "Пользователь вышел",
    claimedBy = "Разбирается",
    sendMessage = "Написать сообщение...",
    typeYourMessage = "Введите сообщение:",
    actions = "Действия",
    action_claim = "Взять жалобу",
    action_unclaim = "Передать жалобу",
    action_spectate = "Наблюдать",
    action_goto = "К нему",
    action_bring = "К себе",
    action_return = "Вернуть на место",
    action_returnself = "Вернуться на место",
    action_copySteamID = "Скопировать SteamID",
    action_callon = "Включить просьбу о помощи",
    action_calloff = "Выключить просьбу о помощи",
    action_close = "Закрыть жалобу",
    error_wait = "Тихо-тихо... Куда так разогнался?",
    error_noAccess = "Ошибка доступа",
    error_playerNotFound = "Игрок не найден",
    error_ticketNotEnded = "Жалоба не закрыта",
    error_ticketNotFound = "Жалоба не найдена",
    error_ticketEnded = "Жалоба уже решена",
    error_ticketNotClaimed = "Жалоба никем не взята",
    error_ticketAlreadyClaimed = "Жалоба уже взята",
    error_needToRate = "Ты должен оценить прошлую жалобу!",
	error_cantCancelHasAdmin = "Нельзя отменить жалобу, которую рассматривают",
    ticketClaimed = "Жалоба взята",
    ticketUnclaimed = "Жалоба отдана",
    ticketClaimedBy = "Твою жалобу принял %s",
    ticketUnclaimedBy = "Твоя жалоба передана",
    ticketClosed = "Жалоба закрыта",
    ticketClosedBy = "%s закрыл жалобу. Оцени его работу!",
    ticketRatedForAdmin = "Оценка по твоей жалобе: %s",
    ticketRatedForUser = "Ты оценил решение жалобы на %s",
    ticketUserLeft = "Пользователь, чью жалобу ты решал, вышел",
    rateAdmin = "Нажми ниже, чтобы выбрать оценку",
    ok = "Готово",
    cancel = "Отмена",
    ticket_noAdmins = "На сервере нет администраторов, но если кто-то зайдет, он увидит твою жалобу",
    dow = {"ПН","ВТ","СР","ЧТ","ПТ","СБ","ВС"},
}

------------------------------------------------------
-- ADVANCED SETTINGS (do not edit unless you're a dev)
------------------------------------------------------

cats.config.serverID = "myserver"
cats.config.getPlayerName = function(ply)
    return ply:Name() .. " (" .. ply:SteamName() .. ")"
end
local groupsCanSeeTicket = {['founder']=true, ['serverstaff']=true, ['moderator']=true}
cats.config.playerCanSeeTicket = function(ply, ticketSteamID)
    return groupsCanSeeTicket[ply:GetUserGroup()] or ply:SteamID() == ticketSteamID
end
cats.config.triggerText = function(ply, text)
    if cats.config.playerCanSeeTicket(ply, "") then return false end

    text = text:Trim()
    if text:sub(1,1) == '@' then
        return true, text:sub(2):Trim()
    elseif text:sub(1,3) == '///' then
        return true, text:sub(4):Trim()
    end

    return false
end
cats.config.notify = function(ply, msg, type, duration)
    if IsValid(ply) then
        -- rp.Notify(ply, type, msg)
        -- DarkRP.notify(ply, type, duration, msg)
        -- meta.util.Notify('red', ply, msg)
        rp.Notify(ply, type, msg)
    else
        -- rp.NotifyAll(type, msg)
        -- DarkRP.notifyAll(type, duration, msg)
        -- meta.util.NotifyAll('red', msg)
        rp.NotifyAll(type, msg)
    end
end

-- NOTE: these are clientside
cats.config.commands = {
    -- { -- spectate
    --     text = cats.lang.action_spectate,
    --     icon = 'camera_go',
    --     click = function(ply)
    --         RunConsoleCommand('FSpectate', ply:SteamID())
    --     end
    -- },
    { -- bring
        text = cats.lang.action_bring,
        icon = 'user_go',
        click = function(ply)
            RunConsoleCommand('sg', 'bring', ply:SteamID())
        end
    },
    { -- return
        text = cats.lang.action_return,
        icon = 'arrow_undo',
        click = function(ply)
            RunConsoleCommand('sg', 'return', ply:SteamID())
        end
    },
    { -- goto
        text = cats.lang.action_goto,
        icon = 'arrow_right',
        click = function(ply)
            RunConsoleCommand('sg', 'goto', ply:SteamID())
        end
    },
    { -- return self
        text = cats.lang.action_returnself,
        icon = 'arrow_rotate_clockwise',
        click = function(ply)
            RunConsoleCommand('sg', 'return', LocalPlayer():SteamID())
        end
    },
    { -- copy steamID
        text = cats.lang.action_copySteamID,
        icon = 'key_go',
        click = function(ply)
            SetClipboardText( ply:SteamID() )
        end
    },
}

-- | also please do not touch these
-- V
if SERVER then
    ScrW = nil ScrH = nil
end
