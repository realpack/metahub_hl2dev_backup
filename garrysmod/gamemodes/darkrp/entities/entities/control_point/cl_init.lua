include('shared.lua')

local function DrawSimpleCircle(posx, posy, radius, color)
  local poly = { }
  local v = 40
  for i = 0, v do
    poly[i+1] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
  end

  draw.NoTexture()
  surface.SetDrawColor(color)
  surface.DrawPoly(poly)
end

local function DrawCircle(posx, posy, radius, progress, color)
  local poly = { }
  local v = 220
  poly[1] = {x = posx, y = posy}
  for i = 0, v*progress+0.5 do
    poly[i+2] = {x = math.sin(-math.rad(i/v*360)) * radius + posx, y = math.cos(-math.rad(i/v*360)) * radius + posy}
  end
  draw.NoTexture()
  surface.SetDrawColor(color)
  surface.DrawPoly(poly)
end

local anim_capture = 0

function ENT:Draw()
  self:DrawModel()

  local ang = self:GetAngles()
  local pos = self:GetPos()+ang:Up()*15+ang:Forward()*35
  local mypos = LocalPlayer():GetPos()
  local dist = pos:Distance(mypos)
  local ID = self:GetId() or nil

  if dist > 350 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then
    return -- fancy math says we dont need to draw
  end

  ang:RotateAroundAxis(ang:Forward(), 0)
  ang:RotateAroundAxis(ang:Right(), -45)
  ang:RotateAroundAxis(ang:Up(), 90)

  if ID then
    cam.Start3D2D(pos, ang, 0.070)
      anim_capture = Lerp(0.05, anim_capture, self:GetNetVar('Control_Capture') or 0)

      if self:GetNetVar('Control_Capture') and self:GetNetVar('Control_Capture') >= 1 then
        DrawSimpleCircle(0, -500, 100, Color(50, 50, 50, 200))
        DrawCircle(0, -500, 100, math.Clamp(100/100 * anim_capture/100,0,1), capture.Zones[ID].color)
        draw.ShadowSimpleText(self:GetNetVar('Control_Capture').."%", 'font_base_45', 0, -500, color_white, 1, 1)
        draw.ShadowSimpleText('Взлом терминала...', 'font_base_45', 0, -390, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
      end

      draw.ShadowSimpleText(capture.Zones[ID].name, 'font_base_45', 0, -680, color_white, 1, 1)

      if !self:GetFraction() or self:GetFraction() == "" then
        draw.ShadowSimpleText("Фракция: Свободный терминал", 'font_base_45', 0, -640, color_white, 1, 1)
      else
        draw.ShadowSimpleText("Фракция: "..self:GetFraction(), 'font_base_45', 0, -640, color_white, 1, 1)
      end

    cam.End3D2D()
  end
end
