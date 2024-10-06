{
  programs.nixvim = {
    plugins.flash = {
      enable = true;
      jump = {
        autojump = true;
      };
      label = {
        uppercase = false;
        rainbow = {
          enabled = true;
        };
      };
      labels = "asdfghjklqwertyuiopzxcvbnm";
      search = {
        mode = "fuzzy";
      };
    };
    keymaps = [
      {
        key = "s";
        action = "<cmd>lua require('flash').jump()<cr>";
        mode = [
          "n"
          "x"
          "o"
        ];
        options = {
          desc = "Flash";
        };
      }
      {
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<cr>";
        mode = [
          "n"
          "x"
          "o"
        ];
        options = {
          desc = "Flash Treesitter";
        };
      }
      {
        key = "r";
        action = "<cmd>lua require('flash').remote()<cr>";
        mode = "o";
        options = {
          desc = "Remote Flash";
        };
      }
      {
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<cr>";
        mode = [
          "x"
          "o"
        ];
        options = {
          desc = "Treesitter Search";
        };
      }
    ];
  };
}
