 local L = translation and translation.L or function(s) return s end

local Tag="chatbox"

local string=string

module(Tag,package.seeall)

if SERVER then AddCSLuaFile() return end

_M.chatgui=_M.chatgui or false

CHAT_INIT = -2
CHAT_OPEN = -3
CHAT_CB = -4
CHAT_PM_CB = -5
function CreateChatbox(recreate) -- global for debugging
	if recreate and ValidPanel(chatgui) then
		chatgui:Remove()
		_M.chatgui=false
		_G.chatgui=nil
	end
	if not ValidPanel(chatgui) then
		chatgui = vgui.Create( Tag, nil, 'customchatbox' )
		_G.chatgui=chatgui
		
		hook.Call("ChatBoxAction",nil,CHAT_INIT)
		
	end
end


local function start() CreateChatbox() end
if IsValid(LocalPlayer()) then
	timer.Simple(0,start)
else
	hook.Add('Initialize',Tag,start)
end

hook.Add("ChatBoxAction","chatbox_log",function(msg)
	if msg~=CHAT_INIT then return end
	ChatLog("<<< "..L"Joined server".." >>> ip=",tostring(GetConVarString"hostip")," "..L"Hostname"..": ",GetHostName()," \t"..L"Time"..":"..os.date())
end)

hook.Add("ShutDown","chatbox_log",function()
	ChatLog("<<< "..L"Left the Server".." >>>")
end)

--hook.Add("ChatBoxAction","chatbox",function(...) print("DBGChatBoxAction",...) end)
function ShowChat2Box(tab,mode)

	CreateChatbox()
	if hook.Call("ChatBoxAction",nil,CHAT_OPEN,tab,mode,chatgui) == false then return chatgui end
	
	chatgui:SetTab(tab,mode)
	chatgui:Show()
	
	return chatgui
	
end

-- -- Native function override
-- local chat_GetChatBoxPos = chat.GetChatBoxPos
-- function chat.GetChatBoxPos()
-- 	if chatgui==_M.chatgui then
-- 		return chatgui:GetPos()
-- 	end
-- 	return chat_GetChatBoxPos()
-- end


concommand.Add("openchatbox", function()
	ShowChat2Box(1,1)
end)
concommand.Add("chat_open", function()
	ShowChat2Box(1,1)
end)
concommand.Add("chat_open_team", function()
	ShowChat2Box(1,2)
end)
concommand.Add("chat_open_local", function()
	ShowChat2Box(1,3)
end)

concommand.Add("chat_open_mode", function(_,_,x)
	ShowChat2Box(1,tonumber(x[1] or 1) or 1)
end)

concommand.Add("openluabox1", function()
	ShowChat2Box(2)
end)

concommand.Add("chat_open_lua", function()
	ShowChat2Box(2)
end)
concommand.Add("chat_open_config", function()
	ShowChat2Box(3)
end)

concommand.Add("chat_open_pm", function(a,b,c,d)
	d=c[1]
	d=d and #d>1 and d
	d=d and string.Trim(d)
	d=d and #d>1 and d
	ShowChat2Box(4,d)
end)
------------------ logging ---------------------

local chatbox_logging=CreateClientConVar("chatbox_logging","0",true,false)
function ChatLog(...)
    if not chatbox_logging:GetBool() then return end
    local data = {...}
    for k,v in pairs(data) do
	local typ=type(v)
	local str
	if typ=="string" then
	    str=v
	elseif typ=="table" then
	    str=""
	elseif typ=="Player" then
	    str=v:Name()..' ('..v:SteamID()..')'
	else
	    str=tostring(v)
	end
	data[k]=str
    end
	
	local highest=0
	for k,v in pairs(data) do
		local num=tonumber(k)
		if num and highest<num then highest=num end
	end
	for i=1,highest do
		data[i]=data[i] or ""
	end
    table.insert(data,1,os.date("[%H:%M] "))
    local filename="chatlogs/"..os.date"%m-%d-%Y"..".txt"
	file.CreateDir("chatlogs")
    file.Append(filename,table.concat(data,""):gsub("\n","> ").."\n")
end

