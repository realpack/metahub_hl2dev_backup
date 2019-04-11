surface.CreateFont("cats.small", {
    font = "Roboto Bold",
    extended = true,
    size = 16,
    weight = 500
})

surface.CreateFont("cats.xlarge", {
    font = "Roboto Bold",
    extended = true,
    size = 48,
    weight = 500
})

surface.CreateFont("cats.large", {
    font = "Roboto Bold",
    extended = true,
    size = 36,
    weight = 500
})

surface.CreateFont("cats.medium", {
    font = "Roboto Bold",
    extended = true,
    size = 24,
    weight = 500
})

local c

local function n(t, e, a)
    local e = c[e]

    if not e then
        e = {
            tooltip = 'error',
            icon = Material('icon16/error.png'),
            click = function() end
        }
    end

    t:SetToolTip(e.tooltip)
    t.icon = e.icon

    t.DoClick = function(t)
        e.click(t, a)
    end
end

local function r(e)
    local n, a, t
    n = math.floor(e / 60 / 60)
    a = math.floor(e / 60) % 60
    t = math.floor(e) % 60

    return string.format("%02i:%02i:%02i", n, a, t)
end

function drawCircle(n, o, e, t)
    local a = {}

    table.insert(a, {
        x = n,
        y = o,
        u = .5,
        v = .5
    })

    for c = 0, t do
        local t = math.rad((c / t) * -360)

        table.insert(a, {
            x = n + math.sin(t) * e,
            y = o + math.cos(t) * e,
            u = math.sin(t) / 2 + .5,
            v = math.cos(t) / 2 + .5
        })
    end

    local t = math.rad(0)

    table.insert(a, {
        x = n + math.sin(t) * e,
        y = o + math.cos(t) * e,
        u = math.sin(t) / 2 + .5,
        v = math.cos(t) / 2 + .5
    })

    surface.DrawPoly(a)
end

local a = {
    action_claim = Material('metahub/lock.png', 'smooth noclamp'),
    action_unclaim = Material('metahub/unlock.png', 'smooth noclamp'),
    actions = Material('metahub/gear.png', 'smooth noclamp'),
    action_callon = Material('icon16/lightbulb_off.png', 'smooth noclamp'),
    action_calloff = Material('icon16/lightbulb.png', 'smooth noclamp'),
    action_close = Material('metahub/skull.png', 'smooth noclamp'),
    noStar = Material('icon16/bullet_white.png', 'smooth noclamp'),
    star = Material('icon16/star.png', 'smooth noclamp')
}

c = {
    action_claim = {
        tooltip = cats.lang.action_claim,
        icon = a.action_claim,
        click = function(t, e)
            net.Start('cats.claimTicket')
            net.WriteString(e:SteamID())
            net.WriteBool(true)
            net.SendToServer()
            n(t, 'action_unclaim', e)
        end
    },
    action_unclaim = {
        tooltip = cats.lang.action_unclaim,
        icon = a.action_unclaim,
        click = function(t, e)
            net.Start('cats.claimTicket')
            net.WriteString(e:SteamID())
            net.WriteBool(false)
            net.SendToServer()
            n(t, 'action_claim', e)
        end
    },
    actions = {
        tooltip = cats.lang.actions,
        icon = a.actions,
        click = function(e, a)
            local e = DermaMenu()

            for n, t in ipairs(cats.config.commands) do
                e:AddOption(t.text, function()
                    t.click(a)
                end):SetIcon('icon16/' .. (t.icon or 'wand') .. '.png')
            end

            e:SetPos(input.GetCursorPos())
            e:SetSkin('serverguard')
            e:Open()
        end
    },
    action_callon = {
        tooltip = cats.lang.action_callon,
        icon = a.action_callon,
        click = function(t, e)
            n(t, 'action_calloff', e)
        end
    },
    action_calloff = {
        tooltip = cats.lang.action_calloff,
        icon = a.action_calloff,
        click = function(e, t)
            n(e, 'action_callon', t)
        end
    },
    action_close = {
        tooltip = cats.lang.action_close,
        icon = a.action_close,
        click = function(t, e)
            net.Start('cats.closeTicket')
            net.WriteString(e:SteamID())
            net.SendToServer()
        end
    }
}

local l = {'action_claim', 'actions', 'action_close'}

local e = {
    user = LocalPlayer(),
    userID = 'STEAM_X:X:XXXXXXXX',
    admin = LocalPlayer(),
    adminID = 'STEAM_X:X:XXXXXXXX',
    chatLog = {{"Зюзя", "Админ тп, застрял", false}, {"СуперВася", "Ща, погоди", true}, {"Зюзя", "Ну где вы???", false}, {"УберПетя", "Бля, Вася, да вытащи ты его уже, наконец, он заебал вопить, как малое дите, сука, ебаный в рот", true}, {"СуперВася", "Ну ща-ща, я дорешаю жалобу", true}, {"УберПетя", "Да с хера ли ты берешь столько жалоб? Разберись сначала с одной, потом уж на другие иди", true}, {"СуперВася", "Да хорошо, блять, но дай сейчас-то разберусь", true}, {"Зюзя", "Идите оба нахуй, я выбрался уже", false}}
}

local t

local function i(c)
    surface.PlaySound(cats.config.newTicketSound)
    local e = cats.ticketContainer:Add("DButton")
    e:SetSize(cats.config.spawnSize[1], 180)
    e:SetText('')
    e.expanded = true
    e.ticket = c
    e.Created = SysTime();
    e.Closed = nil;
    e.Alpha = 0;

    e.Paint = function(n, t, a)
        local c, o = n.ticket.user, n.ticket.admin
        -- surface.SetDrawColor(30, 40, 50, 220)
        -- surface.DrawRect(0, 0, t, a)

        -- if n.Hovered then
        --     surface.SetDrawColor(255, 255, 255, 2)
        --     surface.DrawRect(0, 0, t, a)
        -- end

        n.Alpha = (math.Clamp(SysTime() - n.Created, 0, 0.15) - math.Clamp(SysTime() - (n.Closed or math.huge), 0, 0.15)) / 0.15;
        draw.Blur(n)
        surface.SetDrawColor(52, 73, 94, n.Alpha * 200)
        surface.DrawRect(0, 0, t, a)

        -- surface.SetDrawColor(0, 0, 0, 255)
        -- surface.DrawLine(0, -1, 0, a)
        -- surface.DrawLine(-1, a - 1, t, a - 1)
        -- surface.DrawLine(t - 1, a, t - 1, -1)
        local a = '(' .. os.date("%M:%S", CurTime() - n.ticket.created) .. ')'
        local n = IsValid(c) and c:Name() or cats.lang.userDisconnected
        local c = '★' .. math.Round(c:GetNWFloat("cats_averageRating"), 1)
        draw.SimpleText(a .. ' ' .. c .. ' ' .. n, 'cats.small', 8, 15, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        if IsValid(o) then
            local e = '★' .. math.Round(o:GetNWFloat("cats_adminRating"), 1)
            draw.SimpleText(e .. ' ' .. o:Name(), 'cats.small', t - 8, 15, Color(180, 200, 240), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end

    e.DoClick = function(t)
        t.expanded = not t.expanded

        for t, e in ipairs(cats.ticketContainer:GetChildren()) do
            e:InvalidateLayout(true)
        end

        cats.ticketContainer:Layout()

        timer.Simple(0, function()
            t.chatLog:GotoTextEnd()
        end)
    end

    e.PerformLayout = function(e)
        e:SetSize(e:GetParent():GetWide(), e.expanded and 180 or 30)
        e.controls:SetVisible(e.expanded)
    end

    local t = vgui.Create("DPanel", e)
    t:DockMargin(1, 1, 1, 1)
    t:Dock(BOTTOM)
    t:SetTall(150)
    t.Paint = function() end
    e.controls = t
    e.controls.buttons = {}

    for o, a in pairs(l) do
        local t = vgui.Create("DButton", t)
        t:SetSize(30, 30)
        t:SetPos(0, (o - 1) * 30)
        t:SetText('')

        t.Paint = function(e, a, t)
            if e.Hovered then
                draw.RoundedBox(0, 0, 0, a, t, Color(255, 255, 255, 2))
            end

            surface.SetMaterial(e.icon)
            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(7, 7, 16, 16)
        end

        n(t, a, e.ticket.user)
        e.controls.buttons[a] = t
    end

    local a = vgui.Create("DPanel", e.controls)
    a:Dock(FILL)
    a:DockMargin(30, 0, 0, 0)

    a.Paint = function(n, a, t)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, a, t - 20)
        surface.SetDrawColor(0, 0, 0, 255)
        -- surface.DrawLine(0, t, 0, 0)
        -- surface.DrawLine(-1, 0, a, 0)
        -- surface.DrawLine(-1, t - 21, a, t - 21)
    end

    e.chat = a
    local t = vgui.Create("DButton", e.chat)
    t:Dock(BOTTOM)
    t:SetText('')
    t:SetTall(20)
    t:SetCursor('beam')

    t.Paint = function(e, n, a)
        if e.Hovered then
            draw.RoundedBox(0, 0, 0, n, a, Color(255, 255, 255, 1))
        end

        draw.SimpleText(cats.lang.sendMessage, 'cats.small', 8, 10, Color(220, 220, 220, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    t.DoClick = function(e)
        Derma_StringRequest(cats.lang.sendMessage, cats.lang.typeYourMessage, '', function(e)
            net.Start("cats.dispatchMessage")
            net.WriteString(c.userID)
            net.WriteString(e)
            net.SendToServer()
        end, function() end, cats.lang.ok, cats.lang.cancel)
    end

    local a = vgui.Create("RichText", e.chat)
    a:Dock(FILL)

    a.Paint = function(t)
        t.m_FontName = "cats.small"
        t:SetFontInternal("cats.small")
        t:SetBGColor(Color(0, 0, 0, 0))
        t.Paint = nil
    end

    e.chatLog = a
    cats.ticketContainer[c.userID] = e
    cats.ticketFrame:PerformLayout()
end

local function c(e, a, n, t)
    local e = cats.ticketContainer[e].chatLog
    if not IsValid(e) then return end

    if t then
        e:InsertColorChange(50, 120, 180, 255)
    else
        e:InsertColorChange(180, 160, 50, 255)
    end

    e:AppendText("\n" .. a)
    e:InsertColorChange(220, 220, 220, 255)
    e:AppendText(": " .. n)
end

hook.Add("Think", "cats", function()
    if IsValid(cats.ticketFrame) then
        cats.ticketFrame:Remove()
    end

    local t, a = cats.config.spawnSize[1], cats.config.spawnSize[2]
    local n, o = cats.config.spawnPosAdmin[1], cats.config.spawnPosAdmin[2]
    local e = vgui.Create("DFrame")
    e:SetSize(t, a)
    e:SetPos(n, o)
    e:DockPadding(0, 24, 0, 0)
    e:SetTitle('')
    e:ShowCloseButton(false)
    cats.ticketFrame = e
    local t = vgui.Create("DScrollPanel", e)
    t:Dock(FILL)
    local a = t.PerformLayout

    t.PerformLayout = function(e)
        a(e)

        for t, e in ipairs(cats.ticketContainer:GetChildren()) do
            e:InvalidateLayout()
        end
    end

    local t = vgui.Create("DIconLayout", t)
    t:Dock(FILL)
    t:SetSpaceX(0)
    t:SetSpaceY(0)
    cats.ticketContainer = t
    local n = e.PerformLayout

    e.PerformLayout = function(a)
        n(a)
        a:SetTall(math.min(t:GetTall(), ScrH() - 100, 600) + 27)
        a:SetVisible(#t:GetChildren() > 0)
    end

    e.Paint = function(a, e, a)
        surface.SetDrawColor(52, 73, 94, 90)
        surface.DrawRect(0, 0, e, 24)
        surface.SetDrawColor(0, 0, 0, 255)
        -- surface.DrawOutlinedRect(0, 0, e, 24)
        draw.SimpleText(cats.lang.openTickets .. ' (' .. #t:GetChildren() .. ')', 'cats.small', 8, 12, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    hook.Remove("Think", "cats")
end)

if IsValid(cats.myTicketFrame) then
    cats.myTicketFrame:Remove()
end

local function d(e)
    surface.PlaySound(cats.config.newTicketSound)
    t = e
    local c, e = cats.config.spawnSize[1], cats.config.spawnSize[2]
    local o, n = cats.config.spawnPosUser[1], cats.config.spawnPosUser[2]
    local e = vgui.Create("DFrame")
    e:ShowCloseButton(false)
    e:SetSize(c, 220)
    e:SetPos(o, n)
    e:DockPadding(0, 30, 0, 0)
    e:SetTitle('')
    e.ticket = t
    e.Created = SysTime();
    e.Closed = nil;
    e.Alpha = 0;

    e.Paint = function(e, a, n)
        local o, t = e.ticket.user, e.ticket.admin
        e.Alpha = (math.Clamp(SysTime() - e.Created, 0, 0.15) - math.Clamp(SysTime() - (e.Closed or math.huge), 0, 0.15)) / 0.15;
        draw.Blur(e)
        surface.SetDrawColor(52, 73, 94, e.Alpha * 200)
        surface.DrawRect(0, 0, a, n)

        surface.SetDrawColor(0, 0, 0, 255)
        -- surface.DrawOutlinedRect(0, 0, a, n)
        local e = '(' .. os.date("%M:%S", CurTime() - e.ticket.created) .. ')'
        draw.SimpleText(e .. ' ' .. cats.lang.myTicket, 'cats.small', 8, 15, Color(220, 220, 220), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        if IsValid(t) then
            local e = '★' .. math.Round(t:GetNWFloat("cats_adminRating"), 1)
            draw.SimpleText(e .. ' ' .. t:Name(), 'cats.small', a - 8, 15, Color(180, 200, 240), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
        end
    end

    surface.SetFont('font_base_22')
    local o, n = surface.GetTextSize(cats.lang.action_close)
    local n = vgui.Create("DButton", e)
    n:SetText('')
    n:SetSize(o + 16, 30)
    n:AlignRight(1)

    n.Paint = function(a, e, t)
        draw.RoundedBox(0, 0, 0, e, t, Color(92,184,92))
        draw.SimpleText(cats.lang.action_close, "font_base_22", e/2, t/2, Color( 255, 255, 255, 255 ), 1, 1)
        -- if a.Hovered then
        --     draw.RoundedBox(0, 0, 0, e, t, Color(255, 255, 255, 1))
        -- end

        -- draw.SimpleText(cats.lang.action_close, 'cats.small', e / 2, t / 2, Color(220, 220, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    n.DoClick = function(t)
        net.Start('cats.closeTicket')
        net.WriteString(LocalPlayer():SteamID())
        net.SendToServer()
    end

    e.closeBut = n
    local n = vgui.Create("DPanel", e)
    n:Dock(FILL)

    n.Paint = function(n, a, t)
        surface.SetDrawColor(0, 0, 0, 100)
        surface.DrawRect(0, 0, a, t - 20)
        surface.SetDrawColor(0, 0, 0, 255)
        -- surface.DrawLine(0, t, 0, 0)
        -- surface.DrawLine(-1, 0, a, 0)
        -- surface.DrawLine(-1, t - 21, a, t - 21)
    end

    e.chat = n
    local o = vgui.Create("DButton", e.chat)
    o:Dock(BOTTOM)
    o:SetText('')
    o:SetTall(20)
    o:SetCursor('beam')

    o.Paint = function(t, a, e)
        if t.Hovered then
            draw.RoundedBox(0, 0, 0, a, e, Color(255, 255, 255, 1))
        end

        draw.SimpleText(cats.lang.sendMessage, 'cats.small', 8, 10, Color(220, 220, 220, 50), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    o.DoClick = function(e)
        Derma_StringRequest(cats.lang.sendMessage, cats.lang.typeYourMessage, '', function(e)
            net.Start("cats.dispatchMessage")
            net.WriteString(LocalPlayer():SteamID())
            net.WriteString(e)
            net.SendToServer()
        end, function() end, cats.lang.ok, cats.lang.cancel)
    end

    local o = vgui.Create("RichText", e.chat)
    o:Dock(FILL)

    o.Paint = function(t)
        t.m_FontName = "cats.small"
        t:SetFontInternal("cats.small")
        t:SetBGColor(Color(0, 0, 0, 0))
        t.Paint = nil
    end

    e.chatLog = o

    e.SwitchToRating = function(e)
        n:Clear()
        n.Paint = function() end
        local e = vgui.Create('DButton', n)
        e:DockPadding(1, 0, 1, 1)
        e:SetTall(30)
        e:Dock(BOTTOM)
        e:SetText('')
        e:SetEnabled(false)

        e.Paint = function(t, n, a)
            if t:IsEnabled() then
                if t.Hovered then
                    draw.RoundedBox(0, 0, 0, n, a, Color(255, 255, 255, 2))
                end

                draw.SimpleText(cats.lang.ok, "cats.small", n / 2, a / 2, Color(220, 220, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            surface.SetDrawColor(0, 0, 0, 255)
        end

        e.DoClick = function(e)
            net.Start('cats.setRating')
            net.WriteUInt(math.Clamp(t.rating or cats.config.defaultRating, 1, 5), 8)
            net.SendToServer()
            cats.myTicketFrame:Remove()
            t = nil
        end

        local n = vgui.Create('DPanel', n)
        n:Dock(FILL)

        n.Paint = function(a, e, t)
            draw.SimpleText(cats.lang.rateAdmin, "cats.small", e / 2, t / 2 - 24, Color(220, 220, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.RoundedBox(0, 0, 0, e, t, Color(0, 0, 0, 100))
            -- surface.DrawLine(-1, 0, e, 0)
            -- surface.DrawLine(-1, t, e, t)
        end

        for o = 1, 5 do
            local l = o - 3
            local n = vgui.Create('DButton', n)
            n:SetText('')
            n:SetSize(64, 64)
            n:SetPos(c / 2 + l * 64 - 32, 160 / 2 - 18)

            n.Paint = function(e, c, c)
                if e.Hovered then
                    draw.RoundedBox(0, 8, 8, 48, 48, Color(255, 255, 255, 2))
                end

                if not t.rating then
                    surface.SetDrawColor(255, 255, 255, 20)
                    surface.SetMaterial(a.star)
                    surface.DrawTexturedRect(16, 16, 32, 32)
                elseif t.rating and o <= t.rating then
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(a.star)
                    surface.DrawTexturedRect(16, 16, 32, 32)
                else
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(a.noStar)
                    surface.DrawTexturedRect(24, 24, 16, 16)
                end
            end

            n.DoClick = function(a)
                e:SetEnabled(true)
                t.rating = o
            end
        end
    end

    cats.myTicketFrame = e
end

local function l(a, t, n)
    local e = cats.myTicketFrame.chatLog
    if not IsValid(e) then return end

    if n then
        e:InsertColorChange(50, 120, 180, 255)
    else
        e:InsertColorChange(180, 160, 50, 255)
    end

    e:AppendText("\n" .. a)
    e:InsertColorChange(220, 220, 220, 255)
    e:AppendText(": " .. t)
end

net.Receive('cats.dispatchMessage', function(e)
    local e = net.ReadString()
    local a = net.ReadEntity()
    local o = net.ReadString()
    local n = cats.config.getPlayerName(a)
    if not IsValid(a) then return end

    if e == LocalPlayer():SteamID() then
        if t then
            l(n, o, a:SteamID() ~= LocalPlayer():SteamID())
        else
            d({
                created = CurTime()
            })

            l(n, o, a:SteamID() ~= LocalPlayer():SteamID())
        end
    elseif IsValid(cats.ticketContainer[e]) then
        c(e, n, o, a:SteamID() ~= e)
    else
        local t = player.GetBySteamID(e)
        if not IsValid(t) then return end

        i({
            user = t,
            userID = e,
            created = CurTime()
        })

        c(e, n, o, a:SteamID() ~= e)
    end
end)

net.Receive('cats.claimTicket', function(e)
    local o = net.ReadString()
    local a = net.ReadEntity()
    local e = net.ReadBool()
    if e and not IsValid(a) then return end

    if o == LocalPlayer():SteamID() and t then
        t.admin = e and a or nil
        t.adminID = e and a:SteamID() or nil
        cats.myTicketFrame.closeBut:SetVisible(not e)
    elseif IsValid(cats.ticketContainer[o]) then
        local t = cats.ticketContainer[o].ticket
        t.admin = e and a or nil
        t.adminID = e and a:SteamID() or nil

        if t.adminID ~= LocalPlayer():SteamID() then
            local a = cats.ticketContainer[o].controls.buttons['action_claim']

            if e then
                n(a, 'action_unclaim', t.user)
                a:SetEnabled(false)
            else
                n(a, 'action_claim', t.user)
                a:SetEnabled(true)
            end
        end
    end
end)

net.Receive('cats.closeTicket', function(e)
    local e = net.ReadString()

    if e == LocalPlayer():SteamID() and t then
        if IsValid(t.admin) then
            cats.myTicketFrame:SwitchToRating()
        else
            cats.myTicketFrame:Remove()
            t = nil
        end
    elseif IsValid(cats.ticketContainer[e]) then
        cats.ticketContainer[e].ticket = nil
        cats.ticketContainer[e]:Remove()
        cats.ticketFrame:PerformLayout()
    end
end)

net.Receive('cats.setRating', function(e)
    local e = net.ReadString()
    local t = net.ReadUInt(8)

    if e == LocalPlayer():SteamID() then
        cats.myTicketFrame:Remove()
    end
end)

net.Receive('cats.syncTickets', function(e)
    local e = net.ReadTable()

    for t, e in pairs(e) do
        local a = player.GetBySteamID(t)

        if IsValid(a) then
            i({
                user = a,
                userID = t,
                created = e.createdGameTime,
                admin = e.admin,
                adminID = e.adminID
            })

            if IsValid(e.admin) then
                local t = cats.ticketContainer[t].controls.buttons['action_claim']
                n(t, 'action_unclaim', e.user)
                t:SetEnabled(false)
            end

            for a, e in pairs(e.chatLog) do
                c(t, e[1], e[2], e[3])
            end
        end
    end
end)

concommand.Add("cats_test_admin", function()
    local e = LocalPlayer():SteamID()

    i({
        user = LocalPlayer(),
        userID = e,
        created = CurTime(),
        admin = LocalPlayer(),
        adminID = e
    })

    c(e, "chelog", "Админ, дайте мне проверить мой репорт!", false)
    c(e, "Admin", "Хорошо.", true)
end)

concommand.Add("cats_test_admin_clear", function()
    cats.ticketContainer:Clear()
end)

concommand.Add("cats_test_myticket", function()
    d({
        created = CurTime()
    })

    l("chelog", "Админ, дайте мне проверить мой репорт!", false)
    l("Admin", "Хорошо.", true)
end)

local function a()
    local groups = {['founder'] = true, ['moderator'] = true}
    if not groups[LocalPlayer():GetUserGroup()] then return end

    surface.PlaySound(cats.config.newTicketSound)
    local e = vgui.Create('DFrame')
    e:SetSize(1024, 768)
    e:SetTitle('CATS - Analytics')
    e:Center()
    e:MakePopup()
    cats.analyticsFrame = e
    local t = vgui.Create('DListView', e)
    t:Dock(LEFT)
    t:SetWide(160)
    t:SetMultiSelect(false)
    t:AddColumn('Rating'):SetFixedWidth(50)
    t:AddColumn('Admin')

    t.OnRowSelected = function(t, t, a)
        e.pnl:Clear()
        local t = vgui.Create('DLabel', e.pnl)
        t:SetText('Loading...')
        t:SizeToContents()
        t:Center()
        net.Start('cats.getAdminData')
        net.WriteString(a.steamID)
        net.SendToServer()
    end

    e.list = t
    local t = vgui.Create('DScrollPanel', e)
    t:DockMargin(5, 0, 0, 0)
    t:Dock(FILL)
    e.pnl = t
    net.Start('cats.getAdminList')
    net.SendToServer()
end

concommand.Add('cats_analytics', a)

netstream.Hook('cats.getAdminList', function(e)
    if not istable(e) then return end

    for a, e in pairs(e) do
        local t = '★' .. math.Round(e.ratingTotal or 0, 2)
        local e = cats.analyticsFrame.list:AddLine(t, e.lastNick)
        e.steamID = a
    end

    cats.analyticsFrame.list:SortByColumn(1, true)
end)

net.Receive('cats.getAdminData', function()
    local e = net.ReadTable()
    if not IsValid(cats.analyticsFrame) or not IsValid(cats.analyticsFrame.pnl) then return end
    local a = cats.analyticsFrame.pnl
    a:Clear()
    local t = vgui.Create('DLabel', a)
    t:DockMargin(20, 10, 20, 0)
    t:Dock(TOP)
    t:SetTall(50)
    t:SetFont('cats.xlarge')
    t:SetText(e.lastNick)
    local t = vgui.Create('DLabel', a)
    t:DockMargin(20, 5, 20, 0)
    t:Dock(TOP)
    t:SetTall(20)
    t:SetFont('cats.medium')
    t:SetText(e.steamID)
    t:SetToolTip('Click to copy SteamID')

    t.DoClick = function(t)
        SetClipboardText(e.steamID)
    end

    local n = {{'РЕЙТИНГ', '★' .. math.Round(e.ratingTotal or 0, 2)}, {'ЖАЛОБЫ', e.claimsTotal}, {'ПОЛЬЗОВАТЕЛИ', e.uniqueUsers}, {'В НЕДЕЛЮ', math.Round((e.claimsTotal or 0) / (e.updateTime - e.createdTime) * 604800)}, {'ВРЕМЯ ЖАЛОБ', r(e.ticketTimeTotal)}}

    if e.playTimeTotal then
        table.insert(n, {'ВРЕМЯ ИГРЫ', r(e.playTimeTotal)})
    end

    local t = vgui.Create('DIconLayout', a)
    t:DockMargin(20, 20, 20, 0)
    t:Dock(TOP)
    t:SetTall(100)

    for e, n in ipairs(n) do
        local e = t:Add('DPanel')
        e:SetSize((a.pnlCanvas:GetWide() - 40) / 3, 100)

        e.Paint = function(o, t, a)
            draw.RoundedBox(8, 5, 5, t - 10, a - 10, Color(0, 0, 0, 60))
            draw.SimpleText(n[1], "cats.medium", t / 2, 30, Color(220, 220, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(n[2], "cats.xlarge", t / 2, 65, Color(220, 220, 220), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        e.PerformLayout = function(e)
            e:SetWide((a.pnlCanvas:GetWide() - 40) / 3)
        end
    end

    local t = vgui.Create('DLabel', a)
    t:DockMargin(20, 20, 20, 5)
    t:Dock(TOP)
    t:SetTall(20)
    t:SetFont('cats.medium')
    t:SetText('Play time card')
    local d, c, r = cats.lang.dow, cats.config.punchCardMode, cats.config.punchCardStart - 1
    local l = 1

    for t = 1, 7 do
        for a = 1, 24 do
            l = math.max(l, e.timeCard[t][a])
        end
    end

    local n = vgui.Create('DPanel', a)
    n:DockMargin(20, 10, 20, 0)
    n:Dock(TOP)
    n:SetTall(400)

    n.Paint = function(t, e, a)
        draw.RoundedBox(8, 0, 0, e, a, Color(0, 0, 0, 60))
        e, a = e - 55, a - 35
        local n, e = a / 7, e / 24
        draw.NoTexture()

        for e = 1, 7 do
            draw.SimpleText(d[e], "cats.medium", 25, 30 + n * (e) - n / 2, Color(220, 220, 220, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(220, 220, 220, 4)

        for o = 1, 24 do
            local t = o - r
            t = t > 0 and t or t + 24
            draw.SimpleText(o ~= 24 and o or 0, "cats.small", 50 + e * (t - 1) + e / 2, 20, Color(220, 220, 220, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetDrawColor(220, 220, 220, 4)

            if c == 'dots' then
                surface.DrawLine(50 + e * (t - 1) + e / 2, 30 + n / 2, 50 + e * (t - 1) + e / 2, 30 + a - n / 2)
            elseif c == 'line' then
                surface.DrawLine(50 + e * (t - 1) + e / 2, 30, 50 + e * (t - 1) + e / 2, 30 + a)
            end
        end
    end

    local t = vgui.Create('DPanel', n)
    t:DockMargin(50, 30, 5, 5)
    t:Dock(FILL)

    t.Paint = function(n, a, t)
        local o, a = t / 7, a / 24
        draw.NoTexture()

        for n = 1, 7 do
            for i = 1, 24 do
                local t = i - r
                t = t > 0 and t or t + 24

                if c == 'dots' then
                    local e = math.max(math.floor((a - 4) * e.timeCard[n][i] / l), 2)
                    local a, t = math.floor(a * (t - 1) + a / 2), math.floor(o * (n) - o / 2)
                    surface.SetDrawColor(220, 220, 220)
                    drawCircle(a, t, e / 2, math.max(e, 6))
                elseif c == 'line' then
                    if t < 24 then
                        local i, c = a * (t - 1) + a / 2, o * (n) - (o - 16) * e.timeCard[n][i] / l - 8
                        local e, t = a * (t) + a / 2, o * (n) - (o - 16) * e.timeCard[n][t + 1] / l - 8
                        surface.SetDrawColor(220, 220, 220)
                        surface.DrawLine(math.floor(i), math.floor(c), math.floor(e), math.floor(t))
                    end
                else
                    local e = math.floor(math.floor((o - 8) * e.timeCard[n][i] / l))
                    draw.RoundedBoxEx(math.floor(math.min(e, 4)), a * (t - 1) + 3, math.floor(o * (n) - e), a - 6, e, Color(220, 220, 220), true, true, false, false)
                end
            end
        end
    end

    local t = vgui.Create('DLabel', a)
    t:DockMargin(20, 20, 20, 5)
    t:Dock(TOP)
    t:SetTall(20)
    t:SetFont('cats.medium')
    t:SetText('Ticket claim card')
    local l = 1

    for a = 1, 7 do
        for t = 1, 24 do
            l = math.max(l, e.claimCard[a][t])
        end
    end

    local n = vgui.Create('DPanel', a)
    n:DockMargin(20, 10, 20, 0)
    n:Dock(TOP)
    n:SetTall(400)

    n.Paint = function(t, e, a)
        draw.RoundedBox(8, 0, 0, e, a, Color(0, 0, 0, 60))
        e, a = e - 55, a - 35
        local n, e = a / 7, e / 24
        draw.NoTexture()

        for e = 1, 7 do
            draw.SimpleText(d[e], "cats.medium", 25, 30 + n * (e) - n / 2, Color(220, 220, 220, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        surface.SetDrawColor(220, 220, 220, 4)

        for o = 1, 24 do
            local t = o - r
            t = t > 0 and t or t + 24
            draw.SimpleText(o ~= 24 and o or 0, "cats.small", 50 + e * (t - 1) + e / 2, 20, Color(220, 220, 220, 35), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            surface.SetDrawColor(220, 220, 220, 4)

            if c == 'dots' then
                surface.DrawLine(50 + e * (t - 1) + e / 2, 30 + n / 2, 50 + e * (t - 1) + e / 2, 30 + a - n / 2)
            elseif c == 'line' then
                surface.DrawLine(50 + e * (t - 1) + e / 2, 30, 50 + e * (t - 1) + e / 2, 30 + a)
            end
        end
    end

    local t, i, r = cats.lang.dow, cats.config.punchCardMode, cats.config.punchCardStart - 1
    local t = vgui.Create('DPanel', n)
    t:DockMargin(50, 30, 5, 5)
    t:Dock(FILL)

    t.Paint = function(n, a, t)
        local o, a = t / 7, a / 24
        draw.NoTexture()

        for n = 1, 7 do
            for c = 1, 24 do
                local t = c - r
                t = t > 0 and t or t + 24

                if i == 'dots' then
                    local e = math.max(math.floor((a - 4) * e.claimCard[n][c] / l), 2)
                    local t, a = math.floor(a * (t - 1) + a / 2), math.floor(o * (n) - o / 2)
                    surface.SetDrawColor(220, 220, 220)
                    drawCircle(t, a, e / 2, math.max(e, 6))
                elseif i == 'line' then
                    if t < 24 then
                        local i, c = a * (t - 1) + a / 2, o * (n) - (o - 16) * e.claimCard[n][c] / l - 8
                        local t, e = a * (t) + a / 2, o * (n) - (o - 16) * e.claimCard[n][t + 1] / l - 8
                        surface.SetDrawColor(220, 220, 220)
                        surface.DrawLine(math.floor(i), math.floor(c), math.floor(t), math.floor(e))
                    end
                else
                    local e = math.floor(math.floor((o - 8) * e.claimCard[n][c] / l))
                    draw.RoundedBoxEx(math.floor(math.min(e, 4)), a * (t - 1) + 3, math.floor(o * (n) - e), a - 6, e, Color(220, 220, 220), true, true, false, false)
                end
            end
        end
    end
end)
