local opts = { noremap = true, silent = true }

local keymap = vim.keymap.set

-- Remap the leader key as space
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffers
keymap("n", "<Tab>", "<cmd>bn<CR>", opts)
keymap("n", "<S-Tab>", "<cmd>bp<CR>", opts)
--keymap("n", "<space>bd", "<cmd>bd<CR>", opts)

-- Leader Buffer mappings
keymap("n", "<leader>n", ":bnext<cr>", opts)
keymap("n", "<leader>p", ":bprev<cr>", opts)
keymap("n", "<leader>bd", ":bd<cr>", opts)

-- Toggle wrap
keymap("n", "<leader>w", ":set wrap! linebreak!<CR>:echo 'wrap=' . &wrap<CR>", opts)

-- Telescope
keymap(
	"n",
	"<leader>t",
	"<cmd>Telescope find_files<cr>",
	--"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
	opts
)
keymap("n", "<leader>f", "<cmd>Telescope live_grep<cr>", opts)

-- Nvimtree
keymap("n", "<leader>e", ":NvimTreeToggle<cr>", opts)

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

-- Insert --

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)

-- Don't replace unnamed register with replaced text
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Config File Editing --
keymap("n", "<leader>ev", ":e ~/.config/nvim/init.lua<cr>", opts)
