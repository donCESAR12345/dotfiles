local plugins = {
	-- Highlight hex colors, rgb(), etc. inline in the buffer
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},

	-- Dashboard shown on startup
	{
		"goolord/alpha-nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")

			-- Resolve byte length of UTF-8 characters for color mapping
			local function getCharLen(s, pos)
				local byte = string.byte(s, pos)
				if not byte then
					return nil
				end
				return (byte < 0x80 and 1) or (byte < 0xE0 and 2) or (byte < 0xF0 and 3) or (byte < 0xF8 and 4) or 1
			end

			-- Apply per-character highlight groups to the ASCII logo
			local function applyColors(logo, colors, logoColors)
				dashboard.section.header.val = logo

				for key, color in pairs(colors) do
					local name = "Alpha" .. key
					vim.api.nvim_set_hl(0, name, color)
					colors[key] = name
				end

				dashboard.section.header.opts.hl = {}
				for i, line in ipairs(logoColors) do
					local highlights = {}
					local pos = 0

					for j = 1, #line do
						local opos = pos
						local char_len = getCharLen(logo[i], opos + 1)
						if not char_len then
							break
						end
						pos = pos + char_len
						local color_name = colors[line:sub(j, j)]
						if color_name then
							table.insert(highlights, { color_name, opos, pos })
						end
					end

					table.insert(dashboard.section.header.opts.hl, highlights)
				end

				return dashboard.opts
			end

			require("alpha").setup(applyColors({
				[[  ███       ███  ]],
				[[  ████      ████ ]],
				[[  ████     █████ ]],
				[[ █ ████    █████ ]],
				[[ ██ ████   █████ ]],
				[[ ███ ████  █████ ]],
				[[ ████ ████ ████ ]],
				[[ █████  ████████ ]],
				[[ █████   ███████ ]],
				[[ █████    ██████ ]],
				[[ █████     █████ ]],
				[[ ████      ████ ]],
				[[  ███       ███  ]],
				[[                    ]],
				[[  N  E  O  V  I  M  ]],
			}, {
				["b"] = { fg = "#3399ff", ctermfg = 33 },
				["a"] = { fg = "#53C670", ctermfg = 35 },
				["g"] = { fg = "#39ac56", ctermfg = 29 },
				["h"] = { fg = "#33994d", ctermfg = 23 },
				["i"] = { fg = "#33994d", bg = "#39ac56", ctermfg = 23, ctermbg = 29 },
				["j"] = { fg = "#53C670", bg = "#33994d", ctermfg = 35, ctermbg = 23 },
				["k"] = { fg = "#30A572", ctermfg = 36 },
			}, {
				[[  kkkka       gggg  ]],
				[[  kkkkaa      ggggg ]],
				[[ b kkkaaa     ggggg ]],
				[[ bb kkaaaa    ggggg ]],
				[[ bbb kaaaaa   ggggg ]],
				[[ bbbb aaaaaa  ggggg ]],
				[[ bbbbb aaaaaa igggg ]],
				[[ bbbbb  aaaaaahiggg ]],
				[[ bbbbb   aaaaajhigg ]],
				[[ bbbbb    aaaaajhig ]],
				[[ bbbbb     aaaaajhi ]],
				[[ bbbbb      aaaaajh ]],
				[[  bbbb       aaaaa  ]],
				[[                    ]],
				[[  a  a  a  b  b  b  ]],
			}))

			dashboard.section.buttons.val = {
				dashboard.button("p", "  Recent Projects", "<cmd>lua Snacks.picker.projects()<CR>"),
				dashboard.button("r", "  Recent Files", "<cmd>Telescope oldfiles<CR>"),
				dashboard.button("n", "  New File", "<cmd>ene<CR>"),
				dashboard.button(
					"c",
					"⚙️  Config Files",
					"<cmd>cd " .. vim.fn.stdpath("config") .. " | Neotree filesystem reveal dir=./ position=float<CR>"
				),
				dashboard.button("t", "  Open Terminal", "<cmd>ToggleTerm name=float direction=float<CR>"),
				dashboard.button("q", "  Quit", "<cmd>qa<CR>"),
			}

			dashboard.section.footer.val = {
				"✨ Powered by Neovim",
				"🚀 Ready to boost productivity!",
			}

			dashboard.opts.opts.noautocmd = true
			alpha.setup(dashboard.opts)
		end,
	},

	-- Discord Rich Presence
	{
		"andweeb/presence.nvim",
		lazy = false,
		opts = {
			main_image = "file",
		},
	},

	-- Indent guides with scope highlighting
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			scope = { enabled = true },
		},
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			theme = "catppuccin",
		},
	},

	-- Improved UI for messages, cmdline, and notifications
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {
					-- Required when background is transparent — sets the base
					-- color used to compute notification window transparency
					background_colour = "#000000",
				},
			},
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
				routes = {
					-- Suppress the "written" message after every save
					{
						filter = { event = "msg_show", kind = "", find = "written" },
						opts = { skip = true },
					},
				},
			})
		end,
	},

	-- Mount remote directories over SSH and browse with Telescope
	{
		"nosduco/remote-sshfs.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		opts = {},
	},

	-- Highlight and navigate TODO/FIXME/HACK/NOTE comments
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- LSP progress indicator shown in the bottom-right corner
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}

return plugins
