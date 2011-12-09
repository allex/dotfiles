" vim:foldmethod=marker:tw=75
" ======================================================================================
"
" File Name:     DevToolkit.vim
" Author:        Allex Wang <x-niu@msn.com>
" Version:       1.2
" Description:   Toolkit with codes format, compressor for web develop etc,.
"                (javascript, java, c#, css)
"
" Last Modified: Fri Dec 09, 2011 05:03PM
"
" ======================================================================================

if !&cp && exists('is_devtoolkit_loaded')
    finish
endif
let is_devtoolkit_loaded = 1

if !exists('enable_auto_formater')
    let enable_auto_formater = 0
endif

augroup DevToolkit
    au!

    " Shortcut for edit current file with notepad.
    nnoremap <silent> <leader>,n :exec ':!start notepad %' <cr>

    " Html tidy definitions.
    if !&cp && !exists(":Tidy") && has("user_commands")

        au BufNewFile,BufRead *.htm*,*.jsp,*.aspx,*.xml
            \ com! -nargs=* -range=% Tidy call s:Tidy(<line1>, <line2>, <f-args>)

    endif

    if g:enable_auto_formater == 1
        au BufReadPost,FileReadPost *.js call s:Format()
    endif

    " Command definitions

    " primary commands
    com -nargs=* -range=% Format call s:Format(<line1>, <line2>, <f-args>)
    com -nargs=* -range=% GC call s:GCompiler(<line1>, <line2>, <f-args>)

    " plugin command mappings (format, compressor)
    nnoremap <silent> <c-k> :Format<cr>
    nnoremap <silent> <plug>Format :Format<cr>
    nnoremap <silent> <plug>GC :GC<cr>

augroup END

" Code formater (F) {{{1
function! s:Format(line1, line2, ...)

    " make 'patchmode' empty, we don't want a copy of the written file
    let pm_cache = &pm
    set pm =

    " set 'modifiable'
    set ma

    " when filtering the whole buffer, it will become empty
    " let empty = line("'[") == 1 && line("']") == line('$')

    let nodejs = 1

    " see also https://github.com/mishoo/UglifyJS
    let cmd = 'uglifyjs'
    let params = ''

    if !executable(cmd)
        let nodejs = 0
        let cmd = 'CodeFormater'
        let params = ' -config'
        if !executable(cmd)
            call s:ReportError('Can Not Find Extra Command `' . cmd . '`') | return -1
        endif
    endif

    if !nodejs
        " a:0 is set to the number of extra arguments (which can be 0).
        if a:0 > 0
            let arg1 = a:1
            let mode = ''

            " handle the specific argument in by the first one.
            if len(arg1) > 0 && match(arg1, '[:=]') == -1
                if &ft == 'css'
                    let mode = 'mode'
                else
                    let mode = 'preserve_newlines'
                endif
                let params .= ' ' . mode . ':' . a:1
            endif

            " get all the available parameters
            for s in a:000
                if match(s, '[:=]') != -1
                    let params .= ' ' . s
                endif
            endfor
        endif

        if params !~ ' type'
            " defaut file type detections
            let l:ft = &ft
            if l:ft == 'javascript' | let l:ft = 'js' | endif
            let params .= ' type:' . l:ft
            if l:ft == 'html'
                if !executable('js-beautify')
                    call s:ReportError('beautify toolkit not exist.') | return -1
                else
                    call s:Exec('js-beautify.cmd', '', '', a:line1, a:line2) | return -1
                endif
            endif
        endif
        call s:Exec(cmd, params, '-file', a:line1, a:line2)
    else
        " combile the params for uglifyjs
        if a:0 > 0
            " get all the available parameters
            for s in a:000
                let params .= ' ' . s
            endfor
        else
            " defaut output indented code w/o mangle variable names.
            let params .= ' -b -nm -ns --unpack'
        endif
        call s:Exec(cmd, params, '', a:line1, a:line2)
    endif

    " recover global variables
    let &pm = pm_cache
endfunction
" }}}

" Compressor, Google compiler (GC) {{{1
function! s:GCompiler(line1, line2, ...)
    if !executable('java')
        call s:ReportError('Java(TM) SE Runtime Environment Initial Failed') | return -1
    endif

    let start_line = a:line1
    let end_line = a:line2
    if a:line1 > a:line2
        let start_line = a:line2
        let end_line = a:line1
    endif

    " make 'patchmode' empty, we don't want a copy of the written file
    let pm_cache = &pm
    set pm =

    " set 'modifiable'
    set ma

    " initialize compiler dependencies vars.
    let cmd = ''
    let params = ''

    let google_compiler = $LIB . '/google-compiler.jar'
    if !isdirectory(google_compiler) && filereadable(google_compiler)
        let cmd = 'java -jar ' . google_compiler
    else
        call s:ReportError('Can not find lib: `google-compiler.jar` in directory `$LIB`') | return -1
    endif
    
    if a:0 > 0
        let arg1 = a:1
        " handle arg 0 AS WHITESPACE_ONLY
        if match(arg1, '\d') == 0
            if arg1 == '0' | let params .= ' --compilation_level WHITESPACE_ONLY' | endif
        else
        " get all the available parameters
            for s in a:000
                let params .= ' ' . s
            endfor
        endif
    endif

    " print help info
    if params =~ '--help'
        " HACK:  if line endings in the repository have been corrupted, the output
        " of the command will be confused.
        let output = substitute(system(cmd), '\r', '', 'g')
        if strlen(output)
            call s:EditFile('help')
            silent 0put = output

            " the last command left a blank line at the end of the buffer.  If the
            " last line is folded (a side effect of the 'put') then the attempt to
            " remove the blank line will kill the last fold.
            "
            " This could be fixed by explicitly detecting whether the last line is
            " within a fold, but I prefer to simply unfold the result buffer altogether.
            if has('folding')
                normal zR
            endif

            $d
            1
        endif

        return -1
    endif

    call s:Exec(cmd, params, '--js', a:line1, a:line2)

    " recover global variables
    let &pm = pm_cache
endfunction
" }}}
" s:Tidy {{{
function! s:Tidy(line1, line2, ...)
    if !executable('tidy')
        call s:ReportError('Can Not Find Extra Command `tidy`') | return -1
    endif

    let options = ''
    if a:0 > 0
        let options .= ' ' . join(a:000, ' ')
    endif
    if options !~ '-config'
        let config = $VIM . '\tidy.conf'
        if !filereadable(config)
            let config = expand('~\\tidy.conf')
        endif
        if filereadable(config)
            let options = ' -config "' . config .'"' . options
        endif
        let l:ft = &ft

        " FIX file type is XML, set the '-xml' manaully to overrice default
        " configuration, 09 November 2010, 5:53:49 PM
        if l:ft == 'xml' && options !~ '-xml'
            let options .= ' -xml'
        endif
    endif

    try
        exec 'silent ' . a:line1 . ',' . a:line2 . '!tidy' . options
    catch
        call s:ReportError(v:exception)
    endtry
endfunction
" }}}

" s:Exec {{{
function! s:Exec(cmd, option, fileFlg, line1, line2)
    let start_line = a:line1
    let end_line = a:line2

    if a:line1 > a:line2
        let start_line = a:line2
        let end_line = a:line1
    endif

    " get current source file path
    let file = expand('%:p')
    if file == ''
        let file = expand('<afile>')
    endif

    let cmd = '!' . a:cmd . a:option
    echo cmd
    if start_line > 1 || end_line < line('$')
        "
        " get the specific range selection lines.
        "
        exec 'silent ' . start_line . ',' . end_line . cmd
    else
        "
        " handle the whole file stream.
        " split and show code in a new window
        "
        g/.*/d
        exec 'silent r ' . cmd . ' ' . a:fileFlg. ' "' . file . '"'
        1,2 g/^$/d
    endif
endfunction
"}}}
" Function: s:ReportError(mapping) {{{2
" Displays the given error in a consistent faction.  This is intended to be
" invoked from a catch statement.
function! s:ReportError(error)
    echohl WarningMsg | echomsg 'DevToolkit: ' . a:error | echohl None
endfunction
" }}}

" Function: s:EditFile(name) {{{2
" Creates a new buffer of the given name.
function! s:EditFile(name)
    " creates a new buffer in new split
    rightbelow split
    enew
    setlocal buftype =nofile
    setlocal noswapfile
    if strlen(a:name) > 0
        silent noautocmd file `=a:name`
    endif
endfunction
" }}}
