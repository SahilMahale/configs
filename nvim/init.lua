-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.user")
--  to make the background transparent
vim.cmd([[
augroup user_colors
  autocmd!
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
augroup END
]])
vim.cmd("colorscheme kanagawa-wave")
vim.o.termguicolors = true
