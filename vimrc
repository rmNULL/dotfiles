" .vimrc
" date: 20-Jan-2017
" author(s): ehth77
""""""""
" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set number
set nobackup
set ruler
set showcmd
set ignorecase
set hlsearch
set incsearch
set encoding=utf-8
"""allow backspacing over everything in insert mode
set backspace=indent,eol,start
set history=50		" keep 50 lines of command line history
set pastetoggle=<F3>
set textwidth=79
set shiftwidth=4
set tabstop=4
set expandtab "expand tab as spaces
set autoindent
set nowrapscan
set undofile
set t_Co=256
colorscheme gruvbox
set background=dark

"handy while doing gui stuff
noremap <Up> :!./%<CR><CR> 
noremap <Down> :!clear && ./%<CR>
"disable arrow keys
noremap <Left> <nop>
noremap <Right> <nop>
inoremap jk <Esc>
"bracket completion (better use a plugin)
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i
"basic grouping and quoting
vnoremap _( <Esc>`>a)<Esc>`<i(<Esc>
vnoremap _' <Esc>`>a'<Esc>`<i'<Esc>
vnoremap _" <Esc>`>a"<Esc>`<i"<Esc>
vnoremap _] <Esc>`>a]<Esc>`<i[<Esc>
vnoremap _< <Esc>`>a><Esc>`<i<<Esc>
vnoremap _{ <Esc>`<i<Esc>kA {<Esc>`>o}<Esc>
"highlighting and searching
"sane regexp while searching
nnoremap / /\v
vnoremap / /\v

let mapleader=','
nnoremap ; :
"get rid of all that annoying highlights after search
nnoremap <leader><space> :noh<CR>
"strip trailing whitespaces
nnoremap <leader>\s :%s/\s\+$//<CR>
"open vimrc for editing
nnoremap <leader>vrc :tabnew $MYVIMRC<CR>
" handy (cred to amix https://github.com/amix/vimrc))
nmap <leader>w :w!<cr>
nmap <leader>x :x<cr>

syntax on
filetype plugin indent on

autocmd filetype c inoremap { {<CR>}<Esc>O
"some HTML thingies
""autocmd filetype html inoremap < <><left>
""autocmd BufNewFile,BufRead *.js, *.html, *.css
""    \ set tabstop=2
""    \ set softtabstop=2
""    \ set shiftwidth=2
"""handling folds
""autocmd BufWinLeave * mkview
""autocmd BufWinEnter * silent loadview
