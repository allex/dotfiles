" vim: set ft=vim fdm=marker et ff=unix tw=80 sw=4:
" =================================================================================
"
" .vimrc file
"
" Author: Allex Wang <allex.wxn@gmail.com>
" Version: 1.7
" Last Modified: Wed Feb 07, 2018 17:24
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

" helpers {{{1
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim" | finish | endif
fun! s:run(com)
    exec 'sil! ' . a:com
endfun
fun! s:load(file)
    if filereadable(a:file) | exec 'so ' a:file | endif
endfun
fun! s:exists_plugin(name)
    return !empty(globpath(&rtp, '**/' . a:name))
endfun
" }}}

" preferences {{{1

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

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
" Also we can use `:Sts [num]` set the tab size realtime
set ts=4
set sts=4
set sw=4                        " > and < move block by 4 spaces in visual mode
set et                          " expand tabs to spaces
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
set statusline=\ %m%r%h%w<%r%{__get_cur_dir()}%h>\%=\[%{&ft},%{&ff},%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ [%l,%v,0x%B\/%L,%p%%]
fun! __get_cur_dir()
    let p = substitute(getcwd(), fnameescape($HOME), "~", "g")
    let f = expand("%f")
    return p . "/" . f
endfun

" Low priority filename suffixes for filename completion,
set suffixes-=.h
set suffixes+=.class,.tmp,.log,.aux

" Ignore these files when completing names and in explorer
set wildignore+=.svn,.hg,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.dll,*.jpg,*.jpeg,*.png,*.xpm,*.gif,*.dvi
set wildignore+=*~,#*#,*.sw?,%*,*= " Backup, auto save, swap, undo, and view files.
set wildignore+=*.DS_Store " Mac OS X

let mapleader=","

" Shared the clipbrd whith other application such as X11.
if has('unnamedplus') " When possible use + register for copy-paste
    set clipboard=unnamed,unnamedplus
else " On mac and Windows, use * register for copy-paste
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

" ctags {{{2
set tags=./.tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel 2>/dev/null'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/ctags'
endif

" Index ctags from any project, including those outside Rails
com! MakeTags :!ctags -f ./.tags -R .
" }}}

fun! s:SetColor(...)
    if a:0 > 1
        set background=a:2
    endif
    let c=a:1
    if empty(globpath(&rtp, '**/colors/' . l:c . '.vim'))
        echoerr l:c . "not found"
        " use default instead.'
        let c='desert'
    endif
    call s:run('colo ' . l:c)
    hi clear Normal
    hi clear NonText
    hi Normal ctermbg=NONE
    hi NonText ctermbg=NONE
    set nocursorline
endfun

" :SetColor completion implement
let s:allcolors = []
fun! SetColorComplete(A, L, P)
    if len(s:allcolors) == 0
        let list = split(globpath(&rtp, '**/colors/*.vim'), '\n')
        let i = 0
        for p in list
            let list[i] = substitute(p, '.*/\|.vim', '', 'g')
            let i += 1
        endfor
        let s:allcolors = list
    endif
    let result = []
    let i = 0
    while (i < len(s:allcolors))
        if (match(s:allcolors[i], a:A) == 0)
            call add(result, s:allcolors[i])
        endif
        let i += 1
    endwhile
    return result
endfun

com! -nargs=+ -complete=customlist,SetColorComplete SetColor call s:SetColor(<f-args>)

" Allow to trigger background
fun! s:ToggleBG()
    if &bg == "dark"
        set bg=light
    else
        set bg=dark
    endif
endfun

noremap <Leader>bg :call <SID>ToggleBG()<CR>

" Set colorscheme
" For more colorschemes http://vimcolorschemetest.googlecode.com/svn/
set t_Co=256
set tw=85

if has("gui_running")
    set lines=35
    set co=150
    set tw=100
    if has("win32")
        sil! colo torte
        " set guifont=Lucida_Console:h10:cANSI
    else
        sil! colo darkdevel
        " set guifont=Monospace\ 9
    endif
endif

" locale
let $LANG='en_US.UTF-8'

" }}}

" encoding {{{1
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

" vimdiff {{{1

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
endif

set diffopt+=vertical
set diffopt+=iwhite " ignore whitespace

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
" }}}

" Plugins {{{1

" NerdTree {{{2
if s:exists_plugin("nerdtree")
    nmap <silent> <F10> :NERDTreeToggle<CR>

    let NERDTreeMinimalUI=1
    let NERDTreeQuitOnOpen=1

    " colored NERD Tree
    let NERDChristmasTree=1
    let NERDTreeHighlightCursorline=1
    let NERDTreeShowHidden=1
    let NERDTreeIgnore=['\.sass-cache', '\.DS_Store','\.pdf', '.beam', '\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']

    " Add a space after the left delimiter and before the right delimiter, like this: /* int foo=2; */
    let NERDSpaceDelims=1
endif
" }}}

" ctrlp {{{2
if s:exists_plugin("ctrlp.vim")
    let g:ctrlp_map = '<c-p>'
    let g:ctrlp_cmd = 'CtrlP'
    let g:ctrlp_root_markers = ['pom.xml', '.p4ignore', '.git', '.svn', '.config']
    let g:ctrlp_working_path_mode = 'ra'
    let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components\|node_modules',
        \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$'
        \ }
