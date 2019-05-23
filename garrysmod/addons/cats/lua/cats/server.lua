---------------------------------------------------
-- CONFIG (TEMPORARY)
---------------------------------------------------
cats.mysqlite = {}
cats.mysqlite.EnableMySQL = false -- Set to true if you want to use an external MySQL database, false if you want to use the built in SQLite database (garrysmod/sv.db) of Garry's mod
cats.mysqlite.Host = "127.0.0.1" -- The IP address of the MySQL host
cats.mysqlite.Username = "" -- The username to log in on the MySQL server
cats.mysqlite.Password = "" -- The password to log in on the MySQL server
cats.mysqlite.Database_name = "" -- The name of the Database on the MySQL server
cats.mysqlite.Database_port = 3306 -- The port of the MySQL server
cats.mysqlite.Preferred_module = "mysqloo" -- The MySQL module you use for GMod server
-- the code
util.AddNetworkString"cats.dispatchMessage"
util.AddNetworkString"cats.syncTickets"
util.AddNetworkString"cats.claimTicket"
util.AddNetworkString"cats.closeTicket"
util.AddNetworkString"cats.setRating"
util.AddNetworkString"cats.getAdminList"
util.AddNetworkString"cats.getAdminData"

cats.currentTickets = cats.currentTickets or {}

local function n(e)
    local t = {}

    for n, a in ipairs(player.GetAll()) do
        if cats.config.playerCanSeeTicket(a, e) then
            table.insert(t, a)
        end
    end

    return t
end

local e = {}

for t = 1, 7 do
    e[t] = {}

    for a = 1, 24 do
        e[t][a] = 0
    end
end

function cats:Log(t)
    print("[CATS] " .. t)
end

function cats:Init()
    self.config.serverID = self.config.serverID:gsub('[^A-Za-z]', '')
    MySQLite.initialize(self.mysqlite)
    self:Log("Initialized.")
end

cats:Init()

function cats.QueryError(t, a)
    error("\n[CATS] Query error : " .. t .. " on query : '" .. a .. "'\n\n")
end

function cats:Query(t, a)
    if not t or type(t) ~= "string" then return end
    MySQLite.query(t, a, self.QueryError)
end

function cats:DispatchMessage(a, t, e)
    local i = cats.config.getPlayerName(a)
    local n = n(t)

    if self.currentTickets[t] and not self.currentTickets[t].ended then
        table.insert(self.currentTickets[t].chatLog, {i, e, a:SteamID() ~= t})
    else
        if a:SteamID() == t and cats.config.playerCanSeeTicket(a) then
            cats.config.notify(t, cats.lang.error_noAccess, NOTIFY_ERROR, 3)

            return
        end

        self.currentTickets[t] = {
            createdTime = os.time(),
            createdGameTime = CurTime(),
            chatLog = {{i, e}},
            user = a,
            userID = t
        }

        if #n < 2 then
            cats.config.notify(a, cats.lang.ticket_noAdmins, NOTIFY_GENERIC, 10)
        end
    end

    net.Start('cats.dispatchMessage')
    net.WriteString(t)
    net.WriteEntity(a)
    net.WriteString(e)
    net.Send(n)
end

net.Receive('cats.dispatchMessage', function(a, t)
    local a = net.ReadString()
    local e = net.ReadString()
    local n = player.GetBySteamID(a)

    if not IsValid(n) then
        cats.config.notify(t, cats.lang.error_playerNotFound, NOTIFY_ERROR, 3)

        return
    end

    if not cats.config.playerCanSeeTicket(t, a) then
        cats.config.notify(t, cats.lang.error_noAccess, NOTIFY_ERROR, 3)

        return
    end

    cats:DispatchMessage(t, a, e)
end)

function cats:SaveTicket(e, a)
    local t = self.currentTickets[e]

    if not t then
        self:Log('Trying to close inexistant ticket for ' .. e)

        return
    end

    local n = string.format([[ INSERT INTO cats_]] .. self.config.serverID .. [[_claims(user, admin, createdTime, ticketTime, rating) VALUES (%s, %s, %d, %d, %f); ]], MySQLite.SQLStr(e), MySQLite.SQLStr(t.adminID), t.createdTime, t.finishTime - t.claimTime, a)

    self:Query(n, function(n)
        if IsValid(t.user) then
            cats.config.notify(t.user, string.format(cats.lang.ticketRatedForUser, tostring(a)), NOTIFY_CLEANUP, 8)
        end

        if IsValid(t.admin) and t.admin.cats_adminData then
            cats.config.notify(t.admin, string.format(cats.lang.ticketRatedForAdmin, tostring(a)), NOTIFY_CLEANUP, 8)
            local a = os.date('*t', os.time())
            a.wday = a.wday - 1
            day = a.wday ~= 0 and a.wday or 7
            hour = a.hour ~= 0 and a.hour or 24
            t.admin.cats_adminData.claimCard[day][hour] = t.admin.cats_adminData.claimCard[day][hour] + 1
        end

        self.currentTickets[e] = nil
    end)
