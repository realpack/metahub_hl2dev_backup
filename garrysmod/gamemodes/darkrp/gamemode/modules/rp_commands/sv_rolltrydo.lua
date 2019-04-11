local function RollTheDice(pl, text, args)
  rp.LocalChat(CHAT_NONE, pl, 250, Color(200,0,0), '[', Color(200,0,100), 'КОСТИ', Color(200,0,0), '] ', pl:GetJobColor(), pl:Name(), color_white, ' кидает кубик и получает ', Color(200,0,100), tostring(math.random(100)), color_white, ' из 100.')
end
rp.AddCommand("/roll", RollTheDice)

local function try(pl, text, args)
  if args == "" then
    return ""
  end

  local random = "Не получилось"
  local chance
  local color = Color(200,0,0)
  chance = math.random(1,100)
  if chance >= 30 then
    random = "Успешно"
    color = Color(0,200,0)
  end
  rp.LocalChat(CHAT_NONE, pl, 250, pl:GetJobColor(), pl:Name(), color_white, " "..text, color, " ("..random..")")
end
rp.AddCommand("/try", try)

local function dochat(pl, text, args)
  if args == "" then
    return ""
  end

  rp.LocalChat(CHAT_NONE, pl, 250, pl:GetJobColor(), pl:Name(), color_white, " "..text)
end
rp.AddCommand("/do", dochat)
