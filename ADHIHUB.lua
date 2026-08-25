--[[
    ADHIHUB v2.1
    Features: SaveInstance | Nice (Password) | Fly | Noclip | Misc
    Toggle GUI: Right Control
    Fly: E | Noclip: N
]]

-- ═══════════════════════════════════════════════
-- SERVICES
-- ═══════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ═══════════════════════════════════════════════
-- THEME
-- ═══════════════════════════════════════════════

local Theme = {
    BG          = Color3.fromRGB(18, 18, 24),
    Panel       = Color3.fromRGB(24, 24, 32),
    Card        = Color3.fromRGB(30, 30, 40),
    Accent      = Color3.fromRGB(100, 70, 255),
    AccentGlow  = Color3.fromRGB(130, 100, 255),
    Text        = Color3.fromRGB(230, 230, 240),
    TextDim     = Color3.fromRGB(140, 140, 160),
    TextMuted   = Color3.fromRGB(90, 90, 110),
    Green       = Color3.fromRGB(80, 220, 120),
    Red         = Color3.fromRGB(255, 80, 90),
    Orange      = Color3.fromRGB(255, 170, 60),
    Gold        = Color3.fromRGB(255, 215, 0),
    Border      = Color3.fromRGB(45, 45, 60),
    ToggleOn    = Color3.fromRGB(100, 70, 255),
    ToggleOff   = Color3.fromRGB(50, 50, 65),
    Hover       = Color3.fromRGB(38, 38, 50),
}

-- ═══════════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════════

if game:GetService("CoreGui"):FindFirstChild("ADHIHUB") then
    game:GetService("CoreGui"):FindFirstChild("ADHIHUB"):Destroy()
end

-- ═══════════════════════════════════════════════
-- GUI
-- ═══════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ADHIHUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = player.PlayerGui end

-- ═══════════════════════════════════════════════
-- UTILS
-- ═══════════════════════════════════════════════

local function create(cls, props, children)
    local inst = Instance.new(cls)
    for k, v in pairs(props or {}) do inst[k] = v end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    return inst
end

local function tween(obj, props, dur, style)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function addCorner(p, r)
    return create("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p })
end

local function addStroke(p, color, thick)
    return create("UIStroke", { Color = color or Theme.Border, Thickness = thick or 1, Parent = p })
end

local function addPadding(p, t, b, l, r)
    return create("UIPadding", {
        PaddingTop = UDim.new(0, t or 8), PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 10), PaddingRight = UDim.new(0, r or 10),
        Parent = p,
    })
end

-- ═══════════════════════════════════════════════
-- WATERMARK
-- ═══════════════════════════════════════════════

local WatermarkFrame = create("Frame", {
    Name = "Watermark", Size = UDim2.new(0, 220, 0, 36),
    Position = UDim2.new(0, 12, 0, 12),
    BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Parent = ScreenGui,
})
addCorner(WatermarkFrame, 10)
addStroke(WatermarkFrame, Theme.Accent, 1.5)

create("TextLabel", {
    Size = UDim2.new(1, -16, 1, 0), Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1, Text = "ADHIHUB",
    TextColor3 = Theme.AccentGlow, Font = Enum.Font.GothamBold,
    TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left,
    Parent = WatermarkFrame,
})

create("TextLabel", {
    Size = UDim2.new(0, 50, 1, 0), Position = UDim2.new(1, -58, 0, 0),
    BackgroundTransparency = 1, Text = "v2.1",
    TextColor3 = Theme.TextMuted, Font = Enum.Font.Gotham,
    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right,
    Parent = WatermarkFrame,
})

-- ═══════════════════════════════════════════════
-- MAIN WINDOW
-- ═══════════════════════════════════════════════

local MainFrame = create("Frame", {
    Name = "MainWindow", Size = UDim2.new(0, 460, 0, 520),
    Position = UDim2.new(0.5, -230, 0.5, -260),
    BackgroundColor3 = Theme.BG, BackgroundTransparency = 0.02,
    BorderSizePixel = 0, Active = true, Draggable = true,
    Parent = ScreenGui,
})
addCorner(MainFrame, 12)
addStroke(MainFrame, Theme.Border, 1)

