{
  inputs,
  lib,
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
  # Used for gpg-agent.conf and the GPG_TTY/SSH_AUTH_SOCK fish integration. The
  # launchd side of the module is disabled below, so the agent is still started
  # on demand rather than supervised.
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

  # `gpg-agent --supervised` expects systemd's socket activation protocol
  # (LISTEN_FDS/LISTEN_FDNAMES), which launchd does not speak, so the agent
  # dies with "file descriptor 3 must be valid" on every spawn. KeepAlive then
  # restarts it forever. The module also points the sockets at
  # /var/run/org.nix-community.home.gpg-agent, while gpg clients look under
  # ~/.gnupg, so nothing would connect to them anyway.
  launchd.agents.gpg-agent.enable = lib.mkForce false;

  programs.fish.interactiveShellInit = ''
    # ssh does not auto-start gpg-agent the way gpg does, and SSH_AUTH_SOCK
    # points at the agent's socket. `gpgconf --launch` costs ~310ms on macOS
    # even when the agent is already running, so guard it with a cheap pgrep.
    pgrep -x gpg-agent >/dev/null; or gpgconf --launch gpg-agent
  '';
}

# vim: ts=2 sw=2 expandtab:
