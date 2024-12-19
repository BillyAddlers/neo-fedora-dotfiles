-- pull in the wezterm api
local wezterm = require("wezterm")

-- this will hold the configuration.
local config = wezterm.config_builder()

-- NOTE: CONFIG STARTS HERE
-- this is where you actually apply your config choices
-- note that this configuration is opinionated and does reflect user's personality

-- Use the defaults as a base
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- make task numbers clickable
-- the first matched regex group is captured in $1.
table.insert(config.hyperlink_rules, {
	regex = [[\b[tt](\d+)\b]],
	format = "https://example.com/tasks/?t=$1",
})

-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[["]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["]?]],
	format = "https://www.github.com/$1/$3",
})

-- make github commit hashes clickable
-- this will match any 7-40 character long string that is a hex value
table.insert(config.hyperlink_rules, {
	regex = [[\b[0-9a-f]{7,40}\b]],
	format = "https://www.github.com/commit/$0",
})

-- Using the catppuccino colorscheme
config.color_scheme = "catppuccin-mocha"

-- set the font and font size
config.font = wezterm.font_with_fallback({ "JetBrainsMonoNL", "CascadiaCodeNF" })
config.font_size = 12

config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- enable ligatures
config.harfbuzz_features = { "ss01", "calt=1", "clig=1", "liga=1" }

-- set max fps
config.max_fps = 120

-- enable kitty graphics
config.enable_kitty_graphics = true

-- configuring tab bar and scroll bar
config.enable_tab_bar = false
config.enable_scroll_bar = false

-- set the window decorations
-- RESIZE, TITLE, RESIZE | TITLE, NONE
config.window_decorations = "NONE"
config.window_background_opacity = 0.85

-- NOTE: From here below is a configuration for Shortcuts, etc.
-- Feel free to change accordingly

-- NOTE: Below is a configuration for external plugins
-- Feel free to change accorrdingly

-- local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
-- bar.apply_to_config(config)

-- local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
-- -- tabline.get_config()
-- tabline.setup()
-- tabline.apply_to_config(config)

-- and finally, return the configuration to wezterm
return config