local _ChatLog_=ChatLog ChatLog=function(...)
	local a,b = pcall(_ChatLog_,...)
	if not a then ErrorNoHalt("chatlog fail: "..b.."\n") end
end

------------------------------------------------

local PlayerColors = {
	["0"]  = Color(0,0,0),
	["1"]  = Color(128,128,128),
	["2"]  = Color(192,192,192),
	["3"]  = Color(255,255,255),
	["4"]  = Color(0,0,128),
	["5"]  = Color(0,0,255),
	["6"]  = Color(0,128,128),
	["7"]  = Color(0,255,255),
	["8"]  = Color(0,128,0),
	["9"]  = Color(0,255,0),
	["10"] = Color(128,128,0),
	["11"] = Color(255,255,0),
	["12"] = Color(128,0,0),
	["13"] = Color(255,0,0),
	["14"] = Color(128,0,128),
	["15"] = Color(255,0,255),
	["16"] = Color(199, 76, 58),
	["17"] = Color(127, 0, 95),
}

local ColorModifiers = { 	-- a bit shitty
	function( txt )			-- ^N modifier
		local Colors = {}
		
		for before, n, s in txt:gmatch("(.-)%^(%d+)([^%^]+)") do -- before is the string before the modifier and s is the string after it
			if PlayerColors[ n ] then
				
				if before != "" then
					table.insert( Colors, before )
				end
				
				table.insert( Colors, PlayerColors[n] )
				table.insert( Colors, s )
			end
		end
		
		return Colors
	end,
	function( txt )			-- <color> modifier
		local Modifier, Colors = "<color=%s*(%d*)%s*,?%s*(%d*)%s*,?%s*(%d*)%s*,?%s*(%d*)%s*>", {}
		
		for before, r, g, b, a, s in txt:gmatch( "(.-)" .. Modifier .. "([^<]*)" ) do
			if before != "" then
				table.insert( Colors, before )
			end
			
			r = tonumber( r ); r = r and r or 0
			g = tonumber( g ); g = g and g or 0
			b = tonumber( b ); b = b and b or 0
			a = tonumber( a ); a = a and a or 255
			
			table.insert( Colors, Color( r, g, b, a ) )
			table.insert( Colors, s )
		end
		
		return Colors
	end
}

function ParseName(newtbl,v)
	
	local TextTable = { v }
	
	for _, GetColors in pairs( ColorModifiers ) do

		for k, v in pairs( TextTable ) do
			if not isstring( v ) then continue end
			
			local Colors = GetColors( v )
			
			if table.Count( Colors ) > 0 then
				TextTable[ k ] = nil
				
				for i, content in pairs( Colors ) do
					table.insert( TextTable, k + (i - 1), content )
				end
			end
		end
		
	end
	
	for k, v in pairs( TextTable ) do
		table.insert( newtbl, v )
	end
end




local function check_highlight(line,name)
	if not name or name:len()<=2 then return end
	local a,b = string.find(line,name,1,true)
	if b then
		a=a-1
		b=b+1
		local left = line:sub(a,a)
		local right = line:sub(b,b)
		local bad = left:find'%w' or right:find'%w'
		
		return not bad
		
	end
end

local chat_highlight = CreateClientConVar("chat_highlight","1",true)
local name=GetConVar"name"
function IsHighlight(line)
	
	local nick1=LocalPlayer():Nick()
	local nick3=name:GetString()
	
	if chat_highlight:GetInt()==2 then
			
		if nick1==nick3 then
			nick1=nick1:lower()
			nick3=nick1
		else
			nick1=nick1:lower()
			nick3=nick3:lower()
		end
		
		line=line:lower()
		
	end
	
	if check_highlight(line,nick1) then return true end
	
	local nick2=chat.UndecorateNick
	nick2 = nick2 and nick2(nick1)
	
	if nick2 and nick2 ~= nick1 then
		--print(nick2,line)
		if check_highlight(line,nick2) then
			return true
		end
	end
	
	if nick1==nick3 then return end
	
	return check_highlight(line,nick3)
	
end


local chat_highlight_color = CreateClientConVar("chat_highlight_color","",true)

local should_highlight=0
local function ShouldCheckHighlight()
	return should_highlight>0 -- and chat_highlight:GetBool()
