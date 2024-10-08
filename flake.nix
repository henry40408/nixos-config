{
  description = "My NixOS and home-manager configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # Nixpkgs unstable
    # vue-language-server: 2.1.2 -> 2.1.6
    nixpkgs-unstable.url = "github:nixos/nixpkgs/26ddb99cfd3f8e1092057f90e42db325dad4e5a5";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS WSL
    nixos-wsl.url = "github:nix-community/nixos-wsl/2405.5.4";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
    in
    {
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/vm/configuration.nix ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./hosts/wsl/configuration.nix ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "nixos@linux-x86_64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home-manager/linux ];
        };
        "nixos@linux-aarch64" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home-manager/linux ];
        };
        "henry@darwin-legacy" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home-manager/darwin ];
        };
        "henry@darwin" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-darwin; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home-manager/darwin ];
        };
      };
    };
}
