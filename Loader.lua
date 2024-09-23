local function getExecutorName()
    local executor = "LOL"
    if getexecutorname then
        executor = getexecutorname()
    elseif identifyexecutor then
        executor = identifyexecutor()
    end
    return executor
end

local executorName = getExecutorName()

if executorName == "Solara" then
    game.Players.LocalPlayer:Kick("Solara is not supported by AstroX. Please use SCYTHEX.")
else
    local success, errorMessage = pcall(function()
        local scriptUrl = "https://raw.githubusercontent.com/SoyAdriYT/AstroX/main/Games/Blade%20Ball.lua"
        local response = game:HttpGet(scriptUrl)
        loadstring(response)()
    end)

    if not success then
        warn("An error occurred: " .. errorMessage)
    end
end
