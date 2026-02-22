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
  programs.gh.enable = true;
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
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fetchFromGitHub {
          owner = "jhillyerd";
          repo = "plugin-git";
          rev = "09db2a91510ca8b6abc2ad23c6484f56b3cd72be";
          hash = "sha256-2+CX9ZGNkois7h3m30VG19Cf4ykRdoiPpEVxJMk75I4=";
        };
      }
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

      # Two-line prompt with ANSI colors (terminal theme decides)
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
        "$docker_context"
        "$container"
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
        symbol = "─";
        style = "bright-black";
      };

      os = {
        disabled = false;
        format = "[$symbol ](bold)";
      };

      directory = {
        truncation_length = 5;
        truncate_to_repo = false;
        format = "[$path$read_only ](bold blue)";
        read_only = " ro";
      };

      git_branch = {
        format = "[$symbol$branch(:$remote_branch)](green) ";
        truncation_length = 32;
      };

      git_commit = {
        only_detached = true;
        tag_disabled = false;
        format = "[$hash$tag](green) ";
      };

      git_state = {
        format = "[$state( $progress_current/$progress_total)](red) ";
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

      rust = {
        format = "[$symbol($version)](red) ";
        detect_files = [ "Cargo.toml" ];
      };

      nodejs = {
        format = "[$symbol($version)](green) ";
        detect_files = [
          "package.json"
          ".node-version"
        ];
        detect_folders = [ "node_modules" ];
      };

      golang = {
        format = "[$symbol($version)](cyan) ";
        detect_files = [ "go.mod" ];
      };

      python = {
        format = "[$virtualenv](blue) ";
        detect_files = [ ];
        detect_folders = [ ];
        detect_extensions = [ ];
      };

      docker_context = {
        format = "[$symbol$context](blue) ";
      };

      container = {
        format = "[$symbol$name](bright-red) ";
      };

      kubernetes = {
        disabled = false;
        format = "[$symbol$context(/$namespace)](purple) ";
      };

      terraform = {
        format = "[$symbol$workspace](blue) ";
      };

      aws = {
        format = "[$symbol($profile)( $region)](yellow) ";
      };

      gcloud = {
        format = "[$symbol($project)](blue) ";
      };

      status = {
        disabled = false;
        format = "[$symbol$signal_name](red) ";
        symbol = "";
        map_symbol = true;
        pipestatus = true;
      };

      cmd_duration = {
        min_time = 3000;
        format = "[$duration](yellow) ";
        show_milliseconds = false;
      };

      jobs = {
        symbol = "bg:";
        number_threshold = 0;
        format = "[$symbol](green) ";
      };

      direnv = {
        disabled = false;
        format = "[$symbol$loaded](yellow) ";
        symbol = "direnv ";
      };

      nix_shell = {
        format = "[$symbol$state](blue) ";
        symbol = "nix ";
      };

      username = {
        show_always = false;
        format = "[$user]($style)";
        style_root = "bold red";
        style_user = "bright-white";
      };

      hostname = {
        ssh_only = true;
        format = "[@$hostname](bright-white) ";
      };

      time = {
        disabled = false;
        format = "[$time](bright-black)";
        time_format = "%H:%M:%S";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
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
