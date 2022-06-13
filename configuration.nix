# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.configurationLimit = 10;

  networking.hostName = "nixos"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Asia/Taipei";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ rime ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  hardware.nvidia.powerManagement.enable = true;
  hardware.opengl.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
      # Cursor is too tiny on HiDPI displays
      # ref: https://github.com/NixOS/nixpkgs/issues/34603
      cursorTheme = {
        name = "Vanilla-DMZ";
        package = pkgs.vanilla-dmz;
        size = 64;
      };
    };
  };
  services.xserver.desktopManager.cinnamon.enable = true;

  # don't mess up with gpg-agent with SSH support
  services.gnome.gnome-keyring.enable = pkgs.lib.mkForce false;

  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.henry = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    gnumake
    nixos-option
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts-cjk
      noto-fonts-cjk-serif
      noto-fonts-emoji
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK TC" ];
        sansSerif = [ "Noto Sans CJK TC" ];
        monospace = [ "firacode nerd font" ];
      };
    };
  };

  # run "sudo nix-channel --update" or you will get "cannot open database" error
  # ref: https://discourse.nixos.org/t/command-not-found-unable-to-open-database/3807/8
  programs.command-not-found.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Setting `/sys/module/hid_apple/parameters/fnmode` to `0` at boot? 
  # ref: https://discourse.nixos.org/t/setting-sys-module-hid-apple-parameters-fnmode-to-0-at-boot/15570/3
  boot.extraModprobeConfig = ''
    options hid_apple fnmode=0
  '';
}

# vim: ts=2 sw=2:
