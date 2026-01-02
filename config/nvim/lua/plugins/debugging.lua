local plugins = {
    -- DAP
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        config = function()
            -- Add your DAP configurations here if needed
        end,
    },
    -- DAP Python
    {
        "mfussenegger/nvim-dap-python",
        lazy = false,
        config = function()
            require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')
        end,
    },
}

return plugins