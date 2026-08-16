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
		local cwd = vim.fn.getcwd()
		local cmd
		if (vim.fn.filereadable(cwd .. "/pixi.toml") == 1 or vim.fn.filereadable(cwd .. "/pixi.lock") == 1) and vim.fn.executable("pixi") == 1 then
			cmd = "pixi install"
		elseif vim.fn.filereadable(cwd .. "/poetry.lock") == 1 and vim.fn.executable("poetry") == 1 then
			cmd = "poetry install"
		elseif vim.fn.executable("uv") == 1 then
			if vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
				cmd = "uv pip install -e ."
			elseif vim.fn.filereadable(cwd .. "/requirements.txt") == 1 then
				cmd = "uv pip install -r requirements.txt"
			end
		elseif vim.fn.filereadable(cwd .. "/requirements.txt") == 1 then
			cmd = "pip install -r requirements.txt"
		elseif vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
			cmd = "pip install -e ."
		end

		if cmd then
			M.run_in_toggleterm(cmd, "python_dev_term")
		else
			vim.notify("No suitable package manager or project manifest found", vim.log.levels.WARN)
		end
	end,

	run_script = function(script_name)
		M.run_in_toggleterm("python " .. vim.fn.shellescape(script_name), "python_dev_term")
	end,

	-- Activate the environment and confirm python version
	setup_venv = function()
		local cwd = vim.fn.getcwd()
		local cmd
		if (vim.fn.filereadable(cwd .. "/pixi.toml") == 1 or vim.fn.filereadable(cwd .. "/pixi.lock") == 1) and vim.fn.executable("pixi") == 1 then
			cmd = "pixi shell"
		elseif vim.fn.filereadable(cwd .. "/poetry.lock") == 1 and vim.fn.executable("poetry") == 1 then
			cmd = "poetry shell"
		elseif vim.fn.filereadable(cwd .. "/.venv/bin/activate") == 1 then
			cmd = ". .venv/bin/activate && python --version"
		else
			cmd = "python3 --version"
		end
		M.run_in_toggleterm(cmd, "python_dev_term")
	end,

	-- Marimo notebook helpers
	marimo_edit = function()
		local file = vim.fn.expand("%:p")
		if file == "" or vim.bo.filetype ~= "python" then
			vim.notify("Current buffer is not a saved Python file", vim.log.levels.WARN)
			return
		end
		M.run_in_toggleterm("marimo edit " .. vim.fn.shellescape(file), "marimo_term")
	end,

	marimo_run = function()
		local file = vim.fn.expand("%:p")
		if file == "" or vim.bo.filetype ~= "python" then
			vim.notify("Current buffer is not a saved Python file", vim.log.levels.WARN)
			return
		end
		M.run_in_toggleterm("marimo run " .. vim.fn.shellescape(file), "marimo_term")
	end,
}

return M
