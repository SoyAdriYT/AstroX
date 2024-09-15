--[[

╭━━━╮╱╱╭╮╱╱╱╱╱╭━╮╭━╮
┃╭━╮┃╱╭╯╰╮╱╱╱╱╰╮╰╯╭╯
┃┃╱┃┣━┻╮╭╋━┳━━╮╰╮╭╯
┃╰━╯┃━━┫┃┃╭┫╭╮┃╭╯╰╮
┃╭━╮┣━━┃╰┫┃┃╰╯┣╯╭╮╰╮
╰╯╱╰┻━━┻━┻╯╰━━┻━╯╰━╯
]]

local success, errorMessage = pcall(function()
    local scriptUrl = "https://raw.githubusercontent.com/SoyAdriYT/AstroX/main/Games/Blade%20Ball.lua"
    local response = game:HttpGet(scriptUrl)
    loadstring(response)()
end)

if not success then
    warn("An error occurred: " .. errorMessage)
end

local RunService = game:GetService("RunService")
local isLowFPS = false
local fpsThreshold = 45

local function getFPS()
    local fpsCounter = 0
    local timeElapsed = 0
    local startTime = tick()

    RunService.RenderStepped:Connect(function(deltaTime)
        fpsCounter = fpsCounter + 1
        timeElapsed = tick() - startTime

        if timeElapsed >= 1 then
            local fps = fpsCounter / timeElapsed
            fpsCounter = 0
            startTime = tick()
            return fps
        end
    end)
end

local function optimizeGraphics()
    local a = game
    local b = a.Workspace
    local c = a.Lighting
    local d = b.Terrain

    d.WaterWaveSize = 0
    d.WaterWaveSpeed = 0
    d.WaterReflectance = 0
    d.WaterTransparency = 0

    c.GlobalShadows = false
    c.FogEnd = 9e9
    c.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"

    for _, f in pairs(a:GetDescendants()) do
        if f:IsA("Part") or f:IsA("Union") or f:IsA("CornerWedgePart") or f:IsA("TrussPart") then
            f.Material = "Plastic"
            f.Reflectance = 0
        elseif f:IsA("Decal") or f:IsA("Texture") then
            f.Transparency = 0
        elseif f:IsA("ParticleEmitter") or f:IsA("Trail") then
            f.Lifetime = NumberRange.new(0)
        elseif f:IsA("Explosion") then
            f.BlastPressure = 0
            f.BlastRadius = 0
        elseif f:IsA("Fire") or f:IsA("SpotLight") or f:IsA("Smoke") or f:IsA("Sparkles") then
            f.Enabled = false
        elseif f:IsA("MeshPart") then
            f.Material = "Plastic"
            f.Reflectance = 0
            f.TextureID = 10385902758728957
        end
    end

    for _, g in pairs(c:GetChildren()) do
        if g:IsA("BlurEffect") or g:IsA("SunRaysEffect") or g:IsA("ColorCorrectionEffect") or g:IsA("BloomEffect") or
           g:IsA("DepthOfFieldEffect") then
            g.Enabled = false
        end
    end

    sethiddenproperty(game.Lighting, "Technology", "Compatibility")
end

local function checkFPSForOneMinute()
    local startTime = tick()
    local fpsCheckTime = 60
    local checkInterval = 2

    while tick() - startTime < fpsCheckTime do
        local fps = getFPS()
        if fps and fps < fpsThreshold then
            isLowFPS = true
            break
        end
        wait(checkInterval)
    end
end

checkFPSForOneMinute()

if isLowFPS then
    while true do
        optimizeGraphics()
        wait(120)
    end
end
