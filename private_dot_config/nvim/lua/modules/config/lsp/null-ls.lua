return function ()
  local lsp = require("lspconfig")
  local null_ls = require("null-ls")
  local on_attach = require("modules.config.nvim-lspconfig.on-attach")

  null_ls.config ({
    debug = true,
    sources = {
      null_ls.builtins.formatting.prettierd,
    },
  })

  lsp['null-ls'].setup {
    on_attach=on_attach
  }
end
