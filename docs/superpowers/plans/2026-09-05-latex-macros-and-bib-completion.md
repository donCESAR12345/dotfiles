# LaTeX Macros and Bibliography (.bib) Completion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Provide ergonomic snippets for LaTeX figure and environment insertion and enable full bibliography (.bib) and label autocompletion and LSP navigation in Neovim.

**Architecture:** LuaSnip lua loader loads custom semantic snippets from `snippets/tex.lua`. `micangl/cmp-vimtex` provides native, fuzzy completion for `\cite{...}` and `\ref{...}` via VimTeX's parser. `texlab` LSP provides code navigation (`gd`, `K`) and diagnostics without interfering with the custom Make/Okular compilation flow. VimTeX buffer mappings provide normal-mode quick insertion.

**Tech Stack:** Neovim (Lua), LuaSnip, nvim-cmp, cmp-vimtex, VimTeX, nvim-lspconfig, Mason, TexLab.

---

### Task 1: LuaSnip LaTeX Snippets and Loader

**Files:**
- Create: `nvim/.config/nvim/snippets/tex.lua`
- Modify: `nvim/.config/nvim/lua/plugins/completion.lua`

- [ ] **Step 1: Create custom LuaSnip snippets for LaTeX**

Create `nvim/.config/nvim/snippets/tex.lua` with snippets for `fig` (standard figure), `figh` (figure with [H]), `subfig` (two subfigures side-by-side), `tab` (table with tabular), `eq` (numbered equation), and `al` (align):

```lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
	-- Standard floating figure [htbp]
	s(
		{ trig = "fig", name = "Figure (htbp)", dscr = "Standard floating figure with centering, graphic, caption, label" },
		fmt(
			[[
\begin{figure}[<>]
    \centering
    \includegraphics[width=<>]{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}
<>
]],
			{
				i(1, "htbp"),
				i(2, "0.85\\linewidth"),
				i(3, "path/to/image"),
				i(4, "Caption text"),
				i(5, "label"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Fixed figure [H] (float package)
	s(
		{ trig = "figh", name = "Figure [H]", dscr = "Fixed figure [H] with centering, graphic, caption, label" },
		fmt(
			[[
\begin{figure}[H]
    \centering
    \includegraphics[width=<>]{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}
<>
]],
			{
				i(1, "0.85\\linewidth"),
				i(2, "path/to/image"),
				i(3, "Caption text"),
				i(4, "label"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Two subfigures side-by-side
	s(
		{ trig = "subfig", name = "Subfigures (2)", dscr = "Figure with two side-by-side subfigures" },
		fmt(
			[[
\begin{figure}[<>]
    \centering
    \begin{subfigure}{<>}
        \centering
        \includegraphics[width=\linewidth]{<>}
        \caption{<>}
        \label{subfig:<>}
    \end{subfigure}
    \hfill
    \begin{subfigure}{<>}
        \centering
        \includegraphics[width=\linewidth]{<>}
        \caption{<>}
        \label{subfig:<>}
    \end{subfigure}
    \caption{<>}
    \label{fig:<>}
\end{figure}
<>
]],
			{
				i(1, "H"),
				i(2, "0.48\\linewidth"),
				i(3, "image1"),
				i(4, "Caption 1"),
				i(5, "sub1"),
				i(6, "0.48\\linewidth"),
				i(7, "image2"),
				i(8, "Caption 2"),
				i(9, "sub2"),
				i(10, "Main figure caption"),
				i(11, "main"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Table environment
	s(
		{ trig = "tab", name = "Table", dscr = "Table environment with caption, label, and tabular" },
		fmt(
			[[
\begin{table}[<>]
    \centering
    \caption{<>}
    \label{tab:<>}
    \begin{tabular}{<>}
        \toprule
        <> \\
        \midrule
        <> \\
        \bottomrule
    \end{tabular}
\end{table}
<>
]],
			{
				i(1, "htbp"),
				i(2, "Table caption"),
				i(3, "label"),
				i(4, "cc"),
				i(5, "Header 1 & Header 2"),
				i(6, "Cell 1 & Cell 2"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Numbered equation
	s(
		{ trig = "eq", name = "Equation", dscr = "Numbered equation with label" },
		fmt(
			[[
\begin{equation}
    <>
    \label{eq:<>}
\end{equation}
<>
]],
			{
				i(1, "E = mc^2"),
				i(2, "label"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),

	-- Align environment
	s(
		{ trig = "al", name = "Align", dscr = "Align multiline math environment" },
		fmt(
			[[
\begin{align}
    <>
\end{align}
<>
]],
			{
				i(1, "x &= y + z"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),
}
```

- [ ] **Step 2: Enable LuaSnip Lua loader in completion.lua**

In `nvim/.config/nvim/lua/plugins/completion.lua`, update the LuaSnip config to call `require("luasnip.loaders.from_lua").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })`.

- [ ] **Step 3: Verify LuaSnip loads snippets without errors**

Run: `nvim --headless -c "lua require('luasnip.loaders.from_lua').lazy_load({ paths = { vim.fn.stdpath('config') .. '/snippets' } }); local snips = require('luasnip').get_snippets('tex'); assert(#snips >= 6, 'Expected at least 6 tex snippets'); print('LOADED ' .. #snips .. ' SNIPPETS')" -c "qa"`
Expected: Output containing `LOADED 6 SNIPPETS` without error.

- [ ] **Step 4: Commit Task 1 changes**

```bash
git add nvim/.config/nvim/snippets/tex.lua nvim/.config/nvim/lua/plugins/completion.lua
git commit -m "feat(nvim): add LaTeX LuaSnip snippets and configure Lua loader"
```

---

