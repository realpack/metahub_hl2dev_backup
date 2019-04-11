local PART = {}

PART.command = "r_extended_glow"
PART.color = Vector(0,0,0)
PART.size = 64
PART.opacity = 20
PART.shimmer = false
PART.pixVisEnabled = true
PART.pixVis = 0
PART.lod = 800
PART.anamorphicLensOpacity = 5

PART.materials = {
	["glow"] = {
		textureID = "effects/extended_render/glow"
	},
	["glow_add"] = {
		textureID = "sprites/light_glow02_add_noz"
	},
	["laser"] = {
		textureID = "trails/laser"
	}
}

PART.oldpos = Vector(0, 0, 0)
PART.trail = false
PART.points = {}
PART.length = 25
PART.spacing = 5
PART.lastAdd = 0
PART.startSize = 8
PART.endSize = 0
PART.stretch = false

function PART:Spawn()
	self.PixVisHandle = util.GetPixelVisibleHandle()
	ExtendedRender.Util:LoadMaterials( self )
end

function PART:Render( pos )
	local PixVis = util.PixelVisible( pos, 2, self.PixVisHandle )
	
	self.oldpos = Lerp( FrameTime() * 2, self.oldpos, pos )
	
	if GetConVar("r_extended_trail"):GetBool() and self.trail then
	
		local boxSize = 2
		local static = pos:WithinAABox( self.oldpos - Vector( boxSize, boxSize, boxSize ), self.oldpos + Vector( boxSize, boxSize, boxSize ) )
		
		if not static then
			
			local len = self.length
			local spacing = self.spacing

			if spacing == 0 or self.lastAdd < CurTime() then
				table.insert( self.points, pos )
				self.lastAdd = CurTime() + spacing / 1000
				
			end
			
			local count = #self.points

			if spacing > 0 then
				len = math.ceil( math.abs( len - spacing ) )
			end

			render.SetMaterial( self.materials["laser"].material )

			render.StartBeam( count )
				for i, point in pairs( self.points ) do
					local width = i / ( len / self.startSize )

					local coord = ( 1 / count ) * (i - 1)

					render.AddBeam( i == count and pos or point, width + self.endSize, self.stretch and coord or width, Color(self.color.r, self.color.g, self.color.b, 255) )
				end
			render.EndBeam()

			if count >= len then
				table.remove(self.points, 1)
			end
		else
			self.points = {}
		end
	end
	
	if self.lod != 0 and pos:DistToSqr( EyePos() ) > ( self.lod * self.lod )  then return false end
	
	if self.pixVisEnabled and PixVis < 0.5 then return false end
	
	if GetConVar("r_extended_glow"):GetBool() then
		render.SetMaterial( self.materials["glow"].material )
		render.DrawSprite( pos, self.size, self.size, Color(self.color.r, self.color.g, self.color.b, self.opacity ))
		
		if self.shimmer then
		
			render.SetMaterial( self.materials["glow"].material )
			render.DrawSprite( pos, 80, self.size, Color(20, 110, 180, self.anamorphicLensOpacity ))
			
			render.SetMaterial( self.materials["glow_add"].material )
			render.DrawSprite( pos, self.size / 2, self.size / 2, Color(255, 255, 255, 255))
		end
	end
end

ExtendedRender.Parts:Register( "Glow", PART )