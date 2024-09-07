-- This anti cheat bypass was made by Insano_22
print("Blade Ball Anti Cheat Bypass Activated.")

local antiCheatNames = {
    "AntiCheat", "Exploit", "script1", "script2", "anti", 
    "CheatDetector", "Security", "BanSystem", "AutoBan", 
    "Moderation", "AntiExploit", "AntiHack", "KickHandler", 
    "PlayerCheck", "GameSecurity", "ScriptGuard", "BanManager", 
    "AutoKick", "ServerGuard", "ServerSecurity", "ExploitGuard", 
    "ExploitHandler", "CheatHandler", "HackDetector", "ModerationSystem",
    "ExploitDetection", "AntiExploitSystem", "GameProtection", "ScriptWatcher",
    "GuardScript", "ExploitScanner", "AntiExploitHandler", "HackMonitor",
    "KickSystem", "BanHandler", "BanProtection", "SecurityManager",
    "ModeratorTools", "ExploitProtection", "HackGuard", "BanWatcher",
    "AntiScript", "ExploitPrevention", "KickGuard", "CheatProtection",
    "BanExploit", "ExploitPreventionSystem", "HackPrevention",
    "SecurityWatch", "SecurityAlert", "ExploitLogger", "BanLogger",
    "ExploitCheck", "AntiBan", "SecurityScanner", "ExploitDetectionSystem",
    "CheatPrevention", "HackPreventionSystem", "BanGuard", "SecurityTools"
}

local function destroyAntiCheat()
    for _, name in ipairs(antiCheatNames) do
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                if string.find(string.lower(obj.Name), string.lower(name)) then
                    obj:Destroy()
                end
            end
        end
    end
end

local function destroyRemoteEvents()
    for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            if string.find(string.lower(remote.Name), "ban") or string.find(string.lower(remote.Name), "kick") then
                remote:Destroy()
            end
        end
    end
end

local function destroyAntiCheatByScripts()
    local backpack = game:GetService("Players").LocalPlayer.Backpack
    local character = game:GetService("Players").LocalPlayer.Character
    
    for _, script in ipairs(backpack:GetChildren()) do
        if script:IsA("Tool") and script:FindFirstChild("Script") then
            script:Destroy()
        end
    end
    
    for _, script in ipairs(character:GetChildren()) do
        if script:IsA("Tool") and script:FindFirstChild("Script") then
            script:Destroy()
        end
    end
end

local function bypassAntiCheat()
    local players = game:GetService("Players")
    for _, player in ipairs(players:GetChildren()) do
        if player.Name ~= players.LocalPlayer.Name then
            if player.Backpack:FindFirstChildWhichIsA("Tool") then
                player.Backpack:ClearAllChildren()
            end
            if player.Character:FindFirstChildWhichIsA("Tool") then
                player.Character:ClearAllChildren()
            end
        end
    end
end

while true do
    destroyAntiCheat()
    destroyRemoteEvents()
    destroyAntiCheatByScripts()
    bypassAntiCheat()
    wait(5)
end
