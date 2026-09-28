local env = _G or {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local StatsService = game:GetService("Stats")
local MarketplaceService = game:GetService("MarketplaceService")
local CoreGui = game:GetService("CoreGui")

if not game:IsLoaded() then game.Loaded:Wait() end

local function pickFn(v)
	return type(v) == "function" and v or nil
end
local evalExpr
local function getGlobal(name)
	local value = env[name]
	if value ~= nil then
		return value
	end
	return evalExpr(name)
end
evalExpr = function(expr)
	local loader = pickFn(env.loadstring) or pickFn(loadstring)
	if not loader or type(expr) ~= "string" then
		return nil
	end

	local okChunk, chunk = pcall(loader, "return " .. expr)
	if not okChunk or type(chunk) ~= "function" then
		return nil
	end

	local okValue, value = pcall(chunk)
	return okValue and value or nil
end
local WriteFile = pickFn(getGlobal("writefile"))
local ReadFile = pickFn(getGlobal("readfile"))
local MakeFolder = pickFn(getGlobal("makefolder"))
local IsFolder = pickFn(getGlobal("isfolder"))
local IsFile = pickFn(getGlobal("isfile"))
local ListFiles = pickFn(getGlobal("listfiles"))
local httpGet = function(url)
	return (game :: any):HttpGet(url)
end
local httpGetAsync = function(url)
	return (game :: any):HttpGetAsync(url)
end

local REFERENCE_WIDTH = 1920
local REFERENCE_HEIGHT = 1080

local Library = {
	Theme = {
		Background = Color3.fromRGB(14, 14, 14),
		Sidebar = Color3.fromRGB(18, 18, 18),
		Panel = Color3.fromRGB(26, 26, 26),
		PanelDark = Color3.fromRGB(22, 22, 22),
		PanelLight = Color3.fromRGB(35, 35, 35),
		Border = Color3.fromRGB(58, 58, 58),
		BorderSoft = Color3.fromRGB(42, 42, 42),
		Accent = Color3.fromRGB(224, 224, 224),
		AccentSoft = Color3.fromRGB(186, 186, 186),
		Text = Color3.fromRGB(236, 236, 236),
		TextSoft = Color3.fromRGB(166, 166, 166),
		TextMute = Color3.fromRGB(120, 120, 120),
		Success = Color3.fromRGB(210, 210, 210),
		Danger = Color3.fromRGB(162, 162, 162),
		Overlay = Color3.fromRGB(7, 7, 7),
		Purple = Color3.fromRGB(150, 137, 255),

	},
	Tweens = {
		Instant = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Fast = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Normal = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		Slow = TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		Spring = TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
		Fade = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			Click = TweenInfo.new(0.10, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
			Pulse = TweenInfo.new(0.14, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
	},
	Flags = {},
	Registry = {},
	SearchIndex = {},
	Tabs = {},
	Consoles = {},
	Notifications = {},
	Visible = true,
	LoadingConfig = false,
	DefaultNotificationTime = 4,
	RainbowHue = 0,
	RainbowColor = Color3.fromRGB(255, 255, 255),
}


local VisualRegistry = {}
local ActiveTweens   = setmetatable({}, {__mode = "k"})

local IconAssets = {
	["sword"] = { Id = 16898787671, Offset = Vector2.new(257, 514) },
	["eye"] = { Id = 16898669897, Offset = Vector2.new(0, 0) },
	["globe-2"] = { Id = 16898672599, Offset = Vector2.new(0, 257) },
	["zap"] = { Id = 16898791349, Offset = Vector2.new(257, 257) },
	["move"] = { Id = 16898729752, Offset = Vector2.new(0, 514) },
	["bot"] = { Id = 16898616650, Offset = Vector2.new(514, 0) },
	["play-square"] = { Id = 16898731919, Offset = Vector2.new(257, 257) },
	["monitor"] = { Id = 16898729141, Offset = Vector2.new(514, 257) },
	["folder"] = { Id = 16898671684, Offset = Vector2.new(257, 0) },
	["settings"] = { Id = 16898734421, Offset = Vector2.new(514, 0) },
	["layout-panel-left"] = { Id = 16898674182, Offset = Vector2.new(0, 514) },
	["wrench"] = { Id = 16898791187, Offset = Vector2.new(514, 257) },
	["keyboard"] = { Id = 16898673794, Offset = Vector2.new(257, 0) },
	["save"] = { Id = 16898733674, Offset = Vector2.new(0, 257) },
	["trash-2"] = { Id = 16898789012, Offset = Vector2.new(0, 257) },
	["refresh-cw"] = { Id = 16898733146, Offset = Vector2.new(257, 0) },
	["terminal-square"] = { Id = 16898788248, Offset = Vector2.new(0, 514) },
	["plus"] = { Id = 16898732061, Offset = Vector2.new(514, 0) },
	["search"] = { Id = 16898734242, Offset = Vector2.new(257, 0) },
	["file-text"] = { Id = 16898670469, Offset = Vector2.new(514, 0) },
	["help-circle"] = { Id = 16898673271, Offset = Vector2.new(0, 257) },
	["info"] = { Id = 16898673523, Offset = Vector2.new(257, 257) },
	["chevron-left"] = { Id = 16898617509, Offset = Vector2.new(0, 257) },
	["chevron-right"] = { Id = 16898617509, Offset = Vector2.new(0, 514) },
	["x"] = { Id = 16898791349, Offset = Vector2.new(257, 0) },
	["more-horizontal"] = { Id = 16898729337, Offset = Vector2.new(257, 0) },
	["sliders-horizontal"] = { Id = 16898735040, Offset = Vector2.new(0, 257) },
	["circle-check"] = { Id = 16898617803, Offset = Vector2.new(257, 257) },
	["square-check"] = { Id = 16898735664, Offset = Vector2.new(514, 514) },
	["cog"] = { Id = 16898619015, Offset = Vector2.new(514, 514) },
	["move-diagonal-2"] = { Id = 16898729572, Offset = Vector2.new(0, 257) },
	["sparkles"] = { Id = 16898735175, Offset = Vector2.new(514, 514) },
	["mailbox"] = { Id = 16898671684, Offset = Vector2.new(257, 0) },
	["server"] = { Id = 16898729141, Offset = Vector2.new(514, 257) },
	["database"] = { Id = 16898671684, Offset = Vector2.new(0, 514) },
	["archive"] = { Id = 16898671684, Offset = Vector2.new(0, 257) },
	["inbox"] = { Id = 16898670469, Offset = Vector2.new(514, 257) },
	["cloud"] = { Id = 16898672599, Offset = Vector2.new(514, 257) },
}

local _isMobileCached = nil
local function isMobile()
	if _isMobileCached ~= nil then return _isMobileCached end
	_isMobileCached = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	return _isMobileCached
end

local function getViewportSize()
	local camera = workspace.CurrentCamera
	if camera then return camera.ViewportSize end
	return Vector2.new(REFERENCE_WIDTH, REFERENCE_HEIGHT)
end

local function isSmallViewport()
	local vp = getViewportSize()
	return vp.X < 700 or isMobile()
end

local function isInputTouch(input)
	return input.UserInputType == Enum.UserInputType.Touch
end

local function isInputMouse1(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
end

local function isInputDragStart(input)
	return isInputMouse1(input) or isInputTouch(input)
end

local function isInputDragMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement or isInputTouch(input)
end

local function isInputDragEnd(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or isInputTouch(input)
end

local Utility = {}

local function isCallable(value)
	return type(value) == "function"
end

function Utility.tween(instance, tweenInfo, properties)
	if not instance then
		return nil
	end

	local resolvedInfo = tweenInfo
	if type(tweenInfo) == "string" then
		resolvedInfo = Library.Tweens[tweenInfo] or Library.Tweens.Normal
	end

	if ActiveTweens[instance] then
		ActiveTweens[instance]:Cancel()
	end

	local filteredProperties = {}
	for property, value in pairs(properties or {}) do
		local ok = pcall(function()
			local _ = instance[property]
		end)
		if ok then
			filteredProperties[property] = value
		end
	end
	if next(filteredProperties) == nil then
		return nil
	end

	local tween = TweenService:Create(instance, resolvedInfo or Library.Tweens.Normal, filteredProperties)
	ActiveTweens[instance] = tween
	tween.Completed:Connect(function()
		if ActiveTweens[instance] == tween then
			ActiveTweens[instance] = nil
		end
	end)
	tween:Play()
	return tween
end

function Utility.hopToDifferentServer()
	local placeId = tostring(game.PlaceId)
	local currentJob = tostring(game.JobId)
	local foundJob = nil
	local baseUrl = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100"):format(placeId)
	local cursor = nil
	repeat
		local url = baseUrl
		if cursor and #cursor > 0 then
			url = url .. "&cursor=" .. tostring(cursor)
		end
		local res = httpGet(url)
		local data = HttpService:JSONDecode(res)
		if not data or not data.data then
			break
		end
		for _, srv in ipairs(data.data) do
			local id = tostring(srv.id or "")
			local playing = tonumber(srv.playing or 0) or 0
			local maxPlayers = tonumber(srv.maxPlayers or 0) or 0
			if id ~= currentJob and (maxPlayers == 0 or playing < maxPlayers) then
				foundJob = id
				break
			end
		end
		cursor = data.nextPageCursor
	until foundJob or not cursor

	if foundJob then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, foundJob, LocalPlayer)
		return true
	end
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
	return false
end

function Utility.rejoinCurrentPlaceSimple()
	TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
    return true
end

function Utility.registerVisual(instance)
	if not instance then
		return instance
	end

	local properties = {}
	if instance:IsA("GuiObject") then
		properties.BackgroundTransparency = instance.BackgroundTransparency
	end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
		properties.TextTransparency = instance.TextTransparency
		properties.TextStrokeTransparency = instance.TextStrokeTransparency
	end
	if instance:IsA("ImageLabel") or instance:IsA("ImageButton") then
		properties.ImageTransparency = instance.ImageTransparency
		properties.BackgroundTransparency = instance.BackgroundTransparency
	end
	if instance:IsA("UIStroke") then
		properties.Transparency = instance.Transparency
	end
	if instance:IsA("ScrollingFrame") then
		properties.ScrollBarImageTransparency = instance.ScrollBarImageTransparency
	end
	if next(properties) then
		VisualRegistry[instance] = properties
		instance.Destroying:Connect(function()
			VisualRegistry[instance] = nil
		end)
	end
	return instance
end

function Utility.new(className, properties)
	local instance = Instance.new(className)
	for property, value in pairs(properties or {}) do
        local ok, err = pcall(function()
            instance[property] = value
        end)

        if not ok then
            warn(
                "[aeroWare] Failed to set",
                className,
                property,
                typeof(value),
                tostring(err)
            )
        end
	end
	return Utility.registerVisual(instance)
end

function Utility.applyRound(instance, radius)
	Utility.new("UICorner", {
		CornerRadius = radius or UDim.new(0, 8),
		Parent = instance,
	})
	return instance
end

function Utility.applyStroke(instance, color, thickness, transparency)
	return Utility.new("UIStroke", {
		Color = color or Library.Theme.Border,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = instance,
	})
end

function Utility.applyPadding(instance, left, right, top, bottom)
	Utility.new("UIPadding", {
		PaddingLeft = UDim.new(0, left or 0),
		PaddingRight = UDim.new(0, right or left or 0),
		PaddingTop = UDim.new(0, top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		Parent = instance,
	})
	return instance
end

function Utility.createGradient(instance, colorA, colorB, rotation)
	return Utility.new("UIGradient", {
		Color = ColorSequence.new(colorA, colorB),
		Rotation = rotation or 90,
		Parent = instance,
	})
end

function Utility.bindHover(button, enter, leave)
	button.MouseEnter:Connect(function()
		if enter then
			enter()
		end
	end)
	button.MouseLeave:Connect(function()
		if leave then
			leave()
		end
	end)
end


local function getFrameSize(frame)
	local size = frame.AbsoluteSize
	if size.X > 0 and size.Y > 0 then
		return size
	end
	return Vector2.new(frame.Size.X.Offset, frame.Size.Y.Offset)
end

function Utility.setWindowTopLeft(frame, topLeft)
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local viewport = camera.ViewportSize
	local size = getFrameSize(frame)

	local x = math.clamp(topLeft.X, 0, math.max(0, viewport.X - size.X))
	local y = math.clamp(topLeft.Y, 0, math.max(0, viewport.Y - size.Y))

	frame.Position = UDim2.fromOffset(
		x + (size.X * frame.AnchorPoint.X),
		y + (size.Y * frame.AnchorPoint.Y)
	)
end

function Utility.findHui()
	local getHui = pickFn(getGlobal("gethui"))
	if getHui then
		return getHui()
	end
	local getHiddenGui = pickFn(getGlobal("get_hidden_gui"))
	if getHiddenGui then
		return getHiddenGui()
	else
		return CoreGui
	end
end

function Utility.centerWindow(frame)
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end

	local viewport = camera.ViewportSize
	local size = getFrameSize(frame)

	Utility.setWindowTopLeft(frame, Vector2.new(
		(viewport.X - size.X) * 0.5,
		(viewport.Y - size.Y) * 0.5
	))
end

function Utility.makeIcon(iconName, parent, size, color)
	local asset = IconAssets[iconName]
	if not asset then
		return Utility.new("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(size or 18, size or 18),
			Parent = parent,
		})
	end

	return Utility.new("ImageLabel", {
		Name = iconName,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(size or 18, size or 18),
		Image = "rbxassetid://" .. asset.Id,
		ImageRectSize = Vector2.new(256, 256),
		ImageRectOffset = asset.Offset,
		ScaleType = Enum.ScaleType.Crop,
		ImageColor3 = color or Library.Theme.TextSoft,
		Parent = parent,
	})
end
local function formatValue(value)
	if typeof(value) == "EnumItem" then
		return value.Name
	end
	if type(value) == "number" then
		if math.abs(value - math.floor(value)) < 0.001 then
			return tostring(math.floor(value))
		end
		return string.format("%.2f", value)
	end
	if type(value) == "boolean" then
		return value and "On" or "Off"
	end
	if value == nil then
		return "nil"
	end
	return tostring(value)
end

local function normalizeForSave(value)
	if typeof(value) == "EnumItem" then
		return value.Name
	end
	if type(value) ~= "table" then
		return value
	end
	local result = {}
	for key, nested in pairs(value) do
		result[key] = normalizeForSave(nested)
	end
	return result
end

local function colorToHex(color)
	if typeof(color) ~= "Color3" then
		return "#FFFFFF"
	end
	local r = math.clamp(math.floor((color.R * 255) + 0.5), 0, 255)
	local g = math.clamp(math.floor((color.G * 255) + 0.5), 0, 255)
	local b = math.clamp(math.floor((color.B * 255) + 0.5), 0, 255)
	return string.format("#%02X%02X%02X", r, g, b)
end

local function parseColorString(value)
	if typeof(value) == "Color3" then
		return value
	end

	if type(value) ~= "string" then
		return nil
	end

	local text = value:match("^%s*(.-)%s*$")
	if not text or text == "" then
		return nil
	end

	local hex = text:gsub("#", "")
	if #hex == 6 then
		local num = tonumber(hex, 16)
		if num then
			local r = bit32.rshift(num, 16) % 256
			local g = bit32.rshift(num, 8) % 256
			local b = num % 256
			return Color3.fromRGB(r, g, b)
		end
	end

	local r, g, b = text:match("^(%d+)%s*,%s*(%d+)%s*,%s*(%d+)$")
	if r and g and b then
		return Color3.fromRGB(
			math.clamp(tonumber(r) or 255, 0, 255),
			math.clamp(tonumber(g) or 255, 0, 255),
			math.clamp(tonumber(b) or 255, 0, 255)
		)
	end

	return nil
end

local function serializeConfig(data)
	local lines = {}
	for key, value in pairs(data) do
		local v
		if type(value) == "boolean" then
			v = "bool:" .. tostring(value)
		elseif type(value) == "number" then
			v = "num:" .. tostring(value)
		elseif type(value) == "table" then
			local ok, encoded = pcall(function()
				return HttpService:JSONEncode(value)
			end)
			v = ok and ("json:" .. encoded) or ("str:" .. tostring(value):gsub("[\r\n]", " "))
		else
			v = "str:" .. tostring(value):gsub("[\r\n]", " ")
		end
		table.insert(lines, tostring(key) .. "=" .. v)
	end
	table.sort(lines)
	return table.concat(lines, "\n")
end

local function parseConfig(content)
	local data = {}
	for line in (content or ""):gmatch("[^\r\n]+") do
		local key, val = line:match("^([^=]+)=(.*)$")
		if key and val then
			key = key:match("^%s*(.-)%s*$")
			local tp, raw = val:match("^(%a+):(.*)$")
			if tp == "bool" then
				data[key] = (raw:lower() == "true")
			elseif tp == "num" then
				local n = tonumber(raw)
				if n then data[key] = n end
			elseif tp == "json" then
				local ok, decoded = pcall(function()
					return HttpService:JSONDecode(raw)
				end)
				if ok then
					data[key] = decoded
				end
			elseif tp == "str" then
				data[key] = raw
			else
				data[key] = val
			end
		end
	end
	return data
end


local function asInputName(value)
	if typeof(value) == "EnumItem" then
		if value.EnumType == Enum.KeyCode then
			return value.Name
		elseif value.EnumType == Enum.UserInputType then
			return value.Name
		end
	end
	if type(value) == "string" and value ~= "" then
		if Enum.KeyCode[value] then return value end
		if Enum.UserInputType[value] then return value end
	end
	return "RightShift"
end

local function configNameFromPath(path)
	local normalized = string.gsub(path, "\\", "/")
	local fileName = string.match(normalized, "([^/]+)$") or normalized
	local name = string.gsub(fileName, "%.cfg$", "")
	return name
end

local function getCurrentGameName()
	local fallback = game.Name ~= "" and game.Name or "Current Game"
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	if ok and type(info) == "table" and type(info.Name) == "string" and info.Name ~= "" then
		return info.Name
	end
	return fallback
end

function Library:getConfigDirectory()
	return string.format("%s/%s", self:getConfigRootDirectory(), self:getCurrentGameFolderName())
end

function Library:getConfigRootDirectory()
	return "aeroWare/configs"
end

function Library:getConfigMetaPath()
	return string.format("%s/configmeta.txt", self:getConfigRootDirectory())
end

function Library:getDefaultConfigName()
	return tostring(game.GameId ~= 0 and game.GameId or game.PlaceId)
end

function Library:sanitizeConfigName(name)
	local source = tostring(name or "")
	local trimmed = string.match(source, "^%s*(.-)%s*$") or ""
	if trimmed == "" then
		return nil
	end
	trimmed = string.gsub(trimmed, "[\\/:*?\"<>|=]", "_")
	trimmed = string.gsub(trimmed, "%s+", "_")
	return trimmed
end

function Library:getConfigPath(configName)
	local resolved = self:sanitizeConfigName(configName) or self.ActiveConfigName or self:getDefaultConfigName()
	return string.format("%s/%s.cfg", self:getConfigDirectory(), resolved)
end

function Library:listConfigProfiles()
	local configDirectory = self:getConfigDirectory()
	self:ensureConfigFolder()
	local names = {}
	local seen = {}

	if ListFiles and IsFolder and IsFolder(configDirectory) then
		local ok, files = pcall(ListFiles, configDirectory)
		if ok and type(files) == "table" then
			for _, path in ipairs(files) do
				local filePath = tostring(path or "")
				if string.lower(filePath):sub(-4) == ".cfg" then
					local name = self:sanitizeConfigName(configNameFromPath(filePath))
					if name and not seen[name] then
						seen[name] = true
						table.insert(names, name)
					end
				end
			end
		end
	end

	if #names == 0 then
		table.insert(names, self:getDefaultConfigName())
	end

	table.sort(names)
	return names
end

function Library:refreshConfigSelectorUI()
	local profiles = self:listConfigProfiles()
	self.ConfigProfiles = profiles

	if not self.ActiveConfigName then
		self.ActiveConfigName = self:getDefaultConfigName()
	end

	local exists = false
	for _, name in ipairs(profiles) do
		if name == self.ActiveConfigName then
			exists = true
			break
		end
	end
	if not exists then
		self.ActiveConfigName = profiles[1]
	end

	if self.ConfigProfileDisplay then
		self.ConfigProfileDisplay:SetValue(self.ActiveConfigName)
	end
	if self.ConfigDropdown then
		self.ConfigDropdown:SetOptions(profiles, true)
		self.ConfigDropdown:SetValue(self.ActiveConfigName, true, true)
	end
	if self.ConfigPathDisplay then
		self.ConfigPathDisplay:SetValue(self:getConfigPath(self.ActiveConfigName))
	end
	if self.ConfigCountDisplay then
		self.ConfigCountDisplay:SetValue(tostring(#profiles) .. " profile(s)")
	end
end

function Library:setActiveConfig(configName, showNotification)
	local sanitized = self:sanitizeConfigName(configName)
	if not sanitized then
		return false
	end

	self.ActiveConfigName = sanitized
	self:refreshConfigSelectorUI()
	if showNotification then
		self:notify("Selected config: " .. sanitized, 2.5)
	end
	return true
end

function Library:readConfigMetaEntries()
	local entries = {}
	if not (ReadFile and IsFile and IsFile(self:getConfigMetaPath())) then
		return entries
	end

	local ok, content = pcall(ReadFile, self:getConfigMetaPath())
	if not ok or type(content) ~= "string" then
		return entries
	end

	for line in content:gmatch("[^\r\n]+") do
		local gameFolder, configName = line:match("^([^=]+)=(.*)$")
		if gameFolder and configName then
			local folder = self:sanitizeConfigName(gameFolder)
			if folder then
				entries[folder] = self:sanitizeConfigName(configName) or ""
			end
		end
	end
	return entries
end

function Library:getCurrentGameFolderName()
	return self:sanitizeConfigName(getCurrentGameName()) or "Current_Game"
end

function Library:setAutoloadConfig(configName, showNotification)
	local selected = self:sanitizeConfigName(configName)
	if not selected then
		return false
	end
	if not (IsFile and IsFile(self:getConfigPath(selected))) then
		return false
	end

	self.AutoloadConfigName = selected
	local saved = self:saveConfigMeta()
	if saved and showNotification then
		self:notify("Set autoload: " .. selected, 3)
	end
	return saved
end

function Library:clearAutoloadConfig(showNotification)
	self.AutoloadConfigName = nil
	local saved = self:saveConfigMeta()
	if saved and showNotification then
		self:notify("Cleared autoload for " .. self:getCurrentGameFolderName(), 3)
	end
	return saved
end

function Library:ensureConfigFolder()
	if not MakeFolder then return end
	local path = ""
	for segment in self:getConfigDirectory():gmatch("[^/]+") do
		path = path == "" and segment or (path .. "/" .. segment)
		if IsFolder and not IsFolder(path) then
			pcall(MakeFolder, path)
		end
	end
end

function Library:saveConfigMeta()
	if not WriteFile then
		return false
	end

	self:ensureConfigFolder()
	local entries = self:readConfigMetaEntries()
	entries[self:getCurrentGameFolderName()] = self:sanitizeConfigName(self.AutoloadConfigName) or ""
	local folders = {}
	for folder in pairs(entries) do
		table.insert(folders, folder)
	end
	table.sort(folders)
	local lines = {}
	for _, folder in ipairs(folders) do
		table.insert(lines, folder .. "=" .. tostring(entries[folder] or ""))
	end
	local ok = pcall(WriteFile, self:getConfigMetaPath(), table.concat(lines, "\n"))
	return ok
end

function Library:loadConfigMeta()
	self:ensureConfigFolder()
	self.ActiveConfigName = self.ActiveConfigName or self:getDefaultConfigName()
	local entries = self:readConfigMetaEntries()
	self.AutoloadConfigName = entries[self:getCurrentGameFolderName()]
	if self.AutoloadConfigName == "" then
		self.AutoloadConfigName = nil
	end
	if not entries[self:getCurrentGameFolderName()] then
		self:saveConfigMeta()
	end
end

function Library:collectConfig()
	local data = {}
	for flag, entry in pairs(self.Registry) do
		data[flag] = normalizeForSave(entry:GetValue())
	end
	return data
end

function Library:saveConfig(showNotification, configName)
	if not WriteFile then
		if showNotification then
			self:notify("Config write is unavailable in this environment.", 4)
		end
		return false
	end

	local targetName = self:sanitizeConfigName(configName) or self.ActiveConfigName or self:getDefaultConfigName()
	local targetPath = self:getConfigPath(targetName)

	self:ensureConfigFolder()
	local _writeOk, _writeErr = pcall(WriteFile, targetPath, serializeConfig(self:collectConfig()))
	if not _writeOk then
		if showNotification then
			self:notify("Config write failed: " .. tostring(_writeErr), 4)
		end
		return false
	end
	self.ActiveConfigName = targetName
	self:refreshConfigSelectorUI()
	if self.StatusDisplay then
		self.StatusDisplay:SetValue("Saved " .. targetName)
	end
	if showNotification then
		self:notify("Saved config: " .. targetName, 3)
	end
	return true
end

function Library:loadConfig(showNotification, configName)
	local targetName = self:sanitizeConfigName(configName) or self.ActiveConfigName or self:getDefaultConfigName()
	local targetPath = self:getConfigPath(targetName)

	if not (ReadFile and IsFile and IsFile(targetPath)) then
		self.ActiveConfigName = targetName
		self:saveConfig(false, targetName)
		if showNotification then
			self:notify("Created config: " .. targetName, 3)
		end
		return true
	end

	local _readOk, raw = pcall(ReadFile, targetPath)
	if not _readOk or type(raw) ~= "string" then
		if showNotification then
			self:notify("Config file could not be read.", 3)
		end
		return false
	end
	local decoded = parseConfig(raw)

	self.LoadingConfig = true
	for flag, value in pairs(decoded) do
		local entry = self.Registry[flag]
		if entry and entry.SetValue then
			entry:SetValue(value, true)
		end
	end
	self.LoadingConfig = false
	self:applyParticleSettingsFromFlags()
	self.ActiveConfigName = targetName
	self:refreshConfigSelectorUI()

	if self.StatusDisplay then
		self.StatusDisplay:SetValue("Loaded " .. targetName)
	end
	if showNotification then
		self:notify("Loaded config: " .. targetName, 3)
	end
	return true
end

function Library:startRainbowLoop()
	if self._rainbowConn then
		return
	end

	self.RainbowHue = self.RainbowHue or 0
	self.RainbowColor = self.RainbowColor or Color3.fromHSV(self.RainbowHue, 1, 1)
	self._rainbowConn = RunService.RenderStepped:Connect(function(dt)
		self.RainbowHue = (self.RainbowHue + (dt * 0.12)) % 1
		self.RainbowColor = Color3.fromHSV(self.RainbowHue, 1, 1)
	end)
end

function Library:disconnectRuntimeConnections()
	local connectionKeys = {
		"_rainbowConn",
		"_constellationConn",
		"GlobalToggleConnection",
		"_runtimeStatsConn",
		"_viewportResizeConn",
	}

	for _, key in ipairs(connectionKeys) do
		local connection = self[key]
		if connection then
			pcall(function()
				connection:Disconnect()
			end)
			self[key] = nil
		end
	end
end

function Library:applyParticleSettingsFromFlags()
	if self.Flags["Aero.Particles"] ~= nil then
		self.ConstellationEnabled = self.Flags["Aero.Particles"] == true
		if self.ConstellationContainer then
			self.ConstellationContainer.Visible = self.ConstellationEnabled
		end
	end

	if self.Flags["Aero.ParticleCount"] ~= nil then
		self:setParticleCount(self.Flags["Aero.ParticleCount"])
	end
	if self.Flags["Aero.ParticleMaxLinks"] ~= nil then
		self:setParticleMaxLinks(self.Flags["Aero.ParticleMaxLinks"])
	end
	if self.Flags["Aero.ParticleLinkDistance"] ~= nil then
		self:setParticleLinkDistance((tonumber(self.Flags["Aero.ParticleLinkDistance"]) or 22) / 100)
	end
	if self.Flags["Aero.ParticleSpeed"] ~= nil then
		self:setParticleSpeed((tonumber(self.Flags["Aero.ParticleSpeed"]) or 45) / 100)
	end
	if self.Flags["Aero.ParticleMode"] ~= nil then
		self:setParticleMode(self.Flags["Aero.ParticleMode"])
	end

	self._constellationUseRainbowColor = self.Flags["Aero.ParticleColorRGBMode"] == true

	local resolvedColor = parseColorString(self.Flags["Aero.ParticleColor"])
	if not resolvedColor then
		local r = tonumber(self.Flags["Aero.ParticleColorR"])
		local g = tonumber(self.Flags["Aero.ParticleColorG"])
		local b = tonumber(self.Flags["Aero.ParticleColorB"])
		if r and g and b then
			resolvedColor = Color3.fromRGB(
				math.clamp(math.floor(r + 0.5), 0, 255),
				math.clamp(math.floor(g + 0.5), 0, 255),
				math.clamp(math.floor(b + 0.5), 0, 255)
			)
		end
	end

	if resolvedColor then
		self:setParticleColor(resolvedColor)
		self.Flags["Aero.ParticleColor"] = colorToHex(resolvedColor)
	end
end

function Library:registerFlag(flag, entry)
	if not flag then
		return
	end
	self.Registry[flag] = entry
	self.Flags[flag] = entry.GetSaveValue and entry:GetSaveValue() or entry:GetValue()
end

function Library:updateFlag(flag, value)
	if not flag then
		return
	end
	self.Flags[flag] = value
end

function Library:updateAllVisuals(alpha, instant)
	local uiT = self._uiTransparency or 0

	local effective = math.max(alpha, uiT)
	for instance, base in pairs(VisualRegistry) do
		if instance.Parent then
			local goal = {}
			for property, originalValue in pairs(base) do
				goal[property] = originalValue + ((1 - originalValue) * effective)
			end

			if instant then
				for property, value in pairs(goal) do
					instance[property] = value
				end
			else
				Utility.tween(instance, "Fade", goal)
			end
		end
	end
end

function Library:releaseFocusedInput()
	local focusedBox = UserInputService:GetFocusedTextBox()
	if focusedBox then
		focusedBox:ReleaseFocus()
	end
end

function Library:updateTooltipPosition()
	if not (self.Tooltip and self.Tooltip.Visible and self.ScreenGui) then
		return
	end

	local mousePos = UserInputService:GetMouseLocation()
	local tooltipSize = self.Tooltip.AbsoluteSize
	local viewport = self.ScreenGui.AbsoluteSize
	local offset = Vector2.new(16, 18)

	local x = mousePos.X + offset.X
	local y = mousePos.Y + offset.Y

	if x + tooltipSize.X > viewport.X - 8 then
		x = mousePos.X - tooltipSize.X - 12
	end
	if y + tooltipSize.Y > viewport.Y - 8 then
		y = mousePos.Y - tooltipSize.Y - 12
	end

	x = math.clamp(x, 8, math.max(8, viewport.X - tooltipSize.X - 8))
	y = math.clamp(y, 8, math.max(8, viewport.Y - tooltipSize.Y - 8))

	self.Tooltip.Position = UDim2.fromOffset(x, y)
end

function Library:setVisible(state)
	if self.Visible == state then
		return
	end

	self.Visible = state
	self.ToggleToken = (self.ToggleToken or 0) + 1
	local token = self.ToggleToken

	if state then
		self:releaseFocusedInput()
		self.MainHolder.Visible = true
		if self.ConstellationContainer then
			self.ConstellationContainer.Visible = true
		end
		if self.VisibilityDriver then
			self.VisibilityDriver.Value = 1
			self:updateAllVisuals(1, true)
		else
			self:updateAllVisuals(0, true)
		end
		self.MainScale.Scale = 0.985
		Utility.tween(self.MainScale, "Spring", { Scale = 1 })

		task.delay(0.05, function()
			if self.ToggleToken == token and self.Visible then
				self:updateAllVisuals(0, false)
			end
		end)
	else
		self:releaseFocusedInput()
		if self.SearchResultsPanel then
			self.SearchResultsPanel.Visible = false
		end
		if self.ConstellationContainer then
			self.ConstellationContainer.Visible = false
		end
		if self.VisibilityDriver then
			self.VisibilityDriver.Value = 1
		end
		self:updateAllVisuals(1, false)
		Utility.tween(self.MainScale, "Slow", { Scale = 0.985 })
		task.delay(0.3, function()
			if self.ToggleToken == token and not self.Visible then
				self:releaseFocusedInput()
				self.MainHolder.Visible = false
			end
		end)
	end
end

function Library:toggleVisible()
	self:setVisible(not self.Visible)
end

function Library:setTooltip(text)
	if not self.Tooltip then
		return
	end

	if not text or text == "" then
		self.Tooltip.Visible = false
		return
	end

	self.TooltipLabel.Text = text
	self.Tooltip.Visible = true
	self:updateTooltipPosition()
	end

function Library:trackTooltip(target, tooltip)
	if not tooltip or tooltip == "" then
		return
	end

	if isMobile() then
		return
	end

	local hovering = false
	local tooltipShown = false

	local function showTooltip()
		tooltipShown = true
		self:setTooltip(tooltip)
		local base = VisualRegistry[target]
		local baseAlpha = (base and base.BackgroundTransparency ~= nil) and base.BackgroundTransparency or target.BackgroundTransparency
		Utility.tween(target, "Normal", { BackgroundTransparency = math.max(0, baseAlpha - 0.05) })
	end

	local function hideAll()
		hovering = false
		if tooltipShown then
			self:setTooltip(nil)
			tooltipShown = false
			local base = VisualRegistry[target]
			if base and base.BackgroundTransparency ~= nil then
				Utility.tween(target, "Normal", { BackgroundTransparency = base.BackgroundTransparency })
			end
		end
	end

	target.MouseEnter:Connect(function()
		hovering = true
		tooltipShown = false
		local startPos = UserInputService:GetMouseLocation()
		local deadline = tick() + 0.3
		task.spawn(function()
			while hovering do
				task.wait(0.05)
				if not hovering then break end
				local currentPos = UserInputService:GetMouseLocation()
				if (currentPos - startPos).Magnitude > 4 then
					startPos = currentPos
					deadline = tick() + 0.3
				end
				if tick() >= deadline and not tooltipShown then
					showTooltip()
					break
				end
			end
		end)
	end)

	target.MouseLeave:Connect(function()
		hideAll()
	end)
end

function Library:notify(message, duration)
	local flags = type(self.Flags) == "table" and self.Flags or {}
	local configuredTime = tonumber(flags["Aero.NotificationTime"] or flags["aero.notificationtime"])
		or tonumber(self.DefaultNotificationTime) or 4
	local time = tonumber(duration) or configuredTime
	time = math.clamp(time, 0.1, 60)
	local uiT = self._uiTransparency or 0
	local function withUi(base)
		return base + ((1 - base) * uiT)
	end
	local card = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.Panel,
		BackgroundTransparency = 0.03,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ClipsDescendants = true,
		Parent = self.NotificationList,
	})
	local cardSizeConstraint = Utility.new("UISizeConstraint", {
		MinSize = Vector2.new(0, 30),
		Parent = card,
	})
	Utility.applyRound(card, UDim.new(0, 12))
	local stroke = Utility.applyStroke(card, Library.Theme.Border, 1, 0.1)
	Utility.applyPadding(card, 14, 14, 12, 24)
	Utility.createGradient(card, Library.Theme.Panel, Library.Theme.PanelLight, 90)
	local cardScale = Utility.new("UIScale", {
		Scale = 0.92,
		Parent = card,
	})

		local titleContainer = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		Parent = card,
	})

	Utility.new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = titleContainer,
	})

	local title1 = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = Enum.Font.GothamMedium,
		Text = "aero",
		TextSize = 13,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = titleContainer,
	})

	local title2 = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		Font = Enum.Font.GothamMedium,
		Text = "Ware",
		TextSize = 13,
		TextColor3 = Library.Theme.Purple,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = titleContainer,
	})

	local body = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 24),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Font = Enum.Font.Gotham,
		TextWrapped = true,
		Text = message,
		TextSize = 12,
		TextColor3 = Library.Theme.TextSoft,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Parent = card,
	})

	local indicator = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(1, 5, 0, 0),
		Size = UDim2.new(0, 3, 1.25, 0),
		BackgroundColor3 = Library.Theme.Accent,
		Parent = card,
	})
	Utility.applyRound(indicator, UDim.new(1, 0))

	local progressBack = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1.2, 5),
		Size = UDim2.new(1, -16, 0, 3),
		BackgroundColor3 = Library.Theme.PanelDark,
		BackgroundTransparency = 0.2,
		Parent = card,
	})
	Utility.applyRound(progressBack, UDim.new(1, 0))

	local progressFill = Utility.new("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Library.Theme.Accent,
		Parent = progressBack,
	})
	Utility.applyRound(progressFill, UDim.new(1, 0))

	card.Position = UDim2.new(1, 28, 0, 0)
	card.BackgroundTransparency = 1
	stroke.Transparency = 1
	title1.TextTransparency = 1
	title2.TextTransparency = 1
	body.TextTransparency = 1
	indicator.BackgroundTransparency = 1
	progressBack.BackgroundTransparency = 1
	progressFill.BackgroundTransparency = withUi(0)

	Utility.tween(card, "Slow", {
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = withUi(0.03),
	})
	Utility.tween(cardScale, "Spring", { Scale = 1 })
	Utility.tween(stroke, "Normal", { Transparency = withUi(0.1) })
	Utility.tween(title1, "Normal", { TextTransparency = withUi(0) })
	Utility.tween(title2, "Normal", { TextTransparency = withUi(0) })
	Utility.tween(body, "Normal", { TextTransparency = withUi(0) })
	Utility.tween(indicator, "Normal", { BackgroundTransparency = withUi(0) })
	Utility.tween(progressBack, "Normal", { BackgroundTransparency = withUi(0.2) })
	Utility.tween(progressFill, TweenInfo.new(time, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 1,
	})

	task.delay(time, function()
		if not card.Parent then
			return
		end
		Utility.tween(card, "Slow", {
			Position = UDim2.new(1, 28, 0, 0),
			BackgroundTransparency = 1,
		})
		Utility.tween(cardScale, "Fast", { Scale = 0.96 })
		Utility.tween(stroke, "Fast", { Transparency = 1 })
		Utility.tween(title1, "Fast", { TextTransparency = 1 })
		Utility.tween(title2, "Fast", { TextTransparency = 1 })
		Utility.tween(body, "Fast", { TextTransparency = 1 })
		Utility.tween(indicator, "Fast", { BackgroundTransparency = 1 })
		Utility.tween(progressBack, "Fast", { BackgroundTransparency = 1 })
		Utility.tween(progressFill, "Fast", { BackgroundTransparency = 1 })

		task.delay(0.16, function()
			if not card or not card.Parent then
				return
			end
			local currentHeight = math.max(card.AbsoluteSize.Y, 30)
			card.AutomaticSize = Enum.AutomaticSize.None
			if cardSizeConstraint then
				cardSizeConstraint.MinSize = Vector2.new(0, 0)
			end
			card.Size = UDim2.new(1, 0, 0, currentHeight)
			Utility.tween(card, "Fast", { Size = UDim2.new(1, 0, 0, 0) })
		end)

		task.delay(0.34, function()
			if card then
				card:Destroy()
			end
		end)
	end)
	end

