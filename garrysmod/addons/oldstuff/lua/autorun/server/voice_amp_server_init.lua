resource.AddFile("materials/vgui/entities/voice_amplifier.vmt")

hook.Add("PlayerCanHearPlayersVoice","VoiceAmplifierCanHearVoice",function(lis,tal)
  if lis == tal then return end
  local wep = tal:GetActiveWeapon()
  if not (IsValid(wep) and wep:GetClass() == "voice_amplifier") then return end
  if tal:GetPos():DistToSqr(lis:GetPos()) < wep:GetDistance() or (wep:GetAllTalk() and tal:IsAdmin()) then return true,false end
end)
