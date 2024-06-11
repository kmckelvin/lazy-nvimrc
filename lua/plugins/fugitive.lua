return {
  {
    "tpope/vim-fugitive",
    init = function()
      vim.opt.grepprg = "rg --vimgrep"
    end,
  },
  {
    "tpope/vim-rhubarb",
  },
}
