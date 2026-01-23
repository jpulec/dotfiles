vim.filetype.add({
	filename = {
		[".env"] = "dotenv",
	},
	pattern = {
		[".*%.env%..+"] = "dotenv", -- Matches `.env.staging`, `.env.test`, etc.
	},
})