end

net.Receive('cats.closeTicket', function(t, a)
    local e = net.ReadString()
    local t = cats.currentTickets[e]

    if not t then
        cats.config.notify(a, cats.lang.error_ticketNotFound, NOTIFY_ERROR, 3)
        net.Start('cats.closeTicket')
        net.WriteString(e)
        net.Send(n(e))
        return
    end

    if t.ended then
        cats.config.notify(a, cats.lang.error_ticketEnded, NOTIFY_ERROR, 3)

        net.Start('cats.closeTicket')
        net.WriteString(e)
        net.Send(n(e))
        if cats.currentTickets[e] then
            cats.currentTickets[e] = nil
        end

        return
    end

    if t.adminID == a:SteamID() then
        t.ended = true
        t.finishTime = os.time()
        net.Start('cats.closeTicket')
        net.WriteString(e)
        net.Send(n(e))

        if IsValid(t.user) then
            cats.config.notify(t.user, string.format(cats.lang.ticketClosedBy, t.admin:Name()), NOTIFY_GENERIC, 5)
        end

        cats.config.notify(a, cats.lang.ticketClosed, NOTIFY_GENERIC, 3)
    elseif (t.userID == a:SteamID() and not IsValid(t.admin)) or a:GetUserGroup() == 'moderator' then
        net.Start('cats.closeTicket')
        net.WriteString(e)
        net.Send(n(e))
        cats.currentTickets[e] = nil
    else
        cats.config.notify(a, cats.lang.error_noAccess, NOTIFY_ERROR, 3)

        return
    end
end)

net.Receive('cats.setRating', function(a, t)
    local e = t:SteamID()
    local n = math.Clamp(net.ReadUInt(8) or cats.config.defaultRating, 1, 5)
    local a = cats.currentTickets[e]

    if not a then
        cats.config.notify(t, cats.lang.error_ticketNotFound, NOTIFY_ERROR, 3)
        net.Start('cats.closeTicket')
        net.WriteString(e)
        net.Send(n(e))
        return
    end

    if not a.ended then
        cats.config.notify(t, cats.lang.error_ticketNotEnded, NOTIFY_ERROR, 3)

        return
    end

    net.Start('cats.setRating')
    net.WriteString(e)
    net.WriteUInt(n, 8)
    net.Send({t, a.admin})
    cats:SaveTicket(e, n)
end)

function cats:ClaimTicket(e, a, i)
    local t = self.currentTickets[e]

    if not t then
        self:Log('Trying to claim inexistant ticket for ' .. e)

        return
    end

    if (t.adminID and t.adminID ~= a:SteamID()) or e == a:SteamID() then
        cats.config.notify(a, cats.lang.error_noAccess, NOTIFY_ERROR, 3)

        return
    end

    if i then
        t.admin = a
        t.adminID = a:SteamID()
        t.claimTime = os.time()
    else
        t.admin = nil
        t.adminID = nil
    end

    net.Start('cats.claimTicket')
    net.WriteString(e)
    net.WriteEntity(a)
    net.WriteBool(i)
    net.Send(n(e))
end

net.Receive('cats.claimTicket', function(a, t)
    local e = net.ReadString()
    local n = net.ReadBool()
    local a = cats.currentTickets[e]

    if not cats.config.playerCanSeeTicket(t, e) then
        cats.config.notify(t, cats.lang.error_noAccess, NOTIFY_ERROR, 3)

        return
    end

    if not a then
        cats.config.notify(t, cats.lang.error_ticketNotFound, NOTIFY_ERROR, 3)
        net.Start('cats.closeTicket')
        net.WriteString(e)
        net.Send(n(e))
        return
    end

    if n then
        if IsValid(a.admin) then
            cats.config.notify(t, cats.lang.error_ticketAlreadyClaimed, NOTIFY_ERROR, 3)

            return
        end

        cats.config.notify(t, cats.lang.ticketClaimed, NOTIFY_GENERIC, 5)
        cats.config.notify(a.user, string.format(cats.lang.ticketClaimedBy, t:Name()), NOTIFY_GENERIC, 5)
    else
        if not IsValid(a.admin) then
            cats.config.notify(t, cats.lang.error_ticketNotClaimed, NOTIFY_ERROR, 3)

            return
        end

        cats.config.notify(t, cats.lang.ticketUnclaimed, NOTIFY_GENERIC, 5)
        cats.config.notify(a.user, string.format(cats.lang.ticketUnclaimedBy, t:Name()), NOTIFY_GENERIC, 5)
    end

    cats:ClaimTicket(e, t, n)
end)

