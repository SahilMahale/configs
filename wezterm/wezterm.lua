-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

config.automatically_reload_config = true
config.color_scheme = "Catppuccin Mocha"
config.window_background_opacity = 0.95
config.font = wezterm.font_with_fallback({
	"Fira Code",
})
config.font = wezterm.font("IosevkaTerm NFM", { italic = false })
config.font_size = 15

--Tab styff
config.keys = {
	{ key = "F9", mods = "ALT", action = wezterm.action.ShowTabNavigator },
	{ key = "-", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "=", mods = "ALT", action = act.ActivateTabRelative(1) },
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
}
for i = 1, 8 do
	-- CTRL+ number to activate that tab
	table.insert(config.keys, {
		key = tostring(i),
		mods = "CTRL",
		action = act.ActivateTab(i - 1),
	})
	-- F1 through F8 to activate that tab
	table.insert(config.keys, {
		key = "F" .. tostring(i),
		action = act.ActivateTab(i - 1),
	})
end

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.max_fps = 240
config.window_decorations = "NONE"

return config
