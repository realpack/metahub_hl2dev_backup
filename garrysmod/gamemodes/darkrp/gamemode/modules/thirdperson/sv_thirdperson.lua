util.AddNetworkString('thirdperson_toggle')

hook.Add("ShowHelp", "ThirdpersonOpen", function( pPlayer )
	net.Start('thirdperson_toggle')
    net.Send(pPlayer)
end)

function GM:ShowHelp()

end
