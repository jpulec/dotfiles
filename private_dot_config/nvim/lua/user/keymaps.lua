local keymap = vim.keymap.set

-- Remap the leader key as space
keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true, desc = "Go to left window" })
keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true, desc = "Go to lower window" })
keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true, desc = "Go to upper window" })
keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true, desc = "Go to right window" })

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true, desc = "Increase window height" })
keymap("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true, desc = "Decrease window height" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true, desc = "Decrease window width" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true, desc = "Increase window width" })

-- Buffers
keymap("n", "<Tab>", "<cmd>bn<CR>", { noremap = true, silent = true, desc = "Next buffer" })
keymap("n", "<S-Tab>", "<cmd>bp<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
keymap("n", "<leader>bd", function() Snacks.bufdelete() end, { noremap = true, silent = true, desc = "Delete buffer" })

-- Toggle wrap
keymap("n", "<leader>w", ":set wrap! linebreak!<CR>:echo 'wrap=' . &wrap<CR>", { noremap = true, silent = true, desc = "Toggle wrap" })

-- Telescope
keymap("n", "<leader>t", "<cmd>Telescope find_files<cr>", { noremap = true, silent = true, desc = "Find files" })
keymap("n", "<leader>f", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true, desc = "Live grep" })

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", { noremap = true, silent = true, desc = "Toggle file explorer" })

-- Diagnostics
local diagnostic_goto = function(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		if next then
			vim.diagnostic.jump({ count = 1, float = true, severity = severity })
		else
			vim.diagnostic.jump({ count = -1, float = true, severity = severity })
		end
	end
end
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left" })
keymap("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right" })

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
keymap("v", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })

-- Don't replace unnamed register with replaced text
keymap("v", "p", '"_dP', { noremap = true, silent = true, desc = "Paste without yanking" })

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move block down" })
keymap("x", "K", ":move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move block up" })
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", { noremap = true, silent = true, desc = "Move block down" })
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", { noremap = true, silent = true, desc = "Move block up" })

-- Config File Editing --
keymap("n", "<leader>ev", ":e ~/.config/nvim/init.lua<cr>", { noremap = true, silent = true, desc = "Edit nvim config" })
