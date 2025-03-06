# Neovim Configuration Guide

## Commands
- Format current file: `<leader>ff`
- Format selection: `<leader>bf` (in visual mode)
- Auto-format on save is enabled for all supported filetypes
- Python linting: Uses ruff, pyright
- JavaScript/TypeScript linting: Uses ts_ls

## Code Style Guidelines
- **Indentation**: 2 spaces (expandtab enabled)
- **Line Length**: 88 characters for Python (Black/Ruff default)
- **Naming**: Follow Lua conventions with snake_case for variables/functions
- **Imports**: Group by standard library, then plugins, then local modules
- **Error Handling**: Use pcall for potential errors in Lua code
- **Plugin Config**: Each plugin has its own file in `plugins/` directory
- **Comments**: Use -- for single line comments in Lua

## Formatters
- Python: ruff_format, black, isort
- JavaScript/TypeScript: prettierd
- Lua: stylua
- Go: gopls (via LSP)
- HTML/CSS: prettierd
- Shell: beautysh
- SQL: sql_formatter
- Nix: alejandra
- C/C++: clang-format with custom style
# Linting and LSP
- JavaScript/TypeScript: Using tsserver for type checking and eslint for linting
- Go: Using gopls with enhanced static analysis settings and golangci-lint
- Diagnostics are shown on cursor hover (CursorHold)
- null-ls is configured with additional linters
- To manually trigger linting, use the LSP Diagnostic commands
