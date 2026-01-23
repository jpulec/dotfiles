return {
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			local copilot = require("copilot")
			copilot.setup()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
		end,
	},
}
