local Jawere = {}
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local boldFont = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local regFont = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local function makeRow(parent, order)
	local f = Instance.new("Frame", parent)
	f.BorderSizePixel = 0
	f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	f.Size = UDim2.new(0, 270, 0, 32)
	f.BackgroundTransparency = 0.6
	f.LayoutOrder = order
	local c = Instance.new("UICorner", f)
	local s = Instance.new("UIStroke", f)
	s.Thickness = 1.8
	s.Color = Color3.fromRGB(72, 72, 72)
	local p = Instance.new("UIPadding", f)
	p.PaddingTop = UDim.new(0, 1)
	p.PaddingLeft = UDim.new(0, 8)
	p.PaddingRight = UDim.new(0, 8)
	return f
end

local function makeLabel(parent, text, xAlign, size, pos)
	local l = Instance.new("TextLabel", parent)
	l.BorderSizePixel = 0
	l.TextWrapped = true
	l.TextScaled = true
	l.BackgroundTransparency = 1
	l.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	l.FontFace = boldFont
	l.TextColor3 = Color3.fromRGB(255, 255, 255)
	l.TextXAlignment = xAlign or Enum.TextXAlignment.Left
	l.Size = size
	l.Position = pos
	l.AnchorPoint = Vector2.new(0, 0.5)
	l.Text = text
	return l
end

local function makeDropdownList(main)
	local list = Instance.new("Frame", main)
	list.BorderSizePixel = 0
	list.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	list.AnchorPoint = Vector2.new(1, 0)
	list.Size = UDim2.new(0, 0, 0, 0)
	list.Position = UDim2.new(0, 0, 0, 0)
	list.ZIndex = 200
	list.Visible = false
	list.ClipsDescendants = true
	local c = Instance.new("UICorner", list)
	c.CornerRadius = UDim.new(0, 4)
	local s = Instance.new("UIStroke", list)
	s.Color = Color3.fromRGB(72, 72, 72)
	s.Thickness = 1.5
	local ll = Instance.new("UIListLayout", list)
	ll.SortOrder = Enum.SortOrder.LayoutOrder
	ll.Padding = UDim.new(0, 2)
	local pad = Instance.new("UIPadding", list)
	pad.PaddingTop = UDim.new(0, 4)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.PaddingLeft = UDim.new(0, 4)
	pad.PaddingRight = UDim.new(0, 4)
	return list
end

