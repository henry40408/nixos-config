.PHONY: dry-run fmt os/dry-run os/switch switch

NIX_FILES := $(shell find . -name '*.nix')
UNAME := $(shell uname)
WSL_DISTRO := $(strip $(WSL_DISTRO_NAME))

fmt:
	nixpkgs-fmt $(NIX_FILES)

# Home manager

dry-run:
ifeq ($(UNAME), Darwin)
	# Darwin
	home-manager build --dry-run --flake '.#henry@darwin'
else
	# WSL & VM
	home-manager build --dry-run --flake '.#nixos@all'
endif

switch:
ifeq ($(UNAME), Darwin)
	# Darwin
	home-manager switch --flake '.#henry@darwin'
else
	# WSL & VM
	home-manager switch --flake '.#nixos@all'
endif

# NixOS

os/dry-run:
ifdef WSL_DISTRO
	sudo nixos-rebuild dry-build --flake ".#wsl" --impure
else ifeq ($(UNAME), Darwin)
	$(info Darwin is not supported)
else ifeq ($(UNAME), Linux)
	sudo nixos-rebuild dry-build --flake ".#vm" --impure
endif

os/switch:
ifdef WSL_DISTRO
	sudo nixos-rebuild switch --flake ".#wsl" --impure
else ifeq ($(UNAME), Darwin)
	$(info Darwin is not supported)
else ifeq ($(UNAME), Linux)
	sudo nixos-rebuild switch --flake ".#vm" --impure
endif
