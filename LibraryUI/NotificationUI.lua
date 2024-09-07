local a = game:GetService("UserInputService")
local b = game:GetService("TweenService")
local c = game:GetService("RunService")
local d = game:GetService("Players").LocalPlayer
local e = d:GetMouse()
local f = game:GetService("HttpService")
local g = {
    Elements = {},
    ThemeObjects = {},
    Connections = {},
    Flags = {},
    Themes = {
        Default = {
            Main = Color3.fromRGB(25, 25, 25),
            Second = Color3.fromRGB(32, 32, 32),
            Stroke = Color3.fromRGB(60, 60, 60),
            Divider = Color3.fromRGB(60, 60, 60),
            Text = Color3.fromRGB(240, 240, 240),
            TextDark = Color3.fromRGB(150, 150, 150)
        }
    },
    SelectedTheme = "Default",
    Folder = nil,
    SaveCfg = false
}
local h = {}
local i, j =
    pcall(
    function()
        h =
            f:JSONDecode(
            game:HttpGetAsync(
                "https://raw.githubusercontent.com/evoincorp/lucideblox/master/src/modules/util/icons.json"
            )
        ).icons
    end
)
if not i then
    warn("\nOrion Library - Failed to load Feather Icons. Error code: " .. j .. "\n")
end
local function k(l)
    if h[l] ~= nil then
        return h[l]
    else
        return nil
    end
end
local m = Instance.new("ScreenGui")
m.Name = "Orion"
if syn then
    syn.protect_gui(m)
    m.Parent = game.CoreGui
else
    m.Parent = gethui() or game.CoreGui
end
if gethui then
    for n, o in ipairs(gethui():GetChildren()) do
        if o.Name == m.Name and o ~= m then
            o:Destroy()
        end
    end
else
    for n, o in ipairs(game.CoreGui:GetChildren()) do
        if o.Name == m.Name and o ~= m then
            o:Destroy()
        end
    end
end
function g:IsRunning()
    if gethui then
        return m.Parent == gethui()
    else
        return m.Parent == game:GetService("CoreGui")
    end
end
local function p(q, r)
    if not g:IsRunning() then
        return
    end
    local s = q:Connect(r)
    table.insert(g.Connections, s)
    return s
end
task.spawn(
    function()
        while g:IsRunning() do
            wait()
        end
        for n, t in next, g.Connections do
            t:Disconnect()
        end
    end
)
local function u(v, w)
    pcall(
        function()
            local x, y, z, A = false
            p(
                v.InputBegan,
                function(B)
                    if B.UserInputType == Enum.UserInputType.MouseButton1 or B.UserInputType == Enum.UserInputType.Touch then
                        x = true
                        z = B.Position
                        A = w.Position
                        B.Changed:Connect(
                            function()
                                if B.UserInputState == Enum.UserInputState.End then
                                    x = false
                                end
                            end
                        )
                    end
                end
            )
            p(
                v.InputChanged,
                function(B)
                    if
                        B.UserInputType == Enum.UserInputType.MouseMovement or
                            B.UserInputType == Enum.UserInputType.Touch
                     then
                        y = B
                    end
                end
            )
            p(
                a.InputChanged,
                function(B)
                    if B == y and x then
                        local C = B.Position - z
                        w.Position = UDim2.new(A.X.Scale, A.X.Offset + C.X, A.Y.Scale, A.Y.Offset + C.Y)
                    end
                end
            )
        end
    )
end
local function D(E, F, G)
    local H = Instance.new(E)
    for I, J in next, F or {} do
        H[I] = J
    end
    for I, J in next, G or {} do
        J.Parent = H
    end
    return H
end
local function K(L, M)
    g.Elements[L] = function(...)
        return M(...)
    end
end
local function N(L, ...)
    local O = g.Elements[L](...)
    return O
end
local function P(Q, R)
    table.foreach(
        R,
        function(S, Value)
            Q[S] = Value
        end
    )
    return Q
end
local function T(Q, G)
    table.foreach(
        G,
        function(n, U)
            U.Parent = Q
        end
    )
    return Q
end
local function V(W, X)
    local Y = math.floor(W / X + math.sign(W) * 0.5) * X
    if Y < 0 then
        Y = Y + X
    end
    return Y
end
local function Z(H)
    if H:IsA("Frame") or H:IsA("TextButton") then
        return "BackgroundColor3"
    end
    if H:IsA("ScrollingFrame") then
        return "ScrollBarImageColor3"
    end
    if H:IsA("UIStroke") then
        return "Color"
    end
    if H:IsA("TextLabel") or H:IsA("TextBox") then
        return "TextColor3"
    end
    if H:IsA("ImageLabel") or H:IsA("ImageButton") then
        return "ImageColor3"
    end
end
local function _(H, a0)
    if not g.ThemeObjects[a0] then
        g.ThemeObjects[a0] = {}
    end
    table.insert(g.ThemeObjects[a0], H)
    H[Z(H)] = g.Themes[g.SelectedTheme][a0]
    return H
end
local function a1()
    for E, a0 in pairs(g.ThemeObjects) do
        for n, H in pairs(a0) do
            H[Z(H)] = g.Themes[g.SelectedTheme][E]
        end
    end
end
local function a2(a3)
    return {R = a3.R * 255, G = a3.G * 255, B = a3.B * 255}
end
local function a4(a3)
    return Color3.fromRGB(a3.R, a3.G, a3.B)
end
local function a5(a6)
    local a7 = f:JSONDecode(a6)
    table.foreach(
        a7,
        function(a8, a9)
            if g.Flags[a8] then
                spawn(
                    function()
                        if g.Flags[a8].Type == "Colorpicker" then
                            g.Flags[a8]:Set(a4(a9))
                        else
                            g.Flags[a8]:Set(a9)
                        end
                    end
                )
            else
                warn("Orion Library Config Loader - Could not find ", a8, a9)
            end
        end
    )
end
local function aa(E)
    local a7 = {}
    for I, J in pairs(g.Flags) do
        if J.Save then
            if J.Type == "Colorpicker" then
                a7[I] = a2(J.Value)
            else
                a7[I] = J.Value
            end
        end
    end
    writefile(g.Folder .. "/" .. E .. ".txt", tostring(f:JSONEncode(a7)))
end
local ab = {
    Enum.UserInputType.MouseButton1,
    Enum.UserInputType.MouseButton2,
    Enum.UserInputType.MouseButton3,
    Enum.UserInputType.Touch
}
local ac = {
    Enum.KeyCode.Unknown,
    Enum.KeyCode.W,
    Enum.KeyCode.A,
    Enum.KeyCode.S,
    Enum.KeyCode.D,
    Enum.KeyCode.Up,
    Enum.KeyCode.Left,
    Enum.KeyCode.Down,
    Enum.KeyCode.Right,
    Enum.KeyCode.Slash,
    Enum.KeyCode.Tab,
    Enum.KeyCode.Backspace,
    Enum.KeyCode.Escape
}
local function ad(ae, af)
    for n, J in next, ae do
        if J == af then
            return true
        end
    end
