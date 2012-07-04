
call pathogen#runtime_append_all_bundles()
call pathogen#infect()
filetype plugin indent on

set nocompatible

" Backups {{{
if v:version >= 703
    set undofile
    set undodir=./.tmp,/tmp
else
    let g:gundo_disable = 1
endif
set backupdir=./.tmp,.,/tmp
set directory=./.tmp,/tmp
set history=500
set undolevels=500
" }}}

" Statusline {{{
    " Functions {{{
        " Statusline updater {{{
            " Inspired by StatusLineHighlight by Ingo Karkat
            function! s:StatusLine(new_stl, type, current)
                let current = (a:current ? "" : "NC")
                let type = a:type
                let new_stl = a:new_stl

                " Prepare current buffer specific text
                " Syntax: <CUR> ... </CUR>
                let new_stl = substitute(new_stl, '<CUR>\(.\{-,}\)</CUR>', (a:current ? '\1' : ''), 'g')

                " Prepare statusline colors
                " Syntax: #[ ... ]
                let new_stl = substitute(new_stl, '#\[\(\w\+\)\]', '%#StatusLine'.type.'\1'.current.'#', 'g')

                if &l:statusline ==# new_stl
                    " Statusline already set, nothing to do
                    return
                endif

                if empty(&l:statusline)
                    " No statusline is set, use my_stl
                    let &l:statusline = new_stl
                else
                    " Check if a custom statusline is set
                    let plain_stl = substitute(&l:statusline, '%#StatusLine\w\+#', '', 'g')

                    if &l:statusline ==# plain_stl
                        " A custom statusline is set, don't modify
                        return
                    endif

                    " No custom statusline is set, use my_stl
                    let &l:statusline = new_stl
                endif
            endfunction
        " }}}
        " Color dict parser {{{
            function! s:StatusLineColors(colors)
                for type in keys(a:colors)
                    for name in keys(a:colors[type])
                        let colors = {'c': a:colors[type][name][0], 'nc': a:colors[type][name][1]}
                        let type = (type == 'NONE' ? '' : type)
                        let name = (name == 'NONE' ? '' : name)

                        if exists("colors['c'][0]")
                            exec 'hi StatusLine'.type.name.' ctermbg='.colors['c'][0].' ctermfg='.colors['c'][1].' cterm='.colors['c'][2]
                        endif

                        if exists("colors['nc'][0]")
                            exec 'hi StatusLine'.type.name.'NC ctermbg='.colors['nc'][0].' ctermfg='.colors['nc'][1].' cterm='.colors['nc'][2]
                        endif
                    endfor
                endfor
            endfunction
        " }}}
    " }}}
    " Default statusline {{{
        let g:default_stl  = ""
        let g:default_stl .= "<CUR>#[Mode] %{&paste ? 'PASTE  ' : ''}%{substitute(mode(), '', '', 'g')} #[ModeS]</CUR>"
        let g:default_stl .= "#[ModFlag]%{&readonly ? 'RO ' : ''}" " RO flag
        let g:default_stl .= " #[FileName]%t " " File name
        let g:default_stl .= "#[ModFlag]%(%M %)" " Modified flag
        let g:default_stl .= "#[BufFlag]%(%H%W %)" " HLP,PRV flags
        let g:default_stl .= "#[FileNameS] " " Separator
        let g:default_stl .= "#[FunctionName] " " Padding/HL group
        let g:default_stl .= "%<" " Truncate right
        let g:default_stl .= "%= " " Right align
        let g:default_stl .= "<CUR>#[FileFormat]%{&fileformat} </CUR>" " File format
        let g:default_stl .= "<CUR>#[FileEncoding]%{(&fenc == '' ? &enc : &fenc)} </CUR>" " File encoding
        let g:default_stl .= "<CUR>#[Separator]  ⊂ #[FileType]%{strlen(&ft) ? &ft : 'n/a'} </CUR>" " File type
        let g:default_stl .= "#[LinePercentS] #[LinePercent] %p%% " " Line/column/virtual column, Line percentage
        let g:default_stl .= "#[LineNumberS] #[LineNumber]  %l#[LineColumn]:%c%V " " Line/column/virtual column, Line percentage
        let g:default_stl .= "%{exists('g:synid') && g:synid ? ' '.synIDattr(synID(line('.'), col('.'), 1), 'name').' ' : ''}" " Current syntax group
    " }}}
    " Color dict {{{
        let s:statuscolors = {
            \   'NONE': {
                \   'NONE'         : [[ 236, 231, 'bold'], [ 232, 244, 'none']]
            \ }
            \ , 'Normal': {
                \   'Mode'         : [[ 214, 235, 'bold'], [                 ]]
                \ , 'ModeS'        : [[ 214, 240, 'bold'], [                 ]]
                \ , 'Branch'       : [[ 240, 250, 'none'], [ 234, 239, 'none']]
                \ , 'BranchS'      : [[ 240, 246, 'none'], [ 234, 239, 'none']]
                \ , 'FileName'     : [[ 240, 231, 'bold'], [ 234, 244, 'none']]
                \ , 'FileNameS'    : [[ 240, 236, 'bold'], [ 234, 232, 'none']]
                \ , 'Error'        : [[ 240, 202, 'bold'], [ 234, 239, 'none']]
                \ , 'ModFlag'      : [[ 240, 196, 'bold'], [ 234, 239, 'none']]
                \ , 'BufFlag'      : [[ 240, 250, 'none'], [ 234, 239, 'none']]
                \ , 'FunctionName' : [[ 236, 247, 'none'], [ 232, 239, 'none']]
                \ , 'FileFormat'   : [[ 236, 244, 'none'], [ 232, 239, 'none']]
                \ , 'FileEncoding' : [[ 236, 244, 'none'], [ 232, 239, 'none']]
                \ , 'Separator'    : [[ 236, 242, 'none'], [ 232, 239, 'none']]
                \ , 'FileType'     : [[ 236, 248, 'none'], [ 232, 239, 'none']]
                \ , 'LinePercentS' : [[ 240, 236, 'none'], [ 234, 232, 'none']]
                \ , 'LinePercent'  : [[ 240, 250, 'none'], [ 234, 239, 'none']]
                \ , 'LineNumberS'  : [[ 252, 240, 'bold'], [ 234, 234, 'none']]
                \ , 'LineNumber'   : [[ 252, 236, 'bold'], [ 234, 244, 'none']]
                \ , 'LineColumn'   : [[ 252, 240, 'none'], [ 234, 239, 'none']]
            \ }
            \ , 'Insert': {
                \   'Mode'         : [[ 153,  23, 'bold'], [                 ]]
                \ , 'ModeS'        : [[ 153,  31, 'bold'], [                 ]]
                \ , 'Branch'       : [[  31, 117, 'none'], [                 ]]
                \ , 'BranchS'      : [[  31, 117, 'none'], [                 ]]
                \ , 'FileName'     : [[  31, 231, 'bold'], [                 ]]
                \ , 'FileNameS'    : [[  31,  24, 'bold'], [                 ]]
                \ , 'Error'        : [[  31, 202, 'bold'], [                 ]]
                \ , 'ModFlag'      : [[  31, 196, 'bold'], [                 ]]
                \ , 'BufFlag'      : [[  31,  75, 'none'], [                 ]]
                \ , 'FunctionName' : [[  24, 117, 'none'], [                 ]]
                \ , 'FileFormat'   : [[  24,  75, 'none'], [                 ]]
                \ , 'FileEncoding' : [[  24,  75, 'none'], [                 ]]
                \ , 'Separator'    : [[  24,  37, 'none'], [                 ]]
                \ , 'FileType'     : [[  24,  81, 'none'], [                 ]]
                \ , 'LinePercentS' : [[  31,  24, 'none'], [                 ]]
                \ , 'LinePercent'  : [[  31, 117, 'none'], [                 ]]
                \ , 'LineNumberS'  : [[ 117,  31, 'bold'], [                 ]]
                \ , 'LineNumber'   : [[ 117,  23, 'bold'], [                 ]]
                \ , 'LineColumn'   : [[ 117,  31, 'none'], [                 ]]
            \ }
        \ }
    " }}}
" }}}

" Statusline highlighting {{{
augroup StatusLineHighlight
    autocmd!

    let s:round_stl = 0

    au ColorScheme * call <SID>StatusLineColors(s:statuscolors)
    au BufEnter,BufWinEnter,WinEnter,CmdwinEnter,CursorHold,BufWritePost,InsertLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 1)
    au BufLeave,BufWinLeave,WinLeave,CmdwinLeave * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 0)
    au InsertEnter,CursorHoldI * call <SID>StatusLine((exists('b:stl') ? b:stl : g:default_stl), 'Insert', 1)
augroup END
" }}}

augroup General " {{{
    autocmd!
    " Help file settings {{{
        function! s:SetupHelpWindow()
            wincmd L
            vertical resize 80
            setl nonumber winfixwidth colorcolumn=

            let b:stl = "#[Branch] HELP#[BranchS] [>] #[FileName]%<%t #[FileNameS][>>]%* %=#[LinePercentS][<<]#[LinePercent] %p%% " " Set custom statusline

            nnoremap <buffer> <Space> <C-]> " Space selects subject
            nnoremap <buffer> <BS>    <C-T> " Backspace to go back
        endfunction

        au FileType help au BufEnter,BufWinEnter <buffer> call <SID>SetupHelpWindow()
    " }}}
augroup END " }}}

" Pulse {{{
function! PulseCursorLine()
    let current_window = winnr()

    windo set nocursorline
    execute current_window . 'wincmd w'

    setlocal cursorline

    redir => old_hi
        silent execute 'hi CursorLine'
    redir END
    let old_hi = split(old_hi, '\n')[0]
    let old_hi = substitute(old_hi, 'xxx', '', '')

    execute 'hi ' . old_hi

    windo set cursorline
    execute current_window . 'wincmd w'
endfunction

" }}}

" appearance options
set t_Co=256
colorscheme molokai

" Security
set modelines=0

" Tabs/spaces
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Special filetype conf
au FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Basic options
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set number
set pastetoggle=<F2>

" Leader
let mapleader = ","

" Searching
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set incsearch
set showmatch
set hlsearch
set gdefault
map <leader><space> :noh<cr>
runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %
" PulseCursorLine {{{
nnoremap n nzzzv:call PulseCursorLine()<cr>
nnoremap N Nzzzv:call PulseCursorLine()<cr>
" }}}

" Soft/hard wrapping
set wrap
set textwidth=79
set formatoptions=qrn1

" Use the same symbols as TextMate for tabstops and EOLs
set list
set listchars=tab:▸\

" Color scheme (terminal)
syntax on

" Use the damn hjkl keys, never use the arrow keys ! Never ever !
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" And make them fucking work, too.
nnoremap j gj
nnoremap k gk

" Fuck you, help key.
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Remapping esc key
inoremap jk <esc>

" Save when losing focus
au FocusLost * :wa

" Easier linewise reselection
map <leader>v V`]

" Splits / Open file in the same directory as current file
map <leader>ew :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
map <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>

" Easy splits navigation
map <C-h> <C-w>h
map <C-l> <C-w>l

" From tab to vsplit
nnoremap <c-w>V mAZZ<c-w>v`A

" Insert <Tab> or complete identifier
" if the cursor is after a keyword character
function! MyTabOrComplete()
    let col = col('.')-1
    if !col || getline('.')[col-1] !~ '\k'
         return "\<tab>"
    else
         return "\<C-N>"
    endif
endfunction
inoremap <Tab> <C-R>=MyTabOrComplete()<CR>

" text titles and doc helpers
nnoremap <leader>é yypVr=
nnoremap <leader>" yypVr-

" Surround shortcut
nmap <leader>& ysiw

" Bubble single lines
nmap <C-k> [e
nmap <C-j> ]e
" Bubble multiple lines
vmap <C-k> [egv
vmap <C-j> ]egv

" yank and leave the cursor at the end of a visual selection
:vnoremap gy y`> 

" sudo save
cmap w!! w !sudo tee % >/dev/null

" Here are some abbreviations
iabbrev cl console.log

if v:version >= 703
    set relativenumber
    set cc=80
    hi ColorColumn ctermbg=234
endif
