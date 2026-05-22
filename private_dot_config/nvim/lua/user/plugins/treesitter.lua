return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	main = "nvim-treesitter",
	opts = {
		ensure_installed = {
			-- Neovim essentials (query/vim/vimdoc needed by treesitter & help files)
			"lua",
			"luadoc",
			"query",
			"vim",
			"vimdoc",
			-- Config / data formats
			"bash",
			"diff",
			"dockerfile",
			"gitcommit",
			"gitignore",
			"json",
			"jsonc",
			"markdown",
			"markdown_inline",
			"regex",
			"toml",
			"yaml",
			-- Web / JS ecosystem
			"css",
			"graphql",
			"html",
			"javascript",
			"prisma",
			"scss",
			"tsx",
			"typescript",
			-- Other languages
			"fish",
			"python",
		},
	},
}
