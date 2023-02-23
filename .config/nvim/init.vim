set runtimepath^=~/.vim runtimepath+=~/.vim/after

let &packpath = &runtimepath

if has('nvim-0.1.5')        " True color in neovim wasn't added until 0.1.5
    set termguicolors
endif

if has('nvim-0.2.1')
	set inccommand=split " live search in split-mode
end

let g:python3_host_prog = '/usr/bin/python3'

"TODO: cleanup
set tabstop=2 shiftwidth=2 expandtab

if !empty(glob('~/.vimrc'))
	source ~/.vimrc
endif