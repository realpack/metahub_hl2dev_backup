
-----------------------------------------------------
local Tag="coh"
module(Tag,package.seeall)

if SERVER then
	util.AddNetworkString(Tag)
end

local data=_M.data or {}
_M.data=data

function PlyReinit(pl)
	if pl:IsPlayer() then data[pl]=nil end
end

local Player=FindMetaTable"Player"
function Player.GetTypingMessage(pl)
	return data[pl]
end


local tracedata = {}
function CanSee(ent1, ent2, maxdistance)
	maxdistance = maxdistance or 1024
	local distance = ent1:GetPos():Distance(ent2:GetPos())

	-- Check distance.
	if( distance > maxdistance ) then
		return false
	end

	-- Check using PVS
	if SERVER then
		if not ent1:Visible(ent2) then
			return false
		end
	else
		-- noisy, does not work in draw hook
		--if ent1:IsDormant() or ent2:IsDormant() then return false end
	end

	tracedata.start = ent1:GetShootPos()
	tracedata.endpos = ent2:GetShootPos()
	tracedata.filter = ent1
	tracedata.mask = MASK_VISIBLE

	local trace = util.TraceLine(tracedata)

	if( trace.HitWorld ) then
		return false
	end

	return true
end


function GetVisiblePlayers(ply, maxdistance)

	local visible = {}

	for _, v in pairs(player.GetAll()) do

		if( v ~= ply and CanSee(ply, v, maxdistance ) ) then
			table.insert(visible, v)
		end

	end

	return visible

end


function CanAppend(old,new)

	-- Disabled until serverside tracking is added if it's even worth it
	do return false end

	if old==new then return "" end

	local len = #old
	local can = new:sub(1,len)==old
	if can then
		local ret = true
		ret = new:sub(len+1,-1)
		return ret
	end
	return false
end

function ShouldQuickSend(txt)
	return #txt < 300
end

