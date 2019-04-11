local PART = {}

AccessorFunc( PART, "parent", "Parent" )
AccessorFunc( PART, "enabled", "Enabled", FORCE_BOOL )
AccessorFunc( PART, "tempPos", "TempPos" )
AccessorFunc( PART, "tempPrevPos", "TempPrevPos" )
AccessorFunc( PART, "transform", "Transform" )
AccessorFunc( PART, "render3D", "Render3D" )
AccessorFunc( PART, "redraw", "Redraw" )
AccessorFunc( PART, "bone", "Bone" )

PART.command = "r_extended_enable"
PART:SetTempPos( Vector(0, 0, 0) )
PART:SetTempPrevPos ( Vector(0, 0, 0) )
PART:SetEnabled( true )
PART:SetRedraw( true )
local transform = {
	world = {
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0),
		offset = Vector(0, 0, 0)
	},
	view = {
		pos = Vector(0, 0, 0),
		ang = Angle(0, 0, 0),
		offset = Vector(0, 0, 0)
	}
}
PART:SetRender3D( true )
PART:SetTransform( transform )
PART:SetBone( "ValveBiped.Bip01_Head1" )

function PART:Spawn()
end

function PART:Init()
end

function PART:Think()
end

function PART:Render()
end

function PART:OnRemove()
end

ExtendedRender.Part = PART