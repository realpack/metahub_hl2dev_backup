wmat = {
	Queue = {},
	Cache = {},
	Busy = false,
	HandlerURL = ''
}

if (not file.IsDir('wmat', 'DATA')) then 
	file.CreateDir('wmat')
end

function wmat.Create(name, opts, onsuccess, onfailure)
	local crc = util.CRC(name .. '.' .. opts.URL)
	table.insert(wmat.Queue, {
		Name 		= name,
		URL 		= string.JavascriptSafe(opts.URL),
		CRC			= crc,
		Cache		= opts.Cache,
		W 			= (opts.W or 4096),
		H 			= (opts.H or 4096),
		Timeout 	= (opts.Timeout or 5),
		OnSuccess 	= function(this, html_mat, w, h)
			local mat
			if (this.LoadedFromCache) then 
				--print(this.Name .. " successfully loaded from cache.")
				mat = html_mat
			else
				local id = util.CRC(this.URL .. name)
				local rt = GetRenderTarget('wmat_' .. id, w, h, RT_SIZE_NO_CHANGE, 0, 0, 0, 0)

				opts.MaterialData 					= opts.MaterialData 				or {}
				opts.MaterialData['$basetexture'] 	= opts.MaterialData['$basetexture'] or rt:GetName()
				opts.MaterialData['$translucent'] 	= opts.MaterialData['$translucent'] or 1

				mat = CreateMaterial('wmat_' .. id, (opts.Shader or 'UnlitGeneric'), opts.MaterialData)
				local oldrt = render.GetRenderTarget()

				render.SetViewPort(0, 0, w, h)
				render.SetRenderTarget(rt)
				render.Clear(0, 0, 0, 0)
					cam.Start2D()
						surface.SetDrawColor(255, 255, 255, 255)
						surface.SetMaterial(html_mat)
						surface.DrawTexturedRect(0, 0, 4096, 4096)
					cam.End2D()
				render.SetViewPort(0, 0, ScrW(), ScrH())
				render.SetRenderTarget(oldrt)
				
				if this.Cache then this:CompleteCache() end
			end

			wmat.Cache[name] = mat

			if onsuccess then onsuccess(mat) end
		end,
		OnFailure = function(this)
			if onfailure then onfailure() end
		end,
		Base64 = '',
		CacheChunk = function(this, chunk)
			this.Base64 = this.Base64 .. chunk		
		end,
		CompleteCache = function(this)
			local p = string.find(this.Base64, ',')
			if p then
				this.Base64 = string.sub(this.Base64, p)
			else
				print('Error parsing base64 string ' .. this.URL)
			end
			if this.WriteStaggered then
				file.WriteStaggered('wmat/' .. crc .. '.png', util.Base64Decode(this.Base64), function() end)
			else
				file.Write('wmat/' .. crc .. '.png', util.Base64Decode(this.Base64))
			end
		end
	})
end

function wmat.Get(name)
	return wmat.Cache[name]
end

function wmat.Delete(name)
	wmat.Cache[name] = nil
end

function wmat.ClearCache()
	wmat.Cache = {}
end

function wmat.SetHandler(handler)
	wmat.HandlerURL = handler
end

function wmat.Succeed()
	wmat.Handler:UpdateHTMLTexture()

	local inf = wmat.Queue[1]

	if (inf) then
		if inf.Cache and (inf.Base64 == '') then -- tends to happen if the handler URL goes down or lags
			inf:OnFailure()
		else
			inf:OnSuccess(wmat.Handler:GetHTMLMaterial(), inf.W, inf.H)
		end
	end
	table.remove(wmat.Queue, 1)
	wmat.Busy = false
end

function wmat.Fail()
	local inf = wmat.Queue[1]
	
	if (inf) then
		inf:OnFailure()
	end
	
	table.remove(wmat.Queue, 1)
	wmat.Busy = false
end

function wmat.Chunk(data)
	local inf = wmat.Queue[1]
	
	if (inf) then
		inf:CacheChunk(data)
	end
