local scriptUrl = "https://raw.githubusercontent.com/SoyAdriYT/AstroX/main/Games/Blade%20Ball.lua"

local success, errorMessage = pcall(function()
    local response = game:HttpGet(scriptUrl)
    loadstring(response)()
end)

if not success then
    warn("An error occurred: " .. tostring(errorMessage))
end