if CLIENT then

	Colors = {}
	local Colors = Colors
	Colors.Background		= Color(255, 255, 255)
	Colors.Border			= Color(111, 111 , 111)
	Colors.Text			= Color(30, 30, 70)

	Roundness				= 4
	Font					= Tag..'_Font'

		surface.CreateFont( Font, {
			font = "Tahoma",
			size = 13,
			weight = 600,
			antialias = true,
			additive = false
		})

	local LocalPlayer = LocalPlayer
	local surface = surface
	local draw = draw
	local cam = cam

	local coh_enabled=CreateClientConVar("coh_enabled","1",true,true)

	hook.Add("NetworkEntityCreated",Tag,PlyReinit)
	hook.Add("EntityRemoved",Tag,PlyReinit)

	local mindist = 400
	local maxdist = 1024

	local ang = Angle(0,0,90)
	local hdr_check = true
	local hdr
	local vector_1_1_1=Vector(1,1,1)

	-- this thing NEEDS a rewrite
	function Draw(pl, msg)

		if pl == LocalPlayer() then return end

		msg = msg == true and "" or msg

		local dist = pl:GetPos():Distance(LocalPlayer():EyePos())

		local alpha=255
		if dist > mindist then
			alpha = alpha - ((dist - mindist) / (maxdist - mindist)) * 255
		end

		if alpha <= 0 then
			return
		end

		local bone = pl:LookupBone("ValveBiped.Bip01_Head1")
		local pos = bone and pl:GetBonePosition(bone)
		pos=pos or pl:GetShootPos()
		pos = pos + pl:GetUp() * 8
		pos = pos + pl:GetForward() * 4

		Colors.Border.a = alpha
		Colors.Background.a = alpha
		Colors.Text.a = alpha

		surface.SetFont( Font )

		if msg ~= pl.coh_last_msg or not pl.coh_cached_msg_data then

			local data = {lines = {}}
			local x,y = 0,0
			local w,h = 0,0

			if pl.coh_split_msg and #pl.coh_split_msg > 1 then
				if not pl.coh_text_height  then
					local _, _h = surface.GetTextSize("W")
					pl.coh_text_height = _h * table.Count(pl.coh_split_msg) * 0.5
				end

				for key, line in pairs(pl.coh_split_msg) do
					local _w = surface.GetTextSize(line)
					w = _w > w and _w or w
				end

				h = pl.coh_text_height
			else
				w, h = surface.GetTextSize( msg )
			end

			w = w + 4
			if h > 20 then h = h * 2 end

			data.w = w
			data.x = x
			data.y = y

			local lines = string.Explode("\n", msg)
			local max = #lines
			for i, v in pairs(lines) do

				if( v == "" ) then
					v = " "
				end

				data.lines[i] = {str = v, x = x + Roundness, y = y + Roundness - 2}

				if max > 1 and i ~= max then
					local _, add_h = surface.GetTextSize(v)
					y = y + add_h
				end
			end

			local scale = 1

			if msg == "" then
				msg = ("."):rep( math.floor(CurTime() * 2) % 4 )
				w, h = surface.GetTextSize( msg )
			elseif h > 50 then
				y = y - h
				scale = math.min(w/h, 1)
			end

			data.h = h + y


			data.scale = scale

			pl.coh_cached_msg_data = data
			pl.coh_last_msg = msg

		end


		local data = pl.coh_cached_msg_data
		local x, y, w, h, scale = data.x, data.y, data.w, data.h, data.scale
		local tm

		ang.y = pl:EyeAngles().y + 90
		if hdr then
			tm = render.GetToneMappingScaleLinear()
			render.SetToneMappingScaleLinear(vector_1_1_1)
		elseif hdr_check then
			hdr_check = false
			local tm = render.GetToneMappingScaleLinear()
			hdr = tm.x~=1 or tm.y~=1 or tm.z~=1
		end
		cam.IgnoreZ(true)
			cam.Start3D2D(pos, ang, 0.15 * scale)
				draw.RoundedBox(
					Roundness,

					x - 2,
					y - 2 - h,
					w + 4 + Roundness,
					h + 4 + Roundness,

					Colors.Border
				)

				draw.RoundedBox(
					Roundness,

					x - 1,
					y - 1 - h,
					w + 2 + Roundness,
					h + 2 + Roundness,

					Colors.Background
				)

				surface.SetTextColor(
					Colors.Text.r,
					Colors.Text.g,
					Colors.Text.b,
					Colors.Text.a
				)

				for _, data in pairs(data.lines) do
					surface.SetTextPos( data.x, data.y - h )
					surface.DrawText( data.str )
				end

			cam.End3D2D()
		cam.IgnoreZ(false)
		if tm then
			render.SetToneMappingScaleLinear(tm)
		end
	end


	started_typing = false
	function StartChat()

		if not coh_enabled:GetBool() then return end
		if not started_typing then
			started_typing = true
		elseif started_typing then return end
		WriteMessage(nil,msg_typing)

		last_txt_sent = false
		text_queue = false
	end
	hook.Add("StartChat", Tag, StartChat)

	function FinishChat()

		--if not coh_enabled:GetBool() then return end

		if started_typing then
			started_typing = false
		elseif not started_typing then return end

		WriteMessage(nil,msg_endtyping)

		text_queue = false

		last_txt_sent = false

	end
	hook.Add("FinishChat", Tag, FinishChat)

	function ChatTextChanged( text )

		if not started_typing then return end
		SendTypedMessage(text)

	end
	hook.Add("ChatTextChanged", Tag, ChatTextChanged )

	local function setup_suppress()
		local last_framenumber = 0
		local current_frame = 0
		local current_frame_count = 0

		return function()
			local frame_number = FrameNumber()

			if frame_number == last_framenumber then
				current_frame = current_frame + 1
			else
				last_framenumber = frame_number

				if current_frame_count ~= current_frame then
					current_frame_count = current_frame
				end

				current_frame = 1
			end

			return current_frame < current_frame_count
		end
	end

	local should_suppress = setup_suppress()

	function PostDrawTranslucentRenderables()

		-- if not coh_enabled:GetBool() then return end

		if should_suppress() then return end

		local me = LocalPlayer()

		for ply, msg in pairs(data) do
			if CanSee(me, ply) then
				Draw(ply, msg)
			end
		end

	end

	hook.Add("PostDrawTranslucentRenderables", Tag, PostDrawTranslucentRenderables)

end



waiting_ack = false
last_txt_sent = false
text_queue = false
function SendTypedMessage(text)

	-- clear to send
	if text == true then
		waiting_ack = false

		if not last_txt_sent then
			data[LocalPlayer()] = nil
		else
			data[LocalPlayer()] = last_txt_sent
		end

		if text_queue then
			assert(text_queue~=true,"internal failure")
			SendTypedMessage(text_queue)
		end

		return

	end

	if waiting_ack then
		--Dbg("queueud",text)
		text_queue = text
		return
	end

	local append = isstring(last_txt_sent) and isstring(text) and CanAppend(last_txt_sent,text)

	last_txt_sent = text

	assert(isstring(text),"text is not text: "..tostring(text))
	text_queue = false

	local tosend = append and append or text
	WriteMessage(nil,append and msg_data_append or msg_data,tosend)

	-- so we don't slow down on small text without reason
	if ShouldQuickSend(tosend) then
		waiting_ack = false
	else
		waiting_ack = true
	end

	return

end

-- message enums
msg_typing = 1
msg_endtyping = 2
msg_data = 3
msg_data_append = 4
msg_data_ack = 5

function GotMessage(pl)
	if CLIENT then
		pl = net.ReadEntity(pl)
		if not IsValid(pl) then return end
	end

	local msgtype = net.ReadUInt(8)
	local msg
	--Dbg(pl,msgtype)

	if msgtype == msg_typing then
		data[pl]=true
	elseif msgtype == msg_endtyping then
		data[pl]=nil
	elseif msgtype == msg_data then
		msg = net.ReadString()
		assert(isstring(msg),"wtf")
		local olddata = data[pl]
		if olddata then
			data[pl] = msg
		else
			--assert(false,"no data but typing: "..msg)
		end
	elseif msgtype == msg_data_append then
		msg = net.ReadString()
		assert(isstring(msg),"wtf")
		local olddata = data[pl]

		olddata = olddata==true and "" or olddata

		if olddata then
			data[pl] = olddata..msg
		else
			-- TODO: Do fullupdate on server for first send clients :(
			data[pl] = "..."..msg
		end
	elseif msgtype == msg_data_ack then
		assert(pl==LocalPlayer(),"ACK player is not local player??")

		SendTypedMessage(true)

	else
		ErrorNoHalt("Chat over head: Invalid message type"..msgtype..'\n')
		return
	end

	--if CLIENT then Dbg(pl,msgtype,msg,data[pl or false]) end

	if SERVER then
		WriteMessage(pl,msgtype,msg)
	end

end
function Dbg(...)
	Msg('['..Tag..'] ')print(...)
end

function WriteMessage(pl,msgtype,msg)
	net.Start(Tag)

	if SERVER then
		net.WriteEntity(pl)
	end

	net.WriteUInt(msgtype,8)


	if msgtype == msg_data or msgtype == msg_data_append then

		-- it's a limitation but it's sufficiently huge even with utf16 or whatever
		msg = msg:sub(1,64*1024-64)
		net.WriteString(msg)
	else
		assert(not msg,"data on non data message")
	end

	if CLIENT then
		return net.SendToServer()
	end

	if msgtype == msg_data or msgtype == msg_data_append then

		-- others get the message
		local pls = GetVisiblePlayers(pl)
		net.Send(pls)

		-- you'll just get an ack o:
		WriteMessage(pl,msg_data_ack)

	elseif msgtype == msg_data_ack then
		net.Send(pl)
	elseif msgtype == msg_typing or msgtype == msg_endtyping then
		net.Broadcast()
	else
		ErrorNoHalt("Chat over head: Invalid message type"..msgtype..'\n')
	end

end


net.Receive(Tag,function(len,pl) GotMessage(pl) end)
