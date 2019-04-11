if SERVER then
  util.AddNetworkString("Repair_time")
end

if CLIENT then
  SWEP.PrintName = "Гаечный ключ"
  SWEP.Slot = 5
  SWEP.SlotPos = 1
  SWEP.DrawAmmo = false
  SWEP.DrawCrosshair = false
end

-- Variables that are used on both client and server
SWEP.Instructions = ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = Model("models/props_c17/tools_wrench01a.mdl")
SWEP.WorldModel = Model("models/props_c17/tools_wrench01a.mdl")
SWEP.Spawnable = true
SWEP.Category = "RP"
SWEP.Sound = Sound("physics/wood/wood_box_impact_hard3.wav")
SWEP.Primary.ClipSize = -1 -- Size of a clip
SWEP.Primary.DefaultClip = 0 -- Default number of bullets in a clip
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1 -- Size of a clip
SWEP.Secondary.DefaultClip = -1 -- Default number of bullets in a clip
SWEP.Secondary.Automatic = false -- Automatic/Semi Auto
SWEP.Secondary.Ammo = ""
SWEP.RepairTime = 30

--[[---------------------------------------------------------
Name: SWEP:Initialize()
Desc: Called when the weapon is first loaded
---------------------------------------------------------]]
function SWEP:Initialize()
  self:SetHoldType("pistol")
end

if CLIENT then
  net.Receive("Repair_time", function(len)
    local wep = net.ReadEntity()
    local time = net.ReadUInt(32)
    wep.RepairTime = time
    wep.EndRepair = CurTime() + time
  end)
end

--[[---------------------------------------------------------
Name: SWEP:PrimaryAttack()
Desc: +attack1 has been pressed
---------------------------------------------------------]]
function SWEP:PrimaryAttack()
  self.Weapon:SetNextPrimaryFire(CurTime() + 2)
  if self.IsRepairing then return end
  local trace = self.Owner:GetEyeTrace()
  local e = trace.Entity
  if SERVER and not e:GetNetVar('TerminalRepair') or e:GetNetVar('TerminalRepair') == nil or e:GetNetVar('TerminalRepair') >= 100 then return false end

  if IsValid(self.Owner) and IsValid(e) then
    self.RepairTime = e:GetNetVar('TerminalRepair')
  else
    self.RepairTime = 100
  end

  hook.Call("PlayerStartRepairing", nil, self.Owner, e)
  self.IsRepairing = true
  self.StartRepair = CurTime()

  if SERVER then
    net.Start("Repair_time")
    net.WriteEntity(self)
    net.WriteUInt(self.RepairTime, 32)
    net.Send(self.Owner)
  end

  self.EndRepair = CurTime() + self.RepairTime
  self:SetHoldType("pistol")

  if SERVER then
    timer.Create("RepairSounds", 1, self.RepairTime, function()
      if not IsValid(self) then return end
      local snd = {1, 2, 3, 4}
      self:EmitSound("physics/metal/metal_box_strain" .. tostring(snd[math.random(1, #snd)]) .. ".wav", 50, 100)
    end)
  elseif CLIENT then
    self.Dots = self.Dots or ""

    timer.Create("RepairDots", 0.5, 0, function()
      if not self:IsValid() then
        timer.Remove("RepairDots")

        return
      end

      local len = string.len(self.Dots)

      local dots = {
        [0] = ".",
        [1] = "..",
        [2] = "...",
        [3] = ""
      }

      self.Dots = dots[len]
    end)
  end
end

function SWEP:Holster()
  self.IsRepairing = false

  if SERVER then
    timer.Remove("RepairSounds")
  end

  if CLIENT then
    timer.Remove("RepairDots")
  end

  return true
end

function SWEP:Succeed()
  self.IsRepairing = false
  self:SetHoldType("normal")
  local trace = self.Owner:GetEyeTrace()

  if SERVER and IsValid(trace.Entity) then
    trace.Entity:SetNetVar('TerminalRepair', 0)
    trace.Entity:SetNetVar('TerminalBreak', false)
  end

  hook.Call("PlayerFinishRepairing", nil, self.Owner, trace.Entity)

  if SERVER then
    timer.Remove("RepairSounds")
  end

  if CLIENT then
    timer.Remove("RepairDots")
  end
end

function SWEP:Fail()
  self.IsRepairing = false
  self:SetHoldType("normal")

  if SERVER then
    timer.Remove("RepairSounds")
  end

  if CLIENT then
    timer.Remove("RepairDots")
  end
end

function SWEP:Think()
  if self.IsRepairing then
    local trace = self.Owner:GetEyeTrace()

    if not IsValid(trace.Entity) then
      self:Fail()
    end

    if trace.HitPos:Distance(self.Owner:GetShootPos()) > 100 or not trace.Entity:GetNetVar('TerminalRepair') or trace.Entity:GetNetVar('TerminalRepair') == nil then
      self:Fail()
    end

    if self.EndRepair <= CurTime() then
      self:Succeed()
    end
  end
end

function SWEP:DrawHUD()
  if self.IsRepairing then
    self.Dots = self.Dots or ""
    local x, y = (ScrW() / 2) - 150, (ScrH() / 2) - 25
    local w, h = 300, 50
    local time = self.EndRepair - self.StartRepair
    local status = (CurTime() - self.StartRepair) / time
    rp.ui.DrawProgress(x, y, w, h, status)
    draw.ShadowSimpleText("Чиню" .. self.Dots, "font_base_24", ScrW() / 2, ScrH() / 2, Color(255, 255, 255, 255), 1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
end

function SWEP:SecondaryAttack()
  self:PrimaryAttack()
end

function SWEP:DrawWorldModel()
    if not IsValid( self.Owner ) then return end

    local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
    if bone then
        local pos, ang = self.Owner:GetBonePosition( bone )
        local offsetPos = ang:Right() * 1 + ang:Forward() * 3 + ang:Up() * -2

        ang:RotateAroundAxis( ang:Right(), 0 )
        ang:RotateAroundAxis( ang:Forward(), 90 )
        ang:RotateAroundAxis( ang:Up(), 180 )

        self:SetRenderOrigin( pos + offsetPos )
        self:SetRenderAngles( ang )

        self:DrawModel()
    end
end

function SWEP:GetViewModelPosition( pos, ang )
    pos = pos + ang:Right() * 9 + ang:Forward() * 18 + ang:Up() * -9

    ang:RotateAroundAxis( ang:Right(), 90 )
    ang:RotateAroundAxis( ang:Up(), -90 )

    return pos, ang
end
