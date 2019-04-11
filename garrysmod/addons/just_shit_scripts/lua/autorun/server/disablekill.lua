local function BlockSuicide(ply)
	ply:ChatPrint("У тебя только одна жизнь, цени это!")
	return false end
hook.Add( "CanPlayerSuicide", "BlockSuicide", BlockSuicide )