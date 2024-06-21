local cmp_window = require("cmp.config.window")

return {
  "hrsh7th/nvim-cmp",
  opts = {
    window = {
      completion = cmp_window.bordered(),
      documentation = cmp_window.bordered(),
    },
  },
}