function Library:notifyConsole(consoleName, message)
	local console = self.Consoles[consoleName]
	if console then
		console:Log(message)
	end
end

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

local function createHeader(parent, title, description, iconName)
	local header = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 34),
		Parent = parent,
	})

	if iconName then
		local icon = Utility.makeIcon(iconName, header, 18, Library.Theme.Purple)
		icon.Position = UDim2.fromOffset(0, 2)
	end

	Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(iconName and 24 or 0, 0),
		Size = UDim2.new(1, iconName and -24 or 0, 0, 16),
		Font = Enum.Font.GothamMedium,
		Text = title,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Library.Theme.Text,
		Parent = header,
	})

	if description and description ~= "" then
		Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(iconName and 24 or 0, 16),
			Size = UDim2.new(1, iconName and -24 or 0, 0, 16),
			Font = Enum.Font.Gotham,
			Text = description,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = Library.Theme.TextMute,
			Parent = header,
		})
	end

	return header
end

function Tab:Show()
	for _, other in ipairs(Library.Tabs) do
		other.Page.Visible = false
		other.Active = false
		Utility.tween(other.ButtonIndicator, "Fast", { BackgroundTransparency = 1 })
		Utility.tween(other.ButtonTitle, "Fast", { TextColor3 = Library.Theme.TextMute })
		Utility.tween(other.ButtonIcon, "Fast", { ImageColor3 = Library.Theme.Purple })
		Utility.tween(other.ButtonFrame, "Fast", { BackgroundColor3 = Library.Theme.Sidebar })
		Utility.tween(other.ButtonFrame.UIStroke, "Fast", { Transparency = 1 })
		if other.ButtonArrow then
			Utility.tween(other.ButtonArrow, "Fast", { Rotation = 0, ImageColor3 = Library.Theme.Purple })
		end
	end

	self.Page.Visible = true
	self.Active = true
	Utility.tween(self.ButtonIndicator, "Fast", { BackgroundTransparency = 0 })
	Utility.tween(self.ButtonTitle, "Fast", { TextColor3 = Library.Theme.Text })
	Utility.tween(self.ButtonIcon, "Fast", { ImageColor3 = Library.Theme.Accent })
	Utility.tween(self.ButtonFrame, "Fast", { BackgroundColor3 = Library.Theme.Panel })
	Utility.tween(self.ButtonFrame.UIStroke, "Fast", { Transparency = 0.15 })
	if self.ButtonArrow then
		Utility.tween(self.ButtonArrow, "Fast", { Rotation = 90, ImageColor3 = Library.Theme.Accent })
	end
