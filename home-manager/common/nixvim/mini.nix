{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      package = pkgs.next.vimPlugins.mini-nvim;
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
        surround = {
          mappings = {
            add = "gsa"; # Add surrounding in Normal and Visual modes
            delete = "gsd"; # Delete surrounding
            find = "gsf"; # Find surrounding (to the right)
            find_left = "gsF"; # Find surrounding (to the left)
            highlight = "gsh"; # Highlight surrounding
            replace = "gsr"; # Replace surrounding
            update_n_lines = "gsn"; # Update `n_lines`
          };
        };
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