local function wireDropdown(selected, list, main, scrollFrame, options, callback, multi, win)
	local open = false
	local itemHeight = 24
	local padding = 8
	local itemCount = #options
	local selectedItems = {}

	local function updateListPosition()
		local selAbs = selected.AbsolutePosition
		local selSize = selected.AbsoluteSize
		local mainAbs = main.AbsolutePosition
		list.Position = UDim2.new(0, selAbs.X + selSize.X - mainAbs.X, 0, selAbs.Y + selSize.Y - mainAbs.Y + 4)
		list.Size = UDim2.new(0, selSize.X, 0, list.Size.Y.Offset)
	end

	local function setOpen(state)
		open = state
		if state then
			win:_registerPopup(function()
				open = false
				list.Visible = true
				ts:Create(list, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, selected.AbsoluteSize.X, 0, 0)
				}):Play()
				task.delay(0.2, function() list.Visible = false end)
			end)
		end
		updateListPosition()
		list.Visible = true
		local targetH = state and (itemCount * itemHeight + (itemCount - 1) * 2 + padding * 2) or 0
		ts:Create(list, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, selected.AbsoluteSize.X, 0, targetH)
		}):Play()
		if not state then task.delay(0.2, function() list.Visible = false end) end
	end

	selected.Activated:Connect(function()
		if open then
			win:_closePopup()
		else
			setOpen(true)
		end
	end)
	scrollFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if open then win:_closePopup() end
	end)

	for i, optText in ipairs(options) do
		if multi then
			local row = Instance.new("Frame", list)
			row.BorderSizePixel = 0
			row.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			row.BackgroundTransparency = 0.3
			row.Size = UDim2.new(1, 0, 0, itemHeight)
			row.ZIndex = 201
			row.LayoutOrder = i
			local rc = Instance.new("UICorner", row)
			rc.CornerRadius = UDim.new(0, 3)

			local check = Instance.new("Frame", row)
			check.BorderSizePixel = 0
			check.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
			check.AnchorPoint = Vector2.new(0, 0.5)
			check.Size = UDim2.new(0, 16, 0, 16)
			check.Position = UDim2.new(0, 4, 0.5, 0)
			check.ZIndex = 202
			local cc = Instance.new("UICorner", check)
			cc.CornerRadius = UDim.new(0, 3)
			local cs = Instance.new("UIStroke", check)
			cs.Color = Color3.fromRGB(100, 100, 100)
			cs.Thickness = 1

			local checkmark = Instance.new("ImageLabel", check)
			checkmark.BorderSizePixel = 0
			checkmark.BackgroundTransparency = 1
			checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
			checkmark.Size = UDim2.new(0.8, 0, 0.8, 0)
			checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)
			checkmark.Image = "rbxassetid://9754130783"
			checkmark.ImageTransparency = 1
			checkmark.ZIndex = 203

			local lbl = Instance.new("TextLabel", row)
			lbl.BorderSizePixel = 0
			lbl.BackgroundTransparency = 1
			lbl.TextScaled = true
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.FontFace = regFont
			lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
			lbl.AnchorPoint = Vector2.new(0, 0.5)
			lbl.Size = UDim2.new(1, -28, 1, 0)
			lbl.Position = UDim2.new(0, 26, 0.5, 0)
			lbl.Text = optText
			lbl.ZIndex = 202

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
					table.insert(selectedItems, optText)
				else
					check.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
					checkmark.ImageTransparency = 1
					for j, v in ipairs(selectedItems) do
						if v == optText then table.remove(selectedItems, j) break end
					end
				end
				selected.Text = #selectedItems == 0 and "None" or table.concat(selectedItems, ", ")
				if callback then callback(selectedItems) end
			end)
		else
			local optBtn = Instance.new("TextButton", list)
			optBtn.BorderSizePixel = 0
			optBtn.TextScaled = true
			optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			optBtn.BackgroundTransparency = 0.3
			optBtn.FontFace = regFont
			optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			optBtn.Size = UDim2.new(1, 0, 0, itemHeight)
			optBtn.Text = optText
			optBtn.ZIndex = 201
			optBtn.LayoutOrder = i
			local oc = Instance.new("UICorner", optBtn)
			oc.CornerRadius = UDim.new(0, 3)
			optBtn.Activated:Connect(function()
				selected.Text = optText
				setOpen(false)
				if callback then callback(optText) end
			end)
		end
	end
end

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

