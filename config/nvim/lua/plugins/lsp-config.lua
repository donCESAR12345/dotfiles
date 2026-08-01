local plugins = {
	-- Mason: install and manage LSPs, linters, and formatters
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	-- Bridge between mason and nvim-lspconfig (auto-installs LSP servers)
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},

	-- Bridge between mason and conform (auto-installs formatters)
	{
		"zapling/mason-conform.nvim",
		lazy = false,
		config = function()
			require("mason-conform").setup()
		end,
	},

	-- LSP client configuration
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- Force UTF-8 encoding on all servers to avoid position encoding
			-- conflicts when multiple LSPs attach to the same buffer (e.g. pyright + ruff)
			local default_config = {
				capabilities = capabilities,
				positionEncodings = { "utf-8" },
			}

			local servers = {
				"ansiblels", -- Ansible
				"bashls", -- Bash / Shell
				"dockerls", -- Docker
				"pyright", -- Python (type checking)
				"ruff", -- Python (linting + formatting)
				"lua_ls", -- Lua
				"sqls", -- SQL
				"terraformls", -- Terraform
				"ts_ls", -- TypeScript / JavaScript
				"yamlls", -- YAML
			}

			for _, server in ipairs(servers) do
				if server == "lua_ls" then
					-- lua_ls needs Neovim-specific workspace configuration
					local specific_config = require("lsp-config.lua_ls").config()
					vim.lsp.config(server, specific_config)
				else
					vim.lsp.config(server, default_config)
				end
				vim.lsp.enable(server)
			end
		end,
	},

	-- Formatter (auto-format on save via format_on_save option)
	{
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_format" },
				html = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "shfmt" },
				terraform = { "terraform_fmt" },
				sql = { { "sqlfluff", "sql_formatter" } },
				mysql = { { "sqlfluff", "sql_formatter" } },
				yaml = { "yamlfmt" },
				yml = { "yamlfmt" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 3000,
			},
			formatters = {
				sql_formatter = {
					prepend_args = { "--config", '{"tabWidth": 4}' },
				},
				sqlfluff = {
					prepend_args = { "--dialect", "ansi" },
				},
			},
		},
	},
}

return plugins
