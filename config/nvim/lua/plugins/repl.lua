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
			iron.setup({
				config = {
					scratch_repl = true,
					repl_definition = {
						python = {
							command = { "ipython", "--no-autoindent" },
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