end

hook.Add('InitPostEntity', 'wmat.InitPostEntity', function()
	wmat.Handler = vgui.Create 'DHTML'
	wmat.Handler:SetSize(4096, 4096)
	wmat.Handler:SetPaintedManually(true)
	wmat.Handler:SetMouseInputEnabled(false)
	wmat.Handler:SetAllowLua(true)
	wmat.Handler:SetHTML([[
		<body style='margin: 0; overflow: hidden;'>
			<div id='cont'></div>
			<canvas id='canvas'/>
		</body>
		<script type='text/JavaScript'>
			var base64 = '';
			var b64size = 0;
			var step = 0;
			var chunkSize = 384 * 1024;
			var timerVar = 0;
			var w = 0;
			var h = 0;
			function handleChunk() {
				console.log('RUNLUA:wmat.Chunk("' + base64.substring(step, step+chunkSize) + '")');
				step = step + chunkSize + 1;
				
				if (b64size < step) {
					console.log('RUNLUA:timer.Simple(0.1, wmat.Succeed)');
					clearInterval(timerVar);
				}
			}
				
			function SetImage(handler, url, imgW, imgH, timeout, shouldCache){
				base64 = '';
				b64size = 0;
				step = 0;
				timerVar = 0;
				w = imgW;
				h = imgH;
				
				var loaded = false;

				document.getElementById('cont').innerHTML = "<img id='img' width = '" + w + "' height = '" + h + "'>";
				document.getElementById('img').crossOrigin = 'Anonymous';
				
				setTimeout(function() {
					if (!loaded) {
						console.log('RUNLUA:wmat.Fail()');
					}
				}, timeout);
			
				document.getElementById('img').onload = function(){
					loaded = true;
					
					var canvas = document.getElementById('canvas');
					canvas.width = w;
					canvas.height = h;
					var ctx = canvas.getContext('2d');
					var img = document.getElementById('img');
					ctx.drawImage(img, 0, 0, w, h);
					
					if (shouldCache == 1) {
						base64 = canvas.toDataURL();
						b64size = base64.length;
						timerVar = setInterval(handleChunk, 100);
					} else {
						console.log('RUNLUA:timer.Simple(0.1, wmat.Succeed)');
					}
				}
				
				document.getElementById('img').src = handler + encodeURIComponent(url);
			}
			
			function SetImageData(data, w, h){
				document.getElementById('cont').innerHTML = "<img id='img' width = '" + w + "' height = '" + h + "'>";
				document.getElementById('img').src = data;
				
				console.log('RUNLUA:timer.Simple(0.5, wmat.Succeed)');
			}
		</script>
	]])
	
	wmat.Handler.Think = function(self)               
		if (not wmat.Busy) and (#wmat.Queue > 0) then
			local info = wmat.Queue[1]

			if (file.Exists('wmat/' .. info.CRC .. '.png', 'DATA')) then
				local mat = Material('../data/wmat/' .. info.CRC .. '.png')
				info.LoadedFromCache = true
				info:OnSuccess(mat, info.W, info.H)
				table.remove(wmat.Queue, 1)
			else
				self:RunJavascript('SetImage("' .. wmat.HandlerURL .. '", "' .. info.URL.. '", "' .. math.Clamp(info.W, 0, 4096)  .. '", "' .. math.Clamp(info.H, 0, 4096) .. '", "' .. info.Timeout * 1000 .. '", ' .. (info.Cache and 1 or 0) .. ')')
				wmat.Busy = true
			end
		end
	end
end)


--[[
wmat.Create('SUP', {
	URL = 'http://portal.superiorservers.co/static/images/favicon.png',
	W 	= 184,
	H 	= 184,
}, function(material)
	print(material)
end, function()
	print 'cunt'
end)

hook.Add('HUDPaint', 'awdawd', function()
	if wmat.Get('SUP') then 
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(wmat.Get('SUP'))
		surface.DrawTexturedRect(10, 10, 184, 184)
	end
end)]]