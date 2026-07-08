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
    pkg-config
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";

  # The Nix multi-user installer only adds the profile to /etc/zshrc and
  # /etc/bashrc, never to fish. Ghostty launches `fish -l` directly from the
  # GUI (via launchd), so fish never inherits a login shell's PATH and the Nix
  # profile is missing. Bare commands such as `gpgconf` and the snippets emitted
  # by `atuin init` / `fzf --fish` then fail at startup. loginShellInit runs in
  # the login block, before interactiveShellInit, so PATH is ready in time.
  programs.fish.loginShellInit = ''
    fish_add_path --prepend --global /nix/var/nix/profiles/default/bin
    fish_add_path --prepend --global $HOME/.nix-profile/bin
  '';

  programs.fish.interactiveShellInit = ''
    # GPG agent
    set -gx GPG_TTY (tty)
    set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    # `gpgconf --launch` costs ~310ms on macOS even when the agent is already
    # running, so guard it with a cheap pgrep check to keep shell startup fast.
    pgrep -x gpg-agent >/dev/null; or gpgconf --launch gpg-agent
  '';

  home.file."Brewfile".source = ./Brewfile;
  news.display = "silent";
}

# vim: ts=2 sw=2 expandtab:
