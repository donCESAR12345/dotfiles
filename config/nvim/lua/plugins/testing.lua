local plugins = {
	-- Neotest
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter", -- Required for Treesitter integration
		},
		config = function()
			require("neotest").setup({
				runners = {
					python = {
						enabled = true,
						strategy = 'vim.fn.executable("pytest") and "pytest" or "unittest"', -- Corrected string literal
					},
					-- Add other language runners as needed (e.g., for C++, web)
				},
				-- Optional: Configure UI elements or other Neotest features
				icons = {
					running = "▶",
					failed = "",
					passed = "✔",
					-- Add other icons as needed
				},
			})
		end,
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Run tests",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run_nearest()
				end,
				desc = "Run nearest test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run_file()
				end,
				desc = "Run tests in file",
			},
			{
				"<leader>tS",
				function()
					require("neotest").output.open()
				end,
				desc = "Show test results",
			},
		},
	},
}

return plugins

