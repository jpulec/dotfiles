return function() 
	local lsp = require 'lspconfig'
  local lsp_status = require 'lsp-status'
	local lspfuzzy = require 'lspfuzzy'

  lsp_status.register_progress()

  local on_attach = require('modules.config.nvim-lspconfig.on-attach')

	--lsp.pyls.setup {
	--  on_attach = on_publish_diagnostics,
	--  root_dir = lsp.util.root_pattern('pyproject.toml', '.git', vim.fn.getcwd()),
	--  settings = {
	--    pyls = {
	--      plugins = {
  --        autopep8 = {
  --          enabled = false
  --        },
  --        pyflakes = {
  --          enabled = false
  --        },
  --        pycodestyle = {
  --          enabled = false
  --        },
  --        pylint = {
  --          enabled = false
  --        },
  --        yapf = {
  --          enabled = false
  --        }
	--      }
	--    }
	--  }
	--}
	lsp.tsserver.setup {
	  on_attach = function (client)
      client.resolved_capabilities.document_formatting = false
      on_attach(client)
    end,
	  cmd = { "typescript-language-server", "--tsserver-path", "./.yarn/sdks/typescript/bin/tsserver", "--stdio" },
    capabilities = lsp_status.capabilities,
	}
  lsp.eslint.setup {}

	local black = require "modules/config/nvim-lspconfig/efm/black"
	local isort = require "modules/config/nvim-lspconfig/efm/isort"
	local mypy = require "modules/config/nvim-lspconfig/efm/mypy"
	local pylint = {
	  lintCommand = "pylint",
	  lintIgnoreExitCode = true,
	  lintStdin = true
	}

	local prettier = require "modules/config/nvim-lspconfig/efm/prettier"
	local eslint = require "modules/config/nvim-lspconfig/efm/eslint"

	local languages = {
	  python = {black, isort, mypy},

	  javascript = {prettier, eslint},
	  javascriptreact = {prettier, eslint},

	  typescript = {prettier, eslint},
	  typescriptreact = {prettier, eslint},

	  yaml = {prettier},
	  json = {prettier},
	  html = {prettier},
	  scss = {prettier},
	  css = {prettier},
	  markdown = {prettier},
	}

	--lsp.efm.setup {
	--  init_options = {documentFormatting = true, codeAction = true },
	--  filetypes = vim.tbl_keys(languages),
	--  settings = {
	--    languages = languages,
	--  },
	--  on_attach = on_attach,
	--}
	lspfuzzy.setup {}

  local border = {
        {"🭽", "FloatBorder"},
        {"▔", "FloatBorder"},
        {"🭾", "FloatBorder"},
        {"▕", "FloatBorder"},
        {"🭿", "FloatBorder"},
        {"▁", "FloatBorder"},
        {"🭼", "FloatBorder"},
        {"▏", "FloatBorder"},
  }
  vim.lsp.handlers["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border})
  vim.lsp.handlers["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border})
end
