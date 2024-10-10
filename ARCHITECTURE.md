# Architecture

- Hardware: A MacBook Pro with an Intel CPU and a Windows PC that runs a WSL (Windows Subsystem for Linux) environment.
- This configuration is derived from the standard version of [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/972935c1b35d8b92476e26b0e63a044d191d49c3/standard).

## home-manager

Configuration for each user.

## home-manager/common

Common configuration shared between Darwin and Linux.

## home-manager/common/neovim

I've encountered version lock issues with both LazyVim and NixVim. Neither solution locks every package to a specific commit, making upgrades unpredictable. While I enjoy living on the edge, I dislike when my LSP stops working just as I find the motivation to work on my side projects.

## home-manager/common/zellij

- A terminal workspace with batteries included.
- The default keybindings of zellij dramatically conflict with lazyvim, so I changed the prefix to change mode from "Ctrl" to "Alt".

## home-manager/common/zsh

The configuration is divided into two files: `extra-first.zsh` and `extra.zsh`:

- `extra-first.zsh`: Commands to be added at the beginning of `.zshrc`.
- `extra.zsh`: Additional commands to be appended to `.zshrc`.

## home-manager/common/envrc

- Credentials are stored in the [pass](https://www.passwordstore.org) store, synchronized with [syncthing](https://syncthing.net).
- Once the current directory is changed to `$HOME/Develop`, credentials are automatically injected into the environment variables.

## home-manager/darwin

- Darwin-specific configurations.
- Currently, it only includes lock files for [homebrew](https://brew.sh).
- GPG agent and syncthing are installed via homebrew for the GUI.

## home-manager/linux

- Linux-specific configurations.
- GPG agent and syncthing are installed by home-manager.

## hosts/vm

- SSH: Inject public keys, disable root login, and disable password authentication.
- Set zsh as the default shell.
- Enable Avahi so the virtual machine is accessible via the \*.local domain.
- Set Asia/Taipei as the timezone.

## hosts/wsl

- Use [NixOS-WSL](https://github.com/nix-community/NixOS-WSL/blob/aef95bdb6800a3a2af7aa7083d6df03067da6592/README.md).
- Set Asia/Taipei as the timezone.
- Install Git and GNU Make for the Makefile of this configuration.
- Set zsh as the default shell.
- Install Docker and allow the normal user to use it for virtualization.
