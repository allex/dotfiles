" Set the status line background color.
hi StatusLine guifg=SlateBlue guibg=Yellow
hi StatusLineNC guifg=Gray guibg=White

hi LineNr guifg=#3D3D3D guibg=black gui=NONE ctermfg=darkgray ctermbg=NONE cterm=NONE
hi Cursor guifg=black guibg=white gui=NONE ctermfg=black ctermbg=white cterm=reverse
hi StatusLine guifg=#CCCCCC guibg=#202020 gui=italic ctermfg=white ctermbg=darkgray cterm=NONE
hi StatusLineNC guifg=black guibg=#202020 gui=NONE ctermfg=blue ctermbg=darkgray cterm=NONE

hi Folded guifg=#a0a8b0 guibg=#384048 gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE

if version >= 700 " Vim 7.x specific colors
    hi CursorLine guifg=NONE guibg=#121212 gui=NONE ctermfg=NONE ctermbg=NONE cterm=BOLD
    hi CursorColumn guifg=NONE guibg=#121212 gui=NONE ctermfg=NONE ctermbg=NONE cterm=BOLD
    hi MatchParen guifg=#f6f3e8 guibg=#857b6f gui=BOLD ctermfg=white ctermbg=darkgray cterm=NONE
    hi Pmenu guifg=#f6f3e8 guibg=#444444 gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
    hi PmenuSel guifg=#000000 guibg=#cae682 gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
    hi Search guifg=#C0c000 guibg=Red gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
endif
