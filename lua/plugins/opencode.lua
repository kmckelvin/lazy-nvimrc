return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    local opencode = require("opencode")

    -- Recommended/example keymaps.
    vim.keymap.set({ "n", "x" }, "<leader>aa", function()
      opencode.ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ax", function()
      opencode.select()
    end, { desc = "Execute opencode action…" })
    local function copy_context_reference()
      local full_path = vim.api.nvim_buf_get_name(0)
      if full_path == "" then
        vim.notify("No file to copy", vim.log.levels.WARN)
        return
      end

      local root = vim.fn.getcwd()
      local relative_path = full_path
      if full_path:sub(1, #root) == root then
        relative_path = full_path:sub(#root + 2)
      end

      local reference = "@" .. relative_path
      local mode = vim.fn.mode()
      if mode == "v" or mode == "V" or mode == "\22" then
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        if start_line == 0 or end_line == 0 then
          start_line = vim.fn.line("'<")
          end_line = vim.fn.line("'>")
        end
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        if start_line == end_line then
          reference = string.format("%s:L%d", reference, start_line)
        else
          reference = string.format("%s:L%d-%d", reference, start_line, end_line)
        end
      end

      vim.fn.setreg("+", reference)
      vim.notify("Copied to clipboard: " .. reference)
    end

    vim.keymap.set({ "n", "x" }, "<leader>ad", copy_context_reference, { desc = "Copy context reference" })
    vim.keymap.set({ "n" }, "<leader>ac", function()
      opencode.toggle()
    end, { desc = "Toggle opencode" })
    vim.keymap.set("n", "<S-C-u>", function()
      opencode.command("session.half.page.up")
    end, { desc = "opencode half page up" })
    vim.keymap.set("n", "<S-C-d>", function()
      opencode.command("session.half.page.down")
    end, { desc = "opencode half page down" })
    -- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
  end,
}
