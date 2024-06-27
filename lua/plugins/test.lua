return {
  "vim-test/vim-test",
  init = function()
    vim.keymap.set("n", "<leader>tn", ":TestNearest<CR>")
    vim.keymap.set("n", "<leader>tf", ":TestFile<CR>")
    vim.keymap.set("n", "<leader>ts", ":TestSuite<CR>")
    vim.keymap.set("n", "<leader>tl", ":TestLast<CR>")
    vim.keymap.set("n", "<leader>tg", ":TestVisit<CR>")

    vim.cmd('let test#strategy="neovim"')
    vim.cmd("let test#javascript#ava#file_pattern = '\\v.*\\.ava\\.(t|j)s(x?)$'")
    vim.cmd("let test#javascript#ava#options = '--serial'")
  end,
}
