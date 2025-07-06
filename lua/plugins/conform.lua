return {
  "stevearc/conform.nvim",
  event = {
    "BufReadPre",
    "BufNewFile",
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      bash = { "beautysh" },
      c = { "clang-format" },
      css = { "prettierd" },
      graphql = { "prettierd" },
      gql = { "prettierd" },
      fish = { "fish_indent" },
      go = { "gofmt" },
      ocaml = { "ocamlformat" },
      html = { "prettierd" },
      javascript = { "biome", "prettierd" },
      javascriptreact = { "biome", "prettierd" },
      json = { "prettierd" },
      lua = { "stylua" },
      markdown = { "prettierd" },
      nix = { "alejandra" },
      python = { "ruff_format" },
      sql = { "sql_formatter" },
      svelte = { "prettierd" },
      templ = { "templ" },
      typescript = { "biome", "prettierd" },
      typescriptreact = { "biome", "prettierd" },
      yaml = { "prettierd" },
      zsh = { "beautysh" },
    },
    formatters = {
      ["clang-format"] = {
        prepend_args = {
          "--style",
          "{IndentCaseLabels: true, IndentWidth: 4, AllowShortFunctionsOnASingleLine: None}",
        },
      },
      templ = {
        command = "templ",
        args = { "fmt" },
        stdin = false,
      },
    },
  },

  vim.keymap.set({ "n", "v" }, "<leader>ff", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    })
  end, { desc = "Format file or visual-mode range." }),
}
