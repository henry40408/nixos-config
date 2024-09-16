#!/usr/bin/env bash

set -euo pipefail

NIX_FILES=$(find . -name '*.nix')
UNAME=$(uname)
ARCH=$(uname -m)
WSL_DISTRO=${WSL_DISTRO_NAME:-}

action_fmt() {
  nixfmt $NIX_FILES
}

action_update() {
  nix flake update
}

action_dry_run() {
  if [[ $UNAME == "Darwin" ]]; then
    if [[ $ARCH == "arm64" ]]; then
      # Darwin (arm64)
      home-manager build --dry-run --flake '.#henry@darwin'
    elif [[ $ARCH == "x86_64" ]]; then
      # Darwin (x86_64)
      home-manager build --dry-run --flake '.#henry@darwin-legacy'
    else
      echo "Unsupported architecture" >&2
      exit 1
    fi
  else
    if [[ $ARCH == "aarch64" ]]; then
      # WSL & VM (arm64)
      home-manager build --dry-run --flake '.#nixos@linux-aarch64'
    elif [[ $ARCH == "x86_64" ]]; then
      # WSL & VM (x86_64)
      home-manager build --dry-run --flake '.#nixos@linux-x86_64'
    else
      echo "Unsupported architecture" >&2
      exit 1
    fi
  fi
}

action_switch() {
  if [[ $UNAME == "Darwin" ]]; then
    if [[ $ARCH == "arm64" ]]; then
      # Darwin (arm64)
      home-manager switch --flake '.#henry@darwin'
    elif [[ $ARCH == "x86_64" ]]; then
      # Darwin (x86_64)
      home-manager switch --flake '.#henry@darwin-legacy'
    else
      echo "Unsupported architecture" >&2
      exit 1
    fi
  else
    if [[ $ARCH == "aarch64" ]]; then
      # WSL & VM (arm64)
      home-manager switch --flake '.#nixos@linux-aarch64'
    elif [[ $ARCH == "x86_64" ]]; then
      # WSL & VM (x86_64)
      home-manager switch --flake '.#nixos@linux-x86_64'
    else
      echo "Unsupported architecture" >&2
      exit 1
    fi
  fi
}

action_os_dry_run() {
  if [[ -n $WSL_DISTRO ]]; then
    sudo nixos-rebuild dry-build --flake ".#wsl" --impure
  elif [[ $UNAME == "Darwin" ]]; then
    echo "Darwin is not supported" >&2
    exit 1
  elif [[ $UNAME == "Linux" ]]; then
    sudo nixos-rebuild dry-build --flake ".#vm" --impure
  fi
}

action_os_switch() {
  if [[ -n $WSL_DISTRO ]]; then
    sudo nixos-rebuild switch --flake ".#wsl" --impure
  elif [[ $UNAME == "Darwin" ]]; then
    echo "Darwin is not supported" >&2
    exit 1
  elif [[ $UNAME == "Linux" ]]; then
    sudo nixos-rebuild switch --flake ".#vm" --impure
  fi
}

case "${1:-}" in
fmt) action_fmt ;;
update) action_update ;;
dry-run) action_dry_run ;;
switch) action_switch ;;
os/dry-run) action_os_dry_run ;;
os/switch) action_os_switch ;;
*)
  echo "Usage: $0 {fmt|update|dry-run|switch|os/dry-run|os/switch}" >&2
  exit 1
  ;;
esac
