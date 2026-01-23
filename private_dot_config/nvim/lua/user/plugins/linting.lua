return {
	{
		"mfussenegger/nvim-lint",
		opts = {
			-- Event to trigger linters
			events = { "BufWritePost", "BufReadPost", "InsertLeave", "TextChanged" },
			linters_by_ft = {
				actionlint = { "actionlint" },
				dotenv = { "dotenv_linter" },
				fish = { "fish" },
				javascript = { "oxlint" },
				javascriptreact = { "oxlint" },
				typescript = { "oxlint" },
				typescriptreact = { "oxlint" },
				["*"] = { "cspell" },
			},
		},
		config = function(_, opts)
			local lint = require("lint")
			lint.linters_by_ft = opts.linters_by_ft
			lint.linters.dotenv_linter.args = { "--quiet", "--no-color", "--skip=UnorderedKey" }

			vim.api.nvim_create_autocmd(opts.events, {
				group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"dmmulroy/tsc.nvim",
		opts = {},
	},
	{
		"folke/trouble.nvim",
		opts = {},
	},
}
