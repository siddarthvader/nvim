-- Custom commands and utilities

-- Copy file path to clipboard (relative to parent of project root)
vim.api.nvim_create_user_command("CopyFilePathToClipboard", function()
  -- Get the current buffer's file path
  local file_path = vim.api.nvim_buf_get_name(0)
  
  if file_path == "" then
    vim.notify("No file to copy path from", vim.log.levels.WARN)
    return
  end

  -- Get current working directory and its parent
  local cwd = vim.fn.getcwd()
  local project_root_parent_dir = vim.fn.fnamemodify(cwd, ":h")

  -- Get relative path from the parent of project root
  local relative_path = vim.fn.fnamemodify(file_path, ":." .. project_root_parent_dir)
  
  -- If the relative path calculation didn't work, try a simpler approach
  if relative_path == file_path then
    -- Get relative path from current working directory
    relative_path = vim.fn.fnamemodify(file_path, ":.")
  end

  -- Copy the relative path to the system clipboard
  vim.fn.setreg("+", relative_path)
  
  -- Show confirmation message
  vim.notify("Copied to clipboard: " .. relative_path, vim.log.levels.INFO)
end, { desc = "Copy file path to clipboard (relative to parent of project root)" })

-- Short aliases for the commands
vim.api.nvim_create_user_command("CFP", function()
  vim.cmd(":CopyFilePathToClipboard")
end, { desc = "Copy file path to clipboard (alias)" })

vim.api.nvim_create_user_command("CAP", function()
  vim.cmd(":CopyFullPath")
end, { desc = "Copy absolute path to clipboard (alias)" })

-- Additional file path copy commands for convenience
vim.api.nvim_create_user_command("CopyFullPath", function()
  local file_path = vim.api.nvim_buf_get_name(0)
  vim.fn.setreg("+", file_path)
  vim.notify("Copied full path to clipboard: " .. file_path, vim.log.levels.INFO)
end, { desc = "Copy full file path to clipboard" })

vim.api.nvim_create_user_command("CopyFileName", function()
  local file_name = vim.fn.expand("%:t")
  vim.fn.setreg("+", file_name)
  vim.notify("Copied filename to clipboard: " .. file_name, vim.log.levels.INFO)
end, { desc = "Copy filename to clipboard" })

-- Keybindings for quick access
vim.keymap.set("n", "<leader>yr", "<cmd>CopyFilePathToClipboard<CR>", { desc = "Yank relative file path to clipboard", silent = true })
vim.keymap.set("n", "<leader>ya", "<cmd>CopyFullPath<CR>", { desc = "Yank absolute file path to clipboard", silent = true })
