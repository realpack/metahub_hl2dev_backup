local staminaRegenDelay = 2
local staminaRegenRate = 8
local staminaSprintCost = 6
local staminaJumpCost = 5

local baseRunSpeed = 225
local baseWalkSpeed = 100

function PLAYER:SetStamina( intValue )
	self:SetNetVar( "Stamina", intValue)
end

function PLAYER:TakeStamina( intValue )
	local intStamina = self:GetStamina()
	if intValue and intStamina then
		self:SetNetVar( "Stamina", math.Clamp( intStamina - intValue, 0, 100 ))
		self.staminaLastUse = CurTime()
	end
end

hook.Add( "PlayerLoadout", "Stamina_PlayerLoadout", function( pl )
    pl:SetStamina( 100 )
end)

hook.Add( "Think", "Stamina_Regen", function()
	for k, pPlayer in pairs( player.GetAll() ) do
		if not IsValid( pPlayer ) or not pPlayer:Alive() then continue end

		-- handle stamina
		local vel = pPlayer:GetVelocity():Length()
		local stam = pPlayer:GetStamina()

		if pPlayer:KeyDown( IN_SPEED ) and vel ~= 0 and pPlayer:OnGround() and pPlayer.canSprint then
			local take = math.Clamp( FrameTime() * staminaSprintCost, 0, 100 )
			pPlayer:SetHunger(pPlayer:GetHunger()-(take/math.random(60,80)))
			if take ~= 0 then pPlayer:TakeStamina( take ) end
		elseif pPlayer.staminaLastUse and pPlayer.staminaLastUse + staminaRegenDelay <= CurTime() then
			local mul = (not pPlayer:OnGround() and 0) or (vel > 100 and 100 / vel or 1)
			local newStam = math.Clamp( stam + FrameTime() * staminaRegenRate * mul, 0, 100 )
			if pPlayer:IsCP() then
				newStam = math.Clamp( stam + FrameTime() * staminaRegenRate*.5 * mul, 0, 100 )
			end

			if newStam ~= stam and not pPlayer:IsStalker() then pPlayer:SetStamina( newStam ) end
		end

		if isnumber(stam) then
			if stam < staminaJumpCost then
				pPlayer.canJump = false
				pPlayer:SetJumpPower( 0 )
			elseif not pPlayer.canJump or pPlayer:GetJumpPower() == 0 then
				pPlayer.canJump = true
				pPlayer:SetJumpPower( 200 )
				pPlayer.canSprint = false
			end

			if stam <= 0 or pPlayer:GetHunger() <= 0 then
				pPlayer:SetRunSpeed( baseWalkSpeed )
			elseif pPlayer.bWearBox then
				pPlayer:SetRunSpeed( baseWalkSpeed )
			elseif stam <= 40 then
				-- pPlayer.canSprint = true
				pPlayer:SetRunSpeed( baseRunSpeed )
			elseif stam > 40 and (not pPlayer.canSprint or pPlayer:GetRunSpeed() == baseWalkSpeed) then
				pPlayer.canSprint = true
				pPlayer:SetRunSpeed( baseRunSpeed )
			end
		end
	end
end)

hook.Add( "SetupMove", "Stamina_Jump", function( pPlayer, mv, cmd )
	if mv:KeyPressed( IN_JUMP ) and pPlayer:OnGround() and pPlayer:GetStamina() >= staminaJumpCost or pPlayer:GetHunger() <= 0 then
		pPlayer:TakeStamina( staminaJumpCost )
	end
end)
