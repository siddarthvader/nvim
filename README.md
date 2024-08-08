# Neovim Keymap README

This README provides a comprehensive list of custom keymaps defined in your Neovim configuration. These keymaps are designed to enhance your productivity and streamline your workflow in Neovim.

## General Keymaps

- `<Space>`: Leader key

### File Operations

- `<leader>s`: Save file
- `<leader>f`: Format file

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
- `<C-\>`: Toggle terminal mode
- `<C-h>`: Move to the window on the left
- `<C-j>`: Move to the window below
- `<C-k>`: Move to the window above
- `<C-l>`: Move to the window on the right
- `<C-w>`: Enter window command mode

### Harpoon Keymaps

- `<C-e>`: Toggle Harpoon quick menu
- `<leader>a`: Add current file to Harpoon
- `<C-h>`: Jump to Harpoon file 1
- `<C-t>`: Jump to Harpoon file 2
- `<C-n>`: Jump to Harpoon file 3
- `<C-s>`: Jump to Harpoon file 4
- `<C-S-P>`: Navigate to previous Harpoon file
- `<C-S-N>`: Navigate to next Harpoon file

### Telescope Keymaps

- `<leader>ff`: Find files (including hidden files, excluding .git)

### LSP Keymaps (Common, may require additional setup)

- `gd`: Go to definition
- `gr`: Go to references
- `gi`: Go to implementation
- `gt`: Go to type definition
- `K`: Hover information
- `<leader>rn`: Rename
- `<leader>ca`: Code action
- `[d`: Go to previous diagnostic
- `]d`: Go to next diagnostic
- `<leader>f`: Format code (already listed under File Operations)

## Notes

- The clipboard is set to use the system clipboard (`unnamed`).
- File format is automatically set for `.templ` files.
- Some keymaps may depend on specific plugins (e.g., Harpoon, Telescope) being installed and configured.
- LSP keymaps typically require additional setup with nvim-lspconfig or similar plugins. If these aren't working, you may need to configure them in your Neovim setup.

Remember that you can always check your current keymaps in Neovim by using the `:map` command. As you become more familiar with Neovim, you may want to modify or add new keymaps to suit your workflow.
