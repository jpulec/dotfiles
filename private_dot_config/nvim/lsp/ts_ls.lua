-- Type hints (variable/property/return) are off because heavy generic types
-- (Hono, tRPC, Drizzle, Zod) blow them out to hundreds of characters per line.
-- Parameter-name and enum-value hints stay on -- they're short and useful.
local inlay_hint_preferences = {
	includeInlayParameterNameHints = "all",
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayFunctionParameterTypeHints = false,
	includeInlayVariableTypeHints = false,
	includeInlayVariableTypeHintsWhenTypeMatchesName = false,
	includeInlayPropertyDeclarationTypeHints = false,
	includeInlayFunctionLikeReturnTypeHints = false,
	includeInlayEnumMemberValueHints = true,
}

return {
	init_options = {
		preferences = {
			includeCompletionsForImportStatements = true,
			includeCompletionsForModuleExports = true,
			importModuleSpecifierPreference = "non-relative",
		},
	},
	settings = {
		typescript = { inlayHints = inlay_hint_preferences },
		javascript = { inlayHints = inlay_hint_preferences },
	},
}
