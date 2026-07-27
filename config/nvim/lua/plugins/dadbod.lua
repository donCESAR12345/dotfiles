return {
	{
		"tpope/vim-dadbod",
		lazy = true,
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = { "tpope/vim-dadbod" },
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_navigation = 1
		end,
		keys = {
			{ "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle Dadbod UI" },
		},
	},
	{
		"kristijanhusak/vim-dadbod-completion",
		dependencies = { "tpope/vim-dadbod", "hrsh7th/nvim-cmp" },
		ft = { "sql", "mysql", "plsql" },
		config = function()
			-- Hook Dadbod completion into nvim-cmp
			require("cmp").setup.filetype({ "sql", "mysql", "plsql" }, {
				sources = {
					{ name = "vim-dadbod-completion" },
					{ name = "nvim_lsp" },
					{ name = "buffer" },
				},
			})
		end,
	},
}
