return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    -- Define all keymaps
    local function setup_keymaps()
      local keymap_opts = { noremap = true, silent = true }

      -- Main commands using <leader>o prefix (for "oracle" or "AI")
      vim.keymap.set("n", "<leader>oi", "<cmd>CodeCompanion<cr>", keymap_opts)            -- Open inline assistant
      vim.keymap.set("n", "<leader>oc", "<cmd>CodeCompanionChat<cr>", keymap_opts)        -- Open chat buffer
      vim.keymap.set("n", "<leader>ot", "<cmd>CodeCompanionChat Toggle<cr>", keymap_opts) -- Toggle chat buffer
      vim.keymap.set("n", "<leader>om", "<cmd>CodeCompanionCmd<cr>", keymap_opts)         -- Generate command-line
      vim.keymap.set("n", "<leader>oa", "<cmd>CodeCompanionActions<cr>", keymap_opts)     -- Open action palette

      -- Visual mode commands
      vim.keymap.set("v", "<leader>oi", "<cmd>CodeCompanion<cr>", keymap_opts)         -- Inline with selection
      vim.keymap.set("v", "<leader>ov", "<cmd>CodeCompanionChat Add<cr>", keymap_opts) -- Add selection to chat

      -- Prompt library access
      vim.keymap.set("n", "<leader>oe", "<cmd>CodeCompanion /Explain<cr>", keymap_opts)                       -- Explain code
      vim.keymap.set("v", "<leader>oe", "<cmd>CodeCompanion /Explain<cr>", keymap_opts)                       -- Explain selection

      vim.keymap.set("n", "<leader>ou", "<cmd>CodeCompanion /\"Unit Tests\"<cr>", keymap_opts)                -- Generate tests
      vim.keymap.set("v", "<leader>ou", "<cmd>CodeCompanion /\"Unit Tests\"<cr>", keymap_opts)                -- Generate tests for selection

      vim.keymap.set("n", "<leader>of", "<cmd>CodeCompanion /\"Fix code\"<cr>", keymap_opts)                  -- Fix code
      vim.keymap.set("v", "<leader>of", "<cmd>CodeCompanion /\"Fix code\"<cr>", keymap_opts)                  -- Fix selection

      vim.keymap.set("n", "<leader>ol", "<cmd>CodeCompanion /\"Explain LSP Diagnostics\"<cr>", keymap_opts)   -- Explain LSP diagnostics
      vim.keymap.set("v", "<leader>ol", "<cmd>CodeCompanion /\"Explain LSP Diagnostics\"<cr>", keymap_opts)   -- Explain LSP for selection

      vim.keymap.set("n", "<leader>og", "<cmd>CodeCompanion /\"Generate a Commit Message\"<cr>", keymap_opts) -- Generate commit message

      -- Code workflow commands
      vim.keymap.set("n", "<leader>ow", "<cmd>CodeCompanion /\"Code workflow\"<cr>", keymap_opts)        -- Code workflow
      vim.keymap.set("n", "<leader>od", "<cmd>CodeCompanion /\"Edit<->Test workflow\"<cr>", keymap_opts) -- Edit-test workflow

      -- Custom prompts
      vim.keymap.set("n", "<leader>op", "<cmd>CodeCompanion \"Custom prompt\"<cr>", keymap_opts) -- Custom prompt
      vim.keymap.set("v", "<leader>op", "<cmd>CodeCompanion \"Custom prompt\"<cr>", keymap_opts) -- Custom prompt with selection
    end

    require("codecompanion").setup({
      adapters = {
        -- Set Anthropic as the default for all adapters
        anthropic = "anthropic",
        opts = {
          show_defaults = true,
        }
      },
      strategies = {
        -- Set Anthropic as default for all strategies
        chat = {
          adapter = "anthropic",
        },
        inline = {
          adapter = "anthropic",
        },
        cmd = {
          adapter = "anthropic",
        },
      },
      display = {
        chat = {
          window = {
            width = 0.5, -- Adjust width as needed
            layout = "vertical",
            position = "right",
          },
          start_in_insert_mode = true,
          show_header_separator = true,
          show_token_count = true,
        },
        action_palette = {
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
        diff = {
          enabled = true,
        },
      },
      opts = {
        log_level = "DEBUG", -- Keep your debug logging
        language = "English",
      },
    })

    setup_keymaps()
  end,
}