endif
" }}}

" editorconfig {{{2
if s:exists_plugin("editorconfig-vim")
    let g:EditorConfig_exclude_patterns = [ "^tarfile::" ]
endif
" }}}

" ALE {{{2
if s:exists_plugin("ale")

    " Write this in your vimrc file
    let g:ale_lint_on_text_changed = 'never'

    " Run linters only when I save files and don't want linters to run on
    " opening a file
    let g:ale_lint_on_enter = 0
    let g:ale_lint_on_save = 1
    let g:ale_fix_on_save = 1

    " Customize linters & fixers
    let g:ale_linters = {
                \   'javascript': ['standard']
                \}
    let g:ale_fixers = {
                \   'javascript': ['standard'],
                \   'scss': ['prettier']
                \}
    let g:ale_javascript_prettier_options = '--no-semi --single-quote --trailing-comma none'
endif
" }}}

" misc {{{2
let Tlist_Auto_Open=0
let Tlist_Use_SingleClick=1

" Mapping for the <F8> key to toggle the taglist window.
nmap <silent> <F8> :TlistToggle<CR>

" Additionally load gist.vim only if git installed.
if !executable('git')
    let g:loaded_gist_vim=1
endif

" auto compile scss, sass files
let g:sass_compile_auto=0
" }}}

" Installation pathogen.vim (http://www.vim.org/scripts/script.php?script_id=2332)
sil! call pathogen#infect()

" }}}

" colorscheme {{{
if exists('$ITERM_PROFILE')
    if $ITERM_PROFILE =~? 'light'
        set background=light
    else
        set background=dark
    endif
    let mycolors = {
                \ "dark": [ "peaksea", "ir_black", "molokai", "solarized" ],
                \ "light": [ "default", "delek", "desert", "morning", "ekvoli", "fnaqevan", "ironman", "ocenlight", "soso", "vc"  ] }
    if &t_Co >= 8 && $TERM !~ 'linux'
        call s:SetColor("solarized")
    endif
endif
" }}}

" shortcuts {{{1
"
" Note <Leader> is the user modifier key (like g is the vim modifier key)
" One can change it from the default of \ using: let mapleader = ","

" Some commands work both in Insert mode and Command-line mode, some not
" :h map/nmap/imap/vmap

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

",p toggle paste mode
map <silent> <Leader>p :set paste!<CR>

map <silent> <F12> :conf q!<CR>

" prettier formatter
nnoremap <silent> <leader>f :silent %!prettier --stdin --trailing-comma all --single-quote<CR>

" Vertical split then hop to new buffer
nmap <silent> <Leader>h :new<CR>
nmap <silent> <Leader>v :vnew<CR>
nmap <Leader>d :vert diffsplit

" Fast saving
nmap <Leader>w :w!<CR>

" sudo write this
if executable('sudo')
    nmap <silent> <Leader>s :w !sudo tee % > /dev/null<CR>
    cmap W! silent w !sudo tee % >/dev/null <CR>
endif

" Move easily between split windows
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

"\n to turn off search highlighting
nmap <silent> <Leader>n :silent :nohlsearch<CR>

"\l to toggle (in)visible whitespace
nmap <silent> <Leader>l :set list!<CR>

" Shift+Tab to insert a hard tab
imap <S-Tab> <C-V><Tab>

" Change Working Directory to that of the current file
cmap <silent> cwd lcd %:p:h<CR>:pwd<CR>
cmap <silent> <Leader>cd :cd %:p:h<CR>:pwd<CR>

" STRIP -- EMPTY LINE ENDINGS
nmap <silent> <Leader>$ :call <SID>run("%s/\\s\\+$//e \| s/\\s\\+$//e")<CR>

" STRIP -- EMPTY LINE BEGINNINGS
nmap <silent> <Leader>^ :call <SID>run("%s/^\\s\\+//e \| s/^\\s\\+//e")<CR>

" Easily change between backslash and forward slash with <Leader>/ or <Leader>\
nmap <silent> <Leader>/ :let tmp=@/<CR>:s:\\:/:ge<CR>:let @/=tmp<CR>
nmap <silent> <Leader><Bslash> :let tmp=@/<CR>:s:/:\\:ge<CR>:let @/=tmp<CR>

" Move text, but keep highlight
vmap > ><CR>gv
vmap < <<CR>gv

" Allow deleting selection without updating the clipboard (yank buffer)
vmap x "_x
vmap X "_X

" Basically you press * or # to search for the current selection !! Really useful same as g[d|D]
vmap <silent> * :call s:VisualSearch('f')<CR>
vmap <silent> # :call s:VisualSearch('b')<CR>

nmap <F4> :w<CR>:make<CR>:cw<CR>

" More convenient copy/paste for the + register
noremap <Leader>y "+y
noremap <leader>Y "+Y
noremap <leader>p "+p
noremap <leader>P "+P

" Selecting
"
" Reselect what was just pasted so I can so something with it.
" (To reslect last selection even if it is not the last paste, use gv.)
nnoremap <Leader>y `[v`]

" Select current line, excluding leading and trailing whitespace
nnoremap vv ^vg_

" Shortcut macro
"
" DATE FUNCTIONS (insert date in format "20 Aug, 2010")
iab DATE <C-R>=strftime("%d %B %Y, %X")<CR>

com! -nargs=? ESLintFix call s:ESLintFix()
nnoremap <Leader>el :ESLintFix<CR>

fun! s:ESLintFix()
  execute "!eslint --fix %"
  edit! %
endfun

" }}}

" autocommands {{{1
if has("autocmd")

    " builtin autocmd {{{

    " Enable file type detection.
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
    " }}}

    " folding {{{
    augroup codeFolding
        au!

        au FileType javascript set commentstring=//\ %s
        au FileType javascript call s:InitJSFolderOpts()

        fun! s:InitJSFolderOpts()
            setlocal fdm=marker
            setlocal fdl=0 " Always start editing with all folds closed (value zero)
            setlocal fdls=0
            setlocal foldtext=MyFoldText()
            syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend
        endfun

        let &l:fillchars=substitute(&l:fillchars,',\?fold:.','','gi')
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

    augroup END
    " }}}

    " Last Modified {{{
    com! -nargs=0 NOMOD :let b:nomod = 1
    com! -nargs=0 MOD   :let b:nomod = 0
    au BufWritePre * call s:UpdateLastModified()

    " Upload file modifier stetement near in the first 20 lines.
    " Restores cursor and window position using save_cursor variable. ('ul' is alias
    " for 'undolevels').
    fun! s:UpdateLastModified()
        if exists('b:nomod') && b:nomod
            return
        endif
        if &modified
            let tstr = 'Last Modified: '
            let cur_pos = getpos('.')
            let n = min([30, line('$')])
            keepjumps exe '1,' . n . 's#^\(.\{,10}' . tstr . '\).*#\1' . strftime('%a %b %d, %Y %H:%M') . '#e'
            call histdel('search', -1)
            let @/ = histget('/', -1)
            call setpos('.', cur_pos)
        endif
    endfun
    " }}}

    " Enable tab switch {{{
    au VimEnter * call s:BufPos_Initialize()

    fun! s:BufPos_Initialize()
        for i in range(1, 9)
            exe "map \<C-" . i . "\> :call BufPos_ActivateBuffer(" . i . ")<CR>"
        endfor
        exe "map \<C-0\> :call BufPos_ActivateBuffer(10)<CR>"
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
    " }}}

    " Reads the template file into new buffer.
    au BufNewFile * call s:loadTemplate()
    fun! s:loadTemplate()
        sil! 0r ~/.vim/skel/%:e.tpl
    endfun

    " Disable syntax highlight if filesize is greater than 1M
    au BufRead,BufNew *
        \ if getfsize(expand('<afile>')) > 1000000 |
        \   setl syntax=off |
        \ endif

    " Customize filetypes
    au FileType ruby,eruby,yaml set ai ts=2 sw=2 sts=2 et

    " Fold current HTML tag mapping: zf
    au FileType html,xml nnoremap zf Vatzf

    au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
    au BufRead,BufNewFile *.es setf javascript
    au BufRead,BufNewFile *.node setf javascript
    au BufRead,BufNewFile *.ejs setf html
    au BufRead,BufNewFile *.vue setf html

    " fix nodejs interpreter
    au BufNewFile,BufRead * call s:DetectNodejs()
    function! s:DetectNodejs()
        if getline(1) =~ '^#!.*\<node\>'
            set filetype=javascript
        endif
    endfunction

    " for HEX editing
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | %!xxd
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | %!xxd
    au BufWritePost *.bin set nomod | endif

endif
" }}}

" customize function / commond {{{1

" Sts() {{{2
com! -nargs=? Sts call s:Sts(<f-args>)

" Set shift tab size by sts, ts, sw, (default tabsize: 2)
" author: Allex Wang (http://iallex.com)
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
fun! s:ForgetUndo()
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

" From an idea by Michael Naumann
fun! s:VisualSearch(dir) range
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

" Append a vim modeline to the end of the file
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
fun! s:AppendModeline()
    let l:modeline = printf(" vim: set fdm=%s ts=%d sw=%d sts=%d tw=%d %set :",
        \ &fdm,
        \ &tabstop, &shiftwidth, &sts, &textwidth, &expandtab ? '' : 'no')
    let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
    call append(line("$"), l:modeline)
    $s/\s\s*/ /
endfun
nnoremap <Leader>ml :call <SID>AppendModeline()<CR>
" }}}

" customizes {{{1

" filetype extends
call s:load($HOME . "/.vim/filetype.vim")

" Load customize .vimrc additionally
call s:load($HOME . "/.vimrc.local")
