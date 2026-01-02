local M = {}

-- Function to execute a command in a toggleterm instance
M.run_in_toggleterm = function(command, name, dir_path)
	local toggleterm = require("toggleterm.terminal")
	dir_path = dir_path or vim.fn.getcwd() -- Use current working directory if not specified

	toggleterm.open({
		dir = dir_path,
		float_opts = {
			border = "curved",
		},
		hidden = true, -- Start hidden, open when needed
		name = name or "helper_term",
	})

	-- Send command to the terminal instance
	-- Use `vim.api.nvim_exec_lua` to ensure commands are executed correctly in Lua context
	vim.api.nvim_exec_lua(
		string.format('require("toggleterm.util").send_command(%q, %q)', name or "helper_term", command),
		false
	)

	-- Open the terminal window after sending the command
	vim.cmd(string.format("ToggleTerm name=%s direction=float", name or "helper_term"))
end

-- Specific commands for Python development
M.dev = {
	install_deps = function()
		local cmd = "pip install -r requirements.txt"
		M.run_in_toggleterm(cmd, "python_dev_term", vim.fn.getcwd())
	end,
	run_script = function(script_name)
		local cmd = "python " .. script_name
		M.run_in_toggleterm(cmd, "python_dev_term", vim.fn.getcwd())
	end,
	setup_venv = function()
		-- Assumes venv is created with 'python -m venv .venv' or similar
		-- This command might need adjustment based on your venv creation method
		local cmd = ". .venv/bin/activate && python --version"
		M.run_in_toggleterm(cmd, "python_dev_term", vim.fn.getcwd())
	end,
}

return M