create("ImageLabel", {
    Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0, -15, 0, -15),
    BackgroundTransparency = 1, Image = "rbxassetid://6015897843",
    ImageColor3 = Color3.new(0, 0, 0), ImageTransparency = 0.6,
    ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
    ZIndex = -1, Parent = MainFrame,
})

-- Title bar
local TitleBar = create("Frame", {
    Name = "TitleBar", Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Parent = MainFrame,
})
addCorner(TitleBar, 12)
create("Frame", {
    Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Parent = TitleBar,
})

create("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 14, 0, 0),
    BackgroundTransparency = 1, Text = "ADHIHUB",
    TextColor3 = Theme.AccentGlow, Font = Enum.Font.GothamBlack,
    TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar,
})

create("TextLabel", {
    Size = UDim2.new(0, 140, 1, 0), Position = UDim2.new(0, 110, 0, 0),
    BackgroundTransparency = 1, Text = "Premium Tool Suite",
    TextColor3 = Theme.TextMuted, Font = Enum.Font.Gotham,
    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar,
})

-- ═══════════════════════════════════════════════
-- MINIMIZE BUTTON (-)
-- ═══════════════════════════════════════════════

local MinimizedBtn = create("TextButton", {
    Name = "MinimizedBtn", Size = UDim2.new(0, 120, 0, 36),
    Position = UDim2.new(0, 12, 0, 12),
    BackgroundColor3 = Theme.Panel, BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Text = "ADHIHUB",
    TextColor3 = Theme.AccentGlow, Font = Enum.Font.GothamBold,
    TextSize = 14, Visible = false, AutoButtonColor = false,
    Parent = ScreenGui,
})
addCorner(MinimizedBtn, 10)
addStroke(MinimizedBtn, Theme.Accent, 1.5)

MinimizedBtn.MouseEnter:Connect(function()
    tween(MinimizedBtn, { BackgroundTransparency = 0 }, 0.15)
end)
MinimizedBtn.MouseLeave:Connect(function()
    tween(MinimizedBtn, { BackgroundTransparency = 0.05 }, 0.15)
end)

local function minimizeGUI()
    MainFrame.Visible = false
    WatermarkFrame.Visible = false
    MinimizedBtn.Visible = true
end

local function restoreGUI()
    MainFrame.Visible = true
    WatermarkFrame.Visible = true
    MinimizedBtn.Visible = false
end

MinimizedBtn.MouseButton1Click:Connect(restoreGUI)

-- Minimize button (the "-" in title bar)
local MinBtn = create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -72, 0, 7),
    BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.7,
    Text = "—", TextColor3 = Theme.Accent,
    Font = Enum.Font.GothamBold, TextSize = 16,
    Parent = TitleBar,
})
addCorner(MinBtn, 8)

MinBtn.MouseEnter:Connect(function() tween(MinBtn, { BackgroundTransparency = 0.4 }, 0.15) end)
MinBtn.MouseLeave:Connect(function() tween(MinBtn, { BackgroundTransparency = 0.7 }, 0.15) end)
MinBtn.MouseButton1Click:Connect(minimizeGUI)

-- Close button
local CloseBtn = create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -38, 0, 7),
    BackgroundColor3 = Theme.Red, BackgroundTransparency = 0.8,
    Text = "×", TextColor3 = Theme.Red,
    Font = Enum.Font.GothamBold, TextSize = 20,
    Parent = TitleBar,
})
addCorner(CloseBtn, 8)

CloseBtn.MouseEnter:Connect(function() tween(CloseBtn, { BackgroundTransparency = 0.5 }, 0.15) end)
CloseBtn.MouseLeave:Connect(function() tween(CloseBtn, { BackgroundTransparency = 0.8 }, 0.15) end)
CloseBtn.MouseButton1Click:Connect(minimizeGUI)

-- ═══════════════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════════════

local TabHolder = create("Frame", {
    Name = "Tabs", Size = UDim2.new(1, -16, 0, 36),
    Position = UDim2.new(0, 8, 0, 52),
    BackgroundTransparency = 1, Parent = MainFrame,
})

