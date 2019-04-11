local Tag="chatbox"
module(Tag,package.seeall)

if SERVER then AddCSLuaFile() return end

local chat_timestamps_history = CreateClientConVar("chat_timestamps_history", "0",true,false)
local chatbox_nickcomplete = CreateClientConVar("chatbox_nickcomplete", "1",true,false)
local chatbox_use_peek = CreateClientConVar("chatbox_use_peek", "1",true,false)
local chatbox_show_ime = CreateClientConVar("chatbox_show_ime", "1",true,false)
local chatbox_history_font = CreateClientConVar("chatbox_history_font", "DermaDefault",true,false)
local chatbox_links_to_clipboard = CreateClientConVar("chatbox_links_to_clipboard","1",true)

LINK_CLICKED = -3

local IME_Languages =
{
	KO = true,
	KR = true,
	JP = true,
	CH = true,
}
local country = system.GetCountry()
local need_ime = IME_Languages[country]

local chatmodes={
	{"Say"},
	{"Say (TEAM)"},
	{"Local Chat"},
	{"Voice"},
	{"Console"},
	{"Translate"},
}
local curmode=1
function SetChatMode(mode)
	--debug.Trace()
	--print("SetChatMode",mode)
	if mode == nil or mode == false then
		curmode=curmode + 1
		if not chatmodes[curmode] then
			curmode = 1
		end
	elseif mode == true then
		curmode=curmode - 1
		if not chatmodes[curmode] then
			curmode = #chatmodes
		end
	else
		local set
		for k,v in pairs(chatmodes) do
			if mode==v or mode==k then
				set=true
				curmode=k
				break
			end
		end
		if not set then
			debug.Trace()
			ErrorNoHalt("Invalid mode "..tostring(mode)..'\n')
		end
	end
	return curmode,chatmodes[curmode]
end



function GetChatMode()
	return curmode,chatmodes[curmode]
end

