
" kanagawa_black

" Clear any existing highlights
highlight clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "kanagawa"

" Set the background to dark
set background=dark

" Define colors
let s:bg = "#1F1F28"
let s:fg = "#DCD7BA"
let s:black = "#2A2A37"
let s:red = "#E82424"
let s:green = "#98BB6C"
let s:yellow = "#E6C384"
let s:blue = "#7E9CD8"
let s:magenta = "#957FB8"
let s:cyan = "#7AA89F"
let s:white = "#DCD7BA"
let s:orange = "#FFA066"
let s:pink = "#D27E99"

" Define highlight groups
exe "hi Normal guifg=".s:fg." guibg=".s:bg
exe "hi LineNr guifg=".s:black." guibg=".s:bg
exe "hi CursorLineNr guifg=".s:magenta." guibg=".s:bg
exe "hi Cursor guifg=".s:bg." guibg=".s:fg
exe "hi CursorLine guibg=".s:black
exe "hi Search guifg=".s:bg." guibg=".s:yellow
exe "hi StatusLine guifg=".s:fg." guibg=".s:black

" Syntax highlighting
exe "hi Comment guifg=#727169"
exe "hi Constant guifg=".s:orange
exe "hi String guifg=".s:green
exe "hi Identifier guifg=".s:blue
exe "hi Function guifg=".s:blue
exe "hi Statement guifg=".s:pink
exe "hi PreProc guifg=".s:magenta
exe "hi Type guifg=".s:cyan
exe "hi Special guifg=".s:orange

" Additional highlight groups
exe "hi Visual guibg=#223249"
exe "hi VertSplit guifg=".s:black." guibg=".s:bg
exe "hi Pmenu guifg=".s:fg." guibg=#223249"
exe "hi PmenuSel guifg=".s:fg." guibg=#2D4F67"
exe "hi MatchParen guibg=#54546D"

" Diff colors
exe "hi DiffAdd guifg=".s:green." guibg=".s:bg
exe "hi DiffChange guifg=".s:yellow." guibg=".s:bg
exe "hi DiffDelete guifg=".s:red." guibg=".s:bg

" Git colors
exe "hi gitcommitSelectedFile guifg=".s:green
exe "hi gitcommitDiscardedFile guifg=".s:red

" Add more highlight groups as needed

" Link some groups to maintain consistency
hi! link SpecialKey Identifier
hi! link Directory Identifier
hi! link ErrorMsg Error
hi! link IncSearch Search
hi! link MoreMsg Special
hi! link Question Special
hi! link Title Special
hi! link WarningMsg Error
hi! link NonText Comment

" Define colors
let s:bg = "#000000"
let s:fg = "#ffffff"
let s:gray = "#9c9c9c"
let s:light_gray = "#cccccc"
let s:ruler = "#222222"
let s:scrollbar_bg = "#ffffff33"
let s:scrollbar_hover = "#ffffff4d"
let s:scrollbar_active = "#ffffff66"
let s:comment = "#6A9955"


" Tabs
exe "hi TabLine guifg=".s:gray." guibg=".s:bg
exe "hi TabLineFill guibg=".s:bg
exe "hi TabLineSel guifg=".s:fg." guibg=".s:bg." gui=bold"

" Status line
exe "hi StatusLine guifg=".s:fg." guibg=".s:bg
exe "hi StatusLineNC guifg=".s:gray." guibg=".s:bg

" Sidebar
exe "hi VertSplit guifg=".s:bg." guibg=".s:bg
exe "hi SignColumn guibg=".s:bg

" Scrollbar (for GUI vim)
exe "hi PmenuSbar guibg=".s:scrollbar_bg
exe "hi PmenuThumb guibg=".s:scrollbar_active


" Title bar (for GUI vim)
exe "hi Title guifg=".s:light_gray." guibg=".s:bg

" Additional highlight groups
exe "hi Visual guibg=".s:ruler
exe "hi Search guibg=".s:ruler." guifg=".s:fg
exe "hi IncSearch guibg=".s:fg." guifg=".s:bg

" Popup menu
exe "hi Pmenu guibg=".s:bg." guifg=".s:fg
exe "hi PmenuSel guibg=".s:ruler." guifg=".s:fg

" Folded text
exe "hi Folded guibg=".s:bg." guifg=".s:gray

" Add more highlight groups as needed

" Link some groups to maintain consistency
hi! link CursorLineNr LineNr
hi! link NonText Comment
hi! link SpecialKey Comment
