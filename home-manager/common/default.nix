{ pkgs, lib, ... }:
{
  imports = [ ./nixvim ];

  home.packages =
    with pkgs;
    [
      fd
      fnm
      git-extras
      gnumake
      gping
      nixfmt-rfc-style
      procs
      spacer
      xh

      (writeShellScriptBin "clipboard-copy" (
        if stdenv.isDarwin then
          ''
            exec pbcopy "$@"
          ''
        else
          ''
            if [ -n "$WAYLAND_DISPLAY" ]; then
              exec ${wl-clipboard}/bin/wl-copy "$@"
            else
              exec ${xclip}/bin/xclip -selection clipboard "$@"
            fi
          ''
      ))
    ]
    ++ lib.optionals stdenv.isLinux [
      wl-clipboard
      xclip
    ];

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
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };
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
  programs.fish = {
    enable = true;
    plugins = [
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      { name = "done"; src = pkgs.fishPlugins.done.src; }
    ];
    shellAliases = {
      cat = "bat";
      ping = "gping";
      ps = "procs";
    };
    interactiveShellInit = ''
      # Cargo PATH
      fish_add_path $HOME/.cargo/bin

      # Source local config if it exists
      if test -f $HOME/.config/fish/local.fish
        source $HOME/.config/fish/local.fish
      end
    '';
  };
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      # Two-line prompt format
      format = builtins.concatStringsSep "" [
        "$os"
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$fill"
        "$status"
        "$cmd_duration"
        "$jobs"
        "$direnv"
        "$python"
        "$nodejs"
        "$golang"
        "$rust"
        "$kubernetes"
        "$terraform"
        "$aws"
        "$gcloud"
        "$username"
        "$hostname"
        "$nix_shell"
        "$time"
        "$line_break"
        "$character"
      ];

      fill = {
        symbol = "-";
        style = "bright-black";
      };

      os = {
        disabled = false;
        style = "bold";
      };

      directory = {
        truncation_length = 5;
        truncate_to_repo = false;
        style = "bold blue";
        read_only = " ro";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        truncation_length = 32;
        style = "green";
      };

      git_commit = {
        only_detached = true;
        tag_disabled = false;
        format = "[$hash$tag]($style) ";
        style = "green";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style))";
        style = "bold";
        ahead = "[>$count](green)";
        behind = "[<$count](green)";
        stashed = "[*$count](green)";
        staged = "[+$count](yellow)";
        modified = "[!$count](yellow)";
        untracked = "[?$count](blue)";
        conflicted = "[~$count](red)";
        deleted = "[-$count](red)";
      };

      git_state = {
        format = "[$state( $progress_current/$progress_total)]($style) ";
        style = "red";
      };

      status = {
        disabled = false;
        format = "[$symbol$signal_name]($style) ";
        symbol = "";
        map_symbol = true;
        pipestatus = true;
        style = "red";
      };

      cmd_duration = {
        min_time = 3000;
        format = "[$duration]($style) ";
        style = "fg:101";
        show_milliseconds = false;
      };

      jobs = {
        symbol = "bg:";
        style = "fg:70";
        number_threshold = 0;
        format = "[$symbol]($style) ";
      };

      direnv = {
        disabled = false;
        format = "[$symbol$loaded]($style) ";
        style = "fg:178";
        symbol = "direnv ";
      };

      python = {
        format = "[$virtualenv]($style) ";
        style = "fg:37";
        detect_files = [ ];
        detect_folders = [ ];
        detect_extensions = [ ];
      };

      nodejs = {
        format = "[$symbol($version)]($style) ";
        style = "fg:70";
        detect_files = [
          "package.json"
          ".node-version"
        ];
        detect_folders = [ "node_modules" ];
      };

      golang = {
        format = "[$symbol($version)]($style) ";
        style = "fg:37";
        detect_files = [ "go.mod" ];
      };

      rust = {
        format = "[$symbol($version)]($style) ";
        style = "fg:37";
        detect_files = [ "Cargo.toml" ];
      };

      kubernetes = {
        disabled = false;
        format = "[$symbol$context(/$namespace)]($style) ";
        style = "fg:134";
      };

      terraform = {
        format = "[$symbol$workspace]($style) ";
        style = "fg:38";
      };

      aws = {
        format = "[$symbol($profile)( $region)]($style) ";
        style = "fg:208";
      };

      gcloud = {
        format = "[$symbol($project)]($style) ";
        style = "fg:32";
      };

      username = {
        show_always = false;
        format = "[$user]($style)";
        style_root = "bold fg:178";
        style_user = "fg:180";
      };

      hostname = {
        ssh_only = true;
        format = "[@$hostname]($style) ";
        style = "fg:180";
      };

      nix_shell = {
        format = "[$symbol$state]($style) ";
        style = "fg:74";
        symbol = "nix ";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
        time_format = "%H:%M:%S";
        style = "fg:66";
      };

      character = {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vimcmd_symbol = "[<](bold green)";
      };
    };
  };
  programs.ripgrep.enable = true;
  programs.zellij.enable = true;
  programs.zoxide.enable = true;

  xdg.configFile."zellij/config.kdl" = {
    source = ./zellij/config.kdl;
  };
}
