ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


			
AddEventHandler('onResourceStart', function(resource)
	TriggerClientEvent("taixiu:batdau",-1)
	print('The resource ' .. resource .. ' has been started.')
	end)

RegisterServerEvent("taixiu:checkmoney")
AddEventHandler("taixiu:checkmoney", function(dice, money)
	local _source   = source
	local xPlayer   = ESX.GetPlayerFromId(_source)
	
if money > 0 then
		if xPlayer.getMoney() >= money then
			TriggerClientEvent('taixiu:checkmoney',source,_source, dice, money)
			
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Bạn không có đủ tiền"})
		end
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Bạn đang tính làm gì vậy ?"})
	end
end)

RegisterServerEvent('taixiu:checkthoigian')
AddEventHandler('taixiu:checkthoigian', function(msg)
	if msg.status == 'success' then
		local xPlayer = ESX.GetPlayerFromId(source)
		local _source = source
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_casino', function(account)
			societyAccount = account
		end)
	
		xPlayer.removeMoney(msg.tiendat)
		updateData('in', msg.tiendat)
		--societyAccount.addMoney(msg.tiendat)
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'success', text = ("Đã đặt "..msg.tiendat.."$")})
	elseif msg.status == 'error' then 
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = ("Chưa đến phiên tiếp theo, vui lòng chờ giây lát!")})
	end
end)

RegisterServerEvent("taixiu:layketqua")
AddEventHandler("taixiu:layketqua", function()
	local _source = source
	
	seed1 = math.random(1, 6)
	seed2 = math.random(1, 6)
	seed3 = math.random(1, 6)
	dice1 = seed1
	dice2 = seed2
	dice3 = seed3


	TriggerClientEvent('taixiu:traketqua', -1, dice1, dice2, dice3)
	Citizen.Wait(30000)
end)

RegisterServerEvent("taixiu:wingame")
AddEventHandler("taixiu:wingame", function(money)
	local _source = source
	

	if GetPlayerName(_source) ~= nil then
		local xPlayer1 = ESX.GetPlayerFromId(_source)
		local name = GetPlayerName(_source)
		xPlayer1.addMoney(money * 1.7)
		updateData('out', money * 1.7)
		local thang = money * 0.7
		TriggerClientEvent('mythic_notify:client:SendAlert', -1, { type = 'success', text = name..' chơi tài xỉu và đã thắng được '..thang..'$' })		
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_casino', function(account)
			societyAccount = account
			--societyAccount.removeMoney(money * 1.7)
		end)
	else 
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Người chơi không tồn tại' })
	end

end)

function updateData(cashType, amount)
print(cashType, amount)
	local money = tonumber(amount)
	if cashType == 'in' then
		MySQL.Sync.execute("UPDATE minigame SET taixiu_in = taixiu_in + @amount", {['@amount'] = money})
	elseif cashType == 'out' then 
		MySQL.Sync.execute("UPDATE minigame SET taixiu_out = taixiu_out + @amount", {['@amount'] = money})
	end
end

ESX.RegisterCommand('neko', 'admin', function(xPlayer, args, showError)
	TriggerEvent("taixiu:doicau", args.name)
end, true, {help = "adasdasd", validate = true, arguments = {
	{name = 'aa', help = 'dd', type = 'number'}
}})