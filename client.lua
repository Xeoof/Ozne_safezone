-- Developed by Ozne#4870, modified by Xeoo#0271
-- Reproduction and resell forbidden
-- Join Ozne's Discord : https://discord.gg/nx3TKM5

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0) 
	end
end)

local zones = {
	{ ['x'] = 430.13, ['y'] = -981.83, ['z'] = 30.71},  -- Comissariat Mission Row
	{ ['x'] = 299.23, ['y'] = -584.64, ['z'] = 43.26 }, -- Hôital Pillbox
	{ ['x'] = 226.24, ['y'] = -783.5, ['z'] = 30.73 } -- Parking central + place "cube"
}

local danslazone = false
local sortir = false
local zone = 1

Citizen.CreateThread(function() 
	ESX.TriggerServerCallback('getUsergroup', function(group)
		playergroup = group
		if playergroup == 'user' then
			while not NetworkIsPlayerActive(PlayerId()) do 
				Citizen.Wait(0) 
			end	
			while true do 
				Citizen.Wait(0) 
				local player = GetPlayerPed(-1) 
				local x,y,z = table.unpack(GetEntityCoords(player, true)) 
				local dist = Vdist(zones[zone].x, zones[zone].y, zones[zone].z, x, y, z)
			
				if dist <= 50.0 then  ---- Pour changer la grandeur de la zone c est ici ! / To change radius of the area its here  !
					if not danslazone then	 
						ESX.ShowNotification("Vous êtes dans une ~g~safe zone~s~ !")
						NetworkSetFriendlyFireOption(false) 
						ClearPlayerWantedLevel(PlayerId()) 
						SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true) 
						danslazone = true 
						sortir = false 
					end 
				else 
					if not sortir then 
						ESX.ShowNotification("Vous n\'êtes plus dans une ~r~safe zone~s~ !")	 
						NetworkSetFriendlyFireOption(true) 
						sortir = true 
						danslazone = false 
					end 
				end 
				if danslazone then 
					DisableControlAction(2, 37, true) 
					DisablePlayerFiring(player,true)  
					DisableControlAction(0, 106, true)  
					if IsDisabledControlJustPressed(2, 37) then  
						SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)  
						ESX.ShowNotification("Vous ne pouvez pas utiliser ~r~d\'armes~s~ dans une ~g~safe zone~s~ !")	 
					end 
					if IsDisabledControlJustPressed(0, 106) then  
						SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)  
						ESX.ShowNotification("Vous ne pouvez pas ~r~vous battre~s~ dans une ~g~safe zone~s~ !")	 
					end 
				end 
			end 
		end
	end)
end)

Citizen.CreateThread(function() 
	while not NetworkIsPlayerActive(PlayerId()) do 
		Citizen.Wait(0) 
	end	
	while true do 
		local playerPed = GetPlayerPed(-1) 
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true)) 
		local minzone = 100000 
		for i = 1, #zones, 1 do 
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z) 
			if dist < minzone then 
				minzone = dist zone = i 
			end 
		end 
		Citizen.Wait(15000) 
	end 
end)


-- Developed by Ozne#4870, modified by Xeoo#0271
-- Reproduction and resell forbidden
-- Join Ozne's Discord : https://discord.gg/nx3TKM5
