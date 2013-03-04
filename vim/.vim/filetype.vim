"
" Author: Allex Wang <allex.wxn@gmail.com>
" Version: 1.6
" Last Modified: Mon Mar 04, 2013 10:31AM
"
" For details see https://github.com/allex/etc/blob/master/vim/.vimrc
"
if !has("autocmd") | finish | endif

augroup IDE
    au!

    " Shortcut for auto complete
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

    func! ClosePair(char)
        if getline('.')[col('.') - 1] == a:char
            return "\<Right>"
        else
            return a:char
        endif
    endfun
augroup END

" Cancel some specific keywords
au FileType php setlocal iskeyword-=$
au FileType sh setlocal iskeyword-=$
au FileType dosbatch setlocal iskeyword-=%

" vim: set ft=vim fdm=marker et ff=unix tw=80 sw=4:
