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
          end
        })
      end,
      -- Update diagnostics in real-time
      update_in_insert = false,
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
