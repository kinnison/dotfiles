default: switch

help:
	@echo "The following targets are available and are aliases for the"
	@echo "obvious nixos-rebuild call in question"
	@echo
	@echo "rebuild-switch -- Runs nixos-rebuild switch with requisite args"

rebuild-switch:
	sudo env NIX_CURL_FLAGS="--user-agent Mozilla/5.0" nixos-rebuild --override-input dotfiles $$(pwd) -v switch -L --keep-going

rebuild-build:
	sudo env NIX_CURL_FLAGS="--user-agent Mozilla/5.0" nixos-rebuild --override-input dotfiles $$(pwd) -v build -L --keep-going
