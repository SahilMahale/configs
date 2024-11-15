-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.user")
vim.cmd("colorscheme catppuccin-mocha")
vim.o.termguicolors = true
