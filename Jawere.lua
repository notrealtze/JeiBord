local Jawere = {}
Jawere.__index = Jawere

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local function makeTween(obj, info, props)
 TweenService:Create(obj, info, props):Play()
end


local function corner(parent, radius)
 local c = Instance.new("UICorner", parent)
 c.CornerRadius = UDim.new(0, radius or 4)
 return c
end

local function stroke(parent, color, thickness)
 local s = Instance.new("UIStroke", parent)
 s.Color = color or Color3.fromRGB(72, 72, 72)
 s.Thickness = thickness or 1.8
 return s
end

local function padding(parent, top, left, right, bottom)
 local p = Instance.new("UIPadding", parent)
 p.PaddingTop = UDim.new(0, top or 0)
 p.PaddingLeft = UDim.new(0, left or 0)
 p.PaddingRight = UDim.new(0, right or 0)
 p.PaddingBottom = UDim.new(0, bottom or 0)
 return p
end

local function makeLabel(parent, text, props)
 local lbl = Instance.new("TextLabel", parent)
 lbl.BorderSizePixel = 0
 lbl.BackgroundTransparency = 1
 lbl.TextScaled = true
 lbl.TextWrapped = true
 lbl.FontFace = props.font or Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
 lbl.TextColor3 = props.color or Color3.fromRGB(255, 255, 255)
 lbl.TextXAlignment = props.xAlign or Enum.TextXAlignment.Left
 lbl.Size = props.size or UDim2.new(0.4, 0, 1, 0)
 lbl.Position = props.pos or UDim2.new(0, 0, 0, 0)
 lbl.AnchorPoint = props.anchor or Vector2.new(0, 0.5)
 lbl.Text = text
 if props.zindex then lbl.ZIndex = props.zindex end
 return lbl
end

