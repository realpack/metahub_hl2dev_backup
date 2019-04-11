
-----------------------------------------------------
include "includes/extensions/chat_addtext_hack.lua"

local function chatbox_init()
	include "chatbox/transportation.lua"
	include "chatbox/private_messaging.lua"
	include "chatbox/tab_chat.lua"
	include "chatbox/tab_lua.lua"
	include "chatbox/tab_pm.lua"
	include "chatbox/tab_config.lua"
	include "chatbox/chatbox.lua"
	include "chatbox/translation.lua"
endhook.Add('InitPostEntity', 'CreateChatLPFix', function() chatbox_init() hook.Remove('InitPostEntity', 'CreateChatLPFix') end)

if SERVER then return end

concommand.Add("chatbox_reload",function()
	if _G.chatbox and IsValid(chatbox.chatgui) then
		chatbox.chatgui:Remove()
	end
	_G.chatbox = nil
	package.loaded.chatbox = nil
	chatbox_init()
end)


concommand.Add("chatbox_recreate",function()
	if _G.chatbox then
		chatbox.CreateChatbox(true)
	end
end)