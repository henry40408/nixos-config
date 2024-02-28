{ inputs
, lib
, config
, pkgs
, ...
}: {
  home.packages = with pkgs; [
    fd
    gcc
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
  ];

  home.file.".p10k.zsh".text = (builtins.readFile ./zsh/p10k.zsh);
  home.file."Develop/.envrc".text = (builtins.readFile ./envrc);
  home.sessionVariables = {
    # https://nixos.wiki/wiki/Packaging/Quirks_and_Caveats#ImportError:_libstdc.2B.2B.so.6:_cannot_open_shared_object_file:_No_such_file
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib/";
  };

  programs.atuin.enable = true;
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
    extraLuaConfig = (builtins.readFile ./neovim/extra.lua);
    extraPackages = with pkgs; [
      lua-language-server
      nixpkgs-fmt
      pyright
      rnix-lsp
      rust-analyzer
      stylua
      taplo
      tree-sitter
      unzip
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
    initExtra = (builtins.readFile ./zsh/extra.zsh);
    initExtraFirst = (builtins.readFile ./zsh/extra-first.zsh);
    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "command-not-found"
        "common-aliases"
        "direnv"
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
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "e85f76a";
          sha256 = "sha256-Qf9AZ2DjO9QUyEF7QG8JtlBHjwHfINOJkrMfu7pipns=";
        };
      }
      {
        name = "powerlevel10k";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.18.0";
          sha256 = "sha256-IiMYGefF+p4bUueO/9/mJ4mHMyJYiq+67GgNdGJ6Eew=";
        };
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "you-should-use";
        src = pkgs.fetchFromGitHub {
          owner = "MichaelAquilina";
          repo = "zsh-you-should-use";
          rev = "773ae5f";
          sha256 = "sha256-g4Fw0TwyajZnWQ8fvJvobyt98nRgg08uxK6yNEABo8Y=";
        };
      }
      {
        name = "zsh-autopair";
        src = pkgs.fetchFromGitHub {
          owner = "hlissner";
          repo = "zsh-autopair";
          rev = "9d003fc";
          sha256 = "sha256-hwZDbVo50kObLQxCa/wOZImjlH4ZaUI5W5eWs/2RnWg=";
        };
      }
      {
        name = "zsh-completions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-completions";
          rev = "20f3cd5";
          sha256 = "sha256-f+FXQIks4nUFabL04fgdgwOI6WTPq6mqZ/+Jvne2CRM=";
        };
      }
    ];
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
      tmuxPlugins.fingers
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

  xdg.configFile."nvim/lua" = {
    recursive = true;
    source = ./neovim/lua;
  };
}
