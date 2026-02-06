local wezterm = require("wezterm")

local M = {}

function M.apply(config)
	-- リーダーキー設定 (ctrl + f)
	config.leader = { key = "f", mods = "CTRL", timeout_milliseconds = 1500 }

	-- キーバインド設定
	config.keys = {
		-- shift + enter で改行
		{
			key = "Enter",
			mods = "SHIFT",
			action = wezterm.action.SendString("\n"),
		},
		-- cmd + d で横に画面分割
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action.SplitPane({
				direction = "Right",
				command = { cwd = wezterm.home_dir },
			}),
		},
		-- cmd + shift + d で縦方向に画面分割
		{
			key = "d",
			mods = "CMD|SHIFT",
			action = wezterm.action.SplitPane({
				direction = "Down",
				command = { cwd = wezterm.home_dir },
			}),
		},
		-- cmd + t でタブ作成
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
		{ key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
		{ key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
		{ key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
		{ key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
		{ key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
		{ key = "6", mods = "CMD", action = wezterm.action.ActivateTab(5) },
		{ key = "7", mods = "CMD", action = wezterm.action.ActivateTab(6) },
		{ key = "8", mods = "CMD", action = wezterm.action.ActivateTab(7) },
		{ key = "9", mods = "CMD", action = wezterm.action.ActivateTab(8) },
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
		-- cmd + enter でフルスクリーントグル
		{
			key = "Enter",
			mods = "CMD",
			action = wezterm.action.ToggleFullScreen,
		},
		-- cmd + 右矢印で次のタブへ
		{
			key = "RightArrow",
			mods = "CMD",
			action = wezterm.action.ActivateTabRelative(1),
		},
		-- cmd + 左矢印で前のタブへ
		{
			key = "LeftArrow",
			mods = "CMD",
			action = wezterm.action.ActivateTabRelative(-1),
		},
		-- cmd + shift + l で 開発レイアウトを作成
		{
			key = "l",
			mods = "CMD|SHIFT",
			action = wezterm.action_callback(function(window, pane)
				-- 1. 現在のペイン（左上）で cb loogia を実行
				pane:send_text("cb loogia\n")

				-- 2. 右に2回分割して3列作成
				local middle_pane = pane:split({ direction = "Right" })
				local right_pane = middle_pane:split({ direction = "Right" })

				-- 3. 一番左のペインで下に分割
				local left_middle_pane = pane:split({ direction = "Bottom" })

				-- 4. 左中のペインで cb loogia 実行
				left_middle_pane:send_text("cb loogia\n")

				-- 5. 左中のペインでさらに下に分割
				local left_bottom_pane = left_middle_pane:split({ direction = "Bottom" })

				-- 6. 左下のペインで cb loogia 実行
				left_bottom_pane:send_text("cb loogia\n")

				-- 7. 真ん中のペインで cb loogia && nvim 実行
				middle_pane:send_text("cb loogia && nvim\n")

				-- 8. 一番右のペインで下に分割
				local right_bottom_pane = right_pane:split({ direction = "Bottom" })

				-- 9. 右上のペインで cb loogia && lg 実行
				right_pane:send_text("cb loogia && lg\n")

				-- 10. 右下のペインで cb loogia && lsql 実行
				right_bottom_pane:send_text("cb loogia && lsql\n")
			end),
		},
	}
end

return M
