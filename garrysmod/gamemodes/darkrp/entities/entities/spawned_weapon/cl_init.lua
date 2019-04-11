include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

/*---------------------------------------------------------------------------
Create a shipment from a spawned_weapon
---------------------------------------------------------------------------*/
properties.Add("createShipment",
{
	MenuLabel	=	"Create a shipment",
	Order		=	2002,
	MenuIcon	=	"icon16/add.png",

	Filter		=	function(self, ent, ply)
						if not IsValid(ent) then return false end
						return ent:GetClass() == "spawned_weapon"
					end,

	Action		=	function(self, ent)
						if not IsValid(ent) then return end
						RunConsoleCommand("rp", "makeshipment", ent:EntIndex())
					end
})