end

function SetShouldCheckHighlight(should)
	should_highlight=should_highlight + (should and 1 or -1)
end

local cl_chatbox_pastelize = CreateClientConVar("cl_chatbox_pastelize","0",true)

local C1=Color(151, 211, 255, 255)

function ProcessAddText(...)
	local newtbl={}
	
	chatgui.Chat.ChatLog:PrintTime()
	local chat_highlight=chat_highlight:GetBool()
	local checkhighlight = chat_highlight and ShouldCheckHighlight()
	for n=1,select('#',...) do
		local v = select(n,...)
		if( type(v) == "Player" ) then
			checkhighlight = checkhighlight or chat_highlight
			local pastelized = cl_chatbox_pastelize:GetBool()
			local ChatLog = chatgui.Chat.ChatLog
			
			local nick = v:GetName()
			local pastelcol
			if pastelized then
				pastelized,pastelcol = chat.UndecorateNick(nick)
			end
			
			local c = pastelcol or team.GetColor(v:Team())
				ChatLog:InsertColorChange(c.r, c.g, c.b, 255)
				table.insert(newtbl, c)
			
			do
				local _tmptab = {}
				ParseName(_tmptab,pastelized or nick)
				
				for k, v in next, _tmptab do
					if istable(v) then
						chatgui.Chat.ChatLog:InsertColorChange(v.r, v.g, v.b, v.a)
					else
						chatgui.Chat.ChatLog:AppendText(v)
					end
					table.insert (newtbl, v)
				end
			end
			
			ChatLog:InsertColorChange(151, 211, 255, 255)
			table.insert(newtbl, C1)

		elseif( type(v) == "table" ) then

			if( v.r ~= nil and v.g ~= nil and v.b ~= nil ) then

				chatgui.Chat.ChatLog:InsertColorChange(v.r, v.g, v.b, 255)
				table.insert(newtbl, v)

			end
		else
			local str = tostring(v)
			local h = checkhighlight and IsHighlight(str)
			if h then
				local r,g,b=chat_highlight_color:GetString():match'^(%d%d?%d?) (%d%d?%d?) (%d%d?%d?)'
				r=r and tonumber(r) or 255
				g=g and tonumber(g) or 90
				b=b and tonumber(b) or 40

				chatgui.Chat.ChatLog:InsertColorChange(r,g,b, 255)
				table.insert(newtbl, Color(r,g,b, 255))
			end
			chatgui.Chat.ChatLog:AppendTextURL(str)
			table.insert(newtbl,str)
		end
	end

	chatgui.Chat.ChatLog:AppendText("\n")
	--table.insert(newtbl, "\n")
	return newtbl
end

chat.ChatHudRealAddText = chat.ChatHudRealAddText or chat.AddText
local chat_AddText=chat.ChatHudRealAddText

local suppress_modify = false

function chat.AddText(...)
	
	if not suppress_modify then
		local args = {...}
		local var =  hook.Run("PreChatAddText", args)
		
		if type(var) == "function" then
			
			local id = "chat_override_" .. tostring(var)
			
			timer.Create(id, 0.1, 0, function()
				local args = var(args)
				
				if args then
					suppress_modify = true
					chat.AddText(unpack(args))
					suppress_modify = false
					timer.Remove(id)
				end
			end)
			
			return
		end
		
		if type(var) == "table" then
			suppress_modify = true
			chat.AddText(unpack(var))
			suppress_modify = false
			return
		end
	end

	ChatLog(...)
	if not chatgui or not chatgui.Chat or not chatgui.Chat.ChatLog then
		return chat_AddText(...)
	end
	
	local newtbl = ProcessAddText(...)
	
	return chat_AddText(unpack(newtbl))

end

hook.Add("ChatText", Tag, function( _, _, msg, msg_type )

	if not chatgui then return end

	chatgui.Chat.ChatLog:InsertColorChange(151, 211, 255, 255)
	chatgui.Chat.ChatLog:AppendTextURL(tostring(msg))
	chatgui.Chat.ChatLog:AppendText("\n")

end)