function Jawere.new(cfg)
	local self = setmetatable({}, Window)
	cfg = cfg or {}
	local name = cfg.Name or "Jawere"
	local w = cfg.Width or 700
	local h = cfg.Height or 400

	local gui = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"))
	gui.IgnoreGuiInset = true
	gui.ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets
	gui.Name = "Jawere"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.ZIndex = 99
	main.BorderSizePixel = 0
	main.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Size = UDim2.new(0, w, 0, h)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.Name = "Main"
	local mainCorner = Instance.new("UICorner", main)
	local mainStroke = Instance.new("UIStroke", main)

	local sidebar = Instance.new("Frame", main)
	sidebar.ZIndex = 3
	sidebar.BorderSizePixel = 0
	sidebar.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	sidebar.ClipsDescendants = true
	sidebar.Size = UDim2.new(0, 110, 1, -44)
	sidebar.Position = UDim2.new(0, 4, 0, 40)
	sidebar.Name = "SideBar"
	local sideCorner = Instance.new("UICorner", sidebar)

	local tabHolder = Instance.new("ScrollingFrame", sidebar)
	tabHolder.ScrollingDirection = Enum.ScrollingDirection.Y
	tabHolder.ZIndex = 3
	tabHolder.BorderSizePixel = 0
	tabHolder.ElasticBehavior = Enum.ElasticBehavior.Always
	tabHolder.BackgroundTransparency = 1
	tabHolder.ScrollBarImageTransparency = 1
	tabHolder.ClipsDescendants = false
	tabHolder.Size = UDim2.new(1, 0, 1, 0)
	tabHolder.Name = "TabHolderList"
	local thPad = Instance.new("UIPadding", tabHolder)
	thPad.PaddingTop = UDim.new(0, 4)
	thPad.PaddingLeft = UDim.new(0, 4)
	thPad.PaddingRight = UDim.new(0, 4)
	local thList = Instance.new("UIListLayout", tabHolder)
	thList.SortOrder = Enum.SortOrder.LayoutOrder
	thList.Padding = UDim.new(0, 4)
	thList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabHolder.CanvasSize = UDim2.new(0, 0, 0, thList.AbsoluteContentSize.Y + 8)
	end)

	local topbar = Instance.new("Frame", main)
	topbar.ZIndex = 999
	topbar.BorderSizePixel = 0
	topbar.BackgroundColor3 = Color3.fromRGB(76, 76, 76)
	topbar.Size = UDim2.new(1, 0, 0, 36)
	topbar.Name = "TopBar"
	local tbCorner = Instance.new("UICorner", topbar)
	tbCorner.CornerRadius = UDim.new(0, 5)

	local tbLine = Instance.new("Frame", topbar)
	tbLine.ZIndex = 99
	tbLine.BorderSizePixel = 0
	tbLine.BackgroundColor3 = Color3.fromRGB(97, 97, 97)
	tbLine.Size = UDim2.new(1, 0, 0, 2)
	tbLine.Position = UDim2.new(0, 0, 1, -2)
	local tbLineCorner = Instance.new("UICorner", tbLine)
	tbLineCorner.CornerRadius = UDim.new(0, 5)

	local titleLabel = Instance.new("TextLabel", topbar)
	titleLabel.TextWrapped = true
	titleLabel.BorderSizePixel = 0
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextScaled = true
	titleLabel.BackgroundTransparency = 1
	titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.FontFace = boldFont
	titleLabel.TextColor3 = Color3.fromRGB(225, 226, 255)
	titleLabel.Size = UDim2.new(0, 120, 0, 28)
	titleLabel.Position = UDim2.new(0, 10, 0, 4)
	titleLabel.Text = name
	titleLabel.Name = "Title"
	local titleStroke = Instance.new("UIStroke", titleLabel)

	local closeBtn = Instance.new("ImageButton", topbar)
	closeBtn.BorderSizePixel = 0
	closeBtn.BackgroundTransparency = 1
	closeBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Image = "rbxassetid://18503481771"
	closeBtn.Size = UDim2.new(0, 24, 0, 24)
	closeBtn.Position = UDim2.new(1, -30, 0, 6)
	closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)

	local elemHolder = Instance.new("Frame", main)
	elemHolder.BorderSizePixel = 0
	elemHolder.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	elemHolder.ClipsDescendants = true
	elemHolder.Size = UDim2.new(1, -122, 1, -44)
	elemHolder.Position = UDim2.new(0, 118, 0, 40)
	elemHolder.Name = "ElementsHolder"
	local ehCorner = Instance.new("UICorner", elemHolder)
	ehCorner.CornerRadius = UDim.new(0, 4)

	local dragging, dragStart, startPos = false, nil, nil
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	self._gui = gui
	self._main = main
	self._sidebar = sidebar
	self._tabHolder = tabHolder
	self._elemHolder = elemHolder
	self._tabs = {}
	self._tabOrder = 0
	self._activeTab = nil
	return self
end

function Window:SetTitle(text)
	self._main.TopBar.Title.Text = text
end

function Window:SetVisible(v)
	self._main.Visible = v
end

function Window:Destroy()
	self._gui:Destroy()
end

