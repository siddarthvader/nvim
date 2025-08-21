# Neovim Keymap README

This README provides a comprehensive list of custom keymaps defined in your Neovim configuration. These keymaps are designed to enhance your productivity and streamline your workflow in Neovim.

## General Keymaps

- `<Space>`: Leader key

### AI Assistant (Avante)

- `<C-a>`: Submit text to Avante AI assistant (in insert mode)
- `<leader>aa`: Show sidebar
- `<leader>at`: Toggle sidebar visibility
- `<leader>ar`: Refresh sidebar
- `<leader>af`: Switch sidebar focus
- `<leader>a?`: Select model
- `<leader>ae`: Edit selected blocks
- `co`: Choose ours (conflict resolution)
- `ct`: Choose theirs (conflict resolution)
- `ca`: Choose all theirs (conflict resolution)
- `c0`: Choose none (conflict resolution)
- `cb`: Choose both (conflict resolution)
- `cc`: Choose cursor (conflict resolution)
- `]x`: Move to previous conflict
- `[x`: Move to next conflict
- `[[`: Jump to previous codeblocks (results window)
- `]]`: Jump to next codeblocks (results windows)

### File Operations

- `<leader>s`: Save file (files are also auto-saved on InsertLeave and TextChanged)
- `<leader>ff`: Format file or visual-mode range (with LSP fallback)
- `<leader>cR`: Rename current file
- `<leader>bd`: Delete buffer

### Window Navigation

- `<C-k>`: Move to the window above
- `<C-j>`: Move to the window below
- `<C-h>`: Move to the window on the left
- `<C-l>`: Move to the window on the right

### Yanky Plugin Keymaps

- `p`: Put (paste) after cursor (normal and visual mode)
- `P`: Put (paste) before cursor (normal and visual mode)
- `gp`: Put (paste) after cursor and leave cursor after new text (normal and visual mode)
- `gP`: Put (paste) before cursor and leave cursor after new text (normal and visual mode)
- `<C-p>`: Cycle to previous yanked text
- `<C-n>`: Cycle to next yanked text

### Terminal Mode Keymaps

- `<Esc>` or `jk`: Exit terminal mode
- `<C-h>`: Move to the window on the left
- `<C-j>`: Move to the window below
- `<C-k>`: Move to the window above
- `<C-l>`: Move to the window on the right
- `<C-w>`: Enter window command mode
- `<C-/>` or `<C-_>`: Toggle terminal

### Neo-tree Keymaps

- `<leader>e`: Open file explorer
- `<leader>m`: Close Neo-tree

### Search and Navigation (snacks.nvim)

#### Quick Access
- `<leader><space>`: Smart find files
- `<leader>/`: Quick grep search
- `<leader>,`: Browse buffers
- `<leader>:`: Command history

#### File Finding
- `<leader>fb`: Browse buffers
- `<leader>fc`: Find config file
- `<leader>fg`: Find git files
- `<leader>fp`: Browse projects
- `<leader>fr`: Recent files

#### Search Operations
- `<leader>sg`: Grep search in project
- `<leader>sw`: Search word under cursor/visual selection
- `<leader>sb`: Search in buffer lines
- `<leader>sB`: Grep in open buffers
- `<leader>s/`: Search history
- `<leader>sd`: Search diagnostics
- `<leader>sD`: Search buffer diagnostics
- `<leader>sh`: Search help pages
- `<leader>sk`: Search keymaps
- `<leader>ss`: Search LSP symbols
- `<leader>sS`: Search LSP workspace symbols
- `<leader>sf`: Find functions/methods only (via Telescope)
- `<leader>sF`: Find workspace functions/methods only (via Telescope)

#### Git Operations
- `<leader>gl`: Git log
- `<leader>gL`: Git log for current line
- `<leader>gs`: Git status
- `<leader>gd`: Git diff (hunks)
- `<leader>gf`: Git log for current file
- `<leader>gb`: Git blame line
- `<leader>gg`: Open Lazygit
- `<leader>gB`: Git browse (normal and visual mode)

