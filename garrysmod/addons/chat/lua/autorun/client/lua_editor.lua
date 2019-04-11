
-----------------------------------------------------
local refresh_autocompletes = function() end -- bottom of file

local PANEL = {}

local TAG = "lua_editor"
local file = file



function PANEL:RefreshAutocompletes(force)
	
	if self.written_autocomplete and not force then return end
	
	self.written_autocomplete = true

	refresh_autocompletes()
	
end

// lua_openscript_cl srv/chat/lua/autorun/client/lua_editor.lua;chatbox_recreate;lua_editor_url "http://10.5.1.8:8080/debug/"

PANEL.URL = "http://metastruct.github.io/lua_editor/"//"http://gmchan.ru/lua_editor"

PANEL.Modes = {
	"glua",
	"lua",
	"javascript",
	"json",
	"text",
	"plain_text",
	"sql",
	"xml",
	"",
	"ada",
	"assembly_x86",
	"autohotkey",
	"batchfile",
	"c9search",
	"c_cpp",
	"csharp",
	"css",
	"diff",
	"html",
	"html_ruby",
	"ini",
	"java",
	"jsoniq",
	"jsp",
	"luapage",
	"lucene",
	"makefile",
	"markdown",
	"mysql",
	"perl",
	"pgsql",
	"php",
	"powershell",
	"properties",
	"python",
	"rhtml",
	"ruby",
	"sh",
	"snippets",
	"svg",
	"vbscript",
}

PANEL.Themes = {
	"ambiance",
	"chaos",
	"chrome",
	"clouds",
	"clouds_midnight",
	"cobalt",
	"crimson_editor",
	"dawn",
	"dreamweaver",
	"eclipse",
	"github",
	"idle_fingers",
	"iplastic",
	"katzenmilch",
	"kr_theme",
	"kuroir",
	"merbivore",
	"merbivore_soft",
	"mono_industrial",
	"monokai",
	"pastel_on_dark",
	"solarized_dark",
	"solarized_light",
	"sqlserver",
	"terminal",
	"textmate",
	"tomorrow",
	"tomorrow_night",
	"tomorrow_night_blue",
	"tomorrow_night_bright",
	"tomorrow_night_eighties",
	"twilight",
	"vibrant_ink",
	"xcode"
}

AccessorFunc( PANEL, "m_iFontSize", "FontSize",			FORCE_NUMBER )
AccessorFunc( PANEL, "m_sTheme", 	"Theme", 			FORCE_STRING )
AccessorFunc( PANEL, "m_sMode", 	"Mode", 			FORCE_STRING )
AccessorFunc( PANEL, "m_sSessName",	"Session",			FORCE_STRING )
AccessorFunc( PANEL, "m_bLoaded",	"HasLoaded",		FORCE_BOOL	 )
AccessorFunc( PANEL, "m_bSaveSnip",	"DoSaveSnippets",	FORCE_BOOL	 )
AccessorFunc( PANEL, "m_bLoadSnip",	"DoLoadSnippets",	FORCE_BOOL	 )

-- TODO:
-- shortcuts: reload panel, run scripts [cl,sv,etc], rebind js-side shortcuts, ...
-- find a way to show the autocompleter while typing without fucking up editor (in lastest version of ace editor, this is just one option.. update pls)
-- remove DoLoad* funcs (should we load anything here, or let parent decide?)
-- get modes and themes from ace editor and send them over a html-binded function -- may not work in latest version of ace editor
--      var modes = {}; editor.menuOptions.setMode.forEach( function( v, k ) { modes[k] = v.textContent; } );
--      var themes = {}; editor.menuOptions.setTheme.forEach(function( v, k ){ themes[v.textContent] = v.value; });
-- use gmodinterface.InternalUpdateTable( TableName, JsonContentTable ) instead of Internal[ANYTHING]Update(...)
-- save extern (loaded outside of lua_editor data folder) files if their content gets changed
-- some files may not load because they need more than the encodings of encode(). what about encoding base64 then decoding js-side?
-- find a way to add lua completions!!
-- UPDATE ACE EDITOR TO LASTEST VERSION


function PANEL:Init()
	
	self:SetCookieName( TAG )
	self:SetDoSaveSnippets( true )
	self:SetDoLoadSnippets( true )
	
	self.SaveDirectory	= TAG .. "/"
	self.Sessions		= {}
	self.Snippets		= {}
	self.CTThreshold	= 5 -- Compile Time Threshold in ms.
	
	self.LoadBtn = vgui.Create( "DButton", self )
		self.LoadBtn:SetText( "Loading Editor | Click me to retry" )
		self.LoadBtn:SizeToContents()
		self.LoadBtn:SetPos( 4, 1 )
		self.LoadBtn:SetSize( self.LoadBtn:GetWide() + 10, self.LoadBtn:GetTall() + 5 )
		self.LoadBtn.DoClick = function() self:LoadURL() end
		self.LoadBtn.Think = function( self ) self:SetTextColor( Color( 100 + 100 * math.sin( CurTime() * 10 ), 50, 50, 255 ) ) end
	
	self.ErrBtn	= vgui.Create( "DButton", self )
		self.ErrBtn:Dock( BOTTOM )
		self.ErrBtn:SetIcon( "icon16/cancel.png" )
		self.ErrBtn:SetTooltip( "Right click to copy error text" )
		self.ErrBtn:SetVisible( false )
		self.ErrBtn:SetTextColor( color_black )
		self.ErrBtn:SetContentAlignment( 4 )
		self.ErrBtn.DoRightClick = function( self ) SetClipboardText( self:GetText() ) end
		self.ErrBtn.DoClick = function() self:GotoErrorLine() end
		self.ErrBtn.Paint = function( self, w, h )
			draw.RoundedBox( 2, 0, 0, w, h, Color( 150,50,50 ) )
			draw.RoundedBox( 2, 2, 2, w - 4, h - 4, Color( 200, 75, 75 ) )
		end
	
	hook.Add( "ShutDown", self, function()
		if not IsValid( self ) or not self.HTML then return end
		self:SaveSnippets()
	end )
	
end

local lua_editor_url = CreateClientConVar("lua_editor_url","",false,false)
function PANEL:GetURL()
	return (lua_editor_url:GetString():find"https?://" and lua_editor_url:GetString()) or self.URL
end

function PANEL:LoadURL()
	self:SetHasLoaded( false )
	self.HTML:OpenURL( self:GetURL() )
	self.LoadBtn:SetVisible( true )
end

function PANEL:CreateHTML()
	self.HTML = vgui.Create( "DHTML", self )
		self.HTML:Dock( FILL )
		self.HTML:RequestFocus()
		self.HTML.OnFocusChanged = function( _, gained ) self:OnFocus( gained ) end
		self.LoadBtn:MoveToAfter( self.HTML )
		self.HTML.Paint= function(self) self:IsLoading() end
			
		function self.HTML.ConsoleMessage( html, msg )

			Msg( "[LEDITOR] " )
			print( msg==nil and "*js variable?*" or msg )

		end
	
	local function bind( name ) -- creates the js->lua callback: gmodinterface.funcname -> PANEL:funcname( ... )
		self.HTML:AddFunction( "gmodinterface", name, function( ... )
			self[ name ]( self, ... )
		end )
	end
	
	bind "OnReady"
	bind "OnCode"
	bind "OnLog"
	bind "onmousedown"
	bind "InternalSnippetsUpdate"
	
	self:LoadURL()
end

function PANEL:Paint( w, h ) -- delayed loading
	if not self.__loaded then
		self.__loaded = true
		self:RefreshAutocompletes()
		self:CreateHTML()
	end
end

