local plugins = {
	{
		"hat0uma/csvview.nvim",
		ft = { "csv", "tsv" },
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
		keys = { { "<leader>cv", "<cmd>CsvViewToggle<cr>", desc = "Toggle CSV View" } },
		opts = {
			parser = {
				comments = { "#", "!" },
			},
			view = {
				display_mode = "border",
			},
		},
		config = function(_, opts)
			require("csvview").setup(opts)
		end,
	},
}

return plugins
