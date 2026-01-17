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
-- Transforms a function call with comma-separated parameters on one line
-- into a multi-line format with each parameter on its own line.
-- Example: `foo(a, b, c)` -> `foo(\n  a,\n  b,\n  c\n)`
-- Handles nested parentheses correctly: `foo(bar(a, b), c)` splits into
-- `foo(\n  bar(a, b),\n  c\n)` (not splitting on commas inside bar())
local function split_params_on_commas()
  -- Get the current cursor position and line content
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  if line == "" then
    return
  end

  -- Extract the leading whitespace (indentation) from the line
  local indent = line:match("^%s*") or ""
  -- Find the position of the opening and closing parentheses
  local open_paren = line:find("%(")
  local close_paren = line:match(".*()%)")
  if not open_paren or not close_paren then
    return
  end

  -- Split the line into three parts:
  -- prefix: everything before the opening paren (function name, etc.)
  -- args: everything between the parentheses (the parameters)
  -- suffix: everything after the closing paren (method chaining, etc.)
  local prefix = line:sub(1, open_paren - 1)
  local args = line:sub(open_paren + 1, close_paren - 1)
  local suffix = line:sub(close_paren + 1)
  -- Check if there's a trailing comma after the closing paren
  -- (e.g., `foo(a, b),` in an array or function call)
  local trailing_comma = suffix:match("^%s*,%s*$") ~= nil

  -- Split the arguments by commas, respecting nested parentheses
  -- This properly handles cases like: foo(bar(a, b), c) where bar(a, b) is a single argument
  local parts = {}
  local current_part = ""
  local depth = 0  -- Track nesting depth of parentheses

  local function add_part()
    local trimmed = vim.trim(current_part)
    if trimmed ~= "" then
      table.insert(parts, trimmed)
    end
    current_part = ""
  end

  for i = 1, #args do
    local char = args:sub(i, i)
    if char == "," and depth == 0 then
      add_part()
    else
      if char == "(" then
        depth = depth + 1
      elseif char == ")" then
        depth = depth - 1
      end
      current_part = current_part .. char
    end
  end

  -- Don't forget the last part (after the final comma or if there are no commas)
  add_part()

  -- If there are no valid parameters, don't do anything
  if #parts == 0 then
    return
  end

  -- Build the new multi-line representation
  -- Start with the prefix and opening parenthesis on the first line
  local lines = { prefix .. "(" }
  -- Add two spaces to the base indent for parameter lines
  local inner_indent = indent .. "  "
  -- Add each parameter on its own line, with a comma after all but the last
  for index, part in ipairs(parts) do
    local innerSuffix = index == #parts and "" or ","
    table.insert(lines, inner_indent .. part .. innerSuffix)
  end

  -- Add the closing parenthesis on its own line
  local closing = indent .. ")"
  -- Preserve trailing comma if it existed, or append any non-whitespace suffix
  if trailing_comma then
    closing = closing .. ","
  else
    if suffix:match("%S") then
      closing = closing .. suffix
    end
  end
  table.insert(lines, closing)

  -- Replace the original line with the new multi-line version
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

  if vim.uv.fs_stat(vim.fn.getcwd() .. "/" .. file) ~= nil then
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
