
-----------------------------------------------------

-----------------------------------------------------
--[[

Copyright Python1320
License: http://store.steampowered.com/eula/311710_eula_0
No, really. You can always ASK for special license. No need to "steal".

-- Actually sets the font
RichText:SetFont(font)

-- Add clickable text with callback
RichText:AddCallbackText(text,callback)

-- Add clickable text with callback
-- inserttext_callback = function(richtext) richtext:AppendText"whatever" end
RichText:AddCallbackText(inserttext_callback,callback)

-- self explanatory
RichText:AddLink(url)
RichText:AddLink(url,text,color)

-- Regular text adding
RichText:AppendText(txt)

-- AppendText with url parsing
RichText:AppendTextURL(txt)

-- AddText("hello",Color(255,200,100),"world")
RichText:AddText(color,text,text,color,...)

-- AddText which parses URLs
RichText:AddTextURL(...)

-- next AppendText will use this color
RichText:InsertColorChange( color )

-- Resets to last color or to supplied values
RichText:ResetLastColor( color )

--- Overrides ---

-- One frame after creation. RichText behaves weirdly before this.
RichText:OnReady() end

-- Think for override
RichText:OnThink() end

-- tab button has been pressed. You might want to handle this.
RichText:OnTab() end

-- Clickable text has been clicked. value can be url or callback id or just random text.
-- Return true to override normal behavior
RichText:OnTextClicked(value) end

-- URL is about to be opened, return true to prevent
RichText:OnURL(url) end

-- Nothing could handle this text click, return true if you handled it
RichText:OnUnhandledClick(value) end

]]


local PANEL={}

function PANEL:OnTextClicked(value) end
function PANEL:OnURL(url) end
function PANEL:OnUnhandledClick(value) end
function PANEL:OnThink() end
function PANEL:OnTab() end
function PANEL:OnReady()end

function PANEL:Init()
	
	self._FAKEURL = "steam://openurlx/"
	self._CALLBACK = "C_"
	self:SetMultiline(true)
	self:GotoTextEnd()
	self:SetPaintBorderEnabled( false )
	self:SetPaintBackgroundEnabled( false )
	self._updatefont = "DefaultSmall"
	self:SetFontInternal(self._updatefont)
	self:InsertColorChange(255,255,255,255)
	self.doinit = true
	self.appendNL = false
	self._breaklongspaces = true
	self._links = {}
	self._nextfontchange = 0
	
end


function PANEL:InitLazy()
	self:SetFontInternal(self._updatefont)
	self:InsertColorChange(255,255,255,255)
	self:OnReady()
end

function PANEL:Paint(w,h)

	surface.SetDrawColor(35,34,33,245)
	surface.DrawRect(0,0,w,h)
	
end

function PANEL:SetFont(font)
	surface.SetFont(font)
	self._updatefont = font
	self:SetFontInternal(self._updatefont)
	i=20
end

function PANEL:GetFont()
	return self._updatefont
end


function PANEL:OnKeyCodePressed(key)
	if key==KEY_TAB then
		self:OnTab()
	end
end

function PANEL:Think()
	
	if self.doinit then
		self.doinit=false
		self:InitLazy()
	end
	
	if self:OnThink() ~= nil then return end
	
	local i = self._nextfontchange + 1
	
	if i>22 then
		self._nextfontchange = 0
		self:SetFontInternal(self._updatefont)
	else
		self._nextfontchange = i
	end
	
	
	
	
	
end


function PANEL:AddCallbackText(inserttext_callback,callback)
	local links=self._links
	
	local id = #links+1
	
	links[id] = callback

	self:InsertClickableTextStart( self._CALLBACK .. id )
	if isstring(inserttext_callback) then
		
		local txt = inserttext_callback
		self:AppendText(txt)
		
	else
		inserttext_callback(self)
	end
	self:InsertClickableTextEnd()
end

function PANEL:ActionSignal(key,value)
	if key=="TextClicked" then
		if self:OnTextClicked(value)~=nil then return end
		self:TextClickedInternal(value)
	end

end

function PANEL:TextClickedInternal(value)
	
	local CALLBACK = self._CALLBACK
	local FAKEURL=self._FAKEURL
	
	local is_callback = value:sub(1,CALLBACK:len()) == CALLBACK
	if is_callback then
		local links = self._links
		local id = tonumber(value:sub(3,-1))
		local cb = links[id]
		cb(self)
		return
	end
	
	local is_url = value:sub( 1, FAKEURL:len() ) == FAKEURL
	if is_url then
		
		local url = value:sub( 18, -1 )
		
		if self:OnURL(url)~=nil then return end
		self:OpenURL(url)
		
		return
	end
	
	if self:OnUnhandledClick(value) == nil then
		ErrorNoHalt("RichText: Unhandled text: "..tostring(value)..'\n')
	end
end

