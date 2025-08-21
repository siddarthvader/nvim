return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
					mappings = {
						i = {
							["<C-u>"] = false,
							["<C-d>"] = false,
						},
					},
				},
			})
			
			-- Set up keymaps after telescope is loaded
			vim.keymap.set('n', '<leader>sf', function()
				require("telescope.builtin").lsp_document_symbols({
					symbols = { "function", "method" },
				})
			end, { desc = "Find Functions/Methods" })
			
			vim.keymap.set('n', '<leader>sF', function()
				require("telescope.builtin").lsp_workspace_symbols({
					symbols = { "function", "method" },
				})
			end, { desc = "Find Functions/Methods (Workspace)" })
		end,
	},
}