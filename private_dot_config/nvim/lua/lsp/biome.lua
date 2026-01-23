-- Find the *repo root* (topmost git directory, not package-level roots)
local function find_repo_root(fname)
	return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
end

-- Absolute path to Biome binary in the monorepo root
local repo_root = find_repo_root(vim.fn.getcwd())
local biome_bin = vim.fs.joinpath(repo_root or vim.fn.getcwd(), "node_modules", ".bin", "biome")

return {
	cmd = { biome_bin, "lsp-proxy" }, -- default fallback (Mason-installed)
	-- Change back to default once have biome monorepo support
	root_dir = function(fname)
		local root_files = { "biome.json", "biome.jsonc" }
		return vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1])
	end,
	settings = {
		biome = {
			codeaction = {
				enable = true,
			},
		},
	},
}
