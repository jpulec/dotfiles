-- plugins/user/lsp/handlers.lua
local M = {}

M.setup = function()
	vim.diagnostic.config({
		virtual_text = false,
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = { border = "rounded", source = "always" },
	})

	-- optional: set a global border for *all* floats (0.11+)
	-- vim.o.winborder = "rounded"

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
		callback = function(args)
			local bufnr = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if not client then
				return
			end
			-- 🔧 tsgo: it advertises textDocument.codeAction, but not codeActionProvider
			if client.name == "tsgo" and client.server_capabilities.codeActionProvider == nil then
				-- simplest: just tell Neovim "yes, this server supports code actions"
				client.server_capabilities.codeActionProvider = true

				-- If you want to be fancy, you *could* pull the kinds from
				-- client.server_capabilities.textDocument.codeAction, but Neovim
				-- doesn't actually need them to send the request.
			end

			-- disable formatting for formatters you don’t want (keep your list)
			if
				client.name == "ts_ls"
				or client.name == "lua_ls"
				or client.name == "jsonls"
				or client.name == "html"
			then
				client.server_capabilities.documentFormattingProvider = false
			end

			-- buffer-local keymaps
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
			end
			map("n", "gD", vim.lsp.buf.declaration, "LSP: Declaration")
			map("n", "gd", vim.lsp.buf.definition, "LSP: Definition")
			map("n", "K", function()
				vim.lsp.buf.hover({ border = "rounded" })
			end, "LSP: Hover")
			map("n", "gi", vim.lsp.buf.implementation, "LSP: Implementation")
			map("n", "<C-k>", function()
				vim.lsp.buf.signature_help({ border = "rounded" })
			end, "LSP: Signature")
			map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
			map("n", "gr", vim.lsp.buf.references, "LSP: References")
			map("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, "LSP: Code Action")

			-- optional extras
			local ok, illuminate = pcall(require, "illuminate")
			if ok then
				illuminate.on_attach(client)
			end
			local lsp_status_ok, lsp_status = pcall(require, "lsp-status")
			if lsp_status_ok then
				lsp_status.on_attach(client)
			end
		end,
	})
end

return M
