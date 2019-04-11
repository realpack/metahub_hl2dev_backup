include("shared.lua")





local UPPER_TEXT = Color(255,255,255)
local LOWER_TEXT = Color(20, 150, 200)
local OUTLINE    = Color(0,0,0)

local font = "ui.40"
local function drawSide(pos,ang,t1,t2)
	cam.Start3D2D(pos, ang, .1)
		draw.SimpleTextOutlined(t1, font, 0, -385, UPPER_TEXT, TEXT_ALIGN_CENTER, nil, 1, OUTLINE)
		draw.SimpleTextOutlined(t2, font, 0, -350, LOWER_TEXT, TEXT_ALIGN_CENTER, nil, 1, OUTLINE)
	cam.End3D2D()
end



local ang = Angle(0,0,90)
local rot = 0 -- 0-180
hook.Add("Think","RotateSigns",function()
	rot = rot == 180 and 0 or math.Approach(rot,180,0.3)

	ang.y = -rot -- минус крутит в обратную сторону
end)


function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()

	local ITEM = IGS.GetItemByUID(self:GetUID())
	local t1 = ITEM:Name()
	local t2 = "Действует " .. IGS.TermToStr(ITEM:Term())

	drawSide(pos,ang,t1,t2)
	ang:RotateAroundAxis(ang:Right(), 180)
	drawSide(pos,ang,t1,t2)
end