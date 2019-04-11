
local col_lime  = Color(100,210,40)
local col_light = Color(228,228,228)
local col_red   = Color(250,30,90)

function IGS.NotifyAll(text)
	chat.AddTextSV(
		col_lime,"[IGS]",
		col_red," > ",
		col_light,text,
		col_red,"."
	)
end


function IGS.Notify(pl,msg,time,type)
	pl:ChatPrintColor(
		col_lime, "[IGS]",
		col_red,  " > ",
		col_light,msg,
		col_red,  "."
	)
end


-- todo реальный логгинг
function IGS.LogError(err)
	error(err)
end