function Jawere.new(config)
 config = config or {}
 local name = config.Name or "Jawere"
 local width = config.Width or 0.4726
 local height = config.Height or 0.56944

 local self = setmetatable({}, Jawere)
 self._tabs = {}
 self._activeTab = nil
 self._tabButtons = {}
 self._tabOrder = 0

 local gui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
 gui.Name = name
 gui.IgnoreGuiInset = true
 gui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
 gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
 gui.ResetOnSpawn = false
 self._gui = gui

 local main = Instance.new("Frame", gui)
 main.Name = "Main"
 main.ZIndex = 99
 main.BorderSizePixel = 0
 main.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
 main.AnchorPoint = Vector2.new(0.5, 0.5)
 main.Size = UDim2.new(width, 0, height, 0)
 main.Position = UDim2.new(0.5, 0, 0.5, 0)
 corner(main, 8)
 stroke(main, Color3.fromRGB(72, 72, 72), 1)
 local aspect = Instance.new("UIAspectRatioConstraint", main)
 aspect.AspectRatio = width / height * (16/9)
 self._main = main

 local topBar = Instance.new("Frame", main)
 topBar.Name = "TopBar"
 topBar.ZIndex = 999
 topBar.BorderSizePixel = 0
 topBar.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
 topBar.Size = UDim2.new(1, 0, 0.1626, 0)
 corner(topBar, 5)

 local titleLine = Instance.new("Frame", topBar)
 titleLine.BorderSizePixel = 0
 titleLine.ZIndex = 99
 titleLine.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
 titleLine.Size = UDim2.new(1, 0, 0.05, 0)
 titleLine.Position = UDim2.new(0, 0, 0.9, 0)
 corner(titleLine, 5)

 local titleLabel = Instance.new("TextLabel", topBar)
 titleLabel.Name = "Title"
 titleLabel.BorderSizePixel = 0
 titleLabel.BackgroundTransparency = 1
 titleLabel.TextScaled = true
 titleLabel.TextWrapped = true
 titleLabel.TextXAlignment = Enum.TextXAlignment.Left
 titleLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
 titleLabel.TextColor3 = Color3.fromRGB(225, 226, 255)
 titleLabel.Size = UDim2.new(0.7, 0, 0.95, 0)
 titleLabel.Text = name
 Instance.new("UIStroke", titleLabel)

 local closeBtn = Instance.new("ImageButton", topBar)
 closeBtn.BorderSizePixel = 0
 closeBtn.BackgroundTransparency = 1
 closeBtn.Image = "rbxassetid://18503481771"
 closeBtn.Size = UDim2.new(0.08454, 0, 0.875, 0)
 closeBtn.Position = UDim2.new(0.91304, 0, 0.05, 0)
 closeBtn.MouseButton1Click:Connect(function()
 main.Visible = false
 end)

 local dragging, dragStart, startPos
 topBar.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 dragStart = input.Position
 startPos = main.Position
 end
 end)
 UserInputService.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 local delta = input.Position - dragStart
 main.Position = UDim2.new(
 startPos.X.Scale, startPos.X.Offset + delta.X,
 startPos.Y.Scale, startPos.Y.Offset + delta.Y
 )
 end
 end)
 UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = false
 end
 end)

 local sidebar = Instance.new("Frame", main)
 sidebar.Name = "SideBar"
 sidebar.ZIndex = 3
 sidebar.BorderSizePixel = 0
 sidebar.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
 sidebar.ClipsDescendants = true
 sidebar.Size = UDim2.new(0.23188, 0, 0.8374, 0)
 sidebar.Position = UDim2.new(0.00483, 0, 0.1626, 0)
 corner(sidebar, 4)
 self._sidebar = sidebar

 local tabScroll = Instance.new("ScrollingFrame", sidebar)
 tabScroll.Name = "TabHolderList"
 tabScroll.ScrollingDirection = Enum.ScrollingDirection.Y
 tabScroll.ZIndex = 3
 tabScroll.BorderSizePixel = 0
 tabScroll.ElasticBehavior = Enum.ElasticBehavior.Always
 tabScroll.BackgroundTransparency = 1
 tabScroll.ScrollBarImageTransparency = 1
 tabScroll.ClipsDescendants = false
 tabScroll.Size = UDim2.new(1, 0, 1, 0)
 corner(tabScroll, 4)
 padding(tabScroll, 2)

 local tabList = Instance.new("UIListLayout", tabScroll)
 tabList.SortOrder = Enum.SortOrder.LayoutOrder
 tabList.Padding = UDim.new(0, 4)
 tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

 tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
 tabScroll.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 6)
 end)

 self._tabScroll = tabScroll

 local elemHolder = Instance.new("Frame", main)
 elemHolder.Name = "ElementsHolder"
 elemHolder.BorderSizePixel = 0
 elemHolder.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
 elemHolder.ClipsDescendants = true
 elemHolder.Size = UDim2.new(0.98551, 0, 0.82927, 0)
 elemHolder.Position = UDim2.new(0.00966, 0, 0.1626, 0)
 corner(elemHolder, 4)
 self._elemHolder = elemHolder

 return self
end

function Jawere:SetTitle(name)
 self._main.Parent.Name = name
 local title = self._main:FindFirstChild("TopBar") and self._main.TopBar:FindFirstChild("Title")
 if title then title.Text = name end
end

function Jawere:SetVisible(bool)
 self._main.Visible = bool
end

function Jawere:Destroy()
 self._gui:Destroy()
end

local Tab = {}
Tab.__index = Tab

function Jawere:AddTab(name, icon)
 local self2 = setmetatable({}, Tab)
 self2._window = self

 local scroll = Instance.new("ScrollingFrame", self._elemHolder)
 scroll.Name = "TabContent_" .. name
 scroll.ScrollingDirection = Enum.ScrollingDirection.Y
 scroll.BorderSizePixel = 0
 scroll.ElasticBehavior = Enum.ElasticBehavior.Always
 scroll.BackgroundTransparency = 1
 scroll.ScrollBarImageTransparency = 1
 scroll.ClipsDescendants = false
 scroll.AnchorPoint = Vector2.new(0.5, 0.5)
 scroll.Size = UDim2.new(0.98529, 0, 0.98039, 0)
 scroll.Position = UDim2.new(0.5, 0, 0.5, 0)
 scroll.Visible = false
 padding(scroll, 4, 4, 4, 4)

 local layout = Instance.new("UIListLayout", scroll)
 layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
 layout.SortOrder = Enum.SortOrder.LayoutOrder
 layout.Padding = UDim.new(0, 6)

 layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
 scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
 end)

 self2._scroll = scroll
 self2._layout = layout
 self2._elemOrder = 0

 self._tabOrder = self._tabOrder + 1
 local tabFrame = Instance.new("Frame", self._tabScroll)
 tabFrame.Name = "Tab_" .. name
 tabFrame.BorderSizePixel = 0
 tabFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
 tabFrame.Size = UDim2.new(0, 88, 0, 26)
 tabFrame.LayoutOrder = self._tabOrder
 corner(tabFrame, 5)
 padding(tabFrame, 0, 0, 0, 0)

 if icon then
 local img = Instance.new("ImageLabel", tabFrame)
 img.BorderSizePixel = 0
 img.BackgroundTransparency = 1
 img.ScaleType = Enum.ScaleType.Fit
 img.Image = icon
 img.Size = UDim2.new(0.22, 0, 0.8, 0)
 img.Position = UDim2.new(0.04, 0, 0.1, 0)
 end

 local tabLabel = Instance.new("TextLabel", tabFrame)
 tabLabel.Name = "TabName"
 tabLabel.BorderSizePixel = 0
 tabLabel.BackgroundTransparency = 1
 tabLabel.TextScaled = true
 tabLabel.TextWrapped = true
 tabLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
 tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
 tabLabel.AnchorPoint = Vector2.new(0.5, 0.5)
 tabLabel.Size = UDim2.new(0.7, 0, 1, 0)
 tabLabel.Position = UDim2.new(icon and 0.58 or 0.5, 0, 0.5, 0)
 tabLabel.Text = name

 local triggerBtn = Instance.new("TextButton", tabFrame)
 triggerBtn.BorderSizePixel = 0
 triggerBtn.BackgroundTransparency = 1
 triggerBtn.Size = UDim2.new(1, 0, 1, 0)
 triggerBtn.Text = ""
 corner(triggerBtn, 5)

 table.insert(self._tabs, scroll)
 table.insert(self._tabButtons, tabFrame)

 triggerBtn.MouseButton1Click:Connect(function()
 for _, s in ipairs(self._tabs) do s.Visible = false end
 for _, b in ipairs(self._tabButtons) do
 b.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
 end
 scroll.Visible = true
 tabFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
 end)

 if #self._tabs == 1 then
 scroll.Visible = true
 tabFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
 end

 return self2
end

local function elemBase(scroll, order)
 local frame = Instance.new("Frame", scroll)
 frame.BorderSizePixel = 0
 frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 frame.BackgroundTransparency = 0.6
 frame.Size = UDim2.new(0, 270, 0, 32)
 frame.LayoutOrder = order
 corner(frame, 6)
 stroke(frame, Color3.fromRGB(72, 72, 72), 1.8)
 padding(frame, 1, 8, 8, 0)
 return frame
end

