# nixos-config

[![Casual Maintenance Intended](https://casuallymaintained.tech/badge.svg)](https://casuallymaintained.tech/)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/henry40408/nixos-config/.github%2Fworkflows%2Fworkflow.yaml)
![GitHub](https://img.shields.io/github/license/henry40408/nixos-config)

## Description

This repository, maintained by henry40408, features configurations managed with Nix Flakes. It is organized into "home-manager" and "hosts" directories for home-manager and NixOS configurations, respectively. The project is based on the template provided by [Misterio77's nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) and is designed for VM environments.

## Installation

### First-Time Setup

Clone this repository:

```bash
git clone https://github.com/henry40408/nixos-config.git
cd nixos-config
```

Install Nix via the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer):

```bash
sh nix-installer.sh install
```

Bootstrap home-manager (`nix run` fetches Home Manager on demand, so no separate Home Manager installation is required):

```bash
make bootstrap
```

### Subsequent Updates

After the initial bootstrap, use home-manager directly:

```bash
make switch
```

To validate the configuration before applying (dry run):

```bash
make dry-run
```

### NixOS System Configuration

To validate and apply the NixOS system configuration:

```bash
make os/dry-run   # validate
make os/switch    # apply
```

For VM:

Ensure the VM boots with UEFI and has three partitions labeled "boot", "nixos", and "swap". For detailed setup instructions, consult the [NixOS Manual](https://nixos.org/manual/nixos/stable/#sec-installation).

```bash
sudo nixos-rebuild switch --flake .#vm
```

To test VM configuration locally with QEMU (Linux only):

```bash
make vm/run
```

This builds and starts a VM with half of host CPU and memory, SSH forwarded to port 2222. Login credentials: `nixos` / `nixos`. Connect via SSH:

```bash
ssh -p 2222 nixos@localhost
```

### macOS System Configuration

The first activation must bootstrap the configuration, since `darwin-rebuild` does not exist on the system yet:

```bash
sudo nix run github:nix-darwin/nix-darwin/nix-darwin-26.05 -- switch --flake .#darwin
```

`sudo` is required because nix-darwin activation must run as root, and the branch is pinned explicitly because the bare `nix-darwin` flake registry alias resolves to master, not the `nix-darwin-26.05` release this configuration is written against.

Afterwards, `darwin-rebuild` is on `PATH` and the Makefile targets can be used instead:

```bash
make darwin/dry-run   # validate
make darwin/switch    # apply
```

Note that nix-darwin takes over `/etc/zshrc` and similar system files, saving the previous versions with a `.before-nix-darwin` suffix.

On macOS, home-manager runs standalone rather than being integrated into nix-darwin: `make switch` applies the user-level configuration and `make darwin/switch` applies the system-level one. The two are independent and neither triggers the other, so both must be run to fully update the machine.

## Usage

The "home-manager" directory contains user-level settings, and the "hosts" directory includes system-level configurations for different NixOS and nix-darwin hosts. Customize by editing these files. The Flake.nix file orchestrates their integration and management. For more details, please refer to [ARCHITECTURE.md](ARCHITECTURE.md)

## Contributing

Contributions are welcome. Please review our contributing guidelines for proposing changes.

## License

Licensed under the [MIT License](LICENSE.txt).
