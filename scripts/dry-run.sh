#!/usr/bin/env bash

set -eo pipefail

if [[ -n "$WSL_DISTRO_NAME" ]]; then
  flake=".#wsl"
else
  flake=".#vm"
fi
sudo nixos-rebuild dry-build --flake "$flake" --impure

# vim: set ts=2 sw=2 expandtab:
