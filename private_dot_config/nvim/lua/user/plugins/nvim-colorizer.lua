return {
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			options = {
				-- css = true enables all the formats the old config had:
				-- hex (RGB, RRGGBB, RRGGBBAA), named colors, rgb(), hsl(), etc.
				parsers = { css = true },
			},
		},
	},
}
