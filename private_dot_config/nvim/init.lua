require("modules")
require("core.options")
require("core.keymaps")
require("core.autocmd")
require("core.colors")


vim.lsp.set_log_level("debug")


vim.api.nvim_exec(
[[
function! OpenZippedFile(f)
  " get number of new (empty) buffer
  let l:b = bufnr('%')
  " construct full path
  let l:f = 'zipfile:' . getcwd() . '/' . substitute(a:f, '.zip/', '.zip::', '')
  " swap back to original buffer
  b #
  " delete new one
  exe 'bd! ' . l:b
  " open buffer with correct path
  sil exe 'e ' . l:f
  " read in zip data
  call zip#Read(l:f, 1)
endfunction

augroup yarngtd
  au!

  au BufReadCmd .yarn/cache/*.zip/* call OpenZippedFile(expand('<afile>'))
augroup END
]],
true)

vim.api.nvim_exec(
[[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
]],
true)
