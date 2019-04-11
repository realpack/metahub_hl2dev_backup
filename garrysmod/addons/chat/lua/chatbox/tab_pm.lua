local Tag="chatbox"

module(Tag,package.seeall)



if SERVER then AddCSLuaFile() return end





local chatbox_history_font = CreateClientConVar("chatbox_history_font", "ChatFont",true,false)



--- HELPER ---

local function CheckFor(tbl,a,b)

    local a_len=#a

    local res,endpos=true,1

    while res and endpos < a_len do

        res,endpos=a:find(b,endpos)

        if res then

            tbl[#tbl+1]={res,endpos}

        end

    end

end

local function AppendTextLink(a,callback)



	local result={}

	CheckFor(result,a,"https?://[^%s%\"]+")

	CheckFor(result,a,"ftp://[^%s%\"]+")

	CheckFor(result,a,"steam://[^%s%\"]+")



	--todo

	--CheckFor(result,a,"^www%.[^%s%\"]+")

	--CheckFor(result,a,"[^%s%\"]www%.[^%s%\"]+")



	if #result == 0 then return false end



	table.sort(result,function(a,b) return a[1]<b[1] end)



	-- Fix overlaps

	local _l,_r

	for k,tbl in pairs(result) do



		local l,r=tbl[1],tbl[2]



		if not _l then

			_l,_r=tbl[1],tbl[2]

			continue

		end



		if l<_r then table.remove(result,k) end



		_l,_r=tbl[1],tbl[2]

	end



	local function TEX(str) callback(false,str) end

	local function LNK(str) callback(true,str) end



	local offset=1

	local right

	for _,tbl in pairs(result) do

		local l,r=tbl[1],tbl[2]

		local link=a:sub(l,r)

		local left=a:sub(offset,l-1)

		right=a:sub(r+1,-1)

		offset=r+1

		TEX(left)

		LNK(link)

	end

	TEX(right)

	return true

end

--------------



local chat_timestamps_history = CreateClientConVar("chat_timestamps_history", "0",true,false)



local PANEL={} -- chat history panel



function PANEL:Link(parent,data)

	self.parent = parent

	self.data = data

	self:PostInit()

end





function PANEL:PostInit()

	self.ChatLog = vgui.Create("RichText", self)

	self.ChatLog:SetMultiline(true)

	self.ChatLog:GotoTextEnd()

	self.ChatLog:SetPaintBorderEnabled( false )

	self.ChatLog:SetPaintBackgroundEnabled( false )

	self.ChatLog:SetFontInternal'ChatFont'

	

	self.ChatLog.OnKeyCodePressed = function (ChatLog,key,...)

		if key==KEY_TAB then

			self.parent:ActivateChat(self.parent:GetActiveChat())

		end

	end

	

	local i=67

	self.ChatLog.Paint=function(ChatLog,w,h)

		

		surface.SetDrawColor(35,34,33,245)

		surface.DrawRect(0,0,w,h)

		

		i=i+1

		if i>66 then

			ChatLog:SetFontInternal(chatbox_history_font:GetString())

			i=0

		end

	end

	

	self.ChatLog:InsertColorChange(255,255,255,255)

	timer.Simple(0,function()

		self.ChatLog.InsertColorChange(self.ChatLog,255,255,255,255)

	end)

	

	self.ChatLog:Dock(FILL)

	

	-- Chatbox link support the hacky way

	self.ChatLog.AddLink=function(richtext,func,func2)

		richtext.__links=richtext.__links or {}

		local id = table.insert(richtext.__links,func2)

		richtext.__links[id]=func2



		richtext:InsertClickableTextStart("callback___"..tostring(id))

		func(richtext)

		richtext:InsertClickableTextEnd()

	end

	function self.ChatLog.ActionSignal(richtext,key,value)

		if key~="TextClicked" then return end



		local id = value:match("callback___(.+)",1,true)

		id=tonumber(id)

		local callback = id and richtext.__links[id]

		if callback then

			callback(richtext,value)

			return

		end

		if hook.Call("ChatBoxAction",nil,CHAT_PM_CB or -5,key,value)==nil then

			gui.OpenURL(value)

		end

	end







	-- We don't want a newline appended right away so we hack it up..

	local appendNL=false

	local AppendText=self.ChatLog.AppendText

	function self.ChatLog:AppendText(txt)

		if appendNL then

			AppendText(self,"\n")

		end

		if txt:sub(-1)=="\n" then

			appendNL=true

			txt = txt:sub(1,txt:len()-1)

		else

			appendNL=false

		end

		AppendText(self,txt)

	end



	local InsertColorChange=self.ChatLog.InsertColorChange

	function self.ChatLog:InsertColorChange(r,g,b)

		InsertColorChange(self,r,g,b,255)

		self.lr = r

		self.lg = g

		self.lb = b

	end



	function self.ChatLog:ResetLastColor(r,g,b)

		local r = self.lr or r or 255

		local g = self.lg or g or 255

		local b = self.lb or b or 255

		self:InsertColorChange(r,g,b,255)

	end

	

	function self.ChatLog:PrintTime()

		if not chat_timestamps_history:GetBool() then return end

		

		local time = os.date '*t'



		self:InsertColorChange( 118, 170, 217, 255 )

		self:AppendText( Format("%.2d:%.2d", time.hour, time.min) )

		self:InsertColorChange(  255, 255, 255, 255)

		self:AppendText( " - " )

		

		

	end



	function self.ChatLog:AppendTextX(txt)

		local function func(link,txt)

			if txt:len()==0 then return end

			if link then

				self:InsertClickableTextStart(txt)

				self:ResetLastColor(255,255,255) -- cheats.

			end

			self:AppendText(txt)

			if link then

				self:InsertClickableTextEnd()

			end

		end



		local res = AppendTextLink(txt,func)

		if not res then

			self:AppendText(txt)

		end

	end

end



function PANEL:Think()



	if not self.__hacked then

		self.__hacked=true

		if ValidPanel(self.ChatLog) then

			self.ChatLog:GotoTextEnd()

		end

	end

	

end



function PANEL:Paint(w,h)

end



function PANEL:Reset()

	self.__hacked = false

end





local PlayerColors = {

	["0"] = Color(0,0,0),

	["1"] = Color(255, 0, 0),

	["2"] = Color(0, 255, 0),

	["3"] = Color(255, 255, 0),

	["4"] = Color(0, 0, 255),

	["5"] = Color(0, 255, 255),

	["6"] = Color(255, 0, 255),

	["7"] = Color(255, 255, 255),

	["r"] = Color(255, 0, 0),

	["g"] = Color(0, 255, 0),

	["b"] = Color(0, 0, 255),

	["w"] = Color(255, 255, 255),

	["c"] = Color(0, 255, 255),

	["m"] = Color(255, 0, 255),

	["y"] = Color(255, 255, 0),

	["k"] = Color(0, 0, 0)

}



local colors = {

	["red"] = Color(255, 0, 0),

	["green"] = Color(0, 255, 0),

	["blue"] = Color(0, 0, 255),

	["yellow"] = Color(255, 255, 0),

	["black"]= Color(0, 0, 0),

	["white"] = Color(255, 255, 255),

	["grey"] = Color(115, 115, 115),

	["gray"] = Color(115, 115, 115), -- for the american spelling

	["lightblue"] = Color(152, 245, 255),

	["aqua"] = Color(127, 255, 212),

	["orange"] = Color(255,165,0),

	["purple"] = Color(127, 0, 255),

	["lightgreen"] = Color(202, 255, 112),

	["pink"] = Color(255, 20, 147),

	["darkred"] = Color(139, 26, 26)

}



function PANEL:ParseName(newtbl,v)

	local found = v:find("%^(%w)")

	if not found then

		self.ChatLog:AppendText(v)

		table.insert(newtbl, v)

	elseif found and found > 1 then

		self.ChatLog:AppendText(v:sub(1, found - 1))

		table.insert(newtbl, v:sub(1, found - 1))

	end



	for n,s in v:gmatch("%^(%w)([^%^]+)") do

		if PlayerColors[n] then

			local cv = PlayerColors[n]

			self.ChatLog:InsertColorChange(cv.r, cv.g, cv.b, 255)

			self.ChatLog:AppendText( s )

			table.insert(newtbl, cv)

			table.insert(newtbl, s)

		end

	end

end



function PANEL:ProcessAddText(...)

	local newtbl={}

	

	self.ChatLog:PrintTime()

	

	for n=1,select('#',...) do

		local v = select(n,...)

		if( type(v) == "Player" ) then

			if IsValid(v)  and IsValid(LocalPlayer()) then

				local c = team.GetColor(v:Team())

				self.ChatLog:InsertColorChange(c.r, c.g, c.b, 255)

				table.insert(newtbl, c)

				self:ParseName(newtbl,v:GetName())

				self.ChatLog:InsertColorChange(151, 211, 255, 255)

				table.insert(newtbl, Color(151, 211, 255, 255))

			else

				table.insert(newtbl, "???")

			end

		elseif( type(v) == "table" ) then



			if( v.r ~= nil and v.g ~= nil and v.b ~= nil ) then



				self.ChatLog:InsertColorChange(v.r, v.g, v.b, 255)

				table.insert(newtbl, v)



			end

		else

			self.ChatLog:AppendTextX(tostring(v))

			table.insert(newtbl,tostring(v))

		end

		

	end



	self.ChatLog:AppendText("\n")

	return newtbl

end







function PANEL:Sent(text,to)

		local tbl = {}



		local ply = LocalPlayer()

		table.insert( tbl, ply )



		-- local metext = text:match("^[!/.]me (.*)") or text:match("^*(.*)*$")

		-- local ittext = text:match("^[!/.]it (.*)")



		-- if metext then

		-- 	if IsValid(ply) and ply:IsPlayer() then

		-- 		table.insert( tbl, team.GetColor( ply:Team() ) )

		-- 	end

		-- 	table.insert( tbl, " " .. metext )

		-- elseif ittext then

		-- 	tbl = {}

		-- 	if IsValid(ply) and ply:IsPlayer() then

		-- 		table.insert( tbl, team.GetColor( ply:Team() ) )

		-- 	end

		-- 	table.insert( tbl, "" .. ittext )

		-- else

			table.insert( tbl, Color( 255, 255, 255 ) )

			table.insert( tbl, ": " .. text )


		if chat.AddTimeStamp then chat.AddTimeStamp(tbl) end

			

		self:ProcessAddText(unpack(tbl))

	

end



function PANEL:Received(text,from)

	local tbl = {}

	

	local data = self.data

	assert(data)

	

	local ply = self.parent:GetPlayerEntity(data)

	local name = IsValid(ply) and ply:Name() or self.parent:GetPlayerName(data)

	

	if IsValid(ply) then

		table.insert( tbl, ply )

	else

		table.insert( tbl, Color(255,255,255,255) )

		table.insert( tbl, name )

	end

	

	-- local metext = text:match("^[!/.]me (.*)") or text:match("^*(.*)*$")

	-- local ittext = text:match("^[!/.]it (.*)")



	-- if metext then

	-- 	if IsValid(ply) and ply:IsPlayer() then

	-- 		table.insert( tbl, team.GetColor( ply:Team() ) )

	-- 	end

	-- 	table.insert( tbl, " " .. metext )

	-- elseif ittext then

	-- 	tbl = {}

	-- 	if IsValid(ply) and ply:IsPlayer() then

	-- 		table.insert( tbl, team.GetColor( ply:Team() ) )

	-- 	end

	-- 	table.insert( tbl, "" .. ittext )

	-- else

		table.insert( tbl, Color( 255, 255, 255 ) )

		table.insert( tbl, ": " .. text )

	-- end



	if chat.AddTimeStamp then chat.AddTimeStamp(tbl) end

		

	self:ProcessAddText(unpack(tbl))

end





local chat_panel_factor = vgui.RegisterTable( PANEL, "DPanel" )















































local PANEL={} -- text entry

function PANEL:Link(parent)

	self.parent = parent

	self:PostInit()

end



function PANEL:Init()

	self:SetTall(24)

end



function PANEL:DoFont(font)

	if font==self.lastfont then return end

	self.ChatText:SetFont(font)

	surface.SetFont(font)

	local w,h = surface.GetTextSize("W")

	self:SetTall(h+4)

	self:InvalidateLayout()

	self.lastfont = font

end



function PANEL:PostInit()



	self.ChatText = vgui.Create("DTextEntry", self)

	local ChatText = self.ChatText

	ChatText:SetEnterAllowed(true)

	ChatText:Dock(FILL)

	ChatText:SetHistoryEnabled(true)

	ChatText.m_bHistory=true

	ChatText.undos={}

	ChatText:SetDrawBorder(false)

	ChatText.m_bLoseFocusOnClickAway = false

	ChatText:SetDrawBackground(false)

	ChatText:SetTextColor(35,35,35,255)

	ChatText:SetMultiline(false)



	local ent1,ent2,ent3 = Color(35, 35, 35,255), Color(30, 130, 255,255), Color(35,35,35,255)



	ChatText.Paint = function(entry,w,h)

		

		

		

		surface.SetDrawColor(255,255,255,255)

		surface.DrawRect(1,1,w-2,h-2)



		entry:DrawTextEntryText(ent1,ent2,ent3)



		local peek = entry.peek

		if peek then

			surface.SetTextColor(50,100,255,255)

			surface.DrawText(peek)

		end

		

		return true

	end

	

	function ChatText.OnLoseFocus(ChatText)

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

	end

	

	function ChatText:DoUndo()

		local len = #self.undos

		self.undos[len] = nil

		local t = self.undos[len-1]

		self.setshit = t or {"",0}

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

	

	ChatText.OnKeyCodeTyped = function( ChatText, code )

		if code==KEY_Z and input.IsKeyDown(KEY_LCONTROL) then

			ChatText:DoUndo()

		end

		

		if code == KEY_ENTER and not input.IsKeyDown(KEY_LCONTROL) then

			self.ChatText:OnEnter()

		end

		

		if code==KEY_TAB then

			ChatText.nolosefocus = true -- think hax

			

			local txt = self.ChatText:GetText()

			if txt=="" then

				return

			end

			

		end

		

		if ChatText.m_bHistory or IsValid( ChatText.Menu ) then



			if code == KEY_UP and not (input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_LCONTROL)) then

				ChatText.HistoryPos = ChatText.HistoryPos - 1;

				ChatText:UpdateFromHistory()

			end

			

			if code == KEY_DOWN and not (input.IsKeyDown(KEY_LSHIFT) or input.IsKeyDown(KEY_LCONTROL))  then

				ChatText.HistoryPos = ChatText.HistoryPos + 1;

				ChatText:UpdateFromHistory()

			end

		

		end

		

	end

--	ChatText:SetDrawBackground(false)

	ChatText:SetDrawLanguageIDAtLeft(true)

	ChatText:SetTextColor(color_black)

	ChatText:SetDrawBorder(true)

	ChatText:Dock(FILL)

	ChatText:SetAllowNonAsciiCharacters(true)



	ChatText.OnEnter = function(entry)

		

		local msg = entry:GetValue()

		

		if ValidMessage( msg ) then

			if self.parent:DoSend() then

				self.ChatText:AddHistory(msg)

				self.ChatText:SetText("")

			end

		end

	end



	function ChatText.OnTextChanged(ChatText)

		local msg = ChatText:GetValue()

		ChatText:AddUndo(msg)

	end



	function ChatText.OnFocusChanged(ChatText,gained)

		if gained then

			ChatText:OnTextChanged()

		end

	end

		

end



function PANEL:GetText()

	return self.ChatText:GetValue()

end

function PANEL:DoRequestFocus()

	--print("DoRequestFocus")

	self.ChatText:RequestFocus()

	self.ChatText.nolosefocus = true

	self.nolosefocus = true

end



local chat_entry_factor = vgui.RegisterTable( PANEL, "DPanel" )



































local PANEL={} -- pm tab



function PANEL:Init()



	self.data = {}



	self.container = vgui.Create('DPanel',self)

		local container = self.container

		container:Dock(TOP)

		container:SetTall(24)

		



		local b = vgui.Create("DButton", container)



		b:SetText( " New discussion with... " )

		b:Dock(LEFT)

		

		b:DockMargin(1,1,1,1)

		b:SizeToContents()

		b:SetWide( b:GetWide() + 1 )

		b.DoClick = function(b)

			

			self:RefreshState(true)

			

			local m = DermaMenu()

			local pls = player.GetAll()

			table.sort(pls, function(a, b)

				if a:GetFriendStatus() ~= b:GetFriendStatus() then

					return a:GetFriendStatus() == "friend"

				else

					return a:Name():lower() < b:Name():lower()

				end

			end)

			local chat_pm_friendsonly = GetConVar"chat_pm_friendsonly":GetBool()

			for k,v in next,pls do

				local sid = v:SteamID()

				if not self:GetData(sid) then

					local name = v:Name()

					local friend = v:GetFriendStatus() ~= "none"

					if chat_pm_friendsonly and not friend then

						continue

					end

					local herp = m:AddOption(name,function()

						self:GetPlDat(sid,false)

					end)

					if friend then

						herp:SetImage('icon16/user_green.png')

					end

				end

			end

			m:Open()

		end



		self.pl_buttons=vgui.Create('DHorizontalScroller',container)

			local pl_buttons=self.pl_buttons

			pl_buttons:Dock(FILL)

			pl_buttons:SetOverlap(-4)

			pl_buttons:DockMargin(2,1,1,1)

			

			pl_buttons.RemovePanel=function(self,pnl)

				for k,v in next,self.Panels do

					if v==pnl then

						local id = table.remove(self.Panels,k)

						self:InvalidateLayout(true)

						return id or true

					end

				end

			end

			

	local chat_entry = vgui.CreateFromTable(chat_entry_factor,self)

	chat_entry:Dock(BOTTOM)

	self.chat_entry = chat_entry

	chat_entry:Link(self)



	hook.Add("pmail",self,self._OnTransmission)

	

end



function PANEL:_OnTransmission(...)

	--print("PM",msg,to,sending and "ME SENDING" or "RECEIVED")

	local ok , err = xpcall(self.OnTransmission,debug.traceback,self,...)

	if not ok then

		ErrorNoHalt("PM Bug: "..tostring(err)..'\n')

		pcall(function()

			local data = self:GetActiveChat()

			if data then

				data.pnl:ProcessAddText(Color(255,0,0,255),"PM BUG:",Color(255,200,200,255)," "..tostring(err))

			end

		end)

	end

	

end



function PANEL:OnTransmission(msg,to,dat,sending)

	--print("PM",msg,to,sending and "ME SENDING" or "RECEIVED")



	if sending then

		self:Sent(msg,to)

	else

		self:Received(msg,to)

	end

	

end



function PANEL:Sent(msg,to)

	local data = self:GetPlDat(to)

	data.pnl:Sent(msg,to)

end



function PANEL:Received(msg,from)

	assert(from)

	assert(msg)

	

	local data = self:GetPlDat(from,true)

	assert(data.pnl.data)

	

	local active = self:GetActiveChat()

	if active~=data then

	end

		data.btn.high = true

	

	self:ActivateChat(data,true)

	

	data.pnl:Received(msg,from)

	

	self:RefreshState()

end







function PANEL:GetData(sid,create)

	if sid==nil then

		assert(not create)

		local k,v = next(self.data)

		return v,k

	end

	

	local dat = self.data[sid]

	if not dat and create then

		dat = {sid=sid,id=sid}

		self.data[sid]=dat

	end

	return dat

end



function PANEL:GetActiveChat()

	local data = self.activechat

	if data and data.pnl and data.pnl:IsValid() then

		return data

	end

end



function PANEL:Link(parent,tab)

	assert(parent)

	assert(tab)

	self.parent = parent

	self.tab = tab

	

	tab.Tab.Paint = function(tab,w,h)

		if self.high and not tab:IsActive() then

			surface.SetDrawColor(200,230,255,80+80*math.sin(CurTime()*7))

			surface.DrawRect(0,0,w,h)

		else

			DTab.Paint(tab,w,h)

		end

	end

end



function PANEL:ActivateChat(data,automated)

	--print("ActivateChat",data.sid or data.name,automated and "auto" or "user")

	if not data then

		data = self:GetData()

	end

	if automated then

		if self.parent and self.parent:IsVisible() then

			return

		end

	end

	

	local prev = self:GetActiveChat()

	if prev then

		prev.btn.selected = false

		prev.pnl:SetVisible(false)

		if not automated then

			prev.pnl.high = false

		end

	end

	

	self.activechat = data

	

	if not data then

		return

	end

		

	data.pnl:SetVisible(true)

	data.pnl:Reset()

	data.btn.selected = true



	if automated then

		print("automated",data.name)

		data.btn.high = true

	else

		data.btn.high = false

		self.chat_entry:DoRequestFocus()

	end

	

	self:RefreshState(true)

end



function PANEL:DoSend(msgg)

	local data = self:GetActiveChat()

	if not data then return false end



	self:RefreshState(true)

	

	local msg = msgg or self.chat_entry:GetText()

	

	if not ValidMessage(msg) then return false end

	

	local receiver = data.sid

	

	

	return pmail.Send{msg=msg,receiver=receiver}

end



function PANEL:NewChatPanel(data)

	local pnl = vgui.CreateFromTable(chat_panel_factor,self)

	pnl:Dock(FILL)

	pnl:SetVisible(false)

	data.pnl=pnl

	pnl:Link(self,data)

	local pl = self:GetPlayerEntity(data)

	pl = IsValid(pl) and pl

	data.pnl:ProcessAddText(Color(255,255,255,255),"Chatting with ",pl or self:GetPlayerName(data))

	

	return pnl

end



function PANEL:AddPlButton(data)

	

	local b = vgui.Create("DButton", self.pl_buttons)



	b:SetText( data.name or data.sid=="" and "SYSTEM" or data.sid or "???" )

	

	b:SetDrawBorder(false)

	b:SetDrawBackground( false )

	

	b.DoClick = function(b)

		b.high = false

		self:ActivateChat(data,false)

	end

	b.DoRightClick = function(b)

		self:RemovePl(data.sid)

	end

	b.DoResize=function(b)

		b:SizeToContents()

		b:SetWide( b:GetWide() + 10 )

		b:GetParent():InvalidateLayout()

	end

	b:DoResize()

	

	b.Paint=function(b,w,h)

		if b.Hovered then

			surface.SetDrawColor(30,30,40,60)

			surface.DrawRect(0,0,w,h)

		elseif b.high then

			if b.selected then

				b.high = false

				self:RefreshState(true)

			else

				surface.SetDrawColor(35,40,200,60+math.sin(RealTime()*5)*30)

				surface.DrawRect(0,0,w,h)

			end

		elseif b.selected then

			surface.SetDrawColor(180,200,222,50)

			surface.DrawRect(0,0,w,h)

			

			surface.SetDrawColor(50,150,233,200)

			surface.DrawRect(0,h-2,w,2)

		end

		

		

		derma.SkinHook( "Paint", "Button", b, w, h )

		return false

	end



	self.pl_buttons:AddPanel( b )

	data.btn = b

	b.data=data

	

	return b

