return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "modern",
		delay = 300,
		spec = {
			{ "<leader>b", group = "buffer" },
			{ "<leader>c", group = "code" },
			{ "<leader>g", group = "git" },
			{ "<leader>n", group = "notifications" },
			{ "<leader>q", group = "session" },
			{ "<leader>r", group = "refactor" },
			{ "<leader>s", group = "search/replace" },
			{ "<leader>x", group = "diagnostics" },
		},
	},
}
