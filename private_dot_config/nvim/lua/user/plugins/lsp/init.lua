return {
	{
		"igorlfs/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
	},
	{
		"rachartier/tiny-code-action.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		event = "LspAttach",
		config = function()
			require("tiny-code-action").setup()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"nvim-cmp",
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"nvim-lua/lsp-status.nvim",
			"tamago324/nlsp-settings.nvim",
		},
		config = function()
			local mason = require("mason")
			local masonLsp = require("mason-lspconfig")

			mason.setup({
				PATH = "append",
			})
			masonLsp.setup({
				automatic_enable = false,
			})
			require("user.plugins.lsp.configs").setup()
			require("user.plugins.lsp.handlers").setup()
			require("user.plugins.lsp.file-operations")
		end,
	},
}
