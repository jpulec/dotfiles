vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

return require('packer').startup(function()
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
      'hrsh7th/nvim-compe',
      config = require('modules.config.nvim-compe'),
      event = 'InsertEnter',
      requires = {
          { 'ray-x/lsp_signature.nvim', module = 'lsp_signature' },
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
      'glepnir/galaxyline.nvim',
      config = require('modules.config.galaxyline'),
      requires = {'kyazdani42/nvim-web-devicons', opt = true},
      branch = 'main',
  })
  -- Snippets
  use({
      'hrsh7th/vim-vsnip',
      requires = {
          'rafamadriz/friendly-snippets',
          'dsznajder/vscode-es7-javascript-react-snippets',
      },
      after = 'nvim-compe',
  })

  -- Remote container dev
  use {'jamestthompson3/nvim-remote-containers'}

  -- Zip file reading
  use {'lbrayner/vim-rzip'}

  use ({
    "jose-elias-alvarez/null-ls.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "neovim/nvim-lspconfig"},
    },
    config = require("modules.config.lsp.null-ls")
  })
end)
