stow_dirs = $(wildcard */)
dry-run:
	stow --simulate --target "$(HOME)" --verbose --restow $(stow_dirs)

stow:
	stow --target "$(HOME)" --verbose --restow $(stow_dirs)

delete:
	stow --target "$(HOME)" --verbose --delete  $(stow_dirs)

install: stow

uninstall: delete
.PHONY: delete dry-run
