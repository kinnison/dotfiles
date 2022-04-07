default: switch

help:
	@echo "The following targets are available and are aliases for the"
	@echo "obvious nixos-rebuild call in question"
	@echo
	@echo "rebuild-switch -- Runs nixos-rebuild switch with requisite args"

rebuild-switch:
	sudo nixos-rebuild --override-input dotfiles $$(pwd) -v switch -L
