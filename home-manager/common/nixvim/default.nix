{ pkgs, ... }:
{
  imports = [
    ./flash.nix
    ./lsp.nix
    ./mini.nix
    ./toggleterm.nix
  ];
  # python3.11-uvloop doesn't compile on macOS
  nixpkgs.config.packageOverrides = pkgs: {
    python311Packages = pkgs.python311Packages.override {
      overrides = self: super: {
        uvloop = super.uvloop.overrideAttrs (old: {
          disabledTestPaths = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ "tests/test_dns.py" ];
        });
      };
    };
  };
  programs.nixvim = {
    enable = true;
    package = pkgs.unstable.neovim-unwrapped;
    colorschemes.base16 = {
      enable = true;
      colorscheme = "irblack";
    };
    plugins.which-key.enable = true;
    extraPlugins = with pkgs.vimPlugins; [ vim-startuptime ];
  };
}
