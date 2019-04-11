local Tag="chatbox"
module(Tag,package.seeall)

---------------------------------------------------------------
-- Transportation
---------------------------------------------------------------

function ValidMessage( msg )
	return (msg and type(msg)=="string" and msg:len()>0)
end



function UserIDToPly( plyid )
	for _,pl in pairs(player.GetAll()) do
		if pl:UserID()==plyid then
			return pl
		end
	end
	return false
end

if SERVER then
	AddCSLuaFile()
	util.AddNetworkString(Tag)
	-- Spamming

	// 10 messages burst, after that limited to one per second
	spam_max=10
	spam_step=1

	SpamTbl={} setmetatable(SpamTbl, { __mode = 'k' })

	-- inform client of version
	version = CreateConVar("_chatbox_version","2.3",FCVAR_NOTIFY)
	
	local Now=CurTime
	
	-- TODO: account for text length instead of count
	function SpamWatch( pl, msg )
		
		local res=SpamTbl[pl] or 0
		
		local now = Now()
		if res<now then res=now end
		
		res=res+spam_step
		if res>now+spam_max then
			pl:ChatPrint("[Chat] Stop spamming the chat!")
			
			return true
		--else
		--	pl:ChatPrint"OK"
		end
		SpamTbl[pl]=res
	end

function PlayerCanSeePlayersChat( msg, teamchat, ply, target, localchat )
		-- NOTE: function GM:PlayerCanSeePlayersChat( strText, bTeamOnly, pListener, pSpeaker )
		-- if bTeamOnly then
		-- 	if ( !IsValid( pSpeaker ) or !IsValid( pListener ) ) then return false end
		-- 	if ( pListener:Team() ~= pSpeaker:Team() ) then return false end
		-- end
		-- return true
		
		-- this is a massive hack but lets do it anyway
		if localchat then
			local result = hook.Call("PlayerCanSeePlayersChat", nil, msg, teamchat, ply, target, true )
			if result == nil then
				
				if IsValid(ply) and IsValid(target) and ply:GetPos():Distance(target:GetPos()) < 256 then
					return true
				end
				
				return false
			end
			
			return result
		end
		
		local result = hook.Call("PlayerCanSeePlayersChat", GAMEMODE, msg, teamchat, ply, target )
		return result
	end
	

	-- Sending
	function SendChatMessage( ply, msg, teamchat, localchat )
	
		local targets = {} -- who to send
		
		-- add players to targets
		for _,target in pairs(player.GetHumans()) do
			local decision = PlayerCanSeePlayersChat( msg, teamchat, ply, target, localchat )

			-- default to yes
			if decision or decision == nil then
				table.insert(targets,target)
			end
		end
		
		if #targets==0 then return end
		
		net.Start(Tag)
			net.WriteUInt(ply:UserID(),16)
			net.WriteString(msg)
			net.WriteBit(tobool(teamchat))
			net.WriteBit(tobool(localchat))
		net.Send(targets)

	end

	-- Receiving
	function ReceiveChatMessage( ply, msg, teamchat, localchat )
		-- Receives raw data. Check if any of it is valid.
		if not ValidMessage ( msg ) then return false end

		if msg:len() > 400 then
			msg = msg:Left(400)
		end
		
		-- Anti spam
		if SpamWatch( ply, msg ) then
			return false
		end

		local result = hook.Call("PlayerSay", GAMEMODE, ply, msg, teamchat, localchat)
		if result == true then -- Kill the message
			return result
		elseif result == false then
			-- Let the message pass
		elseif type(result) == "string" then -- Replace the message
			if not ValidMessage ( result ) then return result end
			msg = result
		end

		-- Print to Console
		local print=_print or print -- EPOE workaround..
		local Msg=_Msg or Msg -- EPOE workaround..
		Msg(ply:Name())
		if teamchat then Msg" (Team)" end
		if localchat then Msg" (Local)" end
		print(": ".. msg)

		SendChatMessage( ply, msg, teamchat, localchat )

	end

	net.Receive(Tag,function(len,ply)
		if len > 4096 then ply:PrintMessage(3, 'Слишком длинное сообщение!') return end
		local msg = net.ReadString() -- no null bytes. Is this bad?
		local teamchat = tobool(net.ReadBit()) -- no null bytes. Is this bad?
		local localchat = tobool(net.ReadBit()) -- no null bytes. Is this bad?
		ReceiveChatMessage( ply, msg, teamchat, localchat )
	end)

	return