function PANEL:Think()
	if not self.HTML or not self:GetHasLoaded() then return end
	
	if self.mdown then
		local mrx, mry = self.HTML:CursorPos()
		local pw, ph = self.HTML:GetSize()
		
		if mrx < 0 or mry < 0 or mrx > pw or mry > ph then
			local fx, fy = math.Clamp( mrx, 1, pw - 1 ), math.Clamp( mry, 1, ph - 1 )
			local sx, sy = self.HTML:LocalToScreen( fx, fy )
			
			input.SetCursorPos( sx, sy ) -- not all the commands go through so we spam this shit
			gui.InternalCursorMoved( sx, sy )
			
			if not input.IsMouseDown( MOUSE_LEFT ) then
				gui.InternalMouseReleased( MOUSE_LEFT )
				self.HTML:PostMessage( "MouseReleased", "code", MOUSE_LEFT )
				self.mdown = false
			end
		end
	end
end

local function encode( str )
	return str:gsub( '\\', [[\\]] ):gsub( '"', [[\"]] ):gsub( '\r', [[\r]] ):gsub( '\n', [[\n]] )
end

local function FormatFilename( str ) -- removes bad characters
	return str:gsub( "[^%/%w%_%. ]", "" )
end

function PANEL:GotoErrorLine()
	if self:GetHasLoaded() then self.HTML:Call( "GotoLine(" .. ( self.ErrorLine or 0 ) .. ");" ) end
end

function PANEL:ValidateCode( code )
	code = code or self:GetCode()
	
	if not code or code:len() < 1 or self:GetMode() != "glua" then
		self:SetError( false )
		return
	end
	
	local took = SysTime()
	local var  = CompileString( code, "lua_editor", false )
	took = ( SysTime() - took ) * 1000
	
	if 		type( var ) == "string" then self:SetError( var )
	elseif	took > self.CTThreshold then self:SetError( "Compiling took " .. math.Round( took, 2 ) .. " ms" )
	else								 self:SetError( false ) end
end

function PANEL:FindFileByName( name )
    return file.Read( name, "GAME" ) or file.Read( self.SaveDirectory .. name .. ".txt", "DATA" )
end

function PANEL:ReloadPage( full )
	if not self:GetHasLoaded() then return end
	self:SaveSnippets()
	self.HTML:Call( "location.reload(".. (full and "true" or "") ..");" )
end

function PANEL:ShowBinds()
	self.HTML:Call("ShowBinds();")
end

function PANEL:ShowMenu()
	self.HTML:Call("ShowMenu();")
end

-- Events
function PANEL:onmousedown()
	self.mdown = true
end

function PANEL:OnRemove()
	self:SaveSnippets()
	hook.Remove( "ShutDown", self )
end

function PANEL:OnLog( ... )
	Msg "Editor: " print( ... )
end

function PANEL:OnReady()
	self.LoadBtn:SetVisible( false )
	self:SetHasLoaded( true )
	self.Sessions = {} -- this fix a location.reload(); bug
	self.Snippets = {}
	
	self.HTML:Call [[
		document.body.onmousedown = function( evt ) {
			if (evt.button == 0 || evt.button == 1) {
				gmodinterface.onmousedown();
			};
	    }
		var snippets = ace.require("ace/snippets").snippetManager;
		
		editor.on( "change", function() {
			gmodinterface.OnCode( editor.getSession().getValue() );
		} );
		
		editor.sessions	  = editor.sessions	  || {};
		editor.addSession = editor.addSession || function( sessID, txt, mode ) {
			editor.sessions[ sessID ] = ace.createEditSession( txt, "ace/mode/"+mode );
		}
		editor.updateSnippetsList = editor.updateSnippetsList || function( mode ) {
			gmodinterface.InternalSnippetsUpdate( JSON.stringify( snippets.snippetNameMap[ mode || "glua" ] ) );
		}
		editor.addSnippet = editor.addSnippet || function( name, content, mode ) {
			snippets.register( { content:content, name:name, tabTrigger:name }, mode || "glua" );
			editor.updateSnippetsList();
		}
		editor.removeSnippet = editor.removeSnippet || function( name, mode ){
			snippets.unregister( snippets.snippetNameMap[ mode || "glua" ][ name ] );
			editor.updateSnippetsList();
		}
		
		editor.updateSnippetsList();
	]]
	
	self:LoadConfigs()
	if self:GetDoLoadSnippets() then self:LoadSnippets( util.JSONToTable( self:GetCookie( "Snippets" ) or "" ) or {} ) end
	
	self:SetSession( "Default" )
	self:ValidateCode()
	self:OnLoaded()
end

function PANEL:OnCode( code )
	local sessName = self:GetSessionName()
	
	timer.Create( "lua_editor_autosave_" .. sessName, 0.7, 1, function()
		if not self then return end
		self:Save( code, sessName )
		self:ValidateCode( code )
	end )
	
	self.Sessions[ sessName ] = code
	self:OnCodeChanged( code, sessName )
end

PANEL.OnFocus			= function( self ) end
PANEL.OnLoaded 			= function( self, gain ) end
PANEL.OnCodeChanged		= function( self, code, sessName ) end
PANEL.OnSessionAdded	= function( self, name, content ) end
PANEL.OnSessionRemoved	= function( self, name ) end
PANEL.OnSessionChanged  = function( self, name ) end

function PANEL:Save( code, filename )
	if not filename or filename:len() < 1 or not code then 	return end
	if file.Read( filename, "GAME" ) then                   return end
	if code:len() < 1 then self:DeleteFile( filename ) 		return end
	
	filename = FormatFilename( filename )
	local folderPath = ""
	
	for folder in filename:gmatch( "(.+)/" ) do -- for filesname in form of "myfolder/anotherfolder/filename"
		folderPath = folderPath .. folder .. "/"
	    file.CreateDir( self.SaveDirectory .. folderPath )
	end
	
	file.Write( self.SaveDirectory .. filename .. ".txt", code )
end

function PANEL:DeleteFile( filename )
	local path = self.SaveDirectory .. FormatFilename( filename ) .. ".txt"
	
	if file.Exists( path, "DATA" ) then
		file.Delete( path )
		
		local folders = {}
        for folder in filename:gmatch( "(%w+)/" ) do
        	table.insert( folders, folder )
        end
        
        filename = filename:gsub( "[^%/]+$", "" ):gsub( "/$", "" )
        for i = #folders, 1, -1 do
            file.Delete( self.SaveDirectory .. filename )
            filename = filename:gsub( "/" .. folders[i], "" )
        end

	end
end

function PANEL:LoadConfigs()
	if ( not self.HTML ) or not self:GetHasLoaded() then return end
	
	self:SetFontSize( self:GetCookie( "FontSize" ) )
	self:SetTheme( self:GetCookie( "Theme" ) )
	self:SetMode( self:GetCookie( "SyntaxMode" ) )
end

function PANEL:SetCode( content, sessionName )
	if not self.HTML or not self:GetHasLoaded() then return end
	sessionName = sessionName or self:GetSessionName()
	
	self:SetSession( sessionName )
	self.HTML:Call( [[editor.sessions["]] .. sessionName .. [["].getDocument().setValue( "]] .. encode( content or "" ) .. [[" );]] )
end

function PANEL:GetCode( sessionName )
	return self:GetHasLoaded() and self:GetSession( sessionName ) or ""
end

-- Snippets
function PANEL:InternalSnippetsUpdate( JTable ) -- Todo: support multi modes
	if not JTable then return end
	self.Snippets = {}
	
	for name, snippet in pairs( util.JSONToTable( JTable ) ) do
		self.Snippets[ name ] = snippet.content
	end
end

function PANEL:GetSnippets()
	return self.Snippets
end

function PANEL:AddSnippet( name, content, mode )
	if ( not self:GetHasLoaded() ) or ( not name ) or ( not content ) or self.Snippets[ name ] then return end
	self.HTML:Call( [[ editor.addSnippet( "]] .. name .. [[","]] .. encode( content ) .. [[","]] .. ( mode or "glua" ) .. [[" ); ]] )
end

function PANEL:LoadSnippets( snippets, mode )
	if not self:GetHasLoaded() then return end
	
	for name, content in pairs( snippets ) do
		self:AddSnippet( name, content, mode )
	end
end

function PANEL:RemoveSnippet( name, mode )
	if ( not self:GetHasLoaded() ) or ( not name ) then return end
	self.HTML:Call( [[ editor.removeSnippet( "]] .. name .. [[","]] .. ( mode or "glua" ) .. [[" ); ]] )
end

function PANEL:SaveSnippets()
	if not self:GetHasLoaded() or not self:GetDoSaveSnippets() then return end
	self:SetCookie( "Snippets", util.TableToJSON( self:GetSnippets() ) )
end

-- Sessions
function PANEL:AddSession( name, content )
	if not self.HTML or not self:GetHasLoaded() then return end
	if not name or name:len() < 1 or self:GetSession( name ) != nil then return end
	
	name    = FormatFilename( name )
	content = content or self:FindFileByName( name ) or ""
	
	self.Sessions[ name ] = content
	self.HTML:Call( [[editor.addSession( "]] .. name .. [[","]] .. encode( content ) .. [[","]] .. self:GetMode() .. [[" );]] )
	self:OnSessionAdded( name, content )
end

function PANEL:RemoveSession( name )
	if not self.Sessions[ name ] or not self:GetHasLoaded() then return end
	
	self.HTML:Call( [[ delete editor.sessions["]] .. name .. [["]; ]] )
	self.Sessions[ name ] = nil
	self:OnSessionRemoved( name )
end

function PANEL:LoadSessions( sessions )
	if not self:GetHasLoaded() then return end
	
	for name, path in pairs( sessions ) do
		self:AddSession( name, file.Read( path, "GAME" ) )
	end
end

function PANEL:SetSession( name )
	if not self:GetHasLoaded() or not name then return end
	
	if not self.Sessions[ name ] then
		self:AddSession( name )
	end
	
	self.m_sSessName = name
	self.HTML:Call( [[
		editor.setSession( editor.sessions["]] .. name .. [["] );
		editor.getSession().setUseWrapMode( false );
		editor.getSession().setUseSoftTabs( false );
		]] )
	self:ValidateCode()
	self:OnSessionChanged( name )
end

function PANEL:GetSessionName()
	return self.m_sSessName
end

function PANEL:GetSession( name )
	return self.Sessions[ name or self:GetSessionName() ]
end

-- Other
function PANEL:SetTheme( theme )
	self.m_sTheme = table.HasValue( self.Themes, theme ) and theme or "default"
	self:SetCookie( "Theme", self.m_sTheme )
	
	if self.HTML and self:GetHasLoaded() then self.HTML:Call( [[ SetTheme( "]] .. self.m_sTheme .. [[" ); ]] ) end
end

function PANEL:SetFontSize( size )
	self.m_iFontSize = tonumber( size or 12 )
	self:SetCookie( "FontSize", self.m_iFontSize )
	
	if self.HTML and self:GetHasLoaded() then self.HTML:Call( [[ SetFontSize( ]] .. self.m_iFontSize .. [[ ); ]] ) end
end

function PANEL:SetMode( mode )
	self.m_sMode = table.HasValue( self.Modes, mode ) and mode or "glua"
	self:SetCookie( "SyntaxMode", self.m_sMode )
	
	if self.HTML and self:GetHasLoaded() then self.HTML:Call( [[ SetMode( "]] .. self.m_sMode .. [[" ); ]] ) end
end

function PANEL:SetError( err )
	if err then
		self.ErrBtn:SetVisible( true )
		
		local matchage, txt = err:match( "^lua_editor%:(%d+)%:(.*)" )
		local text = matchage and txt and ( "Line " .. matchage .. ":" .. txt ) or err or ""
		local match = err:match( " at line (%d)%)" ) or matchage
		
		self.ErrorLine = match and tonumber( match ) or 1
		self.ErrBtn:SetText( text:gsub( "\r", "\\r" ):gsub( "\n", "\\n" ) )
		self.HTML:Call( 'SetErr(' .. tonumber( self.ErrorLine ) .. ',"' .. encode( err ) .. '");' )
	else
		self.ErrorLine = 0
		self.HTML:Call( "ClearErr();" )
		self.ErrBtn:SetVisible( false )
	end
	
	self:InvalidateLayout()
end

vgui.Register( TAG, PANEL, "EditablePanel" )




----------------------------------






refresh_autocompletes = function()

	
	local _R=debug.getregistry()

	local data = {
		objfuncs = {},
		enums = {},
		modulefuncs = {},
		hooks = {},
		globals = {},
		nonmodulefuncs = {}
	}



	-- the hacks :(

	for hname,f in next,(baseclass.Get("gamemode_base")) do
		if isfunction(f) and isstring(hname) and hname:sub(1,1):upper()==hname:sub(1,1) then
			data.hooks[hname]=true
		end
	end

	for hname,f in next,(baseclass.Get("gamemode_sandbox") or {}) do
		if isfunction(f) and isstring(hname) and hname:sub(1,1):upper()==hname:sub(1,1) then
			data.hooks[hname]=true
		end
	end

	--for hname,f in next,hook.GetTable() do
	--	if not data.hooks[hname] then
	--		data.hooks[hname]=true
	--	end
	--end


	-- Gather object functions
	for objname,v in next,_R do
		if isstring(objname) and istable(v) and (v.MetaID or v.__tostring or v.MetaName) then
			
			for fname,f in next,v do
				if isfunction(f) and isstring(fname) and not fname:find"^__" then
					data.objfuncs[objname..':'..fname]=true
				end
			end
		end
	end

	-- proper packages first
	local bad={_G=true,package=true,_R=true,fx=true,meta=true,last=true,GAMEMODE=true,GM=true,ENT=true,SWEP=true,SENT=true,}
	
	for name,_ in next,bad do
		data.globals[name] = true
	end
	
	for name,t in next,package.loaded do
		if t._NAME and not bad[name] then
			data.globals[name] = true
			for fname,f in next,t do
				if isfunction(f) and isstring(fname) and not fname:find"^__" then
					data.modulefuncs[name..'.'..fname]=true
				end
			end
		end
	end

	-- all _G tables
	for name,t in next,_G do
		if istable(t) and isstring(name) and not bad[name] then
			data.globals[name] = true
			for fname,f in next,t do
				if isfunction(f) and isstring(fname) and not fname:find"^__" then
					if data.modulefuncs[name..'.'..fname] then
						break
					else
						data.nonmodulefuncs[name..'.'..fname]=true
					end
				end
			end
		elseif isfunction(t) and isstring(name) then
			data.globals[name] = true
		end
	end

	-- assrt for dupes
	local t1,t2 = data.modulefuncs,data.nonmodulefuncs local function test(t1,t2)	for k,v in next,t1 do		assert(not t2[k],k) 	end end test(t1,t2) test(t2,t1)

	-- All enums
	for enum,val in next,_G do
		if (isnumber(val) or isstring(val)) and isstring(enum) and enum:upper()==enum then
			data.enums[enum]=true
		end
	end

	for k,tbl in next,data do
		local res= {}
		for fn,_ in next,tbl do
			if #fn>=2 then -- filter small things, sorry
				assert(not fn:find('|',1,true))
				res[#res+1]=fn
			end
		end
		data[k]=res
	end

	local fn = SERVER and 'autocomplete.txt' or 'tmp_autocomplete.dat'
	file.Write(fn,
		SERVER and "\n" or '\n'..'editor_ac = {};'..'\n\n'	)
			
		for name,tbl in next,data do
			table.sort(tbl)
			
			tbl = table.concat(tbl,'|')
			
			if SERVER then
				file.Append(fn,('\tthis.$%s = ("%s").split("|");\n'):format(name,tbl))
			else
				file.Append(fn,('editor_ac.$%s = ("%s").split("|");\n'):format(name,tbl))
			end
			
		end
		



	file.Append(fn,SERVER and '\n' or '\nconsole.log("Clientside autocomplete opened");\n')
	
	Msg"[lua_editor] "print("Wrote clientside autocompletes to data/"..fn)
	
end