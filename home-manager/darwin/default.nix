{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ../common
    ../common/nixpkgs.nix
  ];

  home = {
    username = "henry";
    homeDirectory = "/Users/henry";
  };
  home.packages = with pkgs; [
    automake
    aria
    mas
    pkg-config
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  home.file."Brewfile".text = (builtins.readFile ./Brewfile);
  home.file."Brewfile.lock.json".text = (builtins.readFile ./Brewfile.lock.json);
  news.display = "silent";
}

# vim: ts=2 sw=2 expandtab:
