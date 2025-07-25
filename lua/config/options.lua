-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
require("config.options.ruby")

vim.opt.scrolloff = 5
vim.opt.title = true
vim.g.snacks_animate = false

if vim.fn.getenv("TERM_PROGRAM") == "ghostty" then
  vim.opt.mousescroll = "ver:1"
end
