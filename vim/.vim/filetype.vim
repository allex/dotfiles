if !has("autocmd") | finish | endif

" Programming settings {{{
augroup IDE
    au!

    " shortcut for auto complete
    au BufNewFile,BufRead *.java,*.cs       inoremap <buffer> $pr private
    au BufNewFile,BufRead *.java,*.cs       inoremap <buffer> $pu public
    au BufNewFile,BufRead *.java            inoremap <buffer> $print( System.out.print();
    au BufNewFile,BufRead *.java            inoremap <buffer> $println( System.out.println();

    " Map auto complete of (, ", ', [
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap " ""<ESC>:let leavechar='"'<CR>i
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap ' ''<ESC>:let leavechar="'"<CR>i
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap ( ()<ESC>i
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap ) <c-r>=ClosePair(')')<CR>
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap { {}<ESC>i
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap } <c-r>=ClosePair('}')<CR>
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap [ []<ESC>i
    au bufnewfile,bufread *.j*,*.cs*,*.htm*,*.aspx,*.ph* inoremap ] <c-r>=ClosePair(']')<CR>

augroup END

func! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfun

" }}}

" vim: set ft=vim fdm=marker et ff=unix tw=80 sw=4:
