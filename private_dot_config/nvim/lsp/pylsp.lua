-- Dynamically locate a project-local Python interpreter.
-- Order: $VIRTUAL_ENV (already activated) -> ./.venv -> ./venv -> system default (nil).
local function find_python(root)
	if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
		local bin = vim.fs.joinpath(vim.env.VIRTUAL_ENV, "bin", "python")
		if vim.fn.executable(bin) == 1 then
			return bin
		end
	end

	for _, dir in ipairs({ ".venv", "venv" }) do
		local bin = vim.fs.joinpath(root or vim.fn.getcwd(), dir, "bin", "python")
		if vim.fn.executable(bin) == 1 then
			return bin
		end
	end

	return nil
end

return {
	root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
	settings = {
		pylsp = {
			plugins = {
				autopep8 = { enabled = false },
				jedi = {
					-- jedi auto-detects .venv; this only overrides when we can resolve one.
					environment = find_python(),
				},
				mypy = { enabled = true },
				pyflakes = { enabled = false },
				pycodestyle = {
					enabled = true,
					maxLineLength = 88,
				},
				pylint = {
					-- Leave executable unset so pylsp uses `python -m pylint` from whichever
					-- environment pylsp itself runs in. Override per-project with a local
					-- .nvim.lua if you need Django settings, e.g.:
					--   vim.lsp.config("pylsp", { settings = { pylsp = { plugins = {
					--     pylint = { args = { "--django-settings-module=..." } }
					--   } } } })
					enabled = true,
				},
				yapf = { enabled = false },
			},
		},
	},
}
