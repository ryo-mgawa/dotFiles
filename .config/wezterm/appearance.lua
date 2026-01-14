local wezterm = require("wezterm")
local colors = require("colors")

local M = {}

function M.apply(config)
	-- フォント設定
	config.font = wezterm.font("Cica", { weight = "Regular" })
	config.font_size = 15
	config.line_height = 0.9

	-- ウィンドウ設定
	config.window_background_opacity = 0.70
	config.window_decorations = "RESIZE"
	config.macos_window_background_blur = 20
	config.text_background_opacity = 1.0

	-- タブバー設定
	config.hide_tab_bar_if_only_one_tab = true
	config.show_new_tab_button_in_tab_bar = false
	config.window_frame = {
		inactive_titlebar_bg = "none",
		active_titlebar_bg = "none",
	}
	config.window_background_gradient = {
		colors = { "#000000" },
	}

	-- カラー設定
	config.colors = {
		tab_bar = {
			inactive_tab_edge = "none",
		},
		split = colors.purple,
		selection_fg = colors.red,
		cursor_bg = colors.orange,
		cursor_fg = colors.blue,
		cursor_border = colors.purple,
		ansi = {
			colors.black,
			colors.red,
			colors.green,
			colors.yellow,
			colors.blue,
			colors.magenta,
			colors.teal,
			colors.silver,
		},
		brights = {
			colors.grey,
			colors.red,
			colors.lime,
			colors.yellow,
			colors.blue,
			colors.fuchsia,
			colors.aqua,
			colors.white,
		},
	}

	-- スクロールバー設定
	config.enable_scroll_bar = true
	config.min_scroll_bar_height = "2cell"

	-- アクティブ/非アクティブペインの視覚的区別
	config.inactive_pane_hsb = {
		saturation = 0.9,
		brightness = 0.2,
	}

	-- 設定ファイルの自動リロード
	config.automatically_reload_config = true

	-- 環境変数の設定
	config.set_environment_variables = {
		LANG = "ja_JP.UTF-8",
		LC_ALL = "ja_JP.UTF-8",
		LC_CTYPE = "ja_JP.UTF-8",
		LC_MESSAGES = "ja_JP.UTF-8",
	}
end

-- タブタイトルのフォーマット設定
function M.setup_tab_title()
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local background = "#5c6d74"
		local foreground = "#FFFFFF"

		if tab.is_active then
			background = "#ae8b2d"
			foreground = "#FFFFFF"
		end

		local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

		return {
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
		}
	end)
end

return M
