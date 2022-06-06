.PHONY: boot switch test

ARGS := --flake $(PWD)

boot:
	sudo nixos-rebuild boot $(ARGS)

switch:
	sudo nixos-rebuild switch $(ARGS)

test:
	sudo nixos-rebuild test $(ARGS)
