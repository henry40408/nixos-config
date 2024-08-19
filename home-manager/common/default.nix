{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    fd
    fnm
    git-extras
    gnumake
    gping
    hugo
    jless
    jq
    nixpkgs-fmt
    poetry
    procs
    python3
    ruff
    ruff-lsp
    rustup
    spacer
    xh
    zsh-autopair
    zsh-completions
    zsh-fzf-tab
    zsh-powerlevel10k
    zsh-you-should-use
  ];

  home.file.".p10k.zsh".text = (builtins.readFile ./zsh/p10k.zsh);
  home.file."Develop/.envrc".text = (builtins.readFile ./envrc);
  home.sessionVariables = {
    # https://nixos.wiki/wiki/Packaging/Quirks_and_Caveats#ImportError:_libstdc.2B.2B.so.6:_cannot_open_shared_object_file:_No_such_file
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib/";
  };

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
  programs.git = {
    enable = true;
    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
    signing = {
      key = "2316687+henry40408@users.noreply.github.com";
      signByDefault = true;
    };
    userName = "Heng-Yi Wu";
    userEmail = "2316687+henry40408@users.noreply.github.com";
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
    initExtraFirst = ''
      source $HOME/.p10k.zsh
      ${builtins.readFile ./zsh/instant-prompt.zsh}
    '';
    initExtra = ''
      source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.zsh
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      ${builtins.readFile ./zsh/extra.zsh}
    '';
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
      ls = "lsd";
      ping = "gping";
      ps = "procs";
    };
    syntaxHighlighting = { enable = true; };
  };
  programs.ripgrep.enable = true;
  programs.zellij.enable = true;
  programs.zoxide.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    source = ./zellij/config.kdl;
  };
}
