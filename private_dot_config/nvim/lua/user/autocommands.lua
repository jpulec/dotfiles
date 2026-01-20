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
		vim.highlight.on_yank({ higroup = "Search", timeout = 200 })
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

vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
	group = general,
	callback = function()
		vim.cmd("normal! zR")
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
		if vim.bo.filetype == "snacks_dashboard" then
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
