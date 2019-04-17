local rope_length = 100

util.AddNetworkString('ProgressCuffed_Fail')
util.AddNetworkString('ProgressCuffed_Succes')
util.AddNetworkString('ProgressCuffed_Start')

hook.Add( "SetupMove", "Handcuffs_SetupMove", function(ply, mv, cmd)
	local cuffed = ply.IsHandcuffed
	if not cuffed then return end

	mv:SetMaxClientSpeed( mv:GetMaxClientSpeed()*0.6 )

    if not ply.GetPlayerHandcuffed then return end

	ply:SelectWeapon( "handcuffed" )
    local kidnapper = ply.GetPlayerHandcuffed

	if rope_length<=0 then return end // No forced movement
	if not IsValid(kidnapper) then return end // Nowhere to move to

	if kidnapper==ply then return end

	local TargetPoint = ( (kidnapper:IsPlayer() or kidnapper:GetClass() == 'handcuffs_point') and (kidnapper:GetClass() == 'handcuffs_point' and kidnapper:GetPos() or kidnapper:GetShootPos()) )
	local MoveDir = (TargetPoint - ply:GetPos()):GetNormal()
	local ShootPos = ply:GetShootPos() + (Vector(0,0, (ply:Crouching() and 0)))
	local Distance = rope_length

	local distFromTarget = ShootPos:Distance( TargetPoint )
	if distFromTarget<=(Distance+5) then return end
	if ply:InVehicle() then
		if SERVER and (distFromTarget>(Distance*3)) then
			ply:ExitVehicle()
		end

		return
	end

	local TargetPos = TargetPoint - (MoveDir*Distance)

	local xDif = math.abs(ShootPos[1] - TargetPos[1])
	local yDif = math.abs(ShootPos[2] - TargetPos[2])
	local zDif = math.abs(ShootPos[3] - TargetPos[3])

	local speedMult = 3+ ( (xDif + yDif)*0.5)^1.01
	local vertMult = math.max((math.Max(300-(xDif + yDif), -10)*0.08)^1.01  + (zDif/2),0)

	if kidnapper:GetGroundEntity()==ply then vertMult = -vertMult end

	local TargetVel = (TargetPos - ShootPos):GetNormal() * 10
	TargetVel[1] = TargetVel[1]*speedMult
	TargetVel[2] = TargetVel[2]*speedMult
	TargetVel[3] = TargetVel[3]*vertMult
	local dir = mv:GetVelocity()

	local clamp = 50
	local vclamp = 20
	local accel = 200
	local vaccel = 560*(vertMult/50)

	dir[1] = (dir[1]>TargetVel[1]-clamp or dir[1]<TargetVel[1]+clamp) and math.Approach(dir[1], TargetVel[1], accel) or dir[1]
	dir[2] = (dir[2]>TargetVel[2]-clamp or dir[2]<TargetVel[2]+clamp) and math.Approach(dir[2], TargetVel[2], accel) or dir[2]

	if ShootPos[3]<TargetPos[3] then
		dir[3] = (dir[3]>TargetVel[3]-vclamp or dir[3]<TargetVel[3]+vclamp) and math.Approach(dir[3], TargetVel[3]+360, vaccel) or dir[3]

		if vertMult>0 then ply.Cuff_ForceJump=ply end
	end


	mv:SetVelocity( dir )

	if SERVER and mv:GetVelocity():Length()>=(mv:GetMaxClientSpeed()*10) and ply:IsOnGround() and CurTime()>(ply.Cuff_NextDragDamage or 0) then
		ply:SetHealth( ply:Health()-1 )
		if ply:Health()<=0 then ply:Kill() end

		ply.Cuff_NextDragDamage = CurTime()+0.1
	end
end)

function PLAYER:SetHandcuffed(bool,player)
    if bool then
        self.UnHandcuffedWeapons = {}
        for _, wep in pairs(self:GetWeapons()) do
            table.insert(self.UnHandcuffedWeapons, wep:GetClass())
        end
        self:StripWeapons()

        self:Give('handcuffed')
    else
        self:StripWeapon('handcuffed')

		if self.UnHandcuffedWeapons then
			for _, wep in pairs(self.UnHandcuffedWeapons) do
				self:Give(wep)
			end
		end
    end
	if self.GetPlayerHandcuffed then
		self.GetPlayerHandcuffed.GetPlayerKidnapper = false
	end

    self.IsHandcuffed = bool

	self.GetPlayerHandcuffed = false
    self.GetPlayerHandcuffed = bool and player or false

	if player then
		player.GetPlayerKidnapper = bool and self or false
	end

    self:SetNWBool('IsHandcuffed', self.IsHandcuffed)
    self:SetNWEntity('GetPlayerHandcuffed', self.GetPlayerHandcuffed)
