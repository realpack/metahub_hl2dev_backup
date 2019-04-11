local PART = {}

PART.command = "r_extended_light_entities"
PART.color = Vector(0,0,0)
PART.decay = 200
PART.brightness = 2
PART.size = 15
PART.light = nil

function PART:Render( pos )
	local parent = self:GetParent()
	
	self.light = DynamicLight( parent:EntIndex() )
	
	if self.light then
		self.light.Pos = pos
		self.light.Decay = self.decay
		self.light.DieTime = CurTime() + 1
		self.light.Brightness = self.brightness
		self.light.Size = self.size
		self.light.r = self.color.r
		self.light.g = self.color.g
		self.light.b = self.color.b
	end
end

function PART:OnRemove()
	if self.light then
		self.light.Decay = 5000
	end
end


ExtendedRender.Parts:Register( "Light", PART )