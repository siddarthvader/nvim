return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            ".output",
            "$houdini",
            "svelte-kit",
            ".build",
            'ent/',
            'dist/',
            '**/dist/',
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set(
        "n",
        "<leader>fs",
        require("telescope.builtin").current_buffer_fuzzy_find,
        { desc = "Search in current buffer" }
      )
      require("telescope").load_extension("ui-select")
    end,
  },
}
