return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ensure_installed = {
        -- Formatters and linters
        "prettier",
        "prettierd",
        "stylua",
        "ocamlformat",
        "beautysh",
        "clang-format",
        "sql_formatter",
        "alejandra",
        "fish_indent",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = false, -- Disable auto-install to prevent unwanted LSPs
      ensure_installed = {
        -- Language Servers only (formatters go in mason.nvim)
        "tsgo", -- TypeScript/JavaScript
        "biome", -- Biome LSP (diagnostics + code actions)
        "svelte", -- Svelte
        "html", -- HTML
        "cssls", -- CSS
        "tailwindcss", -- Tailwind CSS
        "jsonls", -- JSON
        "pyright", -- Python type checker
        "ruff", -- Python linter
        "gopls", -- Go
        "lua_ls", -- Lua
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    lazy = false,
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "biome",
          "prettier",
          "prettierd",
          "stylua",
          "beautysh",
          "clang-format",
          "sql-formatter",
          "alejandra",
          -- Linters
            "golangci-lint",
        },
        auto_update = true,
        run_on_start = true,
        start_delay = 3000,
        debounce_hours = 5,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      -- Enhanced LSP capabilities for autocompletion
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")


      -- Server configurations in modular pattern
      local servers = {
        tsgo = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
          },
          root_dir = lspconfig.util.root_pattern(
            "tsconfig.json",
            "jsconfig.json",
            ".git",
            "pnpm-workspace.yaml",
            "pnpm-lock.yaml",
            "yarn.lock",
            "package-lock.json",
            "bun.lock",
            "bun.lockb"
          ),
          settings = {
            typescript = {
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
        },
        biome = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "typescript",
            "typescriptreact",
            "json",
            "jsonc",
            "css",
            "html",
          },
        },
        html = {},
        tailwindcss = {
          filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "css" },
          settings = {
            tailwindCSS = {
              includeLanguages = {
                svelte = "html",
              },
            },
          },
        },
        svelte = {
          settings = {
            svelte = {
              plugin = {
                typescript = {
                  diagnostics = { enable = true },
                  hover = { enable = true },
                  completions = { enable = true },
                  codeActions = { enable = true },
                  selectionRange = { enable = true },
                },
              },
            },
          },
        },
        cssls = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
        ruff = {
          init_options = {
            settings = {
              args = {
                "--line-length=88",
              },
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
                shadow = true,
                nilness = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,
              gofumpt = true,
              usePlaceholders = true,
              completeUnimported = true,
            },
          },
        },
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
              },
            },
          },
        },
        ocamllsp = {
          cmd = { "ocamllsp" },
          filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason" },
          root_dir = lspconfig.util.root_pattern("*.opam", "dune-project", "dune-workspace", ".git"),
          settings = {
            codelens = { enable = true },
            inlayHints = { enable = true },
            syntaxDocumentation = { enable = true },
          },
        },
      }

      -- Simplified on_attach function
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Set up hover with rounded borders
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = "rounded",
          max_width = 80,
          max_height = 30,
        })

        -- Key mappings
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, silent = true })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Go to declaration" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })
        vim.keymap.set(
          "n",
          "go",
          vim.lsp.buf.type_definition,
          { buffer = bufnr, desc = "Go to type definition" }
        )
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
        vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Show signature help" })
        vim.keymap.set("n", "<leader>d", function()
          vim.diagnostic.open_float({ border = "rounded", focus = false })
        end, { buffer = bufnr, desc = "Show diagnostics at cursor" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = bufnr, desc = "Code actions" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true })
        end, { buffer = bufnr, desc = "Format buffer" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { buffer = bufnr, desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { buffer = bufnr, desc = "Next diagnostic" })
        vim.keymap.set("n", "<leader>rs", function()
          vim.lsp.stop_client(vim.lsp.get_active_clients())
          vim.cmd("edit")
          vim.notify("LSP servers restarted", vim.log.levels.INFO)
        end, { buffer = bufnr, desc = "Restart LSP server" })
      end

      -- Setup all servers with their configurations
      for name, config in pairs(servers) do
        -- Skip ESLint LSP - using nvim-lint instead
        if name ~= "eslint" then
          config.capabilities = capabilities

          local base_on_attach = config.on_attach or on_attach
          if name == "tsgo" then
            config.on_attach = function(client, bufnr)
              client.server_capabilities.documentFormattingProvider = false
              base_on_attach(client, bufnr)
            end
          else
            config.on_attach = base_on_attach
          end

          lspconfig[name].setup(config)
        end
      end

      if not configs.houdini_lsp then
        configs.houdini_lsp = {
          default_config = {
            cmd = { "houdini-lsp" },
            filetypes = { "svelte", "graphql", "javascript", "javascriptreact", "typescript", "typescriptreact" },
            root_dir = lspconfig.util.root_pattern("houdini.config.js", "package.json", ".git"),
          },
        }
      end

      if vim.fn.executable("houdini-lsp") == 1 then
        lspconfig.houdini_lsp.setup({
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end

      -- Global key mappings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

      -- Diagnostic configuration
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false, -- Don't update in insert mode
        severity_sort = true,
        float = {
          border = "rounded",
          source = "always",
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      local cmp_select = { behavior = cmp.SelectBehavior.Select }

      -- Set up autocomplete
      cmp.setup({
        sources = {
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   keyword_length = 3, priority = 500 },
          { name = "path",     priority = 250 },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
          ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect",
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        -- This automatically selects the first item when completion menu opens
        view = {
          entries = {
            name = "custom",
            selection_order = "near_cursor",
          },
        },
        window = {
          completion = {
            border = "rounded",
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
          },
          documentation = {
            border = "rounded",
          },
        },
        experimental = {
          ghost_text = false,
        },
      })

      -- Select (highlight) the first item when completion shows, but don't insert it
      cmp.event:on("menu_opened", function()
        vim.schedule(function()
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        end)
      end)
    end,
  },
}
