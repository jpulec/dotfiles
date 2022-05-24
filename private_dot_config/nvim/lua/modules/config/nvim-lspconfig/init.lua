return function()
	local lsp = require 'lspconfig'
  local lsp_status = require 'lsp-status'
	local lspfuzzy = require 'lspfuzzy'

  lsp_status.register_progress()

  -- nvim-cmp supports additional completion capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

  local on_attach = require('modules.config.nvim-lspconfig.on-attach')

	lsp.pylsp.setup {
	  on_attach = function (client)
      client.resolved_capabilities.document_formatting = false
      on_attach(client)
    end,
	  root_dir = lsp.util.root_pattern('pyproject.toml', '.git', vim.fn.getcwd()),
	  settings = {
      pylsp = {
        plugins = {
          autopep8 = {
            enabled = false
          },
          jedi = {
            environment = '/home/james/Dev/Resource/resource-worktree/bugfix/django/.venv/bin/python',
          },
          mypy = {
            enabled = true
          },
          pyflakes = {
            enabled = false
          },
          pycodestyle = {
            enabled = true,
            maxLineLength = 88,
          },
          pylint = {
            enabled = true,
            executable = '/home/james/Dev/Resource/resource-worktree/bugfix/django/.venv/bin/pylint',
            args = {'--django-settings-module=guides.settings.dev'}
          },
          yapf = {
            enabled = false
          }
        }
      }
	  }
	}

	lsp.tsserver.setup {
	  on_attach = function (client)
      client.resolved_capabilities.document_formatting = false
      on_attach(client)
    end,
	  cmd = { "typescript-language-server", "--tsserver-path=.yarn/sdks/typescript/lib/", "--stdio" },
    capabilities = vim.tbl_extend('keep', capabilities, lsp_status.capabilities),
	}

  lsp.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
  }

  lsp.tailwindcss.setup {}

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
