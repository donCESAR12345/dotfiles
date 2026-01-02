local opt = vim.opt
local g = vim.g

opt.encoding = "utf-8" -- set encoding
opt.number = true -- add line numbers
opt.relativenumber = true -- add relative line numbers
opt.tabstop = 4 -- number of columns occupied by a tab
opt.softtabstop = 4 -- see multiple spaces as tabstops
opt.shiftwidth = 4 -- width for autoindents
opt.expandtab = true -- convert tabs into spaces
opt.autoindent = true -- indent a new line the same as the line just typed

opt.clipboard = "unnamedplus"
opt.smartindent = true
opt.ignorecase = true
opt.showmatch = true
opt.hlsearch = true
opt.incsearch = true
opt.cc = "80"

-- Fix copy/paste into Neovide
opt.mouse:append("a")

-- Key mappings for clipboard operations
vim.api.nvim_set_keymap("c", "<C-V>", "<C-r>+", { noremap = true, silent = true }) -- Paste in command mode
vim.api.nvim_set_keymap("i", "<C-V>", '<C-r>+', { noremap = true, silent = true }) -- Paste in insert mode

g.mapleader = " "

vim.opt.termguicolors = true
vim.wo.number = true

vim.api.nvim_set_hl(0, "Normal", {
	fg = "#bbbbbb",
	bg = "NONE",
	bold = false,
	italic = false,
	underline = false,
	undercurl = false,
})

-- Example for configuring Neovim to load user-installed installed Lua rocks:
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?/init.lua"
package.path = package.path .. ";" .. vim.fn.expand("$HOME") .. "/.luarocks/share/lua/5.1/?.lua"

-- Python virtual env
vim.g.python3_host_prog = vim.fn.expand("~/.conda/envs/academy/bin/python3.11")

-- Web development 2 spaces
vim.api.nvim_create_augroup("WebDevTabs", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "WebDevTabs",
	pattern = { "html", "css", "javascript", "typescript", "typescriptreact", "json" },
	command = "setlocal shiftwidth=2 softtabstop=2 tabstop=2 expandtab",
})