local chat_pmmode=CreateClientConVar("chat_pmmode","0",true,false)
local chat_devmode=CreateClientConVar("chat_devmode","0",true,false)
local chatbox_legacy=CreateClientConVar("chatbox_legacy","0",true,false)

local in_legacy
local cl_chathud_hide = CreateClientConVar("cl_chathud_hide","0",true)
hook.Add("HUDShouldDraw","cl_chathud_hide",function(id)
	if id=="CHudChat" then
		if not in_legacy and cl_chathud_hide:GetBool() then
			return false
		end
	end
end)

local function Legacy()
	local cantdraw=hook.Run("HUDShouldDraw","CHudChat")==false
	if cantdraw then
		local f=chat._Close or chat.Close
		chat.Close()
	end
	
	if chatbox_legacy:GetBool() then
		if cantdraw then
			chat.AddText("Could not open GMod chat because of custom chat hud")
			RunConsoleCommand("chatbox_legacy","0")
		else
			return true
		end
	end
end


local buttonless_tick = -1

hook.Add("PlayerBindPress", Tag, function( ply, bind, pressed )
	if not pressed then return end
	
	local now = RealTime()
	if buttonless_tick==now then
		--ErrorNoHalt("MMODE OMITTING "..tostring(bind)..' '..tostring(pressed)..'\n')
		return true
	end
	
	local ok,err,ret=true,"",nil
	
	if bind == "messagemode" or bind == "say" then
		local mode =	input.IsKeyDown(KEY_1) and 1 or
						input.IsKeyDown(KEY_2) and 2 or
						input.IsKeyDown(KEY_3) and 3 or
						input.IsKeyDown(KEY_4) and 4 or
						input.IsKeyDown(KEY_5) and 5 or
						input.IsKeyDown(KEY_6) and 6 or
						input.IsKeyDown(KEY_7) and 7 or 1
		
			
		in_legacy = true
			local islegacy = Legacy()
		in_legacy = false
		if islegacy then
			return
		end
		
		ok, err = pcall( ShowChat2Box ,1,mode or 1) -- Chat
		buttonless_tick = RealTime()
		ret = true
	elseif bind == "messagemode2" then
		
		in_legacy = true
			local islegacy = Legacy()
		in_legacy = false
		if islegacy then
			return
		end
		
		if LocalPlayer():IsUserGroup("superadmin") then
			ok, err = pcall( ShowChat2Box ,2) -- Lua
		elseif chat_pmmode:GetBool() then
			ok, err = pcall( ShowChat2Box ,4) -- PM
		else
			ok, err = pcall( ShowChat2Box ,1,2) -- chat, teamchat
		end
		buttonless_tick = RealTime()
		ret = true
	else
		return
	end
	
	if not ok then
		ErrorNoHalt("CHATBOX OPEN FAIL: "..err..'\n')
		
		-- fallback fix or stuff breaks horribly
		if IsValid(LocalPlayer()) then
			LocalPlayer():ConCommand("cl_shownewhud 0",true)
		end
		
		return
	end
	return ret
end)

---------------------------------------------------------------
-- Main VGUI
---------------------------------------------------------------


-- reset mode
can_chat = true
function StartChat()
	can_chat = true
	/*if GetChatMode and GetChatMode()~=1 and GetChatMode()~= 2 then
		SetChatMode(1)
	end*/
end

function FinishChat()
	can_chat = false
	
end

StartChat_override = false

hook.Add("StartChat",Tag,function()
	
	if StartChat_override then return end

	in_legacy = true
	
	if Legacy() then
		--print("in_legacy","StartChat",in_legacy)
		return
	end
	
	in_legacy = false
	--print("in_legacy","StartChat",in_legacy)
	
	return true
	
end)

hook.Add("FinishChat",Tag,function()
	in_legacy = false
	--print("in_legacy","FinishChat",in_legacy)
end)

