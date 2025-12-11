local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- 色定義
local purple = "#bd93f9"
local light_blue = "#6EADD8"
local blue = "#004CE1"
local orange = "#e19500"
local red = "#E50000"
local yellow = "#D7650C"
local green = "#00FF00"
local magenta = "#FF00FF"
local black = "#000000"
local white = "#FFFFFF"
local grey = "#808080"
local silver = "#C0C0C0"
local teal = "#008080"
local lime = "#00FF00"
local aqua = "#00FFFF"
local fuchsia = "#FF00FF"
local dark_red = "#8B0000"
local light_red = "#FF6B6B"
local dark_green = "#006400"
local light_green = "#90EE90"
local dark_blue = "#00008B"
local navy = "#000080"
local royal_blue = "#4169E1"
local sky_blue = "#87CEEB"
local cyan = "#00FFFF"
local dark_cyan = "#008B8B"
local pink = "#FFC0CB"
local hot_pink = "#FF69B4"
local violet = "#8A2BE2"
local indigo = "#4B0082"
local maroon = "#800000"
local brown = "#A52A2A"
local tan = "#D2B48C"
local beige = "#F5F5DC"
local olive = "#808000"
local gold = "#FFD700"
local dark_orange = "#FF8C00"
local coral = "#FF7F50"
local salmon = "#FA8072"
local crimson = "#DC143C"
local forest_green = "#228B22"
local sea_green = "#2E8B57"
local mint_green = "#98FB98"
local chartreuse = "#7FFF00"
local slate_grey = "#708090"
local dim_grey = "#696969"
local light_grey = "#D3D3D3"
local gainsboro = "#DCDCDC"
local snow = "#FFFAFA"
local ivory = "#FFFFF0"

-- 外観・テーマ設定
-- config.font = wezterm.font("Input Mono Condensed", { weight = "Regular" })
config.font = wezterm.font("Cica", { weight = "Regular" })
config.font_size = 15
config.line_height = 0.9
config.window_background_opacity = 0.70
config.window_decorations = "TITLE | RESIZE" -- TITLE | RESIZE | NONE から選択
config.macos_window_background_blur = 20
config.text_background_opacity = 1.0

-- カラー設定
config.colors = {
	split = purple,
	selection_fg = red,
	cursor_bg = orange,
	cursor_fg = blue,
	cursor_border = purple,
	ansi = {
		black,
		red,
		green,
		yellow,
		blue,
		magenta,
		teal,
		silver,
	},
	brights = {
		grey,
		red,
		lime,
		yellow,
		blue,
		fuchsia,
		aqua,
		white,
	},
}

-- 設定ファイルの自動リロード
config.automatically_reload_config = true

-- スクロールバー設定
config.enable_scroll_bar = true
config.min_scroll_bar_height = "2cell"

-- 環境変数の設定（lazygit等を日本語化）
config.set_environment_variables = {
	LANG = "ja_JP.UTF-8",
	LC_ALL = "ja_JP.UTF-8",
	LC_CTYPE = "ja_JP.UTF-8",
	LC_MESSAGES = "ja_JP.UTF-8",
}

-- アクティブ/非アクティブペインの視覚的区別
config.inactive_pane_hsb = {
	saturation = 0.9, -- 彩度を下げる
	brightness = 0.2, -- 明度を下げる（暗くする）
}

-- リーダーキー設定 (ctrl + f)
config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1500 }

-- キーバインド設定
config.keys = {
	-- shift + enter で改行（リテラル改行文字を送信）
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\n"),
	},
	-- cmd + d で横に画面分割（ホームディレクトリで開く）
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitPane({
			direction = "Right",
			command = { cwd = wezterm.home_dir },
		}),
	},
	-- cmd + shift + d で縦方向に画面分割（ホームディレクトリで開く）
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitPane({
			direction = "Down",
			command = { cwd = wezterm.home_dir },
		}),
	},
	-- cmd + t でタブ作成（ホームディレクトリで開く）
	{
		key = "t",
		mods = "CMD",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
		}),
	},
	-- cmd + w で現在のペインを閉じる（確認なし）
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
	},
	-- リーダーキー + h,j,k,l で分割した画面の移動 (Vimスタイル)
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	-- cmd + 数字で特定のタブに移動
	{
		key = "1",
		mods = "CMD",
		action = wezterm.action.ActivateTab(0),
	},
	{
		key = "2",
		mods = "CMD",
		action = wezterm.action.ActivateTab(1),
	},
	{
		key = "3",
		mods = "CMD",
		action = wezterm.action.ActivateTab(2),
	},
	{
		key = "4",
		mods = "CMD",
		action = wezterm.action.ActivateTab(3),
	},
	{
		key = "5",
		mods = "CMD",
		action = wezterm.action.ActivateTab(4),
	},
	{
		key = "6",
		mods = "CMD",
		action = wezterm.action.ActivateTab(5),
	},
	{
		key = "7",
		mods = "CMD",
		action = wezterm.action.ActivateTab(6),
	},
	{
		key = "8",
		mods = "CMD",
		action = wezterm.action.ActivateTab(7),
	},
	{
		key = "9",
		mods = "CMD",
		action = wezterm.action.ActivateTab(8),
	},
	-- cmd + a で全選択
	{
		key = "a",
		mods = "CMD",
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
	},
	-- cmd + c でコピー
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action.CopyTo("Clipboard"),
	},
	-- cmd + v でペースト
	{
		key = "v",
		mods = "CMD",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
}

return config
