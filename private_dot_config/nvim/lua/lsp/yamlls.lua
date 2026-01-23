local schemas = {
	["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
}

return {
	settings = {
		yaml = {
			schemas = schemas,
		},
	},
}
