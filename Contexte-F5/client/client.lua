ESX = nil
PlayerData = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    RefreshMoney()
    RefreshMoney2()

    weaponData = ESX.GetWeaponList()

    for i = 1, #weaponData, 1 do
        if weaponData[i].name == 'WEAPON_UNARMED' then
            weaponData[i] = nil
        else
            weaponData[i].hash = GetHashKey(weaponData[i].name)
        end
    end

    if ESX.IsPlayerLoaded() then

        ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
    RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
    RefreshMoney2()
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
      ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    for i=1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == account.name then
            ESX.PlayerData.accounts[i] = account
            break
        end
    end
end)


local main = ContextUI:CreateMenu(1, "Menu-F5") 

local inventaire = ContextUI:CreateSubMenu(main, "Inventaire")
local UtilisezItems = ContextUI:CreateSubMenu(inventaire, "Utilisation Items")

local portefeuille = ContextUI:CreateSubMenu(main, "Portefeuille")
local UtilisationArgent = ContextUI:CreateSubMenu(portefeuille, "Utilisation Argent")
local UtilisationArgentSale = ContextUI:CreateSubMenu(portefeuille, "Utilisation Argent Sale")
local carteidentite = ContextUI:CreateSubMenu(portefeuille, "Utilisation Carte D'identité")
local permisconduire = ContextUI:CreateSubMenu(portefeuille, "Utilisation Permis de Conduire")
local PPA = ContextUI:CreateSubMenu(portefeuille, "Utilisation PPA")

local gestionarme = ContextUI:CreateSubMenu(main, "Gestion Arme")
local OptionArme = ContextUI:CreateSubMenu(gestionarme, "Utilisation Arme")

local vetement = ContextUI:CreateSubMenu(main, "Vêtement")
local menuvetement = ContextUI:CreateSubMenu(vetement, "Vêtement")
local menuaccessoire = ContextUI:CreateSubMenu(vetement, "Accessoires")


local gestionentreprise = ContextUI:CreateSubMenu(main, "Gestion Entreprise")
local gestiongang = ContextUI:CreateSubMenu(main, "Gestion Gang")

local divers = ContextUI:CreateSubMenu(main, "Divers")
local administation = ContextUI:CreateSubMenu(main, "Administation")

ContextUI:IsVisible(main, function(Entity)

        ContextUI:Button("~b~→ ~s~Inventaire", nil, function(Selected)   
        end, inventaire)

        ContextUI:Button("~b~→ ~s~Portefeuille", nil, function(Selected)   
        end, portefeuille)

        ContextUI:Button("~b~→ ~s~Gestion d'armes", nil, function(Selected)   
        end, gestionarme)

        ContextUI:Button("~b~→ ~s~Vêtement", nil, function(Selected)   
        end, vetement)

        ContextUI:Button("~b~→ ~s~Gestion Entreprise", nil, function(Selected)   
        end, gestionentreprise)

        ContextUI:Button("~b~→ ~s~Gestion Gang", nil, function(Selected)   
        end, gestiongang)

        ContextUI:Button("~b~→ ~s~Divers", nil, function(Selected)   
        end, divers)
end)

ContextUI:IsVisible(inventaire, function(Entity)

ESX.PlayerData = ESX.GetPlayerData()
    for i = 1, #ESX.PlayerData.inventory do
        if ESX.PlayerData.inventory[i].count > 0 then
            ContextUI:Button('[~r~' ..ESX.PlayerData.inventory[i].count.. '~s~] ~b~- ~s~' ..ESX.PlayerData.inventory[i].label, nil, function(Selected)
                if (Selected) then 
                    ItemSelected = ESX.PlayerData.inventory[i]
                end 
            end,UtilisezItems)
        end
    end
end)

ContextUI:IsVisible(UtilisezItems, function(Entity)

    ContextUI:Button("Utiliser", nil, function(Selected)
        if Selected then
            if ItemSelected.usable then
                TriggerServerEvent('esx:useItem', ItemSelected.name)  
            else
                ESX.ShowNotification('l\'items n\'est pas utilisable', ItemSelected.label)
            end
        end
    end)

    ContextUI:Button("Jetez", nil, function(Selected)
        if Selected then
            if ItemSelected.canRemove then
                local quantite = KeyboardInput("Nombres d'items que vous voulez jeter", '', 25)
                if tonumber(quantite) then
                    if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                        TriggerServerEvent('esx:removeInventoryItem', 'item_standard', ItemSelected.name, tonumber(quantite))
                    else
                        ESX.ShowNotification("Vous ne pouvez pas faire ceci dans un véhicule !")
                    end
                else
                    ESX.ShowNotification("Nombres d'items invalid !")
                end
            end
        end
    end)

    ContextUI:Button("Donner", nil, function(Selected)
        if Selected then
            local quantity = KeyboardInput("Nombres d'items que vous voulez donner", "", 25)
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            --local pPed = GetPlayerPed(-1)
            --local coords = GetEntityCoords(pPed)
            --local x,y,z = table.unpack(coords)
                --DrawMarker(2, x, y, z+1.5, 0, 0, 0, 180.0,nil,nil, 0.5, 0.5, 0.5, 0, 0, 255, 120, true, true, p19, true)
            local player = GetPlayerPed(-1)
            local vCoords = GetEntityCoords(player)
            DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 102, 0, 170, 0, 1, 2, 0, nil, nil, 0)
            if tonumber(quantity) then
                if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)
                    if IsPedOnFoot(closestPed) then
                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_standard', Rperso.ItemSelected.name, tonumber(quantity))
                    else
                        ESX.ShowNotification("Nombres d'items invalid !")
                    end
                else
                    ESX.ShowNotification("Aucun joueur ~r~Proche~n~ !")
                end
            end
        end
    end)
end)


ContextUI:IsVisible(portefeuille, function(Entity)

    local MoneyPlayer = ESX.Math.GroupDigits(ESX.PlayerData.money)
    ContextUI:Button("~b~→~s~ Nom : ~b~"..GetPlayerName(PlayerId()), nil, function(Selected)
    end)

    ContextUI:Button("~b~→~s~ Job : ~b~"..ESX.PlayerData.job.label, "~b~→~s~ Grade : ~b~"..ESX.PlayerData.job.grade_label, function(Selected)
    end)

    ContextUI:Button("", nil, function(Selected)
    end)

    ContextUI:Button("~b~→~s~ Liquide : [~g~"..MoneyPlayer.."€~s~]", nil, function(Selected)
    end,UtilisationArgent)

    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money' then
            ContextUI:Button("~b~→~s~ Sale : [~g~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."€~s~]"), nil, function(Selected)
            end,UtilisationArgentSale)
        end

        if ESX.PlayerData.accounts[i].name == 'bank' then
            ContextUI:Button("~b~→~s~ Banque : [~g~"..ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money.."€~s~]"), nil, function(Selected)
            end)
        end
    end

    ContextUI:Button("", nil, function(Selected)
    end)

    ContextUI:Button("~b~→ ~s~ Carte D'identité", nil, function(Selected)
    end,carteidentite)

    ContextUI:Button("~b~→ ~s~ Permis de Conduire", nil, function(Selected)
    end,permisconduire)

    ContextUI:Button("~b~→ ~s~ Permis PPA", nil, function(Selected)
    end,PPA)

end)

ContextUI:IsVisible(UtilisationArgent, function(Entity)

    ContextUI:Button("Donner", nil, function(Selected)
        if Selected then
            local quantity = KeyboardInput("Somme d'argent que vous voulez donner", '', 25)
            if tonumber(quantity) then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)
                    if not IsPedSittingInAnyVehicle(closestPed) then
                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_money', 'rien', tonumber(quantity))
                    else
                        ESX.ShowNotification('Vous ne pouvez pas donner de l\'argent dans un véhicles')
                    end
                else
                    ESX.ShowNotification('Aucun joueur proche !')
                end
            else
                ESX.ShowNotification('Somme invalid')
            end
        end
    end)

    ContextUI:Button("Jetez", nil, function(Selected)
        if Selected then
            local quantity = KeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
            if tonumber(quantity) then
                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    TriggerServerEvent('esx:removeInventoryItem', 'item_money', 'rien', tonumber(quantity))
                else
                    ESX.ShowNotification("~r~Cette action est impossible dans un véhicule !")
                end
            else
                ESX.ShowNotification("~r~Les champs sont incorrects !")
            end
        end
    end)

