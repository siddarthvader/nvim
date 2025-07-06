# Neovim LSP and Linting Configuration Guide

This guide explains how the LSP (Language Server Protocol) and linting/formatting are configured in this Neovim setup, with special focus on OCaml and TypeScript implementations.

## Overview

This configuration uses:
- **nvim-lspconfig** for LSP server configuration
- **Mason** for LSP server installation and management
- **conform.nvim** for code formatting
- **nvim-cmp** for autocompletion with LSP integration

## Core Architecture

### 1. LSP Configuration Structure (`lua/plugins/lsp.lua`)

The LSP setup follows a modular pattern:

```lua
local servers = {
  servername = {
    settings = { ... },      -- Server-specific settings
    on_attach = function,    -- Custom attach function
    cmd = { ... },          -- Custom command
    manual_install = true,   -- Skip Mason auto-install
  }
}
```

### 2. Key Components

#### Mason Integration
- Automatically installs LSP servers and formatters
- Manually installed servers are excluded from auto-installation
- Updates tools automatically with debouncing

#### Capabilities Enhancement
```lua
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
```

#### On Attach Function
- Maps LSP keybindings when server attaches to buffer
- Custom per-server attach functions can be defined

## TypeScript Configuration

### LSP Server: vtsls (TypeScript Language Server)

#### Key Features:
1. **TwoSlash Queries** - Interactive type information comments
2. **Inlay Hints** - Inline type annotations
3. **High Memory Allocation** - 12GB for large projects
4. **Fuzzy Completion** - Server-side fuzzy matching

#### Configuration:
```lua
vtsls = {
  on_attach = function(client, buffer_number)
    require("twoslash-queries").attach(client, buffer_number)
    return on_attach(client, buffer_number)
  end,
  settings = {
    complete_function_calls = true,
    vtsls = {
      autoUseWorkspaceTsdk = true,  -- Use project's TypeScript version
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportOnFileMove = { enabled = "always" },
      suggest = { completeFunctionCalls = true },
      tsserver = { maxTsServerMemory = 12288 },  -- 12GB memory limit
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        functionParameterTypes = { enabled = true },
        parameterNames = { enabled = "all" },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
  },
}
```

### Additional TypeScript Tools:

1. **tsc.nvim** - TypeScript compiler integration
   - Runs tsc in the background
   - Opens quickfix list with errors
   - Lazy loaded for TypeScript files

2. **ESLint** (optional, disabled by default)
   - Configured with high memory limit
   - Can be enabled per project

### Formatting:
- Uses **Biome** for TypeScript/JavaScript formatting
- Configured in `conform.nvim` with fallback to LSP formatting
- Formats on save with 500ms timeout

## OCaml Configuration

### LSP Server: ocamllsp

#### Key Features:
1. **Manual Installation** - Not managed by Mason
2. **Dune Integration** - Runs through dune build system
3. **Code Lens** - Inline type information
4. **Inlay Hints** - Type annotations
5. **Syntax Documentation** - Enhanced documentation

#### Configuration:
```lua
ocamllsp = {
  manual_install = true,  -- Managed by opam, not Mason
  cmd = { "dune", "exec", "ocamllsp" },  -- Run through dune
  settings = {
    codelens = { enable = true },
    inlayHints = { enable = true },
    syntaxDocumentation = { enable = true },
  },
}
```

### OCaml Extensions (`lua/dmmulroy/ocaml_extensions.lua`)

Registers multiple OCaml file types:
- `.mli` → `ocaml.interface`
- `.mly` → `ocaml.menhir` (parser generator)
- `.mll` → `ocaml.ocamllex` (lexer generator)
- `.mlx` → `ocaml` (OCaml with JSX)
- `.t` → `ocaml.cram` (test files)

### Treesitter Integration
Maps file types to appropriate parsers:
```lua
vim.treesitter.language.register("ocaml_interface", "ocaml.interface")
vim.treesitter.language.register("menhir", "ocaml.menhir")
vim.treesitter.language.register("cram", "ocaml.cram")
vim.treesitter.language.register("ocamllex", "ocaml.ocamllex")
```

### OCaml Formatting:
- No formatter configured in conform.nvim
- Falls back to LSP formatting (ocamlformat via ocamllsp)

## Implementation Guide for New Setup

### 1. Install Required Plugins

```lua
-- In your lazy.nvim setup
{
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",  -- For capabilities
  }
},
{
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
}
```

### 2. Basic LSP Setup Structure

```lua
-- Define your servers
local servers = {
  -- TypeScript
  vtsls = {
    settings = { 
      typescript = {
        inlayHints = { /* ... */ },
        tsserver = { maxTsServerMemory = 12288 },
      }
    }
  },
  
  -- OCaml
  ocamllsp = {
    manual_install = true,
    cmd = { "dune", "exec", "ocamllsp" },
    settings = {
      codelens = { enable = true },
      inlayHints = { enable = true },
    }
  }
}

-- Setup capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

-- Setup each server
for name, config in pairs(servers) do
  require("lspconfig")[name].setup({
    capabilities = capabilities,
    settings = config.settings,
    cmd = config.cmd,
    on_attach = your_on_attach_function,
  })
end
```

### 3. Formatting Setup

```lua
require("conform").setup({
  format_after_save = {
    async = true,
    timeout_ms = 500,
    lsp_format = "fallback",  -- Use LSP if no formatter configured
  },
  formatters_by_ft = {
    javascript = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    -- OCaml uses LSP formatting
  },
})
```

### 4. OCaml-Specific Setup

```lua
-- Register OCaml file extensions
vim.filetype.add({
  extension = {
    mli = "ocaml.interface",
    mly = "ocaml.menhir",
    mll = "ocaml.ocamllex",
    mlx = "ocaml",
    t = "ocaml.cram",
  },
})

-- Register Treesitter parsers
vim.treesitter.language.register("ocaml_interface", "ocaml.interface")
-- ... etc
```

### 5. Key Bindings (from keymaps.lua)

Essential LSP keybindings to implement:
- `gd` - Go to definition
- `gD` - Go to declaration
- `gr` - Find references
- `K` - Hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `<leader>f` - Format buffer

## Tips for Implementation

1. **Memory Management**: Both TypeScript and OCaml LSPs can be memory-intensive. Configure appropriate limits.

2. **Manual Installation**: For OCaml, ensure ocamllsp is installed via opam:
   ```bash
   opam install ocaml-lsp-server
   ```

3. **Project Detection**: Use root pattern detection for monorepos:
   ```lua
   root_dir = require("lspconfig.util").root_pattern("dune-project", "*.opam")
   ```

4. **Conditional Loading**: Use filetype-based lazy loading for language-specific plugins.

5. **Fallback Formatting**: Always configure LSP as a fallback formatter for languages without dedicated formatters.

## Troubleshooting

- **TypeScript**: If vtsls runs out of memory, increase `maxTsServerMemory`
- **OCaml**: Ensure dune is in PATH and project has proper dune configuration
- **Formatting**: Check `:ConformInfo` to see active formatters
- **LSP Status**: Use `:LspInfo` to verify server attachment

This configuration provides a robust foundation for TypeScript and OCaml development with intelligent code completion, real-time diagnostics, and automatic formatting.

