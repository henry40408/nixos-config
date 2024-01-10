# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [ fd gnumake gping procs ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";

  home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.atuin.enable = true;
  programs.bat.enable = true;
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
  programs.lsd.enable = true;
  programs.neovim.enable = true;
  programs.ripgrep.enable = true;
  programs.tmux = {
    enable = true;
    extraConfig = (builtins.readFile ./tmux.extra.conf);
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.battery;
        extraConfig = ''
        set -g @batt_remain_short true
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
        set -g @continuum-restore 'on'
        '';
      }
      tmuxPlugins.dracula
      tmuxPlugins.fingers
      tmuxPlugins.pain-control
      {
        plugin = tmuxPlugins.prefix-highlight;
        extraConfig = ''
        set -g @prefix_highlight_bg 'lightgreen'
        set -g @prefix_highlight_empty_prompt '    '
        set -g @prefix_highlight_fg 'black'
        '';
      }
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
      {
        plugin = tmuxPlugins.yank;
        extraConfig = ''
        set -g @yank_selection_mouse 'clipboard'
        '';
      }
    ];
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    initExtra = (builtins.readFile ./zshrc.extra.zsh);
    initExtraFirst = (builtins.readFile ./zshrc.extraFirst.zsh);
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
      {
        name = "zsh-secrets";
        src = pkgs.fetchFromGitHub {
          owner = "chuwy";
          repo = "zsh-secrets";
          rev = "1d01c9d";
          sha256 = "sha256-gyHQxxjE36n+yxtT5xQp0gcD0eTgts3i0IMXGt0TCQI=";
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
  programs.zoxide.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "curses";
  };
  services.syncthing.enable = true;
}

# vim: ts=2 sw=2 expandtab:
