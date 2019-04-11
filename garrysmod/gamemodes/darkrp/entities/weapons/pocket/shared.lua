SWEP.PrintName 					= 'Чемодан'
SWEP.Slot 						= 1
SWEP.SlotPos 					= 1
SWEP.DrawAmmo 					= false
SWEP.DrawCrosshair 				= false

SWEP.Author 					= 'KingofBeast and aStonedPenguin\n Updated by pack'
SWEP.Instructions				= 'Left click with your crosshair on an item to pocket it.'
SWEP.Contact 					= ''
SWEP.Purpose 					= ''

SWEP.ViewModel 					= 'models/weapons/v_suitcase_passenger.mdl'
SWEP.WorldModel					= 'models/weapons/w_suitcase_passenger.mdl'

SWEP.ViewModelFOV 				= 40
SWEP.ViewModelFlip 				= true

SWEP.AutoSwitchTo               = false
SWEP.AutoSwitchFrom             = false

SWEP.Spawnable 					= false
SWEP.Category 					= 'RP'
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ''

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ''

SWEP.UseHands 				= false

SWEP.ShowViewModel = true
SWEP.ShowWorldModel = false

SWEP.VElements = {}
SWEP.WElements = {
	["suitcase"] = { type = "Model", model = "models/weapons/w_suitcase_passenger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.683, 1, 0), angle = Angle(106.708, 0, 0), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.ViewModelBoneMods = {}


function SWEP:Initialize()
	self:SetHoldType('normal')

	if CLIENT then
		self.VElements = table.Copy( self.VElements )
		self.WElements = table.Copy( self.WElements )
		self.ViewModelBoneMods = table.Copy( self.ViewModelBoneMods )

		self:CreateModels(self.VElements)
		self:CreateModels(self.WElements)

		if IsValid(self.Owner) then
			local vm = self.Owner:GetViewModel()

			if IsValid(vm) then
				self:ResetBonePositions(vm)
			end
		end
	end
end

function SWEP:PreDrawViewModel(vm)
	if !(self.ShowViewModel == nil or self.ShowViewModel) then
		vm:SetMaterial('engine/occlusionproxy')
	end
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Holster()
	if CLIENT and IsValid(self.Owner) then
		local vm = self.Owner:GetViewModel()

		if IsValid(vm) then
			self:ResetBonePositions(vm)
			vm:SetMaterial("")
		end
	end

	return true
end

function SWEP:OnRemove()
    self:Holster()
end


-- Shiiiiit
SWEP.wRenderOrder = nil
function SWEP:DrawWorldModel()

    if (!IsValid(self.Owner)) then
        self:DrawModel()
        return
    end

    if (!self.WElements) then return end

    if (!self.wRenderOrder) then

        self.wRenderOrder = {}

        for k, v in pairs( self.WElements ) do
            if (v.type == "Model") then
                table.insert(self.wRenderOrder, 1, k)
            end
        end

    end

    if (IsValid(self.Owner)) then
        bone_ent = self.Owner
    else
        -- when the weapon is dropped
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

        -- local pos = self.Owner:GetBonePosition( self.Owner:LookupBone("ValveBiped.Bip01_R_Hand") )
        if (!pos) then continue end

        local model = v.modelEnt
        local sprite = v.spriteMaterial

        if (v.type == "Model" and IsValid(model)) then

            model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )
            ang:RotateAroundAxis(ang:Up(), v.angle.y)
            ang:RotateAroundAxis(ang:Right(), v.angle.p)
            ang:RotateAroundAxis(ang:Forward(), v.angle.r)

            model:SetAngles(ang)
            --model:SetModelScale(v.size)
            local matrix = Matrix()
            matrix:Scale(v.size)
            model:EnableMatrix( "RenderMultiply", matrix )

            if (v.material == "") then
                model:SetMaterial("")
            elseif (model:GetMaterial() != v.material) then
                model:SetMaterial( v.material )
            end
            if v.submaterial then
                for kk,vv in pairs(v.submaterial) do
                    model:SetSubMaterial(kk,vv)
                end
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
        end

    end

end

function SWEP:CreateModels( tab )

    if (!tab) then return end

    -- Create the clientside models here because Garry says we can't do it in the render hook
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
        end
    end
end
function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
    local bone, pos, ang
    if (tab.rel and tab.rel != "") then

        local v = basetab[tab.rel]

        if (!v) then return end

        -- Technically, if there exists an element with the same name as a bone
        -- you can get in an infinite loop. Let's just hope nobody's that stupid.
        pos, ang = self:GetBoneOrientation( basetab, v, ent )

        if (!pos) then return end

        pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
        ang:RotateAroundAxis(ang:Up(), v.angle.y)
        ang:RotateAroundAxis(ang:Right(), v.angle.p)
        ang:RotateAroundAxis(ang:Forward(), v.angle.r)

    else

        bone = ent:LookupBone(bone_override or tab.bone)

        if (!bone) then return end

        -- why?
        -- |
        -- |
        -- V

        pos, ang = Vector(0,0,0), Angle(0,0,0)
        -- local m = ent:GetBoneMatrix(bone)
        -- if (m) then
        --     pos, ang = m:GetTranslation(), m:GetAngles()
        -- end

        pos, ang = self.Owner:GetBonePosition( bone )

        if (IsValid(self.Owner) and self.Owner:IsPlayer() and
            ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
            ang.r = -ang.r -- Fixes mirrored models
        end

    end

    return pos, ang
end

local allbones
local hasGarryFixedBoneScalingYet = false

function SWEP:UpdateBonePositions(vm)
    if self.ViewModelBoneMods then
        if (!vm:GetBoneCount()) then return end

        // !! WORKAROUND !! //
        // We need to check all model names :/

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
            // !! ----------- !! //
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