function Window:AddTab(name, icon)
	self._tabOrder += 1
	local order = self._tabOrder

	local tabFrame = Instance.new("Frame", self._tabHolder)
	tabFrame.BorderSizePixel = 0
	tabFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	tabFrame.Size = UDim2.new(1, 0, 0, 28)
	tabFrame.Name = "Tab_" .. name
	tabFrame.LayoutOrder = order
	local tfc = Instance.new("UICorner", tabFrame)

	if icon and icon ~= "" then
		local img = Instance.new("ImageLabel", tabFrame)
		img.BorderSizePixel = 0
		img.ScaleType = Enum.ScaleType.Crop
		img.BackgroundTransparency = 1
		img.Image = icon
		img.Size = UDim2.new(0, 18, 0, 18)
		img.Position = UDim2.new(0, 4, 0.5, -9)
		img.Name = "ImageIcon"
	end

	local tabName = Instance.new("TextLabel", tabFrame)
	tabName.TextWrapped = true
	tabName.BorderSizePixel = 0
	tabName.TextScaled = true
	tabName.BackgroundTransparency = 1
	tabName.FontFace = boldFont
	tabName.TextColor3 = Color3.fromRGB(180, 180, 180)
	tabName.AnchorPoint = Vector2.new(0.5, 0.5)
	tabName.Size = UDim2.new(1, -8, 1, 0)
	tabName.Position = UDim2.new(0.5, 0, 0.5, 0)
	tabName.Text = name
	tabName.Name = "TabName"

	local trigBtn = Instance.new("TextButton", tabFrame)
	trigBtn.BorderSizePixel = 0
	trigBtn.BackgroundTransparency = 1
	trigBtn.Size = UDim2.new(1, 0, 1, 0)
	trigBtn.Text = ""
	trigBtn.Name = "TriggerButton"
	local trigCorner = Instance.new("UICorner", trigBtn)

	local scrollFrame = Instance.new("ScrollingFrame", self._elemHolder)
	scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.ScrollBarImageTransparency = 1
	scrollFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	scrollFrame.Visible = false
	scrollFrame.Name = "Tab_Content_" .. name

	local pad = Instance.new("UIPadding", scrollFrame)
	pad.PaddingTop = UDim.new(0, 6)
	pad.PaddingLeft = UDim.new(0, 0)

	local listLayout = Instance.new("UIListLayout", scrollFrame)
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Padding = UDim.new(0, 8)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
	end)

	local tab = setmetatable({
		_frame = tabFrame,
		_scroll = scrollFrame,
		_tabName = tabName,
		_trigBtn = trigBtn,
		_main = self._main,
		_elemHolder = self._elemHolder,
		_window = self,
		_order = 0,
		_closers = {},
	}, Tab)

	table.insert(self._tabs, tab)

	trigBtn.MouseButton1Click:Connect(function()
		self:_selectTab(tab)
	end)

	if #self._tabs == 1 then
		self:_selectTab(tab)
	end

	return tab
end

function Window:_selectTab(tab)
	for _, t in ipairs(self._tabs) do
		t._frame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
		t._tabName.TextColor3 = Color3.fromRGB(180, 180, 180)
		t._scroll.Visible = false
	end
	tab._frame.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	tab._tabName.TextColor3 = Color3.fromRGB(255, 255, 255)
	tab._scroll.Visible = true
	self._activeTab = tab
	self:_closePopup()
end

function Window:_registerPopup(closeFn)
	self:_closePopup()
	self._activePopup = closeFn
end

function Window:_closePopup()
	if self._activePopup then
		self._activePopup()
		self._activePopup = nil
	end
end

function Tab:AddButton(name, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)

	local lbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 8, 0.5, 0))

	local clickIcon = Instance.new("Frame", row)
	clickIcon.ZIndex = 9
	clickIcon.BorderSizePixel = 0
	clickIcon.BackgroundTransparency = 1
	clickIcon.Size = UDim2.new(0, 26, 0, 26)
	clickIcon.AnchorPoint = Vector2.new(1, 0.5)
	clickIcon.Position = UDim2.new(1, 0, 0.5, 0)
	local cic = Instance.new("UICorner", clickIcon)
	cic.CornerRadius = UDim.new(0, 5)
	local img = Instance.new("ImageLabel", clickIcon)
	img.ZIndex = 9
	img.BorderSizePixel = 0
	img.AnchorPoint = Vector2.new(0.5, 0.5)
	img.Image = "rbxassetid://107092551835785"
	img.Size = UDim2.new(0.75, 0, 0.75, 0)
	img.BackgroundTransparency = 1
	img.Position = UDim2.new(0.5, 0, 0.5, 0)

	local btn = Instance.new("TextButton", row)
	btn.BorderSizePixel = 0
	btn.ZIndex = 10
	btn.BackgroundTransparency = 1
	btn.Size = UDim2.new(1, 0, 1, 0)
	btn.Text = ""

	local origSize = row.Size
	btn.Activated:Connect(function()
		ts:Create(row, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 270, 0, 26)
		}):Play()
		task.wait(0.1)
		ts:Create(row, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = origSize
		}):Play()
		if callback then callback() end
	end)
end

