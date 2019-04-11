if SERVER then AddCSLuaFile() end

 local L = translation and translation.L or function(s) return s end

local DEBUG=false

local Tag="pmail"
if SERVER then
	util.AddNetworkString(Tag)
end

module(Tag,package.seeall)

local Dbg=DEBUG and function(...) Msg("["..Tag.."] ")print(...)end or function()end

net.Receive(Tag,function( len,pl )
	local tbl = {}
	if CLIENT then
		tbl.msg = net.ReadString()
		tbl.sender = net.ReadString()
	else
		tbl.msg = net.ReadString()
		tbl.receiver = net.ReadString()
	end
	
	if SERVER then
		tbl.sender = pl:SteamID()
		local msg = tbl.msg
		
		if not chatbox.ValidMessage ( msg ) then return end

		if pl.raybans and pl.raybans.chat then
			return
		end
		
		if msg:len()>64*1024-128 then
			ErrorNoHalt("[ChatPM] IGNORING TOO LONG MESSAGE: len="..msg:len().." from "..tostring(pl))
			return
		end
		
		-- Anti spam
		if chatbox.SpamWatch( pl, msg ) then
			Send{
				msg=L"Spam protection triggered. You're sending too fast!",
				sender="",
				receiver=pl:SteamID(),
			}
			return
		end
		
	end
	
	OnReceive( tbl )
	
end )

function toplayer(steamid)
	Dbg("Finding",steamid)
	for k,v in pairs(player.GetAll()) do
		if v:SteamID()==steamid then
			return v
		end
	end
end

function Send(tbl)
	net.Start(Tag)
	
	net.WriteString(tbl.msg) -- message first
		
	if SERVER then -- pl->pl
		net.WriteString(tbl.sender)
		local pl = toplayer(tbl.receiver)
		if not pl then return false,"Player not found" end
		local sender = toplayer(tbl.sender)
		
		local blockmsg = pl:GetInfo("chat_pm_friendsonly")
		if blockmsg and #blockmsg>0 and blockmsg~="0" then
			if sender and pl.AreFriends and not pl:AreFriends(sender) then
				return false,(L"player only receives friends chat")..(blockmsg and #blockmsg>1 and (": "..tostring(blockmsg)) or "" )
			end
		end
		
		local blockmsg = sender and sender:GetInfo("chat_pm_friendsonly")
		if blockmsg and #blockmsg>0 and blockmsg~="0" then
			if sender and sender.AreFriends and not sender:AreFriends(pl) then
				return false,L"this player is not your friend"
			end
		end

		
		local blockmsg = pl:GetInfo("chat_pm_disable")
		if blockmsg and #blockmsg>0 and blockmsg~="0" and sender then
			return false,(L"player has disabled PM")..(blockmsg and #blockmsg>1 and (": "..tostring(blockmsg)) or "" )
		end
		
		local blockmsg = sender and sender:GetInfo("chat_pm_disable")
		if blockmsg and #blockmsg>0 and blockmsg~="0" then
			return false,L"You have disabled PM"
		end
		
		net.Send(pl)
	else
		net.WriteString(tbl.receiver)
		net.SendToServer()
		
		hook.Call(Tag,nil,tbl.msg,tbl.receiver,tbl,true)
	end
	return true
end


if SERVER then
	function OnReceive( tbl )
		local sent,errmsg = Send( tbl )
		if not sent then
			local err={
				msg=(L"Failed sending to") .. " " ..tostring(tbl.receiver)..(errmsg and (': '..tostring(errmsg)) or ""),
				sender="",
				receiver=tbl.sender,
			}
			local sent = Send(err)
			if not sent then
				Msg"WTFAIL: "PrintTable(tbl)
			end
		end
		
	end
else
	function OnReceive( tbl )
		Dbg("Message from",tbl.sender,toplayer(tbl.sender),"'"..tostring(tbl.msg).."'")
		hook.Call(Tag,nil,tbl.msg,tbl.sender,tbl)
	end
end

-- small user interface
-- TODO: GUI
-- todo: mute

if CLIENT then

	local chat_pm_friendsonly = CreateClientConVar("chat_pm_friendsonly","0",true,true)
	local chat_pm_disable = CreateClientConVar("chat_pm_disable","0",true,true)

	function pmcmd(_,_,args,str)
		local receiver = args[1]
		if not receiver then return end
		local _,pos=str:find(receiver,1,true)
		local msg = str:sub(pos+2,-1)
		
		for k,v in pairs(player.GetAll()) do
			if v:Name():find(receiver,1,true) then
				receiver=v:SteamID()
			end
		end
		if not receiver or not receiver:find("^STEAM") then print"Invalid player" return end
		Send{msg=msg,receiver=receiver}
		
	end
	function pmautocomplete(_,str)
		local str=str:sub(2,-1)
		if str:find" " then return end
		local t={}
		for k,v in pairs(player.GetHumans()) do
			table.insert(t,_..' "'..v:Name()..'"')
		end
		return t
	end
	concommand.Add("pm",pmcmd,pmautocomplete)
end

if CLIENT then

	local pm_hud = CreateClientConVar("pm_hud","0",true)
	local pm_hud_notify = CreateClientConVar("pm_hud_notify","1",true)
	local pm_hud_notify_sound = CreateClientConVar("pm_hud_notify_sound","1",true)
	local red=Color(200,100,100,255)
	local white=Color(255,255,255,255)
	local next_pm_notification = 0
	hook.Add(Tag,Tag,function(msg,sender,tbl,me)

		if not msg then return end
		
		if me then next_pm_notification = 0 end
		
		if not me and not pm_hud:GetBool() and pm_hud_notify:GetBool() and next_pm_notification<RealTime() then
			local n = pm_hud_notify:GetInt()
			n=n and n>1 and n or 15
			
			next_pm_notification = RealTime()+n
			if pm_hud_notify_sound:GetBool() then
				LocalPlayer():EmitSound("friends/message.wav",100,100)
			end
			chat.AddText(red,"[[ ",white,
				L'PM From ',toplayer(sender) or tostring(sender=="" and L"SYSTEM" or sender),red," ]]")
			return
		end
		
		if not me then
			chat.AddText(red,"[",white,
				L'PM',red,"] ",white,toplayer(sender) or tostring(sender)
			,white,': '..tostring(msg))
		else
			chat.AddText(red,"[",white,
				(L'PM to') .. ' ',white,toplayer(sender) or tostring(sender),red,"] ",white,LocalPlayer()
			,white,': '..tostring(msg))
		end
	end)

end