end



function PANEL:GetPlayerEntity(data)

	assert(data)

	if not IsValid(data.pl) then

		for k,v in next,player.GetAll() do

			if v:SteamID()==data.sid or v:SteamID64()==data.sid then

				data.pl = v

				return v

			end

		end

	end

	return data.pl

end



function PANEL:GetPlayerName(data)

	assert(data)

	local pl = self:GetPlayerEntity(data)

	

		

	if IsValid(pl) then

		local name = pl:Name()

		if data.name ~= name then

			data.name = name

			if self.btn then

				self.btn:SetText(name)

				self.btn:DoResize()

			end

		end

		return name

	end

	

	if data.sid=="" then

		return "SYSTEM"

	end

	

	return data.name or data.sid

end



function PANEL:RefreshState(fixhigh)

	if fixhigh then

		self.high = false

	end



	local high

	for sid,data in next,self.data do

		self:GetPlayerName(data)

		if not high and data.btn and data.btn.high then

			--print("high by",data.name or data.sid)

			high = true

		end

	end

	--print("high=",high)

	self.high = self.high or high

end



function PANEL:GetPlDat(sid,automated)

	

	local data = self:GetData(sid)

	

	

	-- return cached or create

	if data then

		self:GetPlayerName(data)

		return data

	else

		data = self:GetData(sid,true)

		assert(data)

	end

	

	assert(data.sid)

	self:GetPlayerName(data)

	

	-- Create GUI

	

	self:AddPlButton(data)

	

	self:NewChatPanel(data)

	

	self:ActivateChat(data,automated)

	

	return data

end



function PANEL:Paint() end



function PANEL:RemovePl(sid)

	local data = self:GetData(sid)

	assert(data)

	self.data[sid] = nil

	

	self.pl_buttons:RemovePanel(data.btn)

	data.btn:Remove()

	data.pnl:Remove()

	

	--NOP unless it was this panel!

	self:ActivateChat(self:GetActiveChat())

	

end



function PANEL:OnActivatedPanel(prev)

	self:ActivateChat(self:GetActiveChat(),false)

	if self:GetActiveChat() and self:GetActiveChat().btn and self:GetActiveChat().btn.high then

		print"WTF??"

	end

	self:RefreshState(true)

	self.chat_entry:DoRequestFocus()

	self.chat_entry:DoFont(GetInputFont())

end



vgui.Register( Tag..'_pm', PANEL, "DPanel" )