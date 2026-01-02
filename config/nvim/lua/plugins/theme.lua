local plugins = {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 9000,
		config = function()
			require("tokyonight").setup({
				style = "night", -- or 'moon', 'storm', 'day'
			})
			vim.cmd("colorscheme tokyonight")
		end,
	},
	-- {
	--     "Mofiqul/dracula.nvim",
	--     lazy = false,
	--     priority = 1000,
	--     opts = {},
	--     config = function()
	--         vim.cmd("colorscheme dracula")
	--     end,
	-- },
	-- {
	-- 	"catppuccin/nvim",
	--     lazy = false,
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	--  	config = function()
	--  		vim.cmd("colorscheme catppuccin-mocha")
	--  	end,
	-- },
	{
		"f-person/auto-dark-mode.nvim",
		opts = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
				require("tokyonight").setup({
					style = "night", -- Switch to night style
				})
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
				require("tokyonight").setup({
					style = "day", -- Switch to day style
				})
			end,
		},
	},
}

return plugins