function Tab:AddToggle(name, default, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)

	local lbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.7, 0, 1, 0), UDim2.new(0, 8, 0.5, 0))

	local container = Instance.new("Frame", row)
	container.ZIndex = 9
	container.BorderSizePixel = 0
	container.BackgroundColor3 = Color3.fromRGB(56, 56, 56)
	container.BackgroundTransparency = 0.6
	container.Size = UDim2.new(0, 26, 0, 26)
	container.AnchorPoint = Vector2.new(1, 0.5)
	container.Position = UDim2.new(1, 0, 0.5, 0)
	local cc = Instance.new("UICorner", container)
	cc.CornerRadius = UDim.new(0, 5)
	local cs = Instance.new("UIStroke", container)
	cs.Color = Color3.fromRGB(111, 111, 111)

	local checkmark = Instance.new("ImageLabel", container)
	checkmark.ZIndex = 9
	checkmark.BorderSizePixel = 0
	checkmark.AnchorPoint = Vector2.new(0.5, 0.5)
	checkmark.Image = "rbxassetid://9754130783"
	checkmark.Size = UDim2.new(0.75, 0, 0.75, 0)
	checkmark.BackgroundTransparency = 1
	checkmark.Position = UDim2.new(0.5, 0, 0.5, 0)

	local toggleBtn = Instance.new("TextButton", container)
	toggleBtn.BorderSizePixel = 0
	toggleBtn.ZIndex = 3
	toggleBtn.BackgroundTransparency = 1
	toggleBtn.Size = UDim2.new(1, 0, 1, 0)
	toggleBtn.Text = ""

	local state = default or false
	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function applyState(s, animate)
		state = s
		if animate then
			ts:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				BackgroundColor3 = s and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(56, 56, 56)
			}):Play()
			if s then
				checkmark.Rotation = 90
				checkmark.ImageTransparency = 1
				ts:Create(checkmark, tweenInfo, { Rotation = 0, ImageTransparency = 0 }):Play()
			else
				ts:Create(checkmark, tweenInfo, { Rotation = -90, ImageTransparency = 1 }):Play()
			end
		else
			container.BackgroundColor3 = s and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(56, 56, 56)
			checkmark.ImageTransparency = s and 0 or 1
			checkmark.Rotation = s and 0 or 90
		end
	end

	applyState(state, false)

	toggleBtn.MouseButton1Click:Connect(function()
		applyState(not state, true)
		if callback then callback(state) end
	end)

	local api = {}
	function api:SetState(s)
		applyState(s, true)
		if callback then callback(state) end
	end
	function api:GetState() return state end
	return api
end

function Tab:AddTextbox(name, placeholder, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)

	local lbl = Instance.new("TextLabel", row)
	lbl.TextWrapped = true
	lbl.BorderSizePixel = 0
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextScaled = true
	lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	lbl.FontFace = boldFont
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(0.4, 0, 1, 0)
	lbl.Position = UDim2.new(0, 0, 0, 0)
	lbl.Text = name

	local inputBox = Instance.new("TextBox", row)
	inputBox.BorderSizePixel = 0
	inputBox.TextWrapped = true
	inputBox.TextScaled = true
	inputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	inputBox.FontFace = regFont
	inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	inputBox.PlaceholderText = placeholder or "Enter value..."
	inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	inputBox.BackgroundTransparency = 0.4
	inputBox.AnchorPoint = Vector2.new(1, 0.5)
	inputBox.Size = UDim2.new(0.55, 0, 0.75, 0)
	inputBox.Position = UDim2.new(1, 0, 0.5, 0)
	inputBox.Text = ""
	inputBox.ClearTextOnFocus = false
	local ic = Instance.new("UICorner", inputBox)
	ic.CornerRadius = UDim.new(0, 4)
	local is = Instance.new("UIStroke", inputBox)
	is.Color = Color3.fromRGB(90, 90, 90)
	is.Thickness = 1

	inputBox.FocusLost:Connect(function(enter)
		if enter and callback then callback(inputBox.Text) end
	end)
end

function Tab:AddDropdown(name, options, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)
	row.ClipsDescendants = false

	local lbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 0, 0.5, 0))

	local selected = Instance.new("TextButton", row)
	selected.BorderSizePixel = 0
	selected.TextScaled = true
	selected.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	selected.FontFace = regFont
	selected.TextColor3 = Color3.fromRGB(200, 200, 200)
	selected.BackgroundTransparency = 0.4
	selected.AnchorPoint = Vector2.new(1, 0.5)
	selected.Size = UDim2.new(0.55, 0, 0.75, 0)
	selected.Position = UDim2.new(1, 0, 0.5, 0)
	selected.Text = options[1] or "Select"
	selected.ZIndex = 5
	local sc = Instance.new("UICorner", selected)
	sc.CornerRadius = UDim.new(0, 4)
	local ss = Instance.new("UIStroke", selected)
	ss.Color = Color3.fromRGB(90, 90, 90)
	ss.Thickness = 1

	local list = makeDropdownList(self._main)
	wireDropdown(selected, list, self._main, self._scroll, options, callback, false, self._window)
