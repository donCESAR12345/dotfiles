local plugins = {
	-- Mason
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},

	-- Mason with LSP
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},

	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			local default_config = {
				capabilities = capabilities,
			}

			local servers = {
				"ansiblels", -- Ansible
				"bashls", -- Shell
				"clangd", -- C/C++
				"dockerls", -- Docker
				"gdscript", -- GodotScript
				"groovyls", -- Groovy
				"html", -- HTML
				"ruff", -- Python
				"lua_ls", -- Lua
				-- "qml_lsp",                -- QML
				"rust_analyzer", -- Rust
				"ts_ls", -- Typescript/Javascript
			}

			-- Default config
			for _, server in ipairs(servers) do
				-- Lua
				if server == "lua_ls" then
					local specific_config = require("lsp-config.lua_ls").config()
					vim.lsp.config(server, specific_config)
				else
					vim.lsp.config(server, default_config)
				end
				vim.lsp.enable(server)
			end
		end,
	},

	-- Conform
	{
		"stevearc/conform.nvim",
		lazy = false,
		opts = {
			formatters_by_ft = {
				-- Lua
				lua = { "stylua" },
				-- Python
				python = { "ruff_format", "black" },
				-- Web
				html = { "djlint" },
				css = { "prettierd" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				json = { "prettierd" },
				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },
				-- C/C++
				c = { "clang_format" },
				cpp = { "clang_format" },
				-- GoDot
				gdscript = { "gdformat" },
				-- Groovy
				groovy = { "npm_groovy_lint" },
				-- Terraform
				terraform = { "terraform_fmt" },
				-- PHP
				php = { "phpcsfixer" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		},
		init = function()
			-- If you want the formatexpr, make the following change
			-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			-- conform will run once before saving
			vim.api.nvim_create_autocmd({ "BufWritePre" }, {
				group = vim.api.nvim_create_augroup("ConformFormat", { clear = true }),
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
}

return plugins