local PANEL={}
	AccessorFunc(PANEL,"m_pHost","Host")
	function PANEL:Init()

		
		self.__tabbing = false
		
		
		local container=vgui.Create('EditablePanel',self)
		container:Dock(BOTTOM)
		container:SetTall(15)
		self.chatinputcontainer = container
		
		
		-- Mode button to change chat modes
		
		local modebutton=vgui.Create('DButton',container)
		modebutton:Dock(LEFT)
		modebutton:SetWide(64)
		modebutton:SetText"Chat"
		modebutton:SizeToContents()
		modebutton:SetWide(modebutton:GetWide()+5)
		
		modebutton.Paint=function(modebutton,w,h)
			DButton.Paint(modebutton,w,h)
			if modebutton.__special then
				surface.SetDrawColor(255,123,111,111)
				surface.DrawRect(0,0,w,h)
			end
		end
	
		local function SetTxt(txt)
			modebutton:SetText(txt)
			modebutton:SizeToContents()
			modebutton:SetWide(modebutton:GetWide()+5)
			self.ChatText:RequestFocus()
		end
		modebutton.Think=function(modebutton)
		
			local m,d=GetChatMode()
			if modebutton.lastmode~=m then
				modebutton.lastmode=m
				modebutton.__special = m ~= 1
				SetTxt(d[1])
			end
			
		end
		modebutton.OnMousePressed=function(modebutton,mc)
			if mc==MOUSE_LEFT then
				SetChatMode()
			else
				local m=DermaMenu()
				for k,v in pairs(chatmodes) do
					local name=v[1]
					if name == "Translate" then
						m:AddOption(name,function()
							OpenTranslateOptions()
						end)
					else
						m:AddOption(name,function()
							SetChatMode(v)
						end)
					end
				end
				m:Open()
			end
		end
		
		-- Chat text input
		
		self.ChatText = vgui.Create("DTextEntry", container)
		local ChatText = self.ChatText
		ChatText:SetEnterAllowed(true)
		--ChatText:SetTall(15)
		ChatText:SetHistoryEnabled(true)
		ChatText.m_bHistory=true
		ChatText.undos={}
		ChatText:SetDrawBorder(false)
		
		ChatText.m_bLoseFocusOnClickAway = false
		ChatText:SetDrawBackground(false)
		ChatText:SetTextColor(35,35,35,255)
		
		-- multiline for word wrapping, but no multiline text allowed, for now
		ChatText:SetMultiline(true)
			
		local ent1,ent2,ent3 = Color(35, 35, 35,255), Color(30, 130, 255,255), Color(35,35,35,255)
		local invis=Color(255,255,255,1)
		
		local changing
		ChatText.Paint = function(ChatText,w,h)
			
			
			local host = self:GetHost()
			local f = host and host:GetAlphaFrac() or 1
			
			local hb = ChatText.historybrowse
			surface.SetDrawColor(hb and 240 or 255,hb and 200 or 255,hb and 150 or 255,f*255)
			surface.DrawRect(1,1,w-2,h-2)
		
			local show_ime = true
			if _G.CHATBOX_FORCE_IME==nil then
				local chatbox_show_ime = chatbox_show_ime:GetInt()
				if chatbox_show_ime == 2 then
					show_ime = false
				elseif chatbox_show_ime == 0 then
					show_ime = need_ime
				end
			end

			if not show_ime then
                ChatText:SetAllowNonAsciiCharacters(false)
            end
			
			-- nop basically
			surface.SetFont"chatfont"
			
			ChatText:DrawTextEntryText(ent1,ent2,ent3)
			
			if not show_ime then
                ChatText:SetAllowNonAsciiCharacters(true)
            end
			
			local peek = ChatText.peek
			if peek then
				
				-- hack to get correct peek position with IME
				if show_ime then
					ChatText:SetAllowNonAsciiCharacters(false)
					surface.SetFont"chatfont"
					ChatText:DrawTextEntryText(invis,invis,invis)
					ChatText:SetAllowNonAsciiCharacters(true)
				end
				
				if #peek<2 then
					surface.SetTextColor(255,100,10,255)
				else
					surface.SetTextColor(120,120,220,255)
				end
				surface.DrawText(peek)
			end
			
			if ChatText.recalc_height then
				local msg = ChatText:GetValue()
				local tw,th = surface.GetTextSize(msg)
				ChatText.recalc_height = false
				if tw>w then
					local count = tw/w
					count=math.ceil(count)
					count=count<2 and 2 or count>10 and 10 or count
					local tall = th*count + 4
					local _,maxtall = self:GetSize()
					tall = tall>maxtall and maxtall or tall
					ChatText:GetParent():SetTall(tall)
					ChatText.multiline = true
				else
					ChatText:GetParent():SetTall(th + 4)
					ChatText.multiline = false
				end
			end
			
			return true
		end
		
		function ChatText.OnLoseFocus(ChatText)
		end
		
		-- inf loop?
		function ChatText:PerformLayout()
			ChatText.recalc_height = true
		end
		
		function ChatText:Think()
			if self.nolosefocus then
				self:RequestFocus()
				self.nolosefocus = false
			end
			if self.setshit then
				local t = self.setshit
				self.setshit = nil
				local msg = t[1]
				local pos = t[2]
				self:SetText(msg)
				self:SetCaretPos(pos)
				self:OnTextChanged()
				
			end
			if self.newfont then
				local font = self.newfont
				self.newfont = nil
				self:SetFont(font)
				self:SetFontInternal(font)
			end
		end
		
		function ChatText:DoUndo()
			local len = #self.undos
			self.undos[len] = nil
			local t = self.undos[len-1]
			--local msg=t and t[1] or ""
			--local pos=t and t[2] or 0
			self.setshit = t or {"",0}
			--self:SetText(msg)
			--self:SetCaretPos(pos)
			--self:OnTextChanged()
		end
		
		function ChatText:AddUndo(msg)
			local pos = self:GetCaretPos()
			local len = #self.undos
			if len>40 then -- my god
				table.remove(self.undos,1)
				len=len-1
			end
			
			local prev = self.undos[len]
			
			if prev and prev[1] == msg then
				return
			end
			
			local t = {msg,pos}
			table.insert(self.undos,t)
		end
		
		ChatText.HistoryUp=function(ChatText,down)
			
			ChatText.HistoryPos = ChatText.HistoryPos + (down and -1 or 1)
			
			if not ChatText.historybrowse then
				ChatText.oldtext = ChatText:GetValue()
			end
			
			ChatText:UpdateFromHistory()
			
			ChatText.historybrowse = true
			
			local new = ChatText.HistoryPos
			if new == 0 then
				ChatText:SetText(ChatText.oldtext or "")
				ChatText:SetCaretPos((ChatText.oldtext or ""):len())
				ChatText.oldtext = false
				ChatText.historybrowse = false
			end
					
		end
		function ChatText.OnKeyCodeTyped( ChatText, code )
			local LCONTROL = input.IsKeyDown(KEY_LCONTROL)
			
			if code==KEY_Z and LCONTROL then
				ChatText:DoUndo()
			end

			if code==KEY_BACKSPACE and LCONTROL then
				ChatText:SetText(ChatText:GetText():match("(.-)%S+") or ChatText:GetText():sub(1, -2))
			end
			
			if code == KEY_ENTER then
				self.ChatText:OnEnter(LCONTROL)
				if LCONTROL then return true end
			end
			
			if code==KEY_TAB then
				ChatText.nolosefocus = true -- think hax
				
				local txt = self.ChatText:GetText()
				if txt=="" then
					SetChatMode(input.IsKeyDown(KEY_LSHIFT) or LCONTROL)
					return
				end
				
				local str,caretpos = self:ChatComplete()
				if str then
					self.ChatText:SetText( str )
					if tonumber(caretpos) then
						self.ChatText:SetCaretPos(caretpos)
					else
						local _, length = str:gsub('[^\128-\191]', '') -- not good
						self.ChatText:SetCaretPos(length)
					end
					
					local completed_foreign = self.completed_foreign
					self.ChatText:OnTextChanged()
					self.completed_foreign = completed_foreign
				end
			end
			
			if ChatText.m_bHistory and (code == KEY_UP or code == KEY_DOWN) then
				local can = input.IsKeyDown(KEY_LALT) or not ChatText.multiline or ChatText.historybrowse
				if can then
					ChatText:HistoryUp(code==KEY_UP)
				end
			end
			
		end
		--ChatText:SetDrawBackground(false)
		ChatText:SetDrawLanguageIDAtLeft(false)
		ChatText:SetTextColor(color_black)
		ChatText:SetDrawBorder(true)
		ChatText:Dock(FILL)
		ChatText:SetAllowNonAsciiCharacters(true)
		ChatText.CanChat = true

		local staticCmds = {
			["/stuck"] = true,
			["/unstuck"] = true,
			["!stuck"] = true,
			["!unstuck"] = true,
		}
		
		ChatText.OnEnter = function(ChatText,lcontrol)
			
			local function closeIt()
				local host = self:GetHost()
				if host and host.Close then
					host:Close()
				else
					ChatText.CanChat = true
				end
			end

			-- Fixes double enter problems
			if lcontrol then return end
			if ChatText.CanChat then
				ChatText.CanChat = false
			
				local msg = ChatText:GetValue()
				if ValidMessage( msg ) then
				
					if staticCmds[msg] then
						RunConsoleCommand("srp_unstuck")
						return closeIt()
					elseif (msg:sub(1,1) == "@" or msg:sub(1,2) == "!a") and msg:find('застрял') then
						RunConsoleCommand("srp_unstuck")
						SendChatMessage( "А я и не знал, что тут есть команда !stuck", curmode == 2, curmode == 3 )
						return closeIt()
					end
				
					self.ChatText:AddHistory(msg)
					if curmode == 5 then
						LocalPlayer():ConCommand(msg)
					elseif curmode == 4 then
						RunConsoleCommand("saysound",msg) -- todo: netmsg for longer says...
					else
						SendChatMessage( msg, curmode == 2, curmode == 3 )
					end
				end
			end
			
			closeIt()

		end

		function ChatText.OnTextChanged(ChatText)
			local msg = ChatText:GetValue()
			
			if ChatText.intextchange then return end
			ChatText.recalc_height = true
			if ChatText.historybrowse then
				ChatText.historybrowse = false
			end
			
			if msg:find("\n",1,true) then
				local msg_replaced = msg:gsub("\n"," ")
				msg = msg_replaced
				ChatText.intextchange = true
					ChatText:SetText(msg)
					ChatText:SetCaretPos(#msg)
				ChatText.intextchange = false
			end
			
			
			if self.completed_foreign then
				--print("	unsetting completed_foreign")
				self.completed_foreign = false
			end
			
			ChatText:AddUndo(msg)
			
			local peek = msg~="" and (self:CustomComplete(msg,true) or hook.Call("OnChatTab",nil,msg,true))
			if peek and peek~=msg then
				self:SetPeek(peek,msg)
			else
				self:SetPeek(false)
			end
			
			hook.Call("ChatTextChanged", GAMEMODE, msg)
		end

		function ChatText.OnFocusChanged(ChatText,gained)
			if gained then
				ChatText:OnTextChanged()
			end
		end
		
		-- Chat log RichText control
		
		local ChatLog = vgui.Create("RichTextX", self)
		self.ChatLog = ChatLog
		
		ChatLog:Dock(FILL)
		ChatLog:SetFont'ChatFont'
		local i=50
		ChatLog.Paint = function(ChatLog,w,h)
			
			local host = self:GetHost()
			local f = host and host:GetAlphaFrac() or 1
			surface.SetDrawColor(35,34,33,f*245)
			surface.DrawRect(0,0,w,h)
			
		end
		
		function ChatLog:PrintTime()
			if not chat_timestamps_history:GetBool() then return end
			
			local time = os.date '*t'

			self:InsertColorChange( 118, 170, 217, 255 )
			self:AppendText( Format("%.2d:%.2d", time.hour, time.min) )
			self:InsertColorChange(  255, 255, 255, 255)
			self:AppendText( " - " )
			
			
		end
		
		function ChatLog.OnThink()
			
			i=i+1
			
			if i>66 then
				
				local new = chatbox_history_font:GetString()
				local font = ChatLog._updatefont -- ChatLog:GetFont() -- TODO
				if new ~= font then
					ChatLog:SetFont(new)
				end
				i=0
				
			end
		end
		
		function ChatLog.OnTab()
			self.ChatText:RequestFocus()
			self.ChatText.nolosefocus = true
		end
		
		function ChatLog:OnReady()
			self:InsertColorChange(255,255,255,255)
			ChatLog:SetFont(chatbox_history_font:GetString())
		end
		ChatLog:OnReady()
		
		function ChatLog:OnURL(url)
			if not chatbox_links_to_clipboard:GetBool() then return end
			SetClipboardText(url)
		end
		
	end
	

	function PANEL:SetMode(mode)
		--print("SetMode",mode)
		SetChatMode(mode)
		self:OnActivatedPanel()
	end
	
	function PANEL:OnActivatedPanel(prev)
		self.ChatText:RequestFocus()
		self.ChatText.nolosefocus = true
		
		local font = GetInputFont()
		if font==self.lastifont then return end
		surface.SetFont(font)
		local w,h = surface.GetTextSize("W")
		self.ChatText.newfont = font
		self.chatinputcontainer:SetTall(h*2+4)
		self:InvalidateLayout()
		self.ChatText:InvalidateLayout(true)
		self.lastifont = font
	end
	
	function PANEL:Think()
	
		if not self.__hack then
			self.__hack=true
			if ValidPanel(self.ChatLog) then
				self.ChatLog:GotoTextEnd()
			end
		end
		
	end

	function PANEL:Paint(w,h)
	end
	
	function PANEL:SetPeek(peek,written)
		if not peek or not chatbox_use_peek:GetBool() then
			self.ChatText.peek = false
			return
		end
		
		local start,stop = string.find(peek:lower(),written:lower(),1,true)
		if start == 1 then
			peek=peek:sub(stop+1,-1)
			--self.ChatText.nopeek = peek:sub(1,stop)
		else
			peek=' << '..peek..' >>'
		end
				
		self.ChatText.peek=peek
	end
	
	function PANEL:Reset()
		self.ChatLog:GotoTextEnd()
		self.ChatText.HistoryPos = 0
		self.ChatText:SetText""
		self.ChatText.CanChat = true
		self.ChatText.historybrowse = false
		self.ChatText.undos = {}
		self.completed_foreign = false
		self.__hack = false
		
	end

	
-- Custom chat autocomplete

	local lastindex=1
	local completelist
	local originalstr
	local justchanged=false
	local function Change()
		justchanged=true
		timer.Simple(0,function()
			timer.Simple(0,function()
				justchanged = false
			end)
		end)
	end
	
	local function IsSteamIDFriend(sid)
		return util.IsSteamIDFriend and util.IsSteamIDFriend(sid) or sid=="76561198018728441"
	end
	
	local function GetACPlayers()
		
		local t={}
		
		if crosschat and crosschat.serverdata then
			for _,server in next,crosschat.serverdata do
				for k,pl in next,server.players do
					if not pl.left then
						table.insert(t,{pl.Name,IsSteamIDFriend(pl.SteamID64),pl.UserID})
					end
				end
			end
		end
		
		local me = LocalPlayer()
		for _,pl in next,player.GetHumans() do
			if pl~=me then
				table.insert(t,{pl:Nick(),pl:GetFriendStatus()=="friend",pl:UserID()})
			end
		end
		
		
		
		table.sort(t, function(a, b)
				
			if a[2]!=b[2] then
				return a[2] and not b[2]
			end
			
			return a[3] < b[3]
		end)
		
		--PrintTable(t)
		
		return t
	end
	
	
	function PANEL:CustomComplete(str,peek)
		if completelist then
			lastindex=lastindex + (peek and 0 or 1)
			local fuuuck
			if not completelist[lastindex] then
				lastindex = 0
				return originalstr,true
			end
			local ret=completelist and completelist[lastindex]
			if not completelist then ret=fuuuck or ret end
			Change()
			return ret
		else
			originalstr=str
		end
			
		local word
		for w in str:gmatch "[^%s%c]+" do
			word = w
		end
		
		--if not peek then print("AC",word) end
		
		if word and word:len()>=1 then
		
			local startpos = 0 -- position where the string begins. UGH HACKY
			while true do
			  local i = string.find(str, word, startpos+1,1,true)
			  if i == nil then break end
			  startpos = i
			end
			local word_len = word:len()
			for _, pl in next,GetACPlayers() do
				local nick = pl[1]
				
				if word_len < nick:len() and nick:lower():find( word:lower(),1,true ) == 1 then
					local str_res = str:sub( 1, startpos-1).. nick
					
					if peek then
						return str_res
					end
						completelist = completelist or {}
					table.insert(completelist,str_res)
		 
				end
		 
			end
		end
		if not completelist then
			return
		elseif #completelist>0 then
			lastindex=1
			Change()
			return completelist[1]
		end
		
		completelist=nil
	 
	end

	function PANEL:ChatComplete()
		local str = self.ChatText:GetText()
		local nick_complete = chatbox_nickcomplete:GetBool()
		local completed_foreign = self.completed_foreign
		local nick_completed
		local notfound
		if nick_complete and not completed_foreign then
			nick_completed,notfound = self:CustomComplete(str)
			if notfound then -- old str
				--print("resetting to",nick_completed)
				str = nick_completed or str
				nick_completed = false
				hook.Call("ChatTextChanged", nil, str) -- HACK
			end
			
			--print("was not completed_foreign so CustomComplete for '"..str.."'",
			--nick_completed=="" and "EMPTY" or nick_completed==str and "UNCHANGE" or nick_completed and ("valid='"..tostring(nick_completed).."'") or "invalid",notfound and "notfound" or "")
		end
		
		-- gamemode is not consulted since we have our
		-- own implementation unless our implementation is not consulted :v:
		local GM=not nick_complete and GAMEMODE
		
		local result
		local caretpos
		if not nick_completed or notfound then
			local ret,newcaretpos = hook.Call("OnChatTab",GM,str)
			--print("OnChatTab",str=="" and "EMPTY" or str or "NIL","==",ret=="" and "EMPT" or ret or "NIL")
			if ret and ret~=str then
				--print("setting completed_foreign")
				self.completed_foreign = true
				--print("RET",ret)
				result = ret
				caretpos = tonumber(newcaretpos)
			end
		else
			--print("COMP",nick_completed)
			result = nick_completed
		end
		
	
		--???? if result==str then return end
		
		--hook.Call("ChatTextChanged", GAMEMODE, result)

		--print("result",result or "NIL")
		return type(result)=="string" and result or str,caretpos
	end
	hook.Add("ChatTextChanged",Tag,function( text )
		if justchanged then return end
		completelist = nil
	end)


vgui.Register( Tag..'_chat', PANEL, "DPanel" )