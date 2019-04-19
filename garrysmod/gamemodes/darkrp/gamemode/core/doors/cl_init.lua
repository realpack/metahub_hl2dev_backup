local IsValid 		= IsValid
local ipairs 		= ipairs
local LocalPlayer 	= LocalPlayer
local Angle 		= Angle
local Vector 		= Vector

local ents_FindInSphere 		= ents.FindInSphere
local util_TraceLine 			= util.TraceLine
local draw_SimpleTextOutlined 	= draw.SimpleTextOutlined
local team_GetColor 			= team.GetColor
local team_GetName 				= team.GetName
local cam_Start3D2D 			= cam.Start3D2D
local cam_End3D2D 				= cam.End3D2D

local color_white 	= Color(255,255,245)
local color_black 	= Color(0,0,0)
local color_green 	= table.Copy(rp.col.Green)

local off_vec 		= Vector(0,0,17.5)
local off_ang 		= Angle(0,90,90)

local count
local DoorText 		= {}
local DoorCache 	= {}

local function AddText(tbl)
	DoorText[count + 1] = tbl
	count = count + 1
end

timer.Create('RefreshDoorCache', 0.4, 0, function()
	if IsValid(LocalPlayer()) then
		local count = 0
		DoorCache 	= {}
		for k, ent in ipairs(ents_FindInSphere(LocalPlayer():GetPos(), 350)) do
			if IsValid(ent) and ent:IsDoor() then
				count = count + 1
				DoorCache[count] = ent
			end
		end
	end
end)

hook.Add('PostDrawOpaqueRenderables', 'Doors_PostDrawOpaqueRenderables', function()
	for _, ent in ipairs(DoorCache) do
		if IsValid(ent) then
			count 		= 0
			DoorText 	= {}
			local dist 	= ent:GetPos():DistToSqr(LocalPlayer():GetPos())

			if ent:DoorIsOwnable() then
				AddText({color_white, 'Нажмите F2, чтобы купить', "font_base_84_normal"})
				AddText({rp.col.Red, rp.FormatMoney(LocalPlayer():Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax))})
			elseif not ent:DoorIsOwnable() then
				-- Title
				if (ent:DoorGetTitle() ~= nil) then
					AddText({color_white, ent:DoorGetTitle()})
				end
				-- Group Own
				if (ent:DoorGetGroup() ~= nil) then
					AddText({color_white, ent:DoorGetGroup()})
				end
				-- Team Own
				if (ent:DoorGetTeam() ~= nil) then
					AddText({team_GetColor(ent:DoorGetTeam()), team_GetName(ent:DoorGetTeam())})
				end
				-- Org own
				local owner = ent:DoorGetOwner()
				if ent:DoorOrgOwned() and IsValid(owner) then
					AddText({owner:GetOrgColor(), owner:GetOrg()})
				end
				-- Owner
				if IsValid(owner) then
					AddText({owner:GetJobColor(), owner:GetNetVar('Name'), "font_base_84_normal"})
				end
				-- Co-Owners
				if (ent:DoorGetCoOwners() ~= nil) then
					for k, co in ipairs(ent:DoorGetCoOwners()) do
						if IsValid(co) then
							AddText({co:GetJobColor(), co:GetNetVar('Name')})
						end
						if (k >= 4) then
							AddText({color_white,  ' и ' .. (#ent:DoorGetCoOwners() - 4) .. ' совладельцы:'})
							break
						end
					end
				end
			end

			-- Draw it
			local lw = ent:LocalToWorld(ent:OBBCenter()) + off_vec
			local tr = util_TraceLine({
				start = LocalPlayer():GetPos() + LocalPlayer():OBBCenter(),
				endpos = lw,
				filter = LocalPlayer()
			})

			if (tr.Entity == ent) and (lw:DistToSqr(tr.HitPos) < 65) then
				cam_Start3D2D(tr.HitPos + tr.HitNormal, tr.HitNormal:Angle() + off_ang, .030)
					local h = 0
					for k, v in ipairs(DoorText) do
						local a = (122500 - dist) / 350
						v[1].a 			= a
						color_black.a 	= a
						-- local _, th = draw_SimpleTextOutlined(v[2], '3d2d', 0, h, v[1], 1, 1, 3, color_black)
                        local font = v[3] or "3d2d"
                        surface.SetFont(font)
                        if v[2] then
                            local _, th = surface.GetTextSize(v[2])
                            draw.ShadowSimpleText(v[2], font, 0, h, v[1], 1, 0)
                            h = h + th + 10
                        end
					end
				cam_End3D2D()
			end
		end
	end
end)
