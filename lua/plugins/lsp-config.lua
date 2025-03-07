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
				"svelte", -- Svelte language server
				"eslint_d", -- Faster ESLint implementation
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

				-- Enhance hover information with more details
				if client.supports_method("textDocument/hover") then
					vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						border = "rounded",
						max_width = 80,
						max_height = 30,
					})
				end

				-- Create a command to show diagnostics at current line
				vim.api.nvim_buf_create_user_command(bufnr, "ShowLineDiagnostics", function()
					vim.diagnostic.open_float({ border = "rounded", focus = false })
				end, { desc = "Show diagnostics at current line" })

				-- Create custom K keybinding to ALWAYS show hover first, diagnostics only as fallback
				vim.keymap.set("n", "K", function()
					-- Always try to show hover information first
					local hover_successful = false

					-- Function to check if hover was successful
					local check_hover = function()
						-- If hover failed or returned no info, show diagnostics as fallback
						if not hover_successful then
							-- Check for diagnostics at cursor position
							local line = vim.fn.line(".") - 1
							local character = vim.fn.col(".") - 1
							local diagnostics_at_cursor = vim.diagnostic.get(bufnr, {
								lnum = line,
								col = character,
							})

							if #diagnostics_at_cursor > 0 then
								-- Show diagnostic at cursor position
								vim.diagnostic.open_float({ border = "rounded", focus = false })
							else
								-- If no diagnostic at cursor, show any on the line
								local line_diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
								if #line_diagnostics > 0 then
									vim.diagnostic.open_float({ border = "rounded", focus = false })
								end
							end
						end
					end

					-- Hook into the hover handler to capture if it was successful
					local orig_hover_handler = vim.lsp.handlers["textDocument/hover"]
					vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
						if
							result
							and result.contents
							and (
								(type(result.contents) == "string" and result.contents ~= "")
								or (
									type(result.contents) == "table"
									and result.contents.value
									and result.contents.value ~= ""
								)
							)
						then
							hover_successful = true
						end
						orig_hover_handler(err, result, ctx, config)

						-- Restore original handler
						vim.lsp.handlers["textDocument/hover"] = orig_hover_handler

						-- If hover failed, show diagnostics
						if not hover_successful then
							vim.defer_fn(check_hover, 50)
						end
					end

					-- Try hover
					vim.lsp.buf.hover()

					-- If hover handler wasn't triggered at all, check diagnostics
					vim.defer_fn(function()
						if not hover_successful then
							check_hover()
						end
					end, 100)
				end, { buffer = bufnr, silent = true })

				-- Add a mapping for explicitly showing diagnostics
				vim.keymap.set("n", "<leader>d", function()
					vim.diagnostic.open_float({ border = "rounded", focus = false })
				end, { buffer = bufnr, desc = "Show diagnostics at cursor" })
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
				on_attach = function(client, bufnr)
					-- Run standard on_attach function
					on_attach(client, bufnr)
					
					-- Add keymap to manually run ESLint diagnostics on the current file
					vim.keymap.set("n", "<leader>el", function()
						vim.cmd("EslintFixAll")
						vim.notify("ESLint ran on current file", vim.log.levels.INFO)
					end, { buffer = bufnr, desc = "Run ESLint on current file" })
				end,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte" },
				settings = {
					workingDirectory = { mode = "auto" },
					run = "onType",  -- Run ESLint as you type
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
			lspconfig.svelte.setup({
				capabilities = capabilities,
				on_attach = function(client, bufnr)
					-- Run standard on_attach function
					on_attach(client, bufnr)
					
					-- Add enhanced diagnostics display for Svelte files
					vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI", "CursorMoved"}, {
						buffer = bufnr,
						callback = function()
							vim.diagnostic.open_float(nil, { focus = false })
						end,
					})
					
					-- Force update diagnostics when saving Svelte files
					vim.api.nvim_create_autocmd("BufWritePost", {
						buffer = bufnr,
						callback = function()
							vim.diagnostic.reset(bufnr)
							vim.defer_fn(function()
								vim.lsp.buf.document_highlight()
								vim.diagnostic.show()
							end, 100)
						end,
					})
				end,
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
						},
					},
				},
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
			-- K mapping is now handled in on_attach to show diagnostics or hover info
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {})

			-- Show diagnostics in a nicer format with borders
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = "●",
					source = "if_many",
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
					format = function(diagnostic)
						-- Enhance the diagnostic message with more information
						local message = diagnostic.message
						if diagnostic.code then
							message = string.format("[%s] %s", diagnostic.code, message)
						end
						if diagnostic.source then
							message = string.format("%s (from %s)", message, diagnostic.source)
						end
						return message
					end,
				},
			})
		end,
	},
}

