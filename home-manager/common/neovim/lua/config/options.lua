-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- ref: https://github.com/LazyVim/LazyVim/issues/1319
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"

-- https://www.reddit.com/r/neovim/comments/14e4y5p/is_there_a_way_to_make_nvim_using_absolute_line/
vim.opt.relativenumber = false
