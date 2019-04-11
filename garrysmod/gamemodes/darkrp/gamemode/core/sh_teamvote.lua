if (SERVER) then
	util.AddNetworkString('rp.TeamVote')
	util.AddNetworkString('rp.TeamVoteCountdown')
	
	rp.teamVote = {
		Votes = {}
	}
	
	function rp.teamVote.Create(name, duration, choices, callback)
		local opts = {}
		local optsobjects = {}
		for k, v in ipairs(choices) do
			if (IsValid(v)) then
				opts[#opts + 1] = {v:Name(), v:SteamID()}
				optsobjects[#optsobjects + 1] = v
			end
		end
		
		if (#opts == 1) then
			callback(optsobjects[1], {[optsobjects[1]] = 1})
			return
		end
		
		local data = util.Compress(pon.encode(opts))
		local size = #data
		local recipients = table.Filter(player.GetAll(), function(v)
			return !table.HasValue(choices, v)
		end)
		
		net.Start('rp.TeamVote')
			net.WriteString(name)
			net.WriteUInt(CurTime() + duration, 32)
			net.WriteUInt(size, 16)
			net.WriteData(data, size)
		net.Send(recipients)
		
		local vote = {
			StartTime = CurTime(),
			Duration = duration,
			Choices = choices,
			Voters = recipients,
			Votes = {},
			Callback = callback
		}
		
		rp.teamVote.Votes[name] = vote
		
		hook('Tick', 'rp.TeamVote', rp.teamVote.Tick)
	end
	
	function rp.teamVote.CountDown(name, duration, callback)
		net.Start('rp.TeamVoteCountdown')
			net.WriteString(name)
			net.WriteFloat(CurTime() + duration)
		net.Broadcast()
		
		timer.Create('rp.TeamVote.' .. name, duration, 1, callback)
	end
	
	function rp.teamVote.Tick()
		local count = 0
		
		for k, v in pairs(rp.teamVote.Votes) do
			local shouldFinish = CurTime() > v.StartTime + v.Duration
			
			if (shouldFinish) then
				local winner
				local winnervotes = 0
				
				for k, v in pairs(v.Votes) do
					if (IsValid(k) and v > winnervotes) then
						winner = k
						winnervotes = v
					end
				end
				
				v.Callback(winner, v.Votes)
				
				rp.teamVote.Votes[k] = nil
				return
			end
			
			count = count + 1 
		end
		
		if (count == 0) then
			hook.Remove('Tick', 'rp.TeamVote')
			return
		end
	end
	
	net('rp.TeamVote', function(len, pl)
		local votename = net.ReadString()
		local votechoice = rp.FindPlayer(net.ReadString())
		
		if (!IsValid(votechoice)) then return end
		
		local vote = rp.teamVote.Votes[votename]
		
		if (!vote) then return end
		
		for k, v in ipairs(vote.Voters) do
			if (IsValid(v) and v == pl) then
				table.remove(vote.Voters, k)
				
				vote.Votes[votechoice] = (vote.Votes[votechoice] or 0) + 1
			end
		end
	end)
	
	return
end

local cdframes = {}

local function createTeamVoteWindow(votename, endtime, options)
	if (IsValid(cdframes[votename])) then cdframes[votename]:Remove() end
	
	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle(votename .. ' Vote')
		self:SetSize(300, math.min(34 + #options * 25), 159)
		self:SetPos(ScrW() - 300, ScrH() - self:GetTall())
	end)
	
	local scr = ui.Create('ui_scrollpanel', function(self)
		self:DockMargin(0, 3, 0, 0)
		self:Dock(FILL)
		
		self.OT = self.Think
		self.Think = function(self)
			self:OT()
			
			if (SysTime() > endtime and !self.Closing) then
				self.Closing = true
				fr:Close()
			end
		end
	end, fr)
	 
	for k, v in ipairs(options) do
		local name = v[1]
		local stid = v[2]
		
		local btn = ui.Create('DButton', function(self)
			self:SetTall(25)
			self:SetText(name)
			scr:AddItem(self)
			
			self.DoClick = function(self)
				fr:Close()
				
				chat.AddText(rp.col.White, 'Voted for ' .. name .. '.')
				
				net.Start('rp.TeamVote')
					net.WriteString(votename)
					net.WriteString(stid)
				net.SendToServer()
			end
		end)
	end
	
	if (LocalPlayer():IsAdmin()) then
		local deny = ui.Create("DButton", function(self)
			self:SetSize(55, 28)
			self:SetPos(fr:GetWide() - 105, 0)
			self:SetCommand("!")
			self:SetText("Deny")
			self.DoClick = function()
				RunConsoleCommand('ba', 'denyteamvote', votename)
				fr:Close()
			end
			self.Paint = function(self, w, h)
				draw.OutlinedBox(0, 0, w, h, (self.Hovered and ui.col.CloseHovered or ui.col.CloseBackground), ui.col.Outline)
			end
			self:SetTextColor(ui.col.Close)
		end, fr)
	end
end

local cred = Color(240, 0, 0)
local cgreen = Color(50, 200, 50)
local function createTeamVoteCountdown(votename, endtime)
	local fr = ui.Create('ui_frame', function(self)
		self:SetTitle('')
		self:SetSize(300, 59)
		self:SetPos(ScrW() - 300, ScrH() - 59)
	end)
	
	local pnl = ui.Create('panel', function(self)
		self:DockMargin(0, 3, 0, 0)
		self:Dock(FILL)
		self.EndTime = endtime
		self.StartTime = SysTime()
		
		self.Paint = function(self, w, h)
			local diff = math.Clamp(self.EndTime - SysTime(), 0, math.huge)
			local prog = math.Clamp((SysTime() - self.StartTime) / (self.EndTime - self.StartTime), 0, 1)
			
			fr:SetTitle(votename .. ' Vote: Starts in ' .. math.ceil(diff) .. 's')
			
			surface.SetDrawColor(LerpColor(prog, cgreen, cred))
			surface.DrawRect(1, 1, (w - 2) - prog * (w - 2), h - 2)
			
			surface.SetDrawColor(rp.col.Outline)
			surface.DrawOutlinedRect(0, 0, w - prog * w, h)
			
			if (diff == 0) then
				fr:Close()
				self.Paint = function() end
			end
		end
	end, fr)
	
	cdframes[votename] = fr
end

net('rp.TeamVoteCountdown', function(len)
	local team = net.ReadString()
	local endtime = SysTime() + (net.ReadFloat() - CurTime())
	
	createTeamVoteCountdown(team, endtime)
end)

net('rp.TeamVote', function(len)
	local team = net.ReadString()
	local endtime = SysTime() + (net.ReadUInt(32) - CurTime())
	local size = net.ReadUInt(16)
	local data = net.ReadData(size)
	
	local options = pon.decode(util.Decompress(data))
	
	createTeamVoteWindow(team, endtime, options)
end)