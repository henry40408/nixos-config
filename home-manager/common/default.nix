{ pkgs
, ...
}: {
  home.packages = with pkgs; [
    fd
    git-extras
    gnumake
    gping
    hugo
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
  programs.bat.enable = true;
  programs.command-not-found.enable = true;
  programs.direnv.enable = true;
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
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      dockerfile-language-server-nodejs
      fish
      hadolint
      lua-language-server
      markdownlint-cli
      marksman
      nil
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages.typescript-language-server
      nodePackages.volar
      pyright
      rust-analyzer
      shfmt
      stylua
      taplo
      tree-sitter
      unzip
      vscode-langservers-extracted
      wget
    ];
    plugins = with pkgs.vimPlugins; [ lazy-nvim ];
    withNodeJs = true;
    withPython3 = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.password-store = {
    enable = true;
    settings = {
      PASSWORD_STORE_DIR = "$HOME/.password-store";
    };
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtraFirst = ''
      source $HOME/.p10k.zsh
      ${builtins.readFile ./zsh/instant-prompt.zsh}
    '';
    initExtra = ''
      source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
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
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    clock24 = true;
    historyLimit = 1000;
    keyMode = "vi";
    mouse = true;
    extraConfig = (builtins.readFile ./tmux/extra.conf);
    plugins = with pkgs; [
      tmuxPlugins.resurrect # before continuum
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
        '';
      }
      tmuxPlugins.tmux-thumbs
      tmuxPlugins.pain-control
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_selection_mouse 'clipboard'
        '';
      }
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-military-time true
          set -g @dracula-plugins "battery network weather time"
          set -g @dracula-show-fahrenheit false
          set -g @dracula-show-flags true
          set -g @dracula-show-location false
        '';
      }
    ];
    terminal = "screen-256color";
  };
  programs.zoxide.enable = true;

  xdg.configFile."nvim" = {
    recursive = true;
    source = ./neovim;
  };
}
