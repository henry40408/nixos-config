{ pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;

    # Nix only manages ~/.config/ghostty/config; the Ghostty binary itself is
    # installed via the system's native channel (Homebrew cask on macOS,
    # Flatpak / AppImage / distro package on Linux). The nixpkgs build is
    # known to fail to launch on this setup.
    package = null;

    # systemd.enable defaults to true on Linux but the module asserts
    # systemd.enable -> package != null, so it must be disabled explicitly.
    systemd.enable = false;

    # Fish integration sources a script from $GHOSTTY_RESOURCES_DIR, which is
    # injected at runtime by Ghostty itself — it does not depend on the Nix
    # package and works with any externally installed Ghostty.
    enableFishIntegration = true;

    settings = {
      command = "${pkgs.fish}/bin/fish -l";
      theme = "Dracula";
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      copy-on-select = "clipboard";
      mouse-hide-while-typing = true;
      window-padding-x = 8;
      window-padding-y = 8;
      confirm-close-surface = false;
      keybind = [
        "cmd+shift+,=reload_config"
        "ctrl+shift+,=reload_config"
      ];
    };
  };

  # macOS installs the Nerd Font via the `font-fira-code-nerd-font` Homebrew
  # cask already, so only register the Nix package on Linux.
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.nerd-fonts.fira-code
  ];
}