end

function Tab:AddSection(options)
	options = options or {}
	local targetColumn = self.NextColumn == 1 and self.LeftColumn or self.RightColumn
	self.NextColumn = self.NextColumn == 1 and 2 or 1

	local container = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.Panel,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = targetColumn,
	})
	Utility.applyRound(container, UDim.new(0, 10))
	Utility.applyStroke(container, Library.Theme.Purple, 1, 1)
	Utility.createGradient(container, Library.Theme.Panel, Library.Theme.PanelDark, 90)
	Utility.applyPadding(container, 12, 12, 12, 12)

	createHeader(container, options.Name or "Section", options.Description or "", options.Icon)

	local content = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 42),
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = container,
	})

	Utility.new("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = content,
	})

	local section = setmetatable({
		Tab = self,
		Frame = container,
		Content = content,
	}, Section)

	table.insert(Library.SearchIndex, {
		Name = options.Name or "Section",
		Type = "Section",
		Tab = self,
		Frame = container,
	})

	Utility.bindHover(container, function()
		Utility.tween(container.UIStroke, "Slow", { Transparency = 0.7 })
	end, function()
		Utility.tween(container.UIStroke, "Normal", { Transparency = 1 })
	end)

	return section
end

function Section:createRow(height)
	local row = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelLight,
		Size = UDim2.new(1, 0, 0, height or 42),
		Parent = self.Content,
	})
	Utility.applyRound(row, UDim.new(0, 8))
	Utility.applyStroke(row, Library.Theme.Border, 1, 0.12)
	Utility.applyPadding(row, 12, 12, 10, 10)
	return row
end

function Section:createLabelBlock(parent, title, subtitle, tooltip, rightReserve)
	rightReserve = math.max(64, tonumber(rightReserve) or 90)
	local holder = Utility.new("TextButton", {
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Size = UDim2.new(1, -rightReserve, 1, 0),
		Parent = parent,
	})

	Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 14),
		Font = Enum.Font.GothamMedium,
		Text = title,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = holder,
	})

	if subtitle and subtitle ~= "" then
		Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, 16),
			Size = UDim2.new(1, 0, 0, 14),
			Font = Enum.Font.Gotham,
			Text = subtitle,
			TextSize = 11,
			TextColor3 = Library.Theme.TextMute,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = holder,
		})
	end

	Library:trackTooltip(holder, tooltip)
	return holder
end

function Section:AddDisplay(options)
    options = options or {}
    local hasDescription = options.Description and options.Description ~= ""
    local row = self:createRow(hasDescription and 60 or 38)
    self:createLabelBlock(row, options.Name or "Display", options.Description, options.Tooltip, 132)

    local valueLabel = Utility.new("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, 0, hasDescription and 0.75 or 0.5, 0),
        Size = UDim2.new(0, 120, 0, 18),
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamMedium,
        Text = tostring(options.Value or "--"),
        TextSize = 12,
        TextColor3 = Library.Theme.AccentSoft,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    })

    local entry = {}
    function entry:SetValue(value)
        valueLabel.Text = tostring(value)
    end
    function entry:GetValue()
        return valueLabel.Text
    end
    table.insert(Library.SearchIndex, { Name = options.Name or "Display", Type = "Display", Tab = self.Tab, Frame = row })
    return entry
end

function Section:AddButton(options)
	options = options or {}
	local hasDescription = options.Description and options.Description ~= ""
	local row = self:createRow(hasDescription and 60 or 38)
	local buttonWidth = options.Width or 84
	self:createLabelBlock(row, options.Name or "Button", options.Description, options.Tooltip, buttonWidth + 16)

	local button = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, hasDescription and 0.75 or 0.5, 0),
		Size = UDim2.fromOffset(buttonWidth, 26),
		BackgroundColor3 = Library.Theme.Background,
		BackgroundTransparency = 0,
		Text = options.ButtonText or options.Name or "Run",
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		TextTransparency = 0,
		AutoButtonColor = false,
		Parent = row,
	})
	Utility.applyRound(button, UDim.new(0, 7))
	Utility.applyStroke(button, Library.Theme.Purple, 1, 0.12)

	Utility.bindHover(button, function()
		Utility.tween(button, "Fast", { BackgroundColor3 = Library.Theme.PanelDark })
	end, function()
		Utility.tween(button, "Fast", { BackgroundColor3 = Library.Theme.Background })
	end)

	button.MouseButton1Click:Connect(function()
				Utility.tween(button, "Click", { Size = UDim2.fromOffset(buttonWidth - 3, 23) })
				task.delay(0.05, function()
					Utility.tween(button, "Click", { Size = UDim2.fromOffset(buttonWidth, 26) })
				end)
		if isCallable(options.Callback) then
			options.Callback() --stack 4
		end
	end)

	table.insert(Library.SearchIndex, { Name = options.Name or "Button", Type = "Button", Tab = self.Tab, Frame = row })
	return {
		Press = function()
			button:Activate()
		end,
		GetValue = function()
			return false
		end,
		Save = false,
	}
end

function Section:AddInput(options)
	options = options or {}
	local value = tostring(options.Default or "")
	local inputWidth = options.Width or (isSmallViewport() and 120 or 170)
	local hasDescription = options.Description and options.Description ~= ""

	local row = self:createRow(hasDescription and 60 or 38)
	self:createLabelBlock(row, options.Name or "Input", options.Description, options.Tooltip, inputWidth + 18)

	local box = Utility.new("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, hasDescription and 0.75 or 0.5, 0),
		Size = UDim2.fromOffset(inputWidth, 26),
		BackgroundColor3 = Library.Theme.PanelDark,
		ClearTextOnFocus = false,
		PlaceholderText = tostring(options.Placeholder or "Type..."),
		PlaceholderColor3 = Library.Theme.TextMute,
		Text = value,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	Utility.applyRound(box, UDim.new(0, 7))
	Utility.applyStroke(box, Library.Theme.Purple, 1, 0.12)
	Utility.applyPadding(box, 8, 8, 0, 0)

	local entry = {
		Save = options.Save ~= false,
	}

	function entry:SetValue(newValue, fromLoad, suppressCallback)
		value = tostring(newValue or "")
		box.Text = value
		if options.Flag then
			Library:updateFlag(options.Flag, value)
		end
		if not suppressCallback and isCallable(options.Callback) then
			options.Callback(value, fromLoad == true)
		end
	end

	function entry:GetValue()
		return value
	end

	box.FocusLost:Connect(function(enterPressed)
		entry:SetValue(box.Text)
		if enterPressed and isCallable(options.OnEnter) then
			options.OnEnter(value)
		end
	end)

	if options.Flag then
		Library:registerFlag(options.Flag, entry)
	end

	entry:SetValue(value, true, true)
	entry.Box = box
	table.insert(Library.SearchIndex, { Name = options.Name or "Input", Type = "Input", Tab = self.Tab, Frame = row })
	return entry
end

function Section:AddDropdown(options)
	options = options or {}
	local dropdownWidth = options.Width or (isSmallViewport() and 130 or 190)
	local hasDescription = options.Description and options.Description ~= ""
	local multiSelect = options.MultiSelect == true
	local choices = {}
	for _, choice in ipairs(options.Options or {}) do
		table.insert(choices, tostring(choice))
	end

	local function copyList(list)
		local result = {}
		for _, value in ipairs(list or {}) do
			table.insert(result, tostring(value))
		end
		return result
	end

	local function collectMultiValues(value)
		local result = {}
		local seen = {}
		if type(value) == "table" then
			for _, entryValue in ipairs(value) do
				local text = tostring(entryValue or "")
				if text ~= "" and not seen[text] then
					seen[text] = true
					table.insert(result, text)
				end
			end
		elseif value ~= nil then
			local text = tostring(value)
			if text ~= "" then
				table.insert(result, text)
			end
		end
		return result
	end

	local selected = multiSelect and collectMultiValues(options.Default) or ""
	if not multiSelect then
		if options.Default ~= nil and tostring(options.Default) ~= "" then
			selected = tostring(options.Default)
		elseif #choices > 0 then
			selected = choices[1]
		end
	end
	local selectedLookup = {}

	local root = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Content,
	})

	Utility.new("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = root,
	})

	local row = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelLight,
		Size = UDim2.new(1, 0, 0, hasDescription and 60 or 38),
		Parent = root,
	})
	Utility.applyRound(row, UDim.new(0, 8))
	Utility.applyStroke(row, Library.Theme.Border, 1, 0.12)
	Utility.applyPadding(row, 12, 12, 10, 10)
	self:createLabelBlock(row, options.Name or "Dropdown", options.Description, options.Tooltip, dropdownWidth + 18)

	local button = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, hasDescription and 0.75 or 0.5, 0),
		Size = UDim2.fromOffset(145, 26),
		BackgroundColor3 = Library.Theme.Panel,
		BackgroundTransparency = 0,
		Text = "",
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		TextTransparency = 0,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		Parent = row,
	})
	Utility.applyRound(button, UDim.new(0, 7))
	local buttonStroke = Utility.applyStroke(button, Library.Theme.Purple, 1, 0.02)
	Utility.applyPadding(button, 8, 26, 0, 0)

	local _arrowDivider = Utility.new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 12.5, 0.5, 0),
		Size = UDim2.fromOffset(1.5, 13),
		BackgroundColor3 = Library.Theme.Purple,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Parent = button,
	})

	local arrowIcon = Utility.makeIcon("chevron-right", button, 14, Library.Theme.Purple)
	arrowIcon.AnchorPoint = Vector2.new(1, 0.5)
	arrowIcon.Position = UDim2.new(1, 11.5, 0.5, 0)
	local arrowScale = Utility.new("UIScale", {
		Scale = 1,
		Parent = arrowIcon,
	})

	local panelRow = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelDark,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		Visible = false,
		Parent = root,
	})
	Utility.applyRound(panelRow, UDim.new(0, 8))
	local panelStroke = Utility.applyStroke(panelRow, Library.Theme.Border, 1, 1)

	local panel = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 152),
		Parent = panelRow,
	})

	local searchBox = Utility.new("TextBox", {
		Position = UDim2.fromOffset(8, 8),
		Size = UDim2.new(1, multiSelect and -82 or -16, 0, 24),
		BackgroundColor3 = Library.Theme.PanelDark,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		PlaceholderText = tostring(options.SearchPlaceholder or "Search..."),
		PlaceholderColor3 = Library.Theme.TextMute,
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = panel,
	})
	Utility.applyRound(searchBox, UDim.new(0, 6))
	Utility.applyStroke(searchBox, Library.Theme.Purple, 1, 0.18)
	Utility.applyPadding(searchBox, 6, 6, 0, 0)

	local clearButton = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 8),
		Size = UDim2.fromOffset(58, 24),
		BackgroundColor3 = Library.Theme.Panel,
		BorderSizePixel = 0,
		Text = "Clear",
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = Library.Theme.TextSoft,
		Visible = multiSelect,
		AutoButtonColor = false,
		Parent = panel,
	})
	Utility.applyRound(clearButton, UDim.new(0, 6))
	local clearButtonStroke = Utility.applyStroke(clearButton, Library.Theme.Border, 1, 0.16)

	local scroll = Utility.new("ScrollingFrame", {
		Position = UDim2.fromOffset(0, 40),
		Size = UDim2.new(1, 0, 1, -40),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Library.Theme.AccentSoft,
		ScrollBarImageTransparency = 0.45,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = panel,
	})

	local listLayout = Utility.new("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = scroll,
	})
	Utility.new("UIPadding", {
		PaddingTop = UDim.new(0, 8),
		PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		Parent = scroll,
	})

	listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		scroll.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y + 16)
	end)

	local optionButtons = {}
	local open = false
	local activeTween
	local placeholder = tostring(options.Placeholder or "Select")
	local searchable = options.Searchable ~= false
	local function rebuildSelectedLookup()
		table.clear(selectedLookup)
		if multiSelect then
			for _, value in ipairs(selected) do
				selectedLookup[value] = true
			end
		end
	end

	local function normalizeMultiSelection(values)
		local choiceSet = {}
		for _, option in ipairs(choices) do
			choiceSet[option] = true
		end

		local result = {}
		local seen = {}
		for _, value in ipairs(values or {}) do
			local text = tostring(value or "")
			if text ~= "" and not seen[text] and (#choices == 0 or choiceSet[text]) then
				seen[text] = true
				table.insert(result, text)
			end
		end

		if #choices == 0 then
			return result
		end

		local ordered = {}
		for _, option in ipairs(choices) do
			if seen[option] then
				table.insert(ordered, option)
			end
		end
		return ordered
	end

	searchBox.Visible = searchable
	if not searchable then
		scroll.Position = UDim2.fromOffset(0, 6)
		scroll.Size = UDim2.new(1, 0, 1, -6)
	end

	local function updateButtonText()
		local hasSelection = multiSelect and #selected > 0 or selected ~= ""
		if multiSelect then
			if #selected == 0 then
				button.Text = placeholder
			elseif #selected == 1 then
				button.Text = selected[1]
			else
				button.Text = tostring(#selected) .. " selected"
			end
		else
			button.Text = hasSelection and selected or placeholder
		end
		button.TextColor3 = hasSelection and Library.Theme.Text or Library.Theme.TextSoft
		clearButton.TextColor3 = hasSelection and Library.Theme.Text or Library.Theme.TextMute
		clearButton.BackgroundTransparency = hasSelection and 0 or 0.18
		clearButtonStroke.Transparency = hasSelection and 0.06 or 0.28
	end

	local function refreshOptionStates()
		for _, optionRecord in ipairs(optionButtons) do
			local isSelected = multiSelect and selectedLookup[optionRecord.Value] == true or selected == optionRecord.Value
			optionRecord.Button.BackgroundColor3 = isSelected and Library.Theme.PanelLight or Library.Theme.PanelDark
			optionRecord.Button.TextColor3 = isSelected and Library.Theme.Text or Library.Theme.TextSoft
			optionRecord.Stroke.Transparency = isSelected and 0.04 or 0.2
		end
	end

	local function refreshDropdownVisual()
		Utility.tween(arrowIcon, "Fast", {
			Rotation = open and 90 or 0,
			ImageColor3 = open and Library.Theme.AccentSoft or Library.Theme.TextMute,
		})
		Utility.tween(arrowScale, "Pulse", { Scale = open and 1.18 or 1 })
		Utility.tween(button, "Fast", {
			BackgroundColor3 = open and Library.Theme.PanelLight or Library.Theme.Panel,
		})
		Utility.tween(buttonStroke, "Fast", {
			Transparency = open and 0 or 0.02,
		})
	end

	local function applyFilter(query)
		local needle = string.lower(query or "")
		for _, optionRecord in ipairs(optionButtons) do
			local haystack = string.lower(optionRecord.Value)
			optionRecord.Button.Visible = needle == "" or string.find(haystack, needle, 1, true) ~= nil
		end
	end

	local function setOpen(state)
		open = state == true
		updateButtonText()
		refreshDropdownVisual()
		if open then
			panelRow.Visible = true
		end
		if activeTween then
			activeTween:Cancel()
		end
		Utility.tween(panelRow, "Fast", {
			BackgroundTransparency = open and 0.1 or 1,
		})
		Utility.tween(panelStroke, "Fast", {
			Transparency = open and 0.1 or 1,
		})
		activeTween = TweenService:Create(panelRow, Library.Tweens.Normal, {
			Size = UDim2.new(1, 0, 0, open and 152 or 0),
		})
		activeTween:Play()
		if not open then
			activeTween.Completed:Once(function()
				if not open then
					panelRow.Visible = false
				end
			end)
		end
	end

	local entry = {
		Save = options.Save ~= false,
	}

	function entry:SetValue(newValue, fromLoad, suppressCallback)
		if multiSelect then
			selected = normalizeMultiSelection(collectMultiValues(newValue))
			rebuildSelectedLookup()
		else
			selected = tostring(newValue or "")
		end
		updateButtonText()
		refreshOptionStates()
		if options.Flag then
			Library:updateFlag(options.Flag, multiSelect and normalizeForSave(selected) or selected)
		end
		if not suppressCallback and isCallable(options.Callback) then
			options.Callback(multiSelect and copyList(selected) or selected, fromLoad == true)
		end
	end

	function entry:GetValue()
		return multiSelect and copyList(selected) or selected
	end

	local function rebuildOptions()
		for _, old in ipairs(optionButtons) do
			old.Button:Destroy()
		end
		table.clear(optionButtons)

		for _, option in ipairs(choices) do
			local optionButton = Utility.new("TextButton", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = Library.Theme.PanelDark,
				BackgroundTransparency = 0,
				Text = option,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextColor3 = Library.Theme.Text,
				TextTransparency = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutoButtonColor = false,
				Parent = scroll,
			})
			Utility.applyRound(optionButton, UDim.new(0, 6))
			local optionStroke = Utility.applyStroke(optionButton, Library.Theme.Border, 1, 0.2)
			Utility.applyPadding(optionButton, 8, 8, 0, 0)

			optionButton.MouseButton1Click:Connect(function()
				if multiSelect then
					local nextSelected = copyList(selected)
					if selectedLookup[option] then
						for index = #nextSelected, 1, -1 do
							if nextSelected[index] == option then
								table.remove(nextSelected, index)
							end
						end
					else
						table.insert(nextSelected, option)
					end
					entry:SetValue(nextSelected)
				else
					entry:SetValue(option)
				end
				if not multiSelect and options.CloseOnSelect ~= false then
					setOpen(false)
				end
			end)

			table.insert(optionButtons, {
				Button = optionButton,
				Stroke = optionStroke,
				Value = option,
			})
		end

		refreshOptionStates()
		applyFilter(searchable and searchBox.Text or "")
	end

	function entry:SetOptions(newOptions, keepCurrent)
		local resolvedChoices = {}
		local seenChoices = {}
		for _, option in ipairs(newOptions or {}) do
			local text = tostring(option or "")
			if text ~= "" and not seenChoices[text] then
				seenChoices[text] = true
				table.insert(resolvedChoices, text)
			end
		end
		table.sort(resolvedChoices)

		local didChange = #resolvedChoices ~= #choices
		if not didChange then
			for index, value in ipairs(resolvedChoices) do
				if choices[index] ~= value then
					didChange = true
					break
				end
			end
		end

		choices = resolvedChoices
		if didChange or #optionButtons == 0 then
			rebuildOptions()
		end

		if multiSelect then
			if #choices == 0 then
				if not keepCurrent or #selected == 0 then
					entry:SetValue({}, true, true)
				else
					entry:SetValue(selected, true, true)
				end
				return
			end

			if keepCurrent then
				entry:SetValue(selected, true, true)
			else
				entry:SetValue({}, true, true)
			end
			return
		end

		if #choices == 0 then
			if not keepCurrent or selected == "" then
				entry:SetValue("", true, true)
			end
			return
		end

		if keepCurrent then
			for _, option in ipairs(choices) do
				if option == selected then
					return
				end
			end
		end

		entry:SetValue(choices[1], true, true)
	end

	clearButton.MouseButton1Click:Connect(function()
		if multiSelect then
			entry:SetValue({})
		end
	end)

	Utility.bindHover(clearButton, function()
		Utility.tween(clearButton, "Fast", { BackgroundColor3 = Library.Theme.PanelLight })
	end, function()
		Utility.tween(clearButton, "Fast", { BackgroundColor3 = Library.Theme.Panel })
	end)

	button.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)

	Utility.bindHover(button, function()
		if not open then
			Utility.tween(button, "Fast", { BackgroundColor3 = Library.Theme.PanelLight })
		end
	end, function()
		if not open then
			Utility.tween(button, "Fast", { BackgroundColor3 = Library.Theme.Panel })
		end
	end)

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if searchable then
			applyFilter(searchBox.Text)
		end
	end)

	entry:SetOptions(choices, true)
	if multiSelect and #selected > 0 or (not multiSelect and selected ~= "") then
		entry:SetValue(selected, true, true)
	end
	setOpen(false)
	refreshDropdownVisual()
	if options.Flag then
		Library:registerFlag(options.Flag, entry)
	end
	table.insert(Library.SearchIndex, { Name = options.Name or "Dropdown", Type = "Dropdown", Tab = self.Tab, Frame = row })
	return entry
end

function Section:AddToggle(options)
	options = options or {}
	local value = options.Default == true
	local hasDescription = options.Description and options.Description ~= ""
	local row = self:createRow(hasDescription and 60 or 38)
	self:createLabelBlock(row, options.Name or "Toggle", options.Description, options.Tooltip, 60)

	local holder = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, hasDescription and 0.75 or 0.5, 0),
		Size = UDim2.fromOffset(44, 24),
		BackgroundColor3 = value and Library.Theme.Purple or Library.Theme.Background,
		BackgroundTransparency = 0,
		Text = "",
		TextTransparency = 0,
		AutoButtonColor = false,
		Parent = row,
	})
	Utility.applyRound(holder, UDim.new(1, 0))
	Utility.applyStroke(holder, Library.Theme.Border, 1, 0.12)

	local knob = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(value and 22 or 2, 12),
		Size = UDim2.fromOffset(20, 20),
		BackgroundColor3 = value and Library.Theme.Background or Library.Theme.Purple,
		BackgroundTransparency = 0,
		Parent = holder,
	})
	Utility.applyRound(knob, UDim.new(1, 0))
	local knobScale = Utility.new("UIScale", {
		Scale = 1,
		Parent = knob,
	})

	local entry = {
		Save = options.Save ~= false,
	}

	function entry:SetValue(newValue, fromLoad)
		value = newValue == true
		Utility.tween(holder, "Fast", {
			BackgroundColor3 = value and Library.Theme.Purple or Library.Theme.Background,
		})
		Utility.tween(knob, "Fast", {
			Position = UDim2.fromOffset(value and 22 or 2, 12),
			BackgroundColor3 = value and Library.Theme.Background or Library.Theme.Purple,
		})
		Utility.tween(knobScale, "Pulse", { Scale = 1.1 })
		task.delay(0.09, function()
			Utility.tween(knobScale, "Pulse", { Scale = 1 })
		end)
		if options.Flag then
			Library:updateFlag(options.Flag, value)
		end
		if isCallable(options.Callback) then
			options.Callback(value, fromLoad == true)
		end
	end

	function entry:GetValue()
		return value
	end

	holder.MouseButton1Click:Connect(function()
		entry:SetValue(not value)
	end)

	if options.Flag then
		Library:registerFlag(options.Flag, entry)
	end

	entry:SetValue(value, true)
	table.insert(Library.SearchIndex, { Name = options.Name or "Toggle", Type = "Toggle", Tab = self.Tab, Frame = row })
	return entry
end