local PANEL={}


	AccessorFunc( PANEL, "m_bIsMenuComponent", 		"IsMenu", 			FORCE_BOOL )
	AccessorFunc( PANEL, "m_bDraggable", 			"Draggable", 		FORCE_BOOL )
	AccessorFunc( PANEL, "m_bSizable", 				"Sizable", 			FORCE_BOOL )
	AccessorFunc( PANEL, "m_bScreenLock", 			"ScreenLock", 		FORCE_BOOL )
	AccessorFunc( PANEL, "m_bDeleteOnClose", 		"DeleteOnClose", 	FORCE_BOOL )
	AccessorFunc( PANEL, "m_bPaintShadow", 			"PaintShadow", 		FORCE_BOOL )

	AccessorFunc( PANEL, "m_iMinWidth", 			"MinWidth" )
	AccessorFunc( PANEL, "m_iMinHeight", 			"MinHeight" )

	AccessorFunc( PANEL, "m_bBackgroundBlur", 		"BackgroundBlur", 	FORCE_BOOL )


	function PANEL:SavePos()

		if self.Maximized then return end
		self:SetCookieName(Tag..'x')
		self:CheckBounds()
		local x,y = self:GetPos()
		local w,h = self:GetSize()

		x = tostring(x/ScrW()*800)
		y = tostring(y/ScrH()*600)
		w = tostring(w/ScrW()*800)
		h = tostring(h/ScrH()*600)
		
		self:SetCookie("x",x)
		self:SetCookie("y",y)
		self:SetCookie("w",w)
		self:SetCookie("h",h)
	end

	function PANEL:LoadPos()

		self:SetCookieName(Tag..'x')

		local x = tonumber(self:GetCookie("x"))
		local y = tonumber(self:GetCookie("y"))
		local w = tonumber(self:GetCookie("w"))
		local h = tonumber(self:GetCookie("h"))
		if not x or not y or not w or not h or
		(w <1 or h<1) then
			self:SetPos(50, ScrH() - 370)
			self:SetSize(527, 315)
			return
		end
		
		x = x*ScrW()/800
		y = y*ScrH()/600
		w = w*ScrW()/800
		h = h*ScrH()/600
		self:SetPos(x,y)
		self:SetSize(w, h)
		self:CheckBounds()
		
	end
	function PANEL:CheckBounds()
		local x,y=self:GetPos()
		local w,h=self:GetSize()
		local mw,mh=self:GetMinWidth() or 0,self:GetMinHeight() or 0
		local ox,oy,ow,oh=x,y,w,h
		local sw,sh=ScrW(),ScrH()
		
		-- up left corner
		--- move to 0 0
		if x<0 then x=0 end
		if y<0 then y=0 end
		-- check if right down corner outside screen
		--- move to 0 0
		if x+w>sw then x=0 end
		if y+h>sh then y=0 end
		
		-- too big?
		--- size sw sh
		if x+w>sw then w=sw end
		if y+h>sh then h=sh end
		
		-- too small?
		w=w<mw and mw or w
		h=h<mh and mh or h
		
		if not self.Maximized then
			if x<=1 and y<=1 and w>=sw-1 and h>=sh-1 then
				x,y=50, ScrH() - 370
				w,h=527, 315
			end
		end
		
		if x~=ox or y~=oy then self:SetPos(x,y) end
		if w~=ow or h~=oh then self:SetSize(w,h) end
		
	end
	function PANEL:Maximize()
		
		if not self.Maximized then
			self:SavePos()
			self:SetPos(0, 0)
			self:SetSize(ScrW(), ScrH())
			self.Maximized = true
		else
			self:LoadPos()
			self.Maximized = false
		end
	end

	function PANEL:Init()

		self:SetPos(50, ScrH() - 370)
		self:SetSize(527, 315)
		self:SetFocusTopLevel( true )


		self:SetPaintShadow( true )
		self:SetMinWidth( 200 )
		self:SetMinHeight( 100 )
				
		self:SetPaintBackgroundEnabled( false )
		self:SetPaintBorderEnabled( false )
		
		self.m_fCreateTime = SysTime()
		
		--self:DockPadding( 5, 24 + 5, 5, 5 )
		self:SetVisible(false)
		self:SetSizable(true)
		self:SetDraggable(true)
		self:DockMargin(0,0,0,0)
		self:DockPadding(5,5,5,0)
		self:SetScreenLock(true)

		self.Properties = vgui.Create("DPropertySheet", self)
		local SetActiveTab=self.Properties.SetActiveTab
		self.Properties.SetActiveTab=function(self,sheet)
			local prev = self:GetActiveTab()
			local ret = SetActiveTab(self,sheet)
			local new = self:GetActiveTab()
			if prev~=new and new then
				local pnl = new:GetPanel()
				
				if IsValid(pnl) and pnl.OnActivatedPanel then
					pnl:OnActivatedPanel(prev)
				end
			end
			return ret
		end
		
		
		local container = vgui.Create("EditablePanel", self.Properties)
		container:Dock(TOP)
		container:SetTall(self.Properties:GetTall())
		self.Properties.tabScroller:SetParent(container)
		self.Properties.tabScroller:Dock(FILL)
		
		-- HACK
		local BClose = vgui.Create("DButton", self)
		self.BClose=BClose
		
		--BClose:Dock(RIGHT)
		BClose:SetSize(42, 16)
		
		BClose.Paint = function(self, w, h)
			
			local bg = (self.Depressed and Color(128, 32, 32)) or (self:IsHovered() and Color(255, 0, 0)) or Color(255, 64, 64)
			
			--[[if self:IsHovered() then
				surface.DisableClipping(true)
				for i=0,9 do
					local x=150
					bg.a=x-i/5*x
					draw.RoundedBoxEx(4, -i, -i, w+i*2, h+i*2, bg, true, true, true, true)
				end
				surface.DisableClipping(false)
			end]]
			draw.RoundedBoxEx(4, 0, 0, w, h, bg, false, false, false, true)
			draw.SimpleTextOutlined("r", "marlett", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
			return true
		end
		BClose.PerformLayout = function(BClose, w, h)
			
			BClose:SetPos(self:GetWide() - BClose:GetWide() - 4, 0)

			return true
		end
		function BClose.OnMousePressed( BClose, mousecode ) end
		function BClose.OnMouseReleased( BClose, mousecode )
			if mousecode==MOUSE_LEFT then return self:Close() end
			local m = DermaMenu()
			m:AddOption(L"Close",function()
				self:Close()
			end)
			m:AddOption(L"Recreate",function()
				CreateChatbox(true)
			end)
			m:Open()
		end

		local BMaxim = vgui.Create("DButton", self)
		self.BMaxim=BMaxim

		BMaxim:SetSize(24, 16)
		
		BMaxim.Paint = function(BMaxim, w, h)
			
			local bg = (BMaxim.Depressed and Color(32, 32, 32)) or (BMaxim:IsHovered() and Color(127, 127, 127)) or Color(175, 175, 175)
			draw.RoundedBoxEx(4, 0, 0, w, h, bg, false, false, true, false)
			draw.SimpleTextOutlined(tostring(self.Maximized and 2 or 1), "marlett", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black )
			return true
		end
		BMaxim.PerformLayout = function(BMaxim, w, h)
			
			BMaxim:SetPos(self:GetWide() - BClose:GetWide() - BMaxim:GetWide() - 4, 0)

			return true
		end
		function BMaxim.OnMousePressed( BMaxim, mousecode ) end
		function BMaxim.OnMouseReleased( BMaxim, mousecode )
			if mousecode==MOUSE_LEFT then return self:Maximize() end
		end

		self.Properties.Paint=function()end
		self.Properties:Dock(FILL)
		
		self.Properties:DockMargin(0,0,0,0)
		self.Properties:SetPadding(0,0,0,0)
		self.Properties:DockPadding(0,0,0,0)
		self.Properties:SetFadeTime(0)
		
		
		self.Chat = vgui.Create(Tag..'_chat', self)
		self.Chat:SetHost(self)
		self.Config = vgui.Create(Tag..'_config', self)
		self.PM = vgui.Create(Tag..'_pm', self)

		self.Chat_ = self.Properties:AddSheet(L"Global", self.Chat,'icon16/comments.png', false, false, "Chat")
		self.PM_ = self.Properties:AddSheet(L"PM", self.PM, "icon16/group.png", false, false, "PM")
		
		self.PM:Link(self,self.PM_)
		
		if self.Properties.tabScroller then
			local space = vgui.Create('DPanel',self.Properties.tabScroller)
			space:SetWide(32)
			space.Paint=function() end
			self.Properties.tabScroller:AddPanel(space)
			--self.Properties.tabScroller:SetOverlap(-5)
		end
		-- todo: separator
		self.Config_ = self.Properties:AddSheet(L"Settings", self.Config, 'icon16/wrench_orange.png', false, false, "Config")




		local function Override(tab)
			tab._OnMousePressed=tab.OnMousePressed or function() end
			tab.OnMousePressed = function(tab,mc)
				tab:_OnMousePressed(mc)
				self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
				--self:MouseCapture( true )
			end
			local DTab_OnMouseReleased=tab.OnMouseReleased or function() end
			tab.OnMouseReleased = function(tab,mc)
				DTab_OnMouseReleased(tab,mc)
				self:OnMouseReleased(mc)
			end
		end
		
		Override(self.Chat_.Tab)
		Override(self.Config_.Tab)
		Override(self.PM_.Tab)
		
		Override(self.Properties.tabScroller)

		if LocalPlayer():IsSuperAdmin() then
			
			local ok,ret = xpcall(function() return vgui.Create(Tag..'_lua', self) end,debug.traceback)

			if not ok then

				ErrorNoHalt(ret..'\n')

			end
			
			self.Lua = ok and ret or vgui.Create('EditablePanel', self)
			
			self.Lua_ = self.Properties:AddSheet(L"Lua", self.Lua, 'icon16/page_edit.png', false, false, "Lua")

			Override(self.Lua_.Tab)
		
		end
		
	end

	function PANEL:SetTab(tab,mode)
		if tab == 1  then
			self.Properties:SetActiveTab( self.Chat_.Tab )
			self.Chat.ChatText:RequestFocus()
			if mode then
				self.Chat:SetMode(mode)
			else
				self.Chat:SetMode(1) -- reset mode
			end
		elseif tab == 2 then
			self.Properties:SetActiveTab( self.Lua_.Tab )
			if IsValid(self.Lua and self.Lua.code and self.Lua.code.HTML) then
				self.Lua.code.HTML:RequestFocus()
				timer.Simple(0,function()
					self.Lua.code.HTML:RequestFocus()
				end)
			end
		elseif tab == 3 then
			self.Properties:SetActiveTab( self.Config_.Tab )
		elseif tab == 4 then
			self.Properties:SetActiveTab( self.PM_.Tab )
			if isstring(mode) and #mode>0 then
				local data = self.PM:GetPlDat(mode,false)
				self.PM:ActivateChat(data,false)
			end
			self.PM.chat_entry.ChatText.nolosefocus = true
		else
			self.Properties:SetActiveTab( tab )
		end
		if tab ~= 1 then
			self.Chat:SetMode(1) -- reset mode
		end
	end
	
	function PANEL:PerformLayout()
		self.BClose:InvalidateLayout()
		self.BMaxim:InvalidateLayout()
	end
	
	local f11Pressed
	function PANEL:Think()
		if( input.IsKeyDown(KEY_ESCAPE) ) then

			self:Close()
			
			if gui and gui.HideGameUI then gui.HideGameUI() end
			
		
					
			return false

		end
	
		if( input.IsKeyDown(KEY_F11) and not f11Pressed) then
			
			self:Maximize()
			f11Pressed = true
			return false
			
		end
		
		f11Pressed = input.IsKeyDown(KEY_F11)
		
		local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
		local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )
		
		if self.Dragging and not input.IsMouseDown(MOUSE_LEFT) then
			self.Dragging = false
		end
		
		if self.Dragging and not self.Maximized then
			
			local x = mousex - self.Dragging[1]
			local y = mousey - self.Dragging[2]
			
			-- Lock to screen bounds if screenlock is enabled
			if ( self:GetScreenLock() ) then
			
				x = math.Clamp( x, 0, ScrW() - self:GetWide() )
				y = math.Clamp( y, 0, ScrH() - self:GetTall() )
			
			end
			
			self:SetPos( x, y )
		
		end
		
		
		if ( self.Sizing and not self.Maximized) then
		
			local x = mousex - self.Sizing[1]
			local y = mousey - self.Sizing[2]
			local px, py = self:GetPos()
			
			if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px and self:GetScreenLock() ) then x = ScrW() - px end
			if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py and self:GetScreenLock() ) then y = ScrH() - py end
		
			self:SetSize( x, y )
			self:SetCursor( "sizenwse" )
			return
		
		end
		
		if ( self.Hovered and
			 self.m_bSizable and
			 mousex > (self.x + self:GetWide() - 20) and
			 mousey > (self.y + self:GetTall() - 20) ) and 
			 not self.Maximized then

			self:SetCursor( "sizenwse" )
			return
			
		end
		
		if ( self.Hovered and self:GetDraggable() and mousey < (self.y + 24) and not self.Maximized) then
			self:SetCursor( "sizeall" )
			return
		end
		
		self:SetCursor( "arrow" )

		-- Don't allow the frame to go higher than 0
		if ( self.y < 0 ) then
			self:SetPos( self.x, 0 )
		end
		
	end


	function PANEL:Show()
		local dont = false
		if not StartChat_override then
			StartChat_override = true
			local teamchat = GetChatMode and GetChatMode() == 2
			if hook.Call("StartChat", GAMEMODE, teamchat) == true then
				dont = true
			end
			StartChat_override = false
		end
		if dont then return false end
		
		StartChat()
		hook.Call("ChatTextChanged", GAMEMODE, "")

		self.Chat:Reset()
		self.startshow = RealTime()
		self:SetAlpha(255)
		
		self:SetVisible(true)
		self:MakePopup()

		-- blocked in gmod update
		--LocalPlayer():ConCommand("con_enable 0")
		
		-- IME workaround
		do
			local key_name = input.LookupBinding("toggleconsole")
			local key

			hook.Add("Think", "IME_workaround", function()
				if not self:IsVisible() then return end
				gui.HideGameUI()
			end)
		end
		
		if not self.posloaded then
			self.posloaded=true
			self:LoadPos()
		end
		
	end


	function PANEL:Hide()
	
		hook.Call("ChatTextChanged", GAMEMODE, "")
		timer.Simple(0,function()
			hook.Call("FinishChat", GAMEMODE)
			FinishChat()
		end)
		self:SetVisible(false)

		self:SavePos()
		
		--blocked in gmod update
		--LocalPlayer():ConCommand("con_enable 1")
		
		hook.Remove("Think", "IME_workaround")
		self.Dragging = nil
		self.Sizing = nil
		self:MouseCapture( false )
	end
	PANEL.Close=PANEL.Hide

	local lastClick = 0
	function PANEL:OnMousePressed()
		if lastClick > CurTime() then
			self:Maximize()
			lastClick = 0
		end
		lastClick = CurTime() + .3
	
		if ( self.m_bSizable ) then
		
			if ( gui.MouseX() > (self.x + self:GetWide() - 20) and
				gui.MouseY() > (self.y + self:GetTall() - 20) ) then
		
				self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
				self:MouseCapture( true )
				return
			end
			
		end
		
		if ( self:GetDraggable() and gui.MouseY() < (self.y + 24) ) then
			self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
			self:MouseCapture( true )
			return
		end
		
	end


	function PANEL:OnMouseReleased()

		self.Dragging = nil
		self.Sizing = nil
		self:MouseCapture( false )

	end
	function PANEL:IsActive()

		if ( self:HasFocus() ) then return true end
		if ( vgui.FocusedHasParent( self ) ) then return true end
		
		return false

	end
	local halfpi=math.pi/2
	function PANEL:GetAlphaFrac()
		local t=self.startshow
		local now = RealTime()
		local f = (now-t)/0.2
		if f>=1 then
			return 1
		elseif f<=0 then
			return 0
		end
		f=math.sin( f*halfpi )
		return f
	end
	function PANEL:Paint( w, h )
		--self:NoClipping(false)
			local a=self:GetAlphaFrac()
			surface.SetDrawColor(66,66,66,a*100)
			surface.DrawRect(0,0,w,h)
			surface.SetDrawColor(66,66,66,a*150)
			surface.DrawOutlinedRect(0,0,w,h)
		--self:NoClipping(true)
		
		hook.Run("ChatBoxDraw", w, h, self)
	end

vgui.Register( Tag, PANEL, "EditablePanel" )