end

function Tab:AddMultiDropdown(name, options, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)
	row.ClipsDescendants = false

	local lbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 0, 0.5, 0))

	local selected = Instance.new("TextButton", row)
	selected.BorderSizePixel = 0
	selected.TextScaled = true
	selected.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	selected.FontFace = regFont
	selected.TextColor3 = Color3.fromRGB(200, 200, 200)
	selected.BackgroundTransparency = 0.4
	selected.AnchorPoint = Vector2.new(1, 0.5)
	selected.Size = UDim2.new(0.55, 0, 0.75, 0)
	selected.Position = UDim2.new(1, 0, 0.5, 0)
	selected.Text = "None"
	selected.ZIndex = 5
	local sc = Instance.new("UICorner", selected)
	sc.CornerRadius = UDim.new(0, 4)
	local ss = Instance.new("UIStroke", selected)
	ss.Color = Color3.fromRGB(90, 90, 90)
	ss.Thickness = 1

	local list = makeDropdownList(self._main)
	wireDropdown(selected, list, self._main, self._scroll, options, callback, true, self._window)
end

function Tab:AddSlider(name, min, max, default, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)

	local lbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.3, 0, 1, 0), UDim2.new(0, 0, 0.5, 0))

	local valLabel = Instance.new("TextLabel", row)
	valLabel.TextWrapped = true
	valLabel.BorderSizePixel = 0
	valLabel.TextScaled = true
	valLabel.BackgroundTransparency = 1
	valLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	valLabel.FontFace = regFont
	valLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	valLabel.AnchorPoint = Vector2.new(1, 0.5)
	valLabel.Size = UDim2.new(0.12, 0, 0.7, 0)
	valLabel.Position = UDim2.new(0.43, 0, 0.5, 0)
	valLabel.ZIndex = 5
	valLabel.Text = tostring(default or min)

	local track = Instance.new("Frame", row)
	track.BorderSizePixel = 0
	track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Size = UDim2.new(0.55, 0, 0, 6)
	track.Position = UDim2.new(1, 0, 0.5, 0)
	track.ZIndex = 5
	local trc = Instance.new("UICorner", track)
	trc.CornerRadius = UDim.new(1, 0)
	local trs = Instance.new("UIStroke", track)
	trs.Color = Color3.fromRGB(90, 90, 90)
	trs.Thickness = 1

	local fill = Instance.new("Frame", track)
	fill.BorderSizePixel = 0
	fill.BackgroundColor3 = Color3.fromRGB(100, 160, 255)
	fill.ZIndex = 6
	local fc = Instance.new("UICorner", fill)
	fc.CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", track)
	knob.BorderSizePixel = 0
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.ZIndex = 7
	local kc = Instance.new("UICorner", knob)
	kc.CornerRadius = UDim.new(1, 0)
	local ks = Instance.new("UIStroke", knob)
	ks.Color = Color3.fromRGB(90, 90, 90)
	ks.Thickness = 1.5

	local initRel = ((default or min) - min) / (max - min)
	fill.Size = UDim2.new(initRel, 0, 1, 0)
	knob.Position = UDim2.new(initRel, 0, 0.5, 0)

	local dragging = false
	local function updateSlider(relX)
		relX = math.clamp(relX, 0, 1)
		fill.Size = UDim2.new(relX, 0, 1, 0)
		knob.Position = UDim2.new(relX, 0, 0.5, 0)
		local val = math.floor(min + (max - min) * relX)
		valLabel.Text = tostring(val)
		if callback then callback(val) end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateSlider((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
		end
	end)
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X)
		end
	end)
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

