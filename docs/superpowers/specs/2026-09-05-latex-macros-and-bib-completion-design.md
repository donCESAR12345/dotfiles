# Especificación de Diseño: Macros de LaTeX y Autocompletado de Bibliografía (.bib)

**Fecha:** 2026-09-05  
**Estado:** Aprobado  
**Área:** Neovim / Dotfiles (`nvim/.config/nvim/`)

---

## 1. Contexto y Objetivos

Al trabajar en documentos LaTeX con Neovim, se identificaron dos carencias principales:
1. **Falta de macros/snippets ergonómicos para insertar figuras y estructuras comunes:** La colección `friendly-snippets` solo provee un snippet `figure` rígido con `\begin{center}` (en lugar de `\centering`), sin soporte para `[H]` (paquete `float`) ni entornos comunes como subfiguras (`subfigure`), tablas o ecuaciones.
2. **Ausencia de autocompletado para archivos `.bib` referenciados:** `nvim-cmp` no cuenta con una fuente vinculada al analizador de proyectos de VimTeX ni existe un servidor LSP de LaTeX activo en `nvim-lspconfig`. Por tanto, escribir `\cite{...}` no sugiere las claves bibliográficas ni metadatos (autor, título, año).

### Objetivos:
- Proveer snippets modernos en formato Lua (`LuaSnip`) para insertar figuras (`fig`, `figh`), subfiguras (`subfig`), tablas (`tab`), ecuaciones (`eq`, `al`), etc., con saltos mediante `<Tab>` / `<S-Tab>`.
- Configurar un atajo de teclado en modo normal en buffers TeX (`<localleader>if`) para insertar una plantilla de figura.
- Integrar `micangl/cmp-vimtex` en `nvim-cmp` para autocompletar citas (`\cite{...}`) y etiquetas (`\ref{...}`) aprovechando la caché y resolución de proyectos de VimTeX.
- Configurar `texlab` en `nvim-lspconfig` y Mason para proveer capacidades LSP completas (`gd` para saltar a definiciones en el `.bib`/`\label`, `K` para hover docs) sin interferir con la compilación personalizada (`Makefile` / `Okular`) ya definida en `vimtex.lua`.

---

## 2. Arquitectura y Componentes

### 2.1 Snippets personalizados de LuaSnip (`nvim/.config/nvim/snippets/tex.lua`)
LuaSnip soporta la carga dinámica de snippets definidos en Lua mediante `luasnip.loaders.from_lua`.
Se estructurarán los siguientes snippets con delimitadores `<>` para evitar conflictos con la sintaxis de llaves `{}` de LaTeX:

- `fig`: Entorno `figure` estándar flotante (`[htbp]`), con `\centering`, `\includegraphics[width=...]`, `\caption` y `\label{fig:...}`.
- `figh`: Entorno `figure` con posición fija `[H]` (requiere paquete `float`), alineado a los informes técnicos del usuario.
- `subfig`: Entorno `figure` con dos entornos `subfigure` (`0.48\linewidth`) lado a lado con subcaptions y sublabels individuales, más el caption y label global.
- `tab`: Entorno `table` con `[htbp]`, `\centering`, `\caption`, `\label{tab:...}` y `tabular`.
- `eq`: Entorno `equation` numerado con `\label{eq:...}`.
- `al`: Entorno `align` para deducciones y desarrollos matemáticos multilínea.

### 2.2 Atajos en VimTeX (`nvim/.config/nvim/lua/plugins/vimtex.lua`)
En la configuración local de buffer para `FileType tex`:
- `<localleader>if`: Inserta la estructura básica de figura directamente en la línea actual en modo normal.

### 2.3 Motor de Autocompletado (`nvim/.config/nvim/lua/plugins/completion.lua`)
- **Plugin:** Agregar `micangl/cmp-vimtex` como dependencia / plugin con activación para tipos de archivo `tex`, `plaintex`, `bib`.
- **Fuentes:** Añadir `{ name = "vimtex" }` a la lista de fuentes de `cmp.setup`.
- **Etiquetas e iconos:** Configurar `vimtex = "[TeX]"` en `source_labels` e icono descriptivo en `kind_icons`.
- **Carga de snippets en Lua:** Incorporar en el `config` de `LuaSnip`:
  ```lua
  require("luasnip.loaders.from_lua").lazy_load({
    paths = { vim.fn.stdpath("config") .. "/snippets" },
  })
  ```

### 2.4 Integración LSP con TexLab (`nvim/.config/nvim/lua/plugins/lsp-config.lua`)
- Agregar `"texlab"` a la lista de `servers` para auto-instalación y habilitación mediante `mason-lspconfig` y `nvim-lspconfig`.
- Desactivar la compilación interna de TexLab al guardar para preservar el flujo de trabajo existente:
  ```lua
  settings = {
    texlab = {
      build = {
        onSave = false,
      },
    },
  }
  ```

---

## 3. Plan de Verificación

1. **Verificación de dependencias:**
   - Sincronización de plugins de Neovim con `nvim --headless "+Lazy! sync" +qa`.
   - Comprobación de que `texlab` esté instalado en Mason (`~/.local/share/nvim/mason/bin/texlab`).
2. **Verificación de carga de configuración:**
   - Comprobar inicio sin errores de sintaxis de Neovim ejecutando un comando headless sobre un archivo `.tex`.
3. **Verificación funcional de autocompletado y snippets:**
   - Crear un archivo de prueba con `\addbibresource` o `\bibliography` y validar que LuaSnip cargue los snippets `fig`, `figh`, `subfig`, `tab`, `eq`.
   - Validar que el archivo `.bib` sea indexado y las claves se listen en `nvim-cmp`.
