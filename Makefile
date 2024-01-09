.PHONY: build wsl/dry-build wsl/switch

# Home manager

build: tmp/.hm-build

switch: tmp/.hm-switch

tmp/.hm-build: home-manager/home.nix home-manager/zshrc.extra
	home-manager build --flake .#nixos@all
	touch tmp/.hm-build

tmp/.hm-switch: home-manager/home.nix home-manager/zshrc.extra
	home-manager switch --flake .#nixos@all
	touch tmp/.hm-switch

# Hosts

## WSL

wsl/dry-build: tmp/.wsl-dry-build
wsl/switch: tmp/.wsl-switch

tmp/.wsl-dry-build: hosts/wsl/configuration.nix
	sudo nixos-rebuild dry-build --flake .#wsl --impure
	touch tmp/.wsl-dry-build

tmp/.wsl-switch: hosts/wsl/configuration.nix
	sudo nixos-rebuild switch --flake .#wsl --impure
	touch tmp/.wsl-switch
