local M = {}
local wk = require("which-key")

-- General and core
M.core = function()
	-- Mappings
	-- Better navigation through vim windows
	vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", { silent = true })
	vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", { silent = true })
	vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", { silent = true })
	vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", { silent = true })
	-- Turn off highlighting
	vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

	-- NeoTree
	vim.keymap.set("n", "<leader>e", ":Neotree<CR>", {})
	vim.keymap.set("n", "<leader>E", ":Neotree filesystem close<CR>", {})

	-- Which-key
	wk.add({
		{ "<leader>h", desc = "Disable search highlight" },
		{ "<leader>e", icon = "", desc = "Open filesystem sidebar" },
		{ "<leader>E", icon = "", desc = "Close filesystem sidebar" },
	})
end

-- Debug Adapter Protocol
M.dap = function()
	-- Mappings
	local dap = require("dap")
	vim.keymap.set("n", "<Leader>Db", dap.toggle_breakpoint, {})
	vim.keymap.set("n", "<Leader>Dc", dap.continue, {})
	vim.keymap.set("n", "<Leader>Dq", dap.terminate, {})
	vim.keymap.set("n", "<Leader>Do", dap.step_over, {})
	vim.keymap.set("n", "<Leader>Di", dap.step_into, {})
	vim.keymap.set("n", "<Leader>DO", dap.step_out, {})
	vim.keymap.set("n", "<Leader>Dr", dap.repl.toggle, {})

	-- Which-key
	wk.add({
		{ "<leader>D", icon = "", group = "DAP" },
		{ "<leader>Db", icon = "", desc = "Toggle breakpoint" },
		{ "<leader>Dc", icon = "", desc = "Start debugging" },
		{ "<leader>Dq", icon = "", desc = "Terminate debugging" },
		{ "<leader>Do", icon = "", desc = "Step over" },
		{ "<leader>Di", icon = "", desc = "Step into" },
		{ "<leader>DO", icon = "", desc = "Step out" },
		{ "<leader>Dr", icon = "", desc = "Toggle REPL" },
	})
end

-- Git
M.git = function()
	local builtin = require("telescope.builtin")
	-- Mappings
	vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", {})
	vim.keymap.set("n", "<leader>gs", builtin.git_status, {})
	vim.keymap.set("n", "<leader>gb", builtin.git_branches, {})

	-- Which-key
	wk.add({
		{ "<leader>g", icon = "", group = "NeoGit" },
		{ "<leader>gg", icon = "", desc = "Run NeoGit" },
		{ "<leader>gb", icon = "", desc = "Git Branches" },
		{ "<leader>gs", icon = "", desc = "Git Status" },
	})
end

-- LSP and diagnostics
M.lsp = function()
	local toggle_diagnostics_fn = function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end
	-- Mappings
	vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, {})
	vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, {})
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, {})
	vim.keymap.set("n", "<leader>li", vim.lsp.buf.implementation, {})
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.references, {})
	vim.keymap.set("n", "<leader>lR", vim.lsp.buf.rename, {})
	vim.keymap.set("n", "<leader>ls", vim.lsp.buf.signature_help, {})
	vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, {})
	vim.keymap.set("n", "<leader>lS", ":Neotree document_symbols reveal float<CR>", {})

	vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, {})
	vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {})
	vim.keymap.set("n", "<leader>dN", vim.diagnostic.goto_prev, {})
	vim.keymap.set("n", "<leader>dq", toggle_diagnostics_fn, {})

	-- Which-key
	wk.add({
		{ "<leader>l", icon = "", group = "LSP" },
		{ "<leader>la", icon = "", desc = "Code action" },
		{ "<leader>ld", icon = "", desc = "Go to definition" },
		{ "<leader>lD", icon = "", desc = "Go to declaration" },
		{ "<leader>li", icon = "", desc = "Go to implementation" },
		{ "<leader>lr", icon = "", desc = "Search references" },
		{ "<leader>lR", icon = "󰑕", desc = "Rename symbol" },
		{ "<leader>ls", icon = "", desc = "Signature help" },
		{ "<leader>lf", icon = "󰉠", desc = "Format" },
		{ "<leader>lS", icon = "", desc = "Show document symbols" },

		{ "<leader>d", icon = "", group = "Diagnostics" },
		{ "<leader>de", icon = "󰘖", desc = "Open floating diagnostic" },
		{ "<leader>dn", icon = "", desc = "Go to next diagnostic" },
		{ "<leader>dN", icon = "", desc = "Go to previous diagnostic" },
		{ "<leader>dq", icon = "", desc = "Toggle diagnostics" },
	})
end

-- Telescope
M.telescope = function()
	local builtin = require("telescope.builtin")

	vim.keymap.set("n", "<leader>b", builtin.buffers, {})
	vim.keymap.set("n", "<leader>c", builtin.colorscheme, {})
	vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
	vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
	vim.keymap.set("n", "<leader>fh", builtin.oldfiles, {})
	vim.keymap.set("n", "<leader>fm", builtin.marks, {})

	-- Which-key
	wk.add({
		{ "<leader>b", icon = "", desc = "Show buffers" },
		{ "<leader>c", icon = "", desc = "Select colorscheme" },
		{ "<leader>f", icon = "", group = "Search" },
		{ "<leader>ff", icon = "󱙓", desc = "Find files by name" },
		{ "<leader>fg", icon = "󱎸", desc = "Find files using content (grep)" },
		{ "<leader>fh", icon = "", desc = "Open recent files" },
		{ "<leader>fm", icon = "󱤇", desc = "Jump to bookmarks" },
	})
end

-- ToggleTerm
M.toggleterm = function()
	-- vim.keymap.set("n", "<leader>tt", ":ToggleTerm name=tab direction=tab<CR>", {})
	vim.keymap.set("n", "<leader>tf", ":ToggleTerm name=float direction=float<CR>", {})
	vim.keymap.set("n", "<leader>tv", ":ToggleTerm name=vert direction=vertical size=50<CR>", {})
	vim.keymap.set("n", "<leader>th", ":ToggleTerm name=horiz direction=horizontal<CR>", {})

	-- Which-key
	wk.add({
		{ "<leader>t", icon = "", group = "Terminal" },
		-- { "<leader>tt", icon = "", desc = "Open terminal in new tab" },
		{ "<leader>tf", icon = "", desc = "Open floating terminal" },
		{ "<leader>tv", icon = "", desc = "Open vertical terminal (to the right)" },
		{ "<leader>th", icon = "", desc = "Open horizontal terminal (at the bottom)" },
	})
end

-- Utilities
M.utils = function()
	-- Mappings for utility functions
	vim.keymap.set("n", "<leader>ui", function()
		require("utils").dev.install_deps()
	end, { desc = "Install dependencies" })
	vim.keymap.set("n", "<leader>us", function()
		local script_name = vim.fn.input("Enter script name to run: ")
		if script_name ~= "" then
			require("utils").dev.run_script(script_name)
		end
	end, { desc = "Run script" })
	vim.keymap.set("n", "<leader>uv", function()
		require("utils").dev.setup_venv()
	end, { desc = "Setup virtual env" })

	-- Which-key
	wk.add({
		{ "<leader>u", icon = "⚙️", group = "Utils" },
		{ "<leader>ui", icon = "", desc = "Install dependencies" },
		{ "<leader>us", icon = "", desc = "Run script" },
		{ "<leader>uv", icon = "", desc = "Setup virtual env" },
	})
end

M.setup = function()
	M.core()
	M.dap()
	M.git()
	M.lsp()
	M.telescope()
	M.toggleterm()
	M.utils() -- Add call to M.utils()
end

return M

