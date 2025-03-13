return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
			ensure_installed = {
				"eslint", -- JavaScript linter
				"svelte", -- Svelte language server
				"tailwindcss", -- Tailwind CSS language server
				"cssls", -- CSS language server
				"html", -- HTML language server
				"pyright", -- Python type checker
				"ruff", -- Python linter
				"gopls", -- Go language server
				"vtsls", -- TypeScript language server (replacing ts_ls)
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- Basic LSP capabilities for autocompletion
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

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
				vim.keymap.set("n", "go", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Go to type definition" })
				vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
				vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Show signature help" })
				vim.keymap.set("n", "<leader>d", function()
					vim.diagnostic.open_float({ border = "rounded", focus = false })
				end, { buffer = bufnr, desc = "Show diagnostics at cursor" })
				vim.keymap.set("n", "<leader>r", function()
					vim.cmd("LspRestart")
					vim.notify("LSP servers restarted", vim.log.levels.INFO)
				end, { buffer = bufnr, desc = "Restart LSP server" })
			end

			-- TypeScript setup (using vtsls instead of ts_ls)
			lspconfig.vtsls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				root_dir = require("lspconfig").util.root_pattern(
					".git",
					"pnpm-workspace.yaml",
					"pnpm-lock.yaml",
					"yarn.lock",
					"package-lock.json",
					"bun.lockb"
				),
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = false,
						},
						tsserver = {
							maxTsServerMemory = 12288,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = false,
						},
					},
					experimental = {
						completion = {
							entriesLimit = 3,
						},
					},
				},
			})

			-- ESLint setup
			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					vim.keymap.set("n", "<leader>el", function()
						vim.cmd("EslintFixAll")
						vim.notify("ESLint ran on current file", vim.log.levels.INFO)
					end, { buffer = bufnr, desc = "Run ESLint on current file" })
				end,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
				settings = {
					workingDirectory = { mode = "auto" },
					run = "onSave", -- Only run on save, not as you type
				},
			})

			-- HTML setup
			lspconfig.html.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Tailwind CSS setup
			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "css" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							svelte = "html",
						},
					},
				},
			})

			-- Svelte setup
			lspconfig.svelte.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- CSS setup
			lspconfig.cssls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Python setup
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
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
			})

			-- Ruff LSP setup (for Python linting)
			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					settings = {
						args = {
							"--line-length=88",
						},
					},
				},
			})

			-- Go setup
			lspconfig.gopls.setup({
				on_attach = on_attach,
				capabilities = capabilities,
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
			})

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
		},
		config = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Insert }
			cmp.setup({
				sources = {
					{ name = "nvim_lsp" },
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<Tab>"] = cmp.mapping.select_next_item({ behaviour = cmp.SelectBehavior.Insert }),
					["<S-Tab>"] = cmp.mapping.select_prev_item({ behaviour = cmp.SelectBehavior.Insert }),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
			})
		end,
	},
}