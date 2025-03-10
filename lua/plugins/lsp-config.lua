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
				"svelte", -- Svelte language server,
        "ts_ls"
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			-- Enhanced LSP capabilities for better autocompletion
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem = {
				documentationFormat = { "markdown", "plaintext" },
				snippetSupport = true,
				preselectSupport = true,
				insertReplaceSupport = true,
				labelDetailsSupport = true,
				deprecatedSupport = true,
				commitCharactersSupport = true,
				tagSupport = { valueSet = { 1 } },
				resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				},
			}
			local lspconfig = require("lspconfig")

			-- Enhanced on_attach function
			local on_attach = function(client, bufnr)
				-- Enable completion triggered by <c-x><c-o>
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				-- Set up simple hover with rounded borders
				vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
					border = "rounded",
					max_width = 80,
					max_height = 30,
				})

				-- Enhanced completions setup
				if client.server_capabilities.completionProvider then
					client.server_capabilities.completionProvider.triggerCharacters = {
						".", ":", "@", "/", "-", "#", 
						-- Add language-specific trigger characters
						"'", '"', "<", "[", "("
					}
				end

				-- Simple diagnostics command
				vim.api.nvim_buf_create_user_command(bufnr, "ShowLineDiagnostics", function()
					vim.diagnostic.open_float({ border = "rounded", focus = false })
				end, { desc = "Show diagnostics at current line" })

				-- Simple K to show hover info
				vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, silent = true })

				-- Add a mapping for showing diagnostics
				vim.keymap.set("n", "<leader>d", function()
					vim.diagnostic.open_float({ border = "rounded", focus = false })
				end, { buffer = bufnr, desc = "Show diagnostics at cursor" })

				-- Add refresh completion cache keybinding
				vim.keymap.set("n", "<leader>r", function()
					-- Use the built-in LspRestart command for the specific client
					if client and client.name then
						vim.cmd("LspRestart " .. client.name)
						vim.notify("LSP server " .. client.name .. " restarted", vim.log.levels.INFO)
					else
						vim.cmd("LspRestart")
						vim.notify("All LSP servers restarted", vim.log.levels.INFO)
					end
				end, { buffer = bufnr, desc = "Restart LSP server and refresh cache" })
			end

			lspconfig.ts_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				-- Exclude Svelte files from TypeScript language server
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
				on_attach = function(client, bufnr)
					-- Run standard on_attach function
					on_attach(client, bufnr)

					-- Add keymap to manually run ESLint diagnostics on the current file
					vim.keymap.set("n", "<leader>el", function()
						vim.cmd("EslintFixAll")
						vim.notify("ESLint ran on current file", vim.log.levels.INFO)
					end, { buffer = bufnr, desc = "Run ESLint on current file" })
				end,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				settings = {
					workingDirectory = { mode = "auto" },
					run = "onType", -- Run ESLint as you type
					codeAction = {
						disableRuleComment = {
							enable = true,
							location = "separateLine",
						},
						showDocumentation = {
							enable = true,
						},
					},
				},
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
			-- Simple Svelte setup
			lspconfig.svelte.setup({
				capabilities = capabilities,
				-- Ensure no duplicate definition behavior
				handlers = {
					["textDocument/definition"] = function(_, result, ctx, config)
						if result and #result == 1 then
							vim.lsp.util.jump_to_location(result[1], "utf-8")
						else
							vim.lsp.handlers["textDocument/definition"](_, result, ctx, config)
						end
					end,
				},
				on_attach = on_attach,
				filetypes = { "svelte" },
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

			-- Setup for templ with enhanced diagnostics
			lspconfig.templ.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			local servers = { "ccls", "cmake" }
			for _, lsp in ipairs(servers) do
				lspconfig[lsp].setup({
					on_attach = on_attach,
					capabilities = capabilities,
				})
			end

			-- Define keymaps for LSP functionality
			-- K mapping is now handled in on_attach to show diagnostics or hover info
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

			-- Simple diagnostic configuration
			vim.diagnostic.config({
				virtual_text = { spacing = 4, prefix = "●" },
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})
		end,
	},
}
