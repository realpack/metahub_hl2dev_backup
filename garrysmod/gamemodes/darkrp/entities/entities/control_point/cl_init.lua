include('shared.lua')

function ENT:Draw()
    self:DrawModel()
    -- if not (LocalPlayer() and IsValid(LocalPlayer()) and
    --     LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and
    --     LocalPlayer():GetActiveWeapon():GetClass() ~= 'gmod_tool' or (LocalPlayer():GetTool() and LocalPlayer():GetTool().Mode ~= 'spawn_points')) then
    --     self:DrawModel()
    -- end
end
