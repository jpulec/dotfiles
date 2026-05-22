return {
	-- Community-maintained fork of the archived epwalsh/obsidian.nvim.
	"obsidian-nvim/obsidian.nvim",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "life",
				path = "~/Dev/jpulec/odine",
			},
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = nil,
		},
		completion = {
			-- Switched from nvim_cmp to blink.cmp.
			nvim_cmp = false,
			blink = true,
			min_chars = 2,
		},
		-- Don't manage frontmatter - we handle it ourselves
		frontmatter = {
			enabled = false,
		},
		-- Use wiki links by default, markdown links also work
		link = {
			style = "wiki",
		},
		-- Customize how note IDs are generated (use filename as-is)
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				suffix = tostring(os.time())
			end
			return suffix
		end,
		-- Where to put new notes
		new_notes_location = "current_dir",
		-- UI settings
		ui = {
			enable = true,
		},
		-- Buffer-local keymaps. The `mappings` option is deprecated; register keymaps
		-- in the enter_note callback instead.
		-- See https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps
		-- Note: <CR> smart action (follow link / toggle checkbox / cycle fold) is
		-- registered by default, so no longer mapped here.
		callbacks = {
			enter_note = function(_note)
				vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", {
					buffer = true,
					desc = "Toggle checkbox",
				})
			end,
		},
		legacy_commands = false,
	},
	keys = {
		{ "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quick switch" },
		{ "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search vault" },
		{ "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Today's note" },
		{ "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
		{ "<leader>ol", "<cmd>ObsidianLinks<cr>", desc = "Links in file" },
		{ "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
		{ "<leader>op", "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
	},
}
