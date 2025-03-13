return {
	{
		"hrsh7th/cmp-nvim-lsp",
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

			-- Set up completion mode
			vim.o.completeopt = "menu,menuone,noselect"

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
				}),
				sources = {
					{ name = "nvim_lsp", keyword_length = 2, max_item_count = 20 },
					{ name = "path", keyword_length = 3, max_item_count = 5 },
					{ name = "luasnip", keyword_length = 2 },
				},
				performance = {
					max_view_entries = 20,
					trigger_debounce_time = 150, -- ms
					throttle = 50, -- ms
				},
				completion = {
					completeopt = "menu,menuone,noinsert",
					keyword_length = 2, -- Increased minimum length to reduce constant triggering
				},
			})
		end,
	},
}