function Tab:AddColorPicker(name, default, callback)
	self._order += 1
	local row = makeRow(self._scroll, self._order)
	row.ClipsDescendants = false

	local lbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 0, 0.5, 0))

	local preview = Instance.new("TextButton", row)
	preview.BorderSizePixel = 0
	preview.BackgroundColor3 = default or Color3.fromRGB(255, 80, 80)
	preview.AnchorPoint = Vector2.new(1, 0.5)
	preview.Size = UDim2.new(0.55, 0, 0.75, 0)
	preview.Position = UDim2.new(1, 0, 0.5, 0)
	preview.Text = ""
	preview.ZIndex = 5
	local pvc = Instance.new("UICorner", preview)
	pvc.CornerRadius = UDim.new(0, 4)
	local pvs = Instance.new("UIStroke", preview)
	pvs.Color = Color3.fromRGB(90, 90, 90)
	pvs.Thickness = 1

	local panel = Instance.new("Frame", self._main)
	panel.BorderSizePixel = 0
	panel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	panel.AnchorPoint = Vector2.new(1, 0)
	panel.Size = UDim2.new(0, 0, 0, 130)
	panel.Position = UDim2.new(0, 0, 0, 0)
	panel.ZIndex = 200
	panel.Visible = false
	local panC = Instance.new("UICorner", panel)
	panC.CornerRadius = UDim.new(0, 4)
	local panS = Instance.new("UIStroke", panel)
	panS.Color = Color3.fromRGB(72, 72, 72)
	panS.Thickness = 1.5

	local hueBG = Instance.new("Frame", panel)
	hueBG.BorderSizePixel = 0
	hueBG.Size = UDim2.new(0.85, 0, 0, 12)
	hueBG.AnchorPoint = Vector2.new(0.5, 0)
	hueBG.Position = UDim2.new(0.5, 0, 0, 8)
	hueBG.ZIndex = 51
	local hueBGC = Instance.new("UICorner", hueBG)
	hueBGC.CornerRadius = UDim.new(0, 6)
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
	hueKnob.BorderSizePixel = 0
	hueKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	hueKnob.Size = UDim2.new(0, 14, 0, 14)
	hueKnob.Position = UDim2.new(0, 0, 0.5, 0)
	hueKnob.ZIndex = 52
	local hkc = Instance.new("UICorner", hueKnob)
	hkc.CornerRadius = UDim.new(1, 0)
	local hks = Instance.new("UIStroke", hueKnob)
	hks.Color = Color3.fromRGB(0, 0, 0)
	hks.Thickness = 1.5

	local satValBox = Instance.new("Frame", panel)
	satValBox.BorderSizePixel = 0
	satValBox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	satValBox.Size = UDim2.new(0.85, 0, 0, 80)
	satValBox.AnchorPoint = Vector2.new(0.5, 0)
	satValBox.Position = UDim2.new(0.5, 0, 0, 28)
	satValBox.ZIndex = 51
	local svc = Instance.new("UICorner", satValBox)
	svc.CornerRadius = UDim.new(0, 4)

	local wGrad = Instance.new("Frame", satValBox)
	wGrad.BorderSizePixel = 0
	wGrad.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	wGrad.Size = UDim2.new(1, 0, 1, 0)
	wGrad.ZIndex = 51
	local wGradUI = Instance.new("UIGradient", wGrad)
	wGradUI.Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,255,255))
	wGradUI.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)})
	local wc = Instance.new("UICorner", wGrad)
	wc.CornerRadius = UDim.new(0, 4)

	local bGrad = Instance.new("Frame", satValBox)
	bGrad.BorderSizePixel = 0
	bGrad.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	bGrad.Size = UDim2.new(1, 0, 1, 0)
	bGrad.ZIndex = 51
	local bGradUI = Instance.new("UIGradient", bGrad)
	bGradUI.Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0))
	bGradUI.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
	bGradUI.Rotation = 90
	local bc = Instance.new("UICorner", bGrad)
	bc.CornerRadius = UDim.new(0, 4)

	local svKnob = Instance.new("Frame", satValBox)
	svKnob.BorderSizePixel = 0
	svKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	svKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	svKnob.Size = UDim2.new(0, 12, 0, 12)
	svKnob.Position = UDim2.new(1, 0, 0, 0)
	svKnob.ZIndex = 52
	local svkc = Instance.new("UICorner", svKnob)
	svkc.CornerRadius = UDim.new(1, 0)
	local svks = Instance.new("UIStroke", svKnob)
	svks.Color = Color3.fromRGB(0, 0, 0)
	svks.Thickness = 1.5

	local hue, sat, val = 0, 1, 1
	local panelOpen = false
	local draggingHue, draggingSV = false, false

	local function updateColor()
		local color = Color3.fromHSV(hue, sat, val)
		preview.BackgroundColor3 = color
		satValBox.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
		if callback then callback(color) end
	end

	if default then
		local h, s, v = Color3.toHSV(default)
		hue, sat, val = h, s, v
		hueKnob.Position = UDim2.new(hue, 0, 0.5, 0)
		svKnob.Position = UDim2.new(sat, 0, 1 - val, 0)
		updateColor()
	end

	local win = self._window
	local function updatePanelPosition()
		local abs = preview.AbsolutePosition
		local sz = preview.AbsoluteSize
		local mainAbs = self._main.AbsolutePosition
		panel.Size = UDim2.new(0, sz.X, 0, 130)
		panel.Position = UDim2.new(0, abs.X + sz.X - mainAbs.X, 0, abs.Y + sz.Y - mainAbs.Y + 4)
	end

	preview.Activated:Connect(function()
		if panelOpen then
			win:_closePopup()
		else
			win:_registerPopup(function()
				panelOpen = false
				panel.Visible = false
			end)
			panelOpen = true
			updatePanelPosition()
			panel.Visible = true
		end
	end)

	local scrollRef = self._scroll
	scrollRef:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if panelOpen then win:_closePopup() end
	end)

	hueBG.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingHue = true
		end
	end)
	satValBox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSV = true
		end
	end)
	uis.InputChanged:Connect(function(input)
		if draggingHue and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			hue = math.clamp((input.Position.X - hueBG.AbsolutePosition.X) / hueBG.AbsoluteSize.X, 0, 1)
			hueKnob.Position = UDim2.new(hue, 0, 0.5, 0)
			updateColor()
		end
		if draggingSV and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			sat = math.clamp((input.Position.X - satValBox.AbsolutePosition.X) / satValBox.AbsoluteSize.X, 0, 1)
			val = 1 - math.clamp((input.Position.Y - satValBox.AbsolutePosition.Y) / satValBox.AbsoluteSize.Y, 0, 1)
			svKnob.Position = UDim2.new(sat, 0, 1 - val, 0)
			updateColor()
		end
	end)
	uis.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingHue = false
			draggingSV = false
		end
	end)
