local o = vim.o
local g = vim.g
local wo = vim.wo
local bo = vim.bo

-- Line Numbering
o.number = true
o.relativenumber = true

-- Mouse fix
o.mouse = 'a'

-- Better Case handling
o.ignorecase = true
o.smartcase = true

--- Search
o.inccommand = 'nosplit'

-- Enable Spell checking
o.spell = true
o.spelllang = 'en'
o.spellfile = '~/.config/nvim/spell/en.utf-8.add'

-- Tab handling
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- Completion
o.completeopt = 'menu,menuone,noselect'
o.pumblend = 10 -- Popup menu transparency
o.pumheight = 8 -- Popup menu height

-- Appearance
o.colorcolumn = '80,120'
o.cursorline = true
o.cmdheight = 1

o.signcolumn = 'yes'
o.termguicolors = true

o.hidden = true

o.virtualedit = 'block'

