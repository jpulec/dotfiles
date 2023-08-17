-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don"t error on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("nvim-lua/plenary.nvim")
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("nvim-tree/nvim-web-devicons")
	use("nvim-tree/nvim-tree.lua")
	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")
	use("nvim-lualine/lualine.nvim")
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("goolord/alpha-nvim")
	use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight

	-- Markdown viewer, patched with MermaidJS support
	use({ "tpabla/markdown-preview.nvim", commit = "4ecfb49e92351d361c21b436ebebedfa56ae0c2d" })

	-- Colorschemes
	use({ "dracula/vim" })

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("nvim-lua/lsp-status.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for

	use({
		"antosha417/nvim-lsp-file-operations",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "kyazdani42/nvim-tree.lua" },
		},
	})

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-media-files.nvim")

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("HiPhish/nvim-ts-rainbow2")

	use("arthurxavierx/vim-caser")
	use("chaoren/vim-wordmotion")
	use("dag/vim-fish")
	use("jparise/vim-graphql")
	--use("pantharshit00/vim-prisma")
	use("norcalli/nvim-colorizer.lua")

	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")
	use("tpope/vim-rhubarb")

	use({
		"zbirenbaum/copilot.lua",
		event = { "VimEnter" },
		config = function()
			vim.defer_fn(function()
				require("copilot").setup()
			end, 100)
		end,
	})

	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	})

	use({
		"hrsh7th/cmp-emoji",
	})

	use({ "axieax/urlview.nvim" })

	use({ "jose-elias-alvarez/typescript.nvim" })

	use({ "tpope/vim-abolish" })

	--- Remote dev stuff
	use({ "https://codeberg.org/esensar/nvim-dev-container" })
end)
