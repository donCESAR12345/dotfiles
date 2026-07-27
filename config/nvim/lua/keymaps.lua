local M = {}

-- ==============================================================================
-- CORE
-- ==============================================================================
M.core = function()
	local wk = require("which-key")

	-- Window navigation
	vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true })
	vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true })
	vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true })
	vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true })

	-- Search
	vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>")

	-- Neo-tree
	vim.keymap.set("n", "<leader>e", ":Neotree<CR>", {})
	vim.keymap.set("n", "<leader>E", ":Neotree filesystem close<CR>", {})

	-- Clipboard (Neovide / GUI paste)
	vim.keymap.set("c", "<C-V>", "<C-r>+", { noremap = true, silent = true })
	vim.keymap.set("i", "<C-V>", "<C-r>+", { noremap = true, silent = true })

	wk.add({
		{ "<leader>h", desc = "Clear search highlight" },
		{ "<leader>e", icon = "", desc = "Open file explorer" },
		{ "<leader>E", icon = "", desc = "Close file explorer" },
	})
end

-- ==============================================================================
-- DAP (Debug Adapter Protocol)
-- ==============================================================================
M.dap = function()
	local wk = require("which-key")
	local dap = require("dap")
	local dapui = require("dapui")

	vim.keymap.set("n", "<leader>Db", dap.toggle_breakpoint, {})
	vim.keymap.set("n", "<leader>Dc", dap.continue, {})
	vim.keymap.set("n", "<leader>Dq", dap.terminate, {})
	vim.keymap.set("n", "<leader>Do", dap.step_over, {})
	vim.keymap.set("n", "<leader>Di", dap.step_into, {})
	vim.keymap.set("n", "<leader>DO", dap.step_out, {})
	vim.keymap.set("n", "<leader>Dr", dap.repl.toggle, {})
	vim.keymap.set("n", "<leader>Du", dapui.toggle, {})

	wk.add({
		{ "<leader>D", icon = "", group = "DAP" },
		{ "<leader>Db", icon = "", desc = "Toggle breakpoint" },
		{ "<leader>Dc", icon = "", desc = "Continue / start" },
		{ "<leader>Dq", icon = "", desc = "Terminate session" },
		{ "<leader>Do", icon = "", desc = "Step over" },
		{ "<leader>Di", icon = "", desc = "Step into" },
		{ "<leader>DO", icon = "", desc = "Step out" },
		{ "<leader>Dr", icon = "", desc = "Toggle REPL" },
		{ "<leader>Du", icon = "", desc = "Toggle DAP UI" },
	})
end

-- ==============================================================================
-- GIT
-- ==============================================================================
M.git = function()
	local wk = require("which-key")

	vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", {})
	vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Status" })
	vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Branches" })

	wk.add({
		{ "<leader>g", icon = "󰊢", group = "Git" },
		{ "<leader>gg", icon = "", desc = "Open Neogit" },
		{ "<leader>gb", icon = "", desc = "Branches" },
		{ "<leader>gs", icon = "", desc = "Status" },
	})
end

-- ==============================================================================
-- LSP & DIAGNOSTICS
-- ==============================================================================
M.lsp = function()
	local wk = require("which-key")

	local toggle_diagnostics = function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end

	-- LSP actions
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

	-- Diagnostics
	vim.keymap.set("n", "<leader>de", vim.diagnostic.open_float, {})
	vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, {})
	vim.keymap.set("n", "<leader>dN", vim.diagnostic.goto_prev, {})
	vim.keymap.set("n", "<leader>dq", toggle_diagnostics, {})

	wk.add({
		{ "<leader>l", icon = "", group = "LSP" },
		{ "<leader>la", icon = "", desc = "Code action" },
		{ "<leader>ld", icon = "", desc = "Go to definition" },
		{ "<leader>lD", icon = "", desc = "Go to declaration" },
		{ "<leader>li", icon = "", desc = "Go to implementation" },
		{ "<leader>lr", icon = "", desc = "References" },
		{ "<leader>lR", icon = "󰑕", desc = "Rename symbol" },
		{ "<leader>ls", icon = "", desc = "Signature help" },
		{ "<leader>lf", icon = "󰉠", desc = "Format buffer" },
		{ "<leader>lS", icon = "", desc = "Document symbols" },

		{ "<leader>d", icon = "", group = "Diagnostics" },
		{ "<leader>de", icon = "󰘖", desc = "Open floating diagnostic" },
		{ "<leader>dn", icon = "", desc = "Next diagnostic" },
		{ "<leader>dN", icon = "", desc = "Previous diagnostic" },
		{ "<leader>dq", icon = "", desc = "Toggle diagnostics" },
	})
end

