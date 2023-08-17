local lspconfig = require("lspconfig")
local typescript_status_ok, typescript = pcall(require, "typescript")

local servers = {
	"bashls",
	"dockerls",
	"html",
	"jsonls",
	"pylsp",
	"sqlls",
	"lua_ls",
	"tailwindcss",
	"terraformls",
	"yamlls",
	"prismals",
	"rust_analyzer",
}

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", server_custom_opts, opts)
	end
	lspconfig[server].setup(opts)
end

if typescript_status_ok then
	typescript.setup({
		go_to_source_defintion = {
			fallback = true,
		},
		server = {
			on_attach = require("user.lsp.handlers").on_attach,
			capabilities = require("user.lsp.handlers").capabilities,
		},
	})
end
