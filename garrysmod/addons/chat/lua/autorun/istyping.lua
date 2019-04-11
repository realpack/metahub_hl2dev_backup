
-----------------------------------------------------
local Tag='IsTyping'

FindMetaTable"Player".IsTyping = function(pl)

	return pl:GetNWBool( "IsTyping" )

end



if CLIENT then

	local started = false

	hook.Add("ChatTextChanged",Tag,function(msg)

		if started or not msg or #msg<1 then return end

		started = true

		

		local me = LocalPlayer()

		if me.SetNetData and me:IsValid() then

			me:SetNetData(Tag,true)

		end

		

	end)

	

	hook.Add("FinishChat", Tag,function()

		started = false

		

		local me = LocalPlayer()

		if me.SetNetData and me:IsValid() then

			me:SetNetData(Tag,false)

		end

	end)

	hook.Add("StartChat", "SendIsTyping", function()
		net.Start( "chat.isTypingUpdate" )
			net.WriteBool( true )
		net.SendToServer()
	end)

	hook.Add("FinishChat", "SendIsTyping", function()
		net.Start( "chat.isTypingUpdate" )
			net.WriteBool( false )
		net.SendToServer()
	end)

else

	util.AddNetworkString "chat.isTypingUpdate"
	net.Receive( "chat.isTypingUpdate", function( len, ply )
		ply:SetNWBool( "IsTyping",  net.ReadBool() )
	end)

end



hook.Add("NetData",Tag,function(pl,k,val)

	if k==Tag and (val==true or val==false or val==nil) then

		if SERVER then return true end

		-- TODO: Hook callback

	end

end)