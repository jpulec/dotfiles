local status_ok, lsp = pcall(require("lspconfig"))
if not status_ok then
	return {}
end

return {
	root_dir = lsp.util.root_pattern("pyproject.toml", ".git", vim.fn.getcwd()),
	settings = {
		pylsp = {
			plugins = {
				autopep8 = {
					enabled = false,
				},
				jedi = {
					environment = "/home/james/Dev/Resource/resource-worktree/bugfix/django/.venv/bin/python",
				},
				mypy = {
					enabled = true,
				},
				pyflakes = {
					enabled = false,
				},
				pycodestyle = {
					enabled = true,
					maxLineLength = 88,
				},
				pylint = {
					enabled = true,
					executable = "/home/james/Dev/Resource/resource-worktree/bugfix/django/.venv/bin/pylint",
					args = { "--django-settings-module=guides.settings.dev" },
				},
				yapf = {
					enabled = false,
				},
			},
		},
	},
}
