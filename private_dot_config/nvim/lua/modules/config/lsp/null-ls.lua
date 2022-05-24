return function ()
  local null_ls = require("null-ls")
  local on_attach = require("modules.config.nvim-lspconfig.on-attach")

  null_ls.setup {
    on_attach=on_attach,
    sources = {
      null_ls.builtins.formatting.prettier_d_slim.with({
        extra_args = { "--prettier-path", "./.yarn/sdks/prettier" },
      }),
      null_ls.builtins.diagnostics.eslint_d.with({
        extra_args = { "--eslint-path", "./.yarn/sdks/eslint" },
      }),
    },
  }
end
