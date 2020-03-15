" .vimrc
" date: 15-Mar-2020
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
xnoremap jk <Esc>
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
" <leader>qq for q! slows down <leader>q
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
" colorscheme " iceberg onedark gruvbox
colorscheme lucid
set background=dark
autocmd vimEnter,WinEnter,BufWinEnter,InsertLeave * setlocal cursorline
autocmd WinLeave,InsertEnter * setlocal nocursorline
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
      \ 'python': ['flake8'],
      \ 'ruby': ['ruby', 'rubocop'],
      \}
" only lint on file save
let g:ale_lint_on_text_changed = 'never'

" Rainbow parens for uber nesting
augroup rainbow_parens
  autocmd!
  autocmd! FileType clojure,sml,scheme RainbowParentheses
augroup END

let g:rainbow#pairs = [['(', ')'], ['[', ']'], ['{', '}']]
let g:lightline = {
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


" source: https://vim.fandom.com/wiki/Improved_hex_editing
nnoremap <C-H> :Hexmode<CR>
inoremap <C-H> <Esc>:Hexmode<CR>
vnoremap <C-H> :<C-U>Hexmode<CR>
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    silent :e " this will reload the file without trickeries
    "(DOS line endings will be shown entirely )
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction
