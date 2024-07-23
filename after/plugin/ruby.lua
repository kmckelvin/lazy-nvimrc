vim.cmd([[autocmd FileType ruby setlocal indentkeys-=.]])
vim.cmd([[autocmd FileType ruby setlocal indentkeys-={]])

vim.cmd([[command AC :execute "e " . eval("rails#buffer().alternate()")]])
