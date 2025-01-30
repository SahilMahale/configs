-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("plugins.user")
--  to make the background transparent
--vim.cmd([[
-- augroup user_colors
--   autocmd!
--   autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
-- augroup END
-- ]])
--
--vim.cmd([[
--localt g:nord_contrast = v:true
--let g:nord_borders = v:true
--let g:nord_italic = v:true
--let g:nord_uniform_diff_background = v:true
--let g:nord_bold = v:true
--let g:nord_disable_background = v:false
--colorscheme nord
--]])
vim.o.termguicolors = true
-- vim.cmd([[colorscheme astrodark]])
vim.opt.background = "dark" -- set this to dark or light
vim.cmd("colorscheme poimandres")
--Transparency for oxocarbon
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
