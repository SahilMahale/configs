-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action

config.automatically_reload_config = true
config.color_scheme = "Poimandres"
config.window_background_image = "/Users/sahil.mahale/Downloads/BlackWall.png"
config.window_background_opacity = 1
-- config.macos_window_background_blur = 20
config.window_background_image_hsb = {
	brightness = 0.6,
	hue = 1.0,
	saturation = 1.0,
}
config.font = wezterm.font_with_fallback({
	{ family = "CartographCF Nerd Font", weight = "Regular", style = "Normal" },
	{ family = "Symbols Nerd Font Mono", scale = 0.75 },
})
--config.font = wezterm.font("IosevkaTerm NFM", { italic = false })
config.font_size = 16
config.cell_width = 1

--Tab styff
config.keys = {
	{ key = "-", mods = "ALT", action = act.ActivateTabRelative(-1) },
	{ key = "=", mods = "ALT", action = act.ActivateTabRelative(1) },
	{
		key = "w",
		mods = "CTRL",
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "r",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
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

config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
config.max_fps = 119
-- config.window_decorations = "NONE"
-- for windows wsl launch
-- config.default_domain = 'WSL:Ubuntu-20.04'
config.initial_rows = 50
config.initial_cols = 165

return config
