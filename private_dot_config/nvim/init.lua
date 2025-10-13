require("user.bootstrap_lazy")
require("user.options")
require("user.keymaps")
require("lazy").setup({
	spec = {
		{ import = "user.plugins" },
	},
	install = {
		colorscheme = { "dracula" },
	},
	checker = {
		enabled = true,
		-- Check once a day
		frequency = 3600 * 24,
	},
})
require("user.autocommands")
require("user.colorscheme")
require("user.filetypes")
