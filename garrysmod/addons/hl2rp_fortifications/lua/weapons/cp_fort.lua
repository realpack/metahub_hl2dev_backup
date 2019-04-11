// Fortifications Builder Tablet by Alydus
// If you'd like to modify this, go ahead, but please leave credit, thank you!

AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Создание Укрытий"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false

	surface.CreateFont("Alydus.FortificationsTablet.Title", {font = "Roboto Condensed", size = 50})
	surface.CreateFont("Alydus.FortificationsTablet.Subtitle", {font = "Roboto Condensed", size = 35})
end

SWEP.Author = "Alydus"
SWEP.Instructions = "A utility weapon that allows the user to build fortifications."
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.WorldModel = ""
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Category = "Контент CWRP"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 3.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Delay = 3.5

SWEP.HoldType = "slam"
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.UseHands = false
SWEP.ViewModel = "models/weapons/v_grenade.mdl"
SWEP.WorldModel = ""
SWEP.ShowViewModel = true
SWEP.ShowWorldModel = true
SWEP.ViewModelBoneMods = {
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.IronSightsPos = Vector(12.72, 0, 0.36)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.Fortifications = {
	{name = "Специальное Укрытие 1", model = "models/props_combine/combine_barricade_med02c.mdl"},
	{name = "Специальное Укрытие 2", model = "models/props_combine/combine_booth_short01a.mdl"},
	{name = "Специальное Укрытие 3", model = "models/props_combine/combine_barricade_med01a.mdl"},
	{name = "Бетонная стена", model = "models/props_fortifications/concrete_wall001_96_reference.mdl"},
	{name = "Бетонная стена 1", model = "models/props_fortifications/concrete_barrier01.mdl"},
	{name = "Бетонная стена 3", model = "models/props_fortifications/concrete_block001_128_reference.mdl"},
	{name = "Малый Забор", model = "models/props_c17/fence01b.mdl"},
	{name = "Средний Забор", model = "models/props_c17/fence01a.mdl"},
	{name = "Большой Забор", model = "models/props_c17/fence03a.mdl"},
}

hook.Add("Alydus.FortificationBuilderTablet.AddFortification", "cp_fort_AddFortificationHook", function(fortification)
	if fortification["name"] and fortification["model"] then
		table.insert(SWEP.Fortifications, fortification)
	else
		print("Invalid fortification data, failed to add fortification. Please include name, and model.")
	end
end)

SWEP.FortificationsModelList = {}


for _, fortification in pairs(SWEP.Fortifications) do
	util.PrecacheModel(fortification["model"])
	table.insert(SWEP.FortificationsModelList, fortification["model"])
end


SWEP.VElements = {
	["tablet"] = { type = "Model", model = "models/nirrti/tablet/tablet_sfm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.714, 5.714, -3.636), angle = Angle(15.194, 118.052, -127.403), size = Vector(0.95, 0.95, 0.95), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}

SWEP.WElements = {
	["tablet"] = { type = "Model", model = "models/nirrti/tablet/tablet_sfm.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.513, 5.714, -2.597), angle = Angle(26.882, 113.376, -127.403), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} },
	["light"] = { type = "Sprite", sprite = "sprites/blueglow1", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1, -2.398), size = { x = 1.729, y = 1.729 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}

if SERVER then
	hook.Add("KeyPress", "Alydus_KeyPress_HandleBuildTabletHologramFinished", function(ply, key)
		if key == IN_USE and IsValid(ply) and ply:Alive() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "cp_fort" and ply:GetActiveWeapon().fortificationSelection then
			if (ply:GetEyeTrace().Entity and ply:GetEyeTrace().Entity:IsPlayer()) or ply:Crouching() or (IsValid(ply:GetEyeTrace().Entity) and table.HasValue(ply:GetActiveWeapon().FortificationsModelList, ply:GetEyeTrace().Entity:GetModel())) or hook.Call("Alydus.FortificationBuilderTablet.CanBuildFortification", ply) or (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "cp_fort" and ply:GetActiveWeapon():GetNWBool("tabletBootup", false) == true) then
				ply:ChatPrint("Failed to deploy fortification.")
			else
				local fortification = ents.Create("prop_physics")
				fortification:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
				fortification:SetPos(ply:GetEyeTrace().HitPos - ply:GetEyeTrace().HitNormal * ply.fortificationHologram:OBBMins().z)
				fortification:SetModel(ply:GetActiveWeapon().Fortifications[ply:GetActiveWeapon().fortificationSelection]["model"])
				fortification:Spawn()
				fortification:SetGravity(150)
				fortification.isPlayerPlacedFortification = ply

				fortification:EmitSound("physics/concrete/rock_impact_hard" .. math.random(1, 6) .. ".wav")

				local phys = fortification:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetMass(50000)
					phys:EnableMotion(false)
				end

				if table.HasValue({"sandbox", "darkrp", "starwarsrp"}, engine.ActiveGamemode()) then
					undo.Create("Укрытие (" .. ply:GetActiveWeapon().Fortifications[ply:GetActiveWeapon().fortificationSelection]["name"] .. ")")
						undo.AddEntity(fortification)
						undo.SetPlayer(ply)
					undo.Finish()
				end
			end
		end
	end)

	hook.Add("PlayerSwitchWeapon", "Alydus_PlayerSwitchWeapon_FortificationBuilderTabletBootup", function(ply, oldWep, newWep)
		if newWep:GetClass() == "cp_fort" and newWep:GetNWBool("tabletBootup", false) != true then
			newWep:SetNWBool("tabletBootup", true)
			newWep.fortificationSelection = newWep.fortificationSelection or 1
			ply:EmitSound("ambient/machines/thumper_startup1.wav")
			timer.Simple(2.5, function()
				if ply:GetNWBool("tabletBootup", false) == false and ply:HasWeapon("cp_fort") then
					ply:EmitSound("npc/scanner/combat_scan4.wav")
					newWep:SetNWBool("tabletBootup", false)
				end
			end)
		elseif ply:HasWeapon("cp_fort") and IsValid(oldWep) and oldWep:GetClass() == "cp_fort" then
			ply:EmitSound("npc/roller/mine/combine_mine_deactivate1.wav")

			if ply.fortificationHologram != nil and IsValid(ply.fortificationHologram) then
				ply.fortificationHologram:Remove()
				ply.fortificationHologram = nil
			end
		end
	end)
	hook.Add("PlayerTick", "Alydus_Think_FortificationBuilderTabletHologram", function(ply, mv)
		local wep = ply:GetActiveWeapon()
		local ang = ply:GetAngles()
		local tr = ply:GetEyeTrace()

		if IsValid(ply) and ply:Alive() and ply:HasWeapon("cp_fort") and IsValid(wep) and wep:GetClass() == "cp_fort" and wep:GetNWBool("tabletBootup", false) == false and wep.fortificationSelection != nil then
			if not IsValid(ply.fortificationHologram) then
				ply.fortificationHologram = ents.Create("prop_physics")
				if IsValid(ply.fortificationHologram) then
					ply.fortificationHologram:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
					ply.fortificationHologram:SetPos(tr.HitPos - tr.HitNormal * ply.fortificationHologram:OBBMins().z)
					ply.fortificationHologram:SetColor(Color(46, 204, 113, 150))
					ply.fortificationHologram:SetModel(wep.Fortifications[wep.fortificationSelection]["model"])
					ply.fortificationHologram:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
					ply.fortificationHologram:SetRenderMode(RENDERMODE_TRANSALPHA)
					ply.fortificationHologram:Spawn()
					ply.fortificationHologram:SetNWString("alydusFortificationHologramName", wep.Fortifications[wep.fortificationSelection]["name"])
					ply.fortificationHologram:EmitSound("physics/concrete/rock_impact_hard1.wav")
				else
					ply.fortificationHologram = nil
				end
			elseif IsValid(ply.fortificationHologram) then
				if ply:Crouching() or ply:GetVelocity():Length() > 15 or (IsValid(tr.Entity) and table.HasValue(wep.FortificationsModelList, tr.Entity:GetModel())) then
					ply.fortificationHologram:SetColor(Color(255, 255, 255, 0))
				else
					if ply.fortificationHologram:GetModel() != wep.Fortifications[wep.fortificationSelection]["model"] then
						ply.fortificationHologram:SetModel(wep.Fortifications[wep.fortificationSelection]["model"])
						ply.fortificationHologram:SetNWString("alydusFortificationHologramName", wep.Fortifications[wep.fortificationSelection]["name"])
					end
					ply.fortificationHologram:SetPos(tr.HitPos - tr.HitNormal * ply.fortificationHologram:OBBMins().z)
					ply.fortificationHologram:SetAngles(Angle(0, ply:EyeAngles().y - 180, 0))
					if tr.HitPos:Distance(ply:GetPos()) >= 250 then
						ply.fortificationHologram:SetColor(Color(255, 255, 255, 0))
					elseif ply.fortificationHologram:GetColor().a == 0 then
						ply.fortificationHologram:SetColor(Color(46, 204, 113, 150))
					end
				end
			end
		elseif ply.fortificationHologram != nil and IsValid(ply.fortificationHologram) then
			ply.fortificationHologram:Remove()
			ply.fortificationHologram = nil
		end
	end)
else
	hook.Add("PostDrawTranslucentRenderables","Lobby_PostDrawOpaqueRenderables_EntityDisplays", function()
		local ply = LocalPlayer()

		-- Selected Fortification Display
		if IsValid(ply) and ply:Alive() and not ply:Crouching() and ply:GetVelocity():Length() < 25 then
			for _, v in pairs(ents.GetAll()) do
				if IsValid(v) and v:GetPos():Distance(LocalPlayer():GetPos()) <= 250 then
					if v:GetClass() == "prop_physics" and v:GetNWString("alydusFortificationHologramName", false) != false then
						local offset = Vector(0, 0, 50)
						local ang = LocalPlayer():EyeAngles()
						local pos = v:GetPos() + offset + ang:Up()

						ang:RotateAroundAxis(ang:Forward(), 90)
						ang:RotateAroundAxis(ang:Right(), 90)

						local fade = math.abs(math.sin(CurTime() * 3))

						cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.10)
							draw.DrawText("Выбор Фортификаций", "Alydus.FortificationsTablet.Title", 0, 0, Color(255, 255, 255), TEXT_ALIGN_CENTER)
							draw.DrawText(v:GetNWString("alydusFortificationHologramName", "Unknown Fortification"), "Alydus.FortificationsTablet.Subtitle", 0, 60, Color(150, 150, 150), TEXT_ALIGN_CENTER)
						cam.End3D2D()
					end
				end
			end
		end
	end)
end

function SWEP:PrimaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		if IsValid(ply) and ply:Alive() and IsValid(ply.fortificationHologram) and self.fortificationSelection != nil and not ply:Crouching() and ply:GetVelocity():Length() < 25 then
			if ply:GetEyeTrace().HitPos:Distance(ply:GetPos()) >= 250 then
				ply:SendLua("surface.PlaySound(\"common/warning.wav\")")
				return
			end
			if self.Fortifications[self.fortificationSelection + 1] then
				self.fortificationSelection = self.fortificationSelection + 1
			else
				self.fortificationSelection = 1
			end
			ply.fortificationHologram:EmitSound("physics/concrete/rock_impact_hard1.wav")
		end
	end
end

function SWEP:SecondaryAttack()
	if SERVER then
		local ply = self:GetOwner()
		if IsValid(ply) and ply:Alive() and IsValid(ply.fortificationHologram) and self.fortificationSelection != nil and not ply:Crouching() and ply:GetVelocity():Length() < 25 then
			if ply:GetEyeTrace().HitPos:Distance(ply:GetPos()) >= 250 then
				ply:SendLua("surface.PlaySound(\"common/warning.wav\")")
				return
			end
			if self.Fortifications[self.fortificationSelection - 1] then
				self.fortificationSelection = self.fortificationSelection - 1
			else
				self.fortificationSelection = table.Count(self.Fortifications)
			end
			ply.fortificationHologram:EmitSound("physics/concrete/rock_impact_hard3.wav")
		end
	end
end

function SWEP:Reload()
	if SERVER then
		local ply = self:GetOwner()
		if not self.Owner:KeyPressed(IN_RELOAD) then 
			return
		end
		if IsValid(ply) and ply:Alive() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "cp_fort" and ply:GetActiveWeapon().fortificationSelection then
			if ply:GetEyeTrace().Entity.isPlayerPlacedFortification == ply then
				ply:GetEyeTrace().Entity:EmitSound("physics/concrete/rock_impact_hard" .. math.random(1, 6) .. ".wav")
				ply:GetEyeTrace().Entity:Remove()
			end
		end
		return
	end
end

if CLIENT then
	language.Add("#Убрана Фортификация", "Убрана Фортификация")

	local wrenchMat = Material("alydus/icons/wrench.png")
	local nextMat = Material("alydus/icons/next.png")
	local lastMat = Material("alydus/icons/last.png")
	local shieldMat = Material("alydus/icons/shield.png")
	local refreshMat = Material("alydus/icons/refresh.png")

	local useBind = string.upper(input.LookupBinding("+use")) or "E"
	local reloadBind = string.upper(input.LookupBinding("+reload")) or "R"

	function SWEP:PostDrawViewModel(vm, wep, ply)
		if IsValid(vm) then
			local atch = vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Hand"))
			local pos, ang = vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Hand")), vm:GetBoneMatrix(vm:LookupBone("ValveBiped.Bip01_R_Hand")):GetAngles()
			ang:RotateAroundAxis(ang:Right(), 90)
			
			cam.Start3D2D(pos - ang:Right() * 3 - ang:Forward() * 8.25 + ang:Right() * 7.4, Angle(0, ply:EyeAngles().y, ang.z) + Angle(180, 90, 160), 0.01)
				surface.SetDrawColor(255, 255, 255, 255)
				if self:GetNWBool("tabletBootup", false) == false then
					draw.SimpleText("Создание Укрытий", "Alydus.FortificationsTablet.Title", 15, 0, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					surface.SetMaterial(nextMat)
					surface.DrawTexturedRect(230, 42, 40, 40)
					surface.SetMaterial(lastMat)
					surface.DrawTexturedRect(-235, 38, 40, 40)

					draw.SimpleText("ЛКМ: Назад | ПКМ Вперёд", "Alydus.FortificationsTablet.Subtitle", 15, 60, Color(150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					surface.SetMaterial(wrenchMat)
					surface.DrawTexturedRect(-215, 98, 40, 40)

					draw.SimpleText("    [" .. useBind .. "]: Создать | [" .. reloadBind .. "]: Убрать", "Alydus.FortificationsTablet.Subtitle", 15, 120, Color(150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					surface.SetMaterial(shieldMat)
					surface.DrawTexturedRect(-237, 162, 40, 40)

					draw.SimpleText("      " .. table.Count(self.Fortifications) .. " Доступно укрытий", "Alydus.FortificationsTablet.Subtitle", 15, 180, Color(100, 100, 100, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				else
					draw.SimpleText("Создатель Фортификаций", "Alydus.FortificationsTablet.Title", 15, 30, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

					surface.SetMaterial(refreshMat)
					surface.DrawTexturedRect(-130, 70, 40, 40)

					draw.SimpleText("    SUP | Загрузка...", "Alydus.FortificationsTablet.Subtitle", 15, 90, Color(150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			cam.End3D2D()
		end
	end
end

function SWEP:GetViewModelPosition( pos, ang )
	self.SwayScale = 0;
	self.BobScale = 0.1;

	return pos, ang;
end

function SWEP:Initialize()
	self:SetHoldType("slam")
	if CLIENT then
		self.VElements = table.FullCopy( self.VElements )
		self.WElements = table.FullCopy( self.WElements )
		self.ViewModelBoneMods = table.FullCopy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)
		
		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				self:ResetBonePositions(vm)
				
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					vm:SetColor(Color(255,255,255,1))
					vm:SetMaterial("Debug/hsv")			
				end
			end
		end
		
	end

end

function SWEP:Holster()
	
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()
		if IsValid(vm) then
			self:ResetBonePositions(vm)
		end
	end
	
	return true
end

function SWEP:OnRemove()
	self:Holster()
end

if CLIENT then

	SWEP.vRenderOrder = nil
	function SWEP:ViewModelDrawn()
		
		local vm = self.Owner:GetViewModel()
		if !IsValid(vm) then return end
		
		if (!self.VElements) then return end
		
		self:UpdateBonePositions(vm)

		if (!self.vRenderOrder) then
			
			// we build a render order because sprites need to be drawn after models
			self.vRenderOrder = {}

			for k, v in pairs( self.VElements ) do
				if (v.type == "Model") then
					table.insert(self.vRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.vRenderOrder, k)
				end
			end
			
		end

		for k, name in ipairs( self.vRenderOrder ) do
		
			local v = self.VElements[name]
			if (!v) then self.vRenderOrder = nil break end
			if (v.hide) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (!v.bone) then continue end
			
			local pos, ang = self:GetBoneOrientation( self.VElements, v, vm )
			
			if (!pos) then continue end
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for k, name in pairs( self.wRenderOrder ) do
		
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			if (v.hide) then continue end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)

				model:SetAngles(ang)
				//model:SetModelScale(v.size)
				local matrix = Matrix()
				matrix:Scale(v.size)
				model:EnableMatrix( "RenderMultiply", matrix )
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			bone = ent:LookupBone(bone_override or tab.bone)

			if (!bone) then return end
			
			pos, ang = Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model, "GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.createdModel = v.model
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt", "GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end
	
	local allbones
	local hasGarryFixedBoneScalingYet = false

	function SWEP:UpdateBonePositions(vm)
		
		if self.ViewModelBoneMods then
			
			if (!vm:GetBoneCount()) then return end
			
			local loopthrough = self.ViewModelBoneMods
			if (!hasGarryFixedBoneScalingYet) then
				allbones = {}
				for i=0, vm:GetBoneCount() do
					local bonename = vm:GetBoneName(i)
					if (self.ViewModelBoneMods[bonename]) then 
						allbones[bonename] = self.ViewModelBoneMods[bonename]
					else
						allbones[bonename] = { 
							scale = Vector(1,1,1),
							pos = Vector(0,0,0),
							angle = Angle(0,0,0)
						}
					end
				end
				
				loopthrough = allbones
			end
			
			for k, v in pairs( loopthrough ) do
				local bone = vm:LookupBone(k)
				if (!bone) then continue end
				
				local s = Vector(v.scale.x,v.scale.y,v.scale.z)
				local p = Vector(v.pos.x,v.pos.y,v.pos.z)
				local ms = Vector(1,1,1)
				if (!hasGarryFixedBoneScalingYet) then
					local cur = vm:GetBoneParent(bone)
					while(cur >= 0) do
						local pscale = loopthrough[vm:GetBoneName(cur)].scale
						ms = ms * pscale
						cur = vm:GetBoneParent(cur)
					end
				end
				
				s = s * ms
				
				if vm:GetManipulateBoneScale(bone) != s then
					vm:ManipulateBoneScale( bone, s )
				end
				if vm:GetManipulateBoneAngles(bone) != v.angle then
					vm:ManipulateBoneAngles( bone, v.angle )
				end
				if vm:GetManipulateBonePosition(bone) != p then
					vm:ManipulateBonePosition( bone, p )
				end
			end
		else
			self:ResetBonePositions(vm)
		end
		   
	end
	 
	function SWEP:ResetBonePositions(vm)
		
		if (!vm:GetBoneCount()) then return end
		for i=0, vm:GetBoneCount() do
			vm:ManipulateBoneScale( i, Vector(1, 1, 1) )
			vm:ManipulateBoneAngles( i, Angle(0, 0, 0) )
			vm:ManipulateBonePosition( i, Vector(0, 0, 0) )
		end
		
	end

	function table.FullCopy( tab )

		if (!tab) then return nil end
		
		local res = {}
		for k, v in pairs( tab ) do
			if (type(v) == "table") then
				res[k] = table.FullCopy(v)
			elseif (type(v) == "Vector") then
				res[k] = Vector(v.x, v.y, v.z)
			elseif (type(v) == "Angle") then
				res[k] = Angle(v.p, v.y, v.r)
			else
				res[k] = v
			end
		end
		
		return res
		
	end
	
end