end

hook.Add('PlayerTick','Handcuffs_PlayerTick',function( player, mv )
	if not player then return end
	if player.VarProgressCuffed and player:GetEyeTrace().Entity ~= player.VarProgressCuffed then
		player.VarProgressCuffed = false
		netstream.Start(player,'ProgressCuffed_Fail',nil)
	end

    local kidnapper = player.GetPlayerHandcuffed
	if not IsValid(kidnapper) then return end // Nowhere to move to
	if not kidnapper then return end

	local TargetPoint = ( (kidnapper:IsPlayer() or kidnapper:GetClass() == 'handcuffs_point') and (kidnapper:GetClass() == 'handcuffs_point' and kidnapper:GetPos() or kidnapper:GetShootPos()) )
	local MoveDir = (TargetPoint - player:GetPos()):GetNormal()
	local ShootPos = player:GetShootPos() + (Vector(0,0, (player:Crouching() and 0)))
	local Distance = rope_length

	local distFromTarget = ShootPos:Distance( TargetPoint )
    if distFromTarget >= 500 then
        player:SetHandcuffed(false)

        player:StripWeapon('handcuffed')

		if player.UnHandcuffedWeapons then
			for _, wep in pairs(player.UnHandcuffedWeapons) do
				player:Give(wep)
			end
		end
    end
end)

function PLAYER:ProgressCuffed(bool,player)
	if bool and self.GetPlayerHandcuffed then return end
	local duration = bool and HANDCUFFED_DURATION or UN_HANDCUFFED_DURATION

	if player then
		netstream.Start(player,'ProgressCuffed_Start',{bool = bool, timer = duration, target = self})
		player.VarProgressCuffed = self
		player.VarProgressCuffedBool = bool
		player.StarterTimeProgressCuffed = os.time()
	end
end

netstream.Hook('ProgressCuffed_Succes',function(player)
	local bool = player.VarProgressCuffedBool
	local duration = bool and HANDCUFFED_DURATION or UN_HANDCUFFED_DURATION

	if bool and player and player.VarProgressCuffed and player.VarProgressCuffed.GetPlayerHandcuffed then return end

	if player.VarProgressCuffed and os.time() >= player.StarterTimeProgressCuffed+duration then
		player.VarProgressCuffed:SetHandcuffed(bool,player)

		player.VarProgressCuffedBool = false
		player.VarProgressCuffed = false
		player.StarterTimeProgressCuffed = false
	end
end)

hook.Add( "KeyPress", "Handcuffs_KeyPress", function( player, key )
	if not player then return end
  
  if key ~= IN_USE then return end
  
  local walk=player:KeyDown(IN_WALK)
  if not walk then return end


	if player.GetPlayerKidnapper then
  
		local trace = player:GetEyeTrace()
		local target = trace.Entity

		local pos = trace.HitPos

		if not target:IsWorld() then return end
    player:ChatPrint('kek')
		if pos:DistToSqr(player:GetPos()) > 23000 then return end
		if not player.GetPlayerKidnapper then return end

		local entity = ents.Create('handcuffs_point')
		entity:SetAngles( player:EyeAngles() + Angle(180,0,0) )
		entity:Spawn()
		entity:SetPos(trace.HitPos)
		entity:Activate()

		player.GetPlayerKidnapper:SetHandcuffed(true,entity)

		entity:SetNVar('GetPlayerKidnapper',entity.GetPlayerKidnapper)
		-- end
	end
end )

hook.Add( "PlayerDeath", "Handcuffs_PlayerDeath", function( player )
	if not player then return end
	player:SetHandcuffed(false)

	if player.GetPlayerKidnapper then
		player.GetPlayerKidnapper:SetHandcuffed(false)
	end
end)

hook.Add( "PlayerDisconnected", "Handcuffs_PlayerDisconnected", function( player )
	if not player then return end
	player:SetHandcuffed(false)

	player.VarProgressCuffed = false
	player.StarterTimeProgressCuffed = false

	-- netstream.Start(player,'ProgressCuffed_Fail',nil)
    net.Start('ProgressCuffed_Fail')
    net.Send(player)

	if player.GetPlayerKidnapper then
		player.GetPlayerKidnapper:SetHandcuffed(false)
	end
end)
