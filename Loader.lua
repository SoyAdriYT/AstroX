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
