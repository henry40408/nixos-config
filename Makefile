.PHONY: dry-run fmt os/dry-run os/switch switch update

NIX_FILES := $(shell find . -name '*.nix')
UNAME := $(shell uname)
ARCH := $(shell uname -m)
WSL_DISTRO := $(strip $(WSL_DISTRO_NAME))

fmt:
	nixfmt $(NIX_FILES)

update:
	nix flake update

# Home manager

dry-run:
ifeq ($(UNAME), Darwin)
ifeq ($(ARCH), arm64)
	# Darwin (arm64)
	home-manager build --dry-run --flake '.#henry@darwin'
else ifeq ($(ARCH), x86_64)
	# Darwin (x86_64)
	home-manager build --dry-run --flake '.#henry@darwin-legacy'
else
	$(error Unsupported architecture)
endif
else
	# WSL & VM
	home-manager build --dry-run --flake '.#nixos@all'
endif

switch:
ifeq ($(UNAME), Darwin)
ifeq ($(ARCH), arm64)
	# Darwin (arm64)
	home-manager switch --flake '.#henry@darwin'
else ifeq ($(ARCH), x86_64)
	# Darwin (x86_64)
	home-manager switch --flake '.#henry@darwin-legacy'
else
	$(error Unsupported architecture)
endif
else
	# WSL & VM
	home-manager switch --flake '.#nixos@all'
endif

# NixOS

os/dry-run:
ifdef WSL_DISTRO
	sudo nixos-rebuild dry-build --flake ".#wsl" --impure
else ifeq ($(UNAME), Darwin)
	$(error Darwin is not supported)
else ifeq ($(UNAME), Linux)
	sudo nixos-rebuild dry-build --flake ".#vm" --impure
endif

os/switch:
ifdef WSL_DISTRO
	sudo nixos-rebuild switch --flake ".#wsl" --impure
else ifeq ($(UNAME), Darwin)
	$(error Darwin is not supported)
else ifeq ($(UNAME), Linux)
	sudo nixos-rebuild switch --flake ".#vm" --impure
endif
