local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("lazy").setup("plugins")


-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
vim.g.go_bin_path = "/usr/local/go/bin"
vim.opt.splitkeep = "screen"
