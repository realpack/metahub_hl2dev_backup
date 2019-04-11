include('shared.lua')

local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local render = render
local CurTime = CurTime

local color_white = Color(255,255,255)
local color_black = Color(0,0,0)

function ENT:Draw3D2D()
	self:DrawModel()

	self:drawFloatingGun()
	self:drawInfo()
end

function ENT:drawFloatingGun()
	if (not IsValid(self:GetgunModel())) or (self:Getcount() == 0) then return end

	local pos = self:GetPos()
	local ang = self:GetAngles()

	-- Position the gun
	local gunPos = self:GetAngles():Up() * 40 + ang:Up() * (math.sin(CurTime() * 3) * 8)
	self:GetgunModel():SetPos(pos + gunPos)

	-- Make it dance
	ang:RotateAroundAxis(ang:Up(), (CurTime() * 180) % 360)
	self:GetgunModel():SetAngles(ang)

	self:GetgunModel():DrawModel()
end

function ENT:drawInfo()
	local content = self:Getcontents() or ''
	local contents = rp.shipments[content]
	if not contents then return end
	contents = contents.name

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())

	color_white.a = 350 - dist
	color_black.a = 350 - dist

	ang:RotateAroundAxis(ang:Forward(), 90)

	cam.Start3D2D(pos + ang:Up() * 17, ang, 0.035)
		draw.SimpleTextOutlined('Contents:', '3d2d', 0, -520, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined(contents, '3d2d', 0, -520, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		draw.SimpleTextOutlined('Amount left:', '3d2d', 0, -200, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined(self:Getcount() .. '/25', '3d2d', 0, -200, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end

/*---------------------------------------------------------------------------
Create a shipment from a spawned_weapon
---------------------------------------------------------------------------*/
properties.Add('splitShipment', {
	MenuLabel	=	'Split this shipment',
	Order		=	2003,
	MenuIcon	=	'icon16/arrow_divide.png',

	Filter		=	function(self, ent, ply)
						if not IsValid(ent) then return false end
						return ent:GetClass() == 'spawned_shipment'
					end,

	Action		=	function(self, ent)
						if not IsValid(ent) then return end
						RunConsoleCommand('rp', 'splitshipment', ent:EntIndex())
					end
})