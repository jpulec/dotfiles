return {
	"stevearc/aerial.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{ "<leader>a", "<cmd>AerialToggle!<cr>", desc = "Toggle Aerial (code outline)" },
		{ "{", "<cmd>AerialPrev<cr>", desc = "Previous symbol" },
		{ "}", "<cmd>AerialNext<cr>", desc = "Next symbol" },
	},
	opts = {
		backends = { "treesitter", "lsp", "markdown", "man" },
		layout = {
			min_width = 30,
			default_direction = "prefer_right",
		},
		attach_mode = "global",
		filter_kind = {
			"Class",
			"Constructor",
			"Enum",
			"Function",
			"Interface",
			"Method",
			"Module",
			"Namespace",
			"Struct",
		},
		show_guides = true,
		guides = {
			mid_item = "├─",
			last_item = "└─",
			nested_top = "│ ",
			whitespace = "  ",
		},
	},
}
