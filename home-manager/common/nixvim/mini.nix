{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      package = pkgs.unstable.vimPlugins.mini-nvim;
      modules = {
        ai = { };
        basics = { };
        bracketed = { };
        comment = { };
        cursorword = { };
        diff = { };
        extra = { };
        files = { };
        icons = { };
        indentscope = { };
        operators = { };
        notify = { };
        pairs = { };
        pick = { };
        statusline = { };
        surround = { };
        tabline = { };
        trailspace = { };
      };
    };
    keymaps = [
      {
        key = "<leader>fe";
        action = {
          __raw = ''function() require("mini.files").open() end'';
        };
        options.desc = "Explorer";
      }
      {
        key = "<leader>ff";
        action = "<cmd>Pick files<cr>";
        options.desc = "Open files";
      }
      {
        key = "<leader>fg";
        action = "<cmd>Pick git_files<cr>";
        options.desc = "Open files (git)";
      }
      {
        key = "<leader>sg";
        action = "<cmd>Pick grep_live<cr>";
        options.desc = "Live grep";
      }
    ];
  };
}
