{
  programs.nixvim = {
    plugins.mini = {
      enable = true;
      modules = {
        ai = { };
        bracketed = { };
        diff = { };
        pairs = { };
        pick = { };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };
    keymaps = [
      {
        key = "<leader>fb";
        action = "<cmd>Pick buffers<CR>";
        options = {
          desc = "Buffers";
          silent = true;
        };
      }
      {
        key = "<leader>ff";
        action = "<cmd>Pick files<CR>";
        options = {
          desc = "Find Files with Telescope";
          silent = true;
        };
      }
      {
        key = "<leader>fg";
        action = "<cmd>Pick grep_live<CR>";
        options = {
          desc = "Live Grep";
          silent = true;
        };
      }
    ];
  };
}
