return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap-python",
		},
		branch = "regexp",
		cmd = { "VenvSelect", "VenvSelectCached" },
		opts = {
			name = { "venv", ".venv" },
			auto_refresh = false,
			settings = {
				search = {
					pixi_envs = {
						type = "conda",
						search_target = "\\.pixi/envs/[^/]+/bin/python",
					},
				},
			},
		},
		keys = {
			{ "<leader>ue", "<cmd>VenvSelect<cr>", desc = "Select Python Venv (Neovim)" },
			{ "<leader>uc", "<cmd>VenvSelectCached<cr>", desc = "Select Cached Venv" },
		},
	},
}
