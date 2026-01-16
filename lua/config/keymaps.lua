-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
if not vim.g.vscode then
  local fzf = require("fzf-lua")
  vim.keymap.set("n", "<leader>gw", fzf.lsp_workspace_symbols, { desc = "Workspace Symbols" })
end

vim.keymap.set("n", "<leader>fs", "<cmd>w<cr>", { silent = true, desc = "Save the current buffer" })
vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
vim.keymap.set("n", "<leader>gc", function()
  vim.cmd.Git("commit")
end, { desc = "Git commit" })

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
local function split_params_on_commas()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
  if not line or line == "" then
    return
  end

  local indent = line:match("^%s*") or ""
  local open_paren = line:find("%(")
  if not open_paren then
    return
  end

  local close_paren
  for i = #line, 1, -1 do
    if line:sub(i, i) == ")" then
      close_paren = i
      break
    end
  end
  if not close_paren then
    return
  end

  local prefix = line:sub(1, open_paren - 1)
  local args = line:sub(open_paren + 1, close_paren - 1)
  local suffix = line:sub(close_paren + 1)
  local trailing_comma = suffix:match("^%s*,%s*$") ~= nil

  local parts = {}
  for part in args:gmatch("[^,]+") do
    local trimmed = vim.trim(part)
    if trimmed ~= "" then
      table.insert(parts, trimmed)
    end
  end

  if #parts == 0 then
    return
  end

  local lines = { prefix .. "(" }
  local inner_indent = indent .. "  "
  for index, part in ipairs(parts) do
    local innerSuffix = index == #parts and "" or ","
    table.insert(lines, inner_indent .. part .. innerSuffix)
  end

  local closing = indent .. ")"
  if trailing_comma then
    closing = closing .. ","
  else
    if suffix:match("%S") then
      closing = closing .. suffix
    end
  end
  table.insert(lines, closing)

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, lines)
end

vim.keymap.set("n", "<leader>cz", split_params_on_commas, { desc = "Split params on commas" })

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

vim.api.nvim_create_user_command("CopyRelativePath", function()
  local full_path = vim.fn.expand("%:p")
  local root = vim.fn.getcwd()
  local relative_path = full_path:sub(#root + 2) -- +2 to remove the leading slash
  vim.fn.setreg("+", relative_path)
  print("Copied to clipboard: " .. relative_path)
end, {})

vim.keymap.set("n", "<leader>yf", ":CopyRelativePath<CR>", { noremap = true, silent = false })
