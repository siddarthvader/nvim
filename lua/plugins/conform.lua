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
      css = { "biome" },
      graphql = { "prettier" },
      gql = { "prettier" },
      fish = { "fish_indent" },
      go = { "gofmt" },
      ocaml = { "ocamlformat" },
      html = { "biome" },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      json = { "biome" },
      lua = { "stylua" },
      markdown = { "prettier" },
      nix = { "alejandra" },
      python = { "ruff_format" },
      sql = { "sql_formatter" },
      svelte = { "prettier" },
      templ = { "templ" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      yaml = { "prettier" },
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
        args = { "fmt", "-stdout", "-stdin-filepath", "$FILENAME" },
        stdin = true,
      },
    },
  },

  vim.keymap.set({ "n", "v" }, "<leader>ff", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 5000,
    })
  end, { desc = "Format file or visual-mode range." }),
}
