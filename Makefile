_NIX_FILES := $(shell find . -name '*.nix')
_UNAME := $(shell uname)
_ARCH := $(shell uname -m)
_WSL_DISTRO := $(WSL_DISTRO_NAME)
_HALF_CPUS := $(shell echo $$(( $$(nproc) / 2 )))
_HALF_MEM := $(shell free -m | awk '/^Mem:/{print int($$2/2)}')

.PHONY: all fmt update dry-run switch os/dry-run os/switch vm/run

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
	sudo nixos-rebuild dry-build --flake ".#wsl"
else ifeq ($(_UNAME),Darwin)
	$(error Darwin is not supported)
else ifeq ($(_UNAME),Linux)
	sudo nixos-rebuild dry-build --flake ".#vm"
endif

os/switch:
ifneq ($(_WSL_DISTRO),)
	sudo nixos-rebuild switch --flake ".#wsl"
else ifeq ($(_UNAME),Darwin)
	$(error Darwin is not supported)
else ifeq ($(_UNAME),Linux)
	sudo nixos-rebuild switch --flake ".#vm"
endif

vm/run:
ifeq ($(_UNAME),Linux)
	nix build ".#nixosConfigurations.vm.config.system.build.vm"
	QEMU_OPTS="-m $(_HALF_MEM) -smp $(_HALF_CPUS)" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm
else
	$(error vm/run is only supported on Linux)
endif
