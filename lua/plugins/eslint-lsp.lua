return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Add eslint to the servers list
      opts.servers = opts.servers or {}
      opts.servers.eslint = {
        on_attach = function(client, bufnr)
          -- Auto fix on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
        settings = {
          -- Helps with monorepos
          workingDirectories = { mode = "auto" },
          format = false, -- Use prettier for formatting instead
        },
      }
      return opts
    end,
  },
}