end)

ContextUI:IsVisible(UtilisationArgentSale, function(Entity)

    ContextUI:Button("Donner", nil, function(Selected)
        if Selected then
            local quantity = KeyboardInput("Somme d'argent que vous voulez Donner", "", 25)
            if tonumber(quantity) then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestDistance ~= -1 and closestDistance <= 3 then
                    local closestPed = GetPlayerPed(closestPlayer)
                    if not IsPedSittingInAnyVehicle(closestPed) then
                        TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                    else
                        ESX.ShowNotification(_U('Vous ne pouvez pas donner ', 'de l\'argent dans un véhicles'))
                    end
                else
                    ESX.ShowNotification('Aucun joueur proche !')
                end
            else
                ESX.ShowNotification('Somme invalid')
            end
        end
    end)
    for i = 1, #ESX.PlayerData.accounts, 1 do
        if ESX.PlayerData.accounts[i].name == 'black_money' then
            ContextUI:Button("Jetez", nil, function(Selected)
                if Selected then
                    local quantity = KeyboardInput("Somme d'argent que vous voulez jeter", "", 25)
                    if tonumber(quantity) then
                        if not IsPedSittingInAnyVehicle(PlayerPed) then
                            TriggerServerEvent('esx:removeInventoryItem', 'item_account', ESX.PlayerData.accounts[i].name, tonumber(quantity))
                        else
                            ESX.ShowNotification('Vous pouvez pas jeter', 'de l\'argent')
                        end
                    else
                        ESX.ShowNotification('Somme Invalid')
                    end
                end
            end)
        end
    end
end)

ContextUI:IsVisible(carteidentite, function(Entity)

    ContextUI:Button("Voir", nil, function(Selected)
        if Selected then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
        end
    end)

    ContextUI:Button("Montrer", nil, function(Selected)
        if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Aucun joueur ~r~proche !')
            end
        end
    end)

end)

ContextUI:IsVisible(permisconduire, function(Entity)

    ContextUI:Button("Voir", nil, function(Selected)
        if Selected then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        end
    end)

    ContextUI:Button("Montrer", nil, function(Selected)
        if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
            else
                ESX.ShowNotification('Aucun joueur ~r~proche !')
            end
        end
    end)
end)

ContextUI:IsVisible(PPA, function(Entity)

    ContextUI:Button("Voir", nil, function(Selected)
        if Selected then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
        end
    end)

    ContextUI:Button("Montrer", nil, function(Selected)
        if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
            else
                ESX.ShowNotification('Aucun joueur ~r~proche !')
            end
        end
    end)
end)




ContextUI:IsVisible(gestionarme, function(Entity)

    ESX.PlayerData = ESX.GetPlayerData()
    for i = 1, #weaponData, 1 do
        if HasPedGotWeapon(PlayerPedId(), weaponData[i].hash, false) then
            local ammo = GetAmmoInPedWeapon(PlayerPedId(), weaponData[i].hash)
            ContextUI:Button(weaponData[i].label .. ' [' .. ammo .. ']', nil, function(Selected)
                if (Selected) then
                    WeaponSelect = weaponData[i]
                end
            end,OptionArme)
        end
    end
end)

ContextUI:IsVisible(OptionArme, function(Entity)

    ContextUI:Button("Donner", nil, function(Selected)
        if Selected then
            local closestPlayer, distance = ESX.Game.GetClosestPlayer()
            local playerPed = PlayerPedId()
            if closestPlayer ~= -1 and distance <= 3.0 then
                TriggerServerEvent('esx:giveInventoryItem', GetPlayerServerId(closestPlayer), 'item_weapon', WeaponSelect.name, WeaponSelect.count)
            else   
                ESX.ShowNotification("Aucun joueur à proximité")     
            end
        end
    end)

    ContextUI:Button("Jetez", nil, function(Selected)
        if Selected then
            TriggerServerEvent('esx:removeInventoryItem', 'item_weapon', WeaponSelect.name)
        end
    end)
end)

ContextUI:IsVisible(vetement, function(Entity)

    ContextUI:Button("Vetement", nil, function(Selected)
    end, menuvetement)

    ContextUI:Button("Accessoires", nil, function(Selected)
    end, menuaccessoire)

end)


ContextUI:IsVisible(menuvetement, function(Entity)

    ContextUI:Button("~b~Torse~s~", nil, function(Selected)
        if Selected then
            setUniform('torso', plyPed)
        end
    end)

    ContextUI:Button("~b~T-Shirt~s~", nil, function(Selected)
        if Selected then
            setUniform('tshirt', plyPed)
        end
    end)

    ContextUI:Button("~b~Jean~s~", nil, function(Selected)
        if Selected then
            setUniform('pants', plyPed)
        end
    end)

    ContextUI:Button("~b~Chaussures~s~", nil, function(Selected)
        if Selected then
            setUniform('shoes', plyPed)
        end
    end)

    ContextUI:Button("~b~Chapeau~s~", nil, function(Selected)
        if Selected then
            setUniform('helmet', plyPed)
        end
    end)

end)


ContextUI:IsVisible(menuaccessoire, function(Entity)

    ContextUI:Button("~b~Gilets par balle~s~", nil, function(Selected)
        if Selected then
            setUniform('bproof', plyPed)
        end
    end)

    ContextUI:Button("~b~Masque~s~", nil, function(Selected)
        if Selected then
            setUniform('mask', plyPed)
        end
    end)

    ContextUI:Button("~b~Lunettes~s~", nil, function(Selected)
        if Selected then
            setUniform('glasses', plyPed)
        end
    end)

    ContextUI:Button("~b~Bracelet~s~", nil, function(Selected)
        if Selected then
            setUniform('bracelets', plyPed)
        end
    end)

    ContextUI:Button("~b~Sac à dos~s~", nil, function(Selected)
        if Selected then
            setUniform('bag', plyPed)
        end
    end)
end)

ContextUI:IsVisible(gestionentreprise, function(Entity)

    if ESX.PlayerData.job.grade_name == 'boss' then

        ContextUI:Button("       ↓ ~b~Gestion Entreprise~s~↓", nil, function(Selected)
        end)

        ContextUI:Button("", nil, function(Selected)
        end)

        ContextUI:Button("       ~o~"..ESX.PlayerData.job.grade_label.." - ~g~"..ESX.PlayerData.job.label, nil, function(Selected)
        end)

        if societymoney ~= nil then
            ContextUI:Button("       ~b~Coffre Entreprise : ~g~"..societymoney.." $", nil, function(Selected)
            end)
        end

        ContextUI:Button("", nil, function(Selected)
        end)

        ContextUI:Button("~b~→ ~s~Recruter un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    TriggerServerEvent('menu-f5:server:recrut', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Virer un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    TriggerServerEvent('menu-f5:server:virer', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Promouvoir un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    TriggerServerEvent('menu-f5:server:promote', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Rétrograder un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    TriggerServerEvent('menu-f5:server:destituer', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Message aux employés", nil, function(Selected)
            if Selected then
                local info = 'patron'
                local message = KeyboardInput('Veuillez mettre le messsage à envoyer', '', 40)
                TriggerServerEvent('menu-f5:envoyeremployer', info, message)
            end
        end)

    else
        ContextUI:Button("", nil, function(Selected)
        end)
        ContextUI:Button("", nil, function(Selected)
        end)
        ContextUI:Button("   PERMISSIONS INSUFFISANTE !", nil, function(Selected)
        end)
        ContextUI:Button("", nil, function(Selected)
        end)
        ContextUI:Button("", nil, function(Selected)
        end)
    end
end)


ContextUI:IsVisible(gestiongang, function(Entity)

    if ESX.PlayerData.job2.grade_name == 'boss' then

        ContextUI:Button("  ~b~→ ~s~Nom du Gang : ~b~"..ESX.PlayerData.job2.label, nil, function(Selected)
        end)

        ContextUI:Button("       ~b~→ ~s~Grade : ~b~"..ESX.PlayerData.job2.grade_label, nil, function(Selected)
        end)

        if societymoney2 ~= nil then
            ContextUI:Button("       ~b~Coffre Entreprise :  ~g~"..societymoney2.." $", nil, function(Selected)
            end)
        end

        ContextUI:Button("", nil, function(Selected)
        end)

        ContextUI:Button("~b~→ ~s~Recruter un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    ESX.ShowNotification('Vous avez recruté ~b~' .. GetPlayerName(closestPlayer))
                    TriggerServerEvent('menu-f5:server:recrut2', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Virer un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    ESX.ShowNotification('Vous avez virer ~b~' .. GetPlayerName(closestPlayer))
                    TriggerServerEvent('menu-f5:server:virer2', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Promouvoir un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    ESX.ShowNotification('Vous avez Promu ~b~' .. GetPlayerName(closestPlayer))
                    TriggerServerEvent('menu-f5:server:promote2', GetPlayerServerId(closestPlayer))
                end
            end
        end)

        ContextUI:Button("~b~→ ~s~Rétrograder un ~b~Joueur", nil, function(Selected)
            if Selected then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                if closestPlayer == -1 or closestDistance > 3.0 then
                    ESX.ShowNotification('Aucun joueur proche')
                else
                    ESX.ShowNotification('Vous avez Rétrograder ~b~' .. GetPlayerName(closestPlayer))
                    TriggerServerEvent('menu-f5:server:derank2', GetPlayerServerId(closestPlayer))
                end
            end
        end)
    else
        ContextUI:Button("", nil, function(Selected)
        end)
        ContextUI:Button("", nil, function(Selected)
        end)
        ContextUI:Button("   PERMISSIONS INSUFFISANTE !", nil, function(Selected)
        end)
        ContextUI:Button("", nil, function(Selected)
        end)
        ContextUI:Button("", nil, function(Selected)
        end)
    end
end)

ContextUI:IsVisible(divers, function(Entity)

    ContextUI:Button("~b~→ ~s~Faire un tweet", nil, function(Selected)
        if Selected then
            local tweet = KeyboardInput("Tapez votre tweet", "", 100)
            local playername = GetPlayerName(PlayerId())
            for k, v in pairs(Config.TweetMotBan) do                              
                if tweet == v.name then                                       
                    return(ESX.ShowNotification("~r~Vous ne pouvez pas faire de tweet avec ce mot"))
                end               
            end
            if tweet ~= nil then
                TriggerServerEvent('menu-f5:sendtweet', playername, tweet)
            end
        end
    end)

    ContextUI:Button("~b~→ ~s~Afficher HUD", nil, function(Selected)
        if Selected then
            DisplayRadar(true)
        end
    end)

    ContextUI:Button("~b~→ ~s~Cacher HUD", nil, function(Selected)
        if Selected then
            DisplayRadar(false)
        end
    end)

    ContextUI:Button("~b~→ ~s~Tomber", "Ragdoll", function(Selected)
        if Selected then
            ragdolling = not ragdolling
            while ragdolling do
                Wait(0)
                local myPed = GetPlayerPed(-1)
                SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
                ResetPedRagdollTimer(myPed)
                AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~b~Réveillé'))
                DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
                ResetPedRagdollTimer(myPed)
                if IsControlJustPressed(0, 22) then 
                    ragdolling = false
                end
            end
        end
    end)

    ContextUI:Button("~b~→~s~ Voir ton ID", nil, function(Selected)
        if Selected then
            ESX.ShowNotification("Ton ID : "..GetPlayerServerId(PlayerId()))
        end
    end)

    ContextUI:Button("~b~→~s~ Voir Id joueur proche", nil, function(Selected)
        if Selected then
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
                ESX.ShowNotification("Joueur Proche : "..GetPlayerName(closestPlayer).." "..GetPlayerServerId(closestPlayer))
            else
                ESX.ShowNotification('Aucun joueur ~r~proche !')
            end
        end
    end)
end)


Keys.Register("LMENU", "LMENU", "Menu Contexte F5", function()
        ContextUI.Focus = not ContextUI.Focus;
end)
