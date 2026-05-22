local o = vim.opt

o.completeopt = { "menuone", "noselect" } -- mostly for cmp

-- System clipboard sharing (requires xclip/xsel/wl-clipboard on Linux).
o.clipboard = "unnamedplus"

-- Confirm before abandoning an unsaved buffer instead of failing silently.
o.confirm = true

-- Global statusline (single status line at the bottom instead of per-window).
o.laststatus = 3

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

-- Spell checking (enabled per-filetype in autocommands.lua)
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
o.winborder = "rounded"

o.smartindent = true

-- Splits
o.splitbelow = true
o.splitright = true

o.timeoutlen = 300

-- Persistent undo
o.undofile = true

o.updatetime = 300

-- Limit matchparen bracket-matching search time (default 300ms blocks cursor movement on large files)
vim.g.matchparen_timeout = 30
vim.g.matchparen_insert_timeout = 30

o.shortmess:append("c")
o.iskeyword:append("-")

o.virtualedit = "block"

-- Folding
o.foldenable = true -- Enable folding by default
o.foldlevel = 99 -- Open most folds by default
o.foldlevelstart = 99 -- Start with all folds open
o.foldnestmax = 3 -- Max nested folds

-- Treesitter folds are set per-filetype in autocommands.lua

o.shell = "/bin/sh"

