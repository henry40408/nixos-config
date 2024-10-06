{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;
      formattersByFt = {
        javascript = [ "prettierd" ];
        javascriptreact = [ "prettierd" ];
        typescript = [ "prettierd" ];
        typescriptreact = [ "prettierd" ];
        nix = [ "nixfmt" ];
      };
      formatOnSave = {
        timeoutMs = 500;
        lspFallback = true;
      };
    };
    plugins.lsp = {
      enable = true;
      servers = {
        eslint.enable = true;
        gopls.enable = true;
        nil-ls.enable = true; # nix language server
        rust-analyzer = {
          enable = true;
          # do not install cargo and rustc
          installCargo = false;
          installRustc = false;
        };
        volar = {
          enable = true;
          filetypes = [
            "typescript"
            "javascript"
            "javascriptreact"
            "typescriptreact"
            "vue"
          ];
          settings = {
            init_options = {
              vue = {
                hybridMode = true;
              };
            };
          };
          package = pkgs.unstable.vue-language-server;
        };
      };
    };
  };
}
