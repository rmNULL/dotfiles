" .vimrc
" date: 29-Jul-2020
" author(s): ehth77
""""""""
" Use Vim settings, rather than Vi settings (much better!).
" this must be first, because it changes other options as a side effect.
set nocompatible
set number
set relativenumber
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
set undodir=$HOME/.vim/.undo/
set nobackup
" set backupdir=$HOME/vim/.bck
set directory=$HOME/.vim/.swap
set history=200   " #lines of command history

"""
"Editing
"""
filetype plugin indent on
" backspace over everything in insert mode, start allows for ^-w and ^-u
set backspace=indent,eol,start
set ignorecase " while searching
set pastetoggle=<F7> " almost useless in neovim
set showmatch
" tenth of a second to showmatch(i.e highlight enclosing pairs)
set matchtime=2
set textwidth=79
set tildeop
" " allow h,l to wrap over lines
" set whichwrap+=h,l
set hidden
set noshowmode

"""
" MAPPINGS
"""
inoremap jk <Esc>
xnoremap tk <Esc>
inoremap <c-d> <Esc>ddi
noremap <Up> :make<CR>
" overwrite in filetype
noremap <Down> <NOP>
noremap <Left>  :bprev<CR>
noremap <Right> :bnext<CR>
" autocmd filetype c,javascript inoremap } {<CR>}<Esc>O
" autocmd filetype c,javascript inoremap { {}<Esc>i
" autocmd filetype javascript set shiftwidth=4 expandtab tabstop=4
"highlighting and searching
"sane regexp while searching
nnoremap / /\v
vnoremap / /\v

" credits to Junegunn Choi
" https://github.com/junegunn/dotfiles/blob/master/vimrc
" Make Y behave like other capitals
nnoremap Y y$
" qq to record, Q to replay
nnoremap Q @q

"''
" Leadered Mappings
let mapleader=','
" nnoremap ; : " wastes more time than save
"get rid of annoying highlights after search
nnoremap <leader><space> :noh<CR>
"strip trailing whitespaces
nnoremap <leader>\s :%s/\s\+$//<CR>
"open vimrc for editing
nnoremap <leader>vrc :tabnew $MYVIMRC<CR>
" handy (cred to amix https://github.com/amix/vimrc)
nmap <leader>w :update<cr>
nmap <leader>x :x<cr>
nmap <leader>q :q<cr>
"
nmap <leader>b :b<space>

" force quits, <leader>q! slows downs <leader>q
nmap <leader>fw :w!<cr>
nmap <leader>fq :q!<cr>

"
" reload config
nmap <leader>rr :source $MYVIMRC<CR>
map <leader>tt :Tagbar<CR>
" send visual selection to ScreenShell
" vmap <leader>cc :'<,'>ScreenSend<CR>
"
" faster file searching/loading within project
map <leader>F :FZF<cr>


"""
" Plugin(s) managements
"""
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
" Plug 'eraserhd/parinfer-rust', {'do': 'cargo build --release'}
" Plug 'guns/vim-clojure-static', { 'for': 'clojure' }
" Plug 'jez/vim-better-sml'
" Plug 'junegunn/seoul256.vim'
" Plug 'junegunn/vim-easy-align'
Plug 'Chiel92/vim-autoformat'
Plug 'SirVer/ultisnips'
" Plug 'amiralies/vim-rescript'
Plug 'calebsmith/vim-lambdify'
Plug 'cseelus/vim-colors-lucid'
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'ervandew/screen'
Plug 'flazz/vim-colorschemes'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-{fish,zsh}' }
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'majutsushi/tagbar'
Plug 'maralla/completor.vim'
Plug 'mattn/emmet-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'javascript.jsx', 'html']}
Plug 'psf/black'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
if version >= 8
  Plug 'w0rp/ale'
endif

call plug#end()


""
" Visuals (a.k.a Fancy stuff)
""
set encoding=utf-8
syntax on
set t_Co=256

let s:cs_dark_time=[18,7]

set background=dark
if (strftime('%H') >= s:cs_dark_time[0]) || (strftime('%H') < s:cs_dark_time[1])
  colorscheme 256_noir
else
  " set background=dark " change to light when colorscheme changes
  let g:oceanic_next_terminal_bold = 1
  let g:oceanic_next_terminal_italic = 1
  colorscheme tender
end

if g:colors_name == "256_noir"
  set cursorline
  highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=233 guifg=NONE guibg=#121212
  autocmd InsertEnter * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=234 guifg=NONE guibg=#1c1c1c
  autocmd InsertLeave * highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=233 guifg=NONE guibg=#121212
else
  autocmd vimEnter,WinEnter,BufWinEnter,InsertLeave * setlocal cursorline
  autocmd WinLeave,InsertEnter * setlocal nocursorline
end

set title " window title

" Snippet Completion
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsUsePythonVersion = 3


" Lint mappings
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

let g:ale_linters = {
      \ 'c':  ['gcc'],
      \ 'javascript': ['eslint'],
      \ 'python': ['flake8', 'black'],
      \ 'ruby': ['ruby', 'rubocop'],
      \}
" only lint on file save
let g:ale_lint_on_text_changed = 'never'

" Rainbow parens for uber nesting
augroup rainbow_parens
  autocmd!
  autocmd! FileType clojure,sml,ruby,scheme,prolog,javascript RainbowParentheses
augroup END

let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}'], ['do', 'end']]
let g:lightline = {
      \ 'colorscheme': 'Tomorrow_Night',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename': 'LightLineFilename',
      \   'gitbranch': 'FugitiveStatusline',
      \ }
      \ }
function! LightLineFilename()
  return expand('%')
endfunction

let g:user_emmet_install_global = 0
autocmd FileType html,css,php EmmetInstall

" autocmd BufWritePre * execute ':Autoformat'
