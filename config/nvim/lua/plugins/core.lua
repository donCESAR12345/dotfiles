local plugins = {
	-- Auto-close brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	-- gcc / gc to comment lines and motions
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},

	-- Git UI (status, diff, commit, rebase)
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("neogit").setup({})
		end,
	},

	-- File explorer, buffer list, git status, document symbols
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				filesystem = {
					hijack_netrw_behavior = "open_default",
				},
				sources = {
					"filesystem",
					"buffers",
					"git_status",
					"document_symbols",
				},
			})
		end,
	},

	-- Project root detection via LSP and common marker files
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				patterns = { ".git", "Makefile", "package.json", "pipfile", "pyproject.toml", ".env" },
			})
		end,
	},

	-- QOL utilities: big file handling, improved input UI
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			input = { enabled = true },
		},
	},

	-- Better vim.ui.select (used by LSP code actions, etc.)
	{ "nvim-telescope/telescope-ui-select.nvim" },

	-- Fuzzy finder for files, grep, LSP, git, and more
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
			require("telescope").load_extension("projects")
			require("telescope").load_extension("remote-sshfs")
		end,
	},

	-- Floating / split terminal toggled with a keymap
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				float_opts = {
					border = "curved",
				},
			})
		end,
	},

	-- Syntax highlighting, indentation, and code awareness
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.config").setup({
				auto_install = true,
				autotag = { enable = true },
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},

	-- Keymap hints popup on leader press
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {},
	},
}

return plugins
