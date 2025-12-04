## Overview

This is a personal Neovim configuration based on LazyVim, customized for web development with Ruby/Rails, Go, TypeScript, and JavaScript.

## Architecture

### Configuration Structure

- **`init.lua`**: Entry point that bootstraps lazy.nvim
- **`lua/config/lazy.lua`**: Lazy.nvim setup with LazyVim extras imports (Ruby, Go, TypeScript, YAML, ESLint, Prettier)
- **`lua/config/options.lua`**: Global options and language-specific option loading
- **`lua/config/options/ruby.lua`**: Ruby-specific configuration including dynamic formatter selection
- **`lua/config/autocmds.lua`**: Auto-commands, including tmux integration
- **`lua/config/keymaps.lua`**: Custom keybindings
- **`lua/plugins/*.lua`**: Plugin configurations that override or extend LazyVim defaults
- **`after/plugin/*.lua`**: Additional plugin setup that runs after main config

### Key Plugin Customizations

- **fzf-lua**: Preferred fuzzy finder, unbinds some default git keymaps
- **vim-fugitive + vim-rhubarb**: Git integration with GitHub support
- **vim-test**: Test runner with neovim strategy, custom mappings for running tests
- **vim-rails**: Rails-specific commands and navigation
- **vim-tmux-navigator**: Seamless navigation between tmux panes and vim splits

## Ruby/Rails Development

### Formatter Selection Logic

Ruby formatting automatically switches between `rubocop` and `standardrb`:

- Checks for `.rubocop.yml` in the **current working directory only** (not parent directories)
- If found: uses `rubocop` formatter
- If not found: uses `standardrb` formatter
- Re-evaluates on every Ruby file open (FileType autocmd)
- Logs the chosen formatter via `vim.notify()`

This logic lives in `lua/config/options/ruby.lua`.

### Rails Commands

- **`:AC`**: Navigate to alternate file (controller ↔ view, model ↔ spec)
- Ruby indentation is customized to remove `.` and `{` from indentkeys

### Test Running

Test keymaps (via vim-test):

- `<leader>tn`: Run nearest test
- `<leader>tf`: Run current test file
- `<leader>ts`: Run full test suite
- `<leader>tl`: Run last test
- `<leader>tg`: Visit last test file

JavaScript/Ava-specific: Tests run with `--serial` flag

## Custom Keymaps

### File Operations

- `<leader>fs`: Save current buffer
- `<leader>yf`: Copy relative file path to clipboard
- `<leader>gf`: Smart file opener - extracts file path (and optional line number) under cursor and opens it

### Git Integration

- `<leader>gs`: Open fugitive Git status
- `<leader>gc`: Open Git commit
- `<leader>gw`: FZF workspace symbols

### Terminal

- `<C-h/j/k/l>`: Navigate between terminal and other panes
- `<leader><esc>`: Exit terminal mode

### Code Manipulation

- `<leader>cz`: Split function parameters into multiple lines (splits on commas)

### Convenience

- `Q`: Quit current window
- User commands: `:Q`, `:Qa`, `:W`, `:Wa`, `:Wq`, `:Wqa` for common typos

## Tmux Integration

When running inside tmux (`$TMUX` set):

- Vim automatically renames the tmux window to `vi:<cwd-basename>` on various events
- Restores automatic tmux window naming on vim exit

## Language Support

Configured via LazyVim extras:

- **Ruby**: LSP, formatting (rubocop/standardrb), rails support
- **Go**: Full language support
- **TypeScript/JavaScript**: LSP, ESLint, Prettier
- **YAML**: Syntax and validation
- **JSON**: Formatting and validation

Additional:

- **CoffeeScript** and **Slim**: Via custom plugins
- **Treesitter endwise**: Auto-closes Ruby blocks

## UI Preferences

- Animations disabled (`vim.g.snacks_animate = false`)
- Rounded borders on LSP diagnostic floats
- Inlay hints disabled
- Scrolloff set to 5
- Window title enabled
- Ghostty terminal: Mouse scroll speed adjusted
