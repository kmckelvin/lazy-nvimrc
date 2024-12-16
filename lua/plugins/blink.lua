return {
  "saghen/blink.cmp",
  opts = {
    enabled = function()
      return vim.bo.filetype ~= "markdown"
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
