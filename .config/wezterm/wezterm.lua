local wezterm = require("wezterm")
local appearance = require("appearance")
local keybindings = require("keybindings")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- 外観設定を適用
appearance.apply(config)
appearance.setup_tab_title()

-- キーバインド設定を適用
keybindings.apply(config)

return config
