return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      tsserver = {},
      solargraph = {
        cmd = { "bundle", "exec", "solargraph" },
        --   -- init_options = {
        --   --   formatter = "auto",
        --   -- },
      },
    },
  },
}
