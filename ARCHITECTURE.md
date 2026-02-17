# Architecture

- Hardware: Supports macOS (both Intel and Apple Silicon) and Linux (x86_64 and aarch64), including WSL (Windows Subsystem for Linux) environments.
- This configuration is derived from the standard version of [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/972935c1b35d8b92476e26b0e63a044d191d49c3/standard).

## flake.nix

The central configuration file that defines all inputs and outputs.

### Inputs

| Input | Source | Purpose |
|-------|--------|---------|
| `nixpkgs` | nixos/nixpkgs (25.11-small) | Main package source |
| `home-manager` | nix-community (25.11) | User environment management |
| `nixos-wsl` | nix-community | WSL support |
| `nixvim` | nix-community (25.11) | Neovim configuration framework |

### Outputs

- **nixosConfigurations**: `vm`, `wsl`
- **homeConfigurations**: `nixos@linux-x86_64`, `nixos@linux-aarch64`, `henry@darwin-legacy` (x86_64), `henry@darwin` (aarch64)
- **packages**: `home-manager` — Exposes the home-manager CLI from flake inputs, enabling `nix run '.#home-manager'` for bootstrapping without a prior installation.
- **overlays**: `fix-inetutils`
- **devShells**: Provides `nixfmt-rfc-style` for all systems

## overlays

Contains `default.nix` which provides the `fix-inetutils` overlay, a workaround for inetutils build failure on Darwin (nixpkgs#488689).

## home-manager

Configuration for each user, organized by platform.

## home-manager/common

Common configuration shared between Darwin and Linux.

### Core packages and tools

- **Shell**: Zsh with Powerlevel10k theme and Oh-my-zsh plugins
- **Development**: Git (with GPG signing), GitHub CLI, direnv, FZF, ripgrep
- **Terminal tools**: Atuin (shell history), bat, lsd, lazygit, zoxide
- **Services**: GPG Agent, Syncthing

## home-manager/common/nixvim

NixVim is a configuration system that uses Nix for plugin management. It leverages `vimPlugins` from the nixpkgs distribution, ensuring that plugin versions are locked.

### Module structure

| Module | Purpose |
|--------|---------|
| `default.nix` | Base settings, colorscheme (irblack), which-key |
| `lsp.nix` | LSP servers (nixd, eslint, pyright, ts_ls, vue_ls, rust-analyzer, etc.) |
| `ui.nix` | Diagnostics display (Trouble plugin) |
| `mini.nix` | Mini.nvim collection (ai, basics, comment, surround, etc.) |
| `flash.nix` | Quick navigation plugin |
| `toggleterm.nix` | Floating terminal configuration |

## home-manager/common/zellij

- A terminal workspace with batteries included.
- The default keybindings of zellij dramatically conflict with NixVim keybindings, so I changed the prefix to change mode from "Ctrl" to "Alt".

## home-manager/common/zsh

The configuration includes:

- `instant-prompt.zsh`: Powerlevel10k instant prompt for faster startup.
- `p10k.zsh`: Powerlevel10k theme configuration.
- `extra.zsh`: Additional commands appended to `.zshrc`.

## home-manager/common/envrc

- Credentials are stored in the [pass](https://www.passwordstore.org) store, synchronized with [syncthing](https://syncthing.net).
- Once the current directory is changed to `$HOME/Develop`, credentials are automatically injected into the environment variables.

## home-manager/darwin

- Darwin-specific configurations for user `henry`.
- Includes lock files for [homebrew](https://brew.sh) (`Brewfile`, `Brewfile.lock.json`).
- Additional packages: automake, mas, pkg-config.

## home-manager/linux

- Linux-specific configurations for user `nixos`.
- GPG agent and syncthing are installed by home-manager.
- No additional packages beyond common configuration.

## hosts/vm

- SSH: Inject public keys, disable root login, and disable password authentication.
- Hardware virtualization: QEMU Guest support.
- Set zsh as the default shell.
- Enable Avahi so the virtual machine is accessible via the \*.local domain.
- Set Asia/Taipei as the timezone.
- Home-manager is integrated as a NixOS module, so user configuration is applied on boot.
- Default password `nixos` for testing (change immediately with `passwd`).

## hosts/wsl

- Use [NixOS-WSL](https://github.com/nix-community/NixOS-WSL).
- Set Asia/Taipei as the timezone.
- Install Git and GNU Make for the Makefile of this configuration.
- Set zsh as the default shell.
- Install Docker and allow the normal user to use it for virtualization.

## Makefile

Automation commands for building and deployment:

- `make bootstrap`: First-time home-manager setup via `nix run '.#home-manager'` (no prior installation required).
- `make dry-run`: Validate home-manager configuration.
- `make switch`: Apply home-manager configuration.
- `make os/dry-run`: Validate NixOS system configuration.
- `make os/switch`: Apply NixOS system configuration.
- `make vm/run`: Build and start a QEMU VM for testing (Linux only). Allocates half of host CPU and memory, forwards SSH to port 2222.
