return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      float = {
        border = "rounded",
      },
    },
    servers = {
      tsserver = {},
      standardrb = {},
      solargraph = {
        init_options = {
          formatting = false,
        },
      },
    },
  },
}
