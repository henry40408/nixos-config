{ inputs, pkgs, ... }:
let
  username = "henry";
  homeDirectory = "/Users/${username}";
in
{
  imports = [ inputs.determinate.darwinModules.default ];

  # Nix itself is managed by Determinate, not nix-darwin. This module forces
  # nix.enable = false internally, so the two never fight over /etc/nix/nix.conf.
  determinateNix.enable = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;
  # https://github.com/nix-darwin/nix-darwin -- set once at install time, then never changed.
  system.stateVersion = 7;

  # fish is the interactive shell, so it needs to be a real login shell rather
  # than something launched out of zsh. programs.fish.enable is what puts fish
  # in environment.systemPackages and writes /etc/fish, where the nix profile
  # paths get exported; without it, a fish login shell would start with none of
  # them (the assertion in nix-darwin's users module says as much).
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  # uid/gid must match the account as it already exists: the activation script
  # skips a user whose uid differs, and unconditionally applies gid, so a wrong
  # value here would silently move the account to another group.
  users.knownUsers = [ username ];
  users.users.${username} = {
    uid = 501;
    gid = 20;
    home = homeDirectory;
    shell = pkgs.fish;
  };

  # `brew services` left an unmanaged plist in ~/Library/LaunchAgents. The
  # binary stays on Homebrew because nixpkgs lags, so this agent points into the
  # Homebrew tree on purpose -- if ollama ever leaves homebrew.brews below, this
  # block has to go with it, or KeepAlive will respawn against a missing binary.
  launchd.user.agents.ollama = {
    serviceConfig = {
      ProgramArguments = [
        "/opt/homebrew/opt/ollama/bin/ollama"
        "serve"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${homeDirectory}/Library/Logs/ollama.log";
      StandardErrorPath = "${homeDirectory}/Library/Logs/ollama.log";
      EnvironmentVariables = {
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };
  };

  # Replaces the Brewfile that home-manager used to symlink into $HOME: that
  # file was only a list, nothing ever applied it, so it drifted from reality.
  homebrew = {
    enable = true;
    onActivation = {
      # Aborts activation listing any Homebrew package installed on request but
      # not declared below, which is what stops this list drifting the way the
      # old Brewfile did. It never uninstalls anything -- that is "zap", and it
      # stays off deliberately, since a stray `brew install` should be a prompt
      # to decide, not something silently destroyed on the next switch.
      #
      # Orphaned dependencies are invisible here; `brew autoremove` owns those.
      cleanup = "check";
    };
    # Kept on Homebrew because nixpkgs either lags or lacks them: `container`
    # (1.1.0 vs 0.12.3), `ollama` (0.32.1 vs 0.31.1), `pi-coding-agent` (0.80.6
    # vs 0.80.3), `knot` (3.5.6 vs 3.5.5), and `dnspyre`, which is not packaged
    # in nixpkgs at all. Anything nixpkgs ships at parity lives in home-manager.
    brews = [
      "container"
      "dnspyre"
      "knot"
      "ollama"
      "pi-coding-agent"
    ];
    casks = [
      "block-goose"
      "codex"
      "firefox"
      "ghostty"
      "netnewswire"
      "raycast"
      "signal"
      "steam"
      "syncthing-app"
      "tailscale-app"
      "zed"
    ];
  };
}