function cats:GetAdminList(t, a)
    cats:Query([[ SELECT steamID, lastNick, ratingTotal FROM cats_]] .. self.config.serverID .. [[_admins; ]], function(t)
        if t and #t > 0 then
            local data = {}
            for e, t in pairs(t) do
                data[t.steamID] = {
                    steamID = tostring(t.steamID), -- just in case
                    lastNick = tostring(t.lastNick),
                    ratingTotal = tonumber(t.ratingTotal) or 0,
                }
            end
            a(data)
        end
    end)
end

function cats:InvalidateTickets()

    for steamID, ticket in pairs(cats.currentTickets) do
        local ply = player.GetBySteamID(steamID)

        if not IsValid(ticket.admin) then
            cats:ClaimTicket(t, a, false)
        end

        if not IsValid(ply) then
            cats.currentTickets[steamID] = nil
            if IsValid(ticket.admin) then
                cats.config.notify(ticket.admin, cats.lang.ticketUserLeft, NOTIFY_ERROR, 8)
            end
            net.Start('cats.closeTicket')
                net.WriteString(t)
            net.Send(n(t))
            return
        end
    end

end

net.Receive('cats.getAdminList', function(a, t)
    if t.cats_cooldowns.getAdminList and t.cats_cooldowns.getAdminList > CurTime() then
        cats.config.notify(t, cats.lang.error_wait, NOTIFY_ERROR, 3)
        return
    end

    t.cats_cooldowns.getAdminList = CurTime() + .2

    if not cats.config.playerCanSeeTicket(t) then
        cats.config.notify(t, cats.lang.error_noAccess, NOTIFY_ERROR, 3)
        return
    end

    cats:Log('Sending admin list to ' .. tostring(t))

    cats:GetAdminList(steamID, function(a)
        if not IsValid(t) or not a then return end
        netstream.Heavy(t, 'cats.getAdminList', a)
    end)
end)

function cats:SavePlayer(a, c)
    local i = a:Name()
    local t = a.cats_adminData

    if t then
        t.playTimeTotal = a:GetUTimeTotalTime()
        local n = [[ SELECT SUM(ticketTime) AS ticketTimeTotal, COUNT(USER) AS claimsTotal, COUNT(DISTINCT USER) AS uniqueUsers, (SELECT AVG(avgPerUser) FROM ( SELECT AVG(rating) AS avgPerUser FROM cats_]] .. self.config.serverID .. [[_claims WHERE admin = ']] .. t.steamID .. [[' GROUP BY user ) AS avgs ) AS ratingTotal FROM cats_]] .. self.config.serverID .. [[_claims WHERE admin = ']] .. t.steamID .. [['; ]]

        self:Query(n, function(a)
            a = a and #a > 0 and a[1]

            if a then
                t.lastNick = i or "Unknown"
                t.lastPlayedTime = os.time() or 0
                t.playTimeTotal = tonumber(t.playTimeTotal) or 0
                t.ticketTimeTotal = tonumber(a.ticketTimeTotal) or 0
                t.ratingTotal = tonumber(a.ratingTotal) or 0
                t.claimsTotal = tonumber(a.claimsTotal) or 0
                t.uniqueUsers = tonumber(a.uniqueUsers) or 0
                t.timeCard = t.timeCard or table.Copy(e)
                t.claimCard = t.claimCard or table.Copy(e)
                t.updateTime = os.time() or 0
                local t = string.format([[ UPDATE cats_]] .. self.config.serverID .. [[_admins SET lastNick = %s, lastPlayedTime = %d, playTimeTotal = %d, ticketTimeTotal = %d, ratingTotal = %f, claimsTotal = %d, uniqueUsers = %d, timeCard = %s, claimCard = %s, updateTime = %d WHERE steamID = ']] .. t.steamID .. [['; ]], MySQLite.SQLStr(t.lastNick), t.lastPlayedTime, t.playTimeTotal, t.ticketTimeTotal, t.ratingTotal, t.claimsTotal, t.uniqueUsers, MySQLite.SQLStr(util.TableToJSON(t.timeCard)), MySQLite.SQLStr(util.TableToJSON(t.claimCard)), t.updateTime or 0)
                self:Query(t, c)
            else
                self.QueryError('No claim records on ' .. t.steamID, n)
            end
        end)
    end
end

function cats:GetAdminData(e, a)
    local t = player.GetBySteamID(e)

    if IsValid(t) then
        if t.cats_adminData and os.time() > (t.cats_adminData.updateTime or 0) + 60 then
            self:SavePlayer(t, function()
                if not IsValid(t) then return end
                a(t.cats_adminData)
            end)
        else
            a(t.cats_adminData)
        end
    else
        self:Query([[ SELECT * FROM cats_]] .. self.config.serverID .. [[_admins WHERE steamID = ]] .. MySQLite.SQLStr(e), function(t)
            t = t and #t > 0 and t[1]

            if t then
                t.timeCard = util.JSONToTable(t.timeCard)
                t.claimCard = util.JSONToTable(t.claimCard)
                a(t)
            else
                a()
            end
        end)
    end
end

net.Receive('cats.getAdminData', function(a, t)
    local a = net.ReadString()

    if t.cats_cooldowns.getAdminData and t.cats_cooldowns.getAdminData > CurTime() then
        cats.config.notify(t, cats.lang.error_wait, NOTIFY_ERROR, 3)

        return
    end

    t.cats_cooldowns.getAdminData = CurTime() + .5

    if not cats.config.playerCanSeeTicket(t) then
        cats.config.notify(t, cats.lang.error_noAccess, NOTIFY_ERROR, 3)

        return
    end

    cats:Log("Sending data of '" .. a .. "' to " .. tostring(t))

    cats:GetAdminData(a, function(a)
        if not IsValid(t) or not a then return end
        net.Start('cats.getAdminData')
        net.WriteTable(a)
        net.Send(t)
    end)
end)

hook.Add("PlayerSay", "cats", function(t, a)
    local a, e = cats.config.triggerText(t, a)

    if a then
        cats:DispatchMessage(t, t:SteamID(), e)

        return ''
    end
end)

hook.Add('PlayerInitialSpawn', 'cats-load-player', function(t)
    timer.Simple(5, function()
        if not IsValid(t) then return end
        t.cats_cooldowns = {}

        if cats.config.playerCanSeeTicket(t, "") then
            cats:Query([[ SELECT * FROM cats_]] .. cats.config.serverID .. [[_admins WHERE steamID = ]] .. MySQLite.SQLStr(t:SteamID()) .. [[; ]], function(a)
                if not IsValid(t) then return end
                a = a and #a > 0 and a[1]

                if a then
                    t.cats_adminData = a
                    t.cats_adminData.timeCard = t.cats_adminData.timeCard and util.JSONToTable(t.cats_adminData.timeCard) or table.Copy(e)
                    t.cats_adminData.claimCard = t.cats_adminData.claimCard and util.JSONToTable(t.cats_adminData.claimCard) or table.Copy(e)
                else
                    t.cats_adminData = {
                        steamID = t:SteamID(),
                        lastNick = t:Name(),
                        createdTime = os.time(),
                        playTimeTotal = t:GetUTimeTotalTime(),
                        lastPlayedTime = os.time(),
                        ticketTimeTotal = 0,
                        ratingTotal = 0,
                        claimsTotal = 0,
                        uniqueUsers = 0,
                        timeCard = table.Copy(e),
                        claimCard = table.Copy(e),
                        updateTime = os.time()
                    }

                    cats:Query(string.format([[ INSERT INTO cats_]] .. cats.config.serverID .. [[_admins(steamID, lastNick, createdTime, playTimeTotal, lastPlayedTime, ticketTimeTotal, ratingTotal, claimsTotal, uniqueUsers, timeCard, claimCard, updateTime) VALUES (%s, %s, %d, %d, %d, %d, %f, %d, %d, %s, %s, %d); ]], MySQLite.SQLStr(t.cats_adminData.steamID), MySQLite.SQLStr(t.cats_adminData.lastNick), t.cats_adminData.createdTime, t.cats_adminData.playTimeTotal, t.cats_adminData.lastPlayedTime, t.cats_adminData.ticketTimeTotal, t.cats_adminData.ratingTotal, t.cats_adminData.claimsTotal, t.cats_adminData.uniqueUsers, MySQLite.SQLStr(util.TableToJSON(t.cats_adminData.timeCard)), MySQLite.SQLStr(util.TableToJSON(t.cats_adminData.claimCard)), os.time()))
                end

                t:SetNWFloat("cats_adminRating", t.cats_adminData.ratingTotal)

                timer.Simple(20, function()
                    net.Start('cats.syncTickets')
                    net.WriteTable(cats.currentTickets)
                    net.Send(t)
                end)
            end)
        else
            cats:Query([[ DELETE FROM cats_]] .. cats.config.serverID .. [[_admins WHERE steamID = ]] .. MySQLite.SQLStr(t:SteamID()) .. [[;]])
        end

        local a = [[ SELECT COUNT(rating) AS ratingsTotal, AVG(rating) AS averageRating FROM cats_]] .. cats.config.serverID .. [[_claims WHERE user = ']] .. t:SteamID() .. [['; ]]

        cats:Query(a, function(a)
            a = a and #a > 0 and a[1]

            if a and IsValid(t) then
                t:SetNWInt("cats_ratingsTotal", tonumber(a.ratingsTotal) or 1)
                t:SetNWFloat("cats_averageRating", tonumber(a.averageRating) or 0)
            end
        end)
    end)
end)

