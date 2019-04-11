AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
	if IsValid(self.Owner) and self:HasAmmo() then
		local manhack = self:GetSpawnedManhack()

	    if not IsValid(manhack) or (IsValid(manhack) and not manhack:GetControlActive()) then
			local viewModel = self.Owner:GetViewModel()

			viewModel:SendViewModelMatchingSequence(self.PrimarySequence)

		    timer.Simple(self.SpawnDelay, function()
		        if ControllableManhack.IsViewModelValidAfterDelay(self, viewModel) then
		            self:SpawnManhack()

					self.Owner:RemoveAmmo(1, self.Primary.Ammo)
		        end
		    end)

			timer.Simple(self.ResetDelay, function()
				if ControllableManhack.IsViewModelValidAfterDelay(self, viewModel) then
					viewModel:SendViewModelMatchingSequence(self.PrimarySequence2)
				end
			end)

			self.Owner:SetAnimation(PLAYER_ATTACK1)

			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		end
	end

	--PrimaryAttack is not called clientside in singleplayer by default
	if game.SinglePlayer() then
		self:CallOnClient("PrimaryAttack")
	end
end

function SWEP:SecondaryAttack()
    if IsValid(self.Owner) and (self.Owner:GetMoveType() == MOVETYPE_NOCLIP or ControllableManhack.IsPlayerGrounded(self.Owner)) then
		local manhack = self:GetSpawnedManhack()

	    if IsValid(manhack) and not manhack:GetControlActive() then
            print(manhack)
	        manhack:StartControlling()
	    end
	end
end

function SWEP:Reload()
	if IsValid(self.Owner) then
	    self:SelfDestructManhack()
	end
end

function SWEP:SpawnManhack()
    self:SelfDestructManhack()

	local trace = util.TraceLine({
		start = self.Owner:EyePos(),
		endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * self.SpawnDistance,
		filter = self.Owner
	})

    local manhack = ControllableManhack.SpawnManhack(self.Owner, trace.HitPos + trace.HitNormal * self.TraceNormalMultiplier, Angle(0, self.Owner:EyeAngles().y, 0))
end

function SWEP:SelfDestructManhack()
    local manhack = self:GetSpawnedManhack()

    if IsValid(manhack) then
        manhack:SelfDestruct()
    end
end

function SWEP:GetSpawnedManhack()
    return ControllableManhack.GetManhackForPlayer(self.Owner)
end
