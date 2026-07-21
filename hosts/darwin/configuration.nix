{ inputs, ... }:
{
  imports = [ inputs.determinate.darwinModules.default ];

  # Nix itself is managed by Determinate, not nix-darwin. This module forces
  # nix.enable = false internally, so the two never fight over /etc/nix/nix.conf.
  determinateNix.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = "henry";
  # https://github.com/nix-darwin/nix-darwin -- set once at install time, then never changed.
  system.stateVersion = 7;

  # Replaces the Brewfile that home-manager used to symlink into $HOME: that
  # file was only a list, nothing ever applied it, so it drifted from reality.
  homebrew = {
    enable = true;
    onActivation = {
      # Start at "none": the first activation only installs what is declared
      # below and removes nothing. Move to "check" next -- it aborts activation
      # listing every Homebrew package not declared here -- and only once that
      # list is empty is "zap" safe.
      cleanup = "none";
    };
    # Kept on Homebrew: `container` is far newer here than nixpkgs (1.1.0 vs
    # 0.12.3) and `dnspyre` is not packaged in nixpkgs at all.
    brews = [
      "container"
      "dnspyre"
    ];
    casks = [
      "block-goose"
      "codex"
      "firefox"
      "ghostty"
      "netnewswire"
      "raycast"
      "signal"
      "steam"
      "syncthing-app"
      "tailscale-app"
      "zed"
    ];
  };
}
