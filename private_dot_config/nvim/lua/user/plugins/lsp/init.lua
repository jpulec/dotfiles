return {
	{
		"igorlfs/nvim-lsp-file-operations",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-tree.lua",
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
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