local TabContainer = create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Theme.Card, BackgroundTransparency = 0.3,
    BorderSizePixel = 0, Parent = TabHolder,
})
addCorner(TabContainer, 8)

create("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 4), Parent = TabContainer,
})
addPadding(TabContainer, 3, 3, 4, 4)

local TabButtons = {}
local TabPages = {}
local ActiveTab = nil

local function createTab(name)
    local btn = create("TextButton", {
        Size = UDim2.new(0, 90, 0, 28),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 1,
        Text = name, TextColor3 = Theme.TextDim,
        Font = Enum.Font.GothamSemibold, TextSize = 12,
        Parent = TabContainer,
    })
    addCorner(btn, 6)

    local page = create("ScrollingFrame", {
        Name = name .. "Page", Size = UDim2.new(1, -16, 1, -110),
        Position = UDim2.new(0, 8, 0, 96),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, Parent = MainFrame,
    })
    create("UIListLayout", { Padding = UDim.new(0, 6), Parent = page })
    addPadding(page, 4, 4, 2, 2)

    TabButtons[name] = btn
    TabPages[name] = page

    btn.MouseButton1Click:Connect(function()
        for n, b in pairs(TabButtons) do
            tween(b, { BackgroundTransparency = 1 }, 0.15)
            b.TextColor3 = Theme.TextDim
            TabPages[n].Visible = false
        end
        tween(btn, { BackgroundTransparency = 0 }, 0.15)
        btn.TextColor3 = Theme.Text
        page.Visible = true
        ActiveTab = name
    end)

    return btn, page
end

-- ═══════════════════════════════════════════════
-- UI COMPONENTS
-- ═══════════════════════════════════════════════

local function createSection(parent, text)
    local s = create("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundTransparency = 1, Parent = parent })
    create("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = text, TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = s,
    })
    create("Frame", {
        Size = UDim2.new(0.6, 0, 0, 1), Position = UDim2.new(0, 80, 0.5, 0),
        BackgroundColor3 = Theme.Border, BorderSizePixel = 0, Parent = s,
    })
    return s
end

