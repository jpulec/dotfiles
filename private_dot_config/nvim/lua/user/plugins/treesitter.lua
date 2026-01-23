return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",
	opts = {
		ensure_installed = { "tsx", "typescript" },
		sync_install = false,
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = { enable = true, disable = { "yaml" } },
		autopairs = { enable = true },
		--rainbow = { enable = true, extended_mode = true },
	},
}
