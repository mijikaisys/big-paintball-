local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local fixateDistance = 4 -- Distance à laquelle la caméra sera positionnée au-dessus du joueur
local fixedPlayer = nil

-- Fonction pour vérifier s'il y a des équipes
local function hasTeams()
    return Players:GetPlayers()[1].Team ~= nil -- Vérifie si le premier joueur a une équipe
end

-- Fonction pour obtenir un joueur valide à fixer
local function getValidPlayer()
    local validPlayers = {}

    -- Parcourir tous les joueurs
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character.PrimaryPart then
            -- Vérifier les conditions de fixation selon la présence d'équipes
            if hasTeams() then
                -- Si des équipes existent, on exclut les joueurs de la même équipe
                if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
                    table.insert(validPlayers, player) -- Ajouter le joueur valide à la liste
                end
            else
                -- Si pas d'équipes, ajouter tous les joueurs sauf le joueur local
                if player ~= LocalPlayer then
                    table.insert(validPlayers, player)
                end
            end
        end
    end

    -- Retourner un joueur aléatoire dans la liste des joueurs valides
    if #validPlayers > 0 then
        return validPlayers[math.random(1, #validPlayers)]
    end
    return nil -- Retourner nil s'il n'y a pas de joueurs valides
end

-- Boucle pour changer le joueur à fixer toutes les 0,3 secondes
while true do
    fixedPlayer = getValidPlayer() -- Obtenir un joueur valide

    if fixedPlayer then
        Camera.CameraType = Enum.CameraType.Scriptable -- Changer le type de caméra
        Camera.CFrame = CFrame.new(fixedPlayer.Character.PrimaryPart.Position + Vector3.new(0, fixateDistance, 0), fixedPlayer.Character.PrimaryPart.Position) -- Fixer la caméra sur le joueur
    else
        -- Si aucun joueur valide n'est trouvé, réinitialiser la caméra à son mode normal
        Camera.CameraType = Enum.CameraType.Custom
    end

    wait(0.08) -- Pause de 0,3 secondes avant de choisir un nouveau joueur
end
