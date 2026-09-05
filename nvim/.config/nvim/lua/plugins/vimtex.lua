local M = {
  "lervag/vimtex",
  lazy = false, -- Recommended by VimTeX for proper filetype detection and setup
}

-- Global session variables for tracking state
local last_compiled_pdf = nil
local last_project_root = nil
local compile_job_id = nil

-- Walk up directory tree starting from start_path to locate a Makefile
local function find_project_root(start_path)
  local path = start_path
  while path and path ~= "/" do
    local makefile = path .. "/Makefile"
    if vim.fn.filereadable(makefile) == 1 then
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  return nil
end

-- Resolve relative PDF target path from the edited file and the project root
local function resolve_pdf_target(root, file_path)
  local rel_path = file_path:sub(#root + 2)
  
  -- If the file belongs to a specific module
  if rel_path:match("^modules/") then
    local parts = vim.split(rel_path, "/")
    if #parts >= 4 then
      if #parts == 4 then
        -- modules/<mod>/<doc_type>/<file>.tex -> modules/<mod>/<doc_type>/<file>.pdf
        local base_name = parts[4]:gsub("%.tex$", "")
        return table.concat({parts[1], parts[2], parts[3], base_name .. ".pdf"}, "/")
      else
        -- modules/<mod>/<doc_type>/sections/... -> modules/<mod>/<doc_type>/main.pdf
        return table.concat({parts[1], parts[2], parts[3], "main.pdf"}, "/")
      end
    end
  -- If it's a shared configuration file
  elseif rel_path:match("^common/") then
    return last_compiled_pdf
  end
  
  -- Fallback for files at the root level
  if rel_path:match("%.tex$") then
    return rel_path:gsub("%.tex$", ".pdf")
  end
  
  return nil
end

-- Asynchronously execute the compilation using Neovim's jobstart
local function compile_latex()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" or not file_path:match("%.tex$") then
    return
  end
  
  local root = find_project_root(vim.fn.fnamemodify(file_path, ":p:h"))
  if not root then
    return -- If no Makefile is found, do nothing automatically
  end
  
  local target = resolve_pdf_target(root, file_path)
  if not target then
    vim.notify("No se pudo determinar el PDF destino para: " .. vim.fn.fnamemodify(file_path, ":t"), vim.log.levels.WARN, { title = "LaTeX Build" })
    return
  end
  
  -- Cache target and root for common/ compilations
  last_compiled_pdf = target
  last_project_root = root
  
  -- Terminate active compilation job if it exists to avoid overlapping builds
  if compile_job_id then
    vim.fn.jobstop(compile_job_id)
    compile_job_id = nil
  end
  
  vim.notify("Compilando " .. target .. "...", vim.log.levels.INFO, { title = "LaTeX Build" })
  
  local output = {}
  
  compile_job_id = vim.fn.jobstart({ "make", target }, {
    cwd = root,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(output, line) end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(output, line) end
        end
      end
    end,
    on_exit = function(job_id, exit_code)
      -- Ignore callbacks from canceled/older jobs
      if job_id ~= compile_job_id then
        return
      end
      compile_job_id = nil
      if exit_code == 0 then
        vim.notify("¡Compilación exitosa!\n" .. target, vim.log.levels.INFO, { title = "LaTeX Build" })
      else
        vim.notify("Fallo en la compilación de:\n" .. target, vim.log.levels.ERROR, { title = "LaTeX Build" })
        
        -- Load build stdout/stderr into the quickfix list and display it
        local qf_list = {}
        for _, line in ipairs(output) do
          table.insert(qf_list, { text = line })
        end
        vim.fn.setqflist(qf_list, "r")
        vim.cmd("copen")
      end
    end
  })
end

-- Launch Okular asynchronously in a detached process
local function open_pdf_in_okular()
  local file_path = vim.api.nvim_buf_get_name(0)
  if file_path == "" then return end
  
  local root = find_project_root(vim.fn.fnamemodify(file_path, ":p:h"))
  root = root or last_project_root
  
  if not root then
    vim.notify("No se encontró la raíz del proyecto (Makefile).", vim.log.levels.WARN, { title = "LaTeX View" })
    return
  end
  
  local target = resolve_pdf_target(root, file_path)
  target = target or last_compiled_pdf
  
  if not target then
    vim.notify("No se pudo determinar el PDF a abrir.", vim.log.levels.WARN, { title = "LaTeX View" })
    return
  end
  
  local pdf_full_path = root .. "/" .. target
  if vim.fn.filereadable(pdf_full_path) == 0 then
    vim.notify("El archivo PDF aún no existe: " .. target .. "\nPor favor, compila primero.", vim.log.levels.WARN, { title = "LaTeX View" })
    return
  end
  
  vim.notify("Abriendo " .. target .. " en Okular...", vim.log.levels.INFO, { title = "LaTeX View" })
  vim.fn.jobstart({ "okular", pdf_full_path }, { detach = true })
end

local function insert_figure_skeleton()
  local skeleton = {
    "\\begin{figure}[htbp]",
    "    \\centering",
    "    \\includegraphics[width=0.85\\linewidth]{}",
    "    \\caption{}",
    "    \\label{fig:}",
    "\\end{figure}",
  }
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, skeleton)
  vim.api.nvim_win_set_cursor(0, { row + 3, 43 }) -- Place cursor inside \includegraphics{}
end

M.init = function()
  -- Disable VimTeX's native compiler and set viewer method
  vim.g.vimtex_compiler_enabled = 0
  vim.g.vimtex_view_method = "general"
  vim.g.vimtex_view_general_viewer = "okular"
  vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
  
  local group = vim.api.nvim_create_augroup("LaTeXAutoCompile", { clear = true })
  
  -- Trigger compile on save
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = group,
    pattern = "*.tex",
    callback = function()
      compile_latex()
    end,
  })
  
  -- Register commands
  vim.api.nvim_create_user_command("VimtexMakeCompile", compile_latex, {})
  vim.api.nvim_create_user_command("VimtexMakeView", open_pdf_in_okular, {})
  
  -- Local keymaps for TeX buffers
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "tex",
    callback = function(ev)
      -- <localleader>ll to compile manually
      vim.keymap.set("n", "<localleader>ll", compile_latex, { buffer = ev.buf, silent = true, desc = "LaTeX: Compilar PDF" })
      -- <localleader>lv to view PDF in Okular
      vim.keymap.set("n", "<localleader>lv", open_pdf_in_okular, { buffer = ev.buf, silent = true, desc = "LaTeX: Ver PDF en Okular" })
      -- <localleader>if to insert figure skeleton
      vim.keymap.set("n", "<localleader>if", insert_figure_skeleton, { buffer = ev.buf, silent = true, desc = "LaTeX: Insertar entorno figure" })
    end,
  })
end

return M
