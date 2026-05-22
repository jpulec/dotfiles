-- plugins/user/lsp/handlers.lua
local M = {}

M.setup = function()
	vim.diagnostic.config({
		virtual_text = false,
		-- Show multi-line diagnostics only on the line under the cursor (0.11+).
		virtual_lines = { current_line = true },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = "",
				[vim.diagnostic.severity.WARN] = "",
				[vim.diagnostic.severity.HINT] = "",
				[vim.diagnostic.severity.INFO] = "",
			},
		},
		update_in_insert = false,
		underline = true,
		severity_sort = true,
		float = { source = "if_many", border = "rounded" },
	})

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

			-- Inlay hints: off by default; toggle with <leader>ch.

			-- Document color: nvim 0.12+ API for LSP-provided color literals (Tailwind, CSS, etc.).
			-- Signature is `enable(enable, filter, opts)` where filter is a table, not a bufnr.
			if vim.lsp.document_color and client:supports_method("textDocument/documentColor", bufnr) then
				vim.lsp.document_color.enable(true, { bufnr = bufnr }, { style = "virtual" })
			end

			-- Buffer-local keymaps. Neovim 0.11+ provides these defaults for free:
			--   K           -> vim.lsp.buf.hover
			--   gri         -> vim.lsp.buf.implementation
			--   grr         -> vim.lsp.buf.references
			--   grn         -> vim.lsp.buf.rename
			--   gra         -> vim.lsp.buf.code_action
			--   grt (0.12)  -> vim.lsp.buf.type_definition
			--   grx (0.12)  -> vim.lsp.codelens.run
			--   <C-s> (ins) -> vim.lsp.buf.signature_help
			--   [d / ]d     -> vim.diagnostic.jump
			-- Only keys below add new behavior or override to a preferred alias.
			local map = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
			end
			map("n", "gD", vim.lsp.buf.declaration, "LSP: Declaration")
			map("n", "gd", vim.lsp.buf.definition, "LSP: Definition")
			-- Signature help in normal mode (insert mode uses default <C-s>).
			map("n", "gK", vim.lsp.buf.signature_help, "LSP: Signature")
			-- Preferred aliases for common actions.
			map("n", "<leader>rn", vim.lsp.buf.rename, "LSP: Rename")
			map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
			map("n", "<leader>ch", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
			end, "LSP: Toggle Inlay Hints")

			local ok, illuminate = pcall(require, "illuminate")
			if ok then
				illuminate.on_attach(client)
			end
		end,
	})
end

return M