end
K(
    "Corner",
    function(ag, ah)
        local ai = D("UICorner", {CornerRadius = UDim.new(ag or 0, ah or 10)})
        return ai
    end
)
K(
    "Stroke",
    function(a3, aj)
        local ak = D("UIStroke", {Color = a3 or Color3.fromRGB(255, 255, 255), Thickness = aj or 1})
        return ak
    end
)
K(
    "List",
    function(ag, ah)
        local al = D("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(ag or 0, ah or 0)})
        return al
    end
)
K(
    "Padding",
    function(am, an, ao, ap)
        local aq =
            D(
            "UIPadding",
            {
                PaddingBottom = UDim.new(0, am or 4),
                PaddingLeft = UDim.new(0, an or 4),
                PaddingRight = UDim.new(0, ao or 4),
                PaddingTop = UDim.new(0, ap or 4)
            }
        )
        return aq
    end
)
K(
    "TFrame",
    function()
        local ar = D("Frame", {BackgroundTransparency = 1})
        return ar
    end
)
K(
    "Frame",
    function(a3)
        local as = D("Frame", {BackgroundColor3 = a3 or Color3.fromRGB(255, 255, 255), BorderSizePixel = 0})
        return as
    end
)
K(
    "RoundFrame",
    function(a3, ag, ah)
        local as =
            D(
            "Frame",
            {BackgroundColor3 = a3 or Color3.fromRGB(255, 255, 255), BorderSizePixel = 0},
            {D("UICorner", {CornerRadius = UDim.new(ag, ah)})}
        )
        return as
    end
)
K(
    "Button",
    function()
        local at =
            D("TextButton", {Text = "", AutoButtonColor = false, BackgroundTransparency = 1, BorderSizePixel = 0})
        return at
    end
)
K(
    "ScrollFrame",
    function(a3, au)
        local av =
            D(
            "ScrollingFrame",
            {
                BackgroundTransparency = 1,
                MidImage = "rbxassetid://7445543667",
                BottomImage = "rbxassetid://7445543667",
                TopImage = "rbxassetid://7445543667",
                ScrollBarImageColor3 = a3,
                BorderSizePixel = 0,
                ScrollBarThickness = au,
                CanvasSize = UDim2.new(0, 0, 0, 0)
            }
        )
        return av
    end
)
K(
    "Image",
    function(aw)
        local ax = D("ImageLabel", {Image = aw, BackgroundTransparency = 1})
        if k(aw) ~= nil then
            ax.Image = k(aw)
        end
        return ax
    end
)
K(
    "ImageButton",
    function(aw)
        local ay = D("ImageButton", {Image = aw, BackgroundTransparency = 1})
        return ay
    end
)
K(
    "Label",
    function(az, aA, aB)
        local aC =
            D(
            "TextLabel",
            {
                Text = az or "",
                TextColor3 = Color3.fromRGB(240, 240, 240),
                TextTransparency = aB or 0,
                TextSize = aA or 15,
                Font = Enum.Font.Gotham,
                RichText = true,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            }
        )
        return aC
    end
)
local aD =
    P(
    T(
        N("TFrame"),
        {
            P(
                N("List"),
                {
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Bottom,
                    Padding = UDim.new(0, 5)
                }
            )
        }
    ),
    {
        Position = UDim2.new(1, -25, 1, -25),
        Size = UDim2.new(0, 300, 1, -25),
        AnchorPoint = Vector2.new(1, 1),
        Parent = m
    }
)
function g:MakeNotification(aE)
    spawn(
        function()
            aE.Name = aE.Name or "Notification"
            aE.Content = aE.Content or "Test"
            aE.Image = aE.Image or "rbxassetid://4384403532"
            aE.Time = aE.Time or 15
            local aF = P(N("TFrame"), {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = aD})
            local aG =
                T(
                P(
                    N("RoundFrame", Color3.fromRGB(25, 25, 25), 0, 10),
                    {
                        Parent = aF,
                        Size = UDim2.new(1, 0, 0, 0),
                        Position = UDim2.new(1, -55, 0, 0),
                        BackgroundTransparency = 0,
                        AutomaticSize = Enum.AutomaticSize.Y
                    }
                ),
                {
                    N("Stroke", Color3.fromRGB(93, 93, 93), 1.2),
                    N("Padding", 12, 12, 12, 12),
                    P(
                        N("Image", aE.Image),
                        {Size = UDim2.new(0, 20, 0, 20), ImageColor3 = Color3.fromRGB(240, 240, 240), Name = "Icon"}
                    ),
                    P(
                        N("Label", aE.Name, 15),
                        {
                            Size = UDim2.new(1, -30, 0, 20),
                            Position = UDim2.new(0, 30, 0, 0),
                            Font = Enum.Font.GothamBold,
                            Name = "Title"
                        }
                    ),
                    P(
                        N("Label", aE.Content, 14),
                        {
                            Size = UDim2.new(1, 0, 0, 0),
                            Position = UDim2.new(0, 0, 0, 25),
                            Font = Enum.Font.GothamSemibold,
                            Name = "Content",
                            AutomaticSize = Enum.AutomaticSize.Y,
                            TextColor3 = Color3.fromRGB(200, 200, 200),
                            TextWrapped = true
                        }
                    )
                }
            )
            b:Create(aG, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Position = UDim2.new(0, 0, 0, 0)}):Play()
            wait(aE.Time - 0.88)
            b:Create(aG.Icon, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {ImageTransparency = 1}):Play()
            b:Create(aG, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {BackgroundTransparency = 0.6}):Play()
            wait(0.3)
            b:Create(aG.UIStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Transparency = 0.9}):Play()
            b:Create(aG.Title, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.4}):Play()
            b:Create(aG.Content, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {TextTransparency = 0.5}):Play()
            wait(0.05)
            aG:TweenPosition(UDim2.new(1, 20, 0, 0), "In", "Quint", 0.8, true)
            wait(1.35)
            aG:Destroy()
        end
    )
end
function g:Init()
    if g.SaveCfg then
        pcall(
            function()
                if isfile(g.Folder .. "/" .. game.GameId .. ".txt") then
                    a5(readfile(g.Folder .. "/" .. game.GameId .. ".txt"))
                    g:MakeNotification(
                        {
                            Name = "Configuration",
                            Content = "Auto-loaded configuration for the game " .. game.GameId .. ".",
                            Time = 5
                        }
                    )
                end
            end
        )
    end
