{
  programs.nixvim = {
    plugins = {
      lualine.enable = true; # bottom status line

      comment.enable = true;
      cursorline.enable = true;
      dashboard.enable = true;
      friendly-snippets.enable = true;
      fidget.enable = true;
      gitsigns.enable = true;
      indent-blankline = {
        enable = true;
        settings = {
          exclude = {
            filetypes = [
              ""
              "TelescopePrompt"
              "TelescopeResults"
              "checkhealth"
              "help"
              "lspinfo"
              "packer"
              "yaml"
              "dashboard"
            ];
          };
        };
      };
      which-key.enable = true;
    };
  };
}
