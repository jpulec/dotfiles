return {
	{
		"https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
		config = function()
			local rainbow_delimiters = require("rainbow-delimiters")

			vim.g.rainbow_delimiters = {
				strategy = {
					[""] = function(bufnr)
						-- Disable for large files to avoid treesitter overhead on every redraw
						local max = vim.g.treesitter_max_lines or 2000
						if vim.api.nvim_buf_line_count(bufnr) > max then
							return nil
						end
						return rainbow_delimiters.strategy["global"]
					end,
					commonlisp = rainbow_delimiters.strategy["local"],
				},
				query = {
					[""] = "rainbow-delimiters",
					lua = "rainbow-blocks",
				},
				highlight = {
					"RainbowDelimiterRed",
					"RainbowDelimiterYellow",
					"RainbowDelimiterBlue",
					"RainbowDelimiterOrange",
					"RainbowDelimiterGreen",
					"RainbowDelimiterViolet",
					"RainbowDelimiterCyan",
				},
				blacklist = { "c", "cpp" },
			}
		end,
	},
}
