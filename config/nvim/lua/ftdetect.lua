local M = {}

M.setup = function()
	vim.filetype.add({
		extension = {
			-- Jupyter notebooks
			ipynb = "ipynb",
			-- Terraform variable files (required for terraformls)
			tfvars = "terraform-vars",
		},
	})
end

return M
