
" Kangawa-bones

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "kitty"

" General Colors
hi Normal                 guifg=#DDD8BB guibg=#1F1F28
hi Comment                guifg=#3C3C51 gui=italic
hi Cursor                 guifg=#1F1F28 guibg=#E6E0C2
hi CursorLine             guibg=#2A2830
hi LineNr                 guifg=#3C3C51 guibg=#1F1F28
hi StatusLine             guifg=#DDD8BB guibg=#49473E
hi StatusLineNC           guifg=#DDD8BB guibg=#363644
hi VertSplit              guifg=#363644 guibg=#1F1F28
hi TabLine                guifg=#DDD8BB guibg=#363644
hi TabLineFill            guifg=#363644 guibg=#1F1F28
hi TabLineSel             guifg=#DDD8BB guibg=#614A82

" Selection colors
hi Visual                 guifg=#DDD8BB guibg=#49473E
hi Search                 guifg=#1F1F28 guibg=#F1C982
hi IncSearch              guifg=#1F1F28 guibg=#E5C283

" Keyword, Function, and Type colors
hi Keyword                guifg=#957FB8
hi Function               guifg=#7EB3C9
hi Type                   guifg=#98BC6D
hi Statement              guifg=#E46A78

" String and Number colors
hi String                 guifg=#A98FD2
hi Number                 guifg=#F1C982

" Error and Warning colors
hi Error                  guifg=#E46A78 guibg=#1F1F28
hi WarningMsg             guifg=#F1C982 guibg=#1F1F28
hi ErrorMsg               guifg=#EC818C guibg=#1F1F28

" URL underline color when hovering with mouse
hi Underlined             guifg=#7BC2DF gui=underline

" Diff colors
hi DiffAdd                guifg=#98BC6D guibg=#1F1F28
hi DiffChange             guifg=#7EB3C9 guibg=#1F1F28
hi DiffDelete             guifg=#E46A78 guibg=#1F1F28

" LSP and diagnostic
hi DiagnosticError        guifg=#E46A78
hi DiagnosticWarning      guifg=#F1C982
hi DiagnosticInformation  guifg=#7EB3C9
hi DiagnosticHint         guifg=#98BC6D

" MatchParen and search highlighting
hi MatchParen             guifg=#DDD8BB guibg=#49473E
hi Search                 guifg=#1F1F28 guibg=#F1C982
