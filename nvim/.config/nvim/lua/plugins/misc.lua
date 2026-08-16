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
				"🇨🇴 `sudo pacman -S tinto` — Compilando desde Medellín 🌺",
				"🐍 `import mine` — Minando diamantes en Minecraft a 60 FPS ⛏️",
				"⚔️ Exterminate en Eris completado con un script de Python 🤖",
				"👺 ¡WOAH! Aku Aku te protege contra los `segmentation fault` 📦",
				"🌲 Picando madera en Minecraft mientras compilo el Kernel de Linux 🐧",
				"🔬 Ciencia Abierta: ¡Conocimiento libre sin DRM ni paywalls! 🌐",
				"🌌 Viajando en la nave de Starbound con un tinto colombiano ☕✨",
				"📶 `ping 8.8.8.8` — Modulando telecomunicaciones contra el Moon Lord 🐙",
				"🔮 Wakfu y Stasis equilibrados con un `try-except` en Python ⚖️",
				"💥 Crash Bandicoot rompiendo cajas de TNT cuando encuentra un bug 💣",
				"🛡️ `sudo chown -R tenno:orokin /system` — Ciencia abierta en el Sistema Origen 🚀",
				"🧱 ¿Para qué Redstone si puedes diseñar telecomunicaciones en Python? 🔌",
				"🌿 Terraria Guide: +100 de velocidad al programar en Linux con tinto ☕",
				"🐧 Rule #1 en Linux: Never dig straight down unless it's `cd ~/.config` ⛏️",
				"📡 Telecomunicaciones + Ciencia Abierta = Conocimiento sin latencia 🌐",
				"💎 `pip install aku-aku` — ¡Invulnerable a errores de sintaxis! 👺",
				"🌸 En Medellín no hay invierno, solo `git pull` con sabor a bandeja paisa 🍲",
				"🚀 \"Clem GRAKATA!\" — Script en Python disparando paquetes TCP a toda velocidad 🔫",
				"🔮 Iop de Wakfu intentando entender punteros en C++ 🧠⚡",
				"👾 Esquivando duendes en Terraria mientras configuro un servidor en Arch Linux 🏹",
				"🌌 Reparando el FTL drive de Starbound con un script de Bash y alambre 🛰️",
				"🍎 Dr. Neo Cortex creando mutantes con `python -m venv` 🧪",
				"☕ El mejor canal de telecomunicaciones: La señal de la arriera con tinto paisa 🏔️",
				"🧱 Netherite Ingot + Linux Kernel = Servidor indestructible 🛡️",
				"🔬 \"Publish your code or it didn't happen\" — Manifiesto de Ciencia Abierta 📖",
				"🐍 `while True: sleep(0.1)` — El reloj interno de un Wabbit en Wakfu 🐇",
				"📡 Antena paraboide ajustada a 5.8GHz en los cerros de Medellín 📶",
				"💥 Jugueteando con TNT en Minecraft hasta que se cae la conexión SSH 💣",
				"🛡️ Vor's Prize: \"Look at them, they come to this place when they know they are not pure\" 🔮",
				"🌾 Sembrando papas en Minecraft con automatización de antenas en Python 🚜",
				"🦊 Crash corriendo de la piedra gigante como yo corriendo del deadline del paper 🏃‍♂️💨",
				"🌌 Flora y fauna alienígena de Starbound catalogada en repositorios de Ciencia Abierta 🪐",
				"📶 Fibra óptica en Colombia: Transmitiendo petabytes de conocimiento libre 🇨🇴",
				"🐧 `chmod +x invencibilidad_aku_aku.sh` 👺",
				"🔬 Grupo de Investigación GITA — Ciencia Abierta & Telecomunicaciones <3 💖",
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
