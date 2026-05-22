-- General settings
local general = vim.api.nvim_create_augroup("_general_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = general,
	pattern = { "qf", "help", "man", "lspinfo" },
	callback = function()
		vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = general,
	callback = function()
		vim.hl.on_yank({ higroup = "Search", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	group = general,
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = general,
	pattern = "qf",
	callback = function()
		vim.bo.buflisted = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = general,
	pattern = "man",
	callback = function()
		vim.opt_local.laststatus = 0
		vim.opt_local.ruler = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = general,
	pattern = { "vim", "css", "javascript", "sh", "zsh" },
	callback = function()
		vim.opt_local.shiftwidth = 2
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = general,
	pattern = "term://*",
	callback = function()
		vim.opt_local.relativenumber = false
		vim.opt_local.number = false
		vim.opt_local.cursorline = false
		vim.opt_local.scrolloff = 0
		vim.opt_local.signcolumn = "no"
	end,
})

-- Treesitter highlighting (highlight.enable is disabled in treesitter.lua).
-- Large files: fall back to vim regex syntax, which is computed lazily
-- per-screen and never blocks.
-- Neovim 0.12 parses asynchronously (coroutine + redrawtime timeout),
-- so vim.treesitter.start() is lightweight and won't block the initial render.
vim.g.treesitter_max_lines = 2000
vim.api.nvim_create_autocmd("FileType", {
	group = general,
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local ft = vim.bo[bufnr].filetype
		if ft == "bigfile" then
			return
		end

		-- Check line count BEFORE touching treesitter to avoid creating a parser
		-- for large files (which rainbow-delimiters and other plugins would then use).
		if vim.api.nvim_buf_line_count(bufnr) > vim.g.treesitter_max_lines then
			vim.treesitter.stop(bufnr)
			vim.bo[bufnr].syntax = ft
			return
		end

		-- Check parser availability without creating a full buffer parser
		-- (get_parser would create one eagerly, leaving a stale parser if
		-- the buffer changes before the highlighter attaches).
		local lang = vim.treesitter.language.get_lang(ft)
		if not lang or not pcall(vim.treesitter.language.add, lang) then
			return
		end

		local ok = pcall(vim.treesitter.start, bufnr)
		if not ok then
			return
		end
		vim.api.nvim_buf_call(bufnr, function()
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		end)
	end,
})

-- Git
local git = vim.api.nvim_create_augroup("_git", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = git,
	pattern = "gitcommit",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Markdown
local markdown = vim.api.nvim_create_augroup("_markdown", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = markdown,
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.conceallevel = 2
	end,
})

-- Auto resize splits
local resize = vim.api.nvim_create_augroup("_auto_resize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
	group = resize,
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Open dashboard when no buffers remain
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local dominated_filetypes = { "snacks_dashboard", "NvimTree" }
		if vim.tbl_contains(dominated_filetypes, vim.bo.filetype) then
			return
		end
		-- Don't open dashboard if we started with a directory argument
		local bufname = vim.api.nvim_buf_get_name(0)
		if bufname ~= "" and vim.fn.isdirectory(bufname) == 1 then
			return
		end
		if #vim.fn.getbufinfo({ buflisted = 1 }) == 0 then
			if vim.bo.buftype ~= "" then
				vim.cmd("enew")
			end
			Snacks.dashboard()
		end
	end,
})
