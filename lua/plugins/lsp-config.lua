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
				"pyright", -- Python type checker
				"ruff", -- Python linter
				"gopls", -- Go language server
				"eslint", -- JavaScript linter
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			local lspconfig = require("lspconfig")

			-- Define on_attach function to ensure it's available for server configs
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Show diagnostics on hover
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						vim.diagnostic.open_float(nil, { focus = false })
					end,
				})
				
				-- Enhance hover information with more details
				if client.supports_method("textDocument/hover") then
					vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
						vim.lsp.handlers.hover, {
							border = "rounded",
							max_width = 80,
							max_height = 30,
						}
					)
				end
			end

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					typescript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
					javascript = {
						inlayHints = {
							includeInlayParameterNameHints = "all",
							includeInlayParameterNameHintsWhenArgumentMatchesName = false,
							includeInlayFunctionParameterTypeHints = true,
							includeInlayVariableTypeHints = true,
							includeInlayPropertyDeclarationTypeHints = true,
							includeInlayFunctionLikeReturnTypeHints = true,
						},
					},
				},
			})

			lspconfig.eslint.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
				settings = {
					workingDirectory = { mode = "auto" },
					codeAction = {
						disableRuleComment = {
							enable = true,
							location = "separateLine"
						},
						showDocumentation = {
							enable = true
						}
					}
				}
			})

			lspconfig.html.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html" },
			})
			lspconfig.htmx.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "htmx" },
			})
			lspconfig.tailwindcss.setup({
				on_attach = on_attach,
				capabilities = capabilities,
				filetypes = { "templ", "astro", "javascript", "typescript", "react", "svelte" },
				settings = {
					tailwindCSS = {
						includeLanguages = {
							templ = "html",
							svelte = "html",
						},
					},
				},
			})
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})
			lspconfig.svelte.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					svelte = {
						plugin = {
							typescript = {
								diagnostics = { enable = true },
								hover = { enable = true },
								documentSymbols = { enable = true },
								completions = { enable = true },
								codeActions = { enable = true },
								selectionRange = { enable = true },
								definitions = { enable = true },
								references = { enable = true },
							},
							css = { diagnostics = { enable = true }, hover = { enable = true } },
							html = { hover = { enable = true }, documentSymbols = { enable = true } },
						}
					}
				}
			})
			lspconfig.cssls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

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

			-- Ruff LSP setup (for linting)
			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					settings = {
						-- Ruff settings
						args = {
							"--line-length=88",
						},
					},
				},
			})

			-- Gopls setup with enhanced settings
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
						experimentalPostfixCompletions = true,
					},
				},
			})

			lspconfig.graphql.setup({
				on_attach = on_attach,
				root_dir = lspconfig.util.root_pattern(".graphqlconfig", ".graphqlrc", "package.json"),
				flags = {
					debounce_text_changes = 150,
				},
				capabilities = capabilities,
			})

			local servers = { "ccls", "cmake", "templ" }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			-- Define keymaps for LSP functionality
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

			-- Show diagnostics in a nicer format with borders
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})
		end,
	},
}