end
function g:MakeWindow(aH)
    local aI = true
    local aJ = false
    local aK = false
    local aL = false
    aH = aH or {}
    aH.Name = aH.Name or "Orion Library"
    aH.ConfigFolder = aH.ConfigFolder or aH.Name
    aH.SaveConfig = aH.SaveConfig or false
    aH.HidePremium = aH.HidePremium or false
    if aH.IntroEnabled == nil then
        aH.IntroEnabled = true
    end
    aH.IntroText = aH.IntroText or "Orion Library"
    aH.CloseCallback = aH.CloseCallback or function()
        end
    aH.ShowIcon = aH.ShowIcon or false
    aH.Icon = aH.Icon or "rbxassetid://8834748103"
    aH.IntroIcon = aH.IntroIcon or "rbxassetid://8834748103"
    g.Folder = aH.ConfigFolder
    g.SaveCfg = aH.SaveConfig
    if aH.SaveConfig then
        if not isfolder(aH.ConfigFolder) then
            makefolder(aH.ConfigFolder)
        end
    end
    local aM =
        _(
        T(
            P(N("ScrollFrame", Color3.fromRGB(255, 255, 255), 4), {Size = UDim2.new(1, 0, 1, -50)}),
            {N("List"), N("Padding", 8, 0, 0, 8)}
        ),
        "Divider"
    )
    p(
        aM.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"),
        function()
            aM.CanvasSize = UDim2.new(0, 0, 0, aM.UIListLayout.AbsoluteContentSize.Y + 16)
        end
    )
    local aN =
        T(
        P(N("Button"), {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0.5, 0, 0, 0), BackgroundTransparency = 1}),
        {
            _(
                P(
                    N("Image", "rbxassetid://7072725342"),
                    {Position = UDim2.new(0, 9, 0, 6), Size = UDim2.new(0, 18, 0, 18)}
                ),
                "Text"
            )
        }
    )
    local aO =
        T(
        P(N("Button"), {Size = UDim2.new(0.5, 0, 1, 0), BackgroundTransparency = 1}),
        {
            _(
                P(
                    N("Image", "rbxassetid://7072719338"),
                    {Position = UDim2.new(0, 9, 0, 6), Size = UDim2.new(0, 18, 0, 18), Name = "Ico"}
                ),
                "Text"
            )
        }
    )
    local v = P(N("TFrame"), {Size = UDim2.new(1, 0, 0, 50)})
    local aP =
        _(
        T(
            P(
                N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10),
                {Size = UDim2.new(0, 150, 1, -50), Position = UDim2.new(0, 0, 0, 50)}
            ),
            {
                _(P(N("Frame"), {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 0, 0)}), "Second"),
                _(P(N("Frame"), {Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0)}), "Second"),
                _(P(N("Frame"), {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0)}), "Stroke"),
                aM,
                T(
                    P(N("TFrame"), {Size = UDim2.new(1, 0, 0, 50), Position = UDim2.new(0, 0, 1, -50)}),
                    {
                        _(P(N("Frame"), {Size = UDim2.new(1, 0, 0, 1)}), "Stroke"),
                        _(
                            T(
                                P(
                                    N("Frame"),
                                    {
                                        AnchorPoint = Vector2.new(0, 0.5),
                                        Size = UDim2.new(0, 32, 0, 32),
                                        Position = UDim2.new(0, 10, 0.5, 0)
                                    }
                                ),
                                {
                                    P(
                                        N(
                                            "Image",
                                            "https://www.roblox.com/headshot-thumbnail/image?userId=" ..
                                                d.UserId .. "&width=420&height=420&format=png"
                                        ),
                                        {Size = UDim2.new(1, 0, 1, 0)}
                                    ),
                                    _(
                                        P(N("Image", "rbxassetid://4031889928"), {Size = UDim2.new(1, 0, 1, 0)}),
                                        "Second"
                                    ),
                                    N("Corner", 1)
                                }
                            ),
                            "Divider"
                        ),
                        T(
                            P(
                                N("TFrame"),
                                {
                                    AnchorPoint = Vector2.new(0, 0.5),
                                    Size = UDim2.new(0, 32, 0, 32),
                                    Position = UDim2.new(0, 10, 0.5, 0)
                                }
                            ),
                            {_(N("Stroke"), "Stroke"), N("Corner", 1)}
                        ),
                        _(
                            P(
                                N("Label", d.DisplayName, aH.HidePremium and 14 or 13),
                                {
                                    Size = UDim2.new(1, -60, 0, 13),
                                    Position = aH.HidePremium and UDim2.new(0, 50, 0, 19) or UDim2.new(0, 50, 0, 12),
                                    Font = Enum.Font.GothamBold,
                                    ClipsDescendants = true
                                }
                            ),
                            "Text"
                        ),
                        _(
                            P(
                                N("Label", "", 12),
                                {
                                    Size = UDim2.new(1, -60, 0, 12),
                                    Position = UDim2.new(0, 50, 1, -25),
                                    Visible = not aH.HidePremium
                                }
                            ),
                            "TextDark"
                        )
                    }
                )
            }
        ),
        "Second"
    )
    local aQ =
        _(
        P(
            N("Label", aH.Name, 14),
            {
                Size = UDim2.new(1, -30, 2, 0),
                Position = UDim2.new(0, 25, 0, -24),
                Font = Enum.Font.GothamBlack,
                TextSize = 20
            }
        ),
        "Text"
    )
    local aR = _(P(N("Frame"), {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1)}), "Stroke")
    local aS =
        _(
        T(
            P(
                N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 10),
                {
                    Parent = m,
                    Position = UDim2.new(0.5, -307, 0.5, -172),
                    Size = UDim2.new(0, 615, 0, 344),
                    ClipsDescendants = true
                }
            ),
            {
                T(
                    P(N("TFrame"), {Size = UDim2.new(1, 0, 0, 50), Name = "TopBar"}),
                    {
                        aQ,
                        aR,
                        _(
                            T(
                                P(
                                    N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 7),
                                    {Size = UDim2.new(0, 70, 0, 30), Position = UDim2.new(1, -90, 0, 10)}
                                ),
                                {
                                    _(N("Stroke"), "Stroke"),
                                    _(
                                        P(
                                            N("Frame"),
                                            {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(0.5, 0, 0, 0)}
                                        ),
                                        "Stroke"
                                    ),
                                    aN,
                                    aO
                                }
                            ),
                            "Second"
                        )
                    }
                ),
                v,
                aP
            }
        ),
        "Main"
    )
    if aH.ShowIcon then
        aQ.Position = UDim2.new(0, 50, 0, -24)
        local aT = P(N("Image", aH.Icon), {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 25, 0, 15)})
        aT.Parent = aS.TopBar
    end
    u(v, aS)
    p(
        aN.MouseButton1Up,
        function()
            aS.Visible = false
            aL = true
            g:MakeNotification(
                {Name = "Interface Hidden", Content = "Tap RightShift to reopen the interface", Time = 5}
            )
            aH.CloseCallback()
        end
    )
    p(
        a.InputBegan,
        function(B)
            if B.KeyCode == Enum.KeyCode.RightShift and aL then
                aS.Visible = true
            end
        end
    )
    p(
        aO.MouseButton1Up,
        function()
            if aJ then
                b:Create(
                    aS,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, 615, 0, 344)}
                ):Play()
                aO.Ico.Image = "rbxassetid://7072719338"
                wait(.02)
                aS.ClipsDescendants = false
                aP.Visible = true
                aR.Visible = true
            else
                aS.ClipsDescendants = true
                aR.Visible = false
                aO.Ico.Image = "rbxassetid://7072720870"
                b:Create(
                    aS,
                    TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {Size = UDim2.new(0, aQ.TextBounds.X + 140, 0, 50)}
                ):Play()
                wait(0.1)
                aP.Visible = false
            end
            aJ = not aJ
        end
    )
    local function aU()
        aS.Visible = false
        local aV =
            P(
            N("Image", aH.IntroIcon),
            {
                Parent = m,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, 0.4, 0),
                Size = UDim2.new(0, 28, 0, 28),
                ImageColor3 = Color3.fromRGB(255, 255, 255),
                ImageTransparency = 1
            }
        )
        local aW =
            P(
            N("Label", aH.IntroText, 14),
            {
                Parent = m,
                Size = UDim2.new(1, 0, 1, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 19, 0.5, 0),
                TextXAlignment = Enum.TextXAlignment.Center,
                Font = Enum.Font.GothamBold,
                TextTransparency = 1
            }
        )
        b:Create(
            aV,
            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {ImageTransparency = 0, Position = UDim2.new(0.5, 0, 0.5, 0)}
        ):Play()
        wait(0.8)
        b:Create(
            aV,
            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -(aW.TextBounds.X / 2), 0.5, 0)}
        ):Play()
        wait(0.3)
        b:Create(aW, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        wait(2)
        b:Create(aW, TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
        aS.Visible = true
        aV:Destroy()
        aW:Destroy()
    end
    if aH.IntroEnabled then
        aU()
    end
    local aX = {}
    function aX:MakeTab(aY)
        aY = aY or {}
        aY.Name = aY.Name or "Tab"
        aY.Icon = aY.Icon or ""
        aY.PremiumOnly = aY.PremiumOnly or false
        local aZ =
            T(
            P(N("Button"), {Size = UDim2.new(1, 0, 0, 30), Parent = aM}),
            {
                _(
                    P(
                        N("Image", aY.Icon),
                        {
                            AnchorPoint = Vector2.new(0, 0.5),
                            Size = UDim2.new(0, 18, 0, 18),
                            Position = UDim2.new(0, 10, 0.5, 0),
                            ImageTransparency = 0.4,
                            Name = "Ico"
                        }
                    ),
                    "Text"
                ),
                _(
                    P(
                        N("Label", aY.Name, 14),
                        {
                            Size = UDim2.new(1, -35, 1, 0),
                            Position = UDim2.new(0, 35, 0, 0),
                            Font = Enum.Font.GothamSemibold,
                            TextTransparency = 0.4,
                            Name = "Title"
                        }
                    ),
                    "Text"
                )
            }
        )
        if k(aY.Icon) ~= nil then
            aZ.Ico.Image = k(aY.Icon)
        end
        local a_ =
            _(
            T(
                P(
                    N("ScrollFrame", Color3.fromRGB(255, 255, 255), 5),
                    {
                        Size = UDim2.new(1, -150, 1, -50),
                        Position = UDim2.new(0, 150, 0, 50),
                        Parent = aS,
                        Visible = false,
                        Name = "ItemContainer"
                    }
                ),
                {N("List", 0, 6), N("Padding", 15, 10, 10, 15)}
            ),
            "Divider"
        )
        p(
            a_.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"),
            function()
                a_.CanvasSize = UDim2.new(0, 0, 0, a_.UIListLayout.AbsoluteContentSize.Y + 30)
            end
        )
        if aI then
            aI = false
            aZ.Ico.ImageTransparency = 0
            aZ.Title.TextTransparency = 0
            aZ.Title.Font = Enum.Font.GothamBlack
            a_.Visible = true
        end
        p(
            aZ.MouseButton1Click,
            function()
                for n, b0 in next, aM:GetChildren() do
                    if b0:IsA("TextButton") then
                        b0.Title.Font = Enum.Font.GothamSemibold
                        b:Create(
                            b0.Ico,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {ImageTransparency = 0.4}
                        ):Play()
                        b:Create(
                            b0.Title,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {TextTransparency = 0.4}
                        ):Play()
                    end
                end
                for n, b1 in next, aS:GetChildren() do
                    if b1.Name == "ItemContainer" then
                        b1.Visible = false
                    end
                end
                b:Create(
                    aZ.Ico,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {ImageTransparency = 0}
                ):Play()
                b:Create(
                    aZ.Title,
                    TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                    {TextTransparency = 0}
                ):Play()
                aZ.Title.Font = Enum.Font.GothamBlack
                a_.Visible = true
            end
        )
        local function b2(ItemParent)
            local M = {}
            function M:AddLabel(az)
                local b3 =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 0.7, Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", az, 15),
                                    {
                                        Size = UDim2.new(1, -12, 1, 0),
                                        Position = UDim2.new(0, 12, 0, 0),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Content"
                                    }
                                ),
                                "Text"
                            ),
                            _(N("Stroke"), "Stroke")
                        }
                    ),
                    "Second"
                )
                local b4 = {}
                function b4:Set(b5)
                    b3.Content.Text = b5
                end
                return b4
            end
            function M:AddParagraph(az, b6)
                az = az or "Text"
                b6 = b6 or "Content"
                local b7 =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 0.7, Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", az, 15),
                                    {
                                        Size = UDim2.new(1, -12, 0, 14),
                                        Position = UDim2.new(0, 12, 0, 10),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Title"
                                    }
                                ),
                                "Text"
                            ),
                            _(
                                P(
                                    N("Label", "", 13),
                                    {
                                        Size = UDim2.new(1, -24, 0, 0),
                                        Position = UDim2.new(0, 12, 0, 26),
                                        Font = Enum.Font.GothamSemibold,
                                        Name = "Content",
                                        TextWrapped = true
                                    }
                                ),
                                "TextDark"
                            ),
                            _(N("Stroke"), "Stroke")
                        }
                    ),
                    "Second"
                )
                p(
                    b7.Content:GetPropertyChangedSignal("Text"),
                    function()
                        b7.Content.Size = UDim2.new(1, -24, 0, b7.Content.TextBounds.Y)
                        b7.Size = UDim2.new(1, 0, 0, b7.Content.TextBounds.Y + 35)
                    end
                )
                b7.Content.Text = b6
                local b8 = {}
                function b8:Set(b5)
                    b7.Content.Text = b5
                end
                return b8
            end
            function M:AddButton(b9)
                b9 = b9 or {}
                b9.Name = b9.Name or "Button"
                b9.Callback = b9.Callback or function()
                    end
                b9.Icon = b9.Icon or "rbxassetid://3944703587"
                local at = {}
                local ba = P(N("Button"), {Size = UDim2.new(1, 0, 1, 0)})
                local bb =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 33), Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", b9.Name, 15),
                                    {
                                        Size = UDim2.new(1, -12, 1, 0),
                                        Position = UDim2.new(0, 12, 0, 0),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Content"
                                    }
                                ),
                                "Text"
                            ),
                            _(
                                P(
                                    N("Image", b9.Icon),
                                    {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0, 7)}
                                ),
                                "TextDark"
                            ),
                            _(N("Stroke"), "Stroke"),
                            ba
                        }
                    ),
                    "Second"
                )
                p(
                    ba.MouseEnter,
                    function()
                        b:Create(
                            bb,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                    end
                )
                p(
                    ba.MouseLeave,
                    function()
                        b:Create(
                            bb,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {BackgroundColor3 = g.Themes[g.SelectedTheme].Second}
                        ):Play()
                    end
                )
                p(
                    ba.MouseButton1Up,
                    function()
                        b:Create(
                            bb,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                        spawn(
                            function()
                                b9.Callback()
                            end
                        )
                    end
                )
                p(
                    ba.MouseButton1Down,
                    function()
                        b:Create(
                            bb,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 6
                                )
                            }
                        ):Play()
                    end
                )
                function at:Set(bc)
                    bb.Content.Text = bc
                end
                return at
            end
            function M:AddToggle(bd)
                bd = bd or {}
                bd.Name = bd.Name or "Toggle"
                bd.Default = bd.Default or false
                bd.Callback = bd.Callback or function()
                    end
                bd.Color = bd.Color or Color3.fromRGB(9, 99, 195)
                bd.Flag = bd.Flag or nil
                bd.Save = bd.Save or false
                local be = {Value = bd.Default, Save = bd.Save}
                local ba = P(N("Button"), {Size = UDim2.new(1, 0, 1, 0)})
                local bf =
                    T(
                    P(
                        N("RoundFrame", bd.Color, 0, 4),
                        {
                            Size = UDim2.new(0, 24, 0, 24),
                            Position = UDim2.new(1, -24, 0.5, 0),
                            AnchorPoint = Vector2.new(0.5, 0.5)
                        }
                    ),
                    {
                        P(N("Stroke"), {Color = bd.Color, Name = "Stroke", Transparency = 0.5}),
                        P(
                            N("Image", "rbxassetid://3944680095"),
                            {
                                Size = UDim2.new(0, 20, 0, 20),
                                AnchorPoint = Vector2.new(0.5, 0.5),
                                Position = UDim2.new(0.5, 0, 0.5, 0),
                                ImageColor3 = Color3.fromRGB(255, 255, 255),
                                Name = "Ico"
                            }
                        )
                    }
                )
                local bg =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 38), Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", bd.Name, 15),
                                    {
                                        Size = UDim2.new(1, -12, 1, 0),
                                        Position = UDim2.new(0, 12, 0, 0),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Content"
                                    }
                                ),
                                "Text"
                            ),
                            _(N("Stroke"), "Stroke"),
                            bf,
                            ba
                        }
                    ),
                    "Second"
                )
                function be:Set(Value)
                    be.Value = Value
                    b:Create(
                        bf,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        {BackgroundColor3 = be.Value and bd.Color or g.Themes.Default.Divider}
                    ):Play()
                    b:Create(
                        bf.Stroke,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        {Color = be.Value and bd.Color or g.Themes.Default.Stroke}
                    ):Play()
                    b:Create(
                        bf.Ico,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                        {
                            ImageTransparency = be.Value and 0 or 1,
                            Size = be.Value and UDim2.new(0, 20, 0, 20) or UDim2.new(0, 8, 0, 8)
                        }
                    ):Play()
                    bd.Callback(be.Value)
                end
                be:Set(be.Value)
                p(
                    ba.MouseEnter,
                    function()
                        b:Create(
                            bg,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                    end
                )
                p(
                    ba.MouseLeave,
                    function()
                        b:Create(
                            bg,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {BackgroundColor3 = g.Themes[g.SelectedTheme].Second}
                        ):Play()
                    end
                )
                p(
                    ba.MouseButton1Up,
                    function()
                        b:Create(
                            bg,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                        aa(game.GameId)
                        be:Set(not be.Value)
                    end
                )
                p(
                    ba.MouseButton1Down,
                    function()
                        b:Create(
                            bg,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 6
                                )
                            }
                        ):Play()
                    end
                )
                if bd.Flag then
                    g.Flags[bd.Flag] = be
                end
                return be
            end
            function M:AddSlider(bh)
                bh = bh or {}
                bh.Name = bh.Name or "Slider"
                bh.Min = bh.Min or 0
                bh.Max = bh.Max or 100
                bh.Increment = bh.Increment or 1
                bh.Default = bh.Default or 50
                bh.Callback = bh.Callback or function()
                    end
                bh.ValueName = bh.ValueName or ""
                bh.Color = bh.Color or Color3.fromRGB(9, 149, 98)
                bh.Flag = bh.Flag or nil
                bh.Save = bh.Save or false
                local bi = {Value = bh.Default, Save = bh.Save}
                local x = false
                local bj =
                    T(
                    P(
                        N("RoundFrame", bh.Color, 0, 5),
                        {Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 0.3, ClipsDescendants = true}
                    ),
                    {
                        _(
                            P(
                                N("Label", "value", 13),
                                {
                                    Size = UDim2.new(1, -12, 0, 14),
                                    Position = UDim2.new(0, 12, 0, 6),
                                    Font = Enum.Font.GothamBold,
                                    Name = "Value",
                                    TextTransparency = 0
                                }
                            ),
                            "Text"
                        )
                    }
                )
                local bk =
                    T(
                    P(
                        N("RoundFrame", bh.Color, 0, 5),
                        {
                            Size = UDim2.new(1, -24, 0, 26),
                            Position = UDim2.new(0, 12, 0, 30),
                            BackgroundTransparency = 0.9
                        }
                    ),
                    {
                        P(N("Stroke"), {Color = bh.Color}),
                        _(
                            P(
                                N("Label", "value", 13),
                                {
                                    Size = UDim2.new(1, -12, 0, 14),
                                    Position = UDim2.new(0, 12, 0, 6),
                                    Font = Enum.Font.GothamBold,
                                    Name = "Value",
                                    TextTransparency = 0.8
                                }
                            ),
                            "Text"
                        ),
                        bj
                    }
                )
                local bl =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4),
                            {Size = UDim2.new(1, 0, 0, 65), Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", bh.Name, 15),
                                    {
                                        Size = UDim2.new(1, -12, 0, 14),
                                        Position = UDim2.new(0, 12, 0, 10),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Content"
                                    }
                                ),
                                "Text"
                            ),
                            _(N("Stroke"), "Stroke"),
                            bk
                        }
                    ),
                    "Second"
                )
                bk.InputBegan:Connect(
                    function(B)
                        if B.UserInputType == Enum.UserInputType.MouseButton1 then
                            x = true
                        end
                    end
                )
                bk.InputEnded:Connect(
                    function(B)
                        if B.UserInputType == Enum.UserInputType.MouseButton1 then
                            x = false
                        end
                    end
                )
                a.InputChanged:Connect(
                    function(B)
                        if x and B.UserInputType == Enum.UserInputType.MouseMovement then
                            local bm = math.clamp((B.Position.X - bk.AbsolutePosition.X) / bk.AbsoluteSize.X, 0, 1)
                            bi:Set(bh.Min + (bh.Max - bh.Min) * bm)
                            aa(game.GameId)
                        end
                    end
                )
                function bi:Set(Value)
                    self.Value = math.clamp(V(Value, bh.Increment), bh.Min, bh.Max)
                    b:Create(
                        bj,
                        TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = UDim2.fromScale((self.Value - bh.Min) / (bh.Max - bh.Min), 1)}
                    ):Play()
                    bk.Value.Text = tostring(self.Value) .. " " .. bh.ValueName
                    bj.Value.Text = tostring(self.Value) .. " " .. bh.ValueName
                    bh.Callback(self.Value)
                end
                bi:Set(bi.Value)
                if bh.Flag then
                    g.Flags[bh.Flag] = bi
                end
                return bi
            end
            function M:AddDropdown(bn)
                bn = bn or {}
                bn.Name = bn.Name or "Dropdown"
                bn.Options = bn.Options or {}
                bn.Default = bn.Default or ""
                bn.Callback = bn.Callback or function()
                    end
                bn.Flag = bn.Flag or nil
                bn.Save = bn.Save or false
                local bo = {
                    Value = bn.Default,
                    Options = bn.Options,
                    Buttons = {},
                    Toggled = false,
                    Type = "Dropdown",
                    Save = bn.Save
                }
                local bp = 5
                if not table.find(bo.Options, bo.Value) then
                    bo.Value = "..."
                end
                local bq = N("List")
                local br =
                    _(
                    P(
                        T(N("ScrollFrame", Color3.fromRGB(40, 40, 40), 4), {bq}),
                        {
                            Parent = ItemParent,
                            Position = UDim2.new(0, 0, 0, 38),
                            Size = UDim2.new(1, 0, 1, -38),
                            ClipsDescendants = true
                        }
                    ),
                    "Divider"
                )
                local ba = P(N("Button"), {Size = UDim2.new(1, 0, 1, 0)})
                local bs =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 38), Parent = ItemParent, ClipsDescendants = true}
                        ),
                        {
                            br,
                            P(
                                T(
                                    N("TFrame"),
                                    {
                                        _(
                                            P(
                                                N("Label", bn.Name, 15),
                                                {
                                                    Size = UDim2.new(1, -12, 1, 0),
                                                    Position = UDim2.new(0, 12, 0, 0),
                                                    Font = Enum.Font.GothamBold,
                                                    Name = "Content"
                                                }
                                            ),
                                            "Text"
                                        ),
                                        _(
                                            P(
                                                N("Image", "rbxassetid://7072706796"),
                                                {
                                                    Size = UDim2.new(0, 20, 0, 20),
                                                    AnchorPoint = Vector2.new(0, 0.5),
                                                    Position = UDim2.new(1, -30, 0.5, 0),
                                                    ImageColor3 = Color3.fromRGB(240, 240, 240),
                                                    Name = "Ico"
                                                }
                                            ),
                                            "TextDark"
                                        ),
                                        _(
                                            P(
                                                N("Label", "Selected", 13),
                                                {
                                                    Size = UDim2.new(1, -40, 1, 0),
                                                    Font = Enum.Font.Gotham,
                                                    Name = "Selected",
                                                    TextXAlignment = Enum.TextXAlignment.Right
                                                }
                                            ),
                                            "TextDark"
                                        ),
                                        _(
                                            P(
                                                N("Frame"),
                                                {
                                                    Size = UDim2.new(1, 0, 0, 1),
                                                    Position = UDim2.new(0, 0, 1, -1),
                                                    Name = "Line",
                                                    Visible = false
                                                }
                                            ),
                                            "Stroke"
                                        ),
                                        ba
                                    }
                                ),
                                {Size = UDim2.new(1, 0, 0, 38), ClipsDescendants = true, Name = "F"}
                            ),
                            _(N("Stroke"), "Stroke"),
                            N("Corner")
                        }
                    ),
                    "Second"
                )
                p(
                    bq:GetPropertyChangedSignal("AbsoluteContentSize"),
                    function()
                        br.CanvasSize = UDim2.new(0, 0, 0, bq.AbsoluteContentSize.Y)
                    end
                )
                local function bt(bu)
                    for n, bv in pairs(bu) do
                        local bw =
                            _(
                            P(
                                T(
                                    N("Button", Color3.fromRGB(40, 40, 40)),
                                    {
                                        N("Corner", 0, 6),
                                        _(
                                            P(
                                                N("Label", bv, 13, 0.4),
                                                {
                                                    Position = UDim2.new(0, 8, 0, 0),
                                                    Size = UDim2.new(1, -8, 1, 0),
                                                    Name = "Title"
                                                }
                                            ),
                                            "Text"
                                        )
                                    }
                                ),
                                {
                                    Parent = br,
                                    Size = UDim2.new(1, 0, 0, 28),
                                    BackgroundTransparency = 1,
                                    ClipsDescendants = true
                                }
                            ),
                            "Divider"
                        )
                        p(
                            bw.MouseButton1Click,
                            function()
                                bo:Set(bv)
                                aa(game.GameId)
                            end
                        )
                        bo.Buttons[bv] = bw
                    end
                end
                function bo:Refresh(bu, bx)
                    if bx then
                        for n, J in pairs(bo.Buttons) do
                            J:Destroy()
                        end
                        table.clear(bo.Options)
                        table.clear(bo.Buttons)
                    end
                    bo.Options = bu
                    bt(bo.Options)
                end
                function bo:Set(Value)
                    if not table.find(bo.Options, Value) then
                        bo.Value = "..."
                        bs.F.Selected.Text = bo.Value
                        for n, J in pairs(bo.Buttons) do
                            b:Create(
                                J,
                                TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {BackgroundTransparency = 1}
                            ):Play()
                            b:Create(
                                J.Title,
                                TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {TextTransparency = 0.4}
                            ):Play()
                        end
                        return
                    end
                    bo.Value = Value
                    bs.F.Selected.Text = bo.Value
                    for n, J in pairs(bo.Buttons) do
                        b:Create(
                            J,
                            TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundTransparency = 1}
                        ):Play()
                        b:Create(
                            J.Title,
                            TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0.4}
                        ):Play()
                    end
                    b:Create(
                        bo.Buttons[Value],
                        TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 0}
                    ):Play()
                    b:Create(
                        bo.Buttons[Value].Title,
                        TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextTransparency = 0}
                    ):Play()
                    return bn.Callback(bo.Value)
                end
                p(
                    ba.MouseButton1Click,
                    function()
                        bo.Toggled = not bo.Toggled
                        bs.F.Line.Visible = bo.Toggled
                        b:Create(
                            bs.F.Ico,
                            TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = bo.Toggled and 180 or 0}
                        ):Play()
                        if #bo.Options > bp then
                            b:Create(
                                bs,
                                TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {Size = bo.Toggled and UDim2.new(1, 0, 0, 38 + bp * 28) or UDim2.new(1, 0, 0, 38)}
                            ):Play()
                        else
                            b:Create(
                                bs,
                                TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {
                                    Size = bo.Toggled and UDim2.new(1, 0, 0, bq.AbsoluteContentSize.Y + 38) or
                                        UDim2.new(1, 0, 0, 38)
                                }
                            ):Play()
                        end
                    end
                )
                bo:Refresh(bo.Options, false)
                bo:Set(bo.Value)
                if bn.Flag then
                    g.Flags[bn.Flag] = bo
                end
                return bo
            end
            function M:AddBind(by)
                by.Name = by.Name or "Bind"
                by.Default = by.Default or Enum.KeyCode.Unknown
                by.Hold = by.Hold or false
                by.Callback = by.Callback or function()
                    end
                by.Flag = by.Flag or nil
                by.Save = by.Save or false
                local bz = {Value, Binding = false, Type = "Bind", Save = by.Save}
                local bA = false
                local ba = P(N("Button"), {Size = UDim2.new(1, 0, 1, 0)})
                local bB =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4),
                            {
                                Size = UDim2.new(0, 24, 0, 24),
                                Position = UDim2.new(1, -12, 0.5, 0),
                                AnchorPoint = Vector2.new(1, 0.5)
                            }
                        ),
                        {
                            _(N("Stroke"), "Stroke"),
                            _(
                                P(
                                    N("Label", by.Name, 14),
                                    {
                                        Size = UDim2.new(1, 0, 1, 0),
                                        Font = Enum.Font.GothamBold,
                                        TextXAlignment = Enum.TextXAlignment.Center,
                                        Name = "Value"
                                    }
                                ),
                                "Text"
                            )
                        }
                    ),
                    "Main"
                )
                local bC =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 38), Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", by.Name, 15),
                                    {
                                        Size = UDim2.new(1, -12, 1, 0),
                                        Position = UDim2.new(0, 12, 0, 0),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Content"
                                    }
                                ),
                                "Text"
                            ),
                            _(N("Stroke"), "Stroke"),
                            bB,
                            ba
                        }
                    ),
                    "Second"
                )
                p(
                    bB.Value:GetPropertyChangedSignal("Text"),
                    function()
                        b:Create(
                            bB,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, bB.Value.TextBounds.X + 16, 0, 24)}
                        ):Play()
                    end
                )
                p(
                    ba.InputEnded,
                    function(B)
                        if B.UserInputType == Enum.UserInputType.MouseButton1 then
                            if bz.Binding then
                                return
                            end
                            bz.Binding = true
                            bB.Value.Text = ""
                        end
                    end
                )
                p(
                    a.InputBegan,
                    function(B)
                        if a:GetFocusedTextBox() then
                            return
                        end
                        if (B.KeyCode.Name == bz.Value or B.UserInputType.Name == bz.Value) and not bz.Binding then
                            if by.Hold then
                                bA = true
                                by.Callback(bA)
                            else
                                by.Callback()
                            end
                        elseif bz.Binding then
                            local af
                            pcall(
                                function()
                                    if not ad(ac, B.KeyCode) then
                                        af = B.KeyCode
                                    end
                                end
                            )
                            pcall(
                                function()
                                    if ad(ab, B.UserInputType) and not af then
                                        af = B.UserInputType
                                    end
                                end
                            )
                            af = af or bz.Value
                            bz:Set(af)
                            aa(game.GameId)
                        end
                    end
                )
                p(
                    a.InputEnded,
                    function(B)
                        if B.KeyCode.Name == bz.Value or B.UserInputType.Name == bz.Value then
                            if by.Hold and bA then
                                bA = false
                                by.Callback(bA)
                            end
                        end
                    end
                )
                p(
                    ba.MouseEnter,
                    function()
                        b:Create(
                            bC,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                    end
                )
                p(
                    ba.MouseLeave,
                    function()
                        b:Create(
                            bC,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {BackgroundColor3 = g.Themes[g.SelectedTheme].Second}
                        ):Play()
                    end
                )
                p(
                    ba.MouseButton1Up,
                    function()
                        b:Create(
                            bC,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                    end
                )
                p(
                    ba.MouseButton1Down,
                    function()
                        b:Create(
                            bC,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 6
                                )
                            }
                        ):Play()
                    end
                )
                function bz:Set(af)
                    bz.Binding = false
                    bz.Value = af or bz.Value
                    bz.Value = bz.Value.Name or bz.Value
                    bB.Value.Text = bz.Value
                end
                bz:Set(by.Default)
                if by.Flag then
                    g.Flags[by.Flag] = bz
                end
                return bz
            end
            function M:AddTextbox(bD)
                bD = bD or {}
                bD.Name = bD.Name or "Textbox"
                bD.Default = bD.Default or ""
                bD.TextDisappear = bD.TextDisappear or false
                bD.Callback = bD.Callback or function()
                    end
                local ba = P(N("Button"), {Size = UDim2.new(1, 0, 1, 0)})
                local bE =
                    _(
                    D(
                        "TextBox",
                        {
                            Size = UDim2.new(1, 0, 1, 0),
                            BackgroundTransparency = 1,
                            TextColor3 = Color3.fromRGB(255, 255, 255),
                            PlaceholderColor3 = Color3.fromRGB(210, 210, 210),
                            PlaceholderText = "Input",
                            Font = Enum.Font.GothamSemibold,
                            TextXAlignment = Enum.TextXAlignment.Center,
                            TextSize = 14,
                            ClearTextOnFocus = false
                        }
                    ),
                    "Text"
                )
                local bF =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4),
                            {
                                Size = UDim2.new(0, 24, 0, 24),
                                Position = UDim2.new(1, -12, 0.5, 0),
                                AnchorPoint = Vector2.new(1, 0.5)
                            }
                        ),
                        {_(N("Stroke"), "Stroke"), bE}
                    ),
                    "Main"
                )
                local bG =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 38), Parent = ItemParent}
                        ),
                        {
                            _(
                                P(
                                    N("Label", bD.Name, 15),
                                    {
                                        Size = UDim2.new(1, -12, 1, 0),
                                        Position = UDim2.new(0, 12, 0, 0),
                                        Font = Enum.Font.GothamBold,
                                        Name = "Content"
                                    }
                                ),
                                "Text"
                            ),
                            _(N("Stroke"), "Stroke"),
                            bF,
                            ba
                        }
                    ),
                    "Second"
                )
                p(
                    bE:GetPropertyChangedSignal("Text"),
                    function()
                        b:Create(
                            bF,
                            TweenInfo.new(0.45, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, bE.TextBounds.X + 16, 0, 24)}
                        ):Play()
                    end
                )
                p(
                    bE.FocusLost,
                    function()
                        bD.Callback(bE.Text)
                        if bD.TextDisappear then
                            bE.Text = ""
                        end
                    end
                )
                bE.Text = bD.Default
                p(
                    ba.MouseEnter,
                    function()
                        b:Create(
                            bG,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                    end
                )
                p(
                    ba.MouseLeave,
                    function()
                        b:Create(
                            bG,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {BackgroundColor3 = g.Themes[g.SelectedTheme].Second}
                        ):Play()
                    end
                )
                p(
                    ba.MouseButton1Up,
                    function()
                        b:Create(
                            bG,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 3,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 3
                                )
                            }
                        ):Play()
                        bE:CaptureFocus()
                    end
                )
                p(
                    ba.MouseButton1Down,
                    function()
                        b:Create(
                            bG,
                            TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
                            {
                                BackgroundColor3 = Color3.fromRGB(
                                    g.Themes[g.SelectedTheme].Second.R * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.G * 255 + 6,
                                    g.Themes[g.SelectedTheme].Second.B * 255 + 6
                                )
                            }
                        ):Play()
                    end
                )
            end
            function M:AddColorpicker(bH)
                bH = bH or {}
                bH.Name = bH.Name or "Colorpicker"
                bH.Default = bH.Default or Color3.fromRGB(255, 255, 255)
                bH.Callback = bH.Callback or function()
                    end
                bH.Flag = bH.Flag or nil
                bH.Save = bH.Save or false
                local bI, bJ, bK = 1, 1, 1
                local bL = {Value = bH.Default, Toggled = false, Type = "Colorpicker", Save = bH.Save}
                local bM =
                    D(
                    "ImageLabel",
                    {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(select(3, Color3.toHSV(bL.Value))),
                        ScaleType = Enum.ScaleType.Fit,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = "http://www.roblox.com/asset/?id=4805639000"
                    }
                )
                local bN =
                    D(
                    "ImageLabel",
                    {
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(bL.Value))),
                        ScaleType = Enum.ScaleType.Fit,
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = "http://www.roblox.com/asset/?id=4805639000"
                    }
                )
                local a3 =
                    D(
                    "ImageLabel",
                    {Size = UDim2.new(1, -25, 1, 0), Visible = false, Image = "rbxassetid://4155801252"},
                    {D("UICorner", {CornerRadius = UDim.new(0, 5)}), bM}
                )
                local bO =
                    D(
                    "Frame",
                    {Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -20, 0, 0), Visible = false},
                    {
                        D(
                            "UIGradient",
                            {
                                Rotation = 270,
                                Color = ColorSequence.new {
                                    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
                                    ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
                                    ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
                                    ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
                                    ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
                                    ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
                                    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
                                }
                            }
                        ),
                        D("UICorner", {CornerRadius = UDim.new(0, 5)}),
                        bN
                    }
                )
                local bP =
                    D(
                    "Frame",
                    {
                        Position = UDim2.new(0, 0, 0, 32),
                        Size = UDim2.new(1, 0, 1, -32),
                        BackgroundTransparency = 1,
                        ClipsDescendants = true
                    },
                    {
                        bO,
                        a3,
                        D(
                            "UIPadding",
                            {
                                PaddingLeft = UDim.new(0, 35),
                                PaddingRight = UDim.new(0, 35),
                                PaddingBottom = UDim.new(0, 10),
                                PaddingTop = UDim.new(0, 17)
                            }
                        )
                    }
                )
                local ba = P(N("Button"), {Size = UDim2.new(1, 0, 1, 0)})
                local bQ =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 4),
                            {
                                Size = UDim2.new(0, 24, 0, 24),
                                Position = UDim2.new(1, -12, 0.5, 0),
                                AnchorPoint = Vector2.new(1, 0.5)
                            }
                        ),
                        {_(N("Stroke"), "Stroke")}
                    ),
                    "Main"
                )
                local bR =
                    _(
                    T(
                        P(
                            N("RoundFrame", Color3.fromRGB(255, 255, 255), 0, 5),
                            {Size = UDim2.new(1, 0, 0, 38), Parent = ItemParent}
                        ),
                        {
                            P(
                                T(
                                    N("TFrame"),
                                    {
                                        _(
                                            P(
                                                N("Label", bH.Name, 15),
                                                {
                                                    Size = UDim2.new(1, -12, 1, 0),
                                                    Position = UDim2.new(0, 12, 0, 0),
                                                    Font = Enum.Font.GothamBold,
                                                    Name = "Content"
                                                }
                                            ),
                                            "Text"
                                        ),
                                        bQ,
                                        ba,
                                        _(
                                            P(
                                                N("Frame"),
                                                {
                                                    Size = UDim2.new(1, 0, 0, 1),
                                                    Position = UDim2.new(0, 0, 1, -1),
                                                    Name = "Line",
                                                    Visible = false
                                                }
                                            ),
                                            "Stroke"
                                        )
                                    }
                                ),
                                {Size = UDim2.new(1, 0, 0, 38), ClipsDescendants = true, Name = "F"}
                            ),
                            bP,
                            _(N("Stroke"), "Stroke")
                        }
                    ),
                    "Second"
                )
                p(
                    ba.MouseButton1Click,
                    function()
                        bL.Toggled = not bL.Toggled
                        b:Create(
                            bR,
                            TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Size = bL.Toggled and UDim2.new(1, 0, 0, 148) or UDim2.new(1, 0, 0, 38)}
                        ):Play()
                        a3.Visible = bL.Toggled
                        bO.Visible = bL.Toggled
                        bR.F.Line.Visible = bL.Toggled
                    end
                )
                local function bS()
                    bQ.BackgroundColor3 = Color3.fromHSV(bI, bJ, bK)
                    a3.BackgroundColor3 = Color3.fromHSV(bI, 1, 1)
                    bL:Set(bQ.BackgroundColor3)
                    bH.Callback(bQ.BackgroundColor3)
                    aa(game.GameId)
                end
                bI =
                    1 -
                    math.clamp(bN.AbsolutePosition.Y - bO.AbsolutePosition.Y, 0, bO.AbsoluteSize.Y) / bO.AbsoluteSize.Y
                bJ = math.clamp(bM.AbsolutePosition.X - a3.AbsolutePosition.X, 0, a3.AbsoluteSize.X) / a3.AbsoluteSize.X
                bK =
                    1 -
                    math.clamp(bM.AbsolutePosition.Y - a3.AbsolutePosition.Y, 0, a3.AbsoluteSize.Y) / a3.AbsoluteSize.Y
                p(
                    a3.InputBegan,
                    function(bT)
                        if bT.UserInputType == Enum.UserInputType.MouseButton1 then
                            if ColorInput then
                                ColorInput:Disconnect()
                            end
                            ColorInput =
                                p(
                                c.RenderStepped,
                                function()
                                    local bU =
                                        math.clamp(e.X - a3.AbsolutePosition.X, 0, a3.AbsoluteSize.X) /
                                        a3.AbsoluteSize.X
                                    local bV =
                                        math.clamp(e.Y - a3.AbsolutePosition.Y, 0, a3.AbsoluteSize.Y) /
                                        a3.AbsoluteSize.Y
                                    bM.Position = UDim2.new(bU, 0, bV, 0)
                                    bJ = bU
                                    bK = 1 - bV
                                    bS()
                                end
                            )
                        end
                    end
                )
                p(
                    a3.InputEnded,
                    function(bT)
                        if bT.UserInputType == Enum.UserInputType.MouseButton1 then
                            if ColorInput then
                                ColorInput:Disconnect()
                            end
                        end
                    end
                )
                p(
                    bO.InputBegan,
                    function(bT)
                        if bT.UserInputType == Enum.UserInputType.MouseButton1 then
                            if HueInput then
                                HueInput:Disconnect()
                            end
                            HueInput =
                                p(
                                c.RenderStepped,
                                function()
                                    local bW =
                                        math.clamp(e.Y - bO.AbsolutePosition.Y, 0, bO.AbsoluteSize.Y) /
                                        bO.AbsoluteSize.Y
                                    bN.Position = UDim2.new(0.5, 0, bW, 0)
                                    bI = 1 - bW
                                    bS()
                                end
                            )
                        end
                    end
                )
                p(
                    bO.InputEnded,
                    function(bT)
                        if bT.UserInputType == Enum.UserInputType.MouseButton1 then
                            if HueInput then
                                HueInput:Disconnect()
                            end
                        end
                    end
                )
                function bL:Set(Value)
                    bL.Value = Value
                    bQ.BackgroundColor3 = bL.Value
                    bH.Callback(bL.Value)
                end
                bL:Set(bL.Value)
                if bH.Flag then
                    g.Flags[bH.Flag] = bL
                end
                return bL
            end
            return M
        end
        local M = {}
        function M:AddSection(bX)
            bX.Name = bX.Name or "Section"
            local bY =
                T(
                P(N("TFrame"), {Size = UDim2.new(1, 0, 0, 26), Parent = a_}),
                {
                    _(
                        P(
                            N("Label", bX.Name, 14),
                            {
                                Size = UDim2.new(1, -12, 0, 16),
                                Position = UDim2.new(0, 0, 0, 3),
                                Font = Enum.Font.GothamSemibold
                            }
                        ),
                        "TextDark"
                    ),
                    T(
                        P(
                            N("TFrame"),
                            {
                                AnchorPoint = Vector2.new(0, 0),
                                Size = UDim2.new(1, 0, 1, -24),
                                Position = UDim2.new(0, 0, 0, 23),
                                Name = "Holder"
                            }
                        ),
                        {N("List", 0, 6)}
                    )
                }
            )
            p(
                bY.Holder.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"),
                function()
                    bY.Size = UDim2.new(1, 0, 0, bY.Holder.UIListLayout.AbsoluteContentSize.Y + 31)
                    bY.Holder.Size = UDim2.new(1, 0, 0, bY.Holder.UIListLayout.AbsoluteContentSize.Y)
                end
            )
            local bZ = {}
            for I, J in next, b2(bY.Holder) do
                bZ[I] = J
            end
            return bZ
        end
        for I, J in next, b2(a_) do
            M[I] = J
        end
        if aY.PremiumOnly then
            for I, J in next, M do
                M[I] = function()
                end
            end
            a_:FindFirstChild("UIListLayout"):Destroy()
            a_:FindFirstChild("UIPadding"):Destroy()
            T(
                P(N("TFrame"), {Size = UDim2.new(1, 0, 1, 0), Parent = ItemParent}),
                {
                    _(
                        P(
                            N("Image", "rbxassetid://3610239960"),
                            {
                                Size = UDim2.new(0, 18, 0, 18),
                                Position = UDim2.new(0, 15, 0, 15),
                                ImageTransparency = 0.4
                            }
                        ),
                        "Text"
                    ),
                    _(
                        P(
                            N("Label", "Unauthorised Access", 14),
                            {
                                Size = UDim2.new(1, -38, 0, 14),
                                Position = UDim2.new(0, 38, 0, 18),
                                TextTransparency = 0.4
                            }
                        ),
                        "Text"
                    ),
                    _(
                        P(
                            N("Image", "rbxassetid://4483345875"),
                            {Size = UDim2.new(0, 56, 0, 56), Position = UDim2.new(0, 84, 0, 110)}
                        ),
                        "Text"
                    ),
                    _(
                        P(
                            N("Label", "Premium Features", 14),
                            {
                                Size = UDim2.new(1, -150, 0, 14),
                                Position = UDim2.new(0, 150, 0, 112),
                                Font = Enum.Font.GothamBold
                            }
                        ),
                        "Text"
                    ),
                    _(
                        P(
                            N(
                                "Label",
                                "This part of the script is locked to Sirius Premium users. Purchase Premium in the Discord server (discord.gg/sirius)",
                                12
                            ),
                            {
                                Size = UDim2.new(1, -200, 0, 14),
                                Position = UDim2.new(0, 150, 0, 138),
                                TextWrapped = true,
                                TextTransparency = 0.4
                            }
                        ),
                        "Text"
                    )
                }
            )
        end
        return M
    end
    return aX
end
function g:Destroy()
    m:Destroy()
end
return g
