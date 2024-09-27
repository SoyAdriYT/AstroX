local a = game:GetService("Players")
local b = game:GetService("RunService")
local c = a.LocalPlayer
local d = workspace.CurrentCamera
local e = {}
local f = {
    {"Head", "UpperTorso"},
    {"UpperTorso", "RightUpperArm"},
    {"RightUpperArm", "RightLowerArm"},
    {"RightLowerArm", "RightHand"},
    {"UpperTorso", "LeftUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"},
    {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "LowerTorso"},
    {"LowerTorso", "LeftUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"},
    {"RightUpperLeg", "RightLowerLeg"},
    {"RightLowerLeg", "RightFoot"}
}
local g = {
    BoxOutlineColor = Color3.new(0, 0, 0),
    BoxColor = Color3.new(1, 1, 1),
    NameColor = Color3.new(1, 1, 1),
    HealthOutlineColor = Color3.new(0, 0, 0),
    HealthHighColor = Color3.new(0, 1, 0),
    HealthLowColor = Color3.new(1, 0, 0),
    CharSize = Vector2.new(4, 6),
    Teamcheck = false,
    WallCheck = false,
    Enabled = false,
    ShowBox = false,
    BoxType = "2D",
    ShowName = false,
    ShowHealth = false,
    ShowDistance = false,
    ShowSkeletons = false,
    ShowTracer = false,
    TracerColor = Color3.new(1, 1, 1),
    TracerThickness = 2,
    SkeletonsColor = Color3.new(1, 1, 1),
    TracerPosition = "Bottom"
}
local function h(i, j)
    local k = Drawing.new(i)
    for l, m in pairs(j) do
        k[l] = m
    end
    return k
end
local function n(o)
    local p = {
        tracer = h("Line", {Thickness = g.TracerThickness, Color = g.TracerColor, Transparency = 0.5}),
        boxOutline = h("Square", {Color = g.BoxOutlineColor, Thickness = 3, Filled = false}),
        box = h("Square", {Color = g.BoxColor, Thickness = 1, Filled = false}),
        name = h("Text", {Color = g.NameColor, Outline = true, Center = true, Size = 13}),
        healthOutline = h("Line", {Thickness = 3, Color = g.HealthOutlineColor}),
        health = h("Line", {Thickness = 1}),
        distance = h("Text", {Color = Color3.new(1, 1, 1), Size = 12, Outline = true, Center = true}),
        tracer = h("Line", {Thickness = g.TracerThickness, Color = g.TracerColor, Transparency = 1}),
        boxLines = {}
    }
    e[o] = p
    e[o]["skeletonlines"] = {}
end
local function q(o)
    local r = o.Character
    if not r then
        return false
    end
    local s = r:FindFirstChild("HumanoidRootPart")
    if not s then
        return false
    end
    local t =
        Ray.new(d.CFrame.Position, (s.Position - d.CFrame.Position).Unit * (s.Position - d.CFrame.Position).Magnitude)
    local u, v = workspace:FindPartOnRayWithIgnoreList(t, {c.Character, r})
    return u and u:IsA("Part")
end
local function w(o)
    local p = e[o]
    if not p then
        return
    end
    for x, k in pairs(p) do
        k:Remove()
    end
    e[o] = nil
end
local function y()
    for o, p in pairs(e) do
        local r, z = o.Character, o.Team
        if r and (not g.Teamcheck or z and z ~= c.Team) then
            local s = r:FindFirstChild("HumanoidRootPart")
            local A = r:FindFirstChild("Head")
            local B = r:FindFirstChild("Humanoid")
            local C = g.WallCheck and q(o)
            local D = not C and g.Enabled
            if s and A and B and D then
                local v, E = d:WorldToViewportPoint(s.Position)
                if E then
                    local F = d:WorldToViewportPoint(s.Position)
                    local G =
                        (d:WorldToViewportPoint(s.Position - Vector3.new(0, 3, 0)).Y -
                        d:WorldToViewportPoint(s.Position + Vector3.new(0, 2.6, 0)).Y) /
                        2
                    local H = Vector2.new(math.floor(G * 1.8), math.floor(G * 1.9))
                    local I = Vector2.new(math.floor(F.X - G * 1.8 / 2), math.floor(F.Y - G * 1.6 / 2))
                    if g.ShowName and g.Enabled then
                        p.name.Visible = true
                        p.name.Text = string.lower(o.Name)
                        p.name.Position = Vector2.new(H.X / 2 + I.X, I.Y - 16)
                        p.name.Color = g.NameColor
                    else
                        p.name.Visible = false
                    end
                    if g.ShowBox and g.Enabled then
                        if g.BoxType == "2D" then
                            p.boxOutline.Size = H
                            p.boxOutline.Position = I
                            p.box.Size = H
                            p.box.Position = I
                            p.box.Color = g.BoxColor
                            p.box.Visible = true
                            p.boxOutline.Visible = true
                            for x, J in ipairs(p.boxLines) do
                                J:Remove()
                            end
                        elseif g.BoxType == "Corner Box Esp" then
                            local K = H.X / 5
                            local L = H.Y / 6
                            local M = 1
                            if #p.boxLines == 0 then
                                for N = 1, 16 do
                                    local O = h("Line", {Thickness = 1, Color = g.BoxColor, Transparency = 1})
                                    p.boxLines[#p.boxLines + 1] = O
                                end
                            end
                            local P = p.boxLines
                            P[1].From = Vector2.new(I.X - M, I.Y - M)
                            P[1].To = Vector2.new(I.X + K, I.Y - M)
                            P[2].From = Vector2.new(I.X - M, I.Y - M)
                            P[2].To = Vector2.new(I.X - M, I.Y + L)
                            P[3].From = Vector2.new(I.X + H.X - K, I.Y - M)
                            P[3].To = Vector2.new(I.X + H.X + M, I.Y - M)
                            P[4].From = Vector2.new(I.X + H.X + M, I.Y - M)
                            P[4].To = Vector2.new(I.X + H.X + M, I.Y + L)
                            P[5].From = Vector2.new(I.X - M, I.Y + H.Y - L)
                            P[5].To = Vector2.new(I.X - M, I.Y + H.Y + M)
                            P[6].From = Vector2.new(I.X - M, I.Y + H.Y + M)
                            P[6].To = Vector2.new(I.X + K, I.Y + H.Y + M)
                            P[7].From = Vector2.new(I.X + H.X - K, I.Y + H.Y + M)
                            P[7].To = Vector2.new(I.X + H.X + M, I.Y + H.Y + M)
                            P[8].From = Vector2.new(I.X + H.X + M, I.Y + H.Y - L)
                            P[8].To = Vector2.new(I.X + H.X + M, I.Y + H.Y + M)
                            for N = 9, 16 do
                                P[N].Thickness = 2
                                P[N].Color = g.BoxOutlineColor
                                P[N].Transparency = 1
                            end
                            P[9].From = Vector2.new(I.X, I.Y)
                            P[9].To = Vector2.new(I.X, I.Y + L)
                            P[10].From = Vector2.new(I.X, I.Y)
                            P[10].To = Vector2.new(I.X + K, I.Y)
                            P[11].From = Vector2.new(I.X + H.X - K, I.Y)
                            P[11].To = Vector2.new(I.X + H.X, I.Y)
                            P[12].From = Vector2.new(I.X + H.X, I.Y)
                            P[12].To = Vector2.new(I.X + H.X, I.Y + L)
                            P[13].From = Vector2.new(I.X, I.Y + H.Y - L)
                            P[13].To = Vector2.new(I.X, I.Y + H.Y)
                            P[14].From = Vector2.new(I.X, I.Y + H.Y)
                            P[14].To = Vector2.new(I.X + K, I.Y + H.Y)
                            P[15].From = Vector2.new(I.X + H.X - K, I.Y + H.Y)
                            P[15].To = Vector2.new(I.X + H.X, I.Y + H.Y)
                            P[16].From = Vector2.new(I.X + H.X, I.Y + H.Y - L)
                            P[16].To = Vector2.new(I.X + H.X, I.Y + H.Y)
                            for x, J in ipairs(P) do
                                J.Visible = true
                            end
                            p.box.Visible = false
                            p.boxOutline.Visible = false
                        end
                    else
                        p.box.Visible = false
                        p.boxOutline.Visible = false
                        for x, J in ipairs(p.boxLines) do
                            J:Remove()
                        end
                        p.boxLines = {}
                    end
                    if g.ShowHealth and g.Enabled then
                        p.healthOutline.Visible = true
                        p.health.Visible = true
                        local Q = o.Character.Humanoid.Health / o.Character.Humanoid.MaxHealth
                        p.healthOutline.From = Vector2.new(I.X - 6, I.Y + H.Y)
                        p.healthOutline.To = Vector2.new(p.healthOutline.From.X, p.healthOutline.From.Y - H.Y)
                        p.health.From = Vector2.new(I.X - 5, I.Y + H.Y)
                        p.health.To =
                            Vector2.new(
                            p.health.From.X,
                            p.health.From.Y - o.Character.Humanoid.Health / o.Character.Humanoid.MaxHealth * H.Y
                        )
                        p.health.Color = g.HealthLowColor:Lerp(g.HealthHighColor, Q)
                    else
                        p.healthOutline.Visible = false
                        p.health.Visible = false
                    end
                    if g.ShowDistance and g.Enabled then
                        local R = (d.CFrame.p - s.Position).Magnitude
                        p.distance.Text = string.format("%.1f studs", R)
                        p.distance.Position = Vector2.new(I.X + H.X / 2, I.Y + H.Y + 5)
                        p.distance.Visible = true
                    else
                        p.distance.Visible = false
                    end
                    if g.ShowSkeletons and g.Enabled then
                        if #p["skeletonlines"] == 0 then
                            for x, S in ipairs(f) do
                                local T, U = S[1], S[2]
                                if o.Character and o.Character[T] and o.Character[U] then
                                    local V = h("Line", {Thickness = 1, Color = g.SkeletonsColor, Transparency = 1})
                                    p["skeletonlines"][#p["skeletonlines"] + 1] = {V, T, U}
                                end
                            end
                        end
                        for x, W in ipairs(p["skeletonlines"]) do
                            local V = W[1]
                            local T, U = W[2], W[3]
                            if o.Character and o.Character[T] and o.Character[U] then
                                local X = d:WorldToViewportPoint(o.Character[T].Position)
                                local Y = d:WorldToViewportPoint(o.Character[U].Position)
                                V.From = Vector2.new(X.X, X.Y)
                                V.To = Vector2.new(Y.X, Y.Y)
                                V.Color = g.SkeletonsColor
                                V.Visible = true
                            else
                                V:Remove()
                            end
                        end
                    else
                        for x, W in ipairs(p["skeletonlines"]) do
                            local V = W[1]
                            V:Remove()
                        end
                        p["skeletonlines"] = {}
                    end
                    if g.ShowTracer and g.Enabled then
                        local Z
                        if g.TracerPosition == "Top" then
                            Z = 0
                        elseif g.TracerPosition == "Middle" then
                            Z = d.ViewportSize.Y / 2
                        else
                            Z = d.ViewportSize.Y
                        end
                        if g.Teamcheck and o.TeamColor == c.TeamColor then
                            p.tracer.Visible = false
                        else
                            p.tracer.Visible = true
                            p.tracer.From = Vector2.new(d.ViewportSize.X / 2, Z)
                            p.tracer.To = Vector2.new(F.X, F.Y)
                        end
                    else
                        p.tracer.Visible = false
                    end
                else
                    for x, k in pairs(p) do
                        k.Visible = false
                    end
                    for x, W in ipairs(p["skeletonlines"]) do
                        local V = W[1]
                        V:Remove()
                    end
                    p["skeletonlines"] = {}
                    for x, J in ipairs(p.boxLines) do
                        J:Remove()
                    end
                    p.boxLines = {}
                end
            else
                for x, k in pairs(p) do
                    k.Visible = false
                end
                for x, W in ipairs(p["skeletonlines"]) do
                    local V = W[1]
                    V:Remove()
                end
                p["skeletonlines"] = {}
                for x, J in ipairs(p.boxLines) do
                    J:Remove()
                end
                p.boxLines = {}
            end
        else
            for x, k in pairs(p) do
                k.Visible = false
            end
            for x, W in ipairs(p["skeletonlines"]) do
                local V = W[1]
                V:Remove()
            end
            p["skeletonlines"] = {}
            for x, J in ipairs(p.boxLines) do
                J:Remove()
            end
            p.boxLines = {}
        end
    end
end
for x, o in ipairs(a:GetPlayers()) do
    if o ~= c then
        n(o)
    end
end
a.PlayerAdded:Connect(
    function(o)
        if o ~= c then
            n(o)
        end
    end
)
a.PlayerRemoving:Connect(
    function(o)
        w(o)
    end
)
b.RenderStepped:Connect(y)
return g