function Section:AddSlider(options)
	options = options or {}
	local minimum = options.Min or 0
	local maximum = options.Max or 100
	local decimals = options.Decimals or 0
	local suffix = options.Suffix or ""
	local value = options.Default or minimum
	local dragging = false
	local editable = options.Editable == true or options.editable == true
	local noLimit = options.NoLimit == true or options.nolimit == true

	local row = self:createRow(66)
	self:createLabelBlock(row, options.Name or "Slider", options.Description, options.Tooltip, editable and 100 or 90)

	local valueDisplay = Utility.new(editable and "TextBox" or "TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		Size = UDim2.fromOffset(80, 16),
		BackgroundTransparency = editable and 0 or 1,
		BackgroundColor3 = editable and Library.Theme.PanelDark or nil,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Text = "",
		TextSize = 12,
		TextColor3 = Library.Theme.AccentSoft,
		TextXAlignment = Enum.TextXAlignment.Right,
		Parent = row,
	})
	if editable then
		valueDisplay.ClearTextOnFocus = false
		Utility.applyRound(valueDisplay, UDim.new(0, 6))
		Utility.applyStroke(valueDisplay, Library.Theme.Border, 1, 0.12)
		Utility.applyPadding(valueDisplay, 8, 8, 0, 0)
	end

	local bar = Utility.new("Frame", {
		Position = UDim2.fromOffset(0, 38),
		Size = UDim2.new(1, 0, 0, 12),
		BackgroundColor3 = Library.Theme.Background,
		Parent = row,
	})
	Utility.applyRound(bar, UDim.new(1, 0))
	Utility.applyStroke(bar, Library.Theme.Border, 1, 0.16)

	local fill = Utility.new("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Library.Theme.PanelDark,
		BackgroundTransparency = 0,
		Parent = bar,
	})
	Utility.applyRound(fill, UDim.new(1, 0))
	Utility.applyStroke(fill, Library.Theme.Purple, 1, 0.8)

	local knob = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Library.Theme.Background,
		BackgroundTransparency = 0,
		Parent = bar,
	})
	Utility.applyRound(knob, UDim.new(1, 0))
	Utility.applyStroke(knob, Library.Theme.Purple, 1.4, 0.05)
	local knobScale = Utility.new("UIScale", {
		Scale = 1,
		Parent = knob,
	})

	local entry = {
		Save = options.Save ~= false,
	}

	local function sanitizeValue(number)
		local scalar = 10 ^ decimals
		local rounded = math.round((tonumber(number) or minimum) * scalar) / scalar
		if noLimit then
			return rounded
		end
		return math.clamp(rounded, minimum, maximum)
	end

	local function getVisualPercent(number)
		local visualValue = math.clamp(number, minimum, maximum)
		if maximum == minimum then
			return 0
		end
		return (visualValue - minimum) / (maximum - minimum)
	end

	local function getDisplayText(number)
		return formatValue(number) .. suffix
	end

	local function syncDisplay(number)
		valueDisplay.Text = getDisplayText(number)
	end

	local function parseDisplayValue(text)
		local numeric = tostring(text or ""):match("[-+]?%d*%.?%d+")
		return tonumber(numeric)
	end

	local function updateFromPercent(percent, fromLoad)
		entry:SetValue(minimum + ((maximum - minimum) * percent), fromLoad)
	end

	function entry:SetValue(newValue, fromLoad)
		value = sanitizeValue(newValue)
		local percent = getVisualPercent(value)
		Utility.tween(fill, "Fast", { Size = UDim2.new(percent, 0, 1, 0) })
		Utility.tween(knob, "Fast", { Position = UDim2.new(percent, 0, 0.5, 0) })
		syncDisplay(value)
		if options.Flag then
			Library:updateFlag(options.Flag, value)
		end
		if isCallable(options.Callback) then
			options.Callback(value, fromLoad == true)
		end
	end

	function entry:GetValue()
		return value
	end

	local function updateFromInput(inputPosition)
		local percent = math.clamp((inputPosition.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
		updateFromPercent(percent)
	end

	if editable then
		valueDisplay.FocusLost:Connect(function()
			local parsed = parseDisplayValue(valueDisplay.Text)
			if parsed ~= nil then
				entry:SetValue(parsed)
			else
				syncDisplay(value)
			end
		end)
	end

	bar.InputBegan:Connect(function(input)
		if isInputDragStart(input) then
			dragging = true
			Utility.tween(knobScale, "Pulse", { Scale = 1.35 })
			--Utility.tween(fill.UIStroke, "Fast", { Transparency = 0.4 })
			updateFromInput(input.Position)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and isInputDragMove(input) then
			updateFromInput(input.Position)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if isInputDragEnd(input) then
			dragging = false
			Utility.tween(knobScale, "Pulse", { Scale = 1 })
			--Utility.tween(fill.UIStroke, "Fast", { Transparency = 0.7 })
		end
	end)

	if options.Flag then
		Library:registerFlag(options.Flag, entry)
	end
	entry:SetValue(value, true)
	table.insert(Library.SearchIndex, { Name = options.Name or "Slider", Type = "Slider", Tab = self.Tab, Frame = row })
	return entry
end

function Section:AddColorWheel(options)
	options = options or {}
	local defaultColor = parseColorString(options.Default) or Color3.fromRGB(255, 255, 255)
	local hsvH, hsvS, hsvV = Color3.toHSV(defaultColor)
	local currentColor = defaultColor
	local rgbMode = options.DefaultRGBMode == true
	local draggingWheel = false
	local open = false

	local root = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.Content,
	})

	Utility.new("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = root,
	})

	local row = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelLight,
		Size = UDim2.new(1, 0, 0, (options.Description and options.Description ~= "") and 60 or 38),
		Parent = root,
	})
	Utility.applyRound(row, UDim.new(0, 8))
	Utility.applyStroke(row, Library.Theme.Border, 1, 0.12)
	Utility.applyPadding(row, 12, 12, 10, 10)
	self:createLabelBlock(row, options.Name or "Color Wheel", options.Description, options.Tooltip, 170)

	local swatchButton = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, (options.Description and options.Description ~= "") and 0.75 or 0.5, 0),
		Size = UDim2.fromOffset(154, 26),
		BackgroundColor3 = Library.Theme.Panel,
		BackgroundTransparency = 0,
		Text = "",
		TextTransparency = 0,
		AutoButtonColor = false,
		Parent = row,
	})
	Utility.applyRound(swatchButton, UDim.new(0, 7))
	local swatchStroke = Utility.applyStroke(swatchButton, Library.Theme.Purple, 1, 0.1)

	local swatchColor = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromOffset(6, 13),
		Size = UDim2.fromOffset(28, 16),
		BackgroundColor3 = currentColor,
		Parent = swatchButton,
	})
	Utility.applyRound(swatchColor, UDim.new(0, 4))
	Utility.applyStroke(swatchColor, Library.Theme.Border, 1, 0.18)

	local swatchText = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(40, 0),
		Size = UDim2.new(1, -64, 1, 0),
		Text = colorToHex(currentColor),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = swatchButton,
	})

	local swatchArrow = Utility.makeIcon("chevron-right", swatchButton, 14, Library.Theme.Purple)
	swatchArrow.AnchorPoint = Vector2.new(1, 0.5)
	swatchArrow.Position = UDim2.new(1, -8, 0.5, 0)

	local panelRow = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelDark,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ClipsDescendants = true,
		Visible = false,
		Parent = root,
	})
	Utility.applyRound(panelRow, UDim.new(0, 8))
	local panelStroke = Utility.applyStroke(panelRow, Library.Theme.Border, 1, 1)

	local panel = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 196),
		Parent = panelRow,
	})

	local wheel = Utility.new("ImageLabel", {
		Position = UDim2.fromOffset(10, 12),
		Size = UDim2.fromOffset(116, 116),
		BackgroundTransparency = 1,
		Image = "rbxassetid://6042339459",
		ScaleType = Enum.ScaleType.Stretch,
		Parent = panel,
	})

	local wheelOverlay = Utility.new("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = wheel,
	})

	local selector = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(10, 10),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		Parent = wheel,
	})
	Utility.applyRound(selector, UDim.new(1, 0))
	Utility.applyStroke(selector, Color3.fromRGB(0, 0, 0), 1, 0.12)

	local liveWheelColor = Utility.new("Frame", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 12),
		Size = UDim2.fromOffset(52, 52),
		BackgroundColor3 = currentColor,
		Parent = panel,
	})
	Utility.applyRound(liveWheelColor, UDim.new(0, 8))
	Utility.applyStroke(liveWheelColor, Library.Theme.Border, 1, 0.08)

	local rgbButton = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 70),
		Size = UDim2.fromOffset(52, 22),
		BackgroundColor3 = Library.Theme.Panel,
		BackgroundTransparency = 0,
		Text = "RGB",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = Library.Theme.TextSoft,
		TextTransparency = 0,
		AutoButtonColor = false,
		Parent = panel,
	})
	Utility.applyRound(rgbButton, UDim.new(0, 5))
	Utility.applyStroke(rgbButton, Library.Theme.Border, 1, 0.08)

	local rgbRow = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(10, 136),
		Size = UDim2.new(1, -20, 0, 50),
		Parent = panel,
	})

	local function makeRgbBox(label, x)
		local holder = Utility.new("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(x, 0),
			Size = UDim2.fromOffset(84, 50),
			Parent = rgbRow,
		})

		Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 12),
			Text = label,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextColor3 = Library.Theme.TextMute,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = holder,
		})

		local box = Utility.new("TextBox", {
			Position = UDim2.fromOffset(0, 16),
			Size = UDim2.fromOffset(78, 24),
			BackgroundColor3 = Library.Theme.Panel,
			ClearTextOnFocus = false,
			Text = "255",
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextColor3 = Library.Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Center,
			Parent = holder,
		})
		Utility.applyRound(box, UDim.new(0, 5))
		Utility.applyStroke(box, Library.Theme.Border, 1, 0.12)

		return box
	end

	local rBox = makeRgbBox("R", 0)
	local gBox = makeRgbBox("G", 90)
	local bBox = makeRgbBox("B", 180)

	local entry = {
		Save = options.Save ~= false,
	}

	local modeEntry = {
		Save = options.Save ~= false,
	}

	local function updateSelectorPosition()
		local radius = (wheel.AbsoluteSize.X * 0.5) - 6
		local angle = hsvH * (math.pi * 2)
		local satRadius = radius * hsvS
		local center = Vector2.new(wheel.AbsoluteSize.X * 0.5, wheel.AbsoluteSize.Y * 0.5)
		local pos = center + Vector2.new(math.cos(angle), math.sin(angle)) * satRadius
		selector.Position = UDim2.fromOffset(pos.X, pos.Y)
	end

	local function applyDisplayColor()
		currentColor = Color3.fromHSV(hsvH, hsvS, hsvV)
		swatchColor.BackgroundColor3 = currentColor
		liveWheelColor.BackgroundColor3 = currentColor
		local hex = colorToHex(currentColor)
		swatchText.Text = hex
		rBox.Text = tostring(math.floor((currentColor.R * 255) + 0.5))
		gBox.Text = tostring(math.floor((currentColor.G * 255) + 0.5))
		bBox.Text = tostring(math.floor((currentColor.B * 255) + 0.5))
		updateSelectorPosition()
	end

	local function refreshRgbButton()
		Utility.tween(rgbButton, "Fast", {
			BackgroundColor3 = rgbMode and Library.Theme.Accent or Library.Theme.Panel,
			TextColor3 = rgbMode and Library.Theme.Background or Library.Theme.TextSoft,
		})
	end

	local function refreshOpenVisuals()
		Utility.tween(swatchArrow, "Fast", {
			Rotation = open and 90 or 0,
			ImageColor3 = open and Library.Theme.AccentSoft or Library.Theme.TextMute,
		})
		Utility.tween(swatchButton, "Fast", {
			BackgroundColor3 = open and Library.Theme.PanelLight or Library.Theme.Panel,
		})
		Utility.tween(swatchStroke, "Fast", {
			Transparency = open and 0 or 0.1,
		})
	end

	local function setOpen(state)
		open = state == true
		if open then
			panelRow.Visible = true
		end
		refreshOpenVisuals()
		Utility.tween(panelRow, "Fast", { BackgroundTransparency = open and 0.1 or 1 })
		Utility.tween(panelStroke, "Fast", { Transparency = open and 0.1 or 1 })
		local tween = TweenService:Create(panelRow, Library.Tweens.Normal, {
			Size = UDim2.new(1, 0, 0, open and 196 or 0),
		})
		tween:Play()
		if not open then
			tween.Completed:Once(function()
				if not open then
					panelRow.Visible = false
				end
			end)
		end
	end

	function modeEntry:SetValue(newValue, fromLoad)
		rgbMode = newValue == true
		if options.ModeFlag then
			Library:updateFlag(options.ModeFlag, rgbMode)
		end
		refreshRgbButton()
		if isCallable(options.Callback) then
			options.Callback(currentColor, rgbMode, fromLoad == true)
		end
	end

	function modeEntry:GetValue()
		return rgbMode
	end

	function entry:SetValue(newValue, fromLoad, suppressCallback)
		local parsed = parseColorString(newValue)
		if not parsed then
			parsed = currentColor
		end
		hsvH, hsvS, hsvV = Color3.toHSV(parsed)
		applyDisplayColor()
		if options.Flag then
			Library:updateFlag(options.Flag, colorToHex(currentColor))
		end
		if not suppressCallback and isCallable(options.Callback) then
			options.Callback(currentColor, rgbMode, fromLoad == true)
		end
	end

	function entry:GetValue()
		return colorToHex(currentColor)
	end

	local function updateFromInput(position)
		local center = wheel.AbsolutePosition + (wheel.AbsoluteSize * 0.5)
		local offset = Vector2.new(position.X, position.Y) - center
		local radius = math.max(1, (wheel.AbsoluteSize.X * 0.5) - 1)
		if offset.Magnitude > radius and offset.Magnitude > 0 then
			offset = offset.Unit * radius
		end
		local distance = math.min(offset.Magnitude, radius)
		hsvS = math.clamp(distance / radius, 0, 1)
		hsvH = (math.atan2(offset.Y, offset.X) / (math.pi * 2)) % 1
		if rgbMode then
			modeEntry:SetValue(false)
		end
		entry:SetValue(Color3.fromHSV(hsvH, hsvS, hsvV))
	end

	local function applyFromRgbBoxes()
		local r = math.clamp(tonumber(rBox.Text) or math.floor((currentColor.R * 255) + 0.5), 0, 255)
		local g = math.clamp(tonumber(gBox.Text) or math.floor((currentColor.G * 255) + 0.5), 0, 255)
		local b = math.clamp(tonumber(bBox.Text) or math.floor((currentColor.B * 255) + 0.5), 0, 255)
		if rgbMode then
			modeEntry:SetValue(false)
		end
		entry:SetValue(Color3.fromRGB(r, g, b))
	end

	wheelOverlay.InputBegan:Connect(function(input)
		if isInputDragStart(input) then
			draggingWheel = true
			updateFromInput(input.Position)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if draggingWheel and isInputDragMove(input) then
			updateFromInput(input.Position)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if isInputDragEnd(input) then
			draggingWheel = false
		end
	end)

	rBox.FocusLost:Connect(function()
		applyFromRgbBoxes()
	end)
	gBox.FocusLost:Connect(function()
		applyFromRgbBoxes()
	end)
	bBox.FocusLost:Connect(function()
		applyFromRgbBoxes()
	end)

	rgbButton.MouseButton1Click:Connect(function()
		modeEntry:SetValue(not rgbMode)
	end)

	swatchButton.MouseButton1Click:Connect(function()
		setOpen(not open)
	end)

	Utility.bindHover(swatchButton, function()
		if not open then
			Utility.tween(swatchButton, "Fast", { BackgroundColor3 = Library.Theme.PanelLight })
		end
	end, function()
		if not open then
			Utility.tween(swatchButton, "Fast", { BackgroundColor3 = Library.Theme.Panel })
		end
	end)

	if options.Flag then
		Library:registerFlag(options.Flag, entry)
	end
	if options.ModeFlag then
		Library:registerFlag(options.ModeFlag, modeEntry)
	end

	entry:SetValue(currentColor, true, true)
	modeEntry:SetValue(rgbMode, true)
	refreshRgbButton()
	setOpen(false)

	local rainbowConn = RunService.RenderStepped:Connect(function()
		if rgbMode and Library.RainbowColor then
			currentColor = Library.RainbowColor
			swatchColor.BackgroundColor3 = currentColor
			liveWheelColor.BackgroundColor3 = currentColor
			swatchText.Text = colorToHex(currentColor)
			rBox.Text = tostring(math.floor((currentColor.R * 255) + 0.5))
			gBox.Text = tostring(math.floor((currentColor.G * 255) + 0.5))
			bBox.Text = tostring(math.floor((currentColor.B * 255) + 0.5))
		end
	end)
	root.Destroying:Connect(function()
		if rainbowConn then
			rainbowConn:Disconnect()
			rainbowConn = nil
		end
	end)

	table.insert(Library.SearchIndex, { Name = options.Name or "Color Wheel", Type = "Color", Tab = self.Tab, Frame = row })
	return entry
end