local function createToggle(parent, text, default)
    local toggled = default or false

    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.1, BorderSizePixel = 0, Parent = parent,
    })
    addCorner(frame, 8)
    addStroke(frame, Theme.Border, 0.5)

    create("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
    })

    local toggleBG = create("Frame", {
        Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -52, 0.5, -10),
        BackgroundColor3 = toggled and Theme.ToggleOn or Theme.ToggleOff,
        BorderSizePixel = 0, Parent = frame,
    })
    addCorner(toggleBG, 10)

    local toggleCircle = create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Theme.Text, BorderSizePixel = 0, Parent = toggleBG,
    })
    addCorner(toggleCircle, 8)

    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        Text = "", Parent = frame,
    })

    local callback = nil

    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        tween(toggleBG, { BackgroundColor3 = toggled and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
        tween(toggleCircle, {
            Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }, 0.2, Enum.EasingStyle.Back)
        if callback then callback(toggled) end
    end)

    return {
        Get = function() return toggled end,
        Set = function(v)
            toggled = v
            tween(toggleBG, { BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff }, 0.2)
            tween(toggleCircle, {
                Position = v and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }, 0.2, Enum.EasingStyle.Back)
            if callback then callback(v) end
        end,
        SetCallback = function(self, cb) callback = cb end,
    }
end

local function createButton(parent, text, color, callback)
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = color or Theme.Accent,
        BackgroundTransparency = 0.1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 14, AutoButtonColor = false,
        Parent = parent,
    })
    addCorner(btn, 8)
    btn.MouseEnter:Connect(function() tween(btn, { BackgroundTransparency = 0 }, 0.15) end)
    btn.MouseLeave:Connect(function() tween(btn, { BackgroundTransparency = 0.1 }, 0.15) end)
    btn.MouseButton1Click:Connect(function()
        tween(btn, { BackgroundTransparency = 0.4 }, 0.05)
        task.wait(0.05)
        tween(btn, { BackgroundTransparency = 0.1 }, 0.1)
        if callback then callback() end
    end)
    return btn
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default or min

    local frame = create("Frame", {
        Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Theme.Panel,
        BackgroundTransparency = 0.1, BorderSizePixel = 0, Parent = parent,
    })
    addCorner(frame, 8)
    addStroke(frame, Theme.Border, 0.5)

    create("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 20), Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = frame,
    })

    local valueLabel = create("TextLabel", {
        Size = UDim2.new(0.3, -12, 0, 20), Position = UDim2.new(0.7, 0, 0, 6),
        BackgroundTransparency = 1, Text = tostring(value),
        TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, Parent = frame,
    })

    local trackBG = create("Frame", {
        Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 34),
        BackgroundColor3 = Theme.ToggleOff, BorderSizePixel = 0, Parent = frame,
    })
    addCorner(trackBG, 3)

    local fill = create("Frame", {
        Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = trackBG,
    })
    addCorner(fill, 3)

    local thumb = create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
        BackgroundColor3 = Theme.Text, BorderSizePixel = 0, Parent = trackBG,
    })
    addCorner(thumb, 7)

    local dragging = false

    local hitbox = create("TextButton", {
        Size = UDim2.new(1, 0, 1, 10), Position = UDim2.new(0, 0, 0, -5),
        BackgroundTransparency = 1, Text = "", Parent = trackBG,
    })

    local function update(inputX)
        local pct = math.clamp((inputX - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
        value = math.floor(min + (max - min) * pct)
        tween(fill, { Size = UDim2.new(pct, 0, 1, 0) }, 0.1)
        tween(thumb, { Position = UDim2.new(pct, -7, 0.5, -7) }, 0.1)
        valueLabel.Text = tostring(value)
        if callback then callback(value) end
    end

    hitbox.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update(input.Position.X)
        end
    end)

    return {
        Get = function() return value end,
        Set = function(v)
            value = math.clamp(v, min, max)
            local pct = (value - min) / (max - min)
            fill.Size = UDim2.new(pct, 0, 1, 0)
            thumb.Position = UDim2.new(pct, -7, 0.5, -7)
            valueLabel.Text = tostring(value)
            if callback then callback(value) end
        end,
    }
end

local function createLabel(parent, text)
    return create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
        Text = "  " .. text, TextColor3 = Theme.TextMuted,
        Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = parent,
    })
end

-- ═══════════════════════════════════════════════
-- TAB: SAVE
-- ═══════════════════════════════════════════════

local _, SavePage = createTab("Save")

createSection(SavePage, "SELECT WHAT TO SAVE")

local toggleWorkspace = createToggle(SavePage, "Workspace (Map / Parts)", true)
local toggleLighting = createToggle(SavePage, "Lighting (Fog / Effects)", true)
local toggleReplicatedStorage = createToggle(SavePage, "ReplicatedStorage (Modules)", true)
local toggleServerStorage = createToggle(SavePage, "ServerStorage (Server Scripts)", true)
local toggleServerScript = createToggle(SavePage, "ServerScriptService", true)
local toggleStarterGui = createToggle(SavePage, "StarterGui (UI / Scripts)", true)
local toggleStarterPlayer = createToggle(SavePage, "StarterPlayer (Player Scripts)", true)

createSection(SavePage, "OPTIONS")

local toggleTerrain = createToggle(SavePage, "Include Terrain", true)
local toggleDecompile = createToggle(SavePage, "Decompile Scripts", true)
local toggleNotCreatable = createToggle(SavePage, "Save NotCreatable", true)
local togglePlayerChars = createToggle(SavePage, "Remove Player Characters", true)
local toggleDefaultProps = createToggle(SavePage, "Save Default Properties", false)

createSection(SavePage, "SAVE")

createButton(SavePage, "SAVE GAME", Theme.Accent, function()
    local rawScript = game:HttpGet("https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/saveinstance.lua", true)
    loadstring(rawScript)()

    local instances = {}
    if toggleWorkspace.Get() then table.insert(instances, workspace) end
    if toggleLighting.Get() then table.insert(instances, game:GetService("Lighting")) end
    if toggleReplicatedStorage.Get() then table.insert(instances, game:GetService("ReplicatedStorage")) end
    if toggleServerStorage.Get() then table.insert(instances, game:GetService("ServerStorage")) end
    if toggleServerScript.Get() then table.insert(instances, game:GetService("ServerScriptService")) end
    if toggleStarterGui.Get() then table.insert(instances, game:GetService("StarterGui")) end
    if toggleStarterPlayer.Get() then table.insert(instances, game:GetService("StarterPlayer")) end

    local timestamp = os.date("%Y%m%d_%H%M%S")
    local fileName = "ADHIHUB_" .. timestamp

    saveinstance({
        mode = "custom",
        ExtraInstances = instances,
        TreatUnionsAsParts = false,
        SharedStringOverwrite = true,
        IgnoreDefaultProps = toggleDefaultProps.Get(),
        SaveNotCreatable = toggleNotCreatable.Get(),
        RemovePlayerCharacters = togglePlayerChars.Get(),
        Decompile = toggleDecompile.Get(),
        FilePath = fileName,
    })
end)

createLabel(SavePage, "File saved as ADHIHUB_[timestamp]")

-- ═══════════════════════════════════════════════
-- TAB: NICE (Password Protected)
-- ═══════════════════════════════════════════════

local _, NicePage = createTab("Nice")

createSection(NicePage, "SECRET SAVE")