elseif CLIENT then

	-- Sending
	
	local function urlencode(str)
		if (str) then
			str = string.gsub (str, "\n", "\r\n")
			str = string.gsub (str, "([^%w ])",
				function (c) return string.format ("%%%02X", string.byte(c)) end)
			str = string.gsub (str, " ", "+")
		end
		return str
	end
	

	function SendChatMessage(msg,teamchat,localchat)
		if not ValidMessage ( msg ) then return false end

		if msg:len() > 4000 then
			msg = msg:Left(4000)
		end

		if msg:find("\0",1,true) then
			ErrorNoHalt("Null byte on chat message, unhandled!")
		end

		if troptions and troptions.enable and troptions.to and not troptions.suppress and not msg:sub(1,1):find("%p") then
			local url = "http://meta-gmod-ingametranslate.appspot.com/?from="..urlencode(troptions.from).."&to="..urlencode(troptions.to).."&str="..urlencode(msg)
			http.Fetch(url, function(html)
				troptions.suppress = true
				if not string.find(html,"<title>Internal Server Error", 1, true) then
					if troptions.show_original then
						html = html .. " ( " .. msg .. " )"
					end
					SendChatMessage(html, teamchat, localchat)
				else
					SendChatMessage(msg .. " ( translation failed! )", teamchat, localchat)
				end
				troptions.suppress = false
			end)
			return
		end
		
		--  This isn't in the specs but it is now :|
		local result = hook.Call("PlayerSay", GAMEMODE, LocalPlayer(), msg, teamchat, localchat)
		if result == true then -- Kill the message
			return false
		elseif result == false then -- Let the message pass
		elseif type(result) == "string" then -- Replace the message
			msg = result
		end
		
		if not ValidMessage ( msg ) then return false end
		
		
		local ok,err=pcall(function()
			net.Start(Tag)
				net.WriteString(msg)
				net.WriteBit(tobool(teamchat))
				net.WriteBit(tobool(localchat))
			net.SendToServer()
		end)
		if not ok then
			RunConsoleCommand("say",msg)
			ErrorNoHalt("Using legacy say because: "..err.."\n")
		end
	end


	-- Receiving

	function ReceiveChatMessage( ply, msg, teamchat, localchat )

		if teamchat==nil then
			teamchat=false
		end
		
		if troptions and troptions.enable and troptions.to and troptions.reverse_incoming and not troptions.suppress and ply ~= LocalPlayer() then
			local url = "http://meta-gmod-ingametranslate.appspot.com/?from="..urlencode(troptions.to).."&to="..urlencode(troptions.from).."&str="..urlencode(msg)
			http.Fetch(url, function(html)
				if ply:IsValid() then
					troptions.suppress = true
					if not string.find(html,"<title>Internal Server Error", 1, true) then
						if troptions.show_original then
							html = html .. " ( " .. msg .. " )"
						end
						ReceiveChatMessage(ply, html, teamchat, localchat)
					else
						ReceiveChatMessage(ply, msg .. " ( translation failed! )", teamchat, localchat)
					end
					troptions.suppress = false
				end
			end)
			return
		end

		hook.Call( "OnPlayerChat", GAMEMODE, ply, msg, teamchat, !ply:Alive(), localchat )

	end

	function ReceivedData( data, retrycount )
		local plyid 	 = data[1]
		local msg   	 = data[2]
		local teamchat   = data[3]
		local localchat  = data[4]

		local ply = UserIDToPly( plyid )

		-- Players do not exist immediatelly. TODO: Wait for them to exist.
		-- Fixed: Players may also vanish.
		-- Need event based team color changes and player nick caching
		-- see: gameevent.Listen
		
		if not IsValid( ply ) or not ply:IsPlayer() then

			retrycount = retrycount or 0

			if retrycount > 40 then
				Msg("WARNING: Player ",plyid," sent message '",msg,"' but is now vanished!\n")
				chat.AddText(Color(255,100,100),"Disconnected player: ",player.UserIDToName and player.UserIDToName(plyid) or tostring(plyid),Color(255,255,255,255),": "..tostring(msg))
				return
			end

			--Msg("["..Tag.."] ")print("Retrying finding player...",plyid)
			timer.Simple(0.25,function() -- delayed recurse
				ReceivedData( data, retrycount + 1 )
			end)

			return

		end

		ReceiveChatMessage(ply, msg, teamchat, localchat)

	end

	
	net.Receive( Tag, function ( len, ply )
	
		local data = {
			[1]=net.ReadUInt(16),
			[2]=net.ReadString(),
			[3]=tobool(net.ReadBit()),
			[4]=tobool(net.ReadBit()),
		}

		ReceivedData( data )

	end )

end





