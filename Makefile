# stow_dirs = $(wildcard */)
# dry-run:
# 	stow --simulate --target "$(HOME)" --verbose --restow $(stow_dirs)

# stow:
# 	stow --target "$(HOME)" --verbose --restow $(stow_dirs)

# delete:
# 	stow --target "$(HOME)" --verbose --delete  $(stow_dirs)

# install: stow

# uninstall: delete
# .PHONY: delete dry-run

GUIX=/usr/local/bin/guix
config_file="home-configuration.scm"

dry-run:
	$(GUIX) home container $(config_file)

reconfigure:
	$(GUIX) home reconfigure $(config_file)
