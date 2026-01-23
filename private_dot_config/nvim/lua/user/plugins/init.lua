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

	"arthurxavierx/vim-caser",
	"chaoren/vim-wordmotion",
	"dag/vim-fish",
	"jparise/vim-graphql",
	"pantharshit00/vim-prisma",

	"JoosepAlviste/nvim-ts-context-commentstring",

	-- Git
	"tpope/vim-fugitive",
	"tpope/vim-rhubarb",

	"tpope/vim-abolish",
}
