local opt = vim.opt
local g = vim.g

-- Leader must be set before lazy loads plugins
g.mapleader = " "

-- ==============================================================================
-- DISPLAY
-- ==============================================================================
opt.number = true
opt.relativenumber = true
opt.colorcolumn = "80"
opt.termguicolors = true
opt.showmatch = true

-- ==============================================================================
-- INDENTATION
-- ==============================================================================
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- 2-space indentation for web filetypes
vim.api.nvim_create_augroup("WebDevTabs", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "WebDevTabs",
	pattern = { "html", "css", "javascript", "typescript", "typescriptreact", "json" },
	command = "setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab",
})

-- ==============================================================================
-- SEARCH
-- ==============================================================================
opt.ignorecase = true
opt.hlsearch = true
opt.incsearch = true

-- ==============================================================================
-- MISC
-- ==============================================================================
opt.encoding = "utf-8"
opt.clipboard = "unnamedplus"

-- Required for Neovide clipboard support
opt.mouse:append("a")

-- ==============================================================================
-- PYTHON
-- ==============================================================================
-- Use the active uv venv if present, otherwise fall back to system Python
local venv_python = vim.fn.getcwd() .. "/.venv/bin/python"
if vim.fn.executable(venv_python) == 1 then
	vim.g.python3_host_prog = venv_python
else
	vim.g.python3_host_prog = vim.fn.exepath("python3")
end

-- ==============================================================================
-- LUAROCKS
-- ==============================================================================
-- Expose user-installed Lua rocks to Neovim's package loader
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"
