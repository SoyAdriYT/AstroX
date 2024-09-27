local AstroX_core = {}

local playerService = game:GetService("Players")

local activeServices = {
    adService = game:GetService("AdService"),
    socialService = game:GetService("SocialService")
}

function AstroX_core.checkEntityStatus(entity)
    local characterModel = entity and entity.Character
    local aliveFolder = workspace:FindFirstChild("Alive")

    if characterModel and aliveFolder then
        local aliveModel = aliveFolder:FindFirstChild(entity.Name)
        local humanoid = aliveModel and aliveModel:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            return humanoid.Health > 0
        end
    end
    return false
end

function AstroX_core.findActiveBall()
    local ballContainer = workspace:WaitForChild("Balls")
    
    for _, ballObject in pairs(ballContainer:GetChildren()) do
        if ballObject:IsA("BasePart") and ballObject:GetAttribute("activeBall") then
            return ballObject
        end
    end
end

return AstroX_core
