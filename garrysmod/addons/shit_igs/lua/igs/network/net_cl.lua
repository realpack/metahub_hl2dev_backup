-- Запрашивает покупку итема в инвентарь
function IGS.Purchase(sItemUID,bAllServers,callback)
	net.Start("IGS.Purchase")
		net.WriteString(sItemUID)
		net.WriteBool(bAllServers)
	net.SendToServer()

	net.Receive("IGS.Purchase",function()
		local errMsg  = !net.ReadBool() and net.ReadString()
		local iID = !errMsg and net.ReadUInt(20) -- iID = InvID, если есть инвентарь, иначе PurchaseID (если покупка со сроком != 0)

		if callback then
			callback(errMsg,iID)
		end

		if errMsg then
			hook.Run("IGS.OnFailedPurchase", IGS.GetItemByUID(sItemUID), bAllServers, errMsg )
		else
			hook.Run("IGS.OnSuccessPurchase", IGS.GetItemByUID(sItemUID), bAllServers, iID )
		end
	end)
end

-- Активирует купленный итем (Только если IGS.C.Inv_Enabled)
function IGS.Activate(iInvID,callback)
	net.Start("IGS.Activate")
		net.WriteUInt(iInvID,20)
	net.SendToServer()

	if !callback then return end
	net.Receive("IGS.Activate",function()
		callback(!net.ReadBool() and net.ReadString()) -- errMsg on error
	end)
end

function IGS.UseCoupon(sCoupon,callback)
	net.Start("IGS.UseCoupon")
		net.WriteString(sCoupon)
	net.SendToServer()

	net.Receive("IGS.UseCoupon",function()
		callback(!net.ReadBool() and net.ReadString())
	end)
end

--[[-------------------------------------------------------------------------
	Ссылки
---------------------------------------------------------------------------]]
function IGS.GetPaymentURL(iSum,fCallback)
	net.Start("IGS.GetPaymentURL")
		net.WriteDouble(iSum)
	net.SendToServer()

	net.Receive("IGS.GetPaymentURL",function()
		fCallback(net.ReadString())
	end)
end

function IGS.GetHelpURL(fCallback)
	net.Ping("IGS.GetHelpURL")

	net.Receive("IGS.GetHelpURL",function()
		fCallback(net.ReadString())
	end)
end



local cache,last_update = {},0 -- на сервере тоже кэширование
function IGS.GetLatestPurchases(fCallback)
	if last_update + 60 >= os.time() then
		fCallback(cache)
		return
	end

	net.Ping("IGS.GetLatestPurchases")
	net.Receive("IGS.GetLatestPurchases",function()
		local dat = {}
		for i = 1,net.ReadUInt(6) do
			dat[i] = {
				serv   = net.ReadUInt(5),
				nick   = net.ReadString(),
				item   = net.ReadString(),
				expire = net.ReadString()
			}

			dat[i].expire = dat[i].expire ~= "*" and dat[i].expire
			dat[i].nick   = dat[i].nick   ~= "*" and dat[i].nick
		end

		cache = dat
		last_update = os.time()

		fCallback(dat)
	end)
end

-- тут таймаут не нужно. Даже если заспамить net - ничего не произойдет
function IGS.GetMyTransactions(fCallback)
	net.Ping("IGS.GetMyTransactions")

	net.Receive("IGS.GetMyTransactions",function()
		local dat = {}
		for i = 1,net.ReadUInt(8) do
			dat[i] = {
				id   = net.ReadUInt(20),
				serv = net.ReadUInt(5),
				sum  = net.ReadDouble(),
				date = net.ReadUInt(32), -- timestamp
				note = net.ReadString()
			}
		end

		fCallback(dat)
	end)
end

function IGS.GetMyPurchases(fCallback)
	net.Ping("IGS.GetMyPurchases")

	net.Receive("IGS.GetMyPurchases",function()
		local dat = {}
		for i = 1,net.ReadUInt(8) do
			dat[i] = {
				id   = net.ReadUInt(20),
				item = net.ReadString(),
				serv = net.ReadUInt(5), -- if 0 then disabled
				purchase = net.ReadUInt(32), -- timestamp
				expire = net.ReadUInt(32), -- timestamp
			}

			if dat[i].purchase == 0 then
				dat[i].purchase = nil
			end

			if dat[i].expire == 0 then
				dat[i].expire = nil
			end

			if dat[i].serv == 0 then
				dat[i].serv = nil
			end
		end

		fCallback(dat)
	end)
end




--[[-------------------------------------------------------------------------
	Инвентарь
---------------------------------------------------------------------------]]
function IGS.GetInventory(fCallback)
	net.Ping("IGS.GetInventory")

	net.Receive("IGS.GetInventory",function()
		local d = {}

		for i = 1,net.ReadUInt(7) do
			d[i] = {
				id = net.ReadUInt(20),
				data = {
					uid    = net.ReadString(),
					global = net.ReadBool(),
					amount = net.ReadUInt(8),
				}
			}
		end

		fCallback(d)
	end)
end

function IGS.DropItem(iID,fCallback) -- энтити в каллбэке
	if !IGS.C.Inv_AllowDrop then
		IGS.ShowNotify("Дроп предметов отключен администратором", "Ошибка")
		return
	end

	net.Start("IGS.DropItem")
		net.WriteUInt(iID,20)
	net.SendToServer()

	net.Receive("IGS.DropItem",function()
		local ent = net.ReadEntity()

		if fCallback then
			fCallback(ent)
		end
	end)
end




net.Receive("IGS.PaymentStatusUpdated",function()
	local t = {}
	t.paymentType = net.ReadString()
	t.orderSum    = net.ReadString()
	t.method      = net.ReadString()

	if t.method == "error" then
		t.errorMessage = net.ReadString()
	end

	hook.Run("IGS.PaymentStatusUpdated",t)
end)

net.Receive("IGS.UI",function()
	IGS.UI()
end)