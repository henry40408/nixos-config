.PHONY: boot switch test

FLAKE_ARGS := --flake $(PWD)
HM_ARGS := -f $(PWD)/home.nix

b: boot
hb: home-build
hs: home-switch
s: switch
t: test

boot:
	sudo nixos-rebuild boot $(FLAKE_ARGS)

home-build:
	home-manager build $(HM_ARGS)

home-switch:
	home-manager switch $(HM_ARGS)

switch:
	sudo nixos-rebuild switch $(FLAKE_ARGS)

test:
	sudo nixos-rebuild test $(FLAKE_ARGS)
