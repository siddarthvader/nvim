return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>lf",
      function()
        -- Then run formatters
        require("conform").format({
          async = true,
          lsp_fallback = true,
        })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      python = { "black" }, -- Try ruff first, then black
      javascript = { "prettierd", "prettier" },
      templ = { "templ" },
    },
  },
  config = function(_, opts)
    local conform = require("conform")
    conform.setup(opts)

    -- Setup format on save with cursor position preservation
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.py",
      callback = function(args)
        -- Save cursor position
        local view = vim.fn.winsaveview()

        -- Do basic indentation fixes
        vim.cmd('set expandtab')
        vim.cmd('retab')
        vim.cmd('normal! gg=G')
        vim.cmd([[%s/\s\+$//e]])

        -- Restore cursor position
        vim.fn.winrestview(view)

        -- Then run formatters
        conform.format({
          bufnr = args.buf,
          timeout_ms = 1000,
        })
      end,
    })
  end,
}
