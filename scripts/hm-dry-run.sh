#!/usr/bin/env bash

set -eo pipefail

parent_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")

if [[ "$(uname -s)" = "Darwin" ]]; then
	nix-instantiate --eval '<home-manager/home-manager/home-manager.nix>' \
		--argstr confPath "$parent_dir/home-manager/macos/home.nix" \
		--argstr confAttr "" \
		-A activationPackage.outPath
else
	nix-instantiate --eval '<home-manager/home-manager/home-manager.nix>' \
		--argstr confPath "$parent_dir/home-manager/linux/home.nix" \
		--argstr confAttr "" \
		-A activationPackage.outPath
fi

# vim: set ts=2 sw=2 expandtab:
