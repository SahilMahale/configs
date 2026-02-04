-- Debug config - absolutely minimal
vim.o.number = true
vim.g.mapleader = ' '

-- Disable ALL autocommands
vim.cmd('autocmd!')

-- Disable all plugins
vim.opt.loadplugins = false

print("DEBUG MODE: No plugins, no autocmds, pure vim")

-- Add basic terraform syntax
vim.cmd([[
  augroup terraform
    autocmd!
    autocmd BufRead,BufNewFile *.tf setlocal filetype=terraform
  augroup END
]])