local adminMenu
local fr
local ent
local doorOptions = {
	{
		Name 	= 'Sell',
		DoClick = function()
            RunConsoleCommand('rp', 'selldoor')
			fr:Close()
		end,
	},
	{
		Name 	= 'Add Co-Owner',
		Check 	= function()
			return (#player.GetAll() > 1)
		end,
		DoClick = function()
			ui.PlayerReuqest(function(pl)
                RunConsoleCommand('rp', 'addcoowner', pl:SteamID())
			end)
		end,
	},
	{
		Name 	= 'Remove Co-Owner',
		Check 	= function()
			return (ent:DoorGetCoOwners() ~= nil) and (#ent:DoorGetCoOwners() > 0)
		end,
		DoClick = function()
			ui.PlayerReuqest(ent:DoorGetCoOwners(), function(pl)
                RunConsoleCommand('rp', 'removecoowner', pl:SteamID())
			end)
		end,
	},
	-- {
	-- 	Name 	= 'Toggle org ownership',
	-- 	Check 	= function()
	-- 		return (#player.GetAll() > 1) and (LocalPlayer():GetOrg() ~= nil)
	-- 	end,
	-- 	DoClick = function()
    --         RunConsoleCommand('rp', 'orgown')
	-- 	end,
	-- },
	{
		Name 	= 'Set Title',
		DoClick = function()
			Derma_StringRequest('Title', 'What do you want the title to be?', '', function(a)
                RunConsoleCommand('rp', 'settitle', tostring(a))
			end)
		end,
	},
	{
		Name 	= 'Admin options',
		Check 	= function()
			return LocalPlayer():IsSuperAdmin()
		end,
		DoClick = function(self)
			fr:Close()
			adminMenu()
		end,
	},
}

local function keysMenu()
	if IsValid(fr) then fr:Close() end
	ent = LocalPlayer():GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(LocalPlayer()) and (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 13225) then
		fr = vgui.Create('DFrame')
        fr:SetTitle('Door Options')
        fr:Center()
        fr:MakePopup()
        fr.Think = function(self)
            ent = LocalPlayer():GetEyeTrace().Entity
            if not IsValid(ent) or (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 13225) then
                fr:Close()
            end
        end

		local count = -1
		local x, y = 5, 25
		for k, v in ipairs(doorOptions) do
			if (v.Check == nil) or (v.Check(ent) == true) then
				count = count + 1
				fr:SetSize(ScrW() * .125, ((count + 1) * 29) + (y + 7))
				fr:Center()
                local bt = vgui.Create('DButton', fr)
                bt:SetPos(x, (count * 29) + y)
                bt:SetSize(ScrW() * .125 - 10, 30)
                bt:SetText(v.Name)
                bt.DoClick = v.DoClick
			end
		end
	elseif IsValid(ent) and ent:IsDoor() and (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 13225) and ent:DoorIsOwnable() then
		-- rp.RunCommand('buydoor')
        RunConsoleCommand('rp', 'buydoor')
	elseif LocalPlayer():IsSuperAdmin() and IsValid(ent) and ent:IsDoor() and (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) < 13225) and not ent:DoorIsOwnable() then
		adminMenu()
	end
end
net('rp.keysMenu', keysMenu)
GM.ShowTeam = keysMenu


//
// Admin Menu
//
local adminOptions = {
	{
		Name 	= 'Toggle Ownable',
		DoClick = function()
			-- rp.RunCommand('setownable')
            RunConsoleCommand('rp', 'setownable', k)
		end,
	},
	{
		Name 	= 'Toggle Locked',
		DoClick = function()
			-- rp.RunCommand('setlocked')
            RunConsoleCommand('rp', 'setlocked', k)
		end,
	},
	{
		Name 	= 'Set Team Own',
		DoClick = function()
			local m = DermaMenu()
			for k, v in ipairs(rp.teams) do
				m:AddOption(v.name, function()
					-- rp.RunCommand('setteamown', k)
                    RunConsoleCommand('rp', 'setteamown', k)
				end)
			end
			m:Open()
		end,
	},
	{
		Name 	= 'Set Group Own',
		DoClick = function()
			local m = DermaMenu()
			for k, v in pairs(rp.teamDoors) do
				m:AddOption(k, function()
					-- rp.RunCommand('setgroupown', k)
                    RunConsoleCommand('rp', 'setgroupown', k)
				end)
			end
			m:Open()
		end,
	},
}

function adminMenu()
	if IsValid(fr) then fr:Close() end
	fr = vgui.Create('DFrame')
    fr:SetTitle('Admin Door Options')
    fr:Center()
    fr:MakePopup()
    fr.Think = function(self)
        ent = LocalPlayer():GetEyeTrace().Entity
        if not IsValid(ent) or (ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 13225) then
            fr:Close()
        end
    end

	local count = -1
	local x, y = 5, 25
	for k, v in ipairs(adminOptions) do
		count = count + 1
		fr:SetSize(ScrW() * .125, ((count + 1) * 29) + (y + 7))
		fr:Center()

        bt = vgui.Create('DButton', fr)
        bt:SetPos(x, (count * 29) + y)
        bt:SetSize(ScrW() * .125 - 10, 30)
        bt:SetText(v.Name)
        bt.DoClick = v.DoClick
	end
end
concommand.Add('rp_dooradmin',adminMenu)
