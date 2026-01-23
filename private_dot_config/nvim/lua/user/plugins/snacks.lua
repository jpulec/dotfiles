return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		notifier = { enabled = false }, -- Using noice.nvim instead
		lazygit = { enabled = true },
		quickfile = { enabled = true },
		bufdelete = { enabled = true },
		indent = {
			enabled = true,
			char = "▏",
			scope = { enabled = true },
			chunk = { enabled = false },
			animate = { enabled = false }, -- Disable animation for performance
		},
		dashboard = {
			enabled = true,
			preset = {
				header = [[
                               __                
  ___     ___    ___   __  __ /\_\    ___ ___    
 / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  
/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ 
\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
 \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
				keys = {
					{ icon = "󰈞 ", key = "f", desc = "Find File", action = ":Telescope find_files" },
					{ icon = " ", key = "e", desc = "New File", action = ":ene | startinsert" },
					{ icon = "󰄉 ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
					{ icon = "󰊄 ", key = "t", desc = "Find Text", action = ":Telescope live_grep" },
					{ icon = " ", key = "c", desc = "Config", action = ":e ~/.config/nvim/init.lua" },
					{ icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
					{ icon = "󰅚 ", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
				{ text = "jamespulec.com", align = "center", hl = "Type" },
			},
		},
	},
	keys = {
		{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
		{ "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "Lazygit file history" },
		{ "<leader>gL", function() Snacks.lazygit.log() end, desc = "Lazygit log" },
	},
}
