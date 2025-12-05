-- Conditionally configure Ruby LSP and formatter based on project setup
local function set_ruby_config()
  local root_dir = vim.fn.getcwd()

  -- Check for solargraph in Gemfile
  local gemfile = root_dir .. "/Gemfile"
  local use_solargraph = false

  if vim.fn.filereadable(gemfile) == 1 then
    local gemfile_contents = vim.fn.readfile(gemfile)
    for _, line in ipairs(gemfile_contents) do
      if line:match("solargraph") then
        use_solargraph = true
        break
      end
    end
  end

  if use_solargraph then
    vim.g.lazyvim_ruby_lsp = "solargraph"
  else
    vim.g.lazyvim_ruby_lsp = "ruby_lsp"
  end

  -- Check for .rubocop.yml for formatter selection
  local rubocop_config = root_dir .. "/.rubocop.yml"

  if vim.fn.filereadable(rubocop_config) == 1 then
    vim.g.lazyvim_ruby_formatter = "rubocop"
  else
    vim.g.lazyvim_ruby_formatter = "standardrb"
  end
end

-- Set config on initial load
set_ruby_config()

-- Re-check config every time a Ruby file is opened
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = set_ruby_config,
})
