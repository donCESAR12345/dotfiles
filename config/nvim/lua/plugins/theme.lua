local plugins = {
	-- Colorscheme — loaded with highest priority to avoid flash of unstyled UI
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			-- Read the current mode from eye-guard-cli's cache
			local flavour = "mocha" -- default to dark
			local cache_file = vim.fn.expand("~/.cache/eye-guard-cli/current_mode")
			local f = io.open(cache_file, "r")
			if f then
				local mode = f:read("*l"):gsub("%s+", "")
				f:close()
				if mode == "light" then
					flavour = "latte"
				end
			end

			require("catppuccin").setup({
				flavour = flavour, -- mocha (dark) | latte (light)
				transparent_background = true,
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}

return plugins
