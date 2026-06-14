local servers = {
	"bashls",
	--"biome",
	"dockerls",
	"graphql",
	--"harper_ls",
	"html",
	"hyprls",
	"jsonls",
	"lua_ls",
	"oxlint",
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

local M = {}

-- Build capabilities once (blink.cmp if present, otherwise defaults)
local capabilities = vim.lsp.protocol.make_client_capabilities()
pcall(function()
	capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
end)
-- Ensure codeAction literal support is present even without blink.cmp
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

-- Skip LSP attach for buffers backed by non-file URIs (e.g. diffview://, fugitive://,
-- gitsigns://). Their buffer names cannot be turned into a valid file:// URI, so when
-- a server tries to compute workspaceFolders it sends malformed "file:/<relpath>" and
-- the server rejects the request with InvalidParams ("workspace URI is not a valid
-- file path: ..."). Returning nil from root_dir (via on_dir(nil)) prevents the start.
local skip_uri_schemes = {
	"diffview://",
	"fugitive://",
	"gitsigns://",
	"octo://",
	"oil://",
}

local function buf_has_skipped_scheme(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return false
	end
	for _, scheme in ipairs(skip_uri_schemes) do
		if name:sub(1, #scheme) == scheme then
			return true
		end
	end
	return false
end

function M.setup()
	-- 1) set global defaults applied to every server (no per-server on_attach needed)
	vim.lsp.config("*", {
		capabilities = capabilities,
		-- you can put other global defaults here if you want
	})

	-- Block LSP attach for diffview://, fugitive://, etc. buffers by wrapping
	-- vim.lsp.start. We can't rely on LspAttach to detach after the fact —
	-- by then the malformed workspaceFolders URI has already been sent. We also
	-- can't rely on each server's root_dir because not every server config uses
	-- one. Intercepting vim.lsp.start covers every code path that vim.lsp.enable
	-- and manual starts go through.
	if not vim.g._user_lsp_start_wrapped then
		vim.g._user_lsp_start_wrapped = true
		local orig_start = vim.lsp.start
		vim.lsp.start = function(config, opts)
			opts = opts or {}
			local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
			if buf_has_skipped_scheme(bufnr) then
				return nil
			end
			return orig_start(config, opts)
		end
	end

	-- Override nvim-lspconfig's oxlint defaults (its lsp/ file clobbers ours via rtp merge order).
	-- Upstream only matches .oxlintrc.json, .oxlintrc.jsonc, and oxlint.config.ts.
	-- Replace upstream's root_dir function with a safe version that:
	--   1. Resolves the buffer name to an absolute path before searching, so
	--      vim.fs.find never returns a relative result.
	--   2. Returns nil (instead of calling on_dir with a bogus value) when no
	--      marker is found, letting `workspace_required` skip the start cleanly.
	-- The upstream function (lsp/oxlint.lua in nvim-lspconfig) can send a
	-- malformed workspace URI like "file://relative/path" to oxc_language_server,
	-- which then responds with InvalidParams: "workspace URI is not a valid
	-- file path: ...".
	local oxlint_root_markers = {
		".oxlintrc.json",
		".oxlintrc.jsonc",
		"oxlint.config.ts",
		"oxlint.config.mts",
		"oxlint.config.cts",
		"oxlint.config.js",
		"oxlint.config.mjs",
		"oxlint.config.cjs",
	}
	vim.lsp.config("oxlint", {
		root_dir = function(bufnr, on_dir)
			local fname = vim.api.nvim_buf_get_name(bufnr)
			if fname == "" then
				return on_dir(nil)
			end
			-- Resolve to an absolute path so vim.fs.find returns absolute results.
			local abs = vim.fn.fnamemodify(fname, ":p")
			local found = vim.fs.find(oxlint_root_markers, { path = abs, upward = true })[1]
			if not found then
				return on_dir(nil)
			end
			on_dir(vim.fs.dirname(found))
		end,
		on_attach = function(client, bufnr)
			vim.api.nvim_buf_create_user_command(bufnr, "LspOxlintFixAll", function()
				client:exec_cmd({
					title = "Apply Oxlint automatic fixes",
					command = "oxc.fixAll",
					arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
				})
			end, {
				desc = "Apply Oxlint automatic fixes",
			})

			vim.api.nvim_create_autocmd("BufWritePre", {
				group = vim.api.nvim_create_augroup("OxlintFixOnSave_" .. bufnr, { clear = true }),
				buffer = bufnr,
				callback = function()
					client:request_sync("workspace/executeCommand", {
						command = "oxc.fixAll",
						arguments = { { uri = vim.uri_from_bufnr(bufnr) } },
					}, 2000, bufnr)
				end,
			})
		end,
	})

	-- Override lspconfig's graphql defaults to also attach to plain TS/JS files
	vim.lsp.config("graphql", {
		filetypes = {
			"graphql",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	})

	-- 2) enable whichever servers you want; Neovim will auto-merge lsp/<server>.lua from rtp
	for _, server in pairs(servers) do
		vim.lsp.enable(server)
	end
end
return M
