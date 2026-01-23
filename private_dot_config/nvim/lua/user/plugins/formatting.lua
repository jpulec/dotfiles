return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		log_level = vim.log.levels.DEBUG,
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "biome" }, -- "prettierd", "prettier", stop_after_first = true },
			typescript = { "biome" }, --, "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "biome" }, --"prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "biome" }, --"prettierd", "prettier", stop_after_first = true },
			--javascript = { "prettierd", "prettier", stop_after_first = true },
			--typescript = { "prettierd", "prettier", stop_after_first = true },
			--javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			--typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			--text = {},
			json = { "biome" },
			markdown = { "prettierd" },
			-- Use the "_" filetype to run formatters on filetypes that don't
			-- have other formatters configured.
			--["_"] = { "prettierd" },
		},
		-- Set up format-on-save
		format_on_save = function(bufnr)
			-- Disable autoformat for files in a certain path
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			if bufname:match("/node_modules/") then
				return
			end

			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			return { timeout_ms = 300, lsp_fallback = false }
		end,
		-- Customize formatters
		formatters = {
			--biome = {
			--	-- Dynamically choose local vs. global/Mason command
			--	command = function()
			--		local local_bin = "./node_modules/.bin/biome"
			--		if vim.fn.executable(local_bin) == 1 then
			--			-- If local biome is available, use that
			--			return local_bin
			--		else
			--			-- Otherwise, fall back to the global or Mason-installed `biome`
			--			return "biome"
			--		end
			--	end,
			--	args = { "format", "-" },
			--	stdin = true,
			--},
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
