{ pkgs, ... }:
{
  imports = [
    ./flash.nix
    ./lsp.nix
    ./mini.nix
    ./toggleterm.nix
    ./ui.nix
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
    colorschemes.base16 = {
      enable = true;
      colorscheme = "irblack";
    };
    defaultEditor = true;
    plugins.which-key = {
      enable = true;
      settings = {
        specs = [
          {
            __unkeyed = "<leader>c";
            name = "code";
          }
          {
            __unkeyed = "<leader>f";
            name = "file / find";

          }
          {
            __unkeyed = "<leader>s";
            name = "search";
          }
        ];
      };
    };
    extraPlugins = with pkgs.vimPlugins; [ vim-startuptime ];
  };
}
