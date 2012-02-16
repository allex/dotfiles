" .vimrc file {{{
"
" vim: set ft=vim fdm=marker et ff=unix:
"
" =================================================================================
" Vim configuration file
"
" Maintainer: Allex <allex.wxn@gmail.com>
" Version: 1.6
" Last Modified: Mon Feb 13, 2012 12:01PM
"
" For details see https://github.com/allex/etc/blob/master/vim/.vimrc
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc
"
" ln -s ~/.etc/vim/.vimrc ~/.vimrc
"
" Tip:
"  If you find anything that you can't understand than do this:
"  help keyword OR helpgrep keywords
"
" Example:
"  Go into command-line mode and type helpgrep nocompatible, ie.
"  :helpgrep nocompatible
"  then press <leader>c to see the results, or :botright cw
"
" Help Document:
"  How to use folds in vim
"  http://tuxtraining.com/2009/04/10/how-to-use-folds-in-vim
"
" =================================================================================
" }}}

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim" | finish | endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Set to auto read when a file is changed from the outside
set autoread

" Get function usage help automatically
set showfulltag

" Use same directory as with last file browser, where a file was opened or saved
set bsdir=last

set history=400                 " keep 400 lines of command line history
set title                       " set terminal title to filename
set showcmd                     " display incomplete commands
set foldminlines=1
set nu
set ruler                       " ashow the cursor position all the time

" Highlighted the matched string is when typing a search command,
set incsearch
set magic
set iskeyword+=_,$,@,%,-

" Ignore case when searching
" set ignorecase

" Change the current working directory whenever you open a file
" set autochdir

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,],h,l

" The % command jumps from one to the other.
set matchpairs+=<:>

set vb t_vb=                    " kill the beeps! (visible bell)
set noerrorbells                " No sound on errors.
set novisualbell
set nopaste

" Indentation / tab replacement stuff
set sts=4
set shiftwidth=4                " > and < move block by 4 spaces in visual mode
set tabstop=4
set expandtab                   " expand tabs to spaces
set wrap!

set autoindent                  " auto indent, usefull when using the 'o' or 'O' command.
set si                          " Do smart autoindenting when starting a new line Works for C-like programs
set cindent                     " use the C indenting rules

" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

set laststatus=2

" Format the statusline
set statusline=\ %F%m%r%h\ %w\ CW\ %r%{CurDir()}%h\ [%Y,%{&ff},%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ \%=[%l,%v,%p%%,\ %L\ \%P]
func! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "g")
    return curdir
endfun

" Low priority filename suffixes for filename completion,
" The default is ".bak,~,.o,.h,.info,.swp,.obj"
set suffixes-=.h
set suffixes+=.class,.tmp,.log,.aux

" Ignore these files when completing names and in explorer
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.dvi

" normalize {{{1

" Shared the clipbrd whith other application such as X11.
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
    set selectmode=mouse
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    if version >= 600 | syntax enable | else | syntax on | endif
    set hlsearch
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
    augroup END
else
    set autoindent      " always set autoindenting on
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

"
" Set color scheme
" For more colorschemes http://vimcolorschemetest.googlecode.com/svn/
"
if has("gui_running")
    set tw=100
    set lines=35
    set co=150
    if has("win32")
        colo torte
        set guifont=Lucida_Console:h10:cANSI
    else
        " pablo skittles_dark
        colo darkdevel
        hi Folded guibg=grey30 guifg=#bbbbbb
    endif
else
    colo dante
    set tw=75
endif

let mapleader=","

" locale
let $LANG='en_US.UTF-8'

" windows {{{
if has("win32")

    " reset the current language to en
    language messages en
    " language time en
    set langmenu=none

    " To try out your translations you first have to remove all menus.
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " Set options and add mapping such that Vim behaves a lot like MS-Windows
    source $VIMRUNTIME/mswin.vim

    " Highlight the screen line of the cursor with CursorLine
    " set cursorline

    " Syntax Highlighting {{{

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
    " }}}

endif " end windows }}}

" encoding {{{
let &termencoding=&encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,latin1,gbk,gb2312 " set bomb
if has("multi_byte")
    " CJK environment detection and corresponding setting
    if v:lang =~ "^zh_CN"
        set fileencodings=cp936
    elseif v:lang =~ "^zh_TW"
        set encoding=big5
        set fileencodings=big5
    elseif v:lang =~ "^ko"
        set fileencodings=euc-kr
    elseif v:lang =~ "^ja_JP"
        set fileencodings=euc-jp
    endif

    " Detect UTF-8 locale, and replace CJK setting if needed
    if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
        set fileencodings=utf-8,latin1
    endif
    if v:lang =~? '^\(zh\)\|\(ja\)\|\(ko\)'
        set ambiwidth=double
    endif

    set formatoptions+=mM
else
    echoerr "Sorry, this version of (g)vim was not compiled with multi_byte!"
endif
" }}}

" diff {{{
set diffopt+=vertical
if has('win32')
    set diffexpr=MyDiff()
    function! MyDiff()
        let opt='-a --binary '
        if &diffopt =~ 'icase' | let opt=opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt=opt . '-b ' | endif
        let arg1=v:fname_in
        if arg1 =~ ' ' | let arg1='"' . arg1 . '"' | endif
        let arg2=v:fname_new
        if arg2 =~ ' ' | let arg2='"' . arg2 . '"' | endif
        let arg3=v:fname_out
        if arg3 =~ ' ' | let arg3='"' . arg3 . '"' | endif
        let eq=''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd='""' . $VIMRUNTIME . '\diff"'
                let eq='"'
            else
                let cmd=substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd=$VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfun
endif
" }}}

" plugin settings {{{

" NERD Tree
let Tlist_Auto_Open=0
let Tlist_Use_SingleClick=1

" NERD Commenter settings, 05-17-2009
" Add a space after the left delimiter and before the right delimiter, like this: /* int foo=2; */
let NERDSpaceDelims=1

" }}}

" mappings {{{
"
" Note <leader> is the user modifier key (like g is the vim modifier key)
" One can change it from the default of \ using: let mapleader = ","

" Some commands work both in Insert mode and Command-line mode, some not
" :h map/nmap/imap/vnoremap/nnoremap

nmap <leader>f :find<CR>

" Fast saving
nmap <leader>w :w!<CR>
if executable('sudo')
    nmap <silent> <leader>s :w !sudo tee %<CR>
endif

" Vertical split then hop to new buffer
nmap <leader>h :new<CR>
nmap <leader>v :vnew<CR>

" Maps Alt-[h,j,k,l] to resizing a window split
map <silent> <A-h> <C-w><
map <silent> <A-j> <C-W>-
map <silent> <A-k> <C-W>+
map <silent> <A-l> <C-w>>

" GUI Options:
if has("gui_running")

    " Hide menu, toolbar
    set guioptions-=m
    set guioptions-=T

    " Able to paste into other applications
    set guioptions+=a

    " Use console messages instead of GUI dialogs
    set guioptions+=c

    " Toggle the toolbar & menu (set guioptions+=T)
    map <silent> <F2> :if &guioptions=~# 'm' <Bar> set guioptions-=m <Bar>
                \else <Bar> set guioptions+=m <Bar> endif<CR>
endif

" Grep command
com -nargs=* Grep call s:Grep(<f-args>)
func! s:Grep(...)
    if a:0 > 0
        let word = a:1
    else
        let word = expand("<cword>")
    endif
    if a:0 > 1
        let ext = a:2
    else
        let ext = expand('%:e')
    endif
    execute 'sil! vimgrep /\<' . l:word . '\>/j **/*.' . l:ext | copen
endfun

" tab shortcut
map tn :tabnext<CR>
map tp :tabprevious<CR>
map td :tabnew
map te :tabedit
map tc :tabclose<CR>

"\n to turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>

"\l to toggle visible whitespace
nmap <silent> <leader>l :set list!<CR>

" shift-tab to insert a hard tab
imap <silent> <s-tab> <c-v><tab>

" Change directory to the file being edited.
cmap <silent> ,cd :cd %:p:h<CR>:pwd<CR>

" Set abbreviations

" DATE FUNCTIONS (insert date in format "20 Aug, 2010")
iab $date <C-R>=strftime("%d %B %Y, %X")<CR>

" STRIP -- EMPTY LINE ENDINGS
nmap <silent> _$ :call Exec("%s/\\s\\+$//e")<CR>
vmap <silent> _$ :call Exec("s/\\s\\+$//e")<CR>

" STRIP -- EMPTY LINE BEGINNINGS
nmap <silent> _^ :call Exec("%s/^\\s\\+//e")<CR>
vmap <silent> _^ :call Exec("s/^\\s\\+//e")<CR>
fun! Exec(com)
    exec 'silent ' . a:com
endfun

" Easily change between backslash and forward slash with <leader>/ or <leader>\
nnoremap <silent> <leader>/ :let tmp=@/<CR>:s:\\:/:ge<CR>:let @/=tmp<CR>
nnoremap <silent> <leader><Bslash> :let tmp=@/<CR>:s:/:\\:ge<CR>:let @/=tmp<CR>

" Move text, but keep highlight
vnoremap > ><CR>gv
vnoremap < <<CR>gv

" Allow deleting selection without updating the clipboard (yank buffer)
vnoremap x "_x
vnoremap X "_X

" Basically you press * or # to search for the current selection !! Really useful same as g[d|D]
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

nnoremap <silent> <F5> :exec ":!javac -encoding UTF-8 % & java -Dfile.encoding=GBK %:r" <CR>

" Mapping for the <F8> key to toggle the taglist window.
nnoremap <silent> <F8> :TlistToggle<CR>
map <F10> :NERDTreeToggle<CR>
map <F12> :q!<CR>

" A function to clear the undo history
command -nargs=0 Reset call <SID>ForgetUndo()
func! <SID>ForgetUndo()
    let old_ul = &undolevels
    set undolevels=-1
    exe "silent normal a \<BS>\<Esc>"
    let &undolevels = old_ul
    unlet old_ul
endfun

"}}}

" autocommands {{{
if has("autocmd")

    " Last Modified {{{
    " If buffer modified, update any 'Last Modified: ' in the first 20 lines.
    " 'Last modified: ' can have up to 10 characters before (they are retained).
    " Restores cursor and window position using pos variable.
    function! LastModified()
        if exists('b:nomod') && b:nomod
            return
        end
        if &modified
            let timeStampLeader = 'Last Modified: '
            let pos = getpos('.')
            0
            let searchPos = search(timeStampLeader, '', 40)
            if searchPos > 0
                keepjumps exe searchPos . 's#^\(.\{,10}' . timeStampLeader . '\).*#\1' .
                            \ strftime('%a %b %d, %Y %I:%M%p') . '#e'
                call histdel('search', -1)
                let @/ = histget('/', -1)
            endif
            call setpos('.', pos)
        endif
    endfun

    autocmd BufWritePre * call LastModified()

    " Modify the commands
    com! -nargs=0 NOMOD :let b:nomod = 1
    com! -nargs=0 MOD   :let b:nomod = 0
    " }}}

    " Programming settings {{{
    augroup IDE
        " Remove all cprog autocommands
        au!
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

        " inoremap < <><ESC>i
        " inoremap > <c-r>=ClosePair('>')<CR>
    augroup END

    " }}}

    " Auto fold javascript, vim ect. {{{
    if has("folding")
        augroup FOLDSETTINGS
            let &l:fillchars=substitute(&l:fillchars,',\?fold:.','','gi')
            let Enable_JsBeautifier_Onload=0
            au!
            au FileType javascript call JavaScriptFold()
            au FileType javascript set commentstring=//\ %s
        augroup END
    endif
    " }}}

    " Enable tab switch
    autocmd VimEnter * call BufPos_Initialize()

    " Remove the newline at end of file
    " augroup EOL
    "     autocmd BufWritePre * call EolSavePre()
    "     autocmd BufWritePost * call EolSavePost()
    "     func! EolSavePre()
    "         let b:save_bin=&bin
    "         if ! &eol
    "             let &l:bin=1
    "         endif
    "     endfun
    "     func! EolSavePost()
    "         let &l:bin=b:save_bin
    "     endfun
    " augroup END

    if has("gui_running") == 0
        " Saves the current session, and map F6 to restores the session.
        set ssop=buffers,sesdir,tabpages,winpos,winsize
        let $VIMSESSION = '~/.session.vim'
        au VimLeave * mks! $VIMSESSION
        nmap <F6> :so $VIMSESSION<CR>
    endif

endif
" }}}

" internal funcs {{{

" @VisualSearch(direction)
" From an idea by Michael Naumann
func! VisualSearch(direction) range
    let l:saved_reg=@"
    execute "normal! vgvy"

    let l:pattern=escape(@", '\\/.*$^~[]')
    let l:pattern=substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    else
        execute "normal /" . l:pattern . "^M"
    endif

    let @/=l:pattern
    let @"=l:saved_reg
endfun
" @ClosePair(char)
function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf
" @JavaScriptFold()
func! JavaScriptFold()
    setlocal foldmethod=marker
    " always start editing with all folds closed (value zero)
    setlocal foldlevelstart=0
    setlocal foldlevel=0
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
    func! MyFoldText()
        " for now, just don't try if version isn't 7 or higher
        if v:version < 701
            return foldtext()
        endif
        " clear fold from fillchars to set it up the way we want later
        let &l:fillchars=substitute(&l:fillchars,',\?fold:.','','gi')
        let l:foldtext=getline(v:foldstart)
        let l:foldtext=substitute(l:foldtext, '[\/\*]\+\s*', '', '')
        return substitute(l:foldtext, '{.*', '{...}', '')
    endfun
    setlocal foldtext=MyFoldText()
endfun
" @BufPos_ActivateBuffer(num)
func! BufPos_ActivateBuffer(num)
    let l:count=1
    for i in range(1, bufnr("$"))
        if buflisted(i) && getbufvar(i, "&modifiable")
            if l:count == a:num
                exe "buffer " . i
                return
            endif
            let l:count=l:count + 1
        endif
    endfor
    echo "No buffer!"
endfun
" @BufPos_Initialize()
func! BufPos_Initialize()
    for i in range(1, 9)
        exe "map <M-" . i . "> :call BufPos_ActivateBuffer(" . i . ")<CR>"
    endfor
    exe "map <M-0> :call BufPos_ActivateBuffer(10)<CR>"
endfun
"}}}
