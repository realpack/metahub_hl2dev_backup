net.Receive( "captureSync", function( len )
  local temp = net.ReadTable()
  if temp != nil then
    capture.Zones = temp
  end
end)

net.Receive("capture.WinnerEffect", function()
  local ply = net.ReadEntity()
  local em = ParticleEmitter(ply:GetPos())
    for i=0, 50 do
      local part = em:Add( "effects/spark", ply:GetPos() + VectorRand()*math.random(-30,30) + Vector(math.random(1,10),math.random(1,10),math.random(50,175)) )
      -- ply:EmitSound("other/whistle_party_noise_maker_005.mp3")
      part:SetAirResistance( 100 )
      part:SetBounce( 0.3 )
      part:SetCollide( true )
      part:SetColor( math.random(10,250),math.random(10,250),math.random(10,250),255 )
      part:SetDieTime( 2 )
      part:SetEndAlpha( 0 )
      part:SetEndSize( 0 )
      part:SetGravity( Vector( 0, 0, -250 ) )
      part:SetRoll( math.Rand(0, 360) )
      part:SetRollDelta( math.Rand(-7,7) )    
      part:SetStartAlpha( math.Rand( 80, 250 ) )
      part:SetStartSize( math.Rand(6,12) )
      part:SetVelocity( VectorRand() * 75 )
    end
  em:Finish()
end)
