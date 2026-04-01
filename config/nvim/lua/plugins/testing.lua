local plugins = {
	-- Test runner UI — keymaps are defined in keymaps.lua (M.testing)
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/nvim-nio",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-python")({
						dap = { justMyCode = false },
						runner = "pytest", -- fallback: "unittest"
					}),
				},
				icons = {
					running = "▶",
					failed = "",
					passed = "✔",
				},
			})
		end,
	},
}

return plugins
