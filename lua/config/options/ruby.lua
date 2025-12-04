-- vim.g.lazyvim_ruby_lsp = "solargraph"

-- Conditionally use rubocop if .rubocop.yml exists, otherwise use standardrb
local function set_ruby_formatter()
  local root_dir = vim.fn.getcwd()
  local rubocop_config = root_dir .. "/.rubocop.yml"

  if vim.fn.filereadable(rubocop_config) == 1 then
    vim.g.lazyvim_ruby_formatter = "rubocop"
  else
    vim.g.lazyvim_ruby_formatter = "standardrb"
  end
end

-- Set formatter on initial load
set_ruby_formatter()

-- Re-check formatter every time a Ruby file is opened
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = set_ruby_formatter,
})
