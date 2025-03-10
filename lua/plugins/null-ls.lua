return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				-- Formatters
				null_ls.builtins.formatting.black,
				-- Go linters
				null_ls.builtins.diagnostics.golangci_lint,

				-- Diagnostics
				null_ls.builtins.diagnostics.yamllint, -- YAML
			},
			on_attach = function(client, bufnr)
				-- Show diagnostics when cursor holds position
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						vim.diagnostic.open_float(nil, { focus = false })
					end,
				})

				-- Show diagnostics when cursor moves to a new line
				vim.api.nvim_create_autocmd("CursorMoved", {
					buffer = bufnr,
					callback = function()
						-- Only show diagnostics if they exist at cursor position
						local line = vim.fn.line(".") - 1
						local character = vim.fn.col(".") - 1
						local diagnostics_at_cursor = vim.diagnostic.get(bufnr, {
							lnum = line,
							col = character,
						})

						if #diagnostics_at_cursor > 0 then
							vim.diagnostic.open_float(nil, { focus = false })
						end
					end,
				})
			end,
			-- Update diagnostics in real-time (change to true for more immediate feedback)
			update_in_insert = true,
		})

		-- Configure diagnostic display
		vim.diagnostic.config({
			underline = true,
			virtual_text = {
				prefix = "●",
				source = "if_many",
			},
			float = {
				source = "always",
				border = "rounded",
			},
			signs = true,
			severity_sort = true,
		})
	end,
}
