require("user.bootstrap_lazy")
require("user.options")
require("user.keymaps")
require("lazy").setup("user.plugins", {
	install = {
		colorscheme = { "dracula" },
	},
})
require("user.autocommands")
require("user.colorscheme")
