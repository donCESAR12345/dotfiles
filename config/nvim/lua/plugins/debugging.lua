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
			-- Requires a debugpy installation in a dedicated virtualenv:
			-- python -m venv ~/.virtualenvs/debugpy && pip install debugpy
			local debugpy = vim.fn.expand("~/.virtualenvs/debugpy/bin/python")
			if vim.fn.executable(debugpy) == 1 then
				require("dap-python").setup(debugpy)
			else
				vim.notify("debugpy not found — DAP for Python disabled", vim.log.levels.WARN)
			end
		end,
	},
}

return plugins
