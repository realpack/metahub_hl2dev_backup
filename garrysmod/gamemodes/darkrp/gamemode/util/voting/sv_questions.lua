local Question = { }
local Questions = { }
GM.ques = {}

util.AddNetworkString("DoQuestion")
util.AddNetworkString("KillQuestionVGUI")

local function ccDoQuestion(ply, cmd, args)
	if ply:IsBanned() then return end
	if not Questions[args[1]] then return end
	if not tonumber(args[2]) then return end

	Questions[args[1]]:HandleNewQuestion(ply, tonumber(args[2]))
end
concommand.Add("ans", ccDoQuestion)

function Question:HandleNewQuestion(ply, response)
	if response == 1 or response == 0 then
		self.yn = tobool(response)
	end

	GAMEMODE.ques.HandleQuestionEnd(self.ID)
end

function GM.ques:Create(question, quesid, ent, delay, callback, fromPly, toPly, ...)
	local newques = { }
	for k, v in pairs(Question) do newques[k] = v end

	newques.ID = quesid
	newques.Callback = callback
	newques.Ent = ent
	newques.Initiator = fromPly
	newques.Target = toPly
	newques.Args = {...}

	newques.yn = 0

	Questions[quesid] = newques

	net.Start("DoQuestion")
		net.WriteString(question)
		net.WriteString(quesid)
		net.WriteFloat(delay)
	net.Send(ent)

	timer.Create(quesid .. "timer", delay, 1, function() GAMEMODE.ques.HandleQuestionEnd(quesid) end)
end

function GM.ques:Destroy(id)
	net.Start("KillQuestionVGUI")
		net.WriteString(Questions[id].ID)
	net.Send(Questions[id].Ent)

	Questions[id] = nil
end

function GM.ques:DestroyQuestionsWithEnt(ent)
	for k, v in pairs(Questions) do
		if v.Ent == ent then
			self:Destroy(v.ID)
		end
	end
end

function GM.ques.HandleQuestionEnd(id)
	if not Questions[id] then return end
	local q = Questions[id]
	q.Callback(q.yn, q.Ent, q.Initiator, q.Target, unpack(q.Args))
	Questions[id] = nil
end
