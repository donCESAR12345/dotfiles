local plugins = {
    -- DAP
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()

            -- Listeners
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end

            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end

            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end

            -- Godot
            dap.adapters.godot = {
                type = "server",
                host = "127.0.0.1",
                port = 6006,
            }
        end,
    },

    -- Python debugging
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
        end,
    },

    -- Improved UI for debugging
    {
        "folke/neodev.nvim",
        opts = {},
        config = function()
            require("neodev").setup({library = { plugins = { "nvim-dap-ui" }, types = true }})
        end
    }
}

return plugins
