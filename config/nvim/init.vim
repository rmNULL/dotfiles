set runtimepath^=~/.vim runtimepath+=~/.vim/after ",~/hover-code

let &packpath = &runtimepath

if !empty(glob('~/.vimrc'))
	source ~/.vimrc
endif

if has('nvim-0.1.5')        " True color in neovim wasn't added until 0.1.5
    set termguicolors
endif

if has('nvim-0.2.1')
	set inccommand=split " live search in split-mode
end
