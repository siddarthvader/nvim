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
				"ts_ls", -- TypeScript language server
				"tailwindcss", -- Tailwind CSS language server
				"cssls", -- CSS language server
				"html", -- HTML language server
				"pyright", -- Python type checker
				"ruff", -- Python linter
				"gopls", -- Go language server
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
				vim.keymap.set("n", "<leader>d", function()
					vim.diagnostic.open_float({ border = "rounded", focus = false })
				end, { buffer = bufnr, desc = "Show diagnostics at cursor" })
				vim.keymap.set("n", "<leader>r", function()
					vim.cmd("LspRestart")
					vim.notify("LSP servers restarted", vim.log.levels.INFO)
				end, { buffer = bufnr, desc = "Restart LSP server" })
			end

			-- TypeScript setup
			lspconfig.ts_ls.setup({
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
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = false,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "literals",
							includeInlayVariableTypeHints = false,
							includeInlayPropertyDeclarationTypeHints = false,
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
}
