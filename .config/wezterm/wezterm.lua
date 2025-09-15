local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- 外観・テーマ設定
config.color_scheme = "Flat (base16)"
config.font = wezterm.font("MesloLGS NF", { weight = "Regular" })
config.font_size = 12
config.line_height = 0.9
config.window_background_opacity = 0.95
config.window_decorations = "RESIZE" -- TITLE | RESIZE | NONE から選択

-- 設定ファイルの自動リロード
config.automatically_reload_config = true

-- アクティブ/非アクティブペインの視覚的区別
config.inactive_pane_hsb = {
	saturation = 0.9, -- 彩度を下げる
	brightness = 0.4, -- 明度を下げる（暗くする）
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
	-- cmd + w で現在のペインを閉じる
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
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