end

function Tab:AddSection(name)
	self._order += 1
	local section = Instance.new("Frame", self._scroll)
	section.BorderSizePixel = 0
	section.BackgroundTransparency = 1
	section.Size = UDim2.new(0, 270, 0, 20)
	section.LayoutOrder = self._order

	local line = Instance.new("Frame", section)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	line.AnchorPoint = Vector2.new(0, 0.5)
	line.Size = UDim2.new(1, 0, 0, 1)
	line.Position = UDim2.new(0, 0, 0.5, 0)
	line.ZIndex = 3
	local lc = Instance.new("UICorner", line)
	lc.CornerRadius = UDim.new(1, 0)

	local title = Instance.new("TextLabel", section)
	title.TextWrapped = true
	title.BorderSizePixel = 0
	title.TextScaled = true
	title.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	title.FontFace = boldFont
	title.TextColor3 = Color3.fromRGB(160, 160, 160)
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Size = UDim2.new(0, 80, 1, 0)
	title.Position = UDim2.new(0.5, 0, 0.5, 0)
	title.Text = name
	title.ZIndex = 4
	local tp = Instance.new("UIPadding", title)
	tp.PaddingLeft = UDim.new(0, 6)
	tp.PaddingRight = UDim.new(0, 6)
end

function Tab:AddLabel(name, value)
	self._order += 1
	local row = makeRow(self._scroll, self._order)

	local nameLbl = makeLabel(row, name, Enum.TextXAlignment.Left, UDim2.new(0.4, 0, 1, 0), UDim2.new(0, 0, 0.5, 0))

	local valLbl = Instance.new("TextLabel", row)
	valLbl.TextWrapped = true
	valLbl.BorderSizePixel = 0
	valLbl.TextXAlignment = Enum.TextXAlignment.Right
	valLbl.TextScaled = true
	valLbl.BackgroundTransparency = 1
	valLbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	valLbl.FontFace = regFont
	valLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
	valLbl.AnchorPoint = Vector2.new(1, 0.5)
	valLbl.Size = UDim2.new(0.55, 0, 1, 0)
	valLbl.Position = UDim2.new(1, 0, 0.5, 0)
	valLbl.Text = value or ""

	local api = {}
	function api:SetValue(v) valLbl.Text = v end
	return api
end

return Jawere