createButton(NicePage, "NICE", Theme.Gold, function()
    local PassOverlay = create("Frame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.4, BorderSizePixel = 0, ZIndex = 100,
        Parent = MainFrame,
    })

    local PassBox = create("Frame", {
        Size = UDim2.new(0, 280, 0, 200), Position = UDim2.new(0.5, -140, 0.5, -100),
        BackgroundColor3 = Theme.BG, BorderSizePixel = 0, ZIndex = 101,
        Parent = PassOverlay,
    })
    addCorner(PassBox, 12)
    addStroke(PassBox, Theme.Accent, 1.5)

    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1,
        Text = "ENTER PASSWORD", TextColor3 = Theme.AccentGlow,
        Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 102,
        Parent = PassBox,
    })

    local PassInput = create("TextBox", {
        Size = UDim2.new(1, -40, 0, 38), Position = UDim2.new(0, 20, 0, 48),
        BackgroundColor3 = Theme.Card, BorderSizePixel = 0,
        Text = "", PlaceholderText = "Password...",
        PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false,
        ZIndex = 102, Parent = PassBox,
    })
    addCorner(PassInput, 6)
    addStroke(PassInput, Theme.Border, 0.5)

    local PassStatus = create("TextLabel", {
        Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 20, 0, 92),
        BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Red,
        Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 102,
        Parent = PassBox,
    })

    local function destroyPass() PassOverlay:Destroy() end

    local SubmitBtn = create("TextButton", {
        Size = UDim2.new(1, -40, 0, 34), Position = UDim2.new(0, 20, 1, -46),
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.1,
        Text = "SUBMIT", TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 102,
        Parent = PassBox,
    })
    addCorner(SubmitBtn, 8)

    local CancelBtn = create("TextButton", {
        Size = UDim2.new(0, 60, 0, 26), Position = UDim2.new(0.5, -30, 1, -80),
        BackgroundTransparency = 1, Text = "Cancel",
        TextColor3 = Theme.TextDim, Font = Enum.Font.Gotham,
        TextSize = 12, ZIndex = 102, Parent = PassBox,
    })
    CancelBtn.MouseButton1Click:Connect(destroyPass)

    local function showNameInput()
        PassBox:Destroy()

        local NameBox = create("Frame", {
            Size = UDim2.new(0, 280, 0, 200), Position = UDim2.new(0.5, -140, 0.5, -100),
            BackgroundColor3 = Theme.BG, BorderSizePixel = 0, ZIndex = 101,
            Parent = PassOverlay,
        })
        addCorner(NameBox, 12)
        addStroke(NameBox, Theme.Gold, 1.5)

        create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1,
            Text = "FILE NAME", TextColor3 = Theme.Gold,
            Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 102,
            Parent = NameBox,
        })

        local NameInput = create("TextBox", {
            Size = UDim2.new(1, -40, 0, 38), Position = UDim2.new(0, 20, 0, 48),
            BackgroundColor3 = Theme.Card, BorderSizePixel = 0,
            Text = "", PlaceholderText = "Enter file name...",
            PlaceholderColor3 = Theme.TextMuted, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 14, ClearTextOnFocus = false,
            ZIndex = 102, Parent = NameBox,
        })
        addCorner(NameInput, 6)
        addStroke(NameInput, Theme.Border, 0.5)

        local NameStatus = create("TextLabel", {
            Size = UDim2.new(1, -40, 0, 20), Position = UDim2.new(0, 20, 0, 92),
            BackgroundTransparency = 1, Text = "", TextColor3 = Theme.Red,
            Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 102,
            Parent = NameBox,
        })

        local StartBtn = create("TextButton", {
            Size = UDim2.new(1, -40, 0, 34), Position = UDim2.new(0, 20, 1, -46),
            BackgroundColor3 = Theme.Gold, BackgroundTransparency = 0.1,
            Text = "START", TextColor3 = Theme.BG,
            Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 102,
            Parent = NameBox,
        })
        addCorner(StartBtn, 8)

        local CancelBtn2 = create("TextButton", {
            Size = UDim2.new(0, 60, 0, 26), Position = UDim2.new(0.5, -30, 1, -80),
            BackgroundTransparency = 1, Text = "Cancel",
            TextColor3 = Theme.TextDim, Font = Enum.Font.Gotham,
            TextSize = 12, ZIndex = 102, Parent = NameBox,
        })
        CancelBtn2.MouseButton1Click:Connect(destroyPass)

        local function doSave(fileName)
            destroyPass()
            print("NICE — Saving as: " .. fileName)

            local rawScript = game:HttpGet("https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/saveinstance.lua", true)
            loadstring(rawScript)()

            saveinstance({
                mode = "custom",
                ExtraInstances = {
                    workspace,
                    game:GetService("Lighting"),
                    game:GetService("ReplicatedStorage"),
                    game:GetService("ServerStorage"),
                    game:GetService("ServerScriptService"),
                    game:GetService("StarterGui"),
                    game:GetService("StarterPlayer"),
                },
                TreatUnionsAsParts = false,
                SharedStringOverwrite = true,
                IgnoreDefaultProps = false,
                SaveNotCreatable = true,
                RemovePlayerCharacters = true,
                Decompile = true,
                FilePath = fileName,
            })
        end

        StartBtn.MouseButton1Click:Connect(function()
            local name = NameInput.Text
            if name == "" or name == nil then
                NameStatus.TextColor3 = Theme.Red
                NameStatus.Text = "Enter a file name!"
                return
            end
            NameStatus.TextColor3 = Theme.Green
            NameStatus.Text = "Starting save..."
            task.wait(0.3)
            doSave(name)
        end)

        NameInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then StartBtn:MouseButton1Click() end
        end)
    end

    SubmitBtn.MouseButton1Click:Connect(function()
        if PassInput.Text == "hackme" then
            PassStatus.TextColor3 = Theme.Green
            PassStatus.Text = "Access granted!"
            task.wait(0.5)
            showNameInput()
        else
            PassStatus.TextColor3 = Theme.Red
            PassStatus.Text = "Wrong password!"
            PassInput.Text = ""
            PassBox.Position = UDim2.new(0.5, -135, 0.5, -100)
            task.wait(0.05)
            PassBox.Position = UDim2.new(0.5, -145, 0.5, -100)
            task.wait(0.05)
            PassBox.Position = UDim2.new(0.5, -140, 0.5, -100)
        end
    end)

    PassInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then SubmitBtn:MouseButton1Click() end
    end)
end)

-- ═══════════════════════════════════════════════
-- TAB: FLY
-- ═══════════════════════════════════════════════

local _, FlyPage = createTab("Fly")

createSection(FlyPage, "FLIGHT SETTINGS")

local flySpeed = createSlider(FlyPage, "Flight Speed", 10, 200, 50)
local flyToggle = createToggle(FlyPage, "Fly Enabled (E)", false)
local noclipToggle = createToggle(FlyPage, "Noclip (N)", false)

createSection(FlyPage, "CONTROLS")

createLabel(FlyPage, "E — Toggle Fly")
createLabel(FlyPage, "N — Toggle Noclip")
createLabel(FlyPage, "WASD — Move")
createLabel(FlyPage, "Space — Up | Q — Down")

-- ═══════════════════════════════════════════════
-- FLY + NOCLIP LOGIC
-- ═══════════════════════════════════════════════

local flying = false
local bodyGyro, bodyVelocity
local noclipConn = nil

local function stopFly()
    flying = false
    flyToggle.Set(false)
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

local function startFly()
    if flying then return end
    flying = true
    flyToggle.Set(true)

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = hrp

    char.Humanoid.PlatformStand = true
end

local controlState = { W = false, A = false, S = false, D = false, Space = false, Q = false }

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then
        if flying then stopFly() else startFly() end
    elseif input.KeyCode == Enum.KeyCode.N then
        noclipToggle.Set(not noclipToggle.Get())
    end

    if input.KeyCode == Enum.KeyCode.W then controlState.W = true end
    if input.KeyCode == Enum.KeyCode.A then controlState.A = true end
    if input.KeyCode == Enum.KeyCode.S then controlState.S = true end
    if input.KeyCode == Enum.KeyCode.D then controlState.D = true end
    if input.KeyCode == Enum.KeyCode.Space then controlState.Space = true end
    if input.KeyCode == Enum.KeyCode.Q then controlState.Q = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then controlState.W = false end
    if input.KeyCode == Enum.KeyCode.A then controlState.A = false end
    if input.KeyCode == Enum.KeyCode.S then controlState.S = false end
    if input.KeyCode == Enum.KeyCode.D then controlState.D = false end
    if input.KeyCode == Enum.KeyCode.Space then controlState.Space = false end
    if input.KeyCode == Enum.KeyCode.Q then controlState.Q = false end
end)

RunService.RenderStepped:Connect(function()
    if not flying then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dir = Vector3.new(0, 0, 0)
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector

    if controlState.W then dir = dir + look end
    if controlState.S then dir = dir - look end
    if controlState.A then dir = dir - right end
    if controlState.D then dir = dir + right end
    if controlState.Space then dir = dir + Vector3.new(0, 1, 0) end
    if controlState.Q then dir = dir - Vector3.new(0, 1, 0) end

    if dir.Magnitude > 0 then dir = dir.Unit end

    if bodyVelocity then bodyVelocity.Velocity = dir * flySpeed.Get() end
    if bodyGyro then bodyGyro.CFrame = camera.CFrame end
end)

-- NOCLIP — runs every frame, checks if toggled
noclipToggle:SetCallback(function(enabled)
    if enabled then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end
end)

-- ═══════════════════════════════════════════════
-- TAB: MISC
-- ═══════════════════════════════════════════════

local _, MiscPage = createTab("Misc")

createSection(MiscPage, "PLAYER")

local speedSlider = createSlider(MiscPage, "Walk Speed", 16, 300, 16, function(val)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = val
    end
end)

local jumpSlider = createSlider(MiscPage, "Jump Power", 50, 300, 50, function(val)
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = val
    end
end)

createButton(MiscPage, "RESET SPEED", Theme.Orange, function()
    speedSlider.Set(16)
    jumpSlider.Set(50)
end)

createSection(MiscPage, "DISPLAY")

createButton(MiscPage, "DESTROY GUI", Theme.Red, function()
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════════════
-- TOGGLE GUI (Right Control)
-- ═══════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if MainFrame.Visible then
            minimizeGUI()
        else
            restoreGUI()
        end
    end
end)

-- ═══════════════════════════════════════════════
-- AUTO RECONNECT
-- ═══════════════════════════════════════════════

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    if flying then startFly() end
end)

-- ═══════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════

for name, btn in pairs(TabButtons) do
    if name == "Save" then
        tween(btn, { BackgroundTransparency = 0 }, 0.2)
        btn.TextColor3 = Theme.Text
        TabPages[name].Visible = true
        ActiveTab = name
    end
end

print("═══════════════════════════════════")
print("  ADHIHUB v2.1 — Loaded!")
print("  Toggle GUI: Right Control")
print("  Fly: E | Noclip: N")
print("═══════════════════════════════════")
