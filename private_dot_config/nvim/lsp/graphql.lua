return {
	cmd = { "graphql-lsp", "server", "--method", "stream" },
	filetypes = {
		"graphql",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	root_markers = {
		".graphqlrc",
		".graphqlrc.json",
		".graphqlrc.yml",
		".graphqlrc.yaml",
		".graphqlrc.ts",
		".graphqlrc.js",
		"graphql.config.ts",
		"graphql.config.js",
		"graphql.config.json",
		"graphql.config.yml",
		"graphql.config.yaml",
	},
}
