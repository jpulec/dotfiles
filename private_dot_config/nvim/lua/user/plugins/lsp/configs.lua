local servers = {
	"bashls",
	"biome",
	"dockerls",
	--"harper_ls",
	"html",
	"hyprls",
	"jsonls",
	"lua_ls",
	"prismals",
	"pylsp",
	"rust_analyzer",
	"sqlls",
	"tailwindcss",
	"terraformls",
	--"ts_ls",
	"tsgo",
	"yamlls",
}

--local base_opts = {
--	on_attach = require("user.plugins.lsp.handlers").on_attach,
--	capabilities = require("user.plugins.lsp.handlers").capabilities,
--}
--
--for _, server in pairs(servers) do
--	local opts = base_opts
--	if ok then
--		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
--	end
--	vim.lsp.config(server, opts)
--	vim.lsp.enable(server)
--end

-- plugins/user/lsp/configs.lua
local M = {}

-- build capabilities once (cmp + lsp-status if present)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
end)
-- Ensure codeAction literal support is present even without cmp_nvim_lsp
capabilities.textDocument = capabilities.textDocument or {}
capabilities.textDocument.codeAction = capabilities.textDocument.codeAction or {}
capabilities.textDocument.codeAction.dynamicRegistration = true
capabilities.textDocument.codeAction.codeActionLiteralSupport = capabilities.textDocument.codeAction.codeActionLiteralSupport
	or {
		codeActionKind = {
			valueSet = {
				"quickfix",
				"refactor",
				"refactor.extract",
				"refactor.inline",
				"refactor.rewrite",
				"source",
				"source.organizeImports",
				"source.fixAll",
				-- TS-specific kinds commonly used by typescript-language-server:
				"source.addMissingImports.ts",
				"source.removeUnused.ts",
				"source.removeUnusedImports.ts",
				"source.sortImports.ts",
				"source.organizeImports.ts",
				"source.fixAll.ts",
			},
		},
	}

pcall(function()
	local ok, lsp_status = pcall(require, "lsp-status")
	if ok then
		capabilities = vim.tbl_extend("keep", capabilities, lsp_status.capabilities)
	end
end)

function M.setup()
	-- 1) set global defaults applied to every server (no per-server on_attach needed)
	vim.lsp.config("*", {
		capabilities = capabilities,
		-- you can put other global defaults here if you want
	})

	-- 2) enable whichever servers you want; Neovim will auto-merge lua/lsp/<server>.lua
	for _, server in pairs(servers) do
		vim.lsp.enable(server)
	end
end
return M
