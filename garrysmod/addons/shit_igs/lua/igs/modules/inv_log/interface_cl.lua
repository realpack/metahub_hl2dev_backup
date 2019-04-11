local actions = setmetatable({},{__index = function() return "Ошибка" end})
actions[1] = "Покупка"
actions[2] = "Активация"
actions[3] = "Дроп"
actions[4] = "Пик"

local function BeautyS64(s64)
	local pl = player.GetBySteamID64(s64)
	return pl and pl:Nick() or util.SteamIDFrom64(s64):sub(#"STEAM_0")
end

local function IsSteamID32(s)
	return s:match("^STEAM_%d:%d:%d+$")
end

local function IsSteamID64(s)
	return #s == 17 and s:StartWith("7656")
end

function IGS.WIN.InvLog()
	return ui.Create("iFrame",function(bg)
		bg:SetTitle("Операции с инвентарем")
		bg:SetSize(800, 600)
		bg:Center()
		bg:MakePopup()

		bg.page  = 1
		bg.sid   = nil -- будет s64, если использовался поиск

		function bg:LoadPage(iPage)
			bg.page = iPage
			bg:Search()
		end

		function bg:SearchSteamID(s64_s32)
			local s64
			if IsSteamID64(s64_s32) then
				s64 = s64_s32
			elseif IsSteamID32(s64_s32) then
				s64 = util.SteamIDTo64(s64_s32)
			end

			assert(s64,"Invalid SteamID format")

			bg.page = 1
			bg.sid = s64
			bg.table:Clear()
			bg:Search()
		end

		function bg:ResetSearch()
			bg.sid  = nil
			bg.page = 1
			bg.table:Clear()
			bg:Search()
		end

		function bg:Search()
			IGS.IL.GetLog(function(tLog)
				if !IsValid(bg) then return end -- Долго данные получались

				for _,r in ipairs(tLog) do
					local ITEM = IGS.GetItemByUID(r.gift_uid)

					local sDate   = IGS.TimestampToDate(r.date, true)
					local sAction = actions[r.action]
					local sItem   = ITEM.isnull and (r.gift_uid .. " (NULL)") or ITEM:Name()

					local sOwner = BeautyS64(r.owner)
					local sInfli = BeautyS64(r.inflictor)

					local line = bg.table:AddLine(sOwner, sInfli, sItem, r.gift_id, sAction, sDate)
					line:SetTooltip("ID операции: " .. r.action_id)
					for _,v in ipairs(line.columns) do
						v:SetCursor("hand")
					end

					line.DoClick = function()
						local m = DermaMenu(line)
						m:AddOption("Copy owner SID",function() SetClipboardText(r.owner) end)
						m:AddOption("Copy actor SID",function() SetClipboardText(r.inflictor) end)
						m:AddOption("Player actions",function() bg:SearchSteamID(r.owner) end)
						m:Open()
					end
				end

				bg.table:PerformLayout()
				bg.load:UpdateLoaded(#bg.table.lines, tLog[0])
			end, bg.page, bg.sid)
		end

		bg.table = ui.Create("ui_table",bg,function(pnl)
			pnl:Dock(FILL)
			pnl:DockMargin(5,5,5,5)
			-- pnl:SetSize(790, 565)

			pnl:SetTitle("Действия")

			pnl:AddColumn("Владелец",100)
			pnl:AddColumn("Исполнитель",100)
			pnl:AddColumn("Предмет")
			pnl:AddColumn("ID гифта", 60)
			pnl:AddColumn("Действие",110)
			pnl:AddColumn("Дата",130)
		end)

		local bottom = ui.Create("Panel", function(self)
			self:SetHeight(30)
			self:Dock(BOTTOM)
			self:DockMargin(5,0,5,5)
		end, bg)

		local entry = ui.Create("DTextEntry", function(self, p)
			self:Dock(LEFT)
			self:SetWide(200)
			self:SetValue("SteamID")
			self.OnEnter = function(s)
				local val = self:GetValue():Trim()
				if val == "" then
					bg:ResetSearch()
				else
					bg:SearchSteamID(val)
				end
			end
		end, bottom)

		ui.Create("iButton", function(self)
			self:Dock(LEFT)
			self:SetWide(150)
			self:DockMargin(5,0,0,0)
			self:SetText("Найти")
			self.DoClick = entry.OnEnter
		end, bottom)

		bg.load = ui.Create("iButton", function(self)
			self:Dock(RIGHT)
			self:SetWide(200)
			self.DoClick = function()
				-- bg.table:Clear()
				bg:LoadPage(bg.page + 1)
			end
			self.UpdateLoaded = function(_, iLoaded, iTotal)
				if iLoaded == iTotal then
					self:SetText("Все загружено (" .. iTotal .. ")")
					self:SetActive(false)
				else
					self:SetText("Загрузить еще (" .. iLoaded .. "/" .. iTotal .. ")")
					self:SetActive(true)
				end
			end
		end, bottom)

		bg:Search()
		bg.load:UpdateLoaded(0, 0)
	end)
end

concommand.Add("igs_invlog",IGS.WIN.InvLog)

-- for i = 1,1 do
	-- local fr = IGS.WIN.InvLog()
-- 	-- timer.Simple(10,function()
-- 	-- 	if IsValid(fr) then
-- 	-- 		fr:Remove()
-- 	-- 	end
-- 	-- end)
-- end