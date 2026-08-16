-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Load order matters: options (and mapleader) must come before lazy
require("vim-options")
require("lazy").setup("plugins", {
	rocks = { enabled = false }, -- luarocks not available, no plugins require it
})
require("keymaps").setup()
require("ftdetect").setup()
