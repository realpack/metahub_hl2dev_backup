include("shared.lua");

local comshieldwall2 = Material('effects/CombineShield/comshieldwall2')
function ENT:DrawTranslucent()
    -- local pos = self:GetPos()
    
    if self:GetCollisionGroup() == 0 then
        -- render.SetColorModulation(255, 0, 0)
        render.SetMaterial(comshieldwall2)
        render.DrawBox( self:GetPos(), self:GetAngles(), self:OBBMins()+Vector(5,0,0), self:OBBMaxs()-Vector(5,0,0), Color(255,255,255,255) )
    end
    -- print(self)
    -- self:DrawModel()
end;

function ENT:Draw()
end