function Section:AddKeybind(options)
	options = options or {}
	local waiting = false
	local value = (options.Default and asInputName(options.Default)) or "RightShift"
	local unboundValue = "None"
	local hasDescription = options.Description and options.Description ~= ""

	local _keybindWidth = isSmallViewport() and 80 or 110
	local row = self:createRow(hasDescription and 60 or 38)
	self:createLabelBlock(row, options.Name or "Keybind", options.Description, options.Tooltip, _keybindWidth + 16)

	local button = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, hasDescription and 0.75 or 0.5, 0),
		Size = UDim2.fromOffset(_keybindWidth, 26),
		BackgroundColor3 = Library.Theme.PanelDark,
		Text = value,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = Library.Theme.TextSoft,
		AutoButtonColor = false,
		Parent = row,
	})
	Utility.applyRound(button, UDim.new(0, 7))
	Utility.applyStroke(button, Library.Theme.Purple, 1, 0.12)

	local entry = {
		Save = options.Save ~= false,
		Triggered = options.OnTriggered,
	}

	function entry:SetValue(newValue, fromLoad)
		if newValue == nil or newValue == unboundValue then
			value = unboundValue
		else
			value = asInputName(newValue)
		end
		button.Text = value
		if options.Flag == "Aero.ToggleKey" then
			Library.ToggleKeyName = value
		end
		if options.Flag then
			Library:updateFlag(options.Flag, value)
		end
		if isCallable(options.Callback) then
			options.Callback(value, fromLoad == true)
		end
	end

	function entry:GetValue()
		return value
	end

	button.MouseButton1Click:Connect(function()
		waiting = true
		Library.BindingKey = true
		button.Text = "Press a key"
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed and not waiting then
			return
		end

		if waiting then
			local isKeyboard = input.UserInputType == Enum.UserInputType.Keyboard
			local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
				or input.UserInputType == Enum.UserInputType.MouseButton2
				or input.UserInputType == Enum.UserInputType.MouseButton3
			if isKeyboard or isMouse then
				waiting = false
				if isKeyboard and input.KeyCode == Enum.KeyCode.Backspace then
					entry:SetValue(unboundValue)
				else
					entry:SetValue(isKeyboard and input.KeyCode or input.UserInputType)
				end
				task.defer(function()
					Library.BindingKey = false
				end)
				return
			end
		end

		local matched = (input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == value)
			or (input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType.Name == value)
		if matched then
			if isCallable(entry.Triggered) then
				entry.Triggered(input.KeyCode)
			end
		end
	end)

	if options.Flag then
		Library:registerFlag(options.Flag, entry)
	end
	entry:SetValue(value, true)
	table.insert(Library.SearchIndex, { Name = options.Name or "Keybind", Type = "Keybind", Tab = self.Tab, Frame = row })
	return entry
end

function Section:AddConsole(options)
	options = options or {}
	local consoleName = options.Name or ("Console" .. tostring(#Library.Consoles + 1))
	local row = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelLight,
		Size = UDim2.new(1, 0, 0, 210),
		Parent = self.Content,
	})
	Utility.applyRound(row, UDim.new(0, 8))
	Utility.applyPadding(row, 10, 10, 10, 10)

	local output = Utility.new("ScrollingFrame", {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(1, 0, 1, -35),
		BackgroundColor3 = Library.Theme.PanelDark,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Library.Theme.AccentSoft,
		ScrollBarImageTransparency = 0.4,
		Parent = row,
	})
	Utility.applyRound(output, UDim.new(0, 8))
	Utility.applyStroke(output, Library.Theme.Border, 1, 0.18)
	Utility.applyPadding(output, 10, 10, 10, 10)

	local outputLayout = Utility.new("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = output,
	})

	outputLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		output.CanvasSize = UDim2.fromOffset(0, outputLayout.AbsoluteContentSize.Y + 20)
		output.CanvasPosition = Vector2.new(0, math.max(0, outputLayout.AbsoluteContentSize.Y + 20 - output.AbsoluteWindowSize.Y))
	end)

	local inputBox = Utility.new("TextBox", {
		Position = UDim2.new(0, 0, 1, -30),
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = Library.Theme.PanelDark,
		ClearTextOnFocus = false,
		PlaceholderText = "Type a command, then press enter...",
		Text = "",
		Font = Enum.Font.RobotoMono,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		PlaceholderColor3 = Library.Theme.TextMute,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = row,
	})
	Utility.applyRound(inputBox, UDim.new(0, 8))
	Utility.applyStroke(inputBox, Library.Theme.Purple, 1, 0.18)
	Utility.applyPadding(inputBox, 10, 10, 0, 0)

	local console = {
		Save = false,
		Commands = {},
		Entries = {},
		MaxEntries = 250,
	}

	function console:Log(message, color)
		local label = Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Font = Enum.Font.RobotoMono,
			TextWrapped = true,
			Text = tostring(message),
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextColor3 = color or Library.Theme.TextSoft,
			Parent = output,
		})
		table.insert(self.Entries, label)
		while #self.Entries > self.MaxEntries do
			local oldest = table.remove(self.Entries, 1)
			if oldest and oldest.Parent then
				oldest:Destroy()
			end
		end
		return label
	end

	function console:RegisterCommand(name, helpText, callback)
		self.Commands[string.lower(name)] = {
			Help = helpText,
			Callback = callback,
		}
		return self
	end

	function console:RunCommand(raw)
		local trimmed = string.match(raw, "^%s*(.-)%s*$")
		if trimmed == "" then
			return
		end

		self:Log("> " .. trimmed, Library.Theme.Text)
		local segments = string.split(trimmed, " ")
		local commandName = string.lower(table.remove(segments, 1) or "")
		local command = self.Commands[commandName]
		if not command then
			self:Log("Unknown command. Use help.", Library.Theme.TextMute)
			return
		end

		local ok, result = pcall(command.Callback, segments, trimmed)
		if not ok then
			self:Log("Command failed: " .. tostring(result), Library.Theme.TextMute)
		elseif result and result ~= "" then
			self:Log(result, Library.Theme.AccentSoft)
		end
	end

	console:RegisterCommand("help", "List available commands.", function()
		local names = {}
		for name in pairs(console.Commands) do
			table.insert(names, name)
		end
		table.sort(names)
		for _, name in ipairs(names) do
			console:Log(string.format("%s - %s", name, console.Commands[name].Help), Library.Theme.TextMute)
		end
		return "Loaded " .. tostring(#names) .. " command(s)."
	end)

	console:RegisterCommand("clear", "Clear console output.", function()
		for _, child in ipairs(output:GetChildren()) do
			if child:IsA("TextLabel") then
				child:Destroy()
			end
		end
		table.clear(console.Entries)
		return "Cleared."
	end)

	console:RegisterCommand("rejoin", "Teleport back into the current server.", function()
		local ok = Utility.rejoinCurrentPlaceSimple()
		if ok then
			return "Rejoining current place..."
		end
		return "Rejoin failed. Please try again."
	end)

	console:RegisterCommand("serverhop", "Join another public server for this place.", function()
		Library:notify("attempting to hop to a different server...", 5)
		local ok, result = pcall(Utility.hopToDifferentServer)
		if not ok then
			return "Server hop failed: " .. tostring(result)
		end
		if result == false then
			return "No suitable server found. Rejoining current place..."
		end
		return "Hopping to a different server..."
	end)

	console:RegisterCommand("echo", "Echo a message back into the console.", function(arguments)
		return table.concat(arguments, " ")
	end)

	console:RegisterCommand("iy", "Load infinite yield.", function(arguments)
        local ok, err = pcall(function()
			local src = httpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
            local fn = loadstring(src)
            if fn then fn() end
        end)
        if ok then
            return "Loaded Infinite Yield."
        else
            return "Failed to load Infinite Yield: " .. tostring(err)
        end
	end)

	console:RegisterCommand("dex", "Load Dex Explorer.", function(arguments)
        local ok, err = pcall(function()
			local src = httpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua")
            local fn = loadstring(src)
            if fn then fn() end
        end)
        if ok then
            return "Loaded Dex Explorer."
        else
            return "Failed to load Dex Explorer: " .. tostring(err)
        end
	end)

	console:RegisterCommand("dev-iy", "Load Dev Infinite Yield by froumes.", function(arguments)
        local ok, err = pcall(function()
			local src = httpGet("https://raw.githubusercontent.com/froumes/badinfiniteyield/refs/heads/master/source")
            local fn = loadstring(src)
            if fn then fn() end
        end)
        if ok then
            return "Loaded Dev Infinite Yield."
        else
            return "Failed to load Dev Infinite Yield: " .. tostring(err)
        end
	end)

	console:RegisterCommand("rspy", "Load remote spy tools. (args: simple, hydro)", function(arguments)
		local arg = string.lower(arguments[1] or "simple")

		local ok, err = pcall(function()
			if arg == "simple" then
				local src = httpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua")
				local fn = loadstring(src)
				if fn then fn() end
			elseif arg == "hydro" then
				local owner = "Upbolt"
				local branch = "revision"

				local function webImport(file)
					local loader = loadstring(httpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. ".lua")
					if loader then
						loader()
					end
				end

				webImport("init")
				webImport("ui/main")
			else
				error("Unknown spy tool: " .. arg .. ". Use 'simple' or 'hydro'.")
			end
		end)

		if ok then
			return "Loaded " .. arg .. " spy tool."
		else
			return "Failed to load " .. arg .. " spy tool: " .. tostring(err)
		end
	end)
	

	for name, command in pairs(options.Commands or {}) do
		console:RegisterCommand(name, command.Help or "Custom command.", command.Callback)
	end

	inputBox.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			return
		end
		local text = inputBox.Text
		inputBox.Text = ""
		console:RunCommand(text)
	end)

	Library.Consoles[consoleName] = console
	if string.lower(consoleName) == "status" then
		console.MaxEntries = 120
	end
	console:Log("Console ready. Type help for commands.", Library.Theme.TextMute)
	table.insert(Library.SearchIndex, { Name = consoleName, Type = "Console", Tab = self.Tab, Frame = row })
	return console
end

local function createTabPage(parent)
	local singleColumn = isSmallViewport()
	local page = Utility.new("ScrollingFrame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		ClipsDescendants = true,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		ScrollBarThickness = isMobile() and 6 or 2,
		ScrollBarImageColor3 = Library.Theme.AccentSoft,
		ScrollBarImageTransparency = 0.4,
		Visible = false,
		Parent = parent,
	})

	local columns = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -4, 0, 0),
		ClipsDescendants = true,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = page,
	})

	Utility.applyPadding(columns, 5, 5, 5, 5)

	local left, right
	if singleColumn then
		left = Utility.new("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = columns,
		})
		right = left

		Utility.new("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = left,
		})
	else
		left = Utility.new("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0.5, -6, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = columns,
		})

		right = Utility.new("Frame", {
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 0),
			Size = UDim2.new(0.5, -6, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Parent = columns,
		})

		Utility.new("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = left,
		})

		Utility.new("UIListLayout", {
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
			Parent = right,
		})
	end

	local function refreshCanvas()
		if singleColumn then
			page.CanvasSize = UDim2.fromOffset(0, left.AbsoluteSize.Y + 6)
		else
			page.CanvasSize = UDim2.fromOffset(0, math.max(left.AbsoluteSize.Y, right.AbsoluteSize.Y) + 6)
		end
	end

	left:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCanvas)
	if not singleColumn then
		right:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCanvas)
	end
	page:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshCanvas)

	return page, left, right
end

function Library:AddTab(options)
	options = options or {}
	local tab = setmetatable({
		Name = options.Name or "Tab",
		Icon = options.Icon or "layout-panel-left",
		NextColumn = 1,
	}, Tab)

	tab.ButtonFrame = Utility.new("TextButton", {
		BackgroundColor3 = Library.Theme.Sidebar,
		Size = UDim2.new(0.98, 0, 0, 34),
		Text = "",
		AutoButtonColor = false,
		Parent = self.TabList,
	})
	Utility.applyPadding(tab.ButtonFrame, 0.05, 0.05, 0.1, 0.05)
	Utility.applyRound(tab.ButtonFrame, UDim.new(0, 8))
	Utility.applyStroke(tab.ButtonFrame, Library.Theme.Purple, 1, 1)

	tab.ButtonIndicator = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(3, 20),
		BackgroundColor3 = Library.Theme.Purple,
		BackgroundTransparency = 1,
		Parent = tab.ButtonFrame,
	})
	Utility.applyRound(tab.ButtonIndicator, UDim.new(1, 0))

	tab.ButtonIcon = Utility.makeIcon(tab.Icon, tab.ButtonFrame, 16, Library.Theme.Purple)
	tab.ButtonIcon.Position = UDim2.new(0, 5, 0.3, 0)

	tab.ButtonTitle = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(34, 0),
		Size = UDim2.new(1, -62, 1, 0),
		Font = Enum.Font.GothamMedium,
		Text = tab.Name,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = Library.Theme.TextMute,
		Parent = tab.ButtonFrame,
	})

	tab.ButtonArrow = Utility.makeIcon("chevron-right", tab.ButtonFrame, 14, Library.Theme.Purple)
	tab.ButtonArrow.AnchorPoint = Vector2.new(1, 0.5)
	tab.ButtonArrow.Position = UDim2.new(1, -10, 0.5, 0)

	tab.Page, tab.LeftColumn, tab.RightColumn = createTabPage(self.PageContainer)

	Utility.bindHover(tab.ButtonFrame, function()
		Utility.tween(tab.ButtonFrame, "Normal", { Size = UDim2.new(0.98, 0, 0, 40) })
	end, function()
		Utility.tween(tab.ButtonFrame, "Fast", { Size = UDim2.new(0.98, 0, 0, 34) })
	end)

	tab.ButtonFrame.MouseButton1Click:Connect(function()
		tab:Show()
	end)

	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		tab:Show()
	end
	return tab
end

function Library:setParticleCount(n)
	n = math.clamp(math.floor(tonumber(n) or 18), 0, 100)
	if not self._constellationParticles or not self.ConstellationContainer then return end
	local particleColor = self._constellationColor or Color3.fromRGB(255, 255, 255)
	while #self._constellationParticles < n do
		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(2, 2)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.BackgroundColor3 = particleColor
		dot.BackgroundTransparency = 0.75
		dot.BorderSizePixel = 0
		dot.ZIndex = 2
		dot.Parent = self.ConstellationContainer
		local cr = Instance.new("UICorner")
		cr.CornerRadius = UDim.new(1, 0)
		cr.Parent = dot
		local px, py = math.random(), math.random()
		dot.Position = UDim2.new(px, 0, py, 0)
		table.insert(self._constellationParticles, {
			frame = dot, x = px, y = py,
			vx = (math.random() - 0.5) * 0.4,
			vy = (math.random() - 0.5) * 0.4,
			speedMul = math.random(70, 170) / 100,
			wobble = math.random() * math.pi * 2,
		})
	end
	while #self._constellationParticles > n do
		local last = table.remove(self._constellationParticles)
		if last and last.frame then last.frame:Destroy() end
	end
end

function Library:setParticleMaxLinks(n)
	n = math.clamp(math.floor(tonumber(n) or 180), 0, 300)
	self._constellationMaxLinks = n

	if not self._constellationLines or not self.ConstellationContainer then
		return
	end

	local lineColor = self._constellationColor or Color3.fromRGB(255, 255, 255)
	local lineAlpha = self._constellationLinkAlpha or 0.85
	while #self._constellationLines < n do
		local ln = Instance.new("Frame")
		ln.Name = "CLink"
		ln.BackgroundColor3 = lineColor
		ln.BackgroundTransparency = lineAlpha
		ln.BorderSizePixel = 0
		ln.AnchorPoint = Vector2.new(0.5, 0.5)
		ln.Visible = false
		ln.ZIndex = 1
		ln.Parent = self.ConstellationContainer
		table.insert(self._constellationLines, ln)
	end

	while #self._constellationLines > n do
		local last = table.remove(self._constellationLines)
		if last then
			last:Destroy()
		end
	end
end

function Library:setParticleLinkDistance(distance)
	distance = math.clamp(tonumber(distance) or 0.22, 0.01, 1)
	self._constellationLinkDistance = distance
end

function Library:setParticleSpeed(speed)
	speed = math.clamp(tonumber(speed) or 0.45, 0, 4)
	self._constellationSpeed = speed
end

function Library:setParticleMode(mode)
	local resolved = string.lower(tostring(mode or "Default Mode"))
	if resolved == "alternate mode" or resolved == "alternate" then
		self._constellationMode = "Alternate Mode"
	else
		self._constellationMode = "Default Mode"
	end
end

function Library:setParticleColor(color)
	if typeof(color) ~= "Color3" then
		return
	end

	self._constellationColor = color
	if self._constellationParticles then
		for _, particle in ipairs(self._constellationParticles) do
			if particle.frame then
				particle.frame.BackgroundColor3 = color
			end
		end
	end

	if self._constellationLines then
		for _, line in ipairs(self._constellationLines) do
			line.BackgroundColor3 = color
		end
	end
