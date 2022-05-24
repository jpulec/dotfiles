vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  -- Built-in lsp
  use({
      'neovim/nvim-lspconfig',
      config = require('modules.config.nvim-lspconfig'),
      requires = {
          { 'nvim-lua/lsp-status.nvim', module = 'lsp-status' }
      },
  })
  use {'ojroques/nvim-lspfuzzy', requires = {
    {'junegunn/fzf'},
    {'junegunn/fzf.vim'},  -- to enable preview (optional)
  }}
  -- Completion plugin
  use({
      'hrsh7th/nvim-cmp',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
  })

  -- Snippets
  use({
      'L3MON4D3/luasnip',
      requires = {
          'rafamadriz/friendly-snippets',
      },
  })

  use {'arthurxavierx/vim-caser'}
  use {'chaoren/vim-wordmotion'}
  use {'dracula/vim' }
  use {'dag/vim-fish'}
  use {'jparise/vim-graphql'}
  use {'pantharshit00/vim-prisma'}
  use ({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = require('modules.config.nvim-treesitter'),
    event = 'BufRead',
  })
  -- Icons
  use({
      'kyazdani42/nvim-web-devicons',
      config = require('modules.config.nvim-web-devicons'),
      module = 'nvim-web-devicons',
  })
  -- Indent Lines
  use({
      'lukas-reineke/indent-blankline.nvim',
      config = require('modules.config.indent-blankline'),
      event = 'ColorScheme',
  })
  use {'tpope/vim-fugitive'}
  -- Should be included in vim core
  use({
      'tpope/vim-surround',
      event = 'BufEnter',
  })
  use {'tpope/vim-abolish'}
  use({
      'norcalli/nvim-colorizer.lua',
      config = require('modules.config.nvim-colorizer'),
      event = 'ColorScheme',
  })
  -- Statusline
  use({
      'NTBBloodbath/galaxyline.nvim',
      config = require('modules.config.galaxyline'),
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      branch = 'main',
  })

  use ({
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "neovim/nvim-lspconfig"},
    },
    config = require("modules.config.lsp.null-ls")                                                                                                                                                             })

  use {'github/copilot.vim'}

  use { 'tpabla/markdown-preview.nvim', commit = '4ecfb49e92351d361c21b436ebebedfa56ae0c2d' }
end)
