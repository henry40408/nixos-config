.PHONY: build wsl/dry-build wsl/switch

HM_DEPS = home-manager/home.nix home-manager/zshrc.extra.zsh home-manager/zshrc.extraFirst.zsh
WSL_DEPS = hosts/wsl/configuration.nix

touch:
	touch $(HM_DEPS) $(WSL_DEPS)

# Home manager

build: tmp/.hm-build

switch: tmp/.hm-switch

tmp/.hm-build: $(HM_DEPS)
	home-manager build --flake .#nixos@all
	touch tmp/.hm-build

tmp/.hm-switch: $(HM_DEPS)
	home-manager switch --flake .#nixos@all
	touch tmp/.hm-switch

# Hosts

## WSL

wsl/dry-build: tmp/.wsl-dry-build
wsl/switch: tmp/.wsl-switch

tmp/.wsl-dry-build: $(WSL_DEPS)
	sudo nixos-rebuild dry-build --flake .#wsl --impure
	touch tmp/.wsl-dry-build

tmp/.wsl-switch: $(WSL_DEPS)
	sudo nixos-rebuild switch --flake .#wsl --impure
	touch tmp/.wsl-switch
