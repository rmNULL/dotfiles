" .vimrc
" date: 14-Jul-2017
" author(s): ehth77
""""""""
" Use Vim settings, rather than Vi settings (much better!).
" this must be first, because it changes other options as a side effect.
set nocompatible
set number
" set ruler 
set showcmd
" highlight search
set hlsearch
" go on highlighting as you type in (search) pattern
set incsearch 
" don't wrap around search
set nowrapscan 
set wildmenu


"""
" Rendering and Session
"""
set lazyredraw " don't re-draw while executing macros. (use ^L to force re-draw)
set autoread
set undofile
set undodir='~/.vim/tmp/'
set nobackup
set noswapfile
set history=50		" keep 50 lines of command line history

"""
"Editing
"""
filetype plugin indent on
" backspace over everything in insert mode, start allows for ^-w and ^-u
set backspace=indent,eol,start
set ignorecase " while searching
set pastetoggle=<F3>
set showmatch
" tenth of a second to showmatch(i.e highlight enclosing pairs)
set matchtime=2
set textwidth=79
set tildeop
" " allow h,l to wrap over lines
" set whichwrap+=h,l 


""
" Visuals (a.k.a Fancy stuff)
""
set encoding=utf-8
syntax on
set t_Co=256
" colorscheme seoul256
colorscheme gruvbox
set background=dark
autocmd vimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


"""
" MAPPINGS
"""
inoremap jk <Esc>
inoremap <c-d> <Esc>ddi
"handy while doing gui stuff
noremap <Up> :!./%<CR><CR>
noremap <Down> :!clear && ./%<CR>
"disable arrow keys
noremap <Left> <nop>
noremap <Right> <nop>
autocmd filetype c,cpp inoremap { {<CR>}<Esc>O
"highlighting and searching
"sane regexp while searching
nnoremap / /\v
vnoremap / /\v


"''
" Leadered Mappings
let mapleader=','
nnoremap ; :
"get rid of all that annoying highlights after search
nnoremap <leader><space> :noh<CR>
"strip trailing whitespaces
nnoremap <leader>\s :%s/\s\+$//<CR>
"open vimrc for editing
nnoremap <leader>vrc :tabnew $MYVIMRC<CR>
" handy (cred to amix https://github.com/amix/vimrc)
nmap <leader>w :w!<cr>
nmap <leader>x :x<cr>
nmap <leader>q :q<cr>
" reload config
nmap <leader>rr :source ~/.vimrc<cr>
" send visual selection to ScreenShell
" vmap <leader>cc :'<,'>ScreenSend<CR>


"""
" Plugin(s) managements
"""
call plug#begin('~/.vim/plugged')
Plug 'ervandew/screen'
Plug 'guns/vim-clojure-static'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'junegunn/seoul256.vim'
" Plug 'junegunn/vim-easy-align'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'

if version >= 8
	Plug 'w0rp/ale'
endif

call plug#end()


" Snippet Completion
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3

" Lint mappings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)nmap <silent> <C-j> <plug>(ale_next_wrap)

let g:ale_linters = {
\	'c':	['gcc'],
\	'haskell': ['ghc'],
\	'javascript': ['eslint'],
\	'python': ['flake8'],
\	'ruby': ['rubocop'],
\}

" Rainbow parens for lisp dialects
augroup rainbow_parens
	autocmd!
	autocmd! FileType clojure RainbowParentheses
augroup END

let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
