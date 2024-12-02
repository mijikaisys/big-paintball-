local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local searchRadius = 2000 -- Rayon de recherche autour du personnage
local actionDistance = 40 -- Distance à laquelle l'action doit être exécutée
local lastActionTime = 0 -- Variable pour suivre le dernier temps d'action
local actionCooldown = 0.202 -- Délai entre les actions (150 ms)

-- Créer un ScreenGui et des TextLabels pour afficher la position, la distance et la couleur
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

-- TextLabel pour afficher la position
local positionLabel = Instance.new("TextLabel", screenGui)
positionLabel.Size = UDim2.new(0, 300, 0, 50) -- Taille du label
positionLabel.Position = UDim2.new(1, -310, 0, 10) -- Position en haut à droite
positionLabel.BackgroundTransparency = 0.5 -- Transparence du fond
positionLabel.TextColor3 = Color3.new(1, 1, 1) -- Couleur du texte blanc
positionLabel.TextScaled = true -- Mise à l'échelle du texte
positionLabel.Text = "Aucun objet trouvé" -- Texte par défaut

-- TextLabel pour afficher la distance
local distanceLabel = Instance.new("TextLabel", screenGui)
distanceLabel.Size = UDim2.new(0, 300, 0, 50) -- Taille du label
distanceLabel.Position = UDim2.new(1, -310, 0, 70) -- Position juste en dessous du premier label
distanceLabel.BackgroundTransparency = 0.5 -- Transparence du fond
distanceLabel.TextColor3 = Color3.new(1, 1, 1) -- Couleur du texte blanc
distanceLabel.TextScaled = true -- Mise à l'échelle du texte
distanceLabel.Text = "Distance : N/A" -- Texte par défaut

-- TextLabel pour afficher la couleur
local colorLabel = Instance.new("TextLabel", screenGui)
colorLabel.Size = UDim2.new(0, 300, 0, 50) -- Taille du label
colorLabel.Position = UDim2.new(1, -310, 0, 130) -- Position juste en dessous du second label
colorLabel.BackgroundTransparency = 0.5 -- Transparence du fond
colorLabel.TextColor3 = Color3.new(1, 1, 1) -- Couleur du texte blanc
colorLabel.TextScaled = true -- Mise à l'échelle du texte
colorLabel.Text = "Couleur : N/A" -- Texte par défaut

-- Fonction pour vérifier si la couleur est dans la plage de rouge
local function isColorRed(color)
    local redThreshold = 0.5 -- Seuil pour le rouge (0 à 1)
    local greenThreshold = 0.3 -- Seuil pour le vert (0 à 1)
    local blueThreshold = 0.3 -- Seuil pour le bleu (0 à 1)
    
    return (color.R >= redThreshold) and (color.G <= greenThreshold) and (color.B <= greenThreshold)
end

-- Fonction pour vérifier les objets autour du personnage
local function checkForGameBall()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() -- Attendre que le personnage soit chargé
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart") -- Obtenir la partie racine humanoïde

    while true do
        local foundObject = false -- Variable pour savoir si un objet a été trouvé
        local objectPosition = "" -- Variable pour stocker la position de l'objet trouvé
        local objectDistance = "" -- Variable pour stocker la distance à l'objet trouvé
        local objectColor = "" -- Variable pour stocker la couleur de l'objet trouvé

        -- Parcourir tous les objets dans le workspace
        for _, object in ipairs(workspace:GetChildren()) do
            -- Vérifier si l'objet est à l'intérieur du rayon de recherche
            if object:IsA("BasePart") and (object.Position - HumanoidRootPart.Position).magnitude <= searchRadius then
                -- Vérifier si le nom de l'objet est "GameBall"
                if object.Name:lower() == "gameball" then
                    foundObject = true
                    objectPosition = "GameBall trouvé à : " .. tostring(object.Position) .. "\n"
                    
                    -- Calculer la distance entre le joueur et "GameBall"
                    local distance = (object.Position - HumanoidRootPart.Position).magnitude
                    objectDistance = "Distance : " .. tostring(distance) -- Mettre à jour la distance
                    
                    -- Vérifier la couleur avec tolérance
                    if isColorRed(object.Color) then
                        objectColor = "Couleur : Rouge"
                        
                        -- Vérifier si suffisamment de temps s'est écoulé depuis la dernière action
                        if distance <= actionDistance and tick() - lastActionTime >= actionCooldown then
                            local args = {
                                [1] = 2.933813859058389e+76
                            }
                            game:GetService("ReplicatedStorage").TS.GeneratedNetworkRemotes:FindFirstChild("RE_4.6848415795802784e+76"):FireServer(unpack(args))
                            lastActionTime = tick() -- Mettre à jour le temps de la dernière action
                        end
                    else
                        objectColor = "Couleur : Pas Rouge"
                    end
                    
                    break -- Sortir de la boucle une fois que l'objet est trouvé
                end
            end
        end

        if foundObject then
            positionLabel.Text = objectPosition -- Mettre à jour le texte avec la position trouvée
            distanceLabel.Text = objectDistance -- Mettre à jour le texte avec la distance trouvée
            colorLabel.Text = objectColor -- Mettre à jour le texte avec la couleur trouvée
        else
            positionLabel.Text = "Aucun objet trouvé" -- Mettre à jour le texte par défaut
            distanceLabel.Text = "Distance : N/A" -- Remettre la distance par défaut
            colorLabel.Text = "Couleur : N/A" -- Remettre la couleur par défaut
        end

        wait(0.1) -- Attendre 0,1 seconde avant de vérifier à nouveau
    end
end

-- Fonction pour initialiser le parry (ajoutez votre logique ici)
local function initializeParry()
    -- Ajoutez ici la logique pour initialiser le parry, si nécessaire
    print("Parry initialized")
end

-- Exécuter la fonction à la création du personnage
LocalPlayer.CharacterAdded:Connect(function()
    wait() -- Attendre que le personnage soit entièrement chargé
    initializeParry() -- Initialiser le parry
    checkForGameBall() -- Appeler la fonction pour vérifier la GameBall
end)

-- Appeler la fonction initialement si le personnage est déjà présent
if LocalPlayer.Character then
    initializeParry() -- Initialiser le parry
    checkForGameBall() -- Appeler la fonction pour vérifier la GameBall
end
