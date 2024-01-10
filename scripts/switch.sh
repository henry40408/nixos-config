#!/usr/bin/env bash

set -euo pipefail

if [[ -n "$WSL_DISTRO_NAME" ]]; then
  flake=".#wsl"
else
  flake=".#vm"
fi
sudo nixos-rebuild switch --flake "$flake" --impure

# vim: set ts=2 sw=2 expandtab:
