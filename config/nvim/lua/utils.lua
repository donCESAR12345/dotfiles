local M = {}

-- Run a shell command in a named floating toggleterm instance
M.run_in_toggleterm = function(command, name, dir_path)
	local Terminal = require("toggleterm.terminal").Terminal

	local term = Terminal:new({
		cmd = command,
		dir = dir_path or vim.fn.getcwd(),
		name = name or "helper_term",
		direction = "float",
		float_opts = {
			border = "curved",
		},
		hidden = true,
	})

	term:toggle()
end

-- Python development helpers
M.dev = {
	install_deps = function()
		M.run_in_toggleterm("pip install -r requirements.txt", "python_dev_term")
	end,

	run_script = function(script_name)
		M.run_in_toggleterm("python " .. script_name, "python_dev_term")
	end,

	-- Activate the local .venv and confirm the Python version
	setup_venv = function()
		M.run_in_toggleterm(". .venv/bin/activate && python --version", "python_dev_term")
	end,
}

return M
