return {
	-- Database client suite
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>du", "<cmd>DBUIToggle<cr>", desc = "Toggle DB UI" },
			{ "<leader>db", "<cmd>DBUI<cr>", desc = "Open DB connection list" },
		},
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_navigation = 1
			vim.g.db_ui_save_location = vim.fn.expand("~/.local/share/db_ui")
		end,
	},
}
