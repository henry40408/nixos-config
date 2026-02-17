{ pkgs, lib, ... }:
{
  imports = [ ./nixvim ];

  home.packages = with pkgs; [
    fd
    fnm
    git-extras
    gnumake
    gping
    nixfmt-rfc-style
    procs
    spacer
    xh
    zsh-autopair
    zsh-completions
    zsh-fzf-tab
    zsh-powerlevel10k
    zsh-you-should-use

    (writeShellScriptBin "clipboard-copy" (
      if stdenv.isDarwin then ''
        exec pbcopy "$@"
      '' else ''
        if [ -n "$WAYLAND_DISPLAY" ]; then
          exec ${wl-clipboard}/bin/wl-copy "$@"
        else
          exec ${xclip}/bin/xclip -selection clipboard "$@"
        fi
      ''
    ))
  ] ++ lib.optionals stdenv.isLinux [
    wl-clipboard
    xclip
  ];

  home.file.".p10k.zsh".text = (builtins.readFile ./zsh/p10k.zsh);
  home.file."Develop/.envrc".text = (builtins.readFile ./envrc);

  programs.atuin = {
    enable = true;
    settings = {
      inline_height = 10;
      style = "compact";
      update_check = false;
    };
  };
  programs.bat = {
    enable = true;
    config = {
      theme = "base16";
    };
  };
  programs.command-not-found.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf.enable = true;
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      side-by-side = true;
    };
  };
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user = {
        name = "Heng-Yi Wu";
        email = "2316687+henry40408@users.noreply.github.com";
      };
    };
    signing = {
      key = "2316687+henry40408@users.noreply.github.com";
      signByDefault = true;
    };
  };
  programs.gpg.enable = true;
  programs.lazygit.enable = true;
  programs.lsd.enable = true;
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };
  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
    };
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        source $HOME/.p10k.zsh
        ${builtins.readFile ./zsh/instant-prompt.zsh}
      '')
      ''
        source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        ${builtins.readFile ./zsh/extra.zsh}
      ''
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "command-not-found"
        "common-aliases"
        "direnv"
        "docker"
        "docker-compose"
        "fzf"
        "gem"
        "git"
        "git-extras"
        "git-flow"
        "gitignore"
        "golang"
        "gpg-agent"
        "helm"
        "pip"
        "python"
        "rails"
        "ruby"
      ];
    };
    shellAliases = {
      cat = "bat";
      ping = "gping";
      ps = "procs";
    };
    syntaxHighlighting = {
      enable = true;
    };
  };
  programs.ripgrep.enable = true;
  programs.zellij.enable = true;
  programs.zoxide.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    source = ./zellij/config.kdl;
  };
}
