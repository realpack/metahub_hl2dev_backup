
-----------------------------------------------------
rp.pp = rp.pp or {}

--
-- Hooks
--
hook('CanTool', 'pp.CanTool', function(pl, trace, tool)
	local ent = trace.Entity

	return (IsValid(ent) and (ent:GetNetVar('PropIsOwned') == true))
end)

hook('PhysgunPickup', 'pp.PhysgunPickup', function(pl, ent) return false end)

function GM:GravGunPunt(pl, ent)
	return pl:IsSuperAdmin()
end

--
-- Spawnlist
--
http.Fetch(rp.cfg.whitelistHandler, function(body)
	local spawnlist = {}
	spawnlist.name = 'Разрешённые пропы'
	spawnlist.id = math.random(1000, 9999)
	spawnlist.icon = 'icon16/package.png'
	spawnlist.parentid = 0
	spawnlist.version = 3
	spawnlist.contents = {}

	for k, v in ipairs(util.JSONToTable(body)) do
		if (mdl ~= '') then
			spawnlist.contents[#spawnlist.contents + 1] = {
				type = 'model',
				model = v.Model
			}
		end
	end

	spawnmenu.AddPropCategory('', spawnlist.name, spawnlist.contents, spawnlist.icon, spawnlist.id, 0)
end)

--
-- Menus
--
local ranks = {
	[0] = 'user',
	[1] = 'VIP',
	[2] = 'Admin',
	[3] = 'Globaladmin'
}

function rp.pp.ToolEditor()
	local tools = net.ReadTable()

	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(500, 400)
		self:SetTitle('Tool editor')
		self:Center()
		self:MakePopup()
	end)

	local targ

	local list = ui.Create('DListView', function(self, p) -- TODO: FIX
		self:SetPos(5, 30)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 65)
		self:SetMultiSelect(false)
		self:AddColumn('Tool')
		self:AddColumn('Rank')

		self.OnRowSelected = function(parent, line)
			targ = self:GetLine(line):GetColumnText(1)
		end

		for a, b in ipairs(spawnmenu.GetTools()) do
			for c, d in ipairs(spawnmenu.GetTools()[a].Items) do
				for e, f in ipairs(spawnmenu.GetTools()[a].Items[c]) do
					if (type(f) == 'table') and string.find(f.Command, 'gmod_tool') then
						self:AddLine(f.ItemName, tools[f.ItemName] and ranks[tools[f.ItemName]] or 'user')
					end
				end
			end
		end
	end, fr)

	for i = 1, 4 do
		ui.Create('DButton', function(self, p)
			self:SetSize(p:GetWide() / 4 - 6, 25)
			self:SetPos((i - 1) * (p:GetWide() / 4 - 6) + (5 * i), p:GetTall() - 30)
			self:SetText(ranks[i - 1])

			self.DoClick = function()
				rp.RunCommand('settoolgroup', targ, (i - 1))
			end
		end, fr)
	end
end

net('rp.toolEditor', rp.pp.ToolEditor)

-- function rp.pp.SharePropMenu()
-- 	local fr = ui.Create('ui_frame', function(self)
-- 		self:SetSize(500, 400)
-- 		self:SetTitle('Share Props')
-- 		self:Center()
-- 		self:MakePopup()
-- 	end)

-- 	local targ

-- 	local list = ui.Create('DListView', function(self, p)
-- 		self:SetPos(5, 30)
-- 		self:SetSize(250 - 5, p:GetTall() - 65)
-- 		self:SetMultiSelect(false)
-- 		self:AddColumn('Player')

-- 		self.OnRowSelected = function(parent, line)
-- 			targ = self:GetLine(line):GetColumnText(1)
-- 		end

-- 		for k, v in ipairs(player.GetAll()) do
-- 			if (v == LocalPlayer()) then continue end
-- 			self:AddLine(v:Name())
-- 		end
-- 	end, fr)

-- 	ui.Create('DButton', function(self, p)
-- 		self:SetSize(250 - 5, 25)
-- 		self:SetPos(5, p:GetTall() - 30)
-- 		self:SetText('Share')

-- 		self.DoClick = function()
-- 			rp.RunCommand('shareprops', targ)
-- 		end
-- 	end, fr)

-- 	local targ

-- 	local list = ui.Create('DListView', function(self, p)
-- 		self:SetPos(252.5, 30)
-- 		self:SetSize(250 - 5, p:GetTall() - 65)
-- 		self:SetMultiSelect(false)
-- 		self:AddColumn('Player')

-- 		self.OnRowSelected = function(parent, line)
-- 			targ = self:GetLine(line):GetColumnText(1)
-- 		end

-- 		for k, v in pairs(LocalPlayer():GetNetVar('ShareProps') or {}) do
-- 			self:AddLine(k:Name())
-- 		end
-- 	end, fr)

-- 	ui.Create('DButton', function(self, p)
-- 		self:SetSize(250 - 5, 25)
-- 		self:SetPos(252.5, p:GetTall() - 30)
-- 		self:SetText('Unshare')

-- 		self.DoClick = function()
-- 			rp.RunCommand('shareprops', targ)
-- 		end
-- 	end, fr)
-- end

--
-- Context menus
--
properties.Add('ppWhitelist', {
	MenuLabel = 'Add/Remove from whitelist',
	Order = 2001,
	MenuIcon = 'icon16/arrow_refresh.png',
	Filter = function(self, ent, pl)
		if not IsValid(ent) or ent:IsPlayer() then return false end

		return pl:IsSuperAdmin()
	end,
	Action = function(self, ent)
		if not IsValid(ent) then return end
		rp.RunCommand('whitelist', ent:GetModel())
	end
})

properties.Add('ppShareProp', {
	MenuLabel = 'Share props',
	Order = 2002,
	MenuIcon = 'icon16/user.png',
	Filter = function(self, ent, pl)
		if not IsValid(ent) or ent:IsPlayer() then return false end

		return true
	end,
	Action = function(self, ent)
		rp.pp.SharePropMenu()
	end
})

local PANEL = {}

function PANEL:Init()
    self.PanelList = vgui.Create("DPanelList", self)
    self.PanelList:SetPadding(4)
    self.PanelList:SetSpacing(2)
    self.PanelList:EnableVerticalScrollbar(true)
    self:BuildList()
end

local function AddComma(n)
    local sn = tostring(n)
    sn = string.ToTable(sn)
    local tab = {}

    for i = 0, #sn - 1 do
        if i % 3 == #sn % 3 and not (i == 0) then
            table.insert(tab, ",")
        end

        table.insert(tab, sn[i + 1])
    end

    return string.Implode("", tab)
end

function PANEL:BuildList()
    self.PanelList:Clear()

    local Scroll = vgui.Create( "DScrollPanel", self ) -- Create the Scroll panel
    Scroll:Dock( FILL )

    local Content = vgui.Create("DIconLayout", Scroll)
    -- Content:EnableHorizontal(true)
    Content:SetDrawBackground(false)
    Content:Dock( FILL )
    Content:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
    Content:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5

    -- Content:SetSpacing(2)
    -- Content:SetPadding(2)
    -- Content:SetAutoSize(true)
    number = 1

    -- PrintTable(nw.GetGlobal('Whitelist'))
    for model, _ in pairs(nw.GetGlobal('Whitelist')) do

        local Icon = vgui.Create("SpawnIcon", self)

        Icon:SetModel(model)
        Icon.DoClick = function()
            RunConsoleCommand("gm_spawn", model)
        end

        local lable = vgui.Create("DLabel", Icon)
        lable:SetFont("DebugFixedSmall")
        lable:SetTextColor(color_black)
        lable:SetText(model)
        lable:SetContentAlignment(5)
        lable:SetWide(self:GetWide())
        lable:AlignBottom(-42)
        Content:Add(Icon)
        number = number + 1
    end
    -- Content:SetSize(self:GetWide(), self:GetTall())

    self.PanelList:InvalidateLayout()
end

function PANEL:PerformLayout()
    self.PanelList:StretchToParent(0, 0, 0, 0)
end

local CreationSheet = vgui.RegisterTable(PANEL, "Panel")

local function CreateContentPanel()
    local ctrl = vgui.CreateFromTable(CreationSheet)

    return ctrl
end

local function RemoveSandboxTabs()
    local AccsesGroup = {
        ["founder"] = true,
        ["serverstaff"] = true,
        ["moderator"] = true,
    }
    local tabstoremove = {
            language.GetPhrase("spawnmenu.content_tab"),
            language.GetPhrase("spawnmenu.category.npcs"),
            language.GetPhrase("spawnmenu.category.entities"),
            language.GetPhrase("spawnmenu.category.weapons"),
            language.GetPhrase("spawnmenu.category.vehicles"),
            language.GetPhrase("spawnmenu.category.postprocess"),
            language.GetPhrase("spawnmenu.category.dupes"),
            language.GetPhrase("spawnmenu.category.saves"),
            'pill',
            'Pills',
            'simfphys'
    }

    if not AccsesGroup[LocalPlayer():GetUserGroup()] then
        for k, v in pairs(g_SpawnMenu.CreateMenu.Items) do
            if table.HasValue(tabstoremove, v.Tab:GetText()) then
                g_SpawnMenu.CreateMenu:CloseTab(v.Tab, true)
                RemoveSandboxTabs()
            end
        end
    end
end


hook.Add("SpawnMenuOpen", "blockmenutabs", RemoveSandboxTabs)

local function BunkMenu()
    return
end

spawnmenu.AddCreationTab("Разрешенные пропы", CreateContentPanel, "icon16/application_view_tile.png", 4)
