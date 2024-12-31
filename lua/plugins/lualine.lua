return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      options = {
        theme = "catppuccin-mocha",
        options = {
          lualine_c = { {
            "filename",
            path = 1,
          } },
        },
      },
    })
  end,
}