### In-File Search

#### Quick Search
- `/`: Search forward in file (type search term and press Enter)
- `?`: Search backward in file (type search term and press Enter)
- `n`: Go to next match
- `N`: Go to previous match
- `<ESC>` or `:noh`: Clear search highlighting

#### Buffer Search (snacks.nvim)
- `<leader>sb`: Search lines in current buffer
- `<leader>sw`: Search for word under cursor or visual selection
- `<leader>sB`: Grep search in open buffers
- `<leader>s/`: View search history

### LSP Keymaps

- `K`: Hover information
- `<leader>d`: Show diagnostics at cursor
- `gd`: Go to definition
- `gD`: Go to declaration
- `gi`: Go to implementation  
- `go`: Go to type definition
- `gr`: Go to references
- `gs`: Show signature help
- `<leader>ca`: Code actions
- `<leader>rn`: Rename symbol
- `<leader>f`: Format buffer (async)
- `[d`: Go to previous diagnostic
- `]d`: Go to next diagnostic
- `<leader>rs`: Restart LSP servers

### Toggle Options

- `<leader>us`: Toggle spelling
- `<leader>uw`: Toggle word wrap
- `<leader>uL`: Toggle relative line numbers
- `<leader>ud`: Toggle diagnostics
- `<leader>ul`: Toggle line numbers
- `<leader>uc`: Toggle conceallevel
- `<leader>uT`: Toggle treesitter
- `<leader>ub`: Toggle dark/light background
- `<leader>uh`: Toggle inlay hints
- `<leader>ug`: Toggle indent guides
- `<leader>uD`: Toggle dim

### Editor Settings

- Line numbers are enabled (both absolute and relative)
- Tab width is set to 2 spaces
- System clipboard is used by default
- Files with `.templ` extension are automatically formatted on save
- Auto-format on save is enabled for all supported filetypes (500ms timeout)
- Format falls back to LSP if no formatter is configured

## LSP Configuration Pattern

The LSP configuration uses a modular pattern where each server is defined in a table:

```lua
local servers = {
  servername = {
    settings = { ... },      -- Server-specific settings
    filetypes = { ... },     -- Custom filetypes
    root_dir = ...,          -- Custom root directory pattern
    cmd = { ... },           -- Custom command
  }
}
```

### Configured Language Servers

- **TypeScript/JavaScript** (`vtsls`): Enhanced inlay hints, 12GB memory limit, fuzzy matching
- **Python** (`pyright` + `ruff`): Type checking and linting with 88-char line length
- **Go** (`gopls`): Static analysis, gofumpt formatting, unused parameter detection
- **Lua** (`lua_ls`): Neovim API support
- **OCaml** (`ocamllsp`): Codelens, inlay hints, syntax documentation
- **Web** (`html`, `cssls`, `tailwindcss`, `svelte`): Full web development support
- **Other** (`jsonls`): JSON schema support

### Formatters (via conform.nvim)

- **TypeScript/JavaScript**: `biome` (primary), `prettierd` (fallback)
- **Python**: `ruff_format`
- **Go**: `gofmt`
- **Lua**: `stylua`
- **OCaml**: `ocamlformat`
- **C/C++**: `clang-format` with custom style
- **Shell**: `beautysh`
- **Nix**: `alejandra`
- **SQL**: `sql_formatter`

## Notes

- The clipboard is set to use the system clipboard (`unnamed`).
- File format is automatically set for `.templ` files.
- Some keymaps may depend on specific plugins (e.g., snacks.nvim) being installed and configured.
- LSP servers are automatically installed via Mason (except OCaml which uses opam).
- Formatters and linters are managed by mason-tool-installer with automatic updates.

Remember that you can always check your current keymaps in Neovim by using the `:map` command. As you become more familiar with Neovim, you may want to modify or add new keymaps to suit your workflow.
