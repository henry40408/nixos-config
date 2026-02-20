# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    ../common
    ../common/nixpkgs.nix
  ];

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
  };
  home.packages = [ ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  news.display = "silent";
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400; # 1 day
    enableSshSupport = true;
    maxCacheTtl = 604800; # 1 week
    pinentry.package = pkgs.pinentry-curses;
  };
  services.syncthing.enable = true;
}

# vim: ts=2 sw=2 expandtab:
