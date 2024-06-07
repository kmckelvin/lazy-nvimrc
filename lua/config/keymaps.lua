-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>", { silent = true, desc = "Save the current buffer" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", function()
  vim.cmd.Git("commit")
end, { desc = "Git commit" })
vim.keymap.set("n", "<leader>gw", telescope.lsp_dynamic_workspace_symbols, { desc = "Workspace Symbols" })

vim.keymap.set("n", "Q", ":q<CR>", { silent = true })

-- terminal pane management
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])
vim.keymap.set("t", "<leader><esc>", [[<C-\><C-n>]])

vim.api.nvim_create_user_command("Q", "q", {})
vim.api.nvim_create_user_command("Qa", "qall", {})

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wa", "wall", {})

vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("Wqa", "wqall", {})