end

function Library:setMainTransparency(alpha)
	alpha = math.clamp(alpha, 0, 1)
	self._uiTransparency = alpha
	self:updateAllVisuals(0, true)
end


function Library:buildShell(options)
	options = options or {}

	local existing = Utility.findHui():FindFirstChild("aeroWareUI")
	if existing then
		self:disconnectRuntimeConnections()
		existing:Destroy()
	end

	self.ScreenGui = Utility.new("ScreenGui", {
		Name = "aeroWareUI",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = Utility.findHui(),
	})

	self.NotificationHost = Utility.new("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -18, 0.5, 0),
		Size = isMobile() and UDim2.new(0.65, 0, 0, 320) or UDim2.fromOffset(300, 420),
		Parent = self.ScreenGui,
	})

	self.NotificationList = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.NotificationHost,
	})

	Utility.new("UIListLayout", {
		Padding = UDim.new(0, 10),
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Parent = self.NotificationList,
	})

	self.Tooltip = Utility.new("Frame", {
		BackgroundColor3 = Library.Theme.PanelLight,
		BackgroundTransparency = 0.05,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		Visible = false,
		ZIndex = 9999,
		Parent = self.ScreenGui,
	})
	Utility.applyRound(self.Tooltip, UDim.new(0, 8))
	Utility.applyPadding(self.Tooltip, 10, 10, 8, 8)
	Utility.applyStroke(self.Tooltip, Library.Theme.Purple, 1, 0.2)
	Utility.new("UISizeConstraint", {
		MinSize = Vector2.new(72, 28),
		MaxSize = Vector2.new(360, 300),
		Parent = self.Tooltip,
	})

	self.TooltipLabel = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		Font = Enum.Font.Gotham,
		Text = "",
		TextSize = 12,
		TextWrapped = true,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		ZIndex = 9999,
		Parent = self.Tooltip,
	})

	self.MainHolder = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = true,
		Parent = self.ScreenGui,
	})

	self.MainGroup = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Parent = self.MainHolder,
	})

	self.VisibilityDriver = Utility.new("NumberValue", {
		Name = "VisibilityDriver",
		Value = 0,
		Parent = self.MainHolder,
	})
	self.VisibilityDriver.Changed:Connect(function(value)
		self:updateAllVisuals(tonumber(value) or 0, true)
	end)
	self:updateAllVisuals(0, true)

	self.Main = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.fromOffset(0, 0),
		Size = options.Size or (isMobile() and UDim2.fromScale(0.95, 0.85) or UDim2.fromScale(0.5, 0.5)),
		BackgroundColor3 = Library.Theme.Background,
		ClipsDescendants = true,
		Parent = self.MainGroup,
	})
	Utility.applyRound(self.Main, UDim.new(0, 14))
	Utility.createGradient(self.Main, Library.Theme.Background, Library.Theme.PanelDark, 0)

	self.WindowMinScale = isMobile() and Vector2.new(0.6, 0.4) or Vector2.new(0.45, 0.25)
	self.WindowMaxScale = isMobile() and Vector2.new(1, 1) or Vector2.new(0.75, 0.75)
	self.MainSizeConstraint = Utility.new("UISizeConstraint", {
		Parent = self.Main,
	})

	self.MainScale = Utility.new("UIScale", {
		Scale = 1,
		Parent = self.Main,
	})

	self.ConstellationEnabled = true
	self._constellationParticles = {}
	self._constellationLines = {}
	self._constellationMaxLinks = 110
	self._constellationLinkDistance = 0.22
	self._constellationLinkAlpha = 0.8
	self._constellationLinkThickness = 1
	self._constellationSpeed = 0.45
	self._constellationColor = Color3.fromRGB(255, 255, 255)
	self._constellationMode = "Default Mode"
	self._constellationUseRainbowColor = false

	local constellationContainer = Utility.new("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ZIndex = 1,
		ClipsDescendants = true,
		Name = "ConstellationContainer",
		Parent = self.Main,
	})
	self.ConstellationContainer = constellationContainer

	for i = 1, 18 do
		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(2, 2)
		dot.AnchorPoint = Vector2.new(0.5, 0.5)
		dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		dot.BackgroundTransparency = 0.80
		dot.BorderSizePixel = 0
		dot.ZIndex = 2
		dot.Parent = constellationContainer
		local cr = Instance.new("UICorner")
		cr.CornerRadius = UDim.new(1, 0)
		cr.Parent = dot
		local px, py = math.random(), math.random()
		dot.Position = UDim2.new(px, 0, py, 0)
		table.insert(self._constellationParticles, {
			frame = dot, x = px, y = py,
			vx = (math.random() - 0.5) * 0.4,
			vy = (math.random() - 0.5) * 0.4,
			speedMul = math.random(70, 170) / 100,
			wobble = math.random() * math.pi * 2,
		})
	end

	for i = 1, self._constellationMaxLinks do
		local ln = Instance.new("Frame")
		ln.Name = "CLink"
		ln.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ln.BackgroundTransparency = self._constellationLinkAlpha
		ln.BorderSizePixel = 0
		ln.AnchorPoint = Vector2.new(0.5, 0.5)
		ln.Visible = false
		ln.ZIndex = 1
		ln.Parent = constellationContainer
		table.insert(self._constellationLines, ln)
	end

	do
		local _cself = self
		local frameBudget = 1 / 30
		local accumulatedDt = 0
		local wasHidden = false
		local function stepConstellation(dt)
			if not _cself.ConstellationEnabled or not constellationContainer.Visible then
				if not wasHidden then
					for _, ln in ipairs(_cself._constellationLines) do
						ln.Visible = false
					end
					wasHidden = true
				end
				return
			end
			wasHidden = false
			accumulatedDt += dt
			if accumulatedDt < frameBudget then
				return
			end
			dt = accumulatedDt
			accumulatedDt = 0
			if _cself._constellationUseRainbowColor and _cself.RainbowColor then
				_cself:setParticleColor(_cself.RainbowColor)
			end
			local sz = constellationContainer.AbsoluteSize
			if sz.X < 1 or sz.Y < 1 then return end
			local maxLinks = _cself._constellationMaxLinks or 0
			local linkDist = _cself._constellationLinkDistance or 0.22
			local linkAlpha = _cself._constellationLinkAlpha or 0.85
			local linkThickness = _cself._constellationLinkThickness or 1
			local speed = _cself._constellationSpeed or 0.45
			local alternateMode = (_cself._constellationMode == "Alternate Mode")
			for _, p in ipairs(_cself._constellationParticles) do
				local particleSpeed = speed
				if alternateMode then
					p.wobble = (p.wobble or 0) + dt * ((p.speedMul or 1) * 4)
					p.vx += math.cos(p.wobble) * dt * 0.18
					p.vy += math.sin(p.wobble * 1.35) * dt * 0.18
					local vMag = math.sqrt((p.vx * p.vx) + (p.vy * p.vy))
					if vMag > 1.2 then
						p.vx = (p.vx / vMag) * 1.2
						p.vy = (p.vy / vMag) * 1.2
					end
					particleSpeed = speed * (p.speedMul or 1)
				end
				p.x += p.vx * dt * particleSpeed
				p.y += p.vy * dt * particleSpeed
				if p.x <= 0 or p.x >= 1 then p.vx = -p.vx; p.x = math.clamp(p.x, 0, 1) end
				if p.y <= 0 or p.y >= 1 then p.vy = -p.vy; p.y = math.clamp(p.y, 0, 1) end
				p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
			end
			local lc = 0
			local d2max = linkDist * linkDist
			for i = 1, #_cself._constellationParticles do
				local a = _cself._constellationParticles[i]
				for j = i + 1, #_cself._constellationParticles do
					local b = _cself._constellationParticles[j]
					local dx = a.x - b.x; local dy = a.y - b.y
					local d2 = dx * dx + dy * dy
					if d2 <= d2max then
						lc += 1
						if lc > maxLinks then break end
						local ln = _cself._constellationLines[lc]
						local t = math.sqrt(d2) / math.max(linkDist, 0.001)
						ln.BackgroundTransparency = math.clamp(linkAlpha + t * 0.10, 0, 1)
						local ax, ay = a.x * sz.X, a.y * sz.Y
						local bx, by = b.x * sz.X, b.y * sz.Y
						local mx, my = (ax + bx) * 0.5, (ay + by) * 0.5
						local dist = math.sqrt((bx - ax) ^ 2 + (by - ay) ^ 2)
						ln.Size = UDim2.fromOffset(dist, linkThickness)
						ln.Position = UDim2.fromOffset(mx, my)
						ln.Rotation = math.deg(math.atan2(by - ay, bx - ax))
						ln.Visible = true
					end
				end
				if lc > maxLinks then break end
			end
			for k = lc + 1, #_cself._constellationLines do _cself._constellationLines[k].Visible = false end
		end
		self._constellationConn = RunService.RenderStepped:Connect(stepConstellation)
	end

	local chrome = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Parent = self.Main,
	})

	local topBar = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Active = true,
		Size = UDim2.new(1, 0, 0, 48),
		Parent = chrome,
	})

	local topTitleContainer = Utility.new("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(20, 14),
		Size = UDim2.new(0, 200, 0, 18),
		ZIndex = 10,
		Parent = topBar,
	})

	Utility.new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = topTitleContainer,
	})

	if options.Title == "aeroWare" then
		Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Enum.Font.GothamBold,
			Text = "aero",
			TextSize = 18,
			TextColor3 = Library.Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = topTitleContainer,
		})
		Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.X,
			Font = Enum.Font.GothamBold,
			Text = "Ware",
			TextSize = 18,
			TextColor3 = Library.Theme.Purple,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = topTitleContainer,
		})
	else
		Utility.new("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamBold,
			Text = options.Title or "aeroWare",
			TextSize = 18,
			TextColor3 = Library.Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = topTitleContainer,
		})
	end

	Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(20, 30),
		Size = UDim2.new(0, 260, 0, 12),
		Font = Enum.Font.Gotham,
		Text = tostring(options.Subtitle or ""),
		TextSize = 11,
		TextColor3 = Library.Theme.TextMute,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 10,
		Parent = topBar,
	})

	local close = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -16, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = Library.Theme.Panel,
		Text = "",
		AutoButtonColor = false,
		Parent = topBar,
	})
	Utility.applyRound(close, UDim.new(1, 0))
	local closeIcon = Utility.makeIcon("x", close, 14, Library.Theme.Purple)
	closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	closeIcon.Position = UDim2.fromScale(0.5, 0.5)
	close.MouseButton1Click:Connect(function()
		self:setVisible(false)
	end)

	-- Search bar in topBar
	local searchHolder = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 15, 0.5, 0),
		Size = UDim2.new(0.5, 0, 0.5, 0),
		BackgroundColor3 = Library.Theme.PanelDark,
		Visible = not isSmallViewport(),
		Parent = topBar,
	})
	Utility.applyRound(searchHolder, UDim.new(0, 7))
	Utility.applyStroke(searchHolder, Library.Theme.Border, 1, 0.15)
	local searchHolderStroke = Utility.applyStroke(searchHolder, Library.Theme.Purple, 1.2, 1)
	local _searchIcon = Utility.makeIcon("search", searchHolder, 13, Library.Theme.Purple)
	_searchIcon.AnchorPoint = Vector2.new(0, 0.5)
	_searchIcon.Position = UDim2.fromOffset(7, 13)
	self.SearchBar = Utility.new("TextBox", {
		Position = UDim2.fromOffset(24, 0),
		Size = UDim2.new(1, -28, 1, 0),
		BackgroundTransparency = 1,
		ClearTextOnFocus = false,
		PlaceholderText = "Search . . .",
		PlaceholderColor3 = Library.Theme.TextMute,
		Text = "",
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextColor3 = Library.Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = searchHolder,
	})

	-- Focus animations for search bar
	local searchHolderBaseSize = searchHolder.Size
	self.SearchBar.Focused:Connect(function()
		Utility.tween(searchHolder, "Slow", { Size = UDim2.new(0.55, 0, 0.55, 0) })
		Utility.tween(searchHolderStroke, "Slow", { Transparency = 0.35 })
	end)
	self.SearchBar.FocusLost:Connect(function()
		Utility.tween(searchHolder, "Slow", { Size = searchHolderBaseSize })
		Utility.tween(searchHolderStroke, "Fast", { Transparency = 1 })
	end)

	self.SearchResultsPanel = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 54),
		Size = UDim2.fromOffset(260, 0),
		BackgroundColor3 = Library.Theme.Panel,
		BackgroundTransparency = 0.03,
		ClipsDescendants = true,
		Visible = false,
		ZIndex = 9000,
		Parent = chrome,
	})
	Utility.applyRound(self.SearchResultsPanel, UDim.new(0, 8))
	Utility.applyStroke(self.SearchResultsPanel, Library.Theme.Border, 1, 0.08)

	local _srList = Utility.new("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Library.Theme.AccentSoft,
		ScrollBarImageTransparency = 0.45,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BorderSizePixel = 0,
		AutomaticSize = Enum.AutomaticSize.Y,
		Parent = self.SearchResultsPanel,
	})
	Utility.new("UIListLayout", {
		Padding = UDim.new(0, 4),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = _srList,
	})
	Utility.applyPadding(_srList, 6, 6, 6, 6)

	do
		local _sself = self
		local function _rebuildSearch(query)
			for _, child in ipairs(_srList:GetChildren()) do
				if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
					child:Destroy()
				end
			end
			if query == "" then
				_sself.SearchResultsPanel.Visible = false
				return
			end
			local results = {}
			local lq = query:lower()
			for _, entry in ipairs(_sself.SearchIndex) do
				if entry.Name:lower():find(lq, 1, true) then
					table.insert(results, entry)
					if #results >= 10 then break end
				end
			end
			if #results == 0 then
				_sself.SearchResultsPanel.Visible = false
				return
			end
			for _, entry in ipairs(results) do
				local rBtn = Utility.new("TextButton", {
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundColor3 = Library.Theme.PanelLight,
					BackgroundTransparency = 0.04,
					Text = "",
					AutoButtonColor = false,
					ZIndex = 9001,
					Parent = _srList,
				})
				Utility.applyRound(rBtn, UDim.new(0, 6))
				local rBtnStroke = Utility.applyStroke(rBtn, Library.Theme.Purple, 1, 1)
				Utility.new("TextLabel", {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(8, 0),
					Size = UDim2.new(0.72, -8, 1, 0),
					Font = Enum.Font.GothamMedium,
					Text = entry.Name,
					TextSize = 12,
					TextColor3 = Library.Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 9002,
					Parent = rBtn,
				})
				Utility.new("TextLabel", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.new(1, -8, 0.5, 0),
					Size = UDim2.new(0.28, 0, 0, 16),
					Font = Enum.Font.Gotham,
					Text = entry.Type,
					TextSize = 10,
					TextColor3 = Library.Theme.TextMute,
					TextXAlignment = Enum.TextXAlignment.Right,
					ZIndex = 9002,
					Parent = rBtn,
				})
				Utility.bindHover(rBtn, function()
					Utility.tween(rBtn, "Fast", { BackgroundTransparency = 0 })
					Utility.tween(rBtnStroke, "Slow", { Transparency = 0.15 })
				end, function()
					Utility.tween(rBtn, "Fast", { BackgroundTransparency = 0.04 })
					Utility.tween(rBtnStroke, "Slow", { Transparency = 1 })
				end)
				local _ce = entry
				rBtn.MouseButton1Click:Connect(function()
					Utility.tween(searchHolderStroke, "Slow", { Transparency = 0.5 })
					_sself.SearchBar.Text = ""
					_sself.SearchResultsPanel.Visible = false
					if _ce.Tab then
						_ce.Tab:Show()
					end
					if _ce.Frame and _ce.Frame.Parent then
						task.defer(function()
							task.wait()
							local page = _ce.Tab and _ce.Tab.Page
							if page then
								local relY = _ce.Frame.AbsolutePosition.Y - page.AbsolutePosition.Y + page.CanvasPosition.Y - 20
								page.CanvasPosition = Vector2.new(0, math.max(0, relY))
							end
							local origColor = _ce.Frame.BackgroundColor3
							for _ = 1, 3 do
								Utility.tween(_ce.Frame, "Instant", { BackgroundColor3 = Color3.fromRGB(90, 90, 90) })
								task.wait(0.13)
								Utility.tween(_ce.Frame, "Instant", { BackgroundColor3 = origColor })
								task.wait(0.09)
							end
						end)
					end
				end)
			end
			local panelH = math.min(#results * 32 + 12, 300)
			_sself.SearchResultsPanel.Size = UDim2.fromOffset(260, panelH)
			_sself.SearchResultsPanel.Visible = true
		end
		self.SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
			_rebuildSearch(self.SearchBar.Text)
		end)
		self.SearchBar.FocusLost:Connect(function()
			task.delay(0.18, function()
				if _sself.SearchResultsPanel and _sself.SearchResultsPanel.Parent then
					_sself.SearchResultsPanel.Visible = false
					Utility.tween(searchHolderStroke, "Fast", { Transparency = 1 })
				end
			end)
		end)
	end

	local _sidebarWidth = isSmallViewport() and 160 or 226
	local sidebar = Utility.new("Frame", {
		Position = UDim2.fromOffset(12, 60),
		Size = UDim2.new(0, _sidebarWidth, 1, -72),
		BackgroundColor3 = Library.Theme.Sidebar,
		ClipsDescendants = true,
		Parent = chrome,
	})
	Utility.applyRound(sidebar, UDim.new(0, 12))
	Utility.applyStroke(sidebar, Library.Theme.BorderSoft, 1, 0.08)
	Utility.applyPadding(sidebar, 12, 12, 14, 14)

	local sidebarHeader = createHeader(sidebar, getCurrentGameName(), tostring(#game:GetService("Players"):GetChildren() .. " player(s)"), "layout-panel-left")
	sidebarHeader.Size = UDim2.new(1, 0, 0, 40)

	self.TabList = Utility.new("ScrollingFrame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(0, 50),
		Size = UDim2.new(1, 0, 1, -96),
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollBarThickness = isMobile() and 4 or 2,
		ScrollBarImageColor3 = Library.Theme.AccentSoft,
		ScrollBarImageTransparency = 0.5,
		BorderSizePixel = 0,
		Parent = sidebar,
	})

	Utility.applyPadding(self.TabList, 0, 0, 5, 5)

	Utility.new("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = self.TabList,
	})

	local runtimeStats = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 12, 1, 0),
		Size = UDim2.new(1, -24, 0, 12),
		BackgroundTransparency = 1,
		ZIndex = 20,
		Visible = not isSmallViewport(),
		Parent = self.Main,
	})

	Utility.new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = runtimeStats,
	})

	local pingLabel = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.05, -6, 1, 0),
		Font = Enum.Font.Gotham,
		Text = "ping: --",
		TextSize = 9,
		TextColor3 = Library.Theme.TextMute,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = runtimeStats,
	})

	local fpsLabel = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.05, -6, 1, 0),
		Font = Enum.Font.Gotham,
		Text = "fps: --",
		TextSize = 9,
		TextColor3 = Library.Theme.TextMute,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = runtimeStats,
	})

	local memoryLabel = Utility.new("TextLabel", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0.05, -6, 1, 0),
		Font = Enum.Font.Gotham,
		Text = "mem: -- mb",
		TextSize = 9,
		TextColor3 = Library.Theme.TextMute,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = runtimeStats,
	})

	self.PageContainer = Utility.new("Frame", {
		Position = UDim2.fromOffset(_sidebarWidth + 26, 60),
		Size = UDim2.new(1, -(_sidebarWidth + 38), 1, -72),
		BackgroundColor3 = Library.Theme.Sidebar,
		ClipsDescendants = true,
		Parent = chrome,
	})
	Utility.applyRound(self.PageContainer, UDim.new(0, 12))
	Utility.applyStroke(self.PageContainer, Library.Theme.BorderSoft, 1, 0.08)
	Utility.applyPadding(self.PageContainer, 12, 12, 12, 12)

	local resizeHandle = Utility.new("TextButton", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -8, 1, -8),
		Size = UDim2.fromOffset(20, 20),
		BackgroundColor3 = Library.Theme.Panel,
		BackgroundTransparency = 0.05,
		Text = "",
		AutoButtonColor = false,
		ZIndex = 12,
		Parent = chrome,
	})
	Utility.applyRound(resizeHandle, UDim.new(0, 6))
	Utility.applyStroke(resizeHandle, Library.Theme.Border, 1, 0.1)
	local resizeIcon = Utility.makeIcon("move-diagonal-2", resizeHandle, 12, Library.Theme.Purple)
	resizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	resizeIcon.Position = UDim2.fromScale(0.5, 0.5)
	resizeIcon.ZIndex = 13
	Utility.bindHover(resizeHandle, function()
		Utility.tween(resizeHandle, "Fast", { BackgroundColor3 = Library.Theme.PanelLight })
		Utility.tween(resizeIcon, "Fast", { ImageColor3 = Library.Theme.Purple })
	end, function()
		if not self.CurrentlyResizing then
			Utility.tween(resizeHandle, "Fast", { BackgroundColor3 = Library.Theme.Panel })
			Utility.tween(resizeIcon, "Fast", { ImageColor3 = Library.Theme.Purple })
		end
	end)

	local rightBoundary = Utility.new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -1, 0.5, 8),
		Size = UDim2.new(0, 2, 0.9, -16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 11,
		Parent = self.Main,
	})

	local bottomBoundary = Utility.new("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 8, 1, -1),
		Size = UDim2.new(0.9, -16, 0, 2),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 11,
		Parent = self.Main,
	})

	local feedbackActive = { x = false, y = false }
	local function flashBoundary(axis)
		if feedbackActive[axis] then
			return
		end

		feedbackActive[axis] = true
		local line = axis == "x" and rightBoundary or bottomBoundary
		local basePosition = line.Position
		line.Visible = true
		line.BackgroundTransparency = 1
		Utility.tween(line, "Fast", { BackgroundTransparency = 0.25 })

		task.spawn(function()
			for i = 1, 4 do
				local offset = i % 2 == 0 and -2 or 2
				if axis == "x" then
					line.Position = UDim2.new(basePosition.X.Scale, basePosition.X.Offset + offset, basePosition.Y.Scale, basePosition.Y.Offset)
				else
					line.Position = UDim2.new(basePosition.X.Scale, basePosition.X.Offset, basePosition.Y.Scale, basePosition.Y.Offset + offset)
				end
				task.wait(0.03)
			end

			line.Position = basePosition
			Utility.tween(line, "Fade", { BackgroundTransparency = 1 })
			task.wait(0.25)
			line.Visible = false
			feedbackActive[axis] = false
		end)
	end

	local dragHandle = topBar
	local dragging = false
	local resizing = false
	local dragStart
	local startPos
	local resizeStart
	local resizeStartSize
	local dragTween
	local resizeTween
	local hitMinXLast = false
	local hitMaxXLast = false
	local hitMinYLast = false
	local hitMaxYLast = false

	local function clampAndSnap(pos)
		local camera = workspace.CurrentCamera
		if not camera then
			return pos
		end

		local viewport = camera.ViewportSize
		local size = self.Main.AbsoluteSize
		local absX = pos.X.Scale * viewport.X + pos.X.Offset
		local absY = pos.Y.Scale * viewport.Y + pos.Y.Offset

		absX = math.clamp(absX, 0, viewport.X - size.X)
		absY = math.clamp(absY, 0, viewport.Y - size.Y)

		local snapDistance = 5
		if absX <= snapDistance then
			absX = 0
		end
		if viewport.X - (absX + size.X) <= snapDistance then
			absX = viewport.X - size.X
		end
		if absY <= snapDistance then
			absY = 0
		end
		if viewport.Y - (absY + size.Y) <= snapDistance then
			absY = viewport.Y - size.Y
		end

		local newOffsetX = absX - pos.X.Scale * viewport.X
		local newOffsetY = absY - pos.Y.Scale * viewport.Y
		return UDim2.new(pos.X.Scale, newOffsetX, pos.Y.Scale, newOffsetY)
	end

	local function getResizeBounds()
		local camera = workspace.CurrentCamera
		if not camera then
			return Vector2.new(420, 320), Vector2.new(1200, 900)
		end

		local viewport = camera.ViewportSize
		local minScale = self.WindowMinScale or Vector2.new(0.45, 0.25)
		local maxScale = self.WindowMaxScale or Vector2.new(0.75, 0.75)
		local minSize = Vector2.new(
			math.max(1, math.floor(viewport.X * minScale.X)),
			math.max(1, math.floor(viewport.Y * minScale.Y))
		)
		local maxSize = Vector2.new(
			math.max(minSize.X, math.floor(viewport.X * maxScale.X)),
			math.max(minSize.Y, math.floor(viewport.Y * maxScale.Y))
		)
		return minSize, maxSize
	end

	local function updateResizeConstraints()
		if not self.MainSizeConstraint then
			return
		end

		local minSize, maxSize = getResizeBounds()
		self.MainSizeConstraint.MinSize = minSize
		self.MainSizeConstraint.MaxSize = maxSize

		local current = self.Main.AbsoluteSize
		local clampedSize = Vector2.new(
			math.clamp(current.X, minSize.X, maxSize.X),
			math.clamp(current.Y, minSize.Y, maxSize.Y)
		)

		if clampedSize.X ~= current.X or clampedSize.Y ~= current.Y then
			self.Main.Size = UDim2.fromOffset(clampedSize.X, clampedSize.Y)
			self.Main.Position = clampAndSnap(self.Main.Position)
		end
	end

	updateResizeConstraints()
	if self._viewportResizeConn then
		self._viewportResizeConn:Disconnect()
		self._viewportResizeConn = nil
	end
	if workspace.CurrentCamera then
		self._viewportResizeConn = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			updateResizeConstraints()
			local sw = isSmallViewport() and 160 or 226
			sidebar.Size = UDim2.new(0, sw, 1, -72)
			self.PageContainer.Position = UDim2.fromOffset(sw + 26, 60)
			self.PageContainer.Size = UDim2.new(1, -(sw + 38), 1, -72)
			searchHolder.Visible = not isSmallViewport()
			runtimeStats.Visible = not isSmallViewport()
		end)
	end

	self.Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		updateResizeConstraints()
		self.Main.Position = clampAndSnap(self.Main.Position)
	end)

	dragHandle.InputBegan:Connect(function(input)
		if isInputDragStart(input) then
			if self.CurrentlyDragging or self.CurrentlyResizing then
				return
			end
			self.Main.ZIndex = 10
			dragging = true
			self.CurrentlyDragging = true
			dragStart = input.Position
			startPos = self.Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					self.CurrentlyDragging = false
					self.Main.Position = clampAndSnap(self.Main.Position)
					if dragTween then
						dragTween:Cancel()
						dragTween = nil
					end
				end
			end)
		end
	end)

	resizeHandle.InputBegan:Connect(function(input)
		if isInputDragStart(input) then
			if self.CurrentlyDragging or self.CurrentlyResizing then
				return
			end

			resizing = true
			self.CurrentlyResizing = true
			resizeStart = input.Position
			resizeStartSize = self.Main.AbsoluteSize
			hitMinXLast, hitMaxXLast, hitMinYLast, hitMaxYLast = false, false, false, false
			Utility.tween(resizeHandle, "Fast", { BackgroundColor3 = Library.Theme.PanelLight })
			Utility.tween(resizeIcon, "Fast", { ImageColor3 = Library.Theme.Text })

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
					self.CurrentlyResizing = false
					self.Main.Position = clampAndSnap(self.Main.Position)
					if resizeTween then
						resizeTween:Cancel()
						resizeTween = nil
					end
					Utility.tween(resizeHandle, "Fast", { BackgroundColor3 = Library.Theme.Panel })
					Utility.tween(resizeIcon, "Fast", { ImageColor3 = Library.Theme.TextSoft })
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and isInputDragMove(input) and dragStart and startPos then
			local delta = input.Position - dragStart
			local target = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			target = clampAndSnap(target)
			if dragTween then
				dragTween:Cancel()
			end
			dragTween = TweenService:Create(
				self.Main,
				TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Position = target }
			)
			dragTween:Play()
		end

		if resizing and isInputDragMove(input) and resizeStart and resizeStartSize then
			local delta = input.Position - resizeStart
			local desired = Vector2.new(
				resizeStartSize.X + delta.X,
				resizeStartSize.Y + delta.Y
			)

			local minSize, maxSize = getResizeBounds()
			local hitMinX = desired.X <= minSize.X
			local hitMaxX = desired.X >= maxSize.X
			local hitMinY = desired.Y <= minSize.Y
			local hitMaxY = desired.Y >= maxSize.Y

			local clamped = Vector2.new(
				math.clamp(desired.X, minSize.X, maxSize.X),
				math.clamp(desired.Y, minSize.Y, maxSize.Y)
			)

			if (hitMinX and not hitMinXLast) or (hitMaxX and not hitMaxXLast) then
				flashBoundary("x")
			end
			if (hitMinY and not hitMinYLast) or (hitMaxY and not hitMaxYLast) then
				flashBoundary("y")
			end

			hitMinXLast, hitMaxXLast, hitMinYLast, hitMaxYLast = hitMinX, hitMaxX, hitMinY, hitMaxY

			if resizeTween then
				resizeTween:Cancel()
			end
			resizeTween = TweenService:Create(
				self.Main,
				TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{ Size = UDim2.fromOffset(clamped.X, clamped.Y) }
			)
			resizeTween:Play()
		end
	end)

	if not self.GlobalToggleConnection then
		self.GlobalToggleConnection = UserInputService.InputBegan:Connect(function(input)
			if self.BindingKey then return end

			local toggleKey = self.ToggleKeyName or "RightShift"

			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == toggleKey then
				self:toggleVisible()
				return
			end

			if input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType.Name == toggleKey then
				self:toggleVisible()
			end
		end)
	end

	if isMobile() then
		local mobileToggle = Utility.new("TextButton", {
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -16, 0.2, -16),
			Size = UDim2.fromOffset(48, 48),
			BackgroundColor3 = Library.Theme.Panel,
			BackgroundTransparency = 0.15,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 10000,
			Parent = self.ScreenGui,
		})
		Utility.applyRound(mobileToggle, UDim.new(1, 0))
		Utility.applyStroke(mobileToggle, Library.Theme.Border, 1, 0.1)
		local mobileToggleIcon = Utility.makeIcon("sliders-horizontal", mobileToggle, 20, Library.Theme.Purple)
		mobileToggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
		mobileToggleIcon.Position = UDim2.fromScale(0.5, 0.5)
		mobileToggleIcon.ZIndex = 10001
		mobileToggle.MouseButton1Click:Connect(function()
			self:toggleVisible()
		end)
		self._mobileToggle = mobileToggle
	end

	if self._runtimeStatsConn then
		self._runtimeStatsConn:Disconnect()
		self._runtimeStatsConn = nil
	end

	local statTick = 0
	local frameAccumulator = 0
	local frameCount = 0
	local lastPingText = nil
	local lastFpsText = nil
	local lastMemoryText = nil
	self._runtimeStatsConn = RunService.RenderStepped:Connect(function(dt)
		if self.Tooltip and self.Tooltip.Visible then
			self:updateTooltipPosition()
		end

		if not self.Visible then
			return
		end

		frameAccumulator += dt
		frameCount += 1
		statTick += dt

		if statTick < 1 then
			return
		end

		local fps = frameAccumulator > 0 and math.floor((frameCount / frameAccumulator) + 0.5) or 0
		frameAccumulator = 0
		frameCount = 0
		statTick = 0

		local pingMs = 0
		local pingOk, pingSec = pcall(function()
			return LocalPlayer:GetNetworkPing()
		end)
		if pingOk and type(pingSec) == "number" then
			pingMs = math.max(0, math.floor((pingSec * 1000) + 0.5))
		end

		local memMb = 0
		local memOk, memValue = pcall(function()
			return StatsService:GetTotalMemoryUsageMb()
		end)
		if memOk and type(memValue) == "number" then
			memMb = math.max(0, memValue)
		end

		local pingText = string.format("ping: %d", pingMs)
		local fpsText = string.format("fps: %d", fps)
		local memoryText = string.format("mem: %.0f mb", memMb)

		if pingText ~= lastPingText then
			lastPingText = pingText
			pingLabel.Text = pingText
		end
		if fpsText ~= lastFpsText then
			lastFpsText = fpsText
			fpsLabel.Text = fpsText
		end
		if memoryText ~= lastMemoryText then
			lastMemoryText = memoryText
			memoryLabel.Text = memoryText
		end
	end)
end

function Library:Init(options)
	options = options or {}
	self:startRainbowLoop()
	self:buildShell(options)
	self:setTooltip(nil)
	task.defer(function()
		Utility.centerWindow(self.Main)
	end)
	return self
end

function Library:Create(options)
	return self:Init(options)
end

return Library
