-- Custom schema overrides (applied before SchemaStore defaults).
local custom_schemas = {
	["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
}

return {
	settings = {
		yaml = {
			schemas = custom_schemas,
			schemaStore = {
				-- Disable yaml-language-server's bundled catalog; SchemaStore.nvim provides a newer one.
				enable = false,
				url = "",
			},
		},
	},
	on_init = function(client)
		local ok, schemastore = pcall(require, "schemastore")
		if not ok then
			return
		end
		local settings = client.config.settings
		settings.yaml.schemas = vim.tbl_deep_extend(
			"force",
			schemastore.yaml.schemas(),
			settings.yaml.schemas or {}
		)
		client.notify("workspace/didChangeConfiguration", { settings = settings })
	end,
}
