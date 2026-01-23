return {
	{
		"https://codeberg.org/esensar/nvim-dev-container",
		config = function()
			require("devcontainer").setup({
				log_level = "trace",
				container_runtime = "docker",
				compose_command = "docker-compose",
				--attach_mounts = {
				--	always = true,
				--	neovim_config = {
				--		enabled = true,
				--		options = { "readonly" },
				--	},
				--	neovim_data = {
				--		enabled = false,
				--	},
				--	neovim_state = {
				--		enabled = false,
				--	},
				--},
				--nvim_installation_commands_provider = function()
				--	return {
				--		{ "apk", "add", "--no-cache", "neovim" },
				--	}
				--end,
			})
		end,
	},
}
