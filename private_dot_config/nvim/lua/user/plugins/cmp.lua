return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"giuxtaposition/blink-cmp-copilot",
		},
		version = "*",
		opts = {
			keymap = {
				preset = "default",
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
				["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				menu = {
					border = "rounded",
					draw = {
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icons = {
										Text = "󰉿",
										Method = "m",
										Function = "󰊕",
										Constructor = "",
										Field = "",
										Variable = "󰆧",
										Class = "󰌗",
										Interface = "",
										Module = "",
										Property = "",
										Unit = "",
										Value = "󰎠",
										Enum = "",
										Keyword = "󰌋",
										Snippet = "",
										Color = "󰏘",
										File = "󰈙",
										Reference = "",
										Folder = "󰉋",
										EnumMember = "",
										Constant = "󰇽",
										Struct = "",
										Event = "",
										Operator = "󰆕",
										TypeParameter = "󰊄",
									}
									return kind_icons[ctx.kind] or ctx.kind_icon
								end,
							},
							source_name = {
								text = function(ctx)
									local source_names = {
										copilot = "[COPILOT]",
										lsp = "[LSP]",
										snippets = "[Snippet]",
										buffer = "[Buffer]",
										path = "[Path]",
									}
									return source_names[ctx.source_name] or string.format("[%s]", ctx.source_name)
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = false,
					auto_show_delay_ms = 500,
					window = {
						border = "rounded",
					},
				},
			},
			signature = {
				enabled = false,
				window = {
					border = "rounded",
				},
			},
		},
		opts_extend = { "sources.default" },
	},
}
