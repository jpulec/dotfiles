return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = require("gitsigns")
					local function map(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
					end

					-- Hunk navigation
					map("n", "]h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "]c", bang = true })
						else
							gs.nav_hunk("next")
						end
					end, "Next hunk")
					map("n", "[h", function()
						if vim.wo.diff then
							vim.cmd.normal({ "[c", bang = true })
						else
							gs.nav_hunk("prev")
						end
					end, "Prev hunk")

					-- Hunk actions (review-focused)
					map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<cr>", "Stage hunk")
					map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<cr>", "Reset hunk (discard)")
					map("n", "<leader>hS", gs.stage_buffer, "Stage entire buffer")
					map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
					map("n", "<leader>hR", gs.reset_buffer, "Reset entire buffer")
					map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
					map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
					map("n", "<leader>hd", gs.diffthis, "Diff against index")
					map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff against last commit")

					-- Toggles
					map("n", "<leader>htb", gs.toggle_current_line_blame, "Toggle line blame")
					map("n", "<leader>htd", gs.toggle_deleted, "Toggle deleted")
					map("n", "<leader>htw", gs.toggle_word_diff, "Toggle word diff")

					-- Text object: ih = "in hunk" (works with d/y/c, e.g. `dih` deletes hunk)
					map({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", "Select hunk")
				end,
				signs = {
					--add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
					--change = {
					--	hl = "GitSignsChange",
					--	text = "▎",
					--	numhl = "GitSignsChangeNr",
					--	linehl = "GitSignsChangeLn",
					--},
					--delete = {
					--	hl = "GitSignsDelete",
					--	text = "󰐊",
					--	numhl = "GitSignsDeleteNr",
					--	linehl = "GitSignsDeleteLn",
					--},
					--topdelete = {
					--	hl = "GitSignsDelete",
					--	text = "󰐊",
					--	numhl = "GitSignsDeleteNr",
					--	linehl = "GitSignsDeleteLn",
					--},
					--changedelete = {
					--	hl = "GitSignsChange",
					--	text = "▎",
					--	numhl = "GitSignsChangeNr",
					--	linehl = "GitSignsChangeLn",
					--},
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000,
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
			})
		end,
	},
}
