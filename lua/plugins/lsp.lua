return {
  "neovim/nvim-lspconfig",
  opts = {
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
