ENT.Type 		= 'anim' 
ENT.Base		= 'base_anim' 
ENT.PrintName	= 'Metal Detector'
ENT.Author		= 'aStonedPenguin'
ENT.Spawnable	= true
ENT.Category 	= 'RP'
ENT.MaxHealth 	= 150

function ENT:SetupDataTables()
	self:NetworkVar('Int', 1, 'Mode')
end