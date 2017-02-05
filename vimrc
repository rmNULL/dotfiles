" .vimrc
" date: 4-Feb-2017
" author(s): ehth77
""""""""
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set number
set encoding=utf-8
set ruler
set showcmd
set ignorecase
set hlsearch
set incsearch
"""allow backspacing over everything in insert mode
set backspace=indent,eol,start
set whichwrap+=h,l
set history=50		" keep 50 lines of command line history
set showmatch
set matchtime=2 " tenth of a second to showmatch(i.e highlight enclosing pairs)
set pastetoggle=<F3>
set textwidth=79
set nowrapscan
set lazyredraw " don't re-draw while executing macros. (use ^L to force re-draw)
set undofile
set nobackup
set noswapfile
set wildmenu

"
" Fancy Stuff
" 
syntax on
set t_Co=256
colorscheme gruvbox
set background=dark

""
" MAPPINGS
""
inoremap jk <Esc>
inoremap <c-d> <Esc>ddi
"handy while doing gui stuff
noremap <Up> :!./%<CR><CR> 
noremap <Down> :!clear && ./%<CR>
"disable arrow keys
noremap <Left> <nop>
noremap <Right> <nop>
autocmd filetype c inoremap { {<CR>}<Esc>O
"highlighting and searching
"sane regexp while searching
nnoremap / /\v
vnoremap / /\v
"
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

filetype plugin indent on
autocmd vimEnter,WinEnter,BufWinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline


call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'metakirby5/codi.vim'
Plug 'w0rp/ale'
call plug#end()


" Snippet Completion
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3

" Lint mappings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <plug>(ale_next_wrap)

