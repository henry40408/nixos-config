# This file defines overlays
{ inputs, ... }:
{
  # Custom packages from the 'pkgs' directory (uncomment when pkgs/ exists):
  # additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    # Uncomment when nixpkgs-next input is enabled in flake.nix:
    # next = import inputs.nixpkgs-next {
    #   system = final.system;
    #   config.allowUnfree = true;
    # };
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
