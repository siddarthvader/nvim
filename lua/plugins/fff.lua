return {
  "dmtrKovalenko/fff.nvim",
  build = function()
    -- this will download prebuild binary or try to use existing rustup toolchain to build from source
    -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
    require("fff.download").download_or_build_binary()
  end,
  -- if you are using nixos
  -- build = "nix run .#release",
  opts = {
    debug = {
      enabled = true,  -- we expect your collaboration at least during the beta
      show_scores = true, -- to help us optimize the scoring system, feel free to share your scores!
    },
  },
  -- No need to lazy-load with lazy.nvim.
  -- This plugin initializes itself lazily.
  lazy = false,
  keys = {
    {
      "<leader><space>",
      function()
        require("fff").find_files()
      end,
      desc = "FFF: Find files",
    },
    {
      "<C-p>",
      function()
        require("fff").find_files()
      end,
      desc = "FFF: Find files",
    },
    {
      "<leader>fg",
      function()
        require("fff").find_files()
      end,
      desc = "FFF: Find git files",
    },
    {
      "<leader>fc",
      function()
        require("fff").find_files({ base_path = vim.fn.stdpath("config") })
      end,
      desc = "FFF: Find config files",
    },
    {
      "<leader>fr",
      function()
        require("fff").find_files()
      end,
      desc = "FFF: Find files (recent)",
    },
  },
}
