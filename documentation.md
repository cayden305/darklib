# DarkLib

Roblox UI library.

## Loading

```lua
local source = (game :: any):HttpGet("https://raw.githubusercontent.com/cayden305/darklib/refs/heads/main/UILib.lua")
local UI = assert(loadstring(source))()
```

## Initialization

```lua
UI:Init({
    Title = "My UI",
    Subtitle = "My application",
    Size = UDim2.fromOffset(950, 600),
})
```

| Option | Type | Default | Description |
|---|---|---|---|
| `Title` | string | `"aeroWare"` | Main title. |
| `Subtitle` | string | `""` | Text below the title. |
| `Size` | `UDim2` | Desktop `UDim2.fromScale(0.5, 0.5)` | Initial window size. |

`UI:Create(options)` is an alias for `UI:Init(options)`.

The window can be dragged from the top bar and resized from the bottom-right handle. The first tab created is selected automatically.

## Tabs

```lua
local tab = UI:AddTab({
    Name = "Settings",
    Icon = "settings",
})

tab:Show()
```

| Option | Type | Default |
|---|---|---|
| `Name` | string | `"Tab"` |
| `Icon` | string | `"layout-panel-left"` |

Useful tab fields include `Page`, `LeftColumn`, `RightColumn`, `Active`, `ButtonFrame`, `ButtonIcon`, `ButtonTitle`, and `ButtonArrow`.


## Sections

```lua
local section = tab:AddSection({
    Name = "Interface",
    Description = "Global interface settings.",
    Icon = "keyboard",
})
```

| Option | Type | Default |
|---|---|---|
| `Name` | string | `"Section"` |
| `Description` | string | `""` |
| `Icon` | string/nil | `nil` |


## Common options

Most elements accept:

| Option | Type | Description |
|---|---|---|
| `Name` | string | Main label and search name. |
| `Description` | string | Secondary label. |
| `Tooltip` | string | Delayed desktop hover tooltip. |
| `Flag` | string | Key used by the config system. |
| `Save` | boolean | Whether the control participates in saving. Defaults to `true`. |
| `Callback` | function | Called when the value changes. |

Callbacks may receive a second `fromLoad` boolean when a saved value is applied.


## Display

```lua
local status = section:AddDisplay({
    Name = "Status",
    Description = "Current state.",
    Value = "Ready",
})

status:SetValue("Running")
print(status:GetValue())
```

Options: `Name`, `Description`, `Value` (default `"--"`), and `Tooltip`.

Methods:

| Method | Description |
|---|---|
| `SetValue(display)` | Updates the displayed text. |
| `GetValue()` | Returns the displayed text as a string. |


## Button

```lua
local button = section:AddButton({
    Name = "Refresh",
    ButtonText = "Run",
    Width = 90,
    Tooltip = "Refresh the data.",
    Callback = function()
        print("Refresh pressed")
    end,
})

button:Press()
```

Options: `Name`, `Description`, `ButtonText` (defaults to `Name`), `Width` (default `84`), `Tooltip`, and `Callback`.

Returned members: `Press()`, `GetValue()` (always `false`), `Button`, and `Save = false`.


## Input

```lua
local input = section:AddInput({
    Name = "Username",
    Description = "Enter a username.",
    Placeholder = "Username...",
    Default = "",
    Width = 180,
    Flag = "User.Username",
    Callback = function(value, fromLoad)
        print(value, fromLoad)
    end,
    OnEnter = function(value)
        print("Submitted:", value)
    end,
})

input:SetValue("Alice")
print(input:GetValue())
input.Box:CaptureFocus()
```

Options: `Name`, `Description`, `Placeholder` (default `"Type..."`), `Default`, `Width`, `Flag`, `Save`, `Tooltip`, `Callback`, and `OnEnter`.

Returned members:

| Member | Description |
|---|---|
| `SetValue(value, fromLoad, suppressCallback)` | Updates the text and optionally suppresses the callback. |
| `GetValue()` | Returns the current string. |
| `Box` | Underlying Roblox `TextBox`. |


## Toggle

```lua
local toggle = section:AddToggle({
    Name = "Enabled",
    Description = "Enable the feature.",
    Default = false,
    Flag = "Feature.Enabled",
    Callback = function(value, fromLoad)
        print("Enabled:", value)
    end,
})

toggle:SetValue(true)
print(toggle:GetValue())
```

Options: `Name`, `Description`, `Default`, `Flag`, `Save`, `Tooltip`, and `Callback`.

Methods: `SetValue(value, fromLoad)` and `GetValue()`.


## Slider

```lua
local slider = section:AddSlider({
    Name = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Decimals = 0,
    Suffix = "%",
    Editable = true,
    Flag = "Audio.Volume",
    Callback = function(value)
        print(value)
    end,
})

slider:SetValue(75)
print(slider:GetValue())
```

