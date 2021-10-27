local utils = require('core.utils')
local map = utils.keymap.map

-- map the leader key
map('n', '<Space>', '')
vim.g.mapleader = ' '


map('n', '<leader><esc>', ':nohlsearch<cr>')
map('n', '<leader>n', ':bnext<cr>')
map('n', '<leader>p', ':bprev<cr>')
map('n', '<leader>t', ':Files<cr>')
map('n', '<leader>f', ':Rg<cr>')

-- Buffers
map('n', '<Tab>', '<cmd>bn<CR>')
map('n', '<S-Tab>', '<cmd>bp<CR>')
map('n', '<space>bd', '<cmd>bd<CR>')

-- Insert
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', { expr = true })
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', { expr = true })
