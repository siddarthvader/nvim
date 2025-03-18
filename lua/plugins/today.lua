return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  config = function()
    -- Wait for nvim-cmp to load fully
    vim.defer_fn(function()
      local cmp = require("cmp")
      
      -- Create custom source for @today completion
      local source = {}
      source.new = function()
        local self = setmetatable({}, { __index = source })
        return self
      end
      
      -- Define metadata for our source
      source.name = "today_date"
      source.priority = 1000 -- Higher priority than other sources
      
      function source:get_trigger_characters()
        return { "@" }
      end
      
      function source:complete(params, callback)
        local line = params.context.cursor_before_line
        
        -- Check if we're typing @today or part of it
        if line:match("@today$") or line:match("@t[o]?[d]?[a]?[y]?$") then
          local current_date = os.date("%Y-%m-%d")
          
          callback({
            {
              label = "@today → " .. current_date,
              filterText = "@today",
              insertText = current_date,
              documentation = "Insert today's date (" .. current_date .. ")",
              kind = cmp.lsp.CompletionItemKind.Snippet,
            }
          })
        else
          callback()
        end
      end
      
      -- Register the custom source
      cmp.register_source("today_date", source.new())
      
      -- Force our custom source to be at the top of sources list
      cmp.setup({
        sources = {
          { name = "today_date", priority = 1000 },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ 
            select = true,  -- This is key - select first item if none selected
            behavior = cmp.ConfirmBehavior.Replace 
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        completion = {
          completeopt = "menu,menuone,noinsert",
          autocomplete = { "TextChanged" }
        }
      })
      
      -- Create a specific autocmd for @today to force completion menu
      vim.api.nvim_create_autocmd("InsertCharPre", {
        pattern = "*",
        callback = function()
          local char = vim.v.char
          if char == "@" then
            -- Mark that we've seen an @ so we can check for 't' next
            vim.b.saw_at = true
          elseif vim.b.saw_at and char:match("[tT]") then
            -- Schedule completion to open after the 't' is inserted
            vim.schedule(function()
              cmp.complete({
                config = {
                  sources = {
                    { name = "today_date" }
                  }
                }
              })
            end)
            vim.b.saw_at = false
          else
            vim.b.saw_at = false
          end
        end
      })
      
    end, 100) -- Small delay to ensure nvim-cmp is fully loaded
  end,
}
