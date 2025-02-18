-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>", { silent = true, desc = "Save the current buffer" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", function()
  vim.cmd.Git("commit")
end, { desc = "Git commit" })
vim.keymap.set("n", "<leader>gw", fzf.lsp_workspace_symbols, { desc = "Workspace Symbols" })

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

-- split parameters into multiple lines
vim.keymap.set("n", "<leader>cz", "0maf(a<cr><esc>f)i<cr><esc>k<cmd>s/, /,\\r/g<cr><cmd>noh<cr>j=`a<cmd>delmarks a<cr>")

local function edit_file_under_cursor()
  vim.cmd('normal! viWo"py')
  local grabbed_string = vim.fn.getreg("p")
  vim.api.nvim_input("<ESC>")

  local file, line_number = string.match(grabbed_string, "(.-):([0-9]+)")

  if line_number == nil then
    file = grabbed_string
  end

  if vim.loop.fs_stat(vim.fn.getcwd() .. "/" .. file) ~= nil then
    vim.cmd("wincmd p")
    vim.cmd("e " .. file)

    if line_number ~= nil then
      vim.cmd("normal " .. line_number .. "gg")
    end
  end
end

vim.keymap.set("n", "<leader>gf", edit_file_under_cursor)