| Option | Type | Default | Description |
|---|---|---|---|
| `Min` | number | `0` | Minimum value. |
| `Max` | number | `100` | Maximum value. |
| `Default` | number | `Min` | Initial value. |
| `Decimals` | number | `0` | Rounding precision. |
| `Suffix` | string | `""` | Display-only suffix. |
| `Editable` / `editable` | boolean | `false` | Adds a numeric text field. |
| `NoLimit` / `nolimit` | boolean | `false` | Allows values outside the visual range. |

Also supports common options. Values are rounded and clamped to `Min..Max`.

Methods: `SetValue(value, fromLoad)` and `GetValue()`.


## Dropdown

### Single selection

```lua
local mode = section:AddDropdown({
    Name = "Mode",
    Options = { "Safe", "Fast", "Experimental" },
    Default = "Safe",
    Placeholder = "Select a mode",
    SearchPlaceholder = "Search modes...",
    Searchable = true,
    Callback = function(value)
        print(value)
    end,
})

mode:SetValue("Fast")
print(mode:GetValue())
```

### Multi-selection

```lua
local categories = section:AddDropdown({
    Name = "Categories",
    Options = { "Weapons", "Tools", "Materials" },
    Default = { "Tools" },
    MultiSelect = true,
    Placeholder = "Select categories",
    Callback = function(values)
        print(table.concat(values, ", "))
    end,
})
```

Options: `Name`, `Description`, `Options`, `Default`, `Placeholder`, `SearchPlaceholder`, `Searchable`, `MultiSelect`, `CloseOnSelect`, `Width`, `Flag`, `Save`, `Tooltip`, and `Callback`.

Methods:

| Method | Description |
|---|---|
| `SetValue(value, fromLoad, suppressCallback)` | Accepts a string or an array of strings. |
| `GetValue()` | Returns a string or a copied array for multi-selection. |
| `SetOptions(options, keepCurrent)` | Replaces, deduplicates, sorts, and rebuilds the options. |


## Color wheel

```lua
local picker = section:AddColorWheel({
    Name = "Accent color",
    Description = "Choose a color.",
    Default = "#9689FF",
    Flag = "Theme.Accent",
    ModeFlag = "Theme.Rainbow",
    DefaultRGBMode = false,
    Callback = function(color, rgbMode, fromLoad)
        print(color, rgbMode)
    end,
})

picker:SetValue("255,0,0")
print(picker:GetValue()) -- #FF0000
```

Options: `Name`, `Description`, `Default` (`Color3`, `#RRGGBB`, or `R,G,B`), `Flag`, `ModeFlag`, `DefaultRGBMode`, `Save`, `Tooltip`, and `Callback`.

Methods:

| Method | Description |
|---|---|
| `SetValue(color, fromLoad, suppressCallback)` | Applies a `Color3`, hex string, or RGB string. |
| `GetValue()` | Returns an uppercase hex string. |


## Keybind

```lua
local bind = section:AddKeybind({
    Name = "Toggle overlay",
    Default = Enum.KeyCode.G,
    Flag = "Overlay.Key",
    OnTriggered = function(keyCode)
        print("Pressed:", keyCode.Name)
    end,
})

bind:SetValue(Enum.KeyCode.H)
print(bind:GetValue())
```

Options: `Name`, `Description`, `Default`, `Flag`, `Save`, `Tooltip`, `Callback`, and `OnTriggered`.

Methods: `SetValue(value, fromLoad)` and `GetValue()`.

Press Backspace while capturing a key to set the value to `"None"`. The global UI toggle is ignored while capturing.


## Console

```lua
local console = section:AddConsole({
    Name = "Debug console",
    MaxEntries = 100,
    Welcome = "Ready.",
    Commands = {
        greet = {
            Help = "Print a greeting.",
            Callback = function(arguments)
                return "Hello " .. (arguments[1] or "world")
            end,
        },
    },
})

console:Log("Application started")
console:RegisterCommand("echo", "Echo text", function(arguments)
    return table.concat(arguments, " ")
end)
console:RunCommand("greet Alice")
```

Options: `Name`, `Description`, `MaxEntries` (default `250`), `Welcome`, and `Commands`.

Console methods: `Log(message, color)`, `RegisterCommand(name, helpText, callback)`, and `RunCommand(raw)`.

Built-in commands: `help`, `clear`, `rejoin`, `serverhop`, `echo`, `iy`, `dex`, `dev-iy`, and `rspy simple/hydro`.

```lua
UI:notifyConsole("Debug console", "Background task finished")
```


## Notifications

