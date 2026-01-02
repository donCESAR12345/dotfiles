local M = {}

M.setup = function()
    -- Add filetype detection for .ipynb files
    vim.filetype.add({
      extension = {
        ipynb = 'ipynb',  -- Map .ipynb extension to 'ipynb' filetype
      },
    })
end

return M
