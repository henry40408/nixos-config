_NIX_FILES := $(shell find . -name '*.nix')
_UNAME := $(shell uname)
_ARCH := $(shell uname -m)
_WSL_DISTRO := $(WSL_DISTRO_NAME)

.PHONY: all fmt update dry-run switch os/dry-run os/switch

all: fmt

fmt:
	nixfmt $(_NIX_FILES)

update:
	nix flake update

dry-run:
ifeq ($(_UNAME),Darwin)
ifeq ($(_ARCH),arm64)
	home-manager build --dry-run --flake '.#henry@darwin'
else ifeq ($(_ARCH),x86_64)
	home-manager build --dry-run --flake '.#henry@darwin-legacy'
else
	$(error Unsupported architecture)
endif
else
ifeq ($(_ARCH),aarch64)
	home-manager build --dry-run --flake '.#nixos@linux-aarch64'
else ifeq ($(_ARCH),x86_64)
	home-manager build --dry-run --flake '.#nixos@linux-x86_64'
else
	$(error Unsupported architecture)
endif
endif

switch:
ifeq ($(_UNAME),Darwin)
ifeq ($(_ARCH),arm64)
	home-manager switch --flake '.#henry@darwin'
else ifeq ($(_ARCH),x86_64)
	home-manager switch --flake '.#henry@darwin-legacy'
else
	$(error Unsupported architecture)
endif
else
ifeq ($(_ARCH),aarch64)
	home-manager switch --flake '.#nixos@linux-aarch64'
else ifeq ($(_ARCH),x86_64)
	home-manager switch --flake '.#nixos@linux-x86_64'
else
	$(error Unsupported architecture)
endif
endif

os/dry-run:
ifneq ($(_WSL_DISTRO),)
	sudo nixos-rebuild dry-build --flake ".#wsl" --impure
else ifeq ($(_UNAME),Darwin)
	$(error Darwin is not supported)
else ifeq ($(_UNAME),Linux)
	sudo nixos-rebuild dry-build --flake ".#vm" --impure
endif

os/switch:
ifneq ($(_WSL_DISTRO),)
	sudo nixos-rebuild switch --flake ".#wsl" --impure
else ifeq ($(_UNAME),Darwin)
	$(error Darwin is not supported)
else ifeq ($(_UNAME),Linux)
	sudo nixos-rebuild switch --flake ".#vm" --impure
endif
