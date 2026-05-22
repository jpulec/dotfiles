return {
	"nvim-tree/nvim-web-devicons",

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
	},
	{ "dracula/vim", name = "dracula", lazy = true },

	-- vim-abolish already provides `crs/crc/crm/cru/crk/...` coercions, so vim-caser is removed.
	"chaoren/vim-wordmotion",
	"dag/vim-fish",
	"jparise/vim-graphql",
	"pantharshit00/vim-prisma",

	-- JSON/YAML schemas for jsonls and yamlls
	{ "b0o/SchemaStore.nvim", lazy = true, version = false },

	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		opts = {
			-- The CursorHold autocmd is unnecessary with the comment.nvim
			-- integration (which calls it on-demand), and triggers treesitter
			-- parsing on every cursor hold.
			enable_autocmd = false,
		},
	},

	-- Git
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	"tpope/vim-abolish",
}
