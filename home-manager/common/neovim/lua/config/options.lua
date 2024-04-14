-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ref: https://github.com/LazyVim/LazyVim/issues/1319
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
