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

  programs.fish.interactiveShellInit = ''
    # GPG agent
    set -gx GPG_TTY (tty)
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    # `gpgconf --launch` costs ~310ms on macOS even when the agent is already
    # running, so guard it with a cheap pgrep check to keep shell startup fast.
    pgrep -x gpg-agent >/dev/null; or gpgconf --launch gpg-agent
  '';

  news.display = "silent";
}

# vim: ts=2 sw=2 expandtab:
