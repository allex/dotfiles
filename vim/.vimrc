" =================================================================================
" .vimrc file
"
" Author: Allex Wang <allex.wxn@gmail.com>
" Version: 1.6
" Last Modified: Tue Aug 05, 2014 02:37PM
"
" For details see https://github.com/allex/dotfiles/blob/master/vim/.vimrc
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc
"
" Usage:
"
"  $ git clone https://github.com/allex/dotfiles.git ~/.dotfiles
"  $ ln -sfh ~/.dotfiles/vim/.vim ~/.vim
"  $ ln -sfh ~/.dotfiles/vim/.vimrc ~/.vimrc
"
" =================================================================================

" pre funcs {{{1
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim" | finish | endif

" Helper functions
fun! s:Exec(com)
    exec 'sil! ' . a:com
endfun
fun! s:Load(file)
    if filereadable(a:file) | exec 'sil! so ' a:file | endif
endfun

" preferences {{{1

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Installation pathogen.vim (http://www.vim.org/scripts/script.php?script_id=2332)
sil! call pathogen#infect()

set autoread                    " Set to auto read when a file is changed from the outside
set showfulltag                 " Get function usage help automatically
set bsdir=last                  " Use same directory as with last file browser, where a file was opened or saved

" Change the current working directory when open a file in GUI.
if has("gui_running") | set autochdir | endif

set history=400                 " keep 400 lines of command line history
set title                       " set terminal title to filename
set showcmd                     " display incomplete commands
set foldminlines=1              " (default 1)
set ruler                       " show the cursor position all the time

" set ignorecase
set nowrap
set nu
set nopaste
set incsearch
set magic
set iskeyword+=_,$,@,%

set whichwrap+=<,>,[,],h,l
set backspace=indent,eol,start  " backspace and cursor keys wrap to previous/next line
set matchpairs+=<:>             " The % command jumps from one to the other.
set vb t_vb=                    " kill the beeps! (visible bell)
set noerrorbells                " No sound on errors.
set novisualbell

" Indentation / tab replacement stuff
set et                          " expand tabs to spaces
set sts=4
set ts=4
set sw=4                        " > and < move block by 4 spaces in visual mode
set ai                          " auto indent, usefull when using the 'o' or 'O' command.
set si                          " do smart autoindenting when starting a new line Works for C-like programs

set cindent                     " use the C indenting rules
set laststatus=2                " always show the status line

" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile
set ml
set mls=5                       " enabled modelines

" Format the statusline
set statusline=\ %F%m%r%h\ %w\ CW\ %r%{CurDir()}%h\ [%Y,%{&ff},%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ \%=[%l,%v,0x%B\ \/\ %L,%p%%]
fun! CurDir()
    return substitute(getcwd(), fnameescape($HOME), "~", "g")
endfun

" Low priority filename suffixes for filename completion,
set suffixes-=.h
set suffixes+=.class,.tmp,.log,.aux

" Ignore these files when completing names and in explorer
set wildignore+=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.dvi

" Shared the clipbrd whith other application such as X11.
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

if has("win32")
    set rtp+=~/.vim
endif

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    " set mouse=a
    set selectmode=mouse
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    if version >= 600 | syntax enable | else | syntax on | endif
    set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 78,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        au FileType text setlocal tw=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event
        " handler (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the
        " default position when opening a file.
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

" Set colorscheme
" For more colorschemes http://vimcolorschemetest.googlecode.com/svn/
set t_Co=256
if has("gui_running")
    set tw=100
    set lines=35
    set co=150
    if has("win32")
        sil! colo torte
        set guifont=Lucida_Console:h10:cANSI
    else
        sil! colo darkdevel
        set guifont=Monospace\ 9
    endif
else
    set tw=85
    if &t_Co >= 8 && $TERM !~ 'linux'
        sil! colo dante
    endif
endif
hi Folded guifg=DarkBlue guibg=LightGrey

let mapleader=","

" locale
let $LANG='en_US.UTF-8'

" }}}1

" windows {{{
if has("win32")
    " reset the current language to en
    language messages en
    set langmenu=none

    " To try out your translations you first have to remove all menus.
    so $VIMRUNTIME/delmenu.vim
    so $VIMRUNTIME/menu.vim

    " Set options and add mapping such that Vim behaves a lot like MS-Windows
    so $VIMRUNTIME/mswin.vim

    " customize syntax highlighting
    call s:Load($HOME . "/.vim/custom_color.vim")
endif
" }}}
" encoding {{{
let &termencoding=&encoding
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,latin1,gbk,gb2312
if &modifiable
    set fileencoding=utf-8
endif
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
" diff configuration {{{1
set diffopt+=vertical

" diff buffers in current window
com! -nargs=0 Diff :sil! call s:ToggleDiff()
fun! s:ToggleDiff()
    if exists('b:diff') && b:diff
        let b:diff = 0
        windo diffoff | set nowrap
    else
        let b:diff = 1
        windo diffoff | diffthis
    endif
endfun

if has('win32')
    set diffexpr=MyDiff()
    fun! MyDiff()
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
        sil! exec '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfun
endif
" plugin settings {{{1

" NERD Tree
let NERDTreeMinimalUI=0

let Tlist_Auto_Open=0
let Tlist_Use_SingleClick=1

" NERD Commenter settings, 05-17-2009
" Add a space after the left delimiter and before the right delimiter, like this: /* int foo=2; */
let NERDSpaceDelims=1

" Additionally load gist.vim only if git installed.
if !executable('git')
    let g:loaded_gist_vim=1
endif
" }}}

" mappings {{{1
"
" Note <leader> is the user modifier key (like g is the vim modifier key)
" One can change it from the default of \ using: let mapleader = ","

" Some commands work both in Insert mode and Command-line mode, some not
" :h map/nmap/imap/vmap

nmap <silent> <leader>f :find<CR>

" Vertical split then hop to new buffer
nmap <silent> <leader>h :new<CR>
nmap <silent> <leader>v :vnew<CR>
nmap <silent> <leader>d :vert diffsplit

" Fast saving
nmap <leader>w :w!<CR>
if executable('sudo')
    nmap <silent> <leader>s :w !sudo tee % > /dev/null<CR>
endif

" Maps Alt-[h,j,k,l] to resizing a window split
map <silent> <A-h> <C-w><
map <silent> <A-j> <C-W>-
map <silent> <A-k> <C-W>+
map <silent> <A-l> <C-w>>

" guioptions
if has("gui_running")
    " Initial guioptions
    set guioptions+=c       " use console dialogs, not the gui ones
    set guioptions-=T       " don't show the toolbar
    set guioptions-=m       " don't show the menu
    set guioptions-=r       " don't need right scrollbar
    set guioptions-=L       " don't show left scrollbar
    set guioptions+=a       " able to paste into other applications

    " Toggle the toolbar and menu
    if has('gui_gtk')
        map <silent> <F3> :if &guioptions=~# 'T' \| set guioptions-=T \| else \| set guioptions+=T \| endif<CR>
    else
        map <silent> <F2> :if &guioptions=~# 'm' \| set guioptions-=m \| else \| set guioptions+=m \| endif<CR>
    endif
endif

" Tab navigation
map tn :tabnext<CR>
map tp :tabprevious<CR>
map td :tabnew
map te :tabedit
map tc :tabclose<CR>

" Move easily between split windows
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

map <silent> <F12> :conf q!<CR>

"\n to turn off search highlighting
nmap <silent> <leader>n :silent :nohlsearch<CR>

"\l to toggle visible whitespace
nmap <silent> <leader>l :set list!<CR>

",p toggle paste mode
map <silent> <leader>p :set paste!<CR>

" shift-tab to insert a hard tab
imap <silent> <s-tab> <c-v><tab>

" Change directory to the file being edited.
cmap <silent> ,cd :cd %:p:h<CR>:pwd<CR>

" STRIP -- EMPTY LINE ENDINGS
nmap <silent> _$ :call s:Exec("%s/\\s\\+$//e")<CR>
vmap <silent> _$ :call s:Exec("s/\\s\\+$//e")<CR>

" STRIP -- EMPTY LINE BEGINNINGS
nmap <silent> _^ :call s:Exec("%s/^\\s\\+//e")<CR>
vmap <silent> _^ :call s:Exec("s/^\\s\\+//e")<CR>

" Easily change between backslash and forward slash with <leader>/ or <leader>\
nmap <silent> <leader>/ :let tmp=@/<CR>:s:\\:/:ge<CR>:let @/=tmp<CR>
nmap <silent> <leader><Bslash> :let tmp=@/<CR>:s:/:\\:ge<CR>:let @/=tmp<CR>

" Move text, but keep highlight
vmap > ><CR>gv
vmap < <<CR>gv

" Allow deleting selection without updating the clipboard (yank buffer)
vmap x "_x
vmap X "_X

" Basically you press * or # to search for the current selection !! Really useful same as g[d|D]
vmap <silent> * :call VisualSearch('f')<CR>
vmap <silent> # :call VisualSearch('b')<CR>

nmap <F4> :w<CR>:make<CR>:cw<CR>

" Mapping for the <F8> key to toggle the taglist window.
nmap <silent> <F8> :TlistToggle<CR>
nmap <silent> <F10> :NERDTreeToggle<CR>

" DATE FUNCTIONS (insert date in format "20 Aug, 2010")
iab DATE <C-R>=strftime("%d %B %Y, %X")<CR>

" }}}

" autocommands {{{1
if has("autocmd")

    " Last Modified {{{
    " If buffer modified, update any 'Last modified: ' in the first 20 lines.
    " 'Last modified: ' can have up to 10 characters before (they are retained).
    " Restores cursor and window position using save_cursor variable. ('ul' is alias
    " for 'undolevels').
    au BufWritePre * call s:UpdateLastModified()
    com! -nargs=0 NOMOD :let b:nomod = 1
    com! -nargs=0 MOD   :let b:nomod = 0
    " }}}

    " Auto fold javascript, vim ect. {{{
    if has("folding")
        augroup FOLDSETTINGS
            let &l:fillchars=substitute(&l:fillchars,',\?fold:.','','gi')
            let Enable_JsBeautifier_Onload=0

            au!
            au FileType javascript call InitJSFolderOpts()
            au FileType javascript set commentstring=//\ %s

            fun! InitJSFolderOpts()
                setlocal fdm=marker

                " Always start editing with all folds closed (value zero)
                setlocal fdl=0
                setlocal fdls=0
                syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

                fun! MyFoldText()
                    " for now, just don't try if version isn't 7 or higher
                    if v:version < 701
                        return foldtext()
                    endif
                    " clear fold from fillchars to set it up the way we want later
                    let &l:fillchars=substitute(&l:fillchars,',\?fold:.','','gi')
                    let l:foldtext=getline(v:foldstart)
                    let l:foldtext=substitute(l:foldtext, '\/[\/\*]\+\s*', '', '')
                    return substitute(l:foldtext, '{.*', '{...}', '')
                endfun

                setlocal foldtext=MyFoldText()
            endfun
        augroup END
    endif
    " }}}

    " Enable tab switch
    au VimEnter * call s:BufPos_Initialize()
    fun! s:BufPos_Initialize()
        for i in range(1, 9)
            exe "map <M-" . i . "> :call BufPos_ActivateBuffer(" . i . ")<CR>"
        endfor
        exe "map <M-0> :call BufPos_ActivateBuffer(10)<CR>"
    endfun
    fun! BufPos_ActivateBuffer(num)
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

    " Reads the template file into new buffer.
    au BufNewFile * call s:LoadTemplate()
    fun! s:LoadTemplate()
        sil! 0r ~/.vim/skel/%:e.tpl
    endfun
endif
" }}}

" customize function / commond {{{1
" Sts() {{{2
com! -nargs=? Sts call s:Sts(<args>)

"
" Set shift tab size by sts, ts, sw, (default tabsize: 2)
" Author: Allex Wang (http://iallex.com)
"
fun! s:Sts(...)
    let l:n = 2
    if a:0 > 0
        let l:n = a:1
    endif
    set et
    let &ts=l:n
    let &sw=l:n
    let &sts=l:n
endfun

" Reset() {{{2
com! -nargs=0 Reset call <SID>ForgetUndo()

" clear the undo history
fun! <SID>ForgetUndo()
    let old_ul = &undolevels
    set undolevels=-1
    exe "sil! normal a \<BS>\<Esc>"
    w
    let &undolevels = old_ul
    unlet old_ul
endfun

" Grep() {{{2
com! -nargs=* Grep call s:Grep(<f-args>)

" Deep serach by a specific pattern
fun! s:Grep(...)
    "
    " Native vimgrep function extendssion, some regular-expression will be
    " escaped.
    " Author: Allex Wang (http://iallex.com)
    "
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
    exec 'sil! vimgrep /' . escape(l:word, "*+./[]") . '/j **/*.' . l:ext | copen
endfun

" Save() / LoadSession() {{{2
set ssop=buffers,sesdir,tabpages,winpos,winsize

com! -nargs=? Save call s:SaveSession(<f-args>)
com! -nargs=? LoadSession call s:LoadSession(<f-args>)

" F6 to restores the session.
nmap <F6> :LoadSession <CR>

"
" functions to save and load current workspace session.
" Author: Allex Wang (http://iallex.com)
"
fun! s:LoadSession(...)
    let fname = '.session.vim'
    if a:0 > 0
        let fname = a:1
    endif
    let sfile = expand('%:p:h') . '/' . fname
    if !filereadable(sfile)
        let sfile = getcwd() . '/' . fname
    endif
    if filereadable(sfile)
        exec 'sil! so ' . sfile
    else
        echo 'session file (' . sfile . ') not exists'
    endif
endfun
fun! s:SaveSession(...)
    let fname = '.session.vim'
    if a:0 > 0
        let fname = a:1
    endif
    let sfile = getcwd() . '/' . fname
    exec 'sil! mks! ' . sfile
    echo 'session saved: ' . sfile
endfun

" }}}1

" functions {{{1

" Update last modified section
fun! s:UpdateLastModified()
    if exists('b:nomod') && b:nomod
        return
    endif
    if &modified
        let tstr = 'Last Modified: '
        let cur_pos = getpos('.')
        let n = min([20, line('$')])
        keepjumps exe '1,' . n . 's#^\(.\{,10}' . tstr . '\).*#\1' . strftime('%a %b %d, %Y %I:%M%p') . '#e'
        call histdel('search', -1)
        let @/ = histget('/', -1)
        call setpos('.', cur_pos)
    endif
endfun

" @VisualSearch(dir)
" From an idea by Michael Naumann
fun! VisualSearch(dir) range
    let l:saved_reg=@"
    exec "normal! vgvy"

    let l:pattern=escape(@", '\\/.*$^~[]')
    let l:pattern=substitute(l:pattern, "\n$", "", "")

    if a:dir == 'b'
        exec "normal ?" . l:pattern . "^M"
    else
        exec "normal /" . l:pattern . "^M"
    endif

    let @/=l:pattern
    let @"=l:saved_reg
endfun

" }}}

" customizes {{{1

" filetype extends
call s:Load($HOME . "/.vim/filetype.vim")

" Load customize .vimrc additionally
if filereadable(expand("~/.vimrc.local"))
    call s:Load("~/.vimrc.local")
endif

" vim: set ft=vim fdm=marker et ff=unix tw=80 sw=4:
