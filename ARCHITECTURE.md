# Architecture

- Hardware: Supports macOS (Apple Silicon) and Linux (x86_64 and aarch64).
- This configuration is derived from the standard version of [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs/tree/972935c1b35d8b92476e26b0e63a044d191d49c3/standard).

## flake.nix

The central configuration file that defines all inputs and outputs.

### Inputs

| Input | Source | Purpose |
|-------|--------|---------|
| `nixpkgs` | nixos/nixpkgs (26.05-small) | Main package source |
| `nixpkgs-unstable` | nixos/nixpkgs (nixos-unstable) | Newer packages via the `unstable-packages` overlay (e.g. `mise`) |
| `home-manager` | nix-community (26.05) | User environment management |
| `nixvim` | nix-community (26.05) | Neovim configuration framework |
| `nix-index-database` | nix-community | Weekly pre-built nix-index database for `nix-locate` and `command-not-found` |
| `nix-darwin` | nix-darwin (26.05) | macOS system-level configuration |
| `determinate` | DeterminateSystems/determinate (pinned `=3.21.5`) | Determinate Nix integration for nix-darwin |

### Outputs

- **nixosConfigurations**: `vm`
- **darwinConfigurations**: `darwin`
- **homeConfigurations**: `nixos@linux-x86_64`, `nixos@linux-aarch64`, `henry@darwin` (aarch64)
- **packages**: `home-manager` (all systems) and `darwin-rebuild` (Darwin only) — Exposes both CLIs from flake inputs, enabling `nix run '.#home-manager'` and `nix run '.#darwin-rebuild'` for bootstrapping without a prior installation, and keeping the pinned input as the single source of the version.
- **overlays**: `unstable-packages`, `fix-inetutils`
- **devShells**: Provides `nixfmt-rfc-style` for all systems

## overlays

Contains `default.nix` which provides:

- `unstable-packages`: exposes the `nixpkgs-unstable` package set as `pkgs.unstable` (used for `mise`).
- `fix-inetutils`: a workaround for inetutils build failure on Darwin (nixpkgs#488689).

## home-manager

Configuration for each user, organized by platform.

## home-manager/common

Common configuration shared between Darwin and Linux.

### Core packages and tools

- **Shell**: Fish with Starship prompt, fish plugins (autopair, fzf-fish, done, plugin-git)
- **Development**: Git (with GPG signing, delta for diffs), GitHub CLI, direnv, FZF, ripgrep, fd, git-extras, gnumake, fnm
- **Terminal tools**: Atuin (shell history), bat, lsd, lazygit, zoxide, gping, procs, spacer, xh, ntfy-sh (push notifications)
- **Security**: GPG, password-store
- **Services**: GPG Agent, Syncthing

## home-manager/common/nixvim

NixVim is a configuration system that uses Nix for plugin management. It leverages `vimPlugins` from the nixpkgs distribution, ensuring that plugin versions are locked.

### Module structure

| Module | Purpose |
|--------|---------|
| `default.nix` | Base settings, colorscheme (dracula-nvim), which-key |
| `lsp.nix` | LSP servers (nixd, eslint, emmet_language_server, pyright, ruff, taplo, ts_ls, vue_ls, rust_analyzer), completion (nvim-cmp), formatting (conform-nvim), treesitter |
| `ui.nix` | Diagnostics display (Trouble plugin) |
| `mini.nix` | Mini.nvim collection (ai, basics, bracketed, comment, cursorword, diff, extra, files, icons, indentscope, notify, operators, pairs, pick, statusline, surround, tabline, trailspace) |
| `flash.nix` | Quick navigation plugin |
| `toggleterm.nix` | Floating terminal configuration |

## home-manager/common/ghostty

- Declarative [Ghostty](https://ghostty.org) terminal configuration via the `programs.ghostty` home-manager module.
- Theme `Dracula`, font `Maple Mono NF CN` @ 12pt, fish shell integration.
- Nix only manages `~/.config/ghostty/config` (`package = null`); the Ghostty binary must be installed via the system's native channel (Homebrew cask on macOS, Flatpak / AppImage / distro package on Linux), because the nixpkgs build is known to fail to launch on this setup.
- `pkgs.maple-mono.NF-CN` is installed on all platforms so the terminal has the correct Nerd Font icons and CJK glyphs.
- `systemd.enable` is explicitly disabled because the module requires `package != null` when the systemd user service is active.

## home-manager/common/zellij

- A terminal workspace with batteries included.
- The default keybindings of zellij dramatically conflict with NixVim keybindings, so I changed the prefix to change mode from "Ctrl" to "Alt".

## home-manager/common/envrc

- Credentials are stored in the [pass](https://www.passwordstore.org) store, synchronized with [syncthing](https://syncthing.net).
- Once the current directory is changed to `$HOME/Develop`, credentials are automatically injected into the environment variables.

## home-manager/darwin

- Darwin-specific configurations for user `henry`.
- Additional packages: automake, mas, pkg-config.

## home-manager/linux

- Linux-specific configurations for user `nixos`.
- GPG agent and syncthing are installed by home-manager.
- No additional packages beyond common configuration.

## hosts/vm

- SSH: Inject public keys, disable root login, and disable password authentication.
- Hardware virtualization: QEMU Guest support.
- Set fish as the default shell.
- Enable Avahi so the virtual machine is accessible via the \*.local domain.
- Set Asia/Taipei as the timezone.
- Home-manager is integrated as a NixOS module, so user configuration is applied on boot.
- Default password `nixos` for testing (change immediately with `passwd`).

## hosts/darwin

- Nix itself is managed by Determinate, not nix-darwin: `determinateNix.enable = true` is set, and the Determinate module force-disables nix-darwin's own `nix.*` management internally, so `nix.enable = false` does not need to be written here.
- The `homebrew` module replaces the old Brewfile, which was never applied by anything and had drifted from what was actually installed.
- `homebrew.onActivation.cleanup` is currently `"none"`, so the first activation only installs what is declared and removes nothing. The next step is `"check"`, which aborts activation listing every Homebrew package not declared in the configuration; `"zap"` is only safe once that list is empty.
- Unlike `hosts/vm`, home-manager is not integrated as a nix-darwin module here — it stays standalone, so `darwin-rebuild` applies only the system layer and `home-manager switch` must be run separately.
- `system.stateVersion = 7`.

## Makefile

Automation commands for building and deployment:

- `make bootstrap`: First-time home-manager setup via `nix run '.#home-manager'` (no prior installation required).
- `make dry-run`: Validate home-manager configuration.
- `make switch`: Apply home-manager configuration.
- `make os/dry-run`: Validate NixOS system configuration.
- `make os/switch`: Apply NixOS system configuration.
- `make vm/run`: Build and start a QEMU VM for testing (Linux only). Allocates half of host CPU and memory, forwards SSH to port 2222.
- `make darwin/bootstrap`: First-time nix-darwin activation via `nix run '.#darwin-rebuild'` (macOS only, no prior installation required).
- `make darwin/dry-run`: Validate the nix-darwin system configuration (macOS only).
- `make darwin/switch`: Apply the nix-darwin system configuration (macOS only).