-- ==============================================================================
-- SEARCH (Snacks Picker)
-- ==============================================================================
M.search = function()
	local wk = require("which-key")

	vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Live grep" })
	vim.keymap.set("n", "<leader>fh", function() Snacks.picker.recent() end, { desc = "Recent files" })
	vim.keymap.set("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Bookmarks" })
	vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
	vim.keymap.set("n", "<leader>fc", function() Snacks.picker.colorschemes() end, { desc = "Select colorscheme" })

	wk.add({
		{ "<leader>f", icon = "󰍉", group = "Search" },
		{ "<leader>ff", icon = "󱙓", desc = "Find files" },
		{ "<leader>fg", icon = "󱎸", desc = "Live grep" },
		{ "<leader>fh", icon = "󰋚", desc = "Recent files" },
		{ "<leader>fm", icon = "󱤇", desc = "Bookmarks" },
		{ "<leader>fb", icon = "󰓗", desc = "Buffers" },
		{ "<leader>fc", icon = "󰏘", desc = "Select colorscheme" },
	})
end

-- ==============================================================================
-- TERMINAL (ToggleTerm)
-- ==============================================================================
M.toggleterm = function()
	local wk = require("which-key")

	vim.keymap.set("n", "<leader>tf", ":ToggleTerm name=float direction=float<CR>", {})
	vim.keymap.set("n", "<leader>tv", ":ToggleTerm name=vert direction=vertical size=50<CR>", {})
	vim.keymap.set("n", "<leader>th", ":ToggleTerm name=horiz direction=horizontal<CR>", {})
	vim.keymap.set("n", "<leader>td", function()
		local file = vim.fn.expand("%:p")
		if file == "" then
			vim.notify("No file associated with current buffer", vim.log.levels.WARN)
			return
		end
		local terminal = require("toggleterm.terminal").Terminal
		local vd = terminal:new({ cmd = "vd " .. vim.fn.shellescape(file), direction = "float" })
		vd:toggle()
	end, { desc = "Terminal Data explorer (VisiData)" })

	wk.add({
		{ "<leader>t", icon = "", group = "Terminal" },
		{ "<leader>tf", icon = "", desc = "Floating terminal" },
		{ "<leader>tv", icon = "", desc = "Vertical terminal" },
		{ "<leader>th", icon = "", desc = "Horizontal terminal" },
		{ "<leader>td", icon = "󰱿", desc = "Terminal Data explorer (VisiData)" },
	})
end

-- ==============================================================================
-- TESTING (Neotest)
-- ==============================================================================
M.testing = function()
	local wk = require("which-key")

	vim.keymap.set("n", "<leader>tt", function()
		require("neotest").run.run()
	end, {})
	vim.keymap.set("n", "<leader>tr", function()
		require("neotest").run.run_nearest()
	end, {})
	vim.keymap.set("n", "<leader>tF", function()
		require("neotest").run.run_file()
	end, {})
	vim.keymap.set("n", "<leader>tS", function()
		require("neotest").output.open()
	end, {})

	wk.add({
		{ "<leader>tt", icon = "", desc = "Run all tests" },
		{ "<leader>tr", icon = "", desc = "Run nearest test" },
		{ "<leader>tF", icon = "", desc = "Run tests in file" },
		{ "<leader>tS", icon = "", desc = "Show test results" },
	})
end

-- ==============================================================================
-- UTILS
-- ==============================================================================
M.utils = function()
	local wk = require("which-key")

	vim.keymap.set("n", "<leader>ui", function()
		require("utils").dev.install_deps()
	end, {})
	vim.keymap.set("n", "<leader>us", function()
		local script_name = vim.fn.input("Enter script name to run: ")
		if script_name ~= "" then
			require("utils").dev.run_script(script_name)
		end
	end, {})
	vim.keymap.set("n", "<leader>uv", function()
		require("utils").dev.setup_venv()
	end, {})

	wk.add({
		{ "<leader>u", icon = "⚙️", group = "Utils" },
		{ "<leader>ui", icon = "", desc = "Install dependencies" },
		{ "<leader>us", icon = "", desc = "Run script" },
		{ "<leader>uv", icon = "", desc = "Setup virtual env" },
	})
end

-- ==============================================================================
-- REPL (iron.nvim)
-- ==============================================================================
M.repl = function()
	local wk = require("which-key")
	wk.add({
		{ "<leader>r", group = "REPL" },
		{ "<leader>rt", desc = "Toggle REPL" },
		{ "<leader>rs", desc = "Send motion" },
		{ "<leader>rl", desc = "Send line" },
		{ "<leader>rf", desc = "Send file" },
	})
end

-- ==============================================================================
-- SETUP
-- ==============================================================================
M.setup = function()
	M.core()
	M.dap()
	M.git()
	M.lsp()
	M.search()
	M.toggleterm()
	M.testing()
	M.utils()
	M.repl()
end

return M
