# nixos-config

[![Casual Maintenance Intended](https://casuallymaintained.tech/badge.svg)](https://casuallymaintained.tech/)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/henry40408/nixos-config/.github%2Fworkflows%2Fworkflow.yaml)
![GitHub](https://img.shields.io/github/license/henry40408/nixos-config)

## Description

This repository, maintained by henry40408, features configurations managed with Nix Flakes. It is organized into "home-manager" and "hosts" directories for home-manager and NixOS configurations, respectively. The project is based on the template provided by [Misterio77's nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) and is designed for both WSL and VM environments.

## Installation

### First-Time Setup

Install Nix via the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer):

```bash
sh nix-installer.sh install
```

Clone this repository:

```bash
git clone https://github.com/henry40408/nixos-config.git
cd nixos-config
```

Bootstrap home-manager (no prior installation required):

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

For WSL:

```bash
sudo nixos-rebuild switch --flake .#wsl
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

## Usage

The "home-manager" directory contains user-level settings, and the "hosts" directory includes system-level configurations for different NixOS hosts. Customize by editing these files. The Flake.nix file orchestrates their integration and management. For more details, please refer to [ARCHITECTURE.md](ARCHITECTURE.md)

## Contributing

Contributions are welcome. Please review our contributing guidelines for proposing changes.

## License

Licensed under the [MIT License](LICENSE.txt).
