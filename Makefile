.PHONY: build switch os/dry-build os/switch

HM_DEPS = home-manager/*.nix home-manager/*.zsh home-manager/*.conf
NIXOS_DEPS = hosts/*/configuration.nix

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

os/dry-build: tmp/.dry-build

os/switch: tmp/.switch

tmp/.dry-build: $(NIXOS_DEPS)
	bash scripts/dry-run.sh
	touch tmp/.dry-build

tmp/.switch: $(NIXOS_DEPS)
	bash scripts/switch.sh
	touch tmp/.switch
