local plugins = {
	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		lazy = false,
		dependencies = {
			"rafamadriz/friendly-snippets", -- Community snippet collection
			"saadparwaiz1/cmp_luasnip", -- cmp source for LuaSnip
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- cmp sources
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-path" },

	-- AI completion (Windsurf / Codeium)
	{
		"Exafunction/windsurf.vim",
		event = "BufEnter",
	},

	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		lazy = false,
		config = function()
			local luasnip = require("luasnip")
			local cmp = require("cmp")

			-- Icons per LSP completion kind
			local kind_icons = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰜢",
				Variable = "󰀫",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "󰑭",
				Value = "󰎠",
				Enum = "",
				Keyword = "󰌋",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "",
				Codeium = "",
			}

			-- Source labels shown on the right of each item
			local source_labels = {
				codeium = "[AI]",
				luasnip = "[Snip]",
				nvim_lsp = "[LSP]",
				path = "[Path]",
				buffer = "[Buf]",
			}

			-- Only trigger completion when there's a real word before the cursor
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				-- Built-in formatting — no external plugin needed
				formatting = {
					format = function(entry, vim_item)
						vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
						vim_item.menu = source_labels[entry.source.name] or ""
						return vim_item
					end,
				},

				mapping = cmp.mapping.preset.insert({
					-- Tab: cycle completions or expand/jump snippets
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),

					-- Confirm only if an item is explicitly selected
					["<CR>"] = cmp.mapping({
						i = function(fallback)
							if cmp.visible() and cmp.get_active_entry() then
								cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
							else
								fallback()
							end
						end,
						s = cmp.mapping.confirm({ select = true }),
						c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
					}),
				}),

				sources = cmp.config.sources({
					{ name = "codeium" }, -- AI suggestions first
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" }, -- Fallback: words in current buffer
				}),
			})
		end,
	},
}

return plugins
