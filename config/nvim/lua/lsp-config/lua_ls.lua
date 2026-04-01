local M = {}

M.config = function()
	return {
		on_init = function(client)
			-- If the project has its own .luarc.json, respect it and bail out
			local path = client.workspace_folders[1].name
			if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
				return
			end

			-- Otherwise inject Neovim-specific settings so lua_ls understands
			-- the vim global, LuaJIT runtime, and bundled library paths
			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = {
					version = "LuaJIT",
				},
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
						"${3rd}/luv/library",
					},
				},
			})
		end,
		settings = {
			Lua = {},
		},
	}
end

return M
