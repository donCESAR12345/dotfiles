local plugins = {
	-- DAP core — debug adapter protocol client
	{
		"mfussenegger/nvim-dap",
		lazy = false,
		config = function()
			-- Adapter configurations live in their respective language plugins below
		end,
	},

	-- DAP UI — floating windows for variables, stack, breakpoints, console
	{
		"rcarriga/nvim-dap-ui",
		lazy = false,
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			-- Open/close UI automatically when a debug session starts or ends
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},

	-- Python debug adapter (uses debugpy)
	{
		"mfussenegger/nvim-dap-python",
		lazy = false,
		config = function()
			-- Path to the python executable installed by Mason
			local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
			if mason_path ~= "" then
				require("dap-python").setup(mason_path)
			else
				vim.notify("debugpy not found in Mason — DAP for Python disabled", vim.log.levels.WARN)
			end
		end,
	},
}

return plugins
