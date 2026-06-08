# Jawere

ui library i made, has tabs buttons toggles sliders dropdowns color pickers etc

---

## load it

external link:
```lua
local Jawere = loadstring(game:HttpGet("https://raw.githubusercontent.com/notrealtze/Custom-Hun/refs/heads/main/Jawere.lua"))()
```

local:
```lua
local Jawere = require(path.to.Jawere)
```

---

## window

```lua
local Window = Jawere.new({
    Name = "my hub",
    Width = 0.5,
    Height = 0.6,
})
```

| key | default | what it does |
|---|---|---|
| Name | "Jawere" | title in the top bar |
| Width | 0.4726 | scale width |
| Height | 0.56944 | scale height |

```lua
Window:SetTitle("new name")
Window:SetVisible(false)
Window:Destroy()
```

---

## tabs

```lua
local Main = Window:AddTab("Main", "rbxassetid://12499751184")
local Combat = Window:AddTab("Combat", "rbxassetid://12499751184")
```

icon is optional

---

## elements

### button

```lua
Main:AddButton("do something", function()
    print("clicked")
end)
```

### toggle

```lua
local t = Main:AddToggle("god mode", false, function(state)
    print(state)
end)

t:SetState(true)
t:GetState()
```

### slider

```lua
Main:AddSlider("speed", 0, 100, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)
```

### textbox

fires callback when you hit enter

```lua
Main:AddTextbox("name", "type here...", function(val)
    print(val)
end)
```

### dropdown

```lua
Main:AddDropdown("team", {"Red", "Blue", "Green"}, function(val)
    print(val)
end)
```

### multi dropdown

callback gives you a table of whatever's checked

```lua
Main:AddMultiDropdown("parts", {"Head", "Torso", "HumanoidRootPart"}, function(selected)
    print(table.concat(selected, ", "))
end)
```

### color picker

click the color box to open it

```lua
Main:AddColorPicker("color", Color3.fromRGB(255, 80, 80), function(color)
    print(color)
end)
```

### section

just a divider

```lua
Main:AddSection("combat")
```

### label

name on left value on right, you can update it

```lua
local ping = Main:AddLabel("ping", "0ms")
ping:SetValue("32ms")
```

---

## full example

```lua
local Jawere = loadstring(game:HttpGet("https://raw.githubusercontent.com/notrealtze/Custom-Hun/refs/heads/main/Jawere.lua"))()

local Window = Jawere.new({ Name = "my hub", Width = 0.5, Height = 0.6 })

local Main = Window:AddTab("Main", "rbxassetid://12499751184")

Main:AddSection("player")

Main:AddButton("print hello", function()
    print("hi")
end)

Main:AddToggle("god mode", false, function(state)
    print("god mode:", state)
end)

Main:AddSlider("speed", 0, 100, 16, function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

local ping = Main:AddLabel("ping", "0ms")
```
