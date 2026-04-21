{ pkgs, lib, ... }:
{
  programs.ghostty = {
    enable = true;

    # On Darwin the nixpkgs ghostty build is frequently marked broken; the
    # upstream recommendation is to install Ghostty.app via Homebrew cask and
    # let Nix manage only the config file. See home-manager/darwin/Brewfile.
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    enableFishIntegration = true;

    settings = {
      theme = "Dracula";
      font-family = "FiraCode Nerd Font";
      font-size = 13;
      copy-on-select = "clipboard";
      mouse-hide-while-typing = true;
      window-padding-x = 8;
      window-padding-y = 8;
      confirm-close-surface = false;
    };
  };

  # macOS installs the Nerd Font via the `font-fira-code-nerd-font` Homebrew
  # cask already, so only register the Nix package on Linux.
  home.packages = lib.optionals pkgs.stdenv.isLinux [
    pkgs.nerd-fonts.fira-code
  ];
}
