return {
	"stevearc/dressing.nvim",
	event = "VeryLazy",
	opts = {
		input = {
			enabled = true,
			default_prompt = "Input:",
			title_pos = "center",
			insert_only = true,
			start_in_insert = true,
			border = "rounded",
			relative = "cursor",
			prefer_width = 40,
			win_options = {
				winblend = 10,
			},
		},
		select = {
			enabled = true,
			backend = { "telescope", "builtin" },
			trim_prompt = true,
			telescope = require("telescope.themes").get_dropdown(),
			builtin = {
				border = "rounded",
				relative = "cursor",
				win_options = {
					winblend = 10,
				},
			},
		},
	},
}
