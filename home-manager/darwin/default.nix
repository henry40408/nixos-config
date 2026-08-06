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
    username = "henry";
    homeDirectory = "/Users/henry";
  };
  home.packages = with pkgs; [
    automake
    mas
    # Moved off Homebrew: nixpkgs ships both at the exact same version, and the
    # nix mkcert bundles certutil, so the separate nss formula is no longer
    # needed either.
    mkcert
    pkg-config
    wrk
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  news.display = "silent";
  # The module registers a launchd agent with socket activation and injects the
  # GPG_TTY/SSH_AUTH_SOCK setup into fish, so no shell has to launch the agent
  # itself.
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400; # 1 day
    enableSshSupport = true;
    maxCacheTtl = 604800; # 1 week
    pinentry.package = pkgs.pinentry_mac;
    # Let libgcrypt grow its secure memory pool. Without this, decrypting
    # several secrets concurrently fails with out-of-secure-memory errors.
    extraConfig = "auto-expand-secmem";
  };
}

# vim: ts=2 sw=2 expandtab:
