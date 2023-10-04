
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
" Disable highlight
map <leader><space> :noh<cr>:call clearmatches()<cr>
runtime macros/matchit.vim
nmap <tab> %
vmap <tab> %

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
"inoremap jk <esc>

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
nnoremap <leader>' yypVr~

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

let g:airline_powerline_fonts = 1

" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Use Node.js for JavaScript interpretation
let $JS_CMD='node'

" Highlight Word --------------------------------------------------------- {{{
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily. You can search for it, but that only
" gives you one color of highlighting. Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.

function! HiInterestingWord(n) " {{{
" Save our location.
    normal! mz

" Yank the current word into the z register.
    normal! "zyiw

" Calculate an arbitrary match ID. Hopefully nothing else is using it.
    let mid = 86750 + a:n

" Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

" Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

" Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

" Move back to our original location.
    normal! `z
endfunction " }}}

" Mappings {{{

nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>

" }}}
" Default Highlights {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

" }}}
" }}}

au BufNewFile,BufRead *.mako set filetype=html

" Fix the git-gutter column color
hi clear SignColumn

let g:indentLine_char = '|'
let g:indentLine_color_term = 235
let g:indentLine_color_term = 239
let g:indentLine_color_dark = 4
let g:indentLine_enabled = 1
" don't collapse links in markdown
let g:indentLine_setConceal = 0

" move close bracket to third line and put cursor at second line
autocmd FileType javascript inoremap {<CR> {<CR>}<Esc><S-o>
autocmd FileType less inoremap {<CR> {<CR>}<Esc><S-o>

" Set some default values for indentation
au FileType md setlocal ts=2 sts=2 sw=2 expandtab
au FileType html setlocal ts=2 sts=2 sw=2 expandtab
au FileType js setlocal ts=2 sts=2 sw=2 expandtab
au FileType mako setlocal ts=2 sts=2 sw=2 expandtab

" Change default vim update time
" Useful for gitgutter
set updatetime=250

" Disable auto folding in markdown
let g:vim_markdown_folding_disabled = 1

" Disable auto folding in vue
let g:vim_vue_plugin_use_foldexpr=0

let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['vue'] = ['prettier']

" automatically fix files on save
let g:ale_fix_on_save = 1

nmap <silent> <leader>j <Plug>(ale_previous_wrap)
nmap <silent> <leader>k <Plug>(ale_next_wrap)

" install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" deoplete
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" deoplete with javascript
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern', 'for': ['javascript', 'javascript.jsx'] }

" CoC Conquer of Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'yaegassy/coc-volar', {'do': 'yarn install --frozen-lockfile'}
Plug 'yaegassy/coc-volar-tools', {'do': 'yarn install --frozen-lockfile'}

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
map <C-p> :FZF <Enter>

" NERDTree
Plug 'preservim/nerdtree'
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Initialize plugin system
call plug#end()

let g:deoplete#enable_at_startup = 1

" Backup copy, avoid issues with webpack watching mechanism
set backupcopy=yes

" Spelling for commit messages
autocmd FileType gitcommit setlocal spelllang=en spell
