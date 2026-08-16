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

			-- Default list of randomized subtitles
			local default_quotes = {
				"🚀 Innovación y desarrollo en GITA",
				"💡 Programando el futuro, una línea a la vez",
				"🔥 Que el código te acompañe",
				"⚡ Ready to build amazing things",
				"🧠 Keep calm and code on",
				"✨ Transformando ideas en software",
				"☕ Powered by coffee and passion",
				"🔬 Grupo de Investigación GITA <3",
			}

			-- Load quotes from quotes.txt if present, otherwise fallback to default list
			local function get_random_quote()
				local quotes_path = vim.fn.stdpath("config") .. "/quotes.txt"
				local quotes = {}
				local file = io.open(quotes_path, "r")
				if file then
					for line in file:lines() do
						if line:match("%S") then
							table.insert(quotes, line)
						end
					end
					file:close()
				end

				if #quotes == 0 then
					quotes = default_quotes
				end

				math.randomseed(os.time() + vim.fn.getpid())
				return quotes[math.random(#quotes)]
			end

			-- Load custom header from header.txt if present, otherwise fallback to default ASCII logo
			local function get_header()
				local header_path = vim.fn.stdpath("config") .. "/header.txt"
				local lines = {}
				local file = io.open(header_path, "r")
				if file then
					for line in file:lines() do
						table.insert(lines, line)
					end
					file:close()
				end

				if #lines == 0 then
					lines = {
						[[                                                    ]],
						[[  ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗███╗   ███╗  ]],
						[[  ████╗  ██║██╔════╝██╔══██╗██║   ██║██║████╗ ████║  ]],
						[[  ██╔██╗ ██║█████╗  ██║  ██║██║   ██║██║██╔████╔██║  ]],
						[[  ██║╚██╗██║██╔══╝  ██║  ██║╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
						[[  ██║ ╚████║███████╗██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
						[[  ╚═╝  ╚═══╝╚══════╝╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
						[[                                                    ]],
					}
				end

				-- Append randomized subtitle below the ASCII header
				table.insert(lines, "")
				table.insert(lines, "  " .. get_random_quote())
				table.insert(lines, "")
				return lines
			end

			dashboard.section.header.val = get_header()
			dashboard.section.header.opts.hl = "AlphaHeader"
			vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#7aa2f7", bold = true })

			-- Dashboard Buttons with Emojis
			dashboard.section.buttons.val = {
				dashboard.button("p", "📂  Recent Projects", "<cmd>lua Snacks.picker.projects()<CR>"),
				dashboard.button("r", "🕒  Recent Files", "<cmd>lua Snacks.picker.recent()<CR>"),
				dashboard.button("n", "📄  New File", "<cmd>ene<CR>"),
				dashboard.button(
					"c",
					"⚙️  Config Files",
					"<cmd>cd " .. vim.fn.stdpath("config") .. " | Neotree filesystem reveal dir=./ position=float<CR>"
				),
				dashboard.button("t", "💻  Open Terminal", "<cmd>ToggleTerm name=float direction=float<CR>"),
				dashboard.button("q", "🚪  Quit", "<cmd>qa<CR>"),
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
