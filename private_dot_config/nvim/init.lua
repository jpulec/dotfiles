require("modules")
require("modules/config/nvim-cmp")
require("core.options")
require("core.keymaps")
require("core.autocmd")
require("core.colors")

vim.lsp.set_log_level("debug")

vim.api.nvim_exec(
[[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
]],
true)
