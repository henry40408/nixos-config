# nixos-config

[![Casual Maintenance Intended](https://casuallymaintained.tech/badge.svg)](https://casuallymaintained.tech/)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/henry40408/nixos-config/.github%2Fworkflows%2Fworkflow.yaml)
![GitHub](https://img.shields.io/github/license/henry40408/nixos-config)

## Description

This repository, maintained by henry40408, features configurations managed with Nix Flakes. It is organized into "home-manager" and "hosts" directories for home-manager and NixOS configurations, respectively. The project is based on the template provided by [Misterio77's nix-starter-configs](https://github.com/Misterio77/nix-starter-configs) and is designed for both WSL and VM environments.

## Installation

Ensure Nix with Flake support is installed. Clone this repository:

```bash
git clone https://github.com/henry40408/nixos-config.git
cd nixos-config
```

To ensure that the NixOS configuration is evaluable, also known as a dry run:

```bash
make os/dry-run
```

To deploy the NixOS configuration:

(Recommended) Automatically apply the configuration based on the detected environment:

```bash
make os/switch
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

To ensure that the Home Manager configuration is evaluable, also known as a dry run:

```bash
make dry-run
```

To apply the home-manager configuration:

```bash
home-manager switch --flake .#nixos@all
# or
make switch
```

## Usage

The "home-manager" directory contains user-level settings, and the "hosts" directory includes system-level configurations for different NixOS hosts. Customize by editing these files. The Flake.nix file orchestrates their integration and management. For more details, please refer to [ARCHITECTURE.md](ARCHITECTURE.md)

## Contributing

Contributions are welcome. Please review our contributing guidelines for proposing changes.

## License

Licensed under the [MIT License](LICENSE.txt).