function Tab:AddButton(text, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)

 makeLabel(frame, text, {
 size = UDim2.new(0.75, 0, 1, 0),
 pos = UDim2.new(0, 8, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local icon = Instance.new("ImageLabel", frame)
 icon.BorderSizePixel = 0
 icon.BackgroundTransparency = 1
 icon.ZIndex = 9
 icon.AnchorPoint = Vector2.new(1, 0.5)
 icon.Image = "rbxassetid://107092551835785"
 icon.Size = UDim2.new(0, 20, 0, 20)
 icon.Position = UDim2.new(1, 0, 0.5, 0)

 local btn = Instance.new("TextButton", frame)
 btn.BorderSizePixel = 0
 btn.BackgroundTransparency = 1
 btn.ZIndex = 10
 btn.Size = UDim2.new(1, 0, 1, 0)
 btn.Text = ""

 local originalSize = frame.Size
 btn.Activated:Connect(function()
 makeTween(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
 { Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 26) })
 task.wait(0.1)
 makeTween(frame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
 { Size = originalSize })
 if callback then callback() end
 end)

 return frame
end

function Tab:AddToggle(text, default, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)

 makeLabel(frame, text, {
 size = UDim2.new(0.7, 0, 1, 0),
 pos = UDim2.new(0, 8, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local container = Instance.new("Frame", frame)
 container.ZIndex = 9
 container.BorderSizePixel = 0
 container.BackgroundColor3 = default and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(56, 56, 56)
 container.Size = UDim2.new(0, 26, 0, 26)
 container.AnchorPoint = Vector2.new(1, 0.5)
 container.Position = UDim2.new(1, 0, 0.5, 0)
 container.BackgroundTransparency = 0.4
 corner(container, 5)
 stroke(container, Color3.fromRGB(111, 111, 111), 1)

 local checkmark = Instance.new("ImageLabel", container)
 checkmark.ZIndex = 9
 checkmark.BorderSizePixel = 0
 checkmark.BackgroundTransparency = 1
 checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
 checkmark.Image = "rbxassetid://9754130783"
 checkmark.Size = UDim2.new(0.75, 0, 0.75, 0)
 checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
 checkmark.ImageTransparency = default and 0 or 1
 checkmark.Rotation = default and 0 or 90

 local toggleBtn = Instance.new("TextButton", container)
 toggleBtn.BorderSizePixel = 0
 toggleBtn.ZIndex = 3
 toggleBtn.BackgroundTransparency = 1
 toggleBtn.Size = UDim2.new(1, 0, 1, 0)
 toggleBtn.Text = ""

 local state = default or false
 local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

 toggleBtn.MouseButton1Click:Connect(function()
 state = not state
 makeTween(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad),
 { BackgroundColor3 = state and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(56, 56, 56) })
 if state then
 checkmark.Rotation = 90
 checkmark.ImageTransparency = 1
 makeTween(checkmark, tweenInfo, { Rotation = 0, ImageTransparency = 0 })
 else
 makeTween(checkmark, tweenInfo, { Rotation = -90, ImageTransparency = 1 })
 end
 if callback then callback(state) end
 end)

 return {
 Frame = frame,
 SetState = function(newState)
 state = newState
 container.BackgroundColor3 = state and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(56, 56, 56)
 checkmark.ImageTransparency = state and 0 or 1
 checkmark.Rotation = state and 0 or 90
 end,
 GetState = function() return state end,
 }
end

function Tab:AddSlider(text, min, max, default, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)
 min = min or 0
 max = max or 100
 default = default or min

 makeLabel(frame, text, {
 size = UDim2.new(0.3, 0, 1, 0),
 pos = UDim2.new(0, 0, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local valueLabel = Instance.new("TextLabel", frame)
 valueLabel.BorderSizePixel = 0
 valueLabel.BackgroundTransparency = 1
 valueLabel.ZIndex = 5
 valueLabel.TextScaled = true
 valueLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
 valueLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
 valueLabel.AnchorPoint = Vector2.new(1, 0.5)
 valueLabel.Size = UDim2.new(0.12, 0, 0.7, 0)
 valueLabel.Position = UDim2.new(0.43, 0, 0.5, 0)
 valueLabel.Text = tostring(default)

 local track = Instance.new("Frame", frame)
 track.ZIndex = 5
 track.BorderSizePixel = 0
 track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
 track.AnchorPoint = Vector2.new(1, 0.5)
 track.Size = UDim2.new(0.55, 0, 0, 6)
 track.Position = UDim2.new(1, 0, 0.5, 0)
 corner(track, 10)
 stroke(track, Color3.fromRGB(90, 90, 90), 1)

 local fill = Instance.new("Frame", track)
 fill.ZIndex = 6
 fill.BorderSizePixel = 0
 fill.BackgroundColor3 = Color3.fromRGB(100, 160, 255)
 fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
 corner(fill, 10)

 local knob = Instance.new("Frame", track)
 knob.ZIndex = 7
 knob.BorderSizePixel = 0
 knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 knob.AnchorPoint = Vector2.new(0.5, 0.5)
 knob.Size = UDim2.new(0, 14, 0, 14)
 knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
 corner(knob, 10)
 stroke(knob, Color3.fromRGB(90, 90, 90), 1.5)

 local dragging = false

 local function updateSlider(relX)
 relX = math.clamp(relX, 0, 1)
 fill.Size = UDim2.new(relX, 0, 1, 0)
 knob.Position = UDim2.new(relX, 0, 0.5, 0)
 local val = math.floor(min + (max - min) * relX)
 valueLabel.Text = tostring(val)
 if callback then callback(val) end
 end

 track.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = true
 updateSlider((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
 end
 end)

 UserInputService.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 updateSlider((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
 end
 end)

 UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 dragging = false
 end
 end)

 return frame
end

function Tab:AddTextbox(text, placeholder, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)

 makeLabel(frame, text, {
 size = UDim2.new(0.4, 0, 1, 0),
 pos = UDim2.new(0, 0, 0, 0),
 anchor = Vector2.new(0, 0),
 })

 local box = Instance.new("TextBox", frame)
 box.BorderSizePixel = 0
 box.TextScaled = true
 box.TextWrapped = true
 box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
 box.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
 box.TextColor3 = Color3.fromRGB(255, 255, 255)
 box.PlaceholderText = placeholder or "Enter value..."
 box.PlaceholderColor3 = Color3.fromRGB(160, 160, 160)
 box.BackgroundTransparency = 0.4
 box.AnchorPoint = Vector2.new(1, 0.5)
 box.Size = UDim2.new(0.55, 0, 0.75, 0)
 box.Position = UDim2.new(1, 0, 0.5, 0)
 box.Text = ""
 box.ClearTextOnFocus = false
 corner(box, 4)
 stroke(box, Color3.fromRGB(90, 90, 90), 1)

 box.FocusLost:Connect(function(enterPressed)
 if enterPressed and callback then
 callback(box.Text)
 end
 end)

 return frame
end

function Tab:AddDropdown(text, options, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)
 frame.ClipsDescendants = false

 makeLabel(frame, text, {
 size = UDim2.new(0.4, 0, 1, 0),
 pos = UDim2.new(0, 0, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local selected = Instance.new("TextButton", frame)
 selected.ZIndex = 5
 selected.BorderSizePixel = 0
 selected.TextScaled = true
 selected.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
 selected.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
 selected.TextColor3 = Color3.fromRGB(200, 200, 200)
 selected.BackgroundTransparency = 0.4
 selected.AnchorPoint = Vector2.new(1, 0.5)
 selected.Size = UDim2.new(0.55, 0, 0.75, 0)
 selected.Position = UDim2.new(1, 0, 0.5, 0)
 selected.Text = options[1] or "Select..."
 corner(selected, 4)
 stroke(selected, Color3.fromRGB(90, 90, 90), 1)

 local list = Instance.new("Frame", self._window._main)
 list.ZIndex = 200
 list.BorderSizePixel = 0
 list.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
 list.AnchorPoint = Vector2.new(1, 0)
 list.Size = UDim2.new(0, 0, 0, 0)
 list.Visible = false
 list.ClipsDescendants = true
 corner(list, 4)
 stroke(list, Color3.fromRGB(72, 72, 72), 1.5)

 local listLayout = Instance.new("UIListLayout", list)
 listLayout.SortOrder = Enum.SortOrder.LayoutOrder
 listLayout.Padding = UDim.new(0, 2)
 padding(list, 4, 4, 4, 4)

 local open = false
 local itemHeight = 24

 local function setOpen(state)
 open = state
 local selAbs = selected.AbsolutePosition
 local selSize = selected.AbsoluteSize
 local mainAbs = self._window._main.AbsolutePosition
 list.Position = UDim2.new(0, selAbs.X + selSize.X - mainAbs.X,
 0, selAbs.Y + selSize.Y - mainAbs.Y + 4)
 local targetH = state and (#options * itemHeight + (#options - 1) * 2 + 16) or 0
 list.Visible = true
 list.Size = UDim2.new(0, selSize.X, 0, list.Size.Y.Offset)
 makeTween(list, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
 { Size = UDim2.new(0, selSize.X, 0, targetH) })
 if not state then task.delay(0.2, function() list.Visible = false end) end
 end

 selected.Activated:Connect(function() setOpen(not open) end)

 for i, opt in ipairs(options) do
 local btn = Instance.new("TextButton", list)
 btn.ZIndex = 201
 btn.BorderSizePixel = 0
 btn.LayoutOrder = i
 btn.TextScaled = true
 btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
 btn.BackgroundTransparency = 0.3
 btn.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
 btn.TextColor3 = Color3.fromRGB(255, 255, 255)
 btn.Size = UDim2.new(1, 0, 0, itemHeight)
 btn.Text = opt
 corner(btn, 3)

 btn.Activated:Connect(function()
 selected.Text = opt
 setOpen(false)
 if callback then callback(opt) end
 end)
 end

 return frame
end

function Tab:AddMultiDropdown(text, options, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)
 frame.ClipsDescendants = false

 makeLabel(frame, text, {
 size = UDim2.new(0.4, 0, 1, 0),
 pos = UDim2.new(0, 0, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local selected = Instance.new("TextButton", frame)
 selected.ZIndex = 5
 selected.BorderSizePixel = 0
 selected.TextScaled = true
 selected.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
 selected.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
 selected.TextColor3 = Color3.fromRGB(200, 200, 200)
 selected.BackgroundTransparency = 0.4
 selected.AnchorPoint = Vector2.new(1, 0.5)
 selected.Size = UDim2.new(0.55, 0, 0.75, 0)
 selected.Position = UDim2.new(1, 0, 0.5, 0)
 selected.Text = "None"
 corner(selected, 4)
 stroke(selected, Color3.fromRGB(90, 90, 90), 1)

 local list = Instance.new("Frame", self._window._main)
 list.ZIndex = 200
 list.BorderSizePixel = 0
 list.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
 list.AnchorPoint = Vector2.new(1, 0)
 list.Size = UDim2.new(0, 0, 0, 0)
 list.Visible = false
 list.ClipsDescendants = true
 corner(list, 4)
 stroke(list, Color3.fromRGB(72, 72, 72), 1.5)

 local listLayout = Instance.new("UIListLayout", list)
 listLayout.SortOrder = Enum.SortOrder.LayoutOrder
 listLayout.Padding = UDim.new(0, 2)
 padding(list, 4, 4, 4, 4)

 local open = false
 local itemHeight = 24
 local selectedItems = {}

 local function updateLabel()
 selected.Text = #selectedItems == 0 and "None" or table.concat(selectedItems, ", ")
 end

 local function setOpen(state)
 open = state
 local selAbs = selected.AbsolutePosition
 local selSize = selected.AbsoluteSize
 local mainAbs = self._window._main.AbsolutePosition
 list.Position = UDim2.new(0, selAbs.X + selSize.X - mainAbs.X,
 0, selAbs.Y + selSize.Y - mainAbs.Y + 4)
 local targetH = state and (#options * itemHeight + (#options - 1) * 2 + 16) or 0
 list.Visible = true
 list.Size = UDim2.new(0, selSize.X, 0, list.Size.Y.Offset)
 makeTween(list, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
 { Size = UDim2.new(0, selSize.X, 0, targetH) })
 if not state then task.delay(0.2, function() list.Visible = false end) end
 end

 selected.Activated:Connect(function() setOpen(not open) end)

 for i, optionText in ipairs(options) do
 local row = Instance.new("Frame", list)
 row.BorderSizePixel = 0
 row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
 row.BackgroundTransparency = 0.3
 row.Size = UDim2.new(1, 0, 0, itemHeight)
 row.LayoutOrder = i
 row.ZIndex = 201
 corner(row, 3)

 local check = Instance.new("Frame", row)
 check.BorderSizePixel = 0
 check.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
 check.AnchorPoint = Vector2.new(0, 0.5)
 check.Size = UDim2.new(0, 16, 0, 16)
 check.Position = UDim2.new(0, 4, 0.5, 0)
 check.ZIndex = 202
 corner(check, 3)
 stroke(check, Color3.fromRGB(100, 100, 100), 1)

 local checkmark = Instance.new("ImageLabel", check)
 checkmark.BorderSizePixel = 0
 checkmark.BackgroundTransparency = 1
 checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
 checkmark.Image = "rbxassetid://9754130783"
 checkmark.Size = UDim2.new(0.8, 0, 0.8, 0)
 checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
 checkmark.ImageTransparency = 1
 checkmark.ZIndex = 203

 local optLabel = Instance.new("TextLabel", row)
 optLabel.BorderSizePixel = 0
 optLabel.BackgroundTransparency = 1
 optLabel.TextScaled = true
 optLabel.TextXAlignment = Enum.TextXAlignment.Left
 optLabel.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
 optLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
 optLabel.AnchorPoint = Vector2.new(0, 0.5)
 optLabel.Size = UDim2.new(1, -28, 1, 0)
 optLabel.Position = UDim2.new(0, 26, 0.5, 0)
 optLabel.Text = optionText
 optLabel.ZIndex = 202

 local btn = Instance.new("TextButton", row)
 btn.BorderSizePixel = 0
 btn.BackgroundTransparency = 1
 btn.Size = UDim2.new(1, 0, 1, 0)
 btn.Text = ""
 btn.ZIndex = 204

 local checked = false
 btn.Activated:Connect(function()
 checked = not checked
 if checked then
 check.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
 checkmark.ImageTransparency = 0
 table.insert(selectedItems, optionText)
 else
 check.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
 checkmark.ImageTransparency = 1
 for j, v in ipairs(selectedItems) do
 if v == optionText then table.remove(selectedItems, j) break end
 end
 end
 updateLabel()
 if callback then callback(selectedItems) end
 end)
 end

 return frame
end

function Tab:AddColorPicker(text, default, callback)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)
 frame.ClipsDescendants = false

 makeLabel(frame, text, {
 size = UDim2.new(0.4, 0, 1, 0),
 pos = UDim2.new(0, 0, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local defaultColor = default or Color3.fromRGB(255, 80, 80)
 local h, s, v = Color3.toHSV(defaultColor)

 local preview = Instance.new("TextButton", frame)
 preview.ZIndex = 5
 preview.BorderSizePixel = 0
 preview.BackgroundColor3 = defaultColor
 preview.AnchorPoint = Vector2.new(1, 0.5)
 preview.Size = UDim2.new(0.55, 0, 0.75, 0)
 preview.Position = UDim2.new(1, 0, 0.5, 0)
 preview.Text = ""
 corner(preview, 4)
 stroke(preview, Color3.fromRGB(90, 90, 90), 1)

 local panel = Instance.new("Frame", frame)
 panel.ZIndex = 50
 panel.BorderSizePixel = 0
 panel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
 panel.AnchorPoint = Vector2.new(1, 0)
 panel.Size = UDim2.new(0.55, 0, 0, 130)
 panel.Position = UDim2.new(1, 0, 1, 4)
 panel.Visible = false
 corner(panel, 4)
 stroke(panel, Color3.fromRGB(72, 72, 72), 1.5)

 local hueBG = Instance.new("Frame", panel)
 hueBG.ZIndex = 51
 hueBG.BorderSizePixel = 0
 hueBG.Size = UDim2.new(0.85, 0, 0, 12)
 hueBG.AnchorPoint = Vector2.new(0.5, 0)
 hueBG.Position = UDim2.new(0.5, 0, 0, 8)
 corner(hueBG, 6)
 local hueGrad = Instance.new("UIGradient", hueBG)
 hueGrad.Color = ColorSequence.new({
 ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
 ColorSequenceKeypoint.new(0.166667, Color3.fromRGB(255, 0, 255)),
 ColorSequenceKeypoint.new(0.333333, Color3.fromRGB(0, 0, 255)),
 ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 225)),
 ColorSequenceKeypoint.new(0.666667, Color3.fromRGB(0, 255, 0)),
 ColorSequenceKeypoint.new(0.833333, Color3.fromRGB(255, 255, 0)),
 ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
 })

 local hueKnob = Instance.new("Frame", hueBG)
 hueKnob.ZIndex = 52
 hueKnob.BorderSizePixel = 0
 hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
 hueKnob.Size = UDim2.new(0, 14, 0, 14)
 hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
 corner(hueKnob, 10)
 stroke(hueKnob, Color3.fromRGB(0, 0, 0), 1.5)

 local svBox = Instance.new("Frame", panel)
 svBox.ZIndex = 51
 svBox.BorderSizePixel = 0
 svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
 svBox.Size = UDim2.new(0.85, 0, 0, 80)
 svBox.AnchorPoint = Vector2.new(0.5, 0)
 svBox.Position = UDim2.new(0.5, 0, 0, 28)
 corner(svBox, 4)

 local whiteGrad = Instance.new("Frame", svBox)
 whiteGrad.BorderSizePixel = 0
 whiteGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 whiteGrad.Size = UDim2.new(1, 0, 1, 0)
 whiteGrad.ZIndex = 51
 corner(whiteGrad, 4)
 local wg = Instance.new("UIGradient", whiteGrad)
 wg.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
 wg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })

 local blackGrad = Instance.new("Frame", svBox)
 blackGrad.BorderSizePixel = 0
 blackGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
 blackGrad.Size = UDim2.new(1, 0, 1, 0)
 blackGrad.ZIndex = 51
 corner(blackGrad, 4)
 local bg = Instance.new("UIGradient", blackGrad)
 bg.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
 bg.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0) })
 bg.Rotation = 90

 local svKnob = Instance.new("Frame", svBox)
 svKnob.ZIndex = 52
 svKnob.BorderSizePixel = 0
 svKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
 svKnob.AnchorPoint = Vector2.new(0.5, 0.5)
 svKnob.Size = UDim2.new(0, 12, 0, 12)
 svKnob.Position = UDim2.new(s, 0, 1 - v, 0)
 corner(svKnob, 10)
 stroke(svKnob, Color3.fromRGB(0, 0, 0), 1.5)

 local function updateColor()
 local color = Color3.fromHSV(h, s, v)
 preview.BackgroundColor3 = color
 svBox.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
 if callback then callback(color) end
 end

 preview.Activated:Connect(function()
 panel.Visible = not panel.Visible
 end)

 local draggingHue, draggingSV = false, false

 hueBG.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 draggingHue = true
 end
 end)

 svBox.InputBegan:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 draggingSV = true
 end
 end)

 UserInputService.InputChanged:Connect(function(input)
 if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 h = math.clamp((input.Position.X - hueBG.AbsolutePosition.X) / hueBG.AbsoluteSize.X, 0, 1)
 hueKnob.Position = UDim2.new(h, 0, 0.5, 0)
 updateColor()
 end
 if draggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
 s = math.clamp((input.Position.X - svBox.AbsolutePosition.X) / svBox.AbsoluteSize.X, 0, 1)
 v = 1 - math.clamp((input.Position.Y - svBox.AbsolutePosition.Y) / svBox.AbsoluteSize.Y, 0, 1)
 svKnob.Position = UDim2.new(s, 0, 1 - v, 0)
 updateColor()
 end
 end)

 UserInputService.InputEnded:Connect(function(input)
 if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
 draggingHue = false
 draggingSV = false
 end
 end)

 updateColor()
 return frame
end

function Tab:AddSection(text)
 self._elemOrder = self._elemOrder + 1
 local frame = Instance.new("Frame", self._scroll)
 frame.BorderSizePixel = 0
 frame.BackgroundTransparency = 1
 frame.Size = UDim2.new(0, 270, 0, 20)
 frame.LayoutOrder = self._elemOrder

 local line = Instance.new("Frame", frame)
 line.ZIndex = 3
 line.BorderSizePixel = 0
 line.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
 line.AnchorPoint = Vector2.new(0, 0.5)
 line.Size = UDim2.new(1, 0, 0, 1)
 line.Position = UDim2.new(0, 0, 0.5, 0)
 corner(line, 10)

 local label = Instance.new("TextLabel", frame)
 label.ZIndex = 4
 label.BorderSizePixel = 0
 label.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
 label.BackgroundTransparency = 0
 label.TextScaled = true
 label.TextWrapped = true
 label.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
 label.TextColor3 = Color3.fromRGB(160, 160, 160)
 label.AnchorPoint = Vector2.new(0.5, 0.5)
 label.Size = UDim2.new(0, 80, 1, 0)
 label.Position = UDim2.new(0.5, 0, 0.5, 0)
 label.Text = text
 padding(label, 0, 6, 6, 0)

 return frame
end

function Tab:AddLabel(text, value)
 self._elemOrder = self._elemOrder + 1
 local frame = elemBase(self._scroll, self._elemOrder)

 makeLabel(frame, text, {
 size = UDim2.new(0.4, 0, 1, 0),
 pos = UDim2.new(0, 0, 0.5, 0),
 anchor = Vector2.new(0, 0.5),
 })

 local valueLabel = makeLabel(frame, value or "", {
 font = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
 color = Color3.fromRGB(160, 160, 160),
 xAlign = Enum.TextXAlignment.Right,
 size = UDim2.new(0.55, 0, 1, 0),
 pos = UDim2.new(1, 0, 0.5, 0),
 anchor = Vector2.new(1, 0.5),
 })

 return {
 Frame = frame,
 SetValue = function(v) valueLabel.Text = tostring(v) end,
 }
end

return Jawere
