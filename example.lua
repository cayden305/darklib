local source = (game :: any):HttpGet("https://raw.githubusercontent.com/cayden305/darklib/refs/heads/main/UILib.lua")
local UI = assert(loadstring(source))()

--init
UI:Init({
    Title = "UI Library Example",
    Subtitle = "Every supported control",
})

--tabs
local settingsTab = UI:AddTab({ Name = "Settings", Icon = "settings" })
local secondTab = UI:AddTab({ Name = "Information", Icon = "info" })

--sections
local about = secondTab:AddSection({
    Name = "About",
    Description = "",
    Icon = "folder",
})
local controls = settingsTab:AddSection({
    Name = "Controls",
    Description = "every element.",
    Icon = "keyboard",
})
local appearance = settingsTab:AddSection({
    Name = "Appearance",
    Description = "Customize the window",
    Icon = "sparkles",
})

--elements
appearance:AddSlider({
    Name = "Window Transparency",
    Description = "Adjust the interface transparency.",
    Min = 10,
    Max = 45,
    Default = 25,
    Decimals = 0,
    Suffix = "%",
    Callback = function(value)
        UI:setMainTransparency(value / 100)
    end,
})

appearance:AddToggle({
    Name = "Background Particles",
    Description = "Toggle constellation.",
    Default = true,
    Callback = function(enabled)
        UI.ConstellationEnabled = enabled
        if UI.ConstellationContainer then
            UI.ConstellationContainer.Visible = enabled
        end
    end,
})

appearance:AddSlider({
    Name = "Particle Count",
    Description = "Number of particles.",
    Min = 0,
    Max = 100,
    Default = 18,
    Decimals = 0,
    Callback = function(value)
        UI:setParticleCount(value)
    end,
})

appearance:AddSlider({
    Name = "Particle Speed",
    Description = "Speed of the particles.",
    Min = 0,
    Max = 100,
    Default = 45,
    Decimals = 0,
    Suffix = "%",
    Callback = function(value)
        UI:setParticleSpeed(value / 100)
    end,
})

appearance:AddSlider({
    Name = "Link Distance",
    Description = "Particle link distance.",
    Min = 1,
    Max = 60,
    Default = 22,
    Decimals = 0,
    Suffix = "%",
    Callback = function(value)
        UI:setParticleLinkDistance(value / 100)
    end,
})

appearance:AddSlider({
    Name = "Maximum Links",
    Description = "Maximum number of visible connections.",
    Min = 0,
    Max = 300,
    Default = 110,
    Decimals = 0,
    Callback = function(value)
        UI:setParticleMaxLinks(value)
    end,
})

appearance:AddDropdown({
    Name = "Particle Mode",
    Description = "Choose movement.",
    Options = { "Default Mode", "Alternate Mode" },
    Default = "Default Mode",
    Callback = function(value)
        UI:setParticleMode(value)
    end,
})

appearance:AddColorWheel({
    Name = "Particle Color",
    Description = "Change color.",
    Default = "#FFFFFF",
    Callback = function(color)
        UI:setParticleColor(color)
    end,
})

controls:AddDisplay({
    Name = "Display",
    Description = "Read-only display",
    Value = "dajsdisoajdisjaidaoj",
})

controls:AddButton({
    Name = "Button",
    Description = "Run an action.",
    ButtonText = "Click",
    Tooltip = "Print a message to the console.",
    Callback = function()
        print("Button pressed")
        UI:notify("Button pressed")
    end,
})

controls:AddInput({
    Name = "Input",
    Description = "Enter text.",
    Placeholder = "Type something...",
    Default = "Hello",
    Callback = function(value)
        print("Input:", value)
    end,
})

controls:AddToggle({
    Name = "Toggle",
    Description = "Enable or disable a feature.",
    Default = false,
    Tooltip = "This is a toggle.",
    Callback = function(value)
        print("Toggled:", value)
    end,
})

controls:AddSlider({
    Name = "Slider",
    Description = "Choose a numeric value.",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(value)
        print("Slider:", value)
    end,
})

controls:AddDropdown({
    Name = "Dropdown",
    Description = "Choose one option.",
    Options = { "First", "Second", "Third" },
    Default = "First",
    Searchable = true,
    Callback = function(value)
        print("Dropdown:", value)
    end,
})

controls:AddDropdown({
    Name = "Multi-select",
    Description = "Choose multiple options.",
    Options = { "Red", "Green", "Blue" },
    MultiSelect = true,
    Placeholder = "Select colors",
    Callback = function(values)
        print("Selected colors:", table.concat(values, ", "))
    end,
})

controls:AddColorWheel({
    Name = "Color picker",
    Description = "Choose a Color3 value.",
    Default = "#9689FF",
    Callback = function(color)
        print("Color:", color)
    end,
})

controls:AddKeybind({
    Name = "Keybind",
    Description = "Bind an action to a key.",
    Default = Enum.KeyCode.G,
    OnTriggered = function(keyCode)
        print("Key pressed:", keyCode.Name)
    end,
})

local console = controls:AddConsole({
    Name = "Console",
    Description = "Register and run commands.",
    Commands = {
        hello = {
            Help = "Print a greeting.",
            Callback = function()
                return "Hello from the example console."
            end,
        },
    },
})
console:Log("Custom console message.")

about:AddDisplay({ Name = "Library", Value = "darklib" })
about:AddDisplay({ Name = "Version", Value = "one point oh" })
