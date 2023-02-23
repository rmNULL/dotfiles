dry-run:
	stow --simulate --target "$(HOME)" --verbose --restow .

stow:
	stow --target "$(HOME)" --verbose --restow .

delete:
	stow --target "$(HOME)" --verbose --delete .

.PHONY: delete dry-run
