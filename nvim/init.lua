-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.user")
vim.cmd("colorscheme kanagawa-wave")
vim.o.termguicolors = true