```lua
UI:notify("Saved successfully")
UI:notify("This message stays longer", 8)
UI.DefaultNotificationTime = 6
```

`UI:notify(message, duration)` creates an animated notification. Duration defaults to `UI.DefaultNotificationTime` or `4`, and is clamped to `0.1..60` seconds.


## Visibility

```lua
UI:setVisible(false)
UI:setVisible(true)
UI:toggleVisible()
UI:releaseFocusedInput()
UI:setTooltip("Temporary help text")
UI:setTooltip(nil)
```

The default global toggle key is `RightShift`:

```lua
UI.ToggleKeyName = "Insert"
```


## Appearance and particles

```lua
UI:setMainTransparency(0.15)
UI:setParticleCount(24)
UI:setParticleMaxLinks(100)
UI:setParticleLinkDistance(0.22)
UI:setParticleSpeed(0.4)
UI:setParticleMode("Alternate Mode")
UI:setParticleColor(Color3.fromRGB(150, 137, 255))
```

| Function | Range/format | Description |
|---|---|---|
| `setMainTransparency(alpha)` | `0..1` | Applies global UI transparency. |
| `setParticleCount(count)` | `0..100` | Sets the particle count. |
| `setParticleMaxLinks(count)` | `0..300` | Sets the line pool size. |
| `setParticleLinkDistance(distance)` | `0.01..1` | Sets normalized connection distance. |
| `setParticleSpeed(speed)` | `0..4` | Sets particle movement speed. |
| `setParticleMode(mode)` | string | Supports `Default Mode` and `Alternate Mode`. |
| `setParticleColor(color)` | `Color3` | Sets static particle/link color. |

After `Init`, particle state is available through `ConstellationEnabled`, `ConstellationContainer`, `RainbowHue`, and `RainbowColor`.


## Flags and configuration

Controls register automatically when given a `Flag`:

```lua
local toggle = section:AddToggle({
    Name = "Enabled",
    Flag = "Example.Enabled",
    Default = false,
})
```

Useful methods:

| Method | Description |
|---|---|
| `registerFlag(flag, entry)` | Manually registers an entry. |
| `updateFlag(flag, value)` | Changes the in-memory flag only. |
| `collectConfig()` | Returns current registered values. |
| `saveConfig(showNotification, name)` | Saves registered values to a profile. |
| `loadConfig(showNotification, name)` | Loads a profile into registered entries. |
| `listConfigProfiles()` | Lists available profiles. |
| `setActiveConfig(name, showNotification)` | Selects a profile. |
| `setAutoloadConfig(name, showNotification)` | Sets the autoload profile. |
| `clearAutoloadConfig(showNotification)` | Clears autoload. |

File configuration requires compatible executor functions such as `writefile`, `readfile`, `makefolder`, `isfile`, and `listfiles`.


## Search, themes, and icons

The top search box indexes tabs, sections, and controls by `Name`. Results switch tabs, scroll to the item, and flash its row.

`Tooltip` values create delayed desktop hover tooltips and are skipped on touch-only devices.

Theme colors are available through `UI.Theme`, including `Background`, `Sidebar`, `Panel`, `PanelDark`, `PanelLight`, `Border`, `Accent`, `AccentSoft`, `Text`, `TextSoft`, `TextMute`, and `Purple`.

Built-in icon names:

```text
sword, eye, globe-2, zap, move, bot, play-square, monitor,
folder, settings, layout-panel-left, wrench, keyboard, save,
trash-2, refresh-cw, terminal-square, plus, search, file-text,
help-circle, info, chevron-left, chevron-right, x, more-horizontal,
sliders-horizontal, circle-check, square-check, cog, move-diagonal-2,
sparkles, mailbox, server, database, archive, inbox, cloud
```


## Complete example

```lua
local source = (game :: any):HttpGet("https://raw.githubusercontent.com/cayden305/darklib/refs/heads/main/UILib.lua")
local UI = assert(loadstring(source))()

UI:Init({
    Title = "Example UI",
    Subtitle = "Reusable rev4 interface",
})

local tab = UI:AddTab({ Name = "Settings", Icon = "settings" })
local section = tab:AddSection({
    Name = "General",
    Description = "Application controls.",
    Icon = "keyboard",
})

local enabled = section:AddToggle({
    Name = "Enabled",
    Default = false,
    Flag = "Example.Enabled",
    Callback = function(value)
        print("Enabled:", value)
    end,
})

local mode = section:AddDropdown({
    Name = "Mode",
    Options = { "Basic", "Advanced" },
    Default = "Basic",
})

section:AddButton({
    Name = "Notify",
    ButtonText = "Show",
    Callback = function()
        UI:notify("Current mode: " .. mode:GetValue())
    end,
})

enabled:SetValue(true)
mode:SetValue("Advanced")
```
