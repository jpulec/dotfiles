local o = vim.opt

o.cmdheight = 2 -- more space for commandline for messages
o.completeopt = { "menuone", "noselect" } -- mostly for cmp

-- Better case handling
o.ignorecase = true -- ignore case in search patterns
o.smartcase = true

--- Search
o.inccommand = "nosplit"

-- Mouse Fix
o.mouse = "a"

-- Line Numbering
o.number = true
o.relativenumber = true

-- Enable Spell checking
o.spell = true
o.spelllang = "en"
o.spellfile = vim.fn.expand("~") .. "/.config/nvim/spell/en.utf-8.add"

-- Tab handling
o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true

-- Pop up menu
o.pumblend = 10 -- Popup menu transparency
o.pumheight = 8 -- Popup menu height

o.showmode = false

-- Appearance
o.colorcolumn = "80,120"
o.cursorline = true
o.cmdheight = 1
o.signcolumn = "yes"
o.termguicolors = true
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8

o.smartindent = true

-- Splits
o.splitbelow = true
o.splitright = true

o.timeoutlen = 300

-- Persistent undo
o.undofile = true

o.updatetime = 300

o.shortmess:append("c")
o.iskeyword:append("-")

o.virtualedit = "block"

-- Folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"

o.shell = "/usr/bin/fish"
