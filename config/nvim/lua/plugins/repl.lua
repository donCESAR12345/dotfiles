return {
	-- Jinja/Jinja2 syntax support (dbt SQL templates)
	{
		"Glench/Vim-Jinja2-Syntax",
		ft = { "jinja", "html", "sql" },
	},

	-- Interactive REPL (iron.nvim)
	{
		"hkupty/iron.nvim",
		cmd = { "IronRepl", "IronReplHere", "IronFocus" },
		keys = {
			{ "<leader>rt", "<cmd>IronRepl<cr>", desc = "Toggle REPL" },
			{ "<leader>rs", mode = { "n", "v" }, desc = "Send motion to REPL" },
			{ "<leader>rl", desc = "Send line to REPL" },
			{ "<leader>rf", desc = "Send file to REPL" },
		},
		config = function()
			local iron = require("iron.core")

			local function get_python_cmd()
				local python_bin, ipython_bin
				-- 1. Try venv-selector safely
				local ok, venv_selector = pcall(require, "venv-selector")
				if ok and venv_selector.get_active_path then
					local active_path = venv_selector.get_active_path()
					if active_path and active_path ~= "" then
						ipython_bin = active_path .. "/bin/ipython"
						python_bin = active_path .. "/bin/python"
					end
				end

				-- 2. Fallback to local directory detection
				if not ipython_bin then
					local cwd = vim.fn.getcwd()
					for _, prefix in ipairs({ cwd .. "/.venv", cwd .. "/.pixi/envs/default" }) do
						if vim.fn.executable(prefix .. "/bin/ipython") == 1 then
							ipython_bin = prefix .. "/bin/ipython"
							break
						elseif vim.fn.executable(prefix .. "/bin/python") == 1 then
							python_bin = prefix .. "/bin/python"
							break
						end
					end
				end

				-- 3. Return executable with appropriate flags
				if ipython_bin and vim.fn.executable(ipython_bin) == 1 then
					return { ipython_bin, "--no-autoindent" }
				elseif python_bin and vim.fn.executable(python_bin) == 1 then
					return { python_bin }
				elseif vim.fn.executable("ipython") == 1 then
					return { "ipython", "--no-autoindent" }
				else
					return { "python3" }
				end
			end

			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						python = {
							command = get_python_cmd,
						},
						sh = {
							command = { "bash" },
						},
					},
					repl_open_cmd = require("iron.view").split.vertical.botright("50%"),
				},
				keymaps = {
					send_motion = "<leader>rs",
					visual_send = "<leader>rs",
					send_file = "<leader>rf",
					send_line = "<leader>rl",
				},
			})
		end,
	},
}
