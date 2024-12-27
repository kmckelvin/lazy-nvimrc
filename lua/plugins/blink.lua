return {
  "saghen/blink.cmp",
  opts = {
    enabled = function()
      if vim.bo.buftype == "prompt" then
        return false
      end

      if vim.bo.filetype == "markdown" then
        return false
      end

      return true
    end,
    completion = {
      menu = {
        border = "rounded",
      },
      documentation = {
        window = {
          border = "rounded",
        },
      },
    },
  },
}
