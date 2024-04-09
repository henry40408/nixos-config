.PHONY: dry-run fmt switch touch os/dry-run os/switch

HM_DEPS = $(shell find home-manager -name '*.conf' -or -name '*.lua' -or -name '*.nix' -or -name '*.zsh')
NIX_FILES = $(shell find . -name '*.nix')
NIXOS_DEPS = $(shell find hosts -name '*.nix' -or -name '*.lock')

fmt:
	nixpkgs-fmt $(NIX_FILES)

touch:
	touch $(HM_DEPS) $(WSL_DEPS)

# Home manager

dry-run: tmp/.hm-dry-run

switch: tmp/.hm-switch

tmp/.hm-dry-run: $(HM_DEPS)
	bash scripts/hm-dry-run.sh
	touch tmp/.hm-dry-run

tmp/.hm-switch: $(HM_DEPS)
	bash scripts/hm-switch.sh
	touch tmp/.hm-switch

# Hosts

os/dry-run: tmp/.dry-run

os/switch: tmp/.switch

tmp/.dry-run: $(NIXOS_DEPS)
	bash scripts/dry-run.sh
	touch tmp/.dry-run

tmp/.switch: $(NIXOS_DEPS)
	bash scripts/switch.sh
	touch tmp/.switch