### Task 2: cmp-vimtex Integration in nvim-cmp

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/completion.lua`

- [ ] **Step 1: Add micangl/cmp-vimtex plugin spec**

In `nvim/.config/nvim/lua/plugins/completion.lua`, add `micangl/cmp-vimtex` to the plugins list:
```lua
	{
		"micangl/cmp-vimtex",
		ft = { "tex", "plaintex", "bib" },
	},
```

- [ ] **Step 2: Add vimtex source and label to nvim-cmp configuration**

In `nvim/.config/nvim/lua/plugins/completion.lua`:
- Add `vimtex = "[TeX]"` to `source_labels`.
- Add `Vimtex = "󰈙"` or appropriate icon to `kind_icons` if desired.
- Add `{ name = "vimtex" }` to `sources` in `cmp.setup`:
```lua
				sources = cmp.config.sources({
					{ name = "vimtex" },
					{ name = "codeium" }, -- AI suggestions first
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{ name = "buffer" }, -- Fallback: words in current buffer
				}),
```

- [ ] **Step 3: Sync Lazy plugins headless to install cmp-vimtex**

Run: `nvim --headless "+Lazy! sync" +qa`
Expected: Lazy downloads and installs `cmp-vimtex`.

- [ ] **Step 4: Verify cmp-vimtex source registration in headless Neovim**

Run: `nvim --headless -c "lua local cmp = require('cmp'); print('CMP OK')" -c "qa"`
Expected: Output `CMP OK` without errors.

- [ ] **Step 5: Commit Task 2 changes**

```bash
git add nvim/.config/nvim/lua/plugins/completion.lua nvim/.config/nvim/lazy-lock.json
git commit -m "feat(nvim): add cmp-vimtex source for LaTeX citation and label completion"
```

---

### Task 3: TexLab LSP Configuration

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/lsp-config.lua`

- [ ] **Step 1: Add texlab to servers list with custom configuration**

In `nvim/.config/nvim/lua/plugins/lsp-config.lua`:
- Add `"texlab"` to the `servers` table.
- Configure `texlab` with `build.onSave = false` so it does not conflict with the custom Make/Okular compilation workflow in `vimtex.lua`:
```lua
			for _, server in ipairs(servers) do
				if server == "lua_ls" then
					local specific_config = require("lsp-config.lua_ls").config()
					vim.lsp.config(server, specific_config)
				elseif server == "texlab" then
					local texlab_config = vim.tbl_deep_extend("force", default_config, {
						settings = {
							texlab = {
								build = {
									onSave = false,
								},
							},
						},
					})
					vim.lsp.config(server, texlab_config)
				else
					vim.lsp.config(server, default_config)
				end
				vim.lsp.enable(server)
			end
```

- [ ] **Step 2: Verify Mason and LSP config load cleanly**

Run: `nvim --headless -c "lua vim.lsp.enable('texlab'); print('TEXLAB LSP CONFIGURED')" -c "qa"`
Expected: Output `TEXLAB LSP CONFIGURED` with exit code 0.

- [ ] **Step 3: Commit Task 3 changes**

```bash
git add nvim/.config/nvim/lua/plugins/lsp-config.lua
git commit -m "feat(nvim): configure texlab LSP server with custom onSave build disabled"
```

---

### Task 4: VimTeX Normal Mode Figure Shortcut

**Files:**
- Modify: `nvim/.config/nvim/lua/plugins/vimtex.lua`

- [ ] **Step 1: Add normal mode <localleader>if helper to insert a figure skeleton**

In `nvim/.config/nvim/lua/plugins/vimtex.lua`, inside the `FileType` autocommand callback (around line 189):
Add `<localleader>if` keymap:
```lua
      -- <localleader>if to insert figure skeleton
      vim.keymap.set("n", "<localleader>if", function()
        local skeleton = {
          "\\begin{figure}[htbp]",
          "    \\centering",
          "    \\includegraphics[width=0.85\\linewidth]{}",
          "    \\caption{}",
          "    \\label{fig:}",
          "\\end{figure}",
        }
        local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
        vim.api.nvim_buf_set_lines(0, row, row, false, skeleton)
        vim.api.nvim_win_set_cursor(0, { row + 3, 29 }) -- Place cursor inside \includegraphics{}
      end, { buffer = ev.buf, silent = true, desc = "LaTeX: Insertar entorno figure" })
```

- [ ] **Step 2: Verify VimTeX loads without error**

Run: `nvim --headless -c "edit test.tex" -c "lua assert(vim.g.vimtex_compiler_enabled == 0); print('VIMTEX OK')" -c "qa"`
Expected: Output `VIMTEX OK` with exit code 0.

- [ ] **Step 3: Commit Task 4 changes**

```bash
git add nvim/.config/nvim/lua/plugins/vimtex.lua
git commit -m "feat(nvim): add normal mode <localleader>if keymap for figure insertion"
```

---

### Task 5: End-to-End Functional Verification

**Files:**
- Test scratch files in `/tmp/latex_test/`

- [ ] **Step 1: Create a test LaTeX project with a .bib file**

Create `/tmp/latex_test/refs.bib` with sample entries:
```bibtex
@article{keiser2015,
  author = {Keiser, Gerd},
  title = {Optical Fiber Communications},
  year = {2015}
}
```
Create `/tmp/latex_test/main.tex` with `\bibliography{refs}`.

- [ ] **Step 2: Verify snippet expansion and cmp-vimtex / texlab attachment**

Run headless verification checking that:
1. `luasnip` expands `fig` correctly.
2. VimTeX detects the buffer and `.bib` file.
3. Clean up `/tmp/latex_test/`.

- [ ] **Step 3: Final git commit and status check**

Run: `git status` to ensure working tree is clean.
