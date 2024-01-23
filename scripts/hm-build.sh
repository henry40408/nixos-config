#!/usr/bin/env bash

set -eo pipefail

if [[ "$(uname -s)" = "Darwin" ]]; then
	flake=".#henry@macos"
else
	flake=".#nixos@all"
fi
home-manager build --flake "$flake"

# vim: set ts=2 sw=2 expandtab:
