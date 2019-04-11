include("shared.lua")

function ENT:Initialize()
end

function ENT:Think()
end

surface.CreateFont("medic_topText", {
    font = Arial,
    size = 75,
    antialias = true
})

function ENT:Draw()
    self.Entity:DrawModel()
    local mypos = self:GetPos()
    if (LocalPlayer():GetPos():Distance(mypos) >= 1000) then return end
    local offset = Vector(0, 0, 80)
    local pos = mypos + offset
    local ang = (LocalPlayer():EyePos() - pos):Angle()
    ang.p = 0
    ang:RotateAroundAxis(ang:Right(), 90)
    ang:RotateAroundAxis(ang:Up(), 90)
    ang:RotateAroundAxis(ang:Forward(), 180)
    cam.Start3D2D(pos,ang,0.04)
        draw.RoundedBox(6,-250-2,0-2,500+4,150+4,Color(255,255,255))
        draw.RoundedBox(6,-250,0,500,150,Color(52, 73, 94))
        draw.SimpleText("ПАТРОНЫ","medic_topText",0,75,Color(255,255,255),1,1)
    cam.End3D2D()
end