function PANEL:OpenURL(url)
	
	-- Workarounds due to crappy ProTecTioNs!!!111
	local realurl = url
	local protocolfound = url:find"^%w-://"
	
	if url:sub(1,7) ~= 'http://' and protocolfound then
		
		url = "http://anonym.to/?" .. url
		
		return gui.OpenURL( url )
		
	end
	
	if not protocolfound then
		url = 'http://' .. url
	end
	
	return gui.OpenURL(url)
	
end

function PANEL:AddLink(url,text,color)
	
	self:InsertClickableTextStart( self._FAKEURL .. url )

		if color then
			self:InsertColorChange(color.r,color.g,color.b,color.a)
		end
		
		self:AppendText( text or url )
		
	self:InsertClickableTextEnd()
	
end


local function replace_char(pos, str, r)
	-- ew
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

local NONBREAKSPACE = [[ ]]
local function FixLongSpaces(ret)
	
	local len=ret:len()
	if len>=40 then
		for i=40,len,40 do
			ret = replace_char(i,ret,NONBREAKSPACE)
		end
	end
	
	return ret
end

PANEL.AppendTextReal = FindMetaTable"Panel".AppendText
function PANEL:AppendText(txt)
	if self.appendNL then
		self:AppendTextReal '\n'
	end
	if txt:sub(-1) == '\n' then
		self.appendNL = true
		txt = txt:sub(1,txt:len()-1)
	else
		self.appendNL=false
	end
	
	if self._breaklongspaces then
		txt=txt:gsub(" +",FixLongSpaces)
	end
	
	self:AppendTextReal( txt )
end

function PANEL:AddText(...)
	for i = 1, select('#',...) do
		local txt = select( i, ... )
		
		if isstring( txt ) then
			txt = tostring( txt ) or "no value"
			self:AppendText( txt )
		else
			local color = txt
			self:InsertColorChange( color.r,
									color.g,
									color.b,
									color.a )
		end
	end
end

PANEL.InsertColorChangeReal = FindMetaTable"Panel".InsertColorChange

function PANEL:InsertColorChange( r, g, b )
	if not g then
		b=r.b
		g=r.g
		r=r.r
	end
		
	self:InsertColorChangeReal( r, g, b, 255 )
	
	self._lr = r
	self._lg = g
	self._lb = b
	
end

function PANEL:ResetLastColor(r,g,b)
	
	if not g then
		b=r.b
		g=r.g
		r=r.r
	end
	
	local r = self._lr or r or 255
	local g = self._lg or g or 255
	local b = self._lb or b or 255
	
	self:InsertColorChangeReal( r,g,b,255 )
	
end

function PANEL:_CheckFor(tbl,a,b)
	
    local a_len = #a
    local res, endpos = true, 1
	
    while res and endpos < a_len do
		
        res,endpos=a:find( b, endpos )

		if res then
            tbl[ #tbl+1 ] = { res, endpos }
        end
		
    end
	
end

function PANEL:_AppendTextLink(a,callback)

	local result={}
	self:_CheckFor(result,a,"https?://[^%s%\"]+")
	self:_CheckFor(result,a,"ftp://[^%s%\"]+")
	self:_CheckFor(result,a,"steam://[^%s%\"]+")
	self:_CheckFor(result,a,"skype://[^%s%\"]+")

	-- might need to disable this one
	self:_CheckFor(result,a,"www%.[^%s%\"]+%.[^%s%\"]+")

	if #result == 0 then
		assert(a or false,"WTF!?")
		callback(self,false,a)
		return false
	end

	table.sort(result,function(a,b) return a[1]<b[1] end)

	-- Fix overlaps
	local _l,_r
	for k,tbl in next,result do

		local l,r=tbl[1],tbl[2]

		if not _l then
			_l,_r=tbl[1],tbl[2]
			continue
		end

		if l<_r then table.remove(result,k) end

		_l,_r=tbl[1],tbl[2]
	end

	local function TEX(str)
		callback(self,false,str)
	end
	local function LNK(str)
		callback(self,true,str)
	end

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

function PANEL:_URLResult( islink, txt )

	if txt:len()==0 then return end
	
	-- we need to reset color in case
	-- self:AddLink( txt )
	
	if islink then
		self:InsertClickableTextStart( self._FAKEURL .. txt )
		self:ResetLastColor(255,255,255)
	end
	
	self:AppendText( txt )
	
	if islink then
		self:InsertClickableTextEnd()
	end
	
end

function PANEL:AppendTextURL(txt)
	self:_AppendTextLink(txt,self._URLResult)
end


function PANEL:AddTextURL(...)
	for i = 1, select('#',...) do
		local txt = select( i, ... )
		
		if isstring( txt ) then
			txt = tostring( txt ) or "no value"
			self:AppendTextURL( txt )
		else
			local color = txt
			self:InsertColorChange( color.r,
									color.g,
									color.b,
									color.a )
		end
	end
end

vgui.Register("RichTextX",PANEL,'RichText')

