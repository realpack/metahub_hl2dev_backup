/*----------------------------------------------------------------------
Leak by Famouse

Play good games ↓
http://store.steampowered.com/curator/32364216

Subscribe to the channel ↓
www.youtube.com/c/Famouse

More leaks in the discord ↓
https://discord.gg/rFdQwzm
------------------------------------------------------------------------*/
timer.Simple( 1, function()
	for _, door in pairs(ents.GetAll()) do
		if (door:GetClass() == "prop_door_rotating" and IsValid(door) ) then
			door:SetMaxHealth(sfdo.config.dmg)
			door:SetHealth(sfdo.config.dmg)
		end
	end
end )
local function isOwnable( door )
	if door.getKeysNonOwnable then
		return door:getKeysNonOwnable() != true
	end
end

local broken = {}

hook.Add("EntityTakeDamage","Ebanue Dvery", function(prop, dmginfo)
	if (prop:GetClass() == "prop_door_rotating" and IsValid(prop) )then

		prop:SetHealth(prop:Health() - dmginfo:GetDamage())
		prop:EmitSound("physics/wood/wood_crate_break"..math.random(1, 5)..".wav", 60)
		if sfdo.config.dbug then
			MsgC(Color(0,255,0), "Dver polychila ".. dmginfo:GetDamage() .. " yrona.\n")
		end

		if prop:Health() <= 0 and (!prop.phys_door or !IsValid(prop.phys_door)) then
			prop:Fire("unlock", 0)
			prop:Fire("open", 0)
			prop:EmitSound("physics/wood/wood_plank_break"..math.random(1, 4)..".wav", 100, 120)

			local vd = prop
			if (!table.HasValue( broken, vd )) then
				table.insert(broken, vd)
				if sfdo.config.dbug then
					MsgC(Color(0,255,0), "Dver otrita, taimer(".. sfdo.config.respawnHPTime .." sec.) sozdan.\n")
				end
				timer.Simple( sfdo.config.respawnHPTime, function()
					vd:SetHealth(sfdo.config.dmg)
					table.RemoveByValue( broken, vd )
					if sfdo.config.dbug then
						MsgC(Color(0,255,0), "Taimer v ".. sfdo.config.respawnHPTime .. " sec. bil zakonchen, dver vostonovlenna !\n")
					end
				end )
			else
				prop:Fire("unlock", 0)
				prop:Fire("open", 0)
				if sfdo.config.dbug then
					MsgC(Color(0,255,0), "Eta dver yshe slomana!\n")
				end
			end
		end
	end
end)
/*------------------------------------------------------------------------
Donation for leaks

Qiwi Wallet         4890494419811120
YandexMoney         410013095053302
WebMoney(WMR)       R235985364414
WebMoney(WMZ)       Z309855690994
------------------------------------------------------------------------*/