hook.Add("PlayerDisconnected", "cats", function(a)
    cats:SavePlayer(a)

    for t, e in pairs(cats.currentTickets) do
        if t == a:SteamID() then
            net.Start('cats.closeTicket')
            net.WriteString(t)
            net.Send(n(t))

            if IsValid(e.admin) then
                cats.config.notify(e.admin, cats.lang.ticketUserLeft, NOTIFY_ERROR, 8)
            end

            cats.currentTickets[t] = nil
        elseif e.adminID == a:SteamID() then
            cats:ClaimTicket(t, a, false)
        end
    end
end)

hook.Add("DatabaseInitialized", "cats", function()
    local t = MySQLite.isMySQL() and "AUTO_INCREMENT" or "AUTOINCREMENT"
    cats:Query([[ CREATE TABLE IF NOT EXISTS cats_]] .. cats.config.serverID .. [[_admins( steamID VARCHAR(30) NOT NULL PRIMARY KEY, lastNick VARCHAR(255) NOT NULL, createdTime INTEGER(11) NOT NULL, lastPlayedTime INTEGER(11) NOT NULL, playTimeTotal INTEGER(11) NOT NULL, ticketTimeTotal INTEGER(8) NOT NULL, ratingTotal FLOAT NOT NULL, claimsTotal INTEGER NOT NULL, uniqueUsers INTEGER NOT NULL, timeCard TEXT NOT NULL, claimCard TEXT NOT NULL, updateTime INTEGER(11) NOT NULL ); ]])
    cats:Query([[ CREATE TABLE IF NOT EXISTS cats_]] .. cats.config.serverID .. [[_claims( id INTEGER NOT NULL PRIMARY KEY ]] .. t .. [[, user VARCHAR(30) NOT NULL, admin VARCHAR(30) NOT NULL, createdTime INTEGER(11) NOT NULL, ticketTime INTEGER(5) NOT NULL, rating FLOAT NOT NULL, FOREIGN KEY(admin) REFERENCES cats_]] .. cats.config.serverID .. [[_admins(steamID) ON DELETE CASCADE ); ]])
    cats:Query([[ CREATE TABLE IF NOT EXISTS cats_]] .. cats.config.serverID .. [[_summary( id INTEGER NOT NULL PRIMARY KEY ]] .. t .. [[, checkTime INTEGER(11) NOT NULL, adminsAmount INTEGER(4) NOT NULL, playersAmount INTEGER(4) NOT NULL, casesClaimedAmount INTEGER(4) NOT NULL, casesUnclaimedAmount INTEGER(4) NOT NULL ); ]])
end)

local t, a = 0, 0

hook.Add("Think", "cats.timeCard", function()
    if CurTime() < t then return end
    t = CurTime() + 1

    if os.time() >= a then
        a = os.time() + 600
        local t = os.date('*t', os.time())
        t.wday = t.wday - 1

        for e, a in pairs(player.GetAll()) do
            if a.cats_adminData and a.cats_adminData.timeCard then
                day = t.wday ~= 0 and t.wday or 7
                hour = t.hour ~= 0 and t.hour or 24
                a.cats_adminData.timeCard[day][hour] = a.cats_adminData.timeCard[day][hour] + 1
            end
        end

        cats:Log('TimeCard update.')
    end
end)
