
-----------------------------------------------------
if chat_addtext_hack then return end
chat_addtext_hack=true

if SERVER then AddCSLuaFile"chat_addtext_hack.lua" return end
local cl_chathud_callengine=CreateClientConVar("cl_chathud_callengine","1",true,false)
local chat_AddText=chat.AddText
chat.AddText=function(...)
	if PrimaryChatAddText then
		local ret = PrimaryChatAddText(...)
		if ret or cl_chathud_callengine:GetBool() then
			chat_AddText(...)
		end
	else
		chat_AddText(...)
	end
end

hook.Add('CanRunAnnoyingTags', 'SukaMydak', function(ply) if not IsValid(ply) or ply:GetUserGroup() ~= 'user' then return true end end)