local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local fixateDistance = 4 -- Distance à laquelle la caméra sera positionnée au-dessus du joueur
local fixedPlayer = nil

-- Fonction pour obtenir un joueur valide à fixer
local function getValidPlayer()
    local validPlayers = {}

    -- Parcourir tous les joueurs
    for _, player in ipairs(Players:GetPlayers()) do
        -- Vérifier que le joueur n'est pas le joueur local et qu'il n'est pas dans la même équipe
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character.PrimaryPart then
            table.insert(validPlayers, player) -- Ajouter le joueur valide à la liste
        end
    end

    -- Retourner un joueur aléatoire dans la liste des joueurs valides
    if #validPlayers > 0 then
        return validPlayers[math.random(1, #validPlayers)]
    end
    return nil -- Retourner nil s'il n'y a pas de joueurs valides
end

-- Boucle pour changer le joueur à fixer toutes les secondes
while true do
    fixedPlayer = getValidPlayer() -- Obtenir un joueur valide

    if fixedPlayer then
        if fixedPlayer.Character and fixedPlayer.Character.PrimaryPart then
            Camera.CameraType = Enum.CameraType.Scriptable -- Changer le type de caméra
            Camera.CFrame = CFrame.new(fixedPlayer.Character.PrimaryPart.Position + Vector3.new(0, fixateDistance, 0), fixedPlayer.Character.PrimaryPart.Position) -- Fixer la caméra sur le joueur
        end
    else
        -- Si aucun joueur valide n'est trouvé, réinitialiser la caméra à son mode normal
        Camera.CameraType = Enum.CameraType.Custom
    end

    wait(0.3) -- Pause de 1 seconde avant de choisir un nouveau joueur
end
