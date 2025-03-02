# Neovim Keymap README

This README provides a comprehensive list of custom keymaps defined in your Neovim configuration. These keymaps are designed to enhance your productivity and streamline your workflow in Neovim.

## General Keymaps

- `<Space>`: Leader key

### File Operations

- `<leader>s`: Save file (files are also auto-saved on InsertLeave and TextChanged)
- `<leader>ff`: Format file
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
- `gd`: Go to definition
- `gD`: Go to declaration
- `gr`: Go to references
- `gI`: Go to implementation
- `gy`: Go to type definition
- `<leader>ca`: Code action
- `<leader>rn`: Rename

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

Note: Some keybindings may require specific plugins to be installed and configured. The clipboard is set to use the system clipboard (`unnamed`).

Here's the updated Neovim Keymap README with the new GPT-related shortcuts:
markdownCopy# Neovim Keymap README

[Previous sections remain unchanged...]

### GPT Integration Keymaps
#### Chat Commands
- `<leader>cc`: New chat
- `<leader>ct`: Toggle chat window
- `<leader>cf`: Open chat finder
- `<leader>cx`: New chat in horizontal split
- `<leader>cv`: New chat in vertical split
- `<leader>cT`: New chat in new tab

#### Visual Mode GPT Commands
- `<leader>cp`: Paste selection into chat
- `<leader>cr`: Rewrite selected text
- `<leader>ca`: Append after selection
- `<leader>cb`: Prepend before selection

#### Window Controls
- `<leader>gp`: Open in popup
- `<leader>ge`: Open in new buffer
- `<leader>gn`: Open in new window
- `<leader>gv`: Open in vertical split
- `<leader>gt`: Open in new tab

#### Utility Commands
- `<leader>cs`: Stop generation
- `<leader>cn`: Switch to next agent
- `<leader>cx`: Toggle context
## Notes

- The clipboard is set to use the system clipboard (`unnamed`).
- File format is automatically set for `.templ` files.
- Some keymaps may depend on specific plugins (e.g., snacks.nvim) being installed and configured.
- LSP keymaps typically require additional setup with nvim-lspconfig or similar plugins. If these aren't working, you may need to configure them in your Neovim setup.

Remember that you can always check your current keymaps in Neovim by using the `:map` command. As you become more familiar with Neovim, you may want to modify or add new keymaps to suit your workflow.
