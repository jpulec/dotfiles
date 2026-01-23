return {
	"epwalsh/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "life",
				path = "~/life",
			},
		},
		daily_notes = {
			folder = "daily",
			date_format = "%Y-%m-%d",
			template = nil,
		},
		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},
		-- Don't manage frontmatter - we handle it ourselves
		disable_frontmatter = true,
		-- Use markdown links by default, wikilinks also work
		preferred_link_style = "wiki",
		-- Open links in current window
		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,
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
			-- Disable checkbox concealment (fixes text getting cut off)
			checkboxes = {},
		},
		-- Key mappings
		mappings = {
			-- Toggle checkbox
			["<leader>oc"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true, desc = "Toggle checkbox" },
			},
			-- Follow link
			["<cr>"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { buffer = true, expr = true, desc = "Follow link" },
			},
		},
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
