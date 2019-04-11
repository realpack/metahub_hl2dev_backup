function EFFECT:Init( data )

	//instead of env_explosion or 'Explosion' effect lets make our own
	local pos = data:GetOrigin()
	local originalpos = pos
	
	local emitter = ParticleEmitter(pos, true)
	
	local speed = math.Rand(200, 400)

		local rad = math.random(0,360)
		local arrivepos = pos
		
		arrivepos = Vector(arrivepos.x + math.sin( CurTime()*3+math.rad( rad ) ) * 45,arrivepos.y + math.cos( CurTime()*3+math.rad( rad) ) * 45,arrivepos.z)
		
		pos.z = pos.z + math.random(-6,6)
		
		local particle = emitter:Add("effects/select_ring", pos + VectorRand() * 3)
		local dir = (pos - arrivepos):GetNormal()
		particle:SetColor( 0, 255, 0 )
		particle:SetAngles( Angle (90, 0 , 0) )
		particle:SetLifeTime( 0.1 )
		particle:SetDieTime( 0.3 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 400 )
		

end

function EFFECT:Think()
return false
end

function EFFECT:Render()
return false
end