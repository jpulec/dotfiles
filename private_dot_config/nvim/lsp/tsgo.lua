-- tsgo (Microsoft typescript-go) reads VSCode-style nested keys, not the
-- `includeInlay*` format used by typescript-language-server. It requests
-- config sections "js/ts", "typescript", "javascript", and "editor" via
-- workspace/configuration on init. Precedence: editor < javascript < typescript < js/ts.
--
-- Type hints (variable/property/return) are off because heavy generic types
-- (Hono, tRPC, Drizzle, Zod) blow them out to hundreds of characters per line.
-- Parameter-name and enum-value hints stay on -- they're short and useful.
local inlay_hint_preferences = {
	parameterNames = {
		enabled = "all", -- "none" | "literals" | "all"
		suppressWhenArgumentMatchesName = true,
	},
	parameterTypes = { enabled = false },
	variableTypes = {
		enabled = false,
		suppressWhenTypeMatchesName = true,
	},
	propertyDeclarationTypes = { enabled = false },
	functionLikeReturnTypes = { enabled = false },
	enumMemberValues = { enabled = true },
}

return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = {
		"tsconfig.json",
		"jsconfig.json",
		"package.json",
		".git",
		"tsconfig.base.json",
	},
	settings = {
		-- "js/ts" wins over both, so set it once instead of duplicating.
		["js/ts"] = { inlayHints = inlay_hint_preferences },
	},
}
