# ── Environment detection ───────────────────────────────────────────
_NIX_FILES := $(shell find . -name '*.nix')
_UNAME     := $(shell uname)
_ARCH      := $(shell uname -m)
_HALF_CPUS  = $(shell echo $$(( $$(nproc) / 2 )))
_HALF_MEM   = $(shell free -m | awk '/^Mem:/{print int($$2/2)}')

# ── Resolve the Home Manager flake target for this machine ──────────
ifeq ($(_UNAME),Darwin)
  ifeq ($(_ARCH),arm64)
    _HM_TARGET := henry@darwin
  endif
else ifeq ($(_UNAME),Linux)
  ifeq ($(_ARCH),aarch64)
    _HM_TARGET := nixos@linux-aarch64
  else ifeq ($(_ARCH),x86_64)
    _HM_TARGET := nixos@linux-x86_64
  endif
endif

# Guard used by recipes that need a resolved Home Manager target.
define _require_hm
	@test -n "$(_HM_TARGET)" || { echo "Unsupported platform: $(_UNAME)/$(_ARCH)"; exit 1; }
endef

# Guard used by recipes that only run on Linux.
define _require_linux
	@test "$(_UNAME)" = Linux || { echo "$@ is Linux-only"; exit 1; }
endef

.DEFAULT_GOAL := all
.PHONY: all help fmt update bootstrap dry-run switch os/dry-run os/switch vm/run

all: fmt

help: ## Show this help
	@grep -E '^[a-zA-Z/_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN{FS=":.*?## "}{printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

fmt: ## Format all Nix files
	nixfmt $(_NIX_FILES)

update: ## Update flake inputs
	nix flake update

bootstrap: ## First-time Home Manager activation (before hm is installed)
	$(_require_hm)
	nix run '.#home-manager' -- switch --flake '.#$(_HM_TARGET)'

dry-run: ## Dry-build the Home Manager configuration
	$(_require_hm)
	home-manager build --dry-run --flake '.#$(_HM_TARGET)' $(HM_FLAGS)

switch: ## Activate the Home Manager configuration
	$(_require_hm)
	home-manager switch --flake '.#$(_HM_TARGET)' $(HM_FLAGS)

# ── NixOS (Linux only) ──────────────────────────────────────────────
os/dry-run: ## Dry-build the NixOS 'vm' configuration
	$(_require_linux)
	sudo nixos-rebuild dry-build --flake ".#vm"

os/switch: ## Activate the NixOS 'vm' configuration
	$(_require_linux)
	sudo nixos-rebuild switch --flake ".#vm"

vm/run: ## Build and boot the NixOS 'vm' in QEMU
	$(_require_linux)
	nix build ".#nixosConfigurations.vm.config.system.build.vm"
	QEMU_OPTS="-m $(_HALF_MEM) -smp $(_HALF_CPUS)" QEMU_NET_OPTS="hostfwd=tcp::2222-:22" ./result/bin/run-nixos-vm
