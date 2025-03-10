return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"hrsh7th/cmp-buffer", -- Add buffer completion source
	},
	{
		"hrsh7th/cmp-path", -- Add path completion source
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			-- Set up completion mode to be eager instead of lazy
			vim.o.completeopt = "menu,menuone,noselect"

			-- Create an autocommand to force refresh completions 
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.svelte" },
				callback = function()
					-- Just check for active LSP clients
					local has_lsp = #vim.lsp.get_active_clients({ bufnr = 0 }) > 0
					if has_lsp then
						vim.schedule(function()
							-- Use the cmp API directly to refresh completion
							require("cmp").complete()
						end)
					end
				end,
			})

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = {
					{ name = "nvim_lsp", keyword_length = 1, max_item_count = 30 },
					{ name = "buffer", keyword_length = 2, max_item_count = 20 },
					{ name = "path", keyword_length = 2, max_item_count = 10 },
					{ name = "luasnip", keyword_length = 2 },
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
					autocomplete = {
						require("cmp.types").cmp.TriggerEvent.TextChanged,
					},
					keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
					keyword_length = 1,
				},
			})
		end,
	},
}
