#!/usr/bin/env bash

set -eo pipefail

parent_dir=$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")

if [[ "$(uname -s)" = "Darwin" ]]; then
	home-manager build --dry-run --flake '.#henry@macos'
else
	home-manager build --dry-run --flake '.#nixos@all'
fi

# vim: set ts=2 sw=2 expandtab:
