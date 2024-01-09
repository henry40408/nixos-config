# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.hostName = "nixos";

  boot.loader.systemd-boot.enable = true;

  users.users = {
    nixos = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6kPv20dWCWHjJz9hF5PiBQlIgVeHIrIuh3gNJHusnWCJh/SILKEfywE6U+OosJ0ylM/BEl9BOrNlwfof0hz/l6h5xq7v3fZoUKyOvGrZ1tk9/cJx6BPNUwx4E3RBzQ0YZwQKi0C1ojJlSWQfj0ewVne4wuV0MmgaGElxRFxf4zOoE1ONX5ipJ0j/rOv56AguAr1gX/R6SgUEgsFKb/KMD28xXRk16lIGaWqqsnD1ZIO1ixocAwdFCN7ZSpGnYdmQU9r8YGdCRKWXyqQCjsU4r3Vb4QrdZq0zJtUFSS9TMRUyISFClHaRG8fyVENWEMmfTw606wQz46dRUf5VKJL2sOuwofSp3VGyIW8Yft2bW956+MLfVna7grKm9uKHlQMrMXBCz0nBywnDFASubiqpn9nUNYPXykEHJYP2pj5N9lMHpAap9AusMnEFUHPkkDWIJNRlSrRRTHC1yJWmzPCvPGUShQpYgGVvYRlNh56ORbS+2z3Mt5bn//1NFYZvWFKms8JNebIN+9N6sPDNXrTSLn464OC7LDo1t2U00Wwnw/Dm8Tt47nokscBUK8qR8JRLmXR05eCw9gD4DVzWoE4jHOaMlW16qdUzGNb8VMJRfjkF7petSNb8PCYu8VEzo6cT0c7Vgq04p9XsA7i8FZn4jnUppCtL/9U0medGeoB/6gQ=="
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBii9pFXGH+2N8VLWAxZHrVxIc6EJ7I7zKe6PRM/9bUd"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjFQwQDC2CWl1rq0ZCFhOYmi403mHiVGoVRHTaeiEwP"
      ];
      extraGroups = ["wheel"];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
