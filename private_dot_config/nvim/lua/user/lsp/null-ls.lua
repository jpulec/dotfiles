local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

null_ls.setup({
	sources = {
		formatting.prettier_d_slim.with({
			extra_args = { "--prettier-path", "./.yarn/sdks/prettier" },
		}),
		diagnostics.eslint_d.with({
			-- There's an issue with core_d where it tries to run from first manifest file as current directory.
			extra_args = { "--eslint-path", "../../.yarn/sdks/eslint" },
		}),
		code_actions.eslint_d.with({
			-- There's an issue with core_d where it tries to run from first manifest file as current directory.
			extra_args = { "--eslint-path", "../../.yarn/sdks/eslint" },
		}),
		formatting.stylua,
